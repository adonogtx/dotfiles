#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Personal terminal appearance
[[ -r "$HOME/.config/bash/appearance.sh" ]] && source "$HOME/.config/bash/appearance.sh"
