-- Look and feel: Gruvbox, thin borders, no transparency, no blur, calm motion

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,
    col = {
      active_border = "rgb(7daea3)",
      inactive_border = "rgb(3c3836)",
    },
    resize_on_border = true,
    extend_border_grab_area = 8,
    layout = "dwindle",
    allow_tearing = false,
  },

  decoration = {
    rounding = 0,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = { enabled = false },
    blur = { enabled = false },
  },

  group = {
    col = { border_active = "rgb(7daea3)", border_inactive = "rgb(3c3836)" },
    groupbar = {
      font_family = "JetBrainsMono Nerd Font",
      font_size = 11,
      height = 20,
      text_color = "rgb(d4be98)",
      col = { active = "rgb(32302f)", inactive = "rgb(1d2021)" },
    },
  },

  dwindle = { preserve_split = true, force_split = 2 },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    background_color = "rgb(1d2021)",
    disable_scale_notification = true,
    focus_on_activate = true,
    bell_sound = "none",
  },

  cursor = { hide_on_key_press = true },

  animations = { enabled = true },
})

hl.curve("calm", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.animation({ leaf = "global", enabled = true, speed = 6, bezier = "calm" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "calm", style = "popin 92%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "linear", style = "popin 92%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "calm" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "calm" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "calm", style = "fade" })
