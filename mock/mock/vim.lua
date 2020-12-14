local pl = require'pl.import_into'()

return {
    cmd = function(cmd)
    end,
    list_extend = function(dst, src, start, finish)
        pl.tablex.insertvalues(dst, src)
        return dst
    end,
    tbl_contains = function(t, value)
        local l = pl.List(t)
        return l:contains(value)
    end,
    inspect = function(object, options)
        return pl.pretty.write(object)
    end,
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
                win32 = (pl.path.sep == "\\") and 1 or 0,
                win64 = (pl.path.sep == "\\") and 1 or 0,
            }
            return d[h]
        end,
        mkdir = function(name, path, prot)
            pl.dir.makepath(name)
        end,
        expand = function(expr, nosurf, list)
            return pl.path.expanduser(expr)
        end,
    },
    g = {},
    b = {},
    w = {},
    t = {},
    v = {},
    env = {},
    o = {},
    bo = {},
    wo = {},
}
