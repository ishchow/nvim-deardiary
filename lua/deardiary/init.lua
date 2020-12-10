local util = require("deardiary.util")
local config = require("deardiary.config")
local date = require("deardiary.lib.date")

local M = {}

M.create_diary_entry = function(frequency, offset, curr_date)
    assert(type(frequency) == "table", "frequency should be a table")
    curr_date = curr_date or date(false)

    local diary_entry_path = util.get_path(offset, frequency.transform,
        frequency.pathformat, curr_date)

    local parts = vim.fn.split(diary_entry_path, util.get_path_sep())
    table.remove(parts, #parts)

    if #parts then
        vim.fn.mkdir(diary_entry_path, "p")
    end

    -- vim.cmd('e ')
end

M.set_journal = function(journal)
    if next(config.journals) ~= nil then
        vim.g.deardiary_current_journal = journal
    end
end

return M
