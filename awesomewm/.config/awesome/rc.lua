pcall(require, "luarocks.loader")

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- {{{ Variable definitions
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/night/theme.lua")
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
-- }}}

F = {}
-- {{{ Menu
require("ui.menu")
--}}}

-- {{{ Tag layout
require("config.layout")
-- }}}

-- {{{ Wallpaper
require("config.wallpaper")
-- }}}

-- {{{ Wibar
require("ui.bar")
-- }}}

-- {{{ Mouse bindings
require("config.mousebindings")
-- }}}

-- {{{ Key bindings
require("config.keybindings")
-- }}}

-- {{{ Rules
require("config.rule")
-- }}}

-- {{{ Titlebars
require("ui.titlebar")
-- }}}

-- {{{ Notifications
require("ui.notifications")
-- }}}

-- {{{ Dashboard
require("ui.popup.action")
-- }}}

-- {{{ Exit screen
require("ui.widgets.exit_screen")
require("ui.widgets.launcher")
-- }}}
awful.spawn.with_shell("picom")


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
