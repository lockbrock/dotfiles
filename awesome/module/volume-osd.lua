local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.clickable-container')
local icons = require('theme.icons')
local spawn = require('awful.spawn')

screen.connect_signal("request::desktop_decoration", function(s)

	s.show_vol_osd = false

	local osd_header = wibox.widget {
		text = 'Volume',
		font = 'SF Pro Text Bold 12',
		align = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local osd_value = wibox.widget {
		text = '0%',
		font = 'SF Pro Text Bold 12',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local slider_osd = wibox.widget {
		nil,
		{
			id 					= 'vol_osd_slider',
			bar_shape           = gears.shape.rounded_rect,
			bar_height          = dpi(2),
			bar_color           = beautiful.system_white_light .. '33',
			bar_active_color	= beautiful.system_white_light .. 'ff',
			handle_color        = beautiful.system_white_light .. 'ff',
			handle_shape        = gears.shape.circle,
			handle_width        = dpi(15),
			handle_border_color = '#00000012',
			handle_border_width = dpi(1),
			maximum				= 100,
			widget              = wibox.widget.slider,
		},
		nil,
		expand = 'none',
		layout = wibox.layout.align.vertical
	}

	local vol_osd_slider = slider_osd.vol_osd_slider

	-- Update volume level using slider value
	vol_osd_slider:connect_signal(
		'property::value',
		function()

			local volume_level = vol_osd_slider:get_value()

			spawn('amixer -D pulse sset Master ' .. volume_level .. '%', false)

			-- Update textbox widget text
			osd_value.text = volume_level .. '%'

			-- Update the volume slider if values here change
			
		
			if s.show_vol_osd then
				awesome.emit_signal(
					'module::volume_osd:show', 
					true
				)
			else
				awesome.emit_signal('widget::volume:update', volume_level)
			end

		end
	)

	vol_osd_slider:connect_signal(
		'button::press',
		function()
			s.show_vol_osd = true
		end
	)
	vol_osd_slider:connect_signal(
		'button::release',
		function()
			--s.show_vol_osd = false
		end
	)
	vol_osd_slider:connect_signal(
		'mouse::enter',
		function()
			s.show_vol_osd = true
		end
	)

	-- The emit will come from the volume-slider
	awesome.connect_signal(
		'module::volume_osd',
		function(volume)
			vol_osd_slider:set_value(volume)
		end
	)

	local icon = wibox.widget {
		{
			image = icons.volume,
			resize = true,
			widget = wibox.widget.imagebox
		},
		top = dpi(12),
		bottom = dpi(12),
		widget = wibox.container.margin
	}

	local volume_slider_osd = wibox.widget {
		icon,
		slider_osd,
		spacing = dpi(24),
		layout = wibox.layout.fixed.horizontal
	}

	-- Create the box
	local osd_height = dpi(100)
	local osd_width = dpi(300)

	local osd_margin = dpi(10) + s.bottom_panel.height

	s.volume_osd_overlay = awful.popup {
		widget = {
		  -- Removing this block will cause an error...
		},
		ontop = true,
		visible = false,
		type = 'notification',
		screen = s,
		height = osd_height,
		width = osd_width,
		maximum_height = osd_height,
		maximum_width = osd_width,
		offset = dpi(5),
		shape = gears.shape.rectangle,
		bg = beautiful.transparent,
		fg = beautiful.widget_fg,
		preferred_anchors = 'middle',
		preferred_positions = {'left', 'right', 'top', 'bottom'},

	}

	s.volume_osd_overlay : setup {
		{
			{
				{
					layout = wibox.layout.align.horizontal,
					expand = 'none',
					forced_height = dpi(48),
					osd_header,
					nil,
					osd_value
				},
				volume_slider_osd,
				layout = wibox.layout.fixed.vertical
			},
			left = dpi(24),
			right = dpi(24),
			widget = wibox.container.margin

		},
		bg = beautiful.system_black_light,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background()
	}


	local hide_osd = gears.timer {
		timeout = 2,
		autostart = true,
		callback  = function()
			awful.screen.focused().volume_osd_overlay.visible = false
		end
	}

	local timer_rerun = function()
	 	if hide_osd.started then
			hide_osd:again()
		else
			hide_osd:start()
		end
	end

	-- Reset timer on mouse hover
	s.volume_osd_overlay:connect_signal(
		'mouse::enter', 
		function()
			s.show_vol_osd = true
			timer_rerun()
		end
	)
	s.volume_osd_overlay:connect_signal(
		'mouse::leave', 
		function()
			s.show_vol_osd = false
		end
	)

	local placement_placer = function()

		local focused = awful.screen.focused()
		
		local right_panel = focused.right_panel
		local volume_osd = focused.volume_osd_overlay

		if right_panel then
			if right_panel.visible then
				awful.placement.bottom_left(focused.volume_osd_overlay, { margins = { 
					left = dpi(5),
					right = 0,
					top = 0,
					bottom = osd_margin,
					}, 
					parent = focused }
				)
				return
			end
		end

		awful.placement.bottom_right(focused.volume_osd_overlay, { margins = { 
			left = 0,
			right = dpi(5),
			top = 0,
			bottom = osd_margin,
			}, 
			parent = focused }
		)
	end

	awesome.connect_signal(
		'module::volume_osd:show', 
		function(bool)
			placement_placer()
			awful.screen.focused().volume_osd_overlay.visible = bool
			if bool then
				timer_rerun()
				awesome.emit_signal(
					'module::brightness_osd:show', 
					false
				)
			else
				if hide_osd.started then
					hide_osd:stop()
				end
			end
		end
	)

end)