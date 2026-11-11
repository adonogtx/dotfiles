-- Gus · Hyprland, Lua config (Hyprland 0.55 and later).
-- Copy this folder to ~/.config/hypr. Each concern lives in its own module;
-- comment out a line in `modules` to switch that part off.

-- A broken module must not take the others down (no binds, no pill).
-- Each one loads in protected mode; errors are collected and shown as a
-- notification once the desktop is up. Read them with: hyprctl configerrors
GUS_CONFIG_ERRORS = {}

local modules = {
  "modules.monitors",
  "modules.env",
  "modules.look",
  "modules.input",
  "modules.rules",
  "modules.binds",
  "modules.autostart",
}

for _, name in ipairs(modules) do
  local ok, err = pcall(require, name)
  if not ok then
    table.insert(GUS_CONFIG_ERRORS, name .. ": " .. tostring(err))
  end
end

if #GUS_CONFIG_ERRORS > 0 then
  local text = table.concat(GUS_CONFIG_ERRORS, "\n"):gsub("'", "")
  print(text)
  hl.on("hyprland.start", function()
    hl.exec_cmd("sleep 3 && notify-send -u critical 'Hyprland config' '" .. text .. "'")
  end)
end
