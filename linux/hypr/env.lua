-- Environment for every app started inside Hyprland

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Japanese input (fcitx5 + mozc) in GTK, Qt and X apps
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. (os.getenv("PATH") or "/usr/local/bin:/usr/bin"))

hl.config({
  xwayland = { force_zero_scaling = true },
  ecosystem = { no_update_news = true, no_donation_nag = true },
})
