#!/usr/bin/env bash
# Arch Linux + i3wm install
# Run on a fresh Arch Linux installation (base system, network, locale
# and bootloader already configured by the standard Arch install steps),
# from inside the cloned repo.
# Runs every category in install/ in order, or only the ones given:
#   ./install.sh               everything
#   ./install.sh dev links     only dev and links

source "$(dirname "${BASH_SOURCE[0]}")/install/lib.sh"

CATEGORIES=(system network desktop audio input dev shell emacs links)

if [ "$#" -gt 0 ]; then
    CATEGORIES=("$@")
fi

for category in "${CATEGORIES[@]}"; do
    if [ "${category}" = "lib" ] || [ ! -f "${DOTFILES}/install/${category}.sh" ]; then
        echo "unknown category: ${category}"
        echo "available: $(basename -s .sh "${DOTFILES}"/install/*.sh | grep -vx lib | xargs)"
        exit 1
    fi
done

if [ "${CATEGORIES[*]}" != "links" ]; then
    keep_sudo
fi

# A category that stops early is logged and the next one still runs.
# Only system is fatal: installing packages after a failed update would
# be a partial upgrade, which can break the system.
for category in "${CATEGORIES[@]}"; do
    if ! bash "${DOTFILES}/install/${category}.sh"; then
        if [ "${category}" = "system" ]; then
            echo "error: system update failed, stopping to avoid a partial upgrade"
            exit 1
        fi
        warn "category ${category} stopped early"
        fail "category: ${category}"
    fi
done

echo
echo "=============================================="
echo "Installation finished: ${CATEGORIES[*]}"
echo "=============================================="
echo
echo "Next steps:"
echo
echo "1. Run ~/.config/emacs/bin/doom sync"
echo "2. Make zsh the default shell: chsh -s /usr/bin/zsh"
echo "3. Reboot so lightdm, NetworkManager with the iwd backend, docker,"
echo "   the docker group and fcitx5 take effect"
echo "4. Verify: i3 --version, docker --version, docker compose version,"
echo "   mise --version, java -version, mvn -version, wpctl status,"
echo "   fcitx5-diagnose | head -20"
