# Gruvbox prompt
if [[ $- == *i* ]]; then
    PS1='\[\e[38;2;168;153;132m\][\[\e[38;2;184;187;38m\]\u\[\e[38;2;168;153;132m\]@\[\e[38;2;131;165;152m\]\h \[\e[38;2;250;189;47m\]\W\[\e[38;2;168;153;132m\]]\[\e[38;2;235;219;178m\]\$ \[\e[0m\]'
fi

# Fastfetch with custom Gruvbox logo
fastfetch() {
    command fastfetch \
        --logo-type file \
        --logo "$HOME/.config/fastfetch/arch-gruvbox.txt" \
        --logo-color-1 '#cc241d' \
        --logo-color-2 '#d65d0e' \
        --logo-color-3 '#fe8019' \
        --logo-color-4 '#d79921' \
        --logo-color-5 '#fabd2f' \
        --logo-color-6 '#b8bb26' \
        --logo-color-7 '#8ec07c' \
        --logo-color-8 '#83a598' \
        --logo-color-9 '#ebdbb2' \
        "$@"
}
