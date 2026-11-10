#!/usr/bin/env bash
# about: Emacs (pgtk, Wayland) and Doom Emacs
source "$(dirname "$0")/lib.sh"

emacs=(emacs-wayland)
doom_deps=(git ripgrep fd)
pac "${emacs[@]}" "${doom_deps[@]}"

if [[ ! -d ~/.config/emacs ]]; then
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
fi

# No systemd unit for the Emacs daemon: started before Hyprland it would miss
# WAYLAND_DISPLAY. Super + D runs emacsclient -a '', which starts it on demand.

if [[ -d ~/.config/doom ]]; then
  info "your Doom config is in place, running doom sync"
  ~/.config/emacs/bin/doom sync
else
  warn "copy config/doom to ~/.config/doom, then run: ~/.config/emacs/bin/doom install"
fi
