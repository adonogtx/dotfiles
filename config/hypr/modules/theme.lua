-- Gruvbox system tokens shared by every module. Same values as quickshell/Theme.qml.
return {
  border          = "rgba(504945ff)",   -- inactive window hairline (line)
  border_active   = "rgba(7c6f64ff)",   -- focused window hairline (tertiary)
  shadow          = 0x4d000000,         -- 30% black
  wallpaper       = os.getenv("HOME") .. "/.local/share/wallpapers/light-solid.png",  -- until the Gruvbox wallpaper is chosen
}
