#!/usr/bin/env bash
set -euo pipefail

# Arch Linux + i3wm bootstrap
# Run on a fresh Arch Linux installation (base system, network, locale
# and bootloader already configured by the standard Arch install steps).
# Does not overwrite dotfiles, those are linked separately with stow.
# Every pacman/yay call uses --noconfirm, so it never stops waiting for
# a [Y/n] answer. If a specific package fails to install (typo, removed
# from the repos, temporary mirror issue), it is skipped and logged at
# the end instead of stopping the whole script.

FAILED=()

install_pkgs() {
    if sudo pacman -S --needed --noconfirm "$@"; then
        return 0
    fi
    echo "warning: batch install failed, retrying package by package..."
    for pkg in "$@"; do
        if ! sudo pacman -S --needed --noconfirm "${pkg}"; then
            echo "warning: failed to install ${pkg}, skipping"
            FAILED+=("${pkg}")
        fi
    done
}

install_aur() {
    if yay -S --needed --noconfirm "$@"; then
        return 0
    fi
    echo "warning: batch aur install failed, retrying package by package..."
    for pkg in "$@"; do
        if ! yay -S --needed --noconfirm "${pkg}"; then
            echo "warning: failed to install ${pkg} (aur), skipping"
            FAILED+=("${pkg}")
        fi
    done
}

echo "==> updating system"
sudo pacman -Syu --needed --noconfirm

echo "==> core system packages"
install_pkgs \
    base-devel git stow curl wget unzip zip tar gzip rsync tree \
    ripgrep fd fzf jq less man-db man-pages which openssh neovim

echo "==> x11 + i3"
install_pkgs \
    xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xsetroot \
    xorg-xrdb xorg-setxkbmap i3-wm i3status rofi lightdm \
    lightdm-gtk-greeter picom feh arandr dunst i3lock xss-lock \
    udiskie flameshot

echo "==> desktop utilities"
install_pkgs \
    kitty firefox thunar thunar-archive-plugin file-roller \
    pavucontrol playerctl brightnessctl networkmanager \
    network-manager-applet bluez bluez-utils blueman polkit \
    polkit-gnome xclip xdg-utils

echo "==> audio stack (pipewire)"
install_pkgs pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber

echo "==> input method (fcitx5 + mozc)"
install_pkgs fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool

echo "==> fonts"
install_pkgs ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd

echo "==> development toolchain"
install_pkgs gcc make cmake pkgconf python python-pip

echo "==> docker"
install_pkgs docker docker-compose

echo "==> iwd (required by impala) and pointing NetworkManager at it"
install_pkgs iwd

sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/wifi-backend.conf >/dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
# NetworkManager starts/stops iwd itself over D-Bus with this backend set,
# so iwd.service is intentionally left disabled here (enabling both at
# once makes them fight over the wifi device).

echo "==> enabling required services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now lightdm
sudo systemctl enable --now docker

echo "==> adding current user to docker group"
sudo usermod -aG docker "${USER}"

mkdir -p "${HOME}/.config"

echo "==> installing yay (AUR helper) if missing"
if ! command -v yay >/dev/null 2>&1; then
    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "${tmp_dir}"' EXIT

    if git clone https://aur.archlinux.org/yay.git "${tmp_dir}/yay"; then
        (
            cd "${tmp_dir}/yay"
            makepkg -si --noconfirm
        ) || echo "warning: failed to build/install yay"
    else
        echo "warning: failed to clone yay"
    fi

    trap - EXIT
    rm -rf "${tmp_dir}"
fi

if command -v yay >/dev/null 2>&1; then
    echo "==> bluetui and netscanner"
    install_pkgs bluetui netscanner

    echo "==> IntelliJ IDEA Community"
    install_aur intellij-idea-community-edition

    echo "==> mise"
    if ! command -v mise >/dev/null 2>&1; then
        install_aur mise
    fi
else
    echo "warning: yay unavailable, skipping bluetui, netscanner, intellij and mise"
    FAILED+=("bluetui" "netscanner" "intellij-idea-community-edition" "mise")
fi

if command -v mise >/dev/null 2>&1; then
    echo "==> Java 21 and Maven through mise"
    mise use --global java@21
    mise use --global maven@3

    SHELL_RC="${HOME}/.bashrc"
    if ! grep -q 'mise activate bash' "${SHELL_RC}" 2>/dev/null; then
        cat >> "${SHELL_RC}" <<'EOF'

# mise
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi
EOF
    fi
fi

echo "==> Doom Emacs prerequisites"
install_pkgs emacs ripgrep fd

echo "==> cloning Doom Emacs"
if [ ! -d "${HOME}/.config/emacs" ]; then
    if ! git clone --depth 1 https://github.com/doomemacs/doomemacs "${HOME}/.config/emacs"; then
        echo "warning: failed to clone Doom Emacs"
        FAILED+=("doomemacs")
    fi
fi

echo
echo "=============================================="
echo "Base installation complete."
echo "=============================================="
echo
if [ "${#FAILED[@]}" -gt 0 ]; then
    echo "Packages that failed and were skipped:"
    printf '  - %s\n' "${FAILED[@]}"
    echo "Review manually with: sudo pacman -S <package>"
    echo
fi
echo "Next steps:"
echo
echo "1. Create your working directories and clone your dotfiles, then"
echo "   apply them with stow"
echo "2. Run ~/.config/emacs/bin/doom sync"
echo "3. Log out/in so the docker group, fcitx5 and the NetworkManager"
echo "   iwd backend take effect"
echo "4. Verify: i3 --version, docker --version, docker compose version,"
echo "   mise --version, java -version, mvn -version, wpctl status,"
echo "   fcitx5-diagnose | head -20"
