describe("test util.get_date()", function()
    package.path = package.path .. ";spec/vim.lua"
    _G.vim = require("vim")

    local util = require("deardiary.util")
    local config = require("deardiary.config")
    local date = require("deardiary.lib.date")

    local curr_date = date("2020-12-31");

    describe("daily frequency", function()
        local transform = config.frequencies.daily.transform

        it("positive offset", function()
            assert.same(util.get_date(1, transform, curr_date), date("2021-01-01"))
            assert.same(util.get_date(2, transform, curr_date), date("2021-01-02"))
        end)

        it("zero offset", function()
            assert.same(util.get_date(0, transform, curr_date), curr_date)
        end)

        it("negative offset", function()
            assert.same(util.get_date(-1, transform, curr_date), date("2020-12-30"))
            assert.same(util.get_date(-2, transform, curr_date), date("2020-12-29"))
        end)
    end)

    describe("weekly frequency", function()
        local transform = config.frequencies.weekly.transform

        it("positive offset", function()
            assert.same(util.get_date(1, transform, curr_date):getweeknumber(), 1)
            assert.same(util.get_date(2, transform, curr_date):getweeknumber(), 2)
        end)

        it("zero offset", function()
            assert.same(util.get_date(0, transform, curr_date):getweeknumber(), 52)
        end)

        it("negative offset", function()
            assert.same(util.get_date(-1, transform, curr_date):getweeknumber(), 51)
            assert.same(util.get_date(-2, transform, curr_date):getweeknumber(), 50)
        end)
    end)

    describe("monthly frequency", function()
        local transform = config.frequencies.monthly.transform

        it("positive offset", function()
            assert.same(util.get_date(1, transform, curr_date):getmonth(), 1)
            assert.same(util.get_date(2, transform, curr_date):getmonth(), 2)
            assert.same(util.get_date(3, transform, curr_date):getmonth(), 3)
        end)

        it("zero offset", function()
            assert.same(util.get_date(0, transform, curr_date):getmonth(), curr_date:getmonth())
        end)

        it("negative offset", function()
            assert.same(util.get_date(-1, transform, curr_date):getmonth(), 11)
            assert.same(util.get_date(-2, transform, curr_date):getmonth(), 10)
        end)
    end)

    describe("yearly frequency", function()
        local transform = config.frequencies.yearly.transform

        it("positive offset", function()
            assert.same(util.get_date(1, transform, curr_date):getyear(), 2021) 
            assert.same(util.get_date(2, transform, curr_date):getyear(), 2022)
        end)

        it("zero offset", function()
            assert.same(util.get_date(0, transform, curr_date):getyear(), curr_date:getyear())
        end)

        it("negative offset", function()
            assert.same(util.get_date(-1, transform, curr_date):getyear(), 2019)
            assert.same(util.get_date(-2, transform, curr_date):getyear(), 2018)
        end)
    end)
end)
