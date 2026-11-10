-- Environment for every app started by Hyprland.
hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- fcitx5 on Wayland: GTK and Qt use the Wayland text input protocol,
-- XWayland apps use XMODIFIERS. Do not set GTK_IM_MODULE.
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")
