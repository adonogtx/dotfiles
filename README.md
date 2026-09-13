**dotfiles**

simple, minimal and zen dotfiles for my personal arch linux setup.

the goal is to keep the environment calm, predictable and free from unnecessary distractions.

these dotfiles are made for my personal use.

do not copy them blindly.

review every file, dependency, path and shortcut before using them on your own system.

questions and suggestions are always welcome.

**install**

on a fresh arch linux install (base system, network and bootloader already set up):

    curl -O https://raw.githubusercontent.com/adonogtx/dotfiles/main/bootstrap.sh
    chmod +x bootstrap.sh
    ./bootstrap.sh

then clone this repo and apply with stow:

    git clone git@github.com:adonogtx/dotfiles.git ~/dev/dotfiles
    cd ~/dev/dotfiles
    stow bash dunst fcitx5 i3 i3status kitty picom rofi x11

firefox is manual, see firefox/README.md.

doom emacs config sync, after stow:

    ~/.config/emacs/bin/doom sync

かたつむり そろそろ登れ 富士の山。 Little snail, slowly, slowly, climb Mount Fuji. - *Kobayashi Issa*
