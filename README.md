**dotfiles**

simple, minimal and zen dotfiles for my personal arch linux setup.

the goal is to keep the environment calm, predictable and free from unnecessary distractions.

these dotfiles are made for my personal use.

do not copy them blindly.

review every file, dependency, path and shortcut before using them on your own system.

questions and suggestions are always welcome.

**install**

on a fresh arch linux install (base system, network and bootloader already set up):

    sudo pacman -S --needed git
    git clone https://github.com/adonogtx/dotfiles.git ~/dev/dotfiles
    cd ~/dev/dotfiles
    ./install.sh

install.sh runs every category in install/ in order. each one can also run alone:

    ./install.sh dev links
    ./install/links.sh

categories:

    system     full update, core cli tools and yay
    network    networkmanager with iwd backend, impala, bluetooth, bluetui, netscanner
    desktop    x11, i3, lightdm, desktop utilities and fonts
    audio      pipewire
    input      fcitx5 + mozc
    dev        toolchain, docker, intellij, mise with java 21 and maven
    shell      zsh + oh my zsh
    emacs      doom emacs
    links      symlinks every file in the package directories into $HOME

run it as your normal user, sudo is asked once. a package, service or step that fails is skipped and listed at the end, only a failed system update stops the run. services are only enabled, so reboot when it finishes.

**links**

no stow. each program has its own directory with just its files, and links.sh links them to where the program reads them. bash, zsh and x11 go to $HOME, everything else to ~/.config/<program>:

    kitty/kitty.conf  ->  ~/.config/kitty/kitty.conf
    bash/.bashrc      ->  ~/.bashrc

existing files that are not links are moved to <file>.backup-<timestamp> first. to link only some packages:

    ./install/links.sh i3 kitty

firefox is manual, see firefox/README.md.

doom emacs config sync, after install:

    ~/.config/emacs/bin/doom sync

かたつむり そろそろ登れ 富士の山。 Little snail, slowly, slowly, climb Mount Fuji. - *Kobayashi Issa*
