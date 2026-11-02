-- Hyprland · gus
-- Pure Arch, no Omarchy. Gruvbox, no transparency, keyboard first.
-- Wiki: https://wiki.hypr.land/Configuring/Start/

-- Let require("hypr.x") find the files next to this one
local home = os.getenv("HOME")
for module in pairs(package.loaded) do
  if module == "hypr" or module:sub(1, 5) == "hypr." then package.loaded[module] = nil end
end
package.path = home .. "/.config/?.lua;" .. package.path

require("hypr.env")
require("hypr.monitors")
require("hypr.input")
require("hypr.looknfeel")
require("hypr.rules")
require("hypr.bindings")
require("hypr.autostart")

-- Machine specific overrides that never go into the repo
local ok_local = io.open(home .. "/.config/hypr/local.lua", "r")
if ok_local then ok_local:close(); require("hypr.local") end
