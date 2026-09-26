#!/usr/bin/env bash
# Audio stack (pipewire).

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "audio stack (pipewire)"
install_pkgs pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
