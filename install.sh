#!/usr/bin/env bash
# Installer. Installs packages by category. It never touches your configs:
# copy each folder under config/ by hand (see README.md).
set -euo pipefail
cd "$(dirname "$0")"
source install/lib.sh

MODULES=(base system desktop fonts icons japanese terminal backend editors apps)

usage() {
  cat <<USAGE
usage: ./install.sh <module>... | all

modules (run in this order on a fresh system):
$(for m in "${MODULES[@]}"; do printf '  %-10s %s\n' "$m" "$(sed -n 's/^# about: //p' "install/$m.sh")"; done)
USAGE
}

[[ $EUID -eq 0 ]] && die "run as your user, not root (sudo is called when needed)"
[[ $# -eq 0 ]] && { usage; exit 0; }
[[ $1 == all ]] && set -- "${MODULES[@]}"

for m in "$@"; do
  [[ $m =~ ^[a-z]+$ && -f install/$m.sh ]] || die "unknown module: $m"
done
for m in "$@"; do
  step "module: $m"
  bash "install/$m.sh"
done
step "done. next: copy the configs you want (README.md, section Configs)"
