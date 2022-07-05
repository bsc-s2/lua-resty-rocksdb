use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/?.lua;$pwd/lib/resty/rocksdb/?.lua;;";
    lua_package_cpath "$pwd/?.so;$pwd/lib/resty/rocksdb/?.so;;";
};

no_long_string();
run_tests();

__DATA__

=== TEST 1: test open db
This test will open new db

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(db ~= nil, "open db returned address is empty")
        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]

--- error_code: 200

=== TEST 2: test open db
This test will open new db

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, false)

        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/not_exist_dir_path")

        assert(err_code == "OpenDbError")
        assert(err_msg == "Invalid argument: ./t/servroot/fastcgi_temp/not_exist_dir_path: does not exist (create_if_missing is false)")
        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]

=== TEST 3: test open db
This test will open new db

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local opt = options.rocksdb_options_create()

        local db, err_code, err_msg = rocksdb.open_with_ttl(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")
        assert(err_code == 'OpenDbError')
        assert(err_msg == "The DB type: TTL to be opened conflicts with an existing type:NORMAL")
        assert(db == nil, "open db returned address is not empty")

        local db, err_code, err_msg = rocksdb.open_for_read_only(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        assert(err_code == 'OpenDbError')
        assert(err_msg == "The DB type: READONLY to be opened conflicts with an existing type:NORMAL")
        assert(db == nil, "open db returned address is not empty")

        local db, err_code, err_msg = rocksdb.open_as_secondary(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        assert(err_code == 'OpenDbError')
        assert(err_msg == "The DB type: SECONDARY to be opened conflicts with an existing type:NORMAL")
        assert(db == nil, "open db returned address is not empty")

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]

