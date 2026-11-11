#!/usr/bin/env bash
# Shows the installed Plymouth theme without rebooting: the phrase fades in, the
# password field appears, then a wrong password message, then the splash quits.
# Run it from a text console (Ctrl + Alt + F3); it does not change the theme or
# the initramfs. Back to the desktop with Ctrl + Alt + F1 (or F2).
set -euo pipefail

echo "Plymouth test: after about 2 s the field appears. Type anything and press Enter."
sudo sh -c 'plymouthd; plymouth show-splash; sleep 2; plymouth ask-for-password --prompt=test >/dev/null; plymouth display-message --text="Wrong password"; sleep 3; plymouth quit'
