local util = require("deardiary.util")

local M = {}

M.frequencies = {
    daily = {
        transform = function(curr_date, offset)
            return curr_date:adddays(offset)
        end,
        template = function(entry_date)
            return entry_date:fmt("# %A, %B %d, %Y")
        end,
        pathformat = util.join_path({"%Y", "%m", "%d.md"})
    },
    weekly = {
        transform = function(curr_date, offset)
            local weekday = curr_date:getweekday()
            curr_date:adddays(2 - weekday)
            return curr_date:adddays(7 * offset)
        end,
        template = function(entry_date)
            local dates = {}
            for i = 0, 6 do
                table.insert(dates, entry_date:copy():adddays(i))
            end
            local lines = {}
            local header = entry_date:fmt("# Week %W of %Y: ")
                .. dates[1]:fmt("%A, %B %d, %Y - ")
                .. dates[7]:fmt("%A, %B %d, %Y")
            table.insert(lines, header)
            table.insert(lines, "\n")
            for i = 1, #dates do
                table.insert(lines, dates[i]:fmt("## %A, %B %d, %Y"))
                table.insert(lines, "\n")
            end
            return vim.fn.join(lines, "\n") .. "\n"
        end,
        pathformat = util.join_path({"%Y", "%W.md"})
    },
    monthly = {
        transform = function(curr_date, offset)
            curr_date:setday(1)
            return curr_date:addmonths(offset)
        end,
        template = function(entry_date)
            return entry_date:fmt("# %B %Y")
        end,
        pathformat = util.join_path({"%Y", "%m.md"}),
    },
    yearly = {
        transform = function(curr_date, offset)
            curr_date:setmonth(1, 1)
            return curr_date:addyears(offset)
        end,
        template = function(entry_date)
            return entry_date:fmt("# %Y")
        end,
        pathformat = "%Y.md",
    },
}

M.journals = {}

return M
