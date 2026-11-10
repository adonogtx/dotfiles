-- Window rules. Everything tiles except small tools and dialogs.

hl.window_rule({
  name  = "suppress-maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Dialogs and pickers.
hl.window_rule({ name = "float-file-roller", match = { class = "^org\\.gnome\\.FileRoller$" }, float = true })
hl.window_rule({ name = "float-portal",      match = { class = "^xdg-desktop-portal-gtk$" },   float = true })
hl.window_rule({ name = "float-polkit",      match = { class = "^hyprpolkitagent$" },          float = true })
hl.window_rule({ name = "float-bitwarden",   match = { class = "^Bitwarden$" },                float = true })

-- Brave picture in picture stays small and floating.
hl.window_rule({ name = "float-pip", match = { title = "^Picture.in.Picture$" }, float = true })

-- XWayland drag fix from the upstream example.
hl.window_rule({
  name  = "fix-xwayland-drags",
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})
