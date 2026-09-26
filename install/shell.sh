#!/usr/bin/env bash
# Shell: zsh + oh my zsh. The .zshrc itself comes from zsh/, linked by
# links.sh, so the oh my zsh installer is told to keep it untouched.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "zsh"
install_pkgs zsh

step "oh my zsh"
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    # Downloaded first: with `sh -c "$(curl ...)"` a failed download runs
    # an empty script and looks like success.
    installer="$(mktemp)"
    if curl -fsSL -o "${installer}" \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh &&
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh "${installer}"; then
        :
    else
        warn "failed to install oh my zsh"
        fail "oh-my-zsh"
    fi
    rm -f "${installer}"
fi
