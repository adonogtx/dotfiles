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

info "creating home folders (docs/apps.md, Folders)"
mkdir -p \
  ~/dev/{backend,website} \
  ~/docs/{career,health,japanese,notes,personal} \
  ~/media/{courses,library,pictures,videos} \
  ~/media/library/{music,books,movies,series,animes,torrents/{complete,incomplete}} \
  ~/media/pictures/screenshots ~/media/videos/recordings \
  ~/archive/{backups,"$(date +%Y)"} \
  ~/dump \
  ~/.local/bin ~/.local/share/wallpapers
# Doom capture target; leaves with the Doom and org decision.
mkdir -p ~/org/daily
