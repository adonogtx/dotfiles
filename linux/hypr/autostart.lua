-- Started once, when Hyprland starts

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("qs -d")
  hl.exec_cmd("mako")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("swaybg -m fill -i " .. os.getenv("HOME") .. "/.config/gus/wallpapers/enso.png")
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("udiskie --automount --notify --no-tray")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("wl-paste --watch cliphist store")
end)
