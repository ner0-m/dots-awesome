-- Library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local exit_screen_grabber

local function exit()
	awful.quit()
end

local function reboot()
	awful.spawn.with_shell("reboot")
	awful.keygrabber.stop(exit_screen_grabber)
end

local function poweroff()
	awful.spawn.with_shell("poweroff")
	awful.keygrabber.stop(exit_screen_grabber)
end

local poweroff_button = require("ui.gooey").make_button({
	icon = "poweroff",
	bg = beautiful.background,
	fg = beautiful.white,
	width = dpi(200),
        margin = 100,
	hover = true,
	exec = function()
		poweroff()
	end,
})
helpers.add_hover_cursor(poweroff_button, "hand1")

local reboot_button = require("ui.gooey").make_button({
	icon = "bell2",
	bg = beautiful.background,
	fg = beautiful.white,
	width = dpi(200),
        margin = 100,
	hover = true,
	exec = function()
		reboot()
	end,
})

helpers.add_hover_cursor(reboot_button, "hand1")

local exit_button = require("ui.gooey").make_button({
	icon = "logout",
	bg = beautiful.background,
	fg = beautiful.white,
	width = dpi(200),
        margin = 100,
	hover = true,
	exec = function()
		exit()
	end,
})

helpers.add_hover_cursor(exit_button, "hand1")

local M = {}

function M.hide()
	awful.keygrabber.stop(exit_screen_grabber)
	M.widget.visible = false
end

local screen_geometry = awful.screen.focused().geometry

M.widget = wibox({
	x = screen_geometry.x,
	y = screen_geometry.y,
	visible = false,
	ontop = true,
	type = "splash",
	height = screen_geometry.height,
	width = screen_geometry.width,
})


awesome.connect_signal("signal::show_exit_screen", function(value, muted)
	exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
		if event == "release" then
			return
		end
		if key == "Escape" or key == "q" then
			M.hide()
		end
	end)
	M.widget.visible = true
end)

-- Hide exit screen on middle and right click
M.widget:buttons(gears.table.join(
	awful.button({}, 2, function()
		M.hide()
	end),
	awful.button({}, 3, function()
		M.hide()
	end)
))

M.widget:setup({
	nil,
	{
		nil,
		{
			poweroff_button,
			reboot_button,
			exit_button,
			layout = wibox.layout.fixed.horizontal,
		},
		nil,
		expand = "none",
		layout = wibox.layout.align.horizontal,
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical,
})
