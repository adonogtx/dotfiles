#!/usr/bin/env bash
# about: Hyprland, Quickshell, lock, idle, login (Plymouth + SDDM), portals, screenshots, clipboard
source "$(dirname "$0")/lib.sh"

compositor=(hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprpolkitagent qt5-wayland qt6-wayland)
shell=(quickshell qt6-svg)
session=(hyprlock hypridle hyprsunset)
login=(plymouth sddm)
clipboard_picker_and_notifications=(fuzzel mako libnotify)
wallpaper=(swaybg)
capture=(grim slurp wf-recorder)
clipboard=(wl-clipboard cliphist)
hardware_keys=(brightnessctl playerctl)
files=(nautilus gvfs gvfs-mtp file-roller)

pac "${compositor[@]}" "${shell[@]}" "${session[@]}" "${login[@]}" "${clipboard_picker_and_notifications[@]}" \
    "${wallpaper[@]}" "${capture[@]}" "${clipboard[@]}" "${hardware_keys[@]}" "${files[@]}"

# The login is not enabled here on purpose. Hyprland and the lock must work
# from the TTY first; a display manager that starts a broken session loops.
info "Plymouth and SDDM are installed but not enabled."
info "first test start-hyprland and hyprlock, then follow docs/post-install.md (Login)"
