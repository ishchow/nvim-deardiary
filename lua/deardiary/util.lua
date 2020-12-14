local date = require("deardiary.lib.date")

local M = {}

M.get_path_sep = function()
    if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
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

return M
