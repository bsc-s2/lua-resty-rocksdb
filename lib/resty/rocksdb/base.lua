local ffi = require "ffi"

local _M = {
    version = '1.0'
}


function _M.convert_cdata_str_to_string(cdata_str, cdata_size)
    cdata_size = tonumber(cdata_size)

    if cdata_str == nil or cdata_size == nil then
        return nil
    else
        return ffi.string(cdata_str, cdata_size)
    end

end


function _M.free(cdata)
    ffi.C.free(cdata)
end


return _M
