use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/?.lua;$pwd/lib/?.lua;;";
    lua_package_cpath "$pwd/?.so;$pwd/lib/resty/rocksdb/?.so;;";
};

master_on();
workers(1);
no_long_string();
run_tests();

__DATA__

=== TEST 1: iterator seek to first
--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")
        local writer = require("resty.rocksdb.writer")
        local iterator = require("resty.rocksdb.iterator")
        local opts = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opts, true)
        local db, err_code, err_msg = rocksdb.open_db(opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local keys_list = {}

        for i = 0, 10, 1 do
            table.insert(keys_list, 'foo' .. i)
            table.insert(keys_list, 'too' .. i)
        end

        for _, k in ipairs(keys_list) do
            local write_opts = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = writer.put(db, write_opts, k, 'bar')

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
        end

        local read_opts = options.rocksdb_readoptions_create()
        local iter = iterator.new(db, read_opts)
        local result = {}
        iter:seek_to_first()

        while iter:valid() do
            local k = iter:key()
            table.insert(result, k)
            iter:next()
        end

        local err = iter:get_error()
        if err ~= nil then
            ngx.log(ngx.ERR, 'failed to iterator db: ' .. err_msg)
        end

        iter:destroy()

        table.sort(keys_list)

        assert(#result == #keys_list, 'failed to iterator db, the nums of data does not match')

        for i, k in ipairs(keys_list) do
            assert(result[i] == k, 'failed to iterator db: ' .. k .. ' expected, got ' .. tostring(result[i]))
        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]


=== TEST 2: iterator seek to last
--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")
        local writer = require("resty.rocksdb.writer")
        local iterator = require("resty.rocksdb.iterator")
        local opts = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opts, true)
        local db, err_code, err_msg = rocksdb.open_db(opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local keys_list = {}

        for i = 0, 10, 1 do
            table.insert(keys_list, 'foo' .. i)
            table.insert(keys_list, 'too' .. i)
        end

        for _, k in ipairs(keys_list) do
            local write_opts = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = writer.put(db, write_opts, k, 'bar')

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
        end

        local read_opts = options.rocksdb_readoptions_create()
        local iter = iterator.new(db, read_opts)
        local result = {}
        iter:seek_to_last()

        while iter:valid() do
            local k = iter:key()
            table.insert(result, k)
            iter:prev()
        end

        local err = iter:get_error()
        if err ~= nil then
            ngx.log(ngx.ERR, 'failed to iterator db: ' .. err_msg)
        end

        iter:destroy()

        table.sort(keys_list, function (x, y) return x > y end)

        assert(#result == #keys_list, 'failed to iterator db, the nums of data does not match')

        for i, k in ipairs(keys_list) do
            assert(result[i] == k, 'failed to iterator db: ' .. k .. ' expected, got ' .. tostring(result[i]))
        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]



=== TEST 3: iterator seek
--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")
        local writer = require("resty.rocksdb.writer")
        local iterator = require("resty.rocksdb.iterator")
        local opts = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opts, true)
        local db, err_code, err_msg = rocksdb.open_db(opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local keys_list = { 'foo1', 'too5', 'too1', 'foo9', 'too3', 'foo10', 'woo1' }

        for _, k in ipairs(keys_list) do
            local write_opts = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = writer.put(db, write_opts, k, 'bar')

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
        end

        local read_opts = options.rocksdb_readoptions_create()
        local iter = iterator.new(db, read_opts)
        local result = {}
        local expected = { 'too1', 'too3', 'too5', 'woo1' }
        iter:seek('too')

        while iter:valid() do
            local k = iter:key()
            table.insert(result, k)
            iter:next()
        end

        local err = iter:get_error()
        if err ~= nil then
            ngx.log(ngx.ERR, 'failed to iterator db: ' .. err_msg)
        end

        iter:destroy()

        assert(#result == #expected, 'failed to iterator db, the nums of data does not match')

        for i, k in ipairs(expected) do
            assert(result[i] == k, 'failed to iterator db: ' .. k .. ' expected, got ' .. tostring(result[i]))
        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]


=== TEST 4: iterator seek lower&upper bound
--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")
        local writer = require("resty.rocksdb.writer")
        local iterator = require("resty.rocksdb.iterator")
        local opts = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opts, true)
        local db, err_code, err_msg = rocksdb.open_db(opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local keys_list = {}

        for i = 0, 10, 1 do
            table.insert(keys_list, 'foo' .. i)
            table.insert(keys_list, 'too' .. i)
        end

        for _, k in ipairs(keys_list) do
            local write_opts = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = writer.put(db, write_opts, k, 'bar')

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
        end

        local read_opts = options.rocksdb_readoptions_create()
        options.rocksdb_readoptions_set_iterate_lower_bound(read_opts, 'foo4')
        options.rocksdb_readoptions_set_iterate_upper_bound(read_opts, 'foo8')

        local iter = iterator.new(db, read_opts)
        local result = {}
        local expected = { 'foo4', 'foo5', 'foo6',  'foo7' }
        iter:seek('foo')

        while iter:valid() do
            local k = iter:key()
            table.insert(result, k)
            iter:next()
        end

        local err = iter:get_error()
        if err ~= nil then
            ngx.log(ngx.ERR, 'failed to iterator db: ' .. err_msg)
        end

        iter:destroy()

        assert(#result == #expected, 'failed to iterator db, the nums of data does not match')

        for i, k in ipairs(expected) do
            assert(result[i] == k, 'failed to iterator db: ' .. k .. ' expected, got ' .. tostring(result[i]))
        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]


=== TEST 5: iterator seek wrong bound
--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("resty.rocksdb.rocksdb")
        local options = require("resty.rocksdb.options")
        local writer = require("resty.rocksdb.writer")
        local iterator = require("resty.rocksdb.iterator")
        local opts = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opts, true)
        local db, err_code, err_msg = rocksdb.open_db(opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local keys_list = {}

        for i = 0, 10, 1 do
            table.insert(keys_list, 'foo' .. i)
            table.insert(keys_list, 'too' .. i)
        end

        for _, k in ipairs(keys_list) do
            local write_opts = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = writer.put(db, write_opts, k, 'bar')

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
        end

        local read_opts = options.rocksdb_readoptions_create()
        options.rocksdb_readoptions_set_iterate_lower_bound(read_opts, 'foo8')
        options.rocksdb_readoptions_set_iterate_upper_bound(read_opts, 'foo4')

        local iter = iterator.new(db, read_opts)
        local result = {}
        iter:seek('foo')

        while iter:valid() do
            local k = iter:key()
            table.insert(result, k)
            iter:next()
        end

        local err = iter:get_error()
        if err ~= nil then
            ngx.log(ngx.ERR, 'failed to iterator db: ' .. err_msg)
        end

        iter:destroy()

        assert(#result == 0, 'failed to iterator db, the nums of data does not match')

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /t

--- no_error_log
[error]
