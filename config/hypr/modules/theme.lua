-- Dark Solid tokens shared by every module. Same values as quickshell/Theme.qml.
return {
  border          = "rgba(ffffff12)",   -- inactive window hairline
  border_active   = "rgba(ffffff2e)",   -- focused window hairline
  shadow          = 0x73000000,         -- 45% black
  wallpaper       = os.getenv("HOME") .. "/.local/share/wallpapers/dark-solid.png",
}
