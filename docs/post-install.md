# Post install

The order that keeps problems isolated. Do one step, check, then go on.

## 1. Fresh Arch

Install with `archinstall`:

| Option | Choice | Why |
|---|---|---|
| Disk | btrfs, default subvolumes (`@`, `@home`, `@log`, `@pkg`, `@.snapshots`) | snapshots in step 2 expect this layout |
| Encryption | **LUKS, on** | a stolen laptop is otherwise an open book; autologin depends on it |
| Network | NetworkManager | the bar's Wi-Fi menu talks to it; `nmtui` works before there is a desktop |
| Audio | PipeWire | `pipewire-pulse` conflicts with PulseAudio and `--noconfirm` would stop there |
| Profile | minimal, no desktop | everything else comes from this repo |
| User | yours, with sudo | the scripts refuse to run as root |

Write down which bootloader archinstall installed: step 4 needs it.

## 2. Snapshots, before anything else

```bash
nmtui
git clone https://github.com/adonogtx/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh base system
findmnt /.snapshots     # must show the @.snapshots subvolume; if it prints nothing, stop here
# archinstall already made an @.snapshots subvolume; snapper wants to create its own.
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots   # drop snapper's nested one, keep @.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo snapper -c root create -d "clean install"
snapper list            # check: one snapshot listed
```

If the repo was uploaded through the GitHub website, run `chmod +x install.sh install/*.sh config/bin/*` after cloning.

From now on `snap-pac` takes a snapshot before and after every pacman transaction. To boot into one, add `grub-btrfs` (GRUB) or `limine-snapper-sync` (Limine) depending on your bootloader.

`snapper rollback` does not work as is with the archinstall layout, because fstab mounts `@` by name. Restore by booting a snapshot from the boot menu (the tools above) or by hand from a live USB: rename `@` to `@broken`, then `btrfs subvolume snapshot` the good snapshot as the new `@`.

## 3. Desktop, started from the TTY

```bash
./install.sh desktop fonts icons japanese terminal
cp -r config/hypr config/quickshell config/ghostty config/fuzzel config/mako config/fcitx5 \
      config/fontconfig config/gtk-3.0 config/gtk-4.0 ~/.config/
cp config/xdg/user-dirs.dirs config/xdg/user-dirs.conf config/xdg/mimeapps.list ~/.config/
cp config/zsh/.zshrc ~/
mkdir -p ~/.config/git && cp config/git/* ~/.config/git/
install -m755 config/bin/* ~/.local/bin/
cp assets/wallpapers/dark-solid.png ~/.local/share/wallpapers/

gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface icon-theme WhiteSur-dark
gsettings set org.gnome.desktop.interface cursor-theme macOS
gsettings set org.gnome.desktop.interface font-name 'IBM Plex Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'PlemolJP Console NF 11'
```

No login manager yet. Start Hyprland by hand from the text login:

```bash
start-hyprland
```

Check, in this order:

1. `hyprctl configerrors` prints nothing. A broken module shows a red notification and the others still load.
2. Super + Return opens Ghostty. This bind is first in `binds.lua` so you always have a terminal.
3. **Test the lock before you trust it:** run `hyprlock` from Ghostty, unlock, then try a wrong password once. If hyprlock fails to start, idle and suspend will not lock the screen, and autologin would leave the session open.
4. The bar shows five dots, Ctrl + Space shows あ in it.

Super + Shift + E logs out back to the TTY. Keep `Ctrl + Alt + F2` in mind: a text login always works there.

## 4. Login: Plymouth and SDDM

Only after every check in step 3 passes. The first install broke here because the login manager was enabled before the session it starts had been tested; this order avoids that.

Coming from the first attempt, turn greetd off first:

```bash
sudo systemctl disable greetd 2>/dev/null; sudo pacman -Rns greetd greetd-tuigreet 2>/dev/null; true
```

### Plymouth (asks the LUKS password)

```bash
sudo cp -r config/plymouth/ichigo /usr/share/plymouth/themes/
sudo plymouth-set-default-theme ichigo
```

Edit `HOOKS` in `/etc/mkinitcpio.conf` and add `plymouth` right after `systemd` (or after `udev` if your line has `udev` and `encrypt`). It must come before `sd-encrypt` or `encrypt`, or the password is asked in text. The archinstall line with LUKS usually becomes:

```
HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
```

Keep `kms` in the line: Plymouth needs the Intel driver early. Then:

```bash
sudo mkinitcpio -P      # check: no errors, a line mentioning plymouth
```

Add `quiet splash` to the kernel parameters. Where depends on the bootloader:

| Bootloader | How to tell | Where | Apply |
|---|---|---|---|
| systemd-boot | `bootctl status` shows systemd-boot | `options` line in `/boot/loader/entries/*.conf` | nothing, read at boot |
| GRUB | `/boot/grub/grub.cfg` exists | `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub` | `sudo grub-mkconfig -o /boot/grub/grub.cfg` |
| Limine | `limine.conf` under `/boot` | `cmdline:` line of each entry | nothing, read at boot |

### SDDM (logs in without a second password)

```bash
grep '^Exec' /usr/share/wayland-sessions/hyprland.desktop   # check: the file exists and names Hyprland
sudo mkdir -p /etc/sddm.conf.d
sed "s/@USER@/$USER/" config/sddm/autologin.conf | sudo tee /etc/sddm.conf.d/autologin.conf
sudo systemctl enable sddm   # no --now: it takes over on the next boot, not this TTY
```

Reboot. Check: the Plymouth screen asks the LUKS password once, then the desktop opens with no second prompt.

If it loops or stays black: `Ctrl + Alt + F2`, log in, `sudo systemctl disable sddm`, reboot to the text login, and read `journalctl -b -1 -u sddm`. The system works without SDDM; fix it from there.

## 5. Work

```bash
./install.sh backend editors
cp -r config/doom ~/.config/
cp -r org ~/                       # starter org files, only on a new machine
~/.config/emacs/bin/doom install
cp config/intellij/idea64.vmoptions ~/.config/JetBrains/<IdeaVersion>/
```

Log out and back in once so the docker group applies.

Docker publishes ports around ufw: `-p 5432:5432` is reachable from the whole Wi-Fi network even with the firewall on. Always bind to localhost, as `templates/compose.yaml` does:

```yaml
ports:
  - "127.0.0.1:5433:5432"
```

## PostgreSQL

Two instances: the local one from pacman for everyday queries in DBeaver, and one pinned `postgres:17` in Docker per Spring project.

The local cluster is created with `peer` for local sockets and passwords for TCP, so create your role once:

```bash
sudo -iu postgres createuser --createdb --pwprompt "$USER"
```

DBeaver connects with that user and password on `localhost:5432`.

For a Spring project, copy `templates/compose.yaml` into its root and run `docker compose up -d`. It listens on `localhost:5433`, so it never clashes with the local one.

Major versions of the local one (17 to 18, say) need `pg_upgrade`. When `pacman -Syu` lists a new major `postgresql`, follow the ArchWiki PostgreSQL upgrade section before rebooting. The Docker one stays on 17 until you change the tag.

## 6. Apps

```bash
./install.sh apps
cp -r config/mpv config/mpd config/zathura ~/.config/
systemctl --user start mpd mpd-mpris
```

## If something breaks

| Symptom | Fix |
|---|---|
| Black screen after login | Ctrl + Alt + F2, log in, read `hyprctl configerrors` or `~/.local/share/hyprland/hyprland.log` |
| Login loops after boot | Ctrl + Alt + F2, `sudo systemctl disable sddm`, reboot, read `journalctl -b -1 -u sddm` |
| LUKS password asked in text, no Plymouth | `plymouth` is missing from `HOOKS` or after `sd-encrypt`; fix, `sudo mkinitcpio -P` |
| Lock screen shows a crash message | Ctrl + Alt + F3, log in as yourself, run `WAYLAND_DISPLAY=wayland-1 hyprlock`, then go back with Ctrl + Alt + F1 |
| Bar is gone | `quickshell` from a terminal shows the QML error |
| Workspace dots do not switch on click | Your Hyprland may still accept the old dispatcher text: change the line in `Workspaces.qml` to `Hyprland.dispatch("workspace " + parent.wsId)` |
| An update broke the system | Boot the previous snapshot from the boot menu, or restore `@` by hand (step 2) |

## Optional

Google Calendar: uncomment `org-gcal` in `config/doom/packages.el`. Off in `apps.md` (Notes).
