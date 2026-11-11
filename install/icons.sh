#!/usr/bin/env bash
# about: icon theme, cursor and GTK light theme
source "$(dirname "$0")/lib.sh"

gtk=(gnome-themes-extra adwaita-icon-theme)   # Adwaita for GTK 3 (Adwaita-dark only as a fallback)
pac "${gtk[@]}"

aur whitesur-icon-theme apple_cursor  # icons and cursor

info "apply with: gsettings set org.gnome.desktop.interface color-scheme prefer-light (see docs/post-install.md)"
