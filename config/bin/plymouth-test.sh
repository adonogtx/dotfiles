#!/usr/bin/env bash
# Shows the installed Plymouth theme without rebooting: the logo fades in, the
# password field appears. The first password counts as wrong: the field gives way
# to the bar, then comes back with the error border and no dots. After the second
# password the bar stays for 6 s (its segments light one after another in a loop),
# then the splash quits.
# Run it from a text console (Ctrl + Alt + F3); it does not change the theme or
# the initramfs. Back to the desktop with Ctrl + Alt + F1 (or F2).
set -euo pipefail

echo "Plymouth test: after about 2 s the field appears. Type anything and press Enter, twice."
sudo sh -c 'plymouthd; plymouth show-splash; sleep 2; plymouth ask-for-password --prompt=test >/dev/null; sleep 1.5; plymouth ask-for-password --prompt=test >/dev/null; sleep 6; plymouth quit'
