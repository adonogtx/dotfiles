#!/usr/bin/env bash
# about: icon theme, cursor and GTK dark theme
source "$(dirname "$0")/lib.sh"

gtk=(gnome-themes-extra adwaita-icon-theme)   # Adwaita-dark for GTK 3
pac "${gtk[@]}"

aur whitesur-icon-theme apple_cursor  # icons and cursor

info "apply with: gsettings set org.gnome.desktop.interface color-scheme prefer-dark (see docs/post-install.md)"
