-- ThinkPad T14 Gen 2i panel: 1080p at 1.25.
hl.monitor({
  output   = "eDP-1",
  mode     = "preferred",
  position = "auto",
  scale    = "1.25",
})

-- Any external monitor: native mode, placed to the right.
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto-right", scale = "1" })

hl.config({
  xwayland = {
    force_zero_scaling = true,   -- no blurry XWayland apps; IntelliJ runs native Wayland anyway
  },
})
