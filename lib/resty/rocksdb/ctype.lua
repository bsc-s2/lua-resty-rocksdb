local ffi = require('ffi')

local _M = {
    int_t = ffi.typeof("int"),
    int_t_p = ffi.typeof("int[1]"),
    uint64_t = ffi.typeof("uint64_t"),
    uint32_t = ffi.typeof("uint32_t"),
    size_t = ffi.typeof("size_t"),
    char_t_p_p = ffi.typeof("char*[1]")
}

return _M
