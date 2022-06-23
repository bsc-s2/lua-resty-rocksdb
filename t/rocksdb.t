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
        options.rocksdb_options_set_create_if_missing(opt, false)

        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/not_exist_dir_path")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end
    }
}

--- request
GET /t

--- response_body
failed to open db: OpenDbError Invalid argument: ./t/servroot/fastcgi_temp/not_exist_dir_path: does not exist (create_if_missing is false)
open db success

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
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end

        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, false)

        local db, err_code, err_msg = rocksdb.open_with_ttl(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end

        local db, err_code, err_msg = rocksdb.open_for_read_only(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end

        local db, err_code, err_msg = rocksdb.open_as_secondary(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end
    }
}

--- request
GET /t

--- response_body
open db success
failed to open db: OpenDbError The DB type: TTL to be opened conflicts with an existing type:NORMAL
failed to open db: OpenDbError The DB type: READONLY to be opened conflicts with an existing type:NORMAL
failed to open db: OpenDbError The DB type: SECONDARY to be opened conflicts with an existing type:NORMAL

--- error_code: 200

