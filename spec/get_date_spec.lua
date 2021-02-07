describe("test deardiary.get_date()", function()
    -- Setup mock vim module before we require deardiary modules
    _G.vim = require("mock.vim")

    local config = require("deardiary.config")
    local date = require("deardiary.lib.date")
    local deardiary = require("deardiary")

    local curr_date = date("2020-12-31");

    describe("daily frequency", function()
        local frequency = config.frequencies.daily

        it("positive offset", function()
            assert.same(deardiary.get_date(1, frequency, curr_date), date("2021-01-01"))
            assert.same(deardiary.get_date(2, frequency, curr_date), date("2021-01-02"))
        end)

        it("zero offset", function()
            assert.same(deardiary.get_date(0, frequency, curr_date), curr_date)
        end)

        it("negative offset", function()
            assert.same(deardiary.get_date(-1, frequency, curr_date), date("2020-12-30"))
            assert.same(deardiary.get_date(-2, frequency, curr_date), date("2020-12-29"))
        end)
    end)

    describe("weekly frequency", function()
        local frequency = config.frequencies.weekly
        local startofweek = 2 -- Monday

        it("positive offset", function()
            assert.same(deardiary.get_date(1, frequency, curr_date), date("2021-01-04"))
            assert.same(deardiary.get_date(1, frequency, curr_date):getweeknumber(startofweek), 1)

            assert.same(deardiary.get_date(2, frequency, curr_date):getweeknumber(startofweek), 2)
            assert.same(deardiary.get_date(2, frequency, curr_date), date("2021-01-11"))
        end)

        it("zero offset", function()
            assert.same(deardiary.get_date(0, frequency, curr_date):getweeknumber(startofweek), 52)
            assert.same(deardiary.get_date(0, frequency, curr_date), date("2020-12-28"))

            assert.same(deardiary.get_date(0, frequency, date("2020-12-14")),
                deardiary.get_date(0, frequency, date("2020-12-19")))
        end)

        it("negative offset", function()
            assert.same(deardiary.get_date(-1, frequency, curr_date):getweeknumber(startofweek), 51)
            assert.same(deardiary.get_date(-1, frequency, curr_date), date("2020-12-21"))

            assert.same(deardiary.get_date(-2, frequency, curr_date):getweeknumber(startofweek), 50)
            assert.same(deardiary.get_date(-2, frequency, curr_date), date("2020-12-14"))
        end)
    end)

    describe("monthly frequency", function()
        local frequency = config.frequencies.monthly

        it("positive offset", function()
            assert.same(deardiary.get_date(1, frequency, curr_date), date("2021-01-01"))
            assert.same(deardiary.get_date(2, frequency, curr_date), date("2021-02-01"))
            assert.same(deardiary.get_date(3, frequency, curr_date), date("2021-03-01"))
        end)

        it("zero offset", function()
            assert.same(deardiary.get_date(0, frequency, curr_date), date("2020-12-01"))

            assert.same(deardiary.get_date(0, frequency, date("2020-02-29")),
                deardiary.get_date(0, frequency, date("2020-02-01")))
        end)

        it("negative offset", function()
            assert.same(deardiary.get_date(-1, frequency, curr_date), date("2020-11-01"))
            assert.same(deardiary.get_date(-2, frequency, curr_date), date("2020-10-01"))
            assert.same(deardiary.get_date(-3, frequency, curr_date), date("2020-09-01"))
        end)
    end)

    describe("yearly frequency", function()
        local frequency = config.frequencies.yearly

        it("positive offset", function()
            assert.same(deardiary.get_date(1, frequency, curr_date), date("2021-01-01"))
            assert.same(deardiary.get_date(2, frequency, curr_date), date("2022-01-01"))
        end)

        it("zero offset", function()
            assert.same(deardiary.get_date(0, frequency, curr_date), date("2020-01-01"))
        end)

        it("negative offset", function()
            assert.same(deardiary.get_date(-1, frequency, curr_date), date("2019-01-01"))
            assert.same(deardiary.get_date(-2, frequency, curr_date), date("2018-01-01"))
        end)
    end)
end)
