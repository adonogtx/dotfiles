#!/usr/bin/env bash
# about: Ghostty, zsh with oh my zsh, and everyday CLI tools
source "$(dirname "$0")/lib.sh"

terminal=(ghostty)
shell=(zsh)
cli=(fzf ripgrep fd bat eza zoxide jq yq tree btop)
pac "${terminal[@]}" "${shell[@]}" "${cli[@]}"

# oh my zsh lives in XDG data, cloned directly (its installer rewrites .zshrc).
ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
if [[ ! -d $ZSH ]]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi
custom="$ZSH/custom/plugins"
[[ -d $custom/zsh-autosuggestions ]] || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$custom/zsh-autosuggestions"
[[ -d $custom/zsh-syntax-highlighting ]] || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$custom/zsh-syntax-highlighting"

if [[ $SHELL != */zsh ]]; then
  info "setting zsh as your login shell"
  chsh -s /usr/bin/zsh
fi
