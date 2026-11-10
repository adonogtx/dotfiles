#!/usr/bin/env bash
# Shared helpers. Sourced by install.sh and every module, never run directly.
set -euo pipefail

step() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }
info() { printf '\033[1;34m  ->\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# Official repos only.
pac() { sudo pacman -S --needed --noconfirm "$@"; }

# AUR (or packages whose repo may change): yay shows the PKGBUILD diff and asks,
# on purpose. Read it before you accept.
aur() {
  command -v yay >/dev/null || die "yay is missing, run ./install.sh base first"
  yay -S --needed "$@"
}

enable_system() { sudo systemctl enable --now "$@"; }
enable_user()   { systemctl --user enable "$@"; }

have() { command -v "$1" >/dev/null 2>&1; }
