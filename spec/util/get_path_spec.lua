describe("test util.get_path()", function()
    package.path = package.path .. ";spec/vim.lua"
    _G.vim = require("vim")

    local util = require("deardiary.util")
    local config = require("deardiary.config")
    local date = require("deardiary.lib.date")

    local curr_date = date("2020-12-31");

    describe("daily frequency", function()
        local transform = config.frequencies.daily.transform
        local pathformat = config.frequencies.daily.pathformat

        it("positive offset", function()
            assert.same(util.get_path(1, transform, pathformat, curr_date), 
                "2021/01/01.md")
            assert.same(util.get_path(2, transform, pathformat, curr_date), 
                "2021/01/02.md")
        end)

        it("zero offset", function()
            assert.same(util.get_path(0, transform, pathformat, curr_date), 
                "2020/12/31.md")
        end)

        it("negative offset", function()
            assert.same(util.get_path(-1, transform, pathformat, curr_date), 
                "2020/12/30.md")
            assert.same(util.get_path(-2, transform, pathformat, curr_date), 
                "2020/12/29.md")
        end)
    end)

    describe("weekly frequency", function()
        local transform = config.frequencies.weekly.transform
        local pathformat = config.frequencies.weekly.pathformat

        it("positive offset", function()
            assert.same(util.get_path(1, transform, pathformat, curr_date), 
                "2021/01.md")
            assert.same(util.get_path(2, transform, pathformat, curr_date), 
                "2021/02.md")
        end)

        it("zero offset", function()
            assert.same(util.get_path(0, transform, pathformat, curr_date), 
                "2020/52.md")
        end)

        it("negative offset", function()
            assert.same(util.get_path(-1, transform, pathformat, curr_date), 
                "2020/51.md")
            assert.same(util.get_path(-2, transform, pathformat, curr_date), 
                "2020/50.md")
        end)
    end)

    describe("monthly frequency", function()
        local transform = config.frequencies.monthly.transform
        local pathformat = config.frequencies.monthly.pathformat

        it("positive offset", function()
            assert.same(util.get_path(1, transform, pathformat, curr_date), 
                "2021/01.md")
            assert.same(util.get_path(2, transform, pathformat, curr_date), 
                "2021/02.md")
        end)

        it("zero offset", function()
            assert.same(util.get_path(0, transform, pathformat, curr_date), 
                "2020/12.md")
        end)

        it("negative offset", function()
            assert.same(util.get_path(-1, transform, pathformat, curr_date), 
                "2020/11.md")
            assert.same(util.get_path(-2, transform, pathformat, curr_date), 
                "2020/10.md")
        end)
    end)

    describe("yearly frequency", function()
        local transform = config.frequencies.yearly.transform
        local pathformat = config.frequencies.yearly.pathformat

        it("positive offset", function()
            assert.same(util.get_path(1, transform, pathformat, curr_date), 
                "2021.md")
            assert.same(util.get_path(2, transform, pathformat, curr_date), 
                "2022.md")
        end)

        it("zero offset", function()
            assert.same(util.get_path(0, transform, pathformat, curr_date), 
                "2020.md")
        end)

        it("negative offset", function()
            assert.same(util.get_path(-1, transform, pathformat, curr_date), 
                "2019.md")
            assert.same(util.get_path(-2, transform, pathformat, curr_date), 
                "2018.md")
        end)
    end)
end)
