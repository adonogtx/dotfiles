-- Keyboard and touchpad
-- The layout comes from /etc/vconsole.conf (set by archinstall), so the console and the desktop agree.

local function vconsole()
  local values = {}
  local f = io.open("/etc/vconsole.conf", "r")
  if not f then return values end
  for line in f:lines() do
    local k, v = line:match("^%s*([%w_]+)%s*=%s*\"?([^\"]*)\"?%s*$")
    if k then values[k] = v end
  end
  f:close()
  return values
end

local vc = vconsole()

hl.config({
  input = {
    kb_layout = vc.XKBLAYOUT or "us",
    kb_variant = vc.XKBVARIANT or "",
    -- Caps Lock is Ctrl
    kb_options = "ctrl:nocaps",
    follow_mouse = 1,
    sensitivity = 0,
    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,

    touchpad = {
      natural_scroll = false,
      clickfinger_behavior = true,
      scroll_factor = 0.4,
      disable_while_typing = true,
    },
  },

  misc = {
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})

-- Ghostty scrolls too fast on the touchpad by default
hl.window_rule({ match = { class = "com.mitchellh.ghostty" }, scroll_touchpad = 0.2 })
