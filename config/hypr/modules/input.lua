-- Keyboard, touchpad and gestures.
hl.config({
  input = {
    kb_layout    = "us",
    kb_options   = "ctrl:nocaps",   -- Caps Lock is Ctrl
    repeat_rate  = 40,
    repeat_delay = 250,
    follow_mouse = 1,
    sensitivity  = 0,
    touchpad = {
      natural_scroll = true,        -- content follows the fingers
      tap_to_click   = true,
      disable_while_typing = true,
    },
  },
})

-- Three fingers left and right switch workspaces.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
