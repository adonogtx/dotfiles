#!/usr/bin/env bash
# Helpers for the fastfetch screen: the date as in the pill, a short CPU name, and the phrase from the boot screen.

rgb() { printf '\033[38;2;%sm' "$1"; }
reset=$'\033[0m'
label="213;196;161"
secondary="168;153;132"
tertiary="124;111;100"
phrase="251;241;199"

case "$1" in
  date)
    # Same as the pill: 11月11日(水) in label, the time in secondary
    kanji=(日 月 火 水 木 金 土)
    w=$(date +%w)
    printf '%s%s月%s日(%s)%s  %s%s\n' \
      "$(rgb "$label")" "$(date +%-m)" "$(date +%-d)" "${kanji[$w]}" \
      "$(rgb "$secondary")" "$(date +%H:%M)" "$reset"
    ;;
  cpu)
    # "i7-1185G7" instead of the long Intel name
    name=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2)
    short=$(grep -oE '(i[3579]|Ultra [3579]|Ryzen [3579]) ?-?[0-9]{3,5}[A-Z0-9]*' <<< "$name" | head -n1)
    echo "${short:-$(xargs <<< "$name")}"
    ;;
  phrase)
    printf '%s一歩一歩%s\n' "$(rgb "$phrase")" "$reset"
    ;;
  meaning)
    printf '%sstep by step%s\n' "$(rgb "$tertiary")" "$reset"
    ;;
esac
