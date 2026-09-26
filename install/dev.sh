#!/usr/bin/env bash
# Development: toolchain, docker, IntelliJ IDEA and Java/Maven through mise.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
keep_sudo

step "development toolchain"
install_pkgs gcc make cmake pkgconf python python-pip

step "docker"
install_pkgs docker docker-compose
enable_service docker

step "adding current user to docker group"
if getent group docker >/dev/null; then
    sudo usermod -aG docker "$(id -un)"
else
    warn "docker group missing, skipping"
    fail "docker group"
fi

step "IntelliJ IDEA Community"
install_pkgs intellij-idea-community-edition

step "mise"
install_pkgs mise

# mise activation lives in bash/.bashrc and zsh/.zshrc, linked by links.sh.
if command -v mise >/dev/null 2>&1; then
    step "Java 21 and Maven through mise"
    for tool in java@21 maven@3; do
        if ! mise use --global "${tool}"; then
            warn "failed to install ${tool} through mise"
            fail "mise: ${tool}"
        fi
    done
fi
