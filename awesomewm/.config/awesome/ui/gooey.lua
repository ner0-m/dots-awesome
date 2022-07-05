local awful = require("awful")
local beautiful = require("beautiful")
local icons_dir = require("gears").filesystem.get_configuration_dir() .. "/icons/"
local wibox = require("wibox")

local M = {}

function M.make_button(opts)
	opts = opts or {}

	local icon = opts.icon or "default"
	local icon_color = opts.icon_fg or "#00000000"
	local icon_widget = wibox.widget({
		widget = wibox.widget.imagebox,
		image = icons_dir .. icon .. ".svg",
		stylesheet = " * { stroke: " .. icon_color .. " }",
	})

	local text_widget = wibox.widget({
		widget = wibox.widget.textbox,
		align = "center",
		valign = "center",
		markup = opts.text or "Button",
		font = opts.font or beautiful.font,
	})

	local inner_widget = text_widget

	if opts.icon then
		inner_widget = icon_widget
	end

	local button = wibox.widget({
		widget = wibox.container.background,
		forced_width = opts.width or 100,
		forced_height = opts.height or 100,
		bg = opts.bg or beautiful.bg_normal,
		fg = opts.fg or beautiful.fg_normal,
		{
			widget = wibox.container.margin,
			margins = opts.margins or 30,
			inner_widget,
		},
		buttons = {
			awful.button({}, 1, function()
				opts.exec()
			end),
		},
	})

	if opts.hover then
		button:connect_signal("mouse::enter", function()
			button.bg = opts.bg_hover or beautiful.bg_normal
		end)

		button:connect_signal("mouse::leave", function()
			button.bg = opts.bg or beautiful.bg_normal
		end)
	end

	return button
end

function M.make_switch(opts)
	opts = opts or {}

	local icon = opts.icon or "default"
	local icon_color = opts.icon_fg or beautiful.fg_normal
	local icon_color_on = opts.icon_fg_on or beautiful.fg_focus
	local icon_widget = wibox.widget({
		widget = wibox.widget.imagebox,
		image = icons_dir .. icon .. ".svg",
		stylesheet = " * { stroke: " .. icon_color .. " }",
	})

	local text_widget = wibox.widget({
		widget = wibox.widget.textbox,
		markup = opts.text or "Button",
		font = opts.font or beautiful.font,
	})

	local inner_widget = text_widget

	if opts.icon then
		inner_widget = icon_widget
	end

	local button = wibox.widget({
		widget = wibox.container.background,
		forced_width = opts.width or 100,
		forced_height = opts.height or 100,
		bg = opts.bg or beautiful.bg_normal,
		fg = opts.fg or beautiful.fg_normal,
		{
			widget = wibox.container.margin,
			margins = opts.margins or 30,
			inner_widget,
		},
	})

	local s = true
	button:buttons({
		awful.button({}, 1, function()
			s = not s
			if s then
				button.bg = opts.bg_off or beautiful.bg_normal
				icon_widget.stylesheet = " * { stroke: " .. icon_color .. " }"
				opts.exec_off()
			else
				button.bg = opts.bg_on or beautiful.bg_focus
				icon_widget.stylesheet = " * { stroke: " .. icon_color_on .. " }"
				opts.exec_on()
			end
		end),
	})

	return button
end

function M.make_prompt_widget(prompt, opts)
	opts = opts or {}
	return awful.popup({
		widget = {
			widget = wibox.container.margin,
			margins = opts.margins or 20,
			prompt,
		},
		ontop = true,
		placement = opts.placement or awful.placement.centered,
		visible = false,
		border_color = opts.border_color or beautiful.border_color_active,
		border_width = opts.border_width or 2,
		bg = opts.bg or beautiful.bg_normal,
		forced_width = opts.forced_width or 500,
		forced_height = opts.forced_height or 500,
	})
end

-- TODO: Give proper credits to Grumph from Reddit and their GitLab link
-- Hide/close the given widget according to the hide_fn
function M.click_to_hide_popup(widget, hide_fn, only_outside)
	-- By default only close if clicked outside
	only_outside = only_outside or true

	-- default function to hide on click
	hide_fn = hide_fn
		or function(obj)
			if only_outside and obj == widget then
				return
			end

			widget.visible = false
		end

	local click_bind = awful.button({}, 1, hide_fn)

	widget:connect_signal("property::visible", function(w)
		if not w.visible then
			wibox.disconnect_signal("button::press", hide_fn)
			client.disconnect_signal("button::press", hide_fn)
			awful.mouse.remove_global_mousebinding(click_bind)
		else
			awful.mouse.append_global_mousebinding(click_bind)
			wibox.connect_signal("button::press", hide_fn)
			client.connect_signal("button::press", hide_fn)
		end
	end)
end

return M
