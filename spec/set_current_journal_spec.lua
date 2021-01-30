describe("test set_current_journal()", function()
    _G.vim = require("mock.vim")

    local deardiary = require("deardiary")
    local config = require("deardiary.config")

    before_each(function()
        deardiary.current_journal = nil
    end)

    it("no journals configured", function()
        config.journals = {}
        deardiary.set_current_journal(1)
        assert.is_nil(deardiary.current_journal)
    end)

    it("invalid journal index", function()
        config.journals = {
            {
                path = "~/journals/personal",
                frequencies = {"daily", "weekly"},
            },
            {
                path = "~/journals/work",
                frequencies = {"daily", "weekly", "monthly", "yearly"},
            },
        }

        deardiary.set_current_journal(-1)
        assert.is_nil(deardiary.current_journal)

        deardiary.set_current_journal(0)
        assert.is_nil(deardiary.current_journal)

        deardiary.set_current_journal(3)
        assert.is_nil(deardiary.current_journal)
    end)

    it("valid journals", function()
        config.journals = {
            {
                path = "~/journals/personal",
                frequencies = {"daily", "weekly"},
            },
            {
                path = "~/journals/work",
                frequencies = {
                    "daily",
                    weekly = {
                        transform = function(curr_date, offset)
                            return curr_date:adddays(7 * offset)
                        end,
                        template = function(entry_date)
                            return entry_date:fmt("# Week %W of %Y")
                        end,
                        formatpath = function(entry_date)
                            return entry_date:fmt("%Y-%W.md")
                        end,
                    },
                    "monthly",
                    "yearly"},
            },
        }
        deardiary.set_current_journal(1)
        assert.same(deardiary.current_journal, config.journals[1])

        deardiary.set_current_journal(2)
        assert.same(deardiary.current_journal, config.journals[2])

        deardiary.set_current_journal(1)
        assert.same(deardiary.current_journal, config.journals[1])
    end)
end)
