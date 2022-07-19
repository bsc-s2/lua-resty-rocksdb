local ffi = require('ffi')
local rocksdb = ffi.load('rocksdb')

local include_rocksdb = require('include_cdef')
local ctype = require('ctype')


local _M = { _VERSION = '0.1.0'}

local function check_put_args(db, write_opts, key, val)
    if db == nil then
        return nil, 'PutError', "db connect is nil"
    end

    if write_opts == nil then
        return nil, 'PutError', "write_opts is nil"
    end

    if type(key) ~= 'string' then
        return nil, 'PutError', string.format(
                'key: %s, err: the parameter key is invalid', type(key))
    end

    if type(val) ~= 'string' then
        return nil, 'PutError', string.format(
                'val: %s, err: the parameter val is invalid', type(val))
    end
end

function _M.put(db, write_opts, key, val)
    local _, err_code, err_msg = check_put_args(db, write_opts, key, val)
    if err_code ~= nil then
        return nil , err_code, err_msg
    end

    local err = ffi.new(ctype.str_array_t, 1)

    rocksdb.rocksdb_put(db, write_opts, key, #key, val, #val, err)

    if err[0] ~= nil then
        return nil, 'PutError', string.format('key: %s, err: %s', key, ffi.string(err[0]))
    end

    return nil, nil, nil
end

function _M.put_cf(db, write_opts, column_family, key, val)
    local _, err_code, err_msg = check_put_args(db, write_opts, key, val)
    if err_code ~= nil then
        return nil , err_code, err_msg
    end

    local err = ffi.new(ctype.str_array_t, 1)

    rocksdb.rocksdb_put_cf(db, write_opts, column_family, key, #key, val, #val, err)

    if err[0] ~= nil then
        return nil, 'PutError', string.format('key: %s, err: %s', key, ffi.string(err[0]))
    end

    return nil, nil, nil
end

return _M
