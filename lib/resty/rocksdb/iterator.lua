local ffi = require('ffi')
local rocksdb = ffi.load('rocksdb')

local include_rocksdb = require('include_cdef')
local ctype = require('ctype')
local base = require('base')

local ngx = ngx

local _M = {
    _VERSION = base._VERSION
}

local mt = { __index = _M }

function _M.new(db, readoptions)
    local iter = rocksdb.rocksdb_create_iterator(db, readoptions)

    return setmetatable({
        iter = iter,
    }, mt)
end

function _M.seek_to_first(self)
    rocksdb.rocksdb_iter_seek_to_first(self.iter)
end

function _M.seek_to_last(self)
    rocksdb.rocksdb_iter_seek_to_last(self.iter)
end

function _M.seek(self, key)
    rocksdb.rocksdb_iter_seek(self.iter, key, #key)
end

function _M.valid(self)
    if rocksdb.rocksdb_iter_valid(self.iter) == 1 then
        return true
    end

    return false
end

function _M.next(self)
    rocksdb.rocksdb_iter_next(self.iter)
end

function _M.prev(self)
    rocksdb.rocksdb_iter_prev(self.iter)
end

function _M.key(self)
    local keylen = ffi.new(ctype.size_array_t, 1)
    local key = rocksdb.rocksdb_iter_key(self.iter, keylen)

    return base.convert_cdata_str_to_string(key, keylen[0])
end

function _M.value(self)
    local vallen = ffi.new(ctype.size_array_t, 1)
    local value = rocksdb.rocksdb_iter_value(self.iter, vallen)

    return base.convert_cdata_str_to_string(value, vallen[0])
end

function _M.get_error(self)
    local err = ffi.new(ctype.str_array_t, 1)

    rocksdb.rocksdb_iter_get_error(self.iter, err)
    if err[0] ~= nil then
        return ffi.string(err[0])
    end

    return nil
end

function _M.destroy(self)
    rocksdb.rocksdb_iter_destroy(self.iter)
end

return _M
