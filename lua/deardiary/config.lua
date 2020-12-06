local M = {}

M.frequencies = {
    daily = {
        transform = function(curr_date, offset)
            return curr_date:adddays(offset)
        end,
        pathformat = "%Y/%m/%d.md",
    },
    weekly = {
        transform = function(curr_date, offset)
            return curr_date:adddays(7 * offset)
        end,
        pathformat = "%Y/%V.md",
    },
    monthly = {
        transform = function(curr_date, offset)
            return curr_date:addmonths(offset)
        end,
        pathformat = "%Y/%m.md",
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
