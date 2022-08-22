local ffi = require('ffi')
local rocksdb = ffi.load('rocksdb')

local include_rocksdb = require('include_cdef')
local ctype = require('ctype')
local base = require('base')

local ngx = ngx

local _M = {
    version = base.version
}


function _M.get(db, read_opts, key)
    if type(key) ~= 'string' then
        return nil, 'GetError', string.format(
                'key: %s, err: the parameter key is invalid', tostring(key))
    end

    local err = ffi.new(ctype.str_array_t, 1)
    local vallen = ffi.new(ctype.size_array_t, 1)

    local buf = rocksdb.rocksdb_get(db, read_opts, key, #key, vallen, err)

    if err[0] ~= nil then
        local err_msg = string.format('key: %s, err: %s', key, ffi.string(err[0]))
        base.free(err[0])
        return nil, 'GetError', err_msg
    end

    local value = base.convert_cdata_str_to_string(buf, vallen[0])
    base.free(buf)
    return value
end


function _M.multi_get(db, read_opts, keys_list, partial_success)
    partial_success = partial_success or false
    local keys_list_sizes = {}

    for i, k in ipairs(keys_list) do
        if type(k) ~= 'string' then
            return nil, 'MultiGetError', string.format(
                    'key: %s, err: the parameter key is invalid', tostring(k))
        else
            keys_list_sizes[i] = #k
        end
    end

    local num_keys = #keys_list_sizes

    local cdata_keys_list = ffi.new(ctype.c_str_array_t, num_keys, keys_list)
    local cdata_keys_list_sizes = ffi.new(ctype.size_array_t, num_keys, keys_list_sizes)

    local cdata_values_list = ffi.new(ctype.str_array_t, num_keys)
    local cdata_values_list_sizes = ffi.new(ctype.size_array_t, num_keys)
    local err = ffi.new(ctype.str_array_t, num_keys)

    rocksdb.rocksdb_multi_get(db, read_opts, num_keys, cdata_keys_list,
            cdata_keys_list_sizes, cdata_values_list, cdata_values_list_sizes, err)

    local ret = {}

    for i = 0, num_keys - 1 do
        local k = keys_list[i + 1]

        if err[i] ~= nil then
            local err_msg = string.format('key: %s, err: %s', k, ffi.string(err[i]))
            base.free(err[i])
            ngx.log(ngx.WARN, err_msg)
            if not partial_success then
                return nil, 'MultiGetError', err_msg
            end
        else
            ret[k] = base.convert_cdata_str_to_string(cdata_values_list[i], cdata_values_list_sizes[i])
            base.free(cdata_values_list[i])
        end
    end

    return ret
end


return _M
