#!/usr/bin/env bash
# about: network, audio, bluetooth, power, firewall, snapshots, Intel drivers
source "$(dirname "$0")/lib.sh"

network=(networkmanager)
audio=(pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber sof-firmware)
bluetooth=(bluez bluez-utils)
power=(power-profiles-daemon upower acpi)
security=(ufw)
snapshots=(snapper snap-pac)
maintenance=(reflector pacman-contrib fwupd)
intel_gpu=(mesa vulkan-intel intel-media-driver)  # ThinkPad T14 Gen 2i, Iris Xe

pac "${network[@]}" "${audio[@]}" "${bluetooth[@]}" "${power[@]}" \
    "${security[@]}" "${snapshots[@]}" "${maintenance[@]}" "${intel_gpu[@]}"

enable_system NetworkManager bluetooth power-profiles-daemon
enable_system paccache.timer   # keeps the last 3 versions of each package

info "firewall: deny incoming, allow outgoing"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
enable_system ufw

# ssh-agent (openssh, from base.sh) starts on demand from its socket;
# config/hypr/modules/env.lua points SSH_AUTH_SOCK at it (docs/base.md, Security).
enable_user ssh-agent.socket

if [[ ! -f /etc/snapper/configs/root ]]; then
  warn "snapper has no root config yet. Set it up by hand once, see docs/post-install.md (Snapshots)."
fi

aur limine-mkinitcpio-hook limine-snapper-sync
