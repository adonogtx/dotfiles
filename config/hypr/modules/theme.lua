-- Light Solid tokens shared by every module. Same values as quickshell/Theme.qml.
return {
  border          = "rgba(e0e0e4ff)",   -- inactive window hairline (line)
  border_active   = "rgba(aeaeb2ff)",   -- focused window hairline (tertiary)
  shadow          = 0x1f000000,         -- 12% black
  wallpaper       = os.getenv("HOME") .. "/.local/share/wallpapers/light-solid.png",
}
