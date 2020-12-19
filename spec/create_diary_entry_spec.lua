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
        config.journals = {
            {
                path = journal_path,
                frequencies = {"daily", "monthly", "weekly", "yearly"},
            },
        }

        deardiary.create_diary_entry("nonexistent", 0, curr_date)
        assert.same(last_cmd, "echo 'No journal set'")
    end)

    it("invalid frequency name", function()
        config.journals = {
            {
                path = journal_path,
                frequencies = {"daily", "monthly", "weekly"},
            },
        }

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

    describe("should succeed", function()
        config.journals = {
            {
                path = journal_path,
                frequencies = {"daily", "monthly", "weekly", "yearly"},
            },
        }

        deardiary.set_current_journal(1)

        it("daily", function()
            local formatpath = config.frequencies.daily.formatpath
            deardiary.create_diary_entry("daily", 0, curr_date)
            local today_path = journal_path
                .. util.get_path_sep()
                .. "daily"
                .. util.get_path_sep()
                .. formatpath(date("2020-12-31"))
            assert.is_not_nil(lfs.attributes(today_path))

            local contents = pl.file.read(today_path)
            local expected_contents = "# Thursday, December 31, 2020"
            assert.same(contents, expected_contents)
        end)

        it("monthly", function()
            local formatpath = config.frequencies.monthly.formatpath
            deardiary.create_diary_entry("monthly", 0, curr_date)
            local this_month_path = journal_path
                .. util.get_path_sep()
                .. "monthly"
                .. util.get_path_sep()
                .. formatpath(date("2020-12-01"))
            assert.is_not_nil(lfs.attributes(this_month_path))

            local contents = pl.file.read(this_month_path)
            local expected_contents = "# December, 2020"
            assert.same(contents, expected_contents)
        end)

        it("yearly", function()
            local formatpath = config.frequencies.yearly.formatpath
            deardiary.create_diary_entry("yearly", 0, curr_date)
            local this_year_path = journal_path
                .. util.get_path_sep()
                .. "yearly"
                .. util.get_path_sep()
                .. formatpath(date("2020-01-01"))
            assert.is_not_nil(lfs.attributes(this_year_path))

            local contents = pl.file.read(this_year_path)
            local expected_contents = "# 2020"
            assert.same(contents, expected_contents)
        end)

        it("weekly", function()
            local formatpath = config.frequencies.weekly.formatpath
            deardiary.create_diary_entry("weekly", 0, curr_date)
            local this_week_path = journal_path
                .. util.get_path_sep()
                .. "weekly"
                .. util.get_path_sep()
                .. formatpath(date("2020-12-28"))
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

    describe("should succeed with custom config", function()
        config.frequencies.daily.template = function(entry_date)
            return entry_date:fmt("# %Y-%m-%d")
        end

        config.frequencies.daily.formatpath = function(entry_date)
            return entry_date:fmt("%Y-%m-%d.md")
        end

        config.journals = {
            {
                path = journal_path,
                frequencies = {
                    "daily",
                    monthly = {
                        template = function(entry_date)
                            return entry_date:fmt("# %b of %Y")
                        end,
                        formatpath = function(entry_date)
                            return entry_date:fmt("%Y-%m.md")
                        end,
                    },
                    biweekly = {
                        transform = function(cdate, offset)
                            return config.frequencies.weekly.transform(cdate, 2 * offset)
                        end,
                        template = function(entry_date)
                            local bi_week_number = entry_date:getweeknumber(2) / 2
                            local year = entry_date:getyear()
                            return string.format("# Bi-week %d of Year %d", bi_week_number, year)
                        end,
                        formatpath = function(entry_date)
                            local bi_week_number = entry_date:getweeknumber(2) / 2
                            local year = entry_date:getyear()
                            return string.format("%d-%d", year, bi_week_number) .. ".md"
                        end,
                    },
                },
            },
        }

        deardiary.set_current_journal(1)

        it("daily", function()
            local formatpath = config.frequencies.daily.formatpath
            deardiary.create_diary_entry("daily", 0, curr_date)
            local today_path = journal_path
                .. util.get_path_sep()
                .. "daily"
                .. util.get_path_sep()
                .. formatpath(date("2020-12-31"))
            assert.is_not_nil(lfs.attributes(today_path))

            local contents = pl.file.read(today_path)
            local expected_contents = "# 2020-12-31"
            assert.same(contents, expected_contents)
        end)

        it("monthly", function()
            local formatpath = config.journals[1].frequencies.monthly.formatpath
            deardiary.create_diary_entry("monthly", 0, curr_date)
            local this_month_path = journal_path
                .. util.get_path_sep()
                .. "monthly"
                .. util.get_path_sep()
                .. formatpath(date("2020-12-01"))
            assert.is_not_nil(lfs.attributes(this_month_path))

            local contents = pl.file.read(this_month_path)
            local expected_contents = "# Dec of 2020"
            assert.same(contents, expected_contents)
        end)

        it("biweekly", function()
            local formatpath = config.journals[1].frequencies.biweekly.formatpath
            deardiary.create_diary_entry("biweekly", 1, curr_date)
            local this_biweek_path = journal_path
                .. util.get_path_sep()
                .. "biweekly"
                .. util.get_path_sep()
                .. formatpath(date("2021-01-11"))
            assert.is_not_nil(lfs.attributes(this_biweek_path))

            local contents = pl.file.read(this_biweek_path)
            local expected_contents = "# Bi-week 1 of Year 2021"
            assert.same(contents, expected_contents)
        end)
    end)
end)
