#!/usr/bin/env bash
# Doom Emacs: prerequisites and clone. Run `doom sync` afterwards.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "Doom Emacs prerequisites"
install_pkgs emacs ripgrep fd

step "cloning Doom Emacs"
if [ ! -d "${HOME}/.config/emacs" ]; then
    if ! git clone --depth 1 https://github.com/doomemacs/doomemacs "${HOME}/.config/emacs"; then
        warn "failed to clone Doom Emacs"
        fail "doomemacs"
    fi
fi
