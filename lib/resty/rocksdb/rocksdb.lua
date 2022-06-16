local ffi = require('ffi')
local rocksdb = ffi.load('rocksdb')

local include_rocksdb = require('include_cdef')
local ctype = require('ctype')

local _M = { _VERSION = '1.0' }

function _M.ret_db_and_parse_err(db, err)
    if err[0] ~= nil then
        return nil, 'CreateDbErr', ffi.string(err[0])
    end
    return db, nil, nil
end

function _M.open_db(opts, db_path)
    local err = ffi.new(ctype.char_t_p_p)

    local db = rocksdb.rocksdb_open(opts, db_path, err)
    return _M.ret_db_and_parse_err(db, err)
end

function _M.rocksdb_open_with_ttl(opts, db_path, ttl)
    local err = ffi.new(ctype.char_t_p_p)

    local db = rocksdb.rocksdb_open_with_ttl(opts, db_path, ffi.new(ctype.int_t, ttl), err)

    return _M.ret_db_and_parse_err(db, err)
end

function _M.rocksdb_open_for_read_only(opts, db_path, error_if_log_file_exist)
    local err = ffi.new(ctype.char_t_p_p)

    local db = rocksdb.rocksdb_open_for_read_only(opts, db_path, error_if_log_file_exist, err)

    return _M.ret_db_and_parse_err(db, err)
end

function _M.rocksdb_open_as_secondary(opts, db_path, secondary_path)
    local err = ffi.new(ctype.char_t_p_p)

    local db = rocksdb.rocksdb_open_as_secondary(opts, db_path, secondary_path, err)

    return _M.ret_db_and_parse_err(db, err)
end

return _M
