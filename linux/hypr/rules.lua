-- Window and layer rules

-- Small tools float in the middle
for _, class in ipairs({ "org.pulseaudio.pavucontrol", "nm-connection-editor", "blueman-manager", "org.gnome.Calculator", "gus.float" }) do
  hl.window_rule({ match = { class = class }, float = true, center = true, size = "900 600" })
end

-- The terminal windows opened by keiko and the day rituals
hl.window_rule({ match = { class = "gus.ritual" }, float = true, center = true, size = "860 620" })

-- File pickers
hl.window_rule({ match = { title = "(Open|Save) (File|Files|Folder)" }, float = true, center = true })

-- Picture in picture stays on top in the corner
hl.window_rule({ match = { title = "Picture.in.[Pp]icture" }, float = true, pin = true, size = "480 270", move = "100%-500 100%-300" })

-- Bar, notifications and launcher appear without sliding
hl.layer_rule({ match = { namespace = "^(quickshell|notifications|launcher)$" }, no_anim = true })
