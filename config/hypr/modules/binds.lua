-- Keybindings. Full table in docs/keybindings.md.
-- SUPER plays the role of Command; vim keys move focus.
local app = require("modules.programs")
local mod = "SUPER"
local function bind(keys, action, opts) hl.bind(mod .. " + " .. keys, action, opts) end
local exec = hl.dsp.exec_cmd

-- Dispatchers whose Lua names may change between Hyprland releases are
-- wrapped: if one fails, only that group is lost and the error is reported.
local function try(label, fn)
  local ok, err = pcall(fn)
  if not ok and GUS_CONFIG_ERRORS then
    table.insert(GUS_CONFIG_ERRORS, "binds/" .. label .. ": " .. tostring(err))
  end
end

-- Apps
bind("Return",      exec(app.terminal))
bind("Space",       exec(app.launcher))
bind("B",           exec(app.browser))
bind("E",           exec(app.files))
bind("D",           exec(app.editor))
bind("I",           exec(app.ide))
bind("C",           exec("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
bind("SHIFT + C",   exec("cliphist wipe && notify-send 'Clipboard history cleared'"))

-- Windows (these names come from the upstream example config)
bind("Q",           hl.dsp.window.close())
bind("V",           hl.dsp.window.float({ action = "toggle" }))
bind("T",           hl.dsp.layout("togglesplit"))
bind("mouse:272",   hl.dsp.window.drag(),   { mouse = true })
bind("mouse:273",   hl.dsp.window.resize(), { mouse = true })
for key, dir in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
  bind(key, hl.dsp.focus({ direction = dir }))
end

-- Workspaces 1 to 5 (the pill shows five dots), also from the upstream example
for i = 1, 5 do
  bind(tostring(i),     hl.dsp.focus({ workspace = i }))
  bind("SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
bind("mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up",     hl.dsp.focus({ workspace = "e-1" }))
bind("S",            hl.dsp.workspace.toggle_special("scratch"))
bind("SHIFT + S",    exec("gus-screenshot region"))   -- MX Keys Mini F8 sends this

-- Names not in the upstream example: isolated so a rename cannot break the rest.
try("fullscreen", function()
  bind("F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
end)
try("move-window", function()
  for key, dir in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
    bind("SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
  end
end)
try("previous-workspace", function()
  bind("Tab", hl.dsp.focus({ workspace = "previous" }))
end)
try("resize-mode", function()
  -- SUPER + R, then H J K L, Escape to leave.
  hl.define_submap("resize", function()
    hl.bind("H", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = 40,  y = 0 }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = 40 }),  { repeating = true })
    hl.bind("Escape", hl.dsp.submap("default"))
  end)
  bind("R", hl.dsp.submap("resize"))
end)

-- Capture
hl.bind("Print",             exec("gus-screenshot screen"))
bind("SHIFT + R",            exec("gus-record"))

-- System
bind("CTRL + Q",             exec("loginctl lock-session"))
bind("N",                    exec("gus-nightlight"))
bind("SHIFT + W",            exec(app.menu .. " wifi"))
bind("SHIFT + A",            exec(app.menu .. " sound"))
bind("SHIFT + B",            exec(app.menu .. " bluetooth"))
try("exit", function() bind("SHIFT + E", hl.dsp.exit()) end)

-- Hardware keys, also while locked
local hw = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), hw)
hl.bind("XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), hw)
hl.bind("XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",   exec("brightnessctl -e4 -n2 set 5%+"), hw)
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), hw)
hl.bind("XF86AudioPlay",         exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",        exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",         exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev",         exec("playerctl previous"), { locked = true })
