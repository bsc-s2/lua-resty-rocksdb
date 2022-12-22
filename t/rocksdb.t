use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/?.lua;$pwd/lib/?.lua;;";
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
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")

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
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, false)

        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/not_exist_dir_path")

        assert(err_code == "NotExistDbError")
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
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")

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

=== TEST 4: test delete db file
This test will delete file with api

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local write = require("resty.rocksdb.writer")
        local options = require("resty.rocksdb.options")
        local read = require("resty.rocksdb.reader")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local write_opt = options.rocksdb_writeoptions_create()

        local _, err_code, err_msg = write.put(db, write_opt, "key", "data")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.get(db, readoptions, "key")
        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result == "data", 'failed to get db: data expected, got ' .. tostring(result))

        local _, err_code, err_msg = rocksdb.delete(write_opt, "key")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to delete file: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local result, err_code, err_msg = read.get(db, readoptions, "key")
        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result == nil, 'failed to get db: nil expected, got ' .. tostring(result))

        ngx.exit(ngx.HTTP_OK)

    }
}

--- request
GET /t

--- no_error_log
[error]

=== TEST 5: test delete db file with invalid key
This test will delete file with invalid key

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local write = require("resty.rocksdb.writer")
        local options = require("resty.rocksdb.options")
        local read = require("resty.rocksdb.reader")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local write_opt = options.rocksdb_writeoptions_create()

        local _, err_code, err_msg = rocksdb.delete(write_opt, 1111)

        if err_code ~= nil then
            assert(err_code == 'DeleteError')
            assert(err_msg == 'key: number, err: the parameter key is invalid')
        end

        local _, err_code, err_msg = rocksdb.delete(nil, "key")
        if err_code ~= nil then
            assert(err_code == 'DeleteError')
            assert(err_msg == 'write_opt: nil, err: the parameter write_opt is nil')
        end

        ngx.exit(ngx.HTTP_OK)

    }
}

--- request
GET /t

--- no_error_log
[error]

=== TEST 6: test delete db file with not exist key
This test will delete file with not exist key

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local write = require("resty.rocksdb.writer")
        local options = require("resty.rocksdb.options")
        local read = require("resty.rocksdb.reader")

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local write_opt = options.rocksdb_writeoptions_create()

        local _, err_code, err_msg = rocksdb.delete(write_opt, 'not_exist_key')

        assert(err_code == nil)
        assert(err_msg == nil)

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]
