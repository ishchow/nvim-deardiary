local util = require("deardiary.util")
local config = require("deardiary.config")
local date = require("deardiary.lib.date")

describe("test util.get_date()", function()
    local curr_date = date(false)

    describe("daily frequency", function()
        local transform = config.frequencies.daily.transform

        it("positive offset", function()
            assert((util.get_date(1, transform, curr_date) - curr_date):spandays() == 1)
            assert((util.get_date(2, transform, curr_date) - curr_date):spandays() == 2)
        end)

        it("zero offse", function()
            assert(util.get_date(0, transform, curr_date) == curr_date)
        end)

        it("negative offset", function()
            assert((util.get_date(-1, transform, curr_date) - curr_date):spandays() == -1)
            assert((util.get_date(-2, transform, curr_date) - curr_date):spandays() == -2)
        end)
    end)

    describe("weekly frequency", function()
        local transform = config.frequencies.weekly.transform

        it("positive offset", function()
            assert((util.get_date(1, transform, curr_date) - curr_date):spandays() == 7)
            assert((util.get_date(2, transform, curr_date) - curr_date):spandays() == 14)
        end)

        it("zero offset", function()
            assert(util.get_date(0, transform, curr_date) == curr_date)
        end)

        it("negative offset", function()
            assert((util.get_date(-1, transform, curr_date) - curr_date):spandays() == -7)
            assert((util.get_date(-2, transform, curr_date) - curr_date):spandays() == -14)
        end)
    end)

    describe("monthly frequency", function()
        local transform = config.frequencies.monthly.transform

        it("positive offset", function()
            assert(util.get_date(1, transform, curr_date):getmonth() == math.fmod(curr_date:getmonth() + 1, 12))
            assert(util.get_date(2, transform, curr_date):getmonth() == math.fmod(curr_date:getmonth() + 2, 12))
        end)

        it("zero offset", function()
            assert(util.get_date(0, transform, curr_date) == curr_date)
        end)

        it("negative offset", function()
            assert(util.get_date(-1, transform, curr_date):getmonth() == math.fmod(curr_date:getmonth() - 1, 12))
            assert(util.get_date(-2, transform, curr_date):getmonth() == math.fmod(curr_date:getmonth() - 2, 12))
        end)
    end)

    describe("yearly frequency", function()
        local transform = config.frequencies.yearly.transform

        it("positive offset", function()
            assert(util.get_date(1, transform, curr_date):getyear() == curr_date:getyear() + 1)
            assert(util.get_date(2, transform, curr_date):getyear() == curr_date:getyear() + 2)
        end)

        it("zero offset", function()
            assert(util.get_date(0, transform, curr_date) == curr_date)
        end)

        it("negative offset", function()
            assert(util.get_date(-1, transform, curr_date):getyear() == curr_date:getyear() - 1)
            assert(util.get_date(-2, transform, curr_date):getyear() == curr_date:getyear() - 2)
        end)
    end)
end)
