#!/usr/bin/env bash
# about: fcitx5 with Mozc for Japanese input (Ctrl + Space)
source "$(dirname "$0")/lib.sh"

input_method=(fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool)
pac "${input_method[@]}"
