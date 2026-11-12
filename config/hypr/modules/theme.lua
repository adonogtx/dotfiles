-- Gruvbox system tokens shared by every module. Same values as quickshell/Theme.qml.

-- The wallpaper chosen with gus-wallpaper (a link), or light-solid.png when there is none
-- or it points to a missing file.
local walls = os.getenv("HOME") .. "/.local/share/wallpapers/"
local function wallpaper()
  local f = io.open(walls .. "current", "r")
  if f then f:close() return walls .. "current" end
  return walls .. "light-solid.png"
end

return {
  border          = "rgba(504945ff)",   -- inactive window hairline (line)
  border_active   = "rgba(7c6f64ff)",   -- focused window hairline (tertiary)
  shadow          = 0x4d000000,         -- 30% black
  wallpaper       = wallpaper(),        -- gus-wallpaper's choice, light-solid.png as fallback
}
