-- Dark Solid: opaque windows, hairline borders, one soft shadow, no blur.
local t = require("modules.theme")

hl.config({
  general = {
    gaps_in          = 6,
    gaps_out         = 12,
    border_size      = 1,
    col = {
      active_border   = t.border_active,
      inactive_border = t.border,
    },
    resize_on_border = true,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 10,
    rounding_power   = 2,
    active_opacity   = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled      = true,
      range        = 24,
      render_power = 3,
      color        = t.shadow,
    },
    blur = {
      enabled = false,
    },
  },

  animations = { enabled = true },

  dwindle = { preserve_split = true },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
    disable_splash_rendering = true,
    -- If the lock screen crashes, allow restarting it from a TTY.
    allow_session_lock_restore = true,
  },
})

-- Short, eased fades and a small scale on open (about 150 ms).
hl.curve("mac", { type = "bezier", points = { {0.25, 1}, {0.5, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global",     enabled = true, speed = 3,   bezier = "mac" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 2.5, bezier = "mac",    style = "popin 94%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "linear", style = "popin 94%" })
hl.animation({ leaf = "windowsMove",enabled = true, speed = 2.5, bezier = "mac" })
hl.animation({ leaf = "fade",       enabled = true, speed = 2,   bezier = "mac" })
hl.animation({ leaf = "border",     enabled = true, speed = 2,   bezier = "mac" })
hl.animation({ leaf = "layers",     enabled = true, speed = 2,   bezier = "mac",    style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "mac",    style = "fade" })
