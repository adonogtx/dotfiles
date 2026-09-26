#!/usr/bin/env bash
# Links every file inside each package directory into $HOME, keeping the
# same relative path (i3/.config/i3/config -> ~/.config/i3/config).
# Files already in place that are not links are moved to
# <file>.backup-<timestamp> first, nothing is deleted.
# Usage: install/links.sh [package...]   (default: every package below)

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

PACKAGES=(bash zsh x11 i3 i3status dunst picom rofi kitty fcitx5)

if [ "$#" -gt 0 ]; then
    PACKAGES=("$@")
fi

stamp="$(date +%Y%m%d%H%M%S)"

# Old stow installs may have linked a whole directory into the repo
# (~/.config/i3 -> dotfiles/i3/.config/i3). Linking a file through it
# would overwrite the repo file itself, so those are replaced by real
# directories first.
unfold_parents() {
    local dir="$1"
    while [ "${dir}" != "${HOME}" ] && [ "${dir}" != "/" ]; do
        if [ -L "${dir}" ] && [[ "$(readlink -f "${dir}")" == "${DOTFILES}"/* ]]; then
            rm "${dir}" || return 1
        fi
        dir="$(dirname "${dir}")"
    done
}

link_file() {
    local src="$1" dst="$2"

    unfold_parents "$(dirname "${dst}")" || return 1
    mkdir -p "$(dirname "${dst}")" || return 1

    if [ -e "${dst}" ] && [ ! -L "${dst}" ]; then
        mv "${dst}" "${dst}.backup-${stamp}" || return 1
        echo "    backup: ${dst}.backup-${stamp}"
    fi

    ln -sfn "${src}" "${dst}" || return 1
    echo "    ${dst} -> ${src}"
}

for pkg in "${PACKAGES[@]}"; do
    if [ ! -d "${DOTFILES}/${pkg}" ]; then
        warn "package ${pkg} not found, skipping"
        fail "links: ${pkg}"
        continue
    fi

    step "linking ${pkg}"
    while IFS= read -r -d '' src; do
        dst="${HOME}/${src#"${DOTFILES}/${pkg}/"}"
        if ! link_file "${src}" "${dst}"; then
            warn "failed to link ${dst}"
            fail "links: ${dst}"
        fi
    done < <(find "${DOTFILES}/${pkg}" -type f -print0 | sort -z)
done
