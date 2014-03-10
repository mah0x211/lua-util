package = "util"
version = "scm-1"
source = {
    url = "git://github.com/mah0x211/lua-util.git"
}
description = {
    summary = "utility functions",
    detailed = [[]],
    homepage = "https://github.com/mah0x211/lua-util", 
    license = "MIT/X11",
    maintainer = "Masatoshi Teruya"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        util = "lib/util.lua",
        ["util.string"] = "lib/string.lua",
    }
}

