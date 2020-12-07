local pl = require'pl.import_into'()

return {
    fn = {
        split = pl.stringx.split,
        join = function(list, sep)
            if sep == nil or sep == "" then
                sep = " "
            end
            return pl.stringx.join(sep, list)
        end,
        has = function(h)
            local d = {
                win32 = pl.path.sep == "\\",
                win64 = pl.path.sep == "\\",
            }
            return d[h]
        end
    },
}
