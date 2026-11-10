#!/usr/bin/env bash
# about: Java via sdkman, Maven, Gradle, Docker, PostgreSQL, DBeaver, IntelliJ, API tools
source "$(dirname "$0")/lib.sh"

ide=(intellij-idea-oss)                  # IntelliJ IDEA, open source build from the Arch repos
containers=(docker docker-compose docker-buildx)
database=(postgresql dbeaver)
pac "${ide[@]}" "${containers[@]}" "${database[@]}"

aur bruno-bin               # Bruno API client

# Java toolchain through sdkman, kept in XDG data.
export SDKMAN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sdkman"
if [[ ! -d $SDKMAN_DIR ]]; then
  info "installing sdkman (official script)"
  curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash
fi
# Answer sdkman prompts automatically (e.g. "set as default?").
sed -i 's/^sdkman_auto_answer=false/sdkman_auto_answer=true/' "$SDKMAN_DIR/etc/config"
set +eu                                   # sdkman is not errexit or nounset safe
source "$SDKMAN_DIR/bin/sdkman-init.sh"
sdk install java                          # default Temurin build
sdk install maven
sdk install gradle
set -eu
[[ -x $SDKMAN_DIR/candidates/java/current/bin/java ]] || warn "Java did not install through sdkman; run: sdk install java"

# Docker: socket activation, starts on first use.
enable_system docker.socket
if ! id -nG "$USER" | grep -qw docker; then
  warn "adding $USER to the docker group. This group is equivalent to root; log out and back in to apply."
  sudo usermod -aG docker "$USER"
fi

# PostgreSQL: initialize the cluster once.
if [[ ! -f /var/lib/postgres/data/PG_VERSION ]]; then
  info "initializing PostgreSQL"
  # peer for local sockets, passwords for TCP. initdb's default would be "trust".
  sudo -iu postgres initdb -D /var/lib/postgres/data --locale=C.UTF-8 --encoding=UTF8 \
    --auth-local=peer --auth-host=scram-sha-256
fi
enable_system postgresql
info "create your role once: sudo -iu postgres createuser --createdb --pwprompt $USER"
warn "PostgreSQL major upgrades need pg_upgrade; read docs/post-install.md (PostgreSQL) before a pacman -Syu that bumps it"
