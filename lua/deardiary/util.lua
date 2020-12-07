local date = require("deardiary.lib.date")

local M = {}

M.get_path_sep = function()
    if vim.fn.has("win32") or vim.fn.has("win64") then
        return "\\"
    else
        return "/"
    end
end

M.split_path = function(path)
    return vim.fn.split(path, M.get_path_sep())
end

M.join_path = function(arr)
    return vim.fn.join(arr, M.get_path_sep())
end

M.get_date = function(offset, transform, curr_date)
    assert(type(offset) == "number", "offset should be a number")
    assert(type(transform) == "function", "transform should be a function")
    curr_date = curr_date or date(false)
    return transform(curr_date:copy(), offset)
end

M.get_path = function(offset, transform, pathformat, curr_date)
    assert(type(offset) == "number", "offset should be a number")
    assert(type(pathformat) == "string", "pathformat should be a string")
    assert(type(transform) == "function", "transform should be a function")
    curr_date = curr_date or date(false)
    local new_date = M.get_date(offset, transform, curr_date)
    return new_date:fmt(pathformat)
end

return M
