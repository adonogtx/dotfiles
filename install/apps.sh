#!/usr/bin/env bash
# about: Brave, zathura, mpv with uosc, mpd with rmpc, imv, Anki, Bitwarden, Discord
source "$(dirname "$0")/lib.sh"

pdf=(zathura zathura-pdf-mupdf)
video=(mpv)
music=(mpd rmpc)
images=(imv)
everyday=(bitwarden discord)
pac "${pdf[@]}" "${video[@]}" "${music[@]}" "${images[@]}" "${everyday[@]}"

aur brave-bin mpv-uosc mpd-mpris anki-bin

mkdir -p ~/.local/share/mpd/playlists ~/.local/state/mpd
enable_user mpd
enable_user mpd-mpris || warn "mpd-mpris has no user unit here; start it from Hyprland autostart instead"
