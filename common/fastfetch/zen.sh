#!/usr/bin/env bash
# Small helpers for the fastfetch screen: the date in kanji and a word for the day.

rgb() { printf '\033[38;2;%sm' "$1"; }
reset=$'\033[0m'

case "$1" in
  date)
    kanji=(日 月 火 水 木 金 土)
    # each weekday in the color of its element: sun, moon, fire, water, wood, metal, earth
    colors=("234;105;98" "221;199;161" "231;138;78" "125;174;163" "169;182;101" "216;166;87" "168;153;132")
    w=$(date +%w)
    num=$(rgb "221;199;161"); dim=$(rgb "124;111;100"); par=$(rgb "90;82;76")
    printf '%s%s%s月%s%s%s日 %s(%s%s%s)%s\n' \
      "$num" "$(date +%-m)" "$dim" "$num" "$(date +%-d)" "$dim" \
      "$par" "$(rgb "${colors[$w]}")" "${kanji[$w]}" "$par" "$reset"
    ;;
  cpu)
    # "i7-1185G7" instead of the long Intel name
    name=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2)
    short=$(grep -oE '(i[3579]|Ultra [3579]|Ryzen [3579]) ?-?[0-9]{3,5}[A-Z0-9]*' <<< "$name" | head -n1)
    echo "${short:-$(xargs <<< "$name")}"
    ;;
  phrase)
    # Miyamoto Musashi, Go Rin no Sho
    printf '%s千日の稽古を鍛とし、万日の稽古を錬とす%s\n' "$(rgb "226;192;141")" "$reset"
    ;;
  meaning)
    printf '%sa thousand days of keiko forge, ten thousand polish%s\n' "$(rgb "124;111;100")" "$reset"
    ;;
esac
