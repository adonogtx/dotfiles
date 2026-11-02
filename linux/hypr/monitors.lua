-- ThinkPad T14 Gen 2i: 1920x1080 at 1.25. Anything else plugged in gets its preferred mode.
-- List monitors with: hyprctl monitors all

hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1.25 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- GTK apps follow the integer part of the scale
hl.env("GDK_SCALE", "1")
