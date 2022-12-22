local ffi = require('ffi')
local rocksdb = ffi.load('rocksdb')

local include_rocksdb = require('resty.rocksdb.include_cdef')
local ctype = require('resty.rocksdb.ctype')
local base = require('resty.rocksdb.base')
local fsutil = require('acid.fsutil')

local _M = {
    version = base.version
}


local db_types = {
    ['normal'] = "NORMAL",
    ['ttl'] = "TTL",
    ['read_only'] = "READONLY",
    ['secondary'] = "SECONDARY",
}


local db = nil
local db_type = nil
local current_name = 'CURRENT'


local function check_open_db_type(type)
    if db_type ~= nil and db_type ~= type then
        return nil , 'OpenDbError', "The DB type: ".. type ..
                " to be opened conflicts with an existing type:" .. db_type
    end

    return nil
end


local function gen_db_open_err(db_path, err_msg)
    local current_path = db_path .. '/' .. current_name
    local err_code = 'NotExistDbError'

    if fsutil.is_file(current_path) then
        err_code = 'OpenDbError'
    end

    return nil, err_code, ffi.string(err_msg)
end


function _M.open_db(opts, db_path)
    local _, err_code, err_msg = check_open_db_type(db_types['normal'])
    if err_code ~= nil then
        return nil, err_code, err_msg
    end

    if db ~= nil then
        return db, nil, nil
    end

    local err = ffi.new(ctype.str_array_t, 1)
    db = rocksdb.rocksdb_open(opts, db_path, err)

    if err[0] ~= nil then
        return gen_db_open_err(db_path, err[0])
    end

    db_type = db_types['normal']

    return db
end


function _M.close_db()
    if db == nil then
        return nil, 'CloseDbError', "db is already closed"
    end

    rocksdb.rocksdb_close(db)

    db = nil
    db_types = nil

    return
end


function _M.destroy_db(opts, db_name)
    local err = ffi.new(ctype.str_array_t, 1)
    rocksdb.rocksdb_destroy_db(opts, db_name, err)
    if err[0] ~= nil then
        return nil, 'DestroyDbError', ffi.string(err[0])
    end

    return nil
end


function _M.open_with_ttl(opts, db_path, ttl)
    local _, err_code, err_msg = check_open_db_type(db_types['ttl'])
    if err_code ~= nil then
        return nil, err_code, err_msg
    end

    if db ~= nil then
        return db, nil, nil
    end

    local err = ffi.new(ctype.str_array_t, 1)

    db = rocksdb.rocksdb_open_with_ttl(opts, db_path, ffi.new(ctype.int_t, ttl), err)

    if err[0] ~= nil then
        return gen_db_open_err(db_path, err[0])
    end

    db_type = db_types['ttl']

    return db
end


function _M.open_for_read_only(opts, db_path, error_if_log_file_exist)
    local _, err_code, err_msg = check_open_db_type(db_types['read_only'])
    if err_code ~= nil then
        return nil, err_code, err_msg
    end

    if db ~= nil then
        return db, nil, nil
    end


    local err = ffi.new(ctype.str_array_t, 1)

    db = rocksdb.rocksdb_open_for_read_only(opts, db_path, error_if_log_file_exist, err)

    if err[0] ~= nil then
        return gen_db_open_err(db_path, err[0])
    end

    db_type = db_types['read_only']

    return db
end


function _M.open_as_secondary(opts, db_path, secondary_path)
    local _, err_code, err_msg = check_open_db_type(db_types['secondary'])
    if err_code ~= nil then
        return nil, err_code, err_msg
    end

    if db ~= nil then
        return db, nil, nil
    end

    local err = ffi.new(ctype.str_array_t, 1)

    db = rocksdb.rocksdb_open_as_secondary(opts, db_path, secondary_path, err)

    if err[0] ~= nil then
        return gen_db_open_err(db_path, err[0])
    end

    db_type = db_types['secondary']

    return db
end


function _M.delete(write_opts, key)

    if type(key) ~= 'string' then
        return nil, 'DeleteError', string.format(
                'key: %s, err: the parameter key is invalid', type(key))
    end

    if write_opts == nil then
        return nil, 'DeleteError', string.format(
                'write_opt: %s, err: the parameter write_opt is nil', write_opts)
    end

    local err = ffi.new(ctype.str_array_t, 1)

    rocksdb.rocksdb_delete(db, write_opts, key, #key, err)

    if err[0] ~= nil then
        return nil, 'DeleteError', ffi.string(err[0])
    end

    return nil
end


return _M
