#!/bin/sh

if [ "$TERM" = "linux" ]; then
    COLORS="
        282828
        CC241D
        98971A
        D79921
        458588
        B16286
        689D6A
        A89984
        928374
        FB4934
        B8BB26
        FABD2F
        83A598
        D3869B
        8EC07C
        EBDBB2
    "

    i=0

    for color in $COLORS; do
        printf '\033]P%x%s' "$i" "$color"
        i=$((i + 1))
    done

    clear
fi
