describe("test create_diary_entry()", function()
    local lfs = require("lfs")
    local pl = require"pl.import_into"()

    local last_cmd
    _G.vim = require("mock.vim")
    vim.cmd = function(cmd)
        last_cmd = cmd

        local echo_match = string.gmatch(cmd, "echo '(.*)'")()
        if echo_match ~= nil then
            return
        end

        local edit_match = string.gmatch(cmd, "e (.*)")()
        if edit_match ~= nil then
            pl.file.write(edit_match, "")
            return
        end
    end

    local deardiary = require("deardiary")
    local util = require("deardiary.util")
    local config = require("deardiary.config")
    local date = require("deardiary.lib.date")

    local curr_date = date("2020-12-31")
    local cwd = lfs.currentdir()
    local cwd_parts = util.split_path(cwd)
    local journal_parts = vim.list_extend(cwd_parts, {"tmp", "journal"})
    local journal_path = util.join_path(journal_parts)

    config.journals = {
        {
            path = journal_path,
            frequencies = {"daily"},
        },
    }

    it("no journal set", function()
        deardiary.create_diary_entry("nonexistent", 0, curr_date)
        assert.same(last_cmd, "echo 'No journal set'")
    end)

    it("invalid frequency name", function()
        deardiary.set_journal(config.journals[1])

        deardiary.create_diary_entry("nonexistent", 0, curr_date)
        assert.same(last_cmd, "echo 'Invalid frequency'")
    end)

    it("frequency not enabled for journal", function()
        deardiary.set_journal(config.journals[1])

        deardiary.create_diary_entry("weekly", 0, curr_date)
        assert.same(last_cmd, "echo 'Frequency not enabled for journal'")
    end)

    it("should succeed", function()
        local pathformat = config.frequencies.daily.pathformat

        deardiary.set_journal(config.journals[1])

        deardiary.create_diary_entry("daily", 0, curr_date)
        local today_path = journal_path
            .. util.get_path_sep()
            .. "daily"
            .. util.get_path_sep()
            .. curr_date:fmt(pathformat)
        assert.is_not_nil(lfs.attributes(today_path))

        deardiary.create_diary_entry("daily", 1, curr_date)
        local tomorrow_path = journal_path
            .. util.get_path_sep()
            .. "daily"
            .. util.get_path_sep()
            .. date("2021-01-01"):fmt(pathformat)
        assert.is_not_nil(lfs.attributes(tomorrow_path))

        deardiary.create_diary_entry("daily", -1, curr_date)
        local yesterday_path = journal_path
            .. util.get_path_sep()
            .. "daily"
            .. util.get_path_sep()
            .. date("2020-12-30"):fmt(pathformat)
        assert.is_not_nil(lfs.attributes(yesterday_path))

        pl.dir.rmtree(journal_path)
    end)
end)
