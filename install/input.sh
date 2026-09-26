#!/usr/bin/env bash
# Input method (fcitx5 + mozc).

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "input method (fcitx5 + mozc)"
install_pkgs fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool
