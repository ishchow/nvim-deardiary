describe("test create_diary_entry()", function()
    local lfs = require("lfs")
    local pl = require"pl.import_into"()

    local last_cmd
    local buffers = {}

    _G.vim = require("mock.vim")

    vim.cmd = function(cmd)
        last_cmd = cmd

        local echo_match = string.gmatch(cmd, "echo '(.*)'")()
        if echo_match ~= nil then
            return
        end

        local edit_match = string.gmatch(cmd, "e (.*)")()
        if edit_match ~= nil then
            pl.file.write(edit_match(), "")
            return
        end

        local b_match = string.gmatch(cmd, "b([0-9]+)")()
        if b_match ~= nil then
            local buf_handle = tonumber(b_match)
            pl.file.write(buffers[buf_handle].name, vim.fn.join(buffers[buf_handle].lines, "\n"))
        end
    end

    vim.api = {
        nvim_create_buf = function(listed, scratch)
            table.insert(buffers, {
                name = "",
                lines = {}
            })
            return #buffers
        end,
        nvim_buf_set_name = function(buffer, name)
            buffers[buffer].name = name
        end,
        nvim_buf_set_lines = function(buffer, startidx, endidx, strict_indexing, replacement)
            for i = startidx, endidx do
                buffers[buffer].lines[i] = replacement[i]
            end
        end,
    }

    local deardiary = require("deardiary")
    local util = require("deardiary.util")
    local config = require("deardiary.config")
    local date = require("deardiary.lib.date")

    local curr_date = date("2020-12-31")
    local cwd = lfs.currentdir()
    local cwd_parts = util.split_path(cwd)
    local journal_parts = vim.list_extend(cwd_parts, {"tmp", "journal"})
    local journal_path = util.join_path(journal_parts)

    before_each(function()
        config.journals = {
            {
                path = journal_path,
                frequencies = {"daily", "monthly", "weekly", "yearly"},
            },
        }
    end)

    after_each(function()
        if pl.path.exists(journal_path) then
            pl.dir.rmtree(journal_path)
        end
    end)

    it("no journals configured", function()
        config.journals = {}
        deardiary.create_diary_entry("nonexistent", 0, curr_date)
        assert.same(last_cmd, "echo 'No journals configured'")
    end)

    it("no journal set", function()
        deardiary.create_diary_entry("nonexistent", 0, curr_date)
        assert.same(last_cmd, "echo 'No journal set'")
    end)

    it("invalid frequency name", function()
        deardiary.set_current_journal(1)

        deardiary.create_diary_entry("nonexistent", 0, curr_date)
        assert.same(last_cmd, "echo 'Invalid frequency'")
    end)

    it("frequency not enabled for journal", function()
        config.journals = {
            {
                path = journal_path,
                frequencies = {"daily", "monthly", "weekly"},
            },
        }
        deardiary.set_current_journal(1)

        deardiary.create_diary_entry("yearly", 0, curr_date)
        assert.same(last_cmd, "echo 'Frequency not enabled for journal'")
    end)

    it("should succeed", function()
        local pathformat = config.frequencies.weekly.pathformat

        deardiary.set_current_journal(1)

        deardiary.create_diary_entry("weekly", 0, curr_date)
        local this_week_path = journal_path
            .. util.get_path_sep()
            .. "weekly"
            .. util.get_path_sep()
            .. date("2020-12-28"):fmt(pathformat)
        assert.is_not_nil(lfs.attributes(this_week_path))

        local contents = pl.file.read(this_week_path)
        local expected_contents = [[# Week 52 of 2020: Monday, December 28, 2020 - Sunday, January 03, 2021


## Monday, December 28, 2020


## Tuesday, December 29, 2020


## Wednesday, December 30, 2020


## Thursday, December 31, 2020


## Friday, January 01, 2021


## Saturday, January 02, 2021


## Sunday, January 03, 2021


]]
        assert.same(contents, expected_contents)

    end)
end)
