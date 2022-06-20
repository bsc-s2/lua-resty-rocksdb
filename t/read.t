use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/?.lua;$pwd/lib/resty/rocksdb/?.lua;;";
    lua_package_cpath "$pwd/?.so;$pwd/lib/resty/rocksdb/?.so;;";
};
master_on();
workers(1);
no_long_string();
run_tests();

__DATA__

=== TEST 1: read.get (key is string)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local writeoptions = options.rocksdb_writeoptions_create()
        local key, value = 'foo', 'bar'
        local _, err_code, err_msg = write.put(db, writeoptions, key, value)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.get(db, readoptions, key)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result == value, 'failed to get db:' .. value .. ' expected, got ' .. tostring(result))

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 2: read.get (key does not exist)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.get(db, readoptions, 'not_exist')

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result == nil, 'failed to get db: nil expected, got ' .. tostring(result))

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 3: read.get (invalid key)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local readoptions = options.rocksdb_readoptions_create()
        local tab = { 100, nil, true, 0, { false }, { foo = 'bar' }, { a = 1 } }

        for i = 1, #tab do
            local result, err_code, err_msg = read.get(db, readoptions, tab[i])
            assert(result == nil, 'failed to get db: nil expected, got ' .. tostring(result))
            assert(err_code == 'GetError', "failed to get db: err_code should be GetError, got " .. tostring(err_code))
        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 4: read.get (ascii characters)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local writeoptions = options.rocksdb_writeoptions_create()
        local readoptions = options.rocksdb_readoptions_create()

        local key, value = '', ''
        for i = 0, 255 do
            key = key .. string.char(i)
            value = value .. string.char(i)
        end

        local _, err_code, err_msg = write.put(db, writeoptions, key, value)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local result, err_code, err_msg = read.get(db, readoptions, key)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result == value, 'failed to get db: ' .. value .. ' expected, got ' .. tostring(result))

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 5: read.get (different size file)
--- http_config eval: $::HttpConfig
--- config
lua_need_request_body on;
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        local vallen = ngx.req.get_body_data()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local key = string.reverse("key" .. tostring(ngx.now()))
        local value = string.rep("a", tonumber(vallen) * 1024)
        local writeoptions = options.rocksdb_writeoptions_create()
        local _, err_code, err_msg = write.put(db, writeoptions, key, value)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.get(db, readoptions, key)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result == value, 'failed to get db: ' .. value .. ' expected, got ' .. tostring(result))

        ngx.exit(ngx.HTTP_OK)
    }
}
--- pipelined_requests eval
["POST /read\n" . "4", "POST /read\n" . "512"]

--- no_error_log
[error]


=== TEST 6: read.multi_get (keys is string)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local tab = { foo = 'bar', key = 'value' }
        local keys_list = {}

        for k, v in pairs(tab) do
            local writeoptions = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = write.put(db, writeoptions, k, v)

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
            table.insert(keys_list, k)
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.multi_get(db, readoptions, keys_list)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        for _, k in ipairs(keys_list) do
            assert(tab[k] == result[k],
                    'failed to get db: ' .. tab[k] .. ' expected, got ' .. tostring(result[k]))

        end

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 7: read.multi_get (some key is nil)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local tab = { foo = 'bar', key = 'value' }

        for k, v in pairs(tab) do
            local writeoptions = options.rocksdb_writeoptions_create()
            local _, err_code, err_msg = write.put(db, writeoptions, k, v)

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.multi_get(db, readoptions, { 'foo', nil, 'key' })

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        assert(result['foo'] == 'bar', 'failed to get db: bar expected, got ' .. tostring(result['foo']))
        assert(result['key'] == nil, 'failed to get db: nil expected, got ' .. tostring(result['key']))

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 8: read.multi_get (invalid keys)
--- http_config eval: $::HttpConfig
--- config
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local writeoptions = options.rocksdb_writeoptions_create()
        local _, err_code, err_msg = write.put(db, writeoptions, 'foo', 'bar')

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local readoptions = options.rocksdb_readoptions_create()
        local keys_list = { 100, nil, 'foo', true, '', { 0 }, foo = 'bar', 'key' }
        local result, err_code, err_msg = read.multi_get(db, readoptions, keys_list)

        assert(result == nil, 'failed to get db: nil expected, got ' .. tostring(result))
        assert(err_code == 'MultiGetError', "failed to get db: err_code should be MultiGetError, got " .. tostring(err_code))

        ngx.exit(ngx.HTTP_OK)
    }
}

--- request
GET /read

--- no_error_log
[error]


=== TEST 9: read.multi_get (different size file)
--- http_config eval: $::HttpConfig
--- config
lua_need_request_body on;
location = /read {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local write = require("write")
        local read = require("read")
        local opt = options.rocksdb_options_create()
        local vallen = ngx.req.get_body_data()
        options.rocksdb_options_set_create_if_missing(opt, true)
        local db, err_code, err_msg = rocksdb.open_db(opt, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to open db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        local value = string.rep("a", tonumber(vallen) * 1024)
        local writeoptions = options.rocksdb_writeoptions_create()
        local keys_list = {}

        for i = 1, 100 do
            local key = string.reverse("key" .. i .. tostring(ngx.now()))
            local _, err_code, err_msg = write.put(db, writeoptions, key, value)

            if err_code ~= nil then
                ngx.log(ngx.ERR, 'failed to put db: ' .. err_code .. ' ' .. err_msg)
                return
            end

            keys_list[i] = key
        end

        local readoptions = options.rocksdb_readoptions_create()
        local result, err_code, err_msg = read.multi_get(db, readoptions, keys_list)

        if err_code ~= nil then
            ngx.log(ngx.ERR, 'failed to get db: ' .. err_code .. ' ' .. err_msg)
            return
        end

        for _, k in ipairs(keys_list) do
            assert(result[k] == value, 'failed to get db: ' .. value .. ' expected, got ' .. tostring(result[k]))
        end

        ngx.exit(ngx.HTTP_OK)
    }
}
--- pipelined_requests eval
["POST /read\n" . "4", "POST /read\n" . "512"]

--- no_error_log
[error]
