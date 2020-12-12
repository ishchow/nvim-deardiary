describe("test set_journal()", function()
    _G.vim = require("mock.vim")

    local deardiary = require("deardiary")
    local config

    before_each(function()
        vim.g.deardiary_current_journal = nil
        config = require("deardiary.config")
    end)

    it("no journals configured", function()
        deardiary.set_journal(1)
        assert.is_nil(vim.g.deardiary_current_journal)
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

        deardiary.set_journal(-1)
        assert.is_nil(vim.g.deardiary_current_journal)

        deardiary.set_journal(0)
        assert.is_nil(vim.g.deardiary_current_journal)

        deardiary.set_journal(3)
        assert.is_nil(vim.g.deardiary_current_journal)
    end)

    it("valid journals", function()
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
        deardiary.set_journal(1)
        assert.same(vim.g.deardiary_current_journal, config.journals[1])

        deardiary.set_journal(2)
        assert.same(vim.g.deardiary_current_journal, config.journals[2])

        deardiary.set_journal(1)
        assert.same(vim.g.deardiary_current_journal, config.journals[1])
    end)
end)
