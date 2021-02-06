describe("test set_current_journal()", function()
    local lfs = require("lfs")
    local pl = require"pl.import_into"()

    _G.vim = require("mock.vim")

    local journal_path = pl.path.join(lfs.currentdir(), "tmp", "journal2")

    local deardiary = require("deardiary")
    local config = require("deardiary.config")

    before_each(function()
        deardiary.current_journal = nil

        vim.fn.getcwd = function()
            return journal_path
        end
    end)

    it("no journals configured", function()
        config.journals = {}
        deardiary.set_current_journal_cwd()
        assert.is_nil(deardiary.current_journal)
    end)

    it("cwd doesn't start with journal path", function()
        config.journals = {
            {
                path = pl.path.join(lfs.currentdir(), "tmp", "journal"),
                frequencies = {"daily", "monthly", "weekly", "yearly"},
            },
        }
        deardiary.set_current_journal_cwd()
        assert.is_nil(deardiary.current_journal)
    end)

    it("cwd starts with journal path", function()
        config.journals = {
            {
                path = journal_path,
                frequencies = {"daily", "monthly", "weekly", "yearly"},
            },
        }
        deardiary.set_current_journal_cwd()
        assert.same(deardiary.current_journal, config.journals[1])
    end)
end)
