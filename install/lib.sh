#!/usr/bin/env bash
# Shared helpers, sourced by install.sh and by every install/*.sh script.
# Every pacman/yay call uses --noconfirm, so it never stops waiting for
# a [Y/n] answer. If a specific package fails to install (typo, removed
# from the repos, temporary mirror issue), it is skipped and logged at
# the end instead of stopping the whole run.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Everything lands in $HOME and makepkg refuses to run as root, so this
# must run as the normal user, with sudo available.
if [ "${EUID}" -eq 0 ]; then
    echo "error: run as your normal user, not root (sudo is called when needed)"
    exit 1
fi

# Failures are written to a shared file so install.sh can print a single
# summary after running every category in its own process. When a
# category script is run on its own, it owns the file and the summary.
if [ -z "${FAILED_LOG:-}" ]; then
    FAILED_LOG="$(mktemp)"
    export FAILED_LOG
    trap 'cleanup' EXIT
fi

step() {
    echo "==> $*"
}

warn() {
    echo "warning: $*"
}

fail() {
    echo "$1" >> "${FAILED_LOG}"
}

install_pkgs() {
    if sudo pacman -S --needed --noconfirm "$@"; then
        return 0
    fi
    warn "batch install failed, retrying package by package..."
    for pkg in "$@"; do
        if ! sudo pacman -S --needed --noconfirm "${pkg}"; then
            warn "failed to install ${pkg}, skipping"
            fail "${pkg}"
        fi
    done
}

install_aur() {
    if ! command -v yay >/dev/null 2>&1; then
        warn "yay unavailable, skipping $*"
        for pkg in "$@"; do
            fail "${pkg}"
        done
        return 0
    fi
    if yay -S --needed --noconfirm "$@"; then
        return 0
    fi
    warn "batch aur install failed, retrying package by package..."
    for pkg in "$@"; do
        if ! yay -S --needed --noconfirm "${pkg}"; then
            warn "failed to install ${pkg} (aur), skipping"
            fail "${pkg}"
        fi
    done
}

# sudo forgets the password after 5 minutes, and long steps (system
# update, intellij download, building yay) would leave the run stopped
# at a password prompt. Asks once and keeps it fresh until the run ends.
keep_sudo() {
    if [ -n "${SUDO_KEEPALIVE:-}" ]; then
        return 0
    fi
    if ! command -v sudo >/dev/null 2>&1; then
        echo "error: sudo is not installed, install it and add your user to wheel"
        exit 1
    fi
    sudo -v
    (
        while kill -0 "$$" 2>/dev/null; do
            sudo -n true || true
            sleep 50
        done
    ) >/dev/null 2>&1 &
    SUDO_KEEPALIVE="$!"
    export SUDO_KEEPALIVE
    SUDO_KEEPALIVE_OWNER=1
}

# Only enables, never starts: starting services mid-run can drop the
# network (NetworkManager) or fail after a kernel update (docker), and a
# reboot is needed anyway. A missing unit is logged instead of stopping.
enable_service() {
    if ! sudo systemctl enable "$1"; then
        warn "failed to enable $1"
        fail "service: $1"
    fi
}

cleanup() {
    if [ -n "${SUDO_KEEPALIVE_OWNER:-}" ]; then
        kill "${SUDO_KEEPALIVE}" 2>/dev/null || true
    fi
    summary
    rm -f "${FAILED_LOG}"
}

summary() {
    if [ -s "${FAILED_LOG}" ]; then
        echo
        echo "Packages and steps that failed and were skipped:"
        sed 's/^/  - /' "${FAILED_LOG}"
        echo "Review manually with: sudo pacman -S <package>"
    fi
}
