local naughty = require('naughty')
local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local beautiful = require('beautiful')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/notif-center/icons/'
local dpi = beautiful.xresources.apply_dpi

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.timeout = 6
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(20)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end

-- Apply theme variables

naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.icon_dirs = {
  "/usr/share/icons/Tela",
  "/usr/share/icons/Tela-blue-dark",
  "/usr/share/icons/Papirus/",
}
naughty.config.icon_formats = {	"png", "svg", "jpg" }


-- Presets / rules

ruled.notification.connect_signal(
  'request::rules', 
  function()

  -- Critical notifs
  ruled.notification.append_rule {
    rule       = { urgency = 'critical' },
    properties = {
      font        		= 'SF Pro Text light 11',
      bg 					= '#662222',
      fg 					= '#ffffff',
      margin 				= dpi(16),
      position 			= 'top_right',
      timeout 			= 0,
      implicit_timeout	= 0
    }
  }

  -- 	-- Normal notifs
  ruled.notification.append_rule {
    rule       = { urgency = 'normal' },
    properties = {
      font        		= 'SF Pro Text light 11',
      bg     				= beautiful.system_black_dark,
      fg 					= beautiful.fg_normal,
      margin 				= dpi(16),
      position 			= 'top_right',
      timeout 			= 5,
      implicit_timeout 	= 5
    }
  }

  -- Low notifs
  ruled.notification.append_rule {
    rule       = { urgency = 'low' },
    properties = {
      font        		= 'SF Pro Text light 11',
      bg     				= beautiful.system_black_dark,
      fg 					= beautiful.fg_normal,
      margin 				= dpi(16),
      position 			= 'top_right',
      timeout 			= 5,
      implicit_timeout	= 5
    }
  }
  end
  )


-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
naughty.notification {
  urgency = "critical",
  title   = "Something went wrong"..(startup and " during startup!" or "!"),
  message = message,
  app_name = 'System Notification',
  icon = beautiful.awesome_icon
}
end)


naughty.connect_signal(
  "request::display", 
  function(n)


  -- naughty.actions template
  local actions_template = wibox.widget {
    notification = n,
    base_layout = wibox.widget {
      spacing        = dpi(0),
      layout         = wibox.layout.flex.horizontal
    },
    widget_template = {
      {
        {
          {
            id     = 'text_role',
            font   = 'SF Pro Text Regular 10',
            widget = wibox.widget.textbox
          },
          widget = wibox.container.place
        },
        bg                 = beautiful.groups_bg,
        shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end,
        forced_height      = dpi(30),
        widget             = wibox.container.background,
      },
      bottom = dpi(5),
      margins = dpi(5),
      widget  = wibox.container.margin,
    },
    style = { underline_normal = false, underline_selected = true },
    widget = naughty.list.actions

  }


  local notif_icon = n.icon or n.app_icon
  if not notif_icon then
    n.icon = widget_icon_dir .. 'new-notif-plain' .. '.svg'
  end

  -- Custom notification layout
  naughty.layout.box {
    notification = n,
    type = "notification",
    screen = awful.screen.focused(),
    shape = gears.shape.rectangle,
    widget_template = {
      {
        {
          {
            {
              {
                {
                  {
                    {
                      {
                        {
                          markup = n.app_name or 'System Notification',
                          font = 'SF Pro Bold 10',
                          align = 'left',
                          widget = wibox.widget.textbox

                        },
                        left = beautiful.notification_margin,
                        right = beautiful.notification_margin,
                        widget  = wibox.container.margin,
                      },
                      {
                        {
                          {
                              resize_strategy = 'center',
                              widget = naughty.widget.icon,
                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        {
                          {
                            layout = wibox.layout.align.vertical,
                            expand = 'none',
                            nil,
                            {
                              {
                                align = 'left',
                                font = 'SF Text Bold 10',
                                widget = naughty.widget.title
                              },
                              {
                                align = "left",
                                valign = 'center',
                                widget = naughty.widget.message,
                              },
                              layout = wibox.layout.fixed.vertical
                            },
                            nil
                          },
                          right = dpi(beautiful.notification_margin),
                          widget  = wibox.container.margin,
                        },
                        fill_space = true,
                        layout = wibox.layout.fixed.horizontal,
                      },
                      fill_space = true,
                      spacing = beautiful.notification_margin,
                      layout  = wibox.layout.fixed.vertical,
                    },
                    -- Margin between the fake background
                    -- Set to 0 to preserve the 'titlebar' effect
                    margins = dpi(20),
                    widget  = wibox.container.margin,
                  },
                  bg = beautiful.system_grey .. 'FF',
                  widget  = wibox.container.background,
                },
                -- Notification action list
                -- naughty.list.actions,
                actions_template,
                spacing = dpi(4),
                layout  = wibox.layout.fixed.vertical,
              },
              bg     = beautiful.system_black_dark,
              id     = "background_role",
              widget = naughty.container.background,
            },
            strategy = "min",
            width    = dpi(300),
            widget   = wibox.container.constraint,
          },
          strategy = "max",
          width    = dpi(300),
          widget   = wibox.container.constraint,
        },
        -- Anti-aliasing container
        -- Real BG
        bg = beautiful.transparent,
        -- This will be the anti-aliased shape of the notification
        shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end,
        widget = wibox.container.background,
        border_width = dpi(0),
        border_color = beautiful.system_black_light .. 'FF',

      },
      -- Margin of the fake BG to have a space between notification and the screen edge
      top = dpi(10),
      right = dpi(10),
      widget  = wibox.container.margin
    }

  }

  -- Destroy popups if dont_disturb mode is on
  -- Or if control center is open
  local focused = awful.screen.focused()
    if _G.dont_disturb or (focused.control_center and focused.control_center.visible) then
    naughty.destroy_all_notifications(nil, 1)
    end
end
)