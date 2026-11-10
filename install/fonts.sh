#!/usr/bin/env bash
# about: IBM Plex (Sans, Sans JP, Serif, Mono), PlemolJP, CJK and symbol fonts
source "$(dirname "$0")/lib.sh"

plex=(ttf-ibm-plex)                       # includes IBM Plex Sans JP
cjk=(noto-fonts noto-fonts-cjk)
symbols=(ttf-nerd-fonts-symbols-mono)
pac "${plex[@]}" "${cjk[@]}" "${symbols[@]}"

aur ttf-plemoljp-bin                      # Takuya's terminal font: Plex Mono + Plex Sans JP

fc-cache -f
