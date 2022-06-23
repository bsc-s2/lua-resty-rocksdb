local ffi = require('ffi')

local _M = {
    int_t = ffi.typeof("int"),
    int_p_t = ffi.typeof("int[1]"),
    uint64_t = ffi.typeof("uint64_t"),
    uint32_t = ffi.typeof("uint32_t"),
    size_t = ffi.typeof("size_t"),
    str_array_t = ffi.typeof("char*[?]")
}

return _M
