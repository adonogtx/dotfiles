#!/usr/bin/env bash
# Shows the installed Plymouth theme without rebooting: the photo, then the
# password field fades in. The first password counts as wrong: the dots give way to
# the loading bar inside the field, then the bar fades out, the error border shows and
# the dots start again from none. After the second password the bar runs for 6 s, then
# the splash quits.
# Run it from a text console (Ctrl + Alt + F3); it does not change the theme or
# the initramfs. Back to the desktop with Ctrl + Alt + F1 (or F2).
set -euo pipefail

echo "Plymouth test: after about 2 s the field appears. Type anything and press Enter, twice."
sudo sh -c 'plymouthd; plymouth show-splash; sleep 2; plymouth ask-for-password --prompt=test >/dev/null; sleep 1.5; plymouth ask-for-password --prompt=test >/dev/null; sleep 6; plymouth quit'
