#!/usr/bin/env bash
# X11 + i3 desktop: window manager, login manager, utilities and fonts.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "x11 + i3"
install_pkgs \
    xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xsetroot \
    xorg-xrdb xorg-setxkbmap i3-wm i3status rofi lightdm \
    lightdm-gtk-greeter picom feh arandr dunst i3lock xss-lock \
    udiskie flameshot autotiling

step "desktop utilities"
install_pkgs \
    kitty firefox thunar thunar-archive-plugin file-roller \
    pavucontrol playerctl brightnessctl polkit polkit-gnome \
    xclip xdg-utils

step "fonts"
install_pkgs ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd

step "enabling lightdm"
enable_service lightdm
