local util = require("deardiary.util")

local M = {}

M.frequencies = {
    daily = {
        transform = function(curr_date, offset)
            return curr_date:adddays(offset)
        end,
        pathformat = util.join_path({"%Y", "%m", "%d.md"})
    },
    weekly = {
        transform = function(curr_date, offset)
            return curr_date:adddays(7 * offset)
        end,
        pathformat = util.join_path({"%Y", "%U.md"})
    },
    monthly = {
        transform = function(curr_date, offset)
            if offset ~= 0 then
                curr_date:setday(1)
            end
            return curr_date:addmonths(offset)
        end,
        pathformat = util.join_path({"%Y", "%m.md"}),
    },
    yearly = {
        transform = function(curr_date, offset)
            return curr_date:addyears(offset)
        end,
        pathformat = "%Y.md",
    },
}

M.journals = {}

return M
