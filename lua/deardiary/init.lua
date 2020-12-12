local util = require("deardiary.util")
local config = require("deardiary.config")
local date = require("deardiary.lib.date")

local M = {}

M.create_diary_entry = function(frequency_name, offset, curr_date)
    assert(type(frequency_name) == "string", "frequency_name should be a string")
    curr_date = curr_date or date(false)

    local journal = vim.g.deardiary_current_journal
    if journal == nil then
        vim.cmd("echo 'No journal set'")
        return
    end

    local frequency = config.frequencies[frequency_name]
    if frequency == nil then
        vim.cmd("echo 'Invalid frequency'")
        return
    end

    if not vim.tbl_contains(journal.frequencies, frequency_name) then
        vim.cmd("echo 'Frequency not enabled for journal'")
        return
    end

    local parts = util.split_path(journal.path)
    table.insert(parts, frequency_name)

    local entry_path = util.get_path(offset, frequency.transform,
        frequency.pathformat, curr_date)
    local entry_parts = util.split_path(entry_path)
    vim.list_extend(parts, entry_parts)

    local filename = table.remove(parts)
    vim.fn.mkdir(util.join_path(parts), "p")
    table.insert(parts, filename)

    vim.cmd("e " .. util.join_path(parts))
end

M.set_journal = function(journal_index)
    assert(type(journal_index) == "number", "journal_index should be a number")
    if next(config.journals) == nil then
        vim.cmd("echo 'No journals configured'")
        return
    end

    local journal = config.journals[journal_index]
    if journal == nil then
        vim.cmd("echo 'Invalid journal index'")
        return
    end
    vim.g.deardiary_current_journal = journal
end

return M
