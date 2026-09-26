#!/usr/bin/env bash
# Network and bluetooth: NetworkManager with the iwd backend, impala,
# bluetui and netscanner.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "networkmanager + bluetooth"
install_pkgs \
    networkmanager network-manager-applet bluez bluez-utils blueman

step "iwd + impala and pointing NetworkManager at it"
install_pkgs iwd impala

sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/wifi-backend.conf >/dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
# NetworkManager starts/stops iwd itself over D-Bus with this backend set,
# so iwd.service is disabled here (enabling both at once makes them fight
# over the wifi device). Nothing is stopped now, so the current connection
# keeps working until the reboot.
if systemctl is-enabled --quiet iwd 2>/dev/null; then
    sudo systemctl disable iwd || warn "failed to disable iwd"
fi

step "bluetui and netscanner"
install_pkgs bluetui netscanner

step "enabling NetworkManager"
enable_service NetworkManager
