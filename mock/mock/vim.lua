local pl = require'pl.import_into'()

return {
    cmd = function(cmd)
    end,
    list_extend = function(dst, src)
        pl.tablex.insertvalues(dst, src)
        return dst
    end,
    tbl_contains = function(t, value)
        local l = pl.List(t)
        return l:contains(value)
    end,
    tbl_keys = function(t)
        return pl.tablex.keys(t)
    end,
    tbl_extend = function(behavior, a, b)
        if behavior == "force" then
            return pl.tablex.union(a, b)
        end
        return nil
    end,
    tbl_filter = function(func, t)
        return pl.tablex.filter(t, func)
    end,
    inspect = function(object)
        return pl.pretty.write(object)
    end,
    startswith = function(s, prefix)
        return pl.stringx.startswith(s, prefix)
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
                win32 = (pl.path.is_windows) and 1 or 0,
                win64 = (pl.path.is_windows) and 1 or 0,
            }
            return d[h]
        end,
        mkdir = function(name)
            pl.dir.makepath(name)
        end,
        expand = function(expr)
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
