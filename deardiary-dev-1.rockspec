rockspec_format = "3.0"
package = "deardiary"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/ishchow/deardiary.git"
}
description = {
   summary = "# Installation",
   detailed = [[

# Installation]],
   homepage = "*** please enter a project homepage ***",
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      ["deardiary.config"] = "lua/deardiary/config.lua",
      ["deardiary.init"] = "lua/deardiary/init.lua",
      ["deardiary.lib.date"] = "lua/deardiary/lib/date.lua",
      ["deardiary.util"] = "lua/deardiary/util.lua"
   }
}
test_dependencies = {
    'busted',
    'penlight',
    'inspect',
}
test = {
    type = "busted",
}
