-- Keybindings, close to Omarchy's so muscle memory carries over.
-- SUPER is the Windows key. See them all with: hyprctl binds

local function bind(keys, cmd, opts)
  if type(cmd) == "string" then cmd = hl.dsp.exec_cmd(cmd) end
  hl.bind(keys, cmd, opts or {})
end

local term = "ghostty"
local float = "ghostty --class=gus.float -e "
local ritual = "ghostty --class=gus.ritual -e "

-- Apps
bind("SUPER + RETURN", term)
bind("SUPER + SPACE", "fuzzel")
bind("SUPER + SHIFT + F", term .. " -e yazi")
bind("SUPER + SHIFT + B", "zen-browser")
bind("SUPER + SHIFT + N", "emacsclient -c -a ''")
bind("SUPER + SHIFT + T", float .. "btop")
bind("SUPER + SHIFT + A", float .. "wiremix")
bind("SUPER + SHIFT + W", float .. "nmtui")
bind("SUPER + SHIFT + D", float .. "bluetui")
bind("SUPER + V", "gus-clipboard")

-- Rituals
bind("SUPER + K", ritual .. "keiko start")
bind("SUPER + SHIFT + K", "gus-keiko-notify")
bind("SUPER + SHIFT + O", ritual .. "day open")
bind("SUPER + SHIFT + C", ritual .. "day close")

-- Session
bind("SUPER + CTRL + L", "loginctl lock-session")
bind("SUPER + ESCAPE", "gus-power")
bind("SUPER + CTRL + R", "pkill qs; qs -d")

-- Screenshots: region to clipboard and ~/media/pictures/screenshots. The MX Keys Mini F8 sends SUPER + SHIFT + S.
bind("PRINT", "gus-screenshot region")
bind("SUPER + SHIFT + S", "gus-screenshot region")
bind("SHIFT + PRINT", "gus-screenshot screen")

-- Windows
bind("SUPER + W", hl.dsp.window.close())
bind("SUPER + Q", hl.dsp.window.close())
bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
bind("SUPER + J", hl.dsp.layout("togglesplit"))
bind("SUPER + P", hl.dsp.window.pseudo())
bind("SUPER + G", hl.dsp.group.toggle())

for key, dir in pairs({ LEFT = "l", RIGHT = "r", UP = "u", DOWN = "d" }) do
  bind("SUPER + " .. key, hl.dsp.focus({ direction = dir }))
  bind("SUPER + SHIFT + " .. key, hl.dsp.window.swap({ direction = dir }))
end

bind("SUPER + minus", hl.dsp.window.resize({ x = -80, y = 0, relative = true }), { repeating = true })
bind("SUPER + equal", hl.dsp.window.resize({ x = 80, y = 0, relative = true }), { repeating = true })
bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -80, relative = true }), { repeating = true })
bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 80, relative = true }), { repeating = true })

bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces 1 to 10 on the number row (code:10 is the 1 key)
for ws = 1, 10 do
  local key = "code:" .. tostring(ws + 9)
  bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(ws) }))
  bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(ws), follow = true }))
end
bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Media and brightness keys work even on the lock screen
local locked = { locked = true, repeating = true }
bind("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", locked)
bind("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", locked)
bind("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true })
bind("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true })
bind("XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+", locked)
bind("XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-", locked)
bind("XF86AudioPlay", "playerctl play-pause", { locked = true })
bind("XF86AudioNext", "playerctl next", { locked = true })
bind("XF86AudioPrev", "playerctl previous", { locked = true })
