#!/usr/bin/env bash
set -euo pipefail

# Arch Linux + i3wm bootstrap
# Reconstructs the user's known development/workstation setup.
# Run on a fresh Arch Linux installation (base system, network, locale
# and bootloader already configured by the standard Arch install steps).
#
# IMPORTANT:
# - This installs packages and creates the expected directory structure.
# - It does NOT overwrite existing dotfiles.
# - Your personal dotfiles should be linked/copied/stowed separately.
# - Packages removed from the user's setup (polybar, fastfetch, lilex, ly,
#   betterlockscreen) are intentionally NOT installed.
# - Fully unattended: every pacman/yay call uses --noconfirm, so it will
#   not stop waiting for a [Y/n] answer.

DOTFILES_DIR="${HOME}/dev/dotfiles"
NOTES_DIR="${HOME}/docs/notes"
BACKEND_DIR="${HOME}/dev/backend/projects"

echo "==> Updating system"
sudo pacman -Syu --needed --noconfirm

echo "==> Installing core system packages"
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    stow \
    curl \
    wget \
    unzip \
    zip \
    tar \
    gzip \
    rsync \
    tree \
    ripgrep \
    fd \
    fzf \
    jq \
    less \
    man-db \
    man-pages \
    which \
    openssh \
    neovim

echo "==> Installing X11 + i3 desktop"
sudo pacman -S --needed --noconfirm \
    xorg-server \
    xorg-xinit \
    xorg-xrandr \
    xorg-xset \
    xorg-xsetroot \
    xorg-xrdb \
    xorg-setxkbmap \
    i3-wm \
    i3status \
    rofi \
    lightdm \
    lightdm-gtk-greeter \
    picom \
    feh \
    arandr \
    dunst \
    i3lock \
    xss-lock \
    udiskie \
    flameshot

echo "==> Installing desktop utilities"
sudo pacman -S --needed --noconfirm \
    kitty \
    firefox \
    thunar \
    thunar-archive-plugin \
    file-roller \
    pavucontrol \
    playerctl \
    brightnessctl \
    networkmanager \
    network-manager-applet \
    bluez \
    bluez-utils \
    blueman \
    polkit \
    polkit-gnome \
    xclip \
    xdg-utils

echo "==> Installing audio stack (pipewire)"
sudo pacman -S --needed --noconfirm \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    wireplumber

echo "==> Installing input method (fcitx5 + mozc, per fcitx5/profile)"
sudo pacman -S --needed --noconfirm \
    fcitx5 \
    fcitx5-mozc \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-configtool

echo "==> Installing fonts"
sudo pacman -S --needed --noconfirm \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji \
    ttf-jetbrains-mono-nerd

echo "==> Installing development toolchain"
sudo pacman -S --needed --noconfirm \
    gcc \
    make \
    cmake \
    pkgconf \
    python \
    python-pip

echo "==> Installing Docker"
sudo pacman -S --needed --noconfirm \
    docker \
    docker-compose

echo "==> Installing iwd (required by impala) and pointing NetworkManager at it"
sudo pacman -S --needed --noconfirm iwd

sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/wifi-backend.conf >/dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
# NetworkManager itself starts/stops iwd over D-Bus with this backend set,
# so iwd.service is intentionally left disabled here (enabling both at
# once causes them to fight over the wifi device).

echo "==> Enabling required services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now lightdm
sudo systemctl enable --now docker

echo "==> Adding current user to docker group"
sudo usermod -aG docker "${USER}"

echo "==> Creating user's working directories"
mkdir -p \
    "${HOME}/dev" \
    "${DOTFILES_DIR}" \
    "${NOTES_DIR}" \
    "${BACKEND_DIR}" \
    "${HOME}/.config"

echo "==> Installing yay (AUR helper) if missing"
if ! command -v yay >/dev/null 2>&1; then
    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "${tmp_dir}"' EXIT

    git clone https://aur.archlinux.org/yay.git "${tmp_dir}/yay"
    (
        cd "${tmp_dir}/yay"
        makepkg -si --noconfirm
    )

    trap - EXIT
    rm -rf "${tmp_dir}"
fi

echo "==> Installing bluetui and netscanner (used in i3 keybinds)"
sudo pacman -S --needed --noconfirm bluetui netscanner

echo "==> Installing IntelliJ IDEA Community"
yay -S --needed --noconfirm intellij-idea-community-edition

echo "==> Installing mise"
if ! command -v mise >/dev/null 2>&1; then
    yay -S --needed --noconfirm mise
fi

echo "==> Installing Java 21 and Maven through mise"
mise use --global java@21
mise use --global maven@3

echo "==> Preparing shell configuration for mise"
SHELL_RC="${HOME}/.bashrc"

if ! grep -q 'mise activate bash' "${SHELL_RC}" 2>/dev/null; then
    cat >> "${SHELL_RC}" <<'EOF'

# mise
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi
EOF
fi

echo "==> Installing Doom Emacs prerequisites"
sudo pacman -S --needed --noconfirm \
    emacs \
    ripgrep \
    fd

echo "==> Installing Doom Emacs"
if [ ! -d "${HOME}/.config/emacs" ]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs "${HOME}/.config/emacs"
fi

echo
echo "=============================================="
echo "Base installation complete."
echo "=============================================="
echo
echo "Known paths:"
echo "  Dotfiles : ${DOTFILES_DIR}"
echo "  Org      : ${NOTES_DIR}"
echo "  Backend  : ${BACKEND_DIR}"
echo
echo "Next steps:"
echo
echo "1. Put your dotfiles in:"
echo "   ${DOTFILES_DIR}"
echo
echo "2. Apply them with GNU Stow, according to your repo structure."
echo
echo "3. Run Doom Emacs sync (config comes from your dotfiles):"
echo "   ~/.config/emacs/bin/doom sync"
echo
echo "4. Log out/in before using Docker without sudo, and so fcitx5"
echo "   and the wifi.backend=iwd change take effect."
echo
echo "5. Verify:"
echo "   i3 --version"
echo "   emacs --version"
echo "   git --version"
echo "   docker --version"
echo "   docker compose version"
echo "   mise --version"
echo "   java -version"
echo "   mvn -version"
echo "   wpctl status"
echo "   fcitx5-diagnose | head -20"
echo
echo "NOTE:"
echo "This script intentionally does not install old/removed components:"
echo "  polybar, fastfetch, lilex, ly, betterlockscreen"
echo
echo "NOTE:"
echo "alacritty and dmenu were dropped from this script: your i3 config"
echo "uses kitty and rofi instead, so they were replaced accordingly."
