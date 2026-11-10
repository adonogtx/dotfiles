# ~/.zshrc · Gus

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="emacsclient -t -a ''"
export VISUAL="$EDITOR"

# History
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# oh my zsh
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# Tools
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
alias ls="eza --group-directories-first"
alias ll="eza -l --git --group-directories-first"
alias la="eza -la --git --group-directories-first"
alias tree="eza --tree"
alias e="emacsclient -c -a ''"

# Java (sdkman, kept in XDG data). Keep this block last.
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
