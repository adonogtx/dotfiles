#!/usr/bin/env bash
# about: build tools, git, yay and your home folders
source "$(dirname "$0")/lib.sh"

packages=(
  base-devel git curl wget rsync openssh
  unzip zip p7zip
  man-db man-pages less
  xdg-user-dirs
)
# Arch does not support partial upgrades: sync and upgrade everything first.
info "full system upgrade before installing anything"
sudo pacman -Sy --needed --noconfirm archlinux-keyring
sudo pacman -Su --noconfirm

pac "${packages[@]}"

if ! have yay; then
  info "building yay from the AUR"
  tmp="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
  (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

info "creating home folders"
mkdir -p \
  ~/dev ~/docs/certificates ~/dump ~/org/daily ~/backups \
  ~/media/pictures/screenshots ~/media/videos/recordings \
  ~/library/{music,books,movies,series,animes,torrents/{complete,incomplete}} \
  ~/.local/bin ~/.local/share/wallpapers
