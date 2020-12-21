local util = require("deardiary.util")
local config = require("deardiary.config")
local date = require("deardiary.lib.date")

local M = {}

M.get_date = function(offset, frequency, curr_date)
    assert(type(offset) == "number", "offset should be a number")
    assert(type(frequency) == "table", "frequency should be a table")
    curr_date = curr_date or date(false)
    return frequency.transform(curr_date:copy(), offset)
end

M.create_diary_entry = function(frequency_name, offset, curr_date)
    assert(type(frequency_name) == "string", "frequency_name should be a string")
    curr_date = curr_date or date(false)

    if next(config.journals) == nil then
        vim.cmd("echo 'No journals configured'")
        return
    end

    local journal = vim.g.deardiary_current_journal
    if journal == nil then
        vim.cmd("echo 'No journal set'")
        return
    end

    local config_freq = config.frequencies[frequency_name]
    if config_freq == nil then
        config_freq = {}
    end

    local journal_freq = vim.g.deardiary_current_journal.frequencies[frequency_name]
    if journal_freq == nil then
        journal_freq = {}
    end

    if next(config_freq) ~= nil
        and next(journal_freq) == nil
        and not vim.tbl_contains(journal.frequencies, frequency_name)
        then
        vim.cmd("echo 'Frequency not enabled for journal'")
        return
    end

    local frequency = vim.tbl_extend("force", config_freq, journal_freq)
    if next(frequency) == nil then
        vim.cmd("echo 'Invalid frequency'")
        return
    end

    local parts = util.split_path(journal.path)
    table.insert(parts, frequency_name)

    local entry_date = M.get_date(offset, frequency, curr_date:copy())
    local entry_path = frequency.formatpath(entry_date:copy())
    local entry_parts = util.split_path(entry_path)
    vim.list_extend(parts, entry_parts)

    local filename = table.remove(parts)
    vim.fn.mkdir(vim.fn.expand(util.join_path(parts)), "p")
    table.insert(parts, filename)

    local path = vim.fn.expand(util.join_path(parts))
    vim.cmd("e " .. path)
    if vim.fn.glob(path) == "" then
        local template_string = frequency.template(entry_date:copy())
        local lines = vim.fn.split(template_string, "\n")
        if next(lines) ~= nil then
            local buf_handle = vim.fn.bufnr(path)
            vim.api.nvim_buf_set_lines(buf_handle, 0, #lines, false, lines)
        end
    end
end

M.set_current_journal = function(journal_index)
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

M.select_journal = function()
    if next(config.journals) == nil then
        vim.cmd("echo 'No journals configured'")
        return
    end

    for idx, journal in pairs(config.journals) do
        if vim.deep_equal(journal, vim.g.deardiary_current_journal) then
            vim.cmd("echohl PmenuSel")
        else
            vim.cmd("echohl None")
        end
        local line = string.format("%2d    %s", idx, journal.path)
        vim.cmd(string.format("echo '%s'", line))
    end

    vim.cmd("echohl None")
    local input = vim.fn.input("Type in journal index and press <Enter> (empty cancels): ")
    if input == "" then
        return
    end

    local journal_index = tonumber(input)
    if journal_index == nil then
        vim.cmd("echo '\nInvalid journal index'")
        return
    else
        M.set_current_journal(journal_index)
        return
    end
end

return M
