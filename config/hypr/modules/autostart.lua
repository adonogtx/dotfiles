-- Started once when Hyprland starts.
local t = require("modules.theme")

hl.on("hyprland.start", function()
  hl.exec_cmd("swaybg -m fill -i " .. t.wallpaper)
  hl.exec_cmd("quickshell")
  hl.exec_cmd("mako")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("fcitx5 -d --replace")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all && systemctl --user start hyprpolkitagent")
  -- Keep only the last 50 copies. Super + Shift + C wipes the history.
  hl.exec_cmd("wl-paste --watch cliphist -max-items 50 store")
end)
