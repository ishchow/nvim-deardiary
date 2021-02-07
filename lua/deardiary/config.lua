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
        formatpath = function(entry_date)
            return entry_date:fmt(util.join_path({"%Y", "%m", "%d.md"}))
        end
    },
    weekly = {
        transform = function(curr_date, offset)
            local weekday = curr_date:getweekday()
            if weekday < 2 then
                curr_date:adddays(weekday - 7)
            else
                curr_date:adddays(2 - weekday)
            end
            return curr_date:adddays(7 * offset)
        end,
        template = function(entry_date)
            local week_end_date = entry_date:copy():adddays(6)
            return entry_date:fmt("# Week %W of %Y: ")
                .. entry_date:fmt("%A, %B %d, %Y - ")
                .. week_end_date:fmt("%A, %B %d, %Y")
        end,
        formatpath = function(entry_date)
            return entry_date:fmt(util.join_path({"%Y", "%W.md"}))
        end,
    },
    monthly = {
        transform = function(curr_date, offset)
            curr_date:setday(1)
            return curr_date:addmonths(offset)
        end,
        template = function(entry_date)
            return entry_date:fmt("# %B, %Y")
        end,
        formatpath = function(entry_date)
            return entry_date:fmt(util.join_path({"%Y", "%m.md"}))
        end,
    },
    yearly = {
        transform = function(curr_date, offset)
            curr_date:setmonth(1, 1)
            return curr_date:addyears(offset)
        end,
        template = function(entry_date)
            return entry_date:fmt("# %Y")
        end,
        formatpath = function(entry_date)
            return entry_date:fmt("%Y.md")
        end
    },
}

M.journals = {}

return M
