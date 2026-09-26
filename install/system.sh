#!/usr/bin/env bash
# Base system: full update, core cli tools and yay (AUR helper).

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

# An outdated keyring makes the whole update fail on signature errors,
# so it is refreshed first (the documented exception to partial updates).
step "updating keyring"
sudo pacman -Sy --needed --noconfirm archlinux-keyring

step "updating system"
sudo pacman -Su --noconfirm

step "core system packages"
install_pkgs \
    base-devel git curl wget unzip zip tar gzip rsync tree \
    ripgrep fd fzf jq less man-db man-pages which openssh neovim

mkdir -p "${HOME}/.config"

step "installing yay (AUR helper) if missing"
if ! command -v yay >/dev/null 2>&1; then
    tmp_dir="$(mktemp -d)"

    if git clone https://aur.archlinux.org/yay.git "${tmp_dir}/yay"; then
        (
            cd "${tmp_dir}/yay"
            makepkg -si --noconfirm
        ) || { warn "failed to build/install yay"; fail "yay"; }
    else
        warn "failed to clone yay"
        fail "yay"
    fi

    rm -rf "${tmp_dir}"
fi
