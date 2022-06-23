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

        local db, _, _ = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        local data = string.rep("a", tonumber(value) * 1024)

        local write_opt = options.rocksdb_writeoptions_create()
        local _, err_code, err_msg = write.put(db, write_opt, string.reverse("key" .. tostring(ngx.now())), data)
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end
    }
}

--- pipelined_requests eval
["POST /t\n" . "4", "POST /t\n" . "512"]
--- response_body eval
["put file success\n", "put file success\n"]

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

        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end
    }
}

--- request
GET /t
--- response_body
failed to put db: PutError db connect is nil

--- error_code: 200

=== TEST 3: test write invalid value type
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

        local db, _, _ = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        local _, err_code, err_msg = write.put(db, write_opt, "key" .. tostring(ngx.now()), 1)
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end

        local _, err_code, err_msg = write.put(db, write_opt, "key" .. tostring(ngx.now()), nil)
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end

        local _, err_code, err_msg = write.put(db, write_opt, "key" .. tostring(ngx.now()), "")
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end

        local _, err_code, err_msg = write.put(db, write_opt, nil, "value")
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end

        local _, err_code, err_msg = write.put(db, write_opt, "", "value")
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end

        local _, err_code, err_msg = write.put(db, nil, "test", "value")
        if err_code ~= nil then
            ngx.say('failed to put db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('put file success')
        end
    }
}

--- request
GET /t
--- response_body
failed to put db: PutError val: number, err: the parameter val is invalid
failed to put db: PutError val: nil, err: the parameter val is invalid
put file success
failed to put db: PutError key: nil, err: the parameter key is invalid
put file success
failed to put db: PutError write_opts is nil
--- error_code: 200
