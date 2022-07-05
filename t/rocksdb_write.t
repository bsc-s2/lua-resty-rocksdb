use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/?.lua;$pwd/lib/resty/rocksdb/?.lua;;";
    lua_package_cpath "$pwd/?.so;$pwd/lib/resty/rocksdb/?.so;;";
};

no_long_string();
master_on();
workers(1);
run_tests();

__DATA__

=== TEST 1: test write same key with different size file
test write same key with different size file

--- http_config eval: $::HttpConfig
--- config
lua_need_request_body on;

location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local opt = options.rocksdb_options_create()
        local value = ngx.req.get_body_data()
        options.rocksdb_options_set_create_if_missing(opt, true)

        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log('failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(db ~= nil, "open db returned address is empty")
        local data = string.rep("a", tonumber(value) * 1024)

        local write_opt = options.rocksdb_writeoptions_create()
        local _, err_code, err_msg = write.put(db, write_opt, string.reverse("key" .. tostring(ngx.now())), data)
        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- pipelined_requests eval
["POST /t\n" . "4", "POST /t\n" . "512"]
--- no_error_log
[error]

=== TEST 2: test put file with null db connection
test put file with null db connection

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local write_opt = options.rocksdb_writeoptions_create()
        local _, err_code, err_msg = write.put(nil, write_opt, "key" .. tostring(ngx.now()), "2222")

        assert(err_code == 'PutError')
        assert(err_msg == 'db connect is nil')

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t
--- no_error_log
[error]

=== TEST 3: test write invalid value and key type
test write invalid value type

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local opt = options.rocksdb_options_create()
        local write = require("write")
        options.rocksdb_options_set_create_if_missing(opt, true)
        local write_opt = options.rocksdb_writeoptions_create()

        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")
        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local list = { 100, nil }

        for _, v in pairs(list) do
            local _, err_code, err_msg = write.put(db, write_opt, "key" .. tostring(ngx.now()), v)
            assert(err_code == 'PutError')
            assert(err_msg == 'val: ' .. type(v) .. ', err: the parameter val is invalid')
        end

        for _, v in pairs(list) do
            local _, err_code, err_msg = write.put(db, write_opt, v, "test")
            assert(err_code == 'PutError')
            assert(err_msg == 'key: ' .. type(v) .. ', err: the parameter key is invalid')
        end

        local _, err_code, err_msg = write.put(db, nil, "test", "value")

        assert(err_code == 'PutError')
        assert(err_msg == 'write_opts is nil')

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t
--- no_error_log
[error]
