# Base

Hardware, installation, security and maintenance. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Hardware

**Decision:** ThinkPad T14 Gen 2i, Intel Iris Xe, 1080p panel at scale 1.25, single monitor, keyboard driven tiling.
**Why:** It is the machine. Every size in `desktop.md` is chosen for 1.25 (and tested at 1.25 on 2026-11-09).
**Where:** `install/system.sh` (Intel drivers, sof-firmware), `config/hypr/modules/monitors.lua`
**Status:** done

## Installation (archinstall)

**Decision:**

| Option | Choice |
|---|---|
| Profile | Minimal (no desktop) |
| Disk | btrfs, default subvolumes (`@`, `@home`, `@log`, `@pkg`, `@.snapshots`) |
| Boot partition | archinstall default; 2 GiB when it can be set without manual partitioning |
| Bootloader | Limine |
| Encryption | LUKS on |
| Network | NetworkManager |
| Audio | PipeWire |
| User | own user with sudo |

**Why:** Minimal leaves nothing to clean up; the repo installs the desktop. Limine boots snapshots through `limine-snapper-sync` and already boots this ThinkPad. The other choices are what the scripts assume.
**Not chosen:** Hyprland profile (adds SDDM, dunst, kitty, wofi, polkit-kde to remove later). Omarchy (too many decisions not ours, AI features). GRUB, systemd-boot.
**Where:** `overview.md`, Install steps; `docs/post-install.md`
**Status:** done. Limine cannot decrypt, so kernel and initramfs stay on the unencrypted boot partition (archinstall default with LUKS); Plymouth asks the password. The kernel line lives in `/boot/limine.conf`.

## Packages

**Decision:** `base.sh` runs a full upgrade before installing anything. Official repos with `--needed --noconfirm`; AUR through yay, interactive, PKGBUILD shown. AUR kept small: the 9 original packages plus `limine-mkinitcpio-hook` and `limine-snapper-sync`, minus `exercism` if it came from the AUR.
**Why:** Arch does not support partial upgrades. AUR code runs as you, so it is reviewed.
**Not chosen:** paru (same thing, yay already known).
**Where:** `install/lib.sh`, `install/base.sh`
**Status:** done. Recount the AUR list after editing `install/backend.sh` and `install/system.sh`.

## Snapshots

**Decision:** snapper + snap-pac on `@`, a snapshot before and after every pacman transaction. Setup is manual, once:

```bash
findmnt /.snapshots          # must show @.snapshots, else stop
sudo umount /.snapshots && sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots && sudo mount -a && sudo chmod 750 /.snapshots
sudo snapper -c root create -d "clean install"
```

Snapshots appear in the Limine menu through `limine-snapper-sync` (AUR); `limine-mkinitcpio-hook` (AUR) redeploys Limine after its own updates.
**Why:** A rolling release will break something eventually; a snapshot is the undo.
**Not chosen:** Timeshift (snapper is closer to pacman via snap-pac). grub-btrfs (GRUB not chosen).
**Where:** `install/system.sh`
**Status:** done. Snapshot boot entries: to build (add both AUR packages to `install/system.sh`; on a 1 GiB boot partition, lower the entry limit in `/etc/limine-snapper-sync.conf`). Keep the boot menu timeout above zero, it is the way into a snapshot.
`snapper rollback` does not work with the archinstall layout; restore by booting a snapshot or renaming `@` from a live USB.

## Security

**Decision:**

| Area | Choice |
|---|---|
| Disk | LUKS, required (autologin depends on it) |
| Firewall | ufw: deny incoming, allow outgoing |
| Lock | hyprlock at 5 min idle and before suspend |
| Bar commands | argument lists only, never shell strings with outside text |
| Wi-Fi passwords | typed in the Control Center, sent to nmcli through stdin, never on a command line |
| Clipboard | history capped at 50, Super + Shift + C wipes it |
| Docker | ports always published on 127.0.0.1 (Docker bypasses ufw) |
| PostgreSQL | peer for local sockets, scram passwords for TCP |
| SSH | client used (GitHub, dojo); server installed with openssh, never enabled |
| Admin prompts | hyprpolkitagent (`desktop.md`, Polkit agent) |

**Why:** One stolen laptop or one open port is the realistic threat.
**Where:** `install/system.sh`, `install/backend.sh`, `config/hypr/`, `config/quickshell/WifiSection.qml`
**Status:** done

## Updates

**Decision:** `sudo pacman -Syu` weekly, after reading archlinux.org news. `yay` for AUR afterwards. `paccache.timer` keeps three versions of each package.
**Why:** Small regular updates break less than rare large ones; snapshots cover the rest.
**Where:** `install/system.sh`
**Status:** done

## Recovery

| Symptom | Fix |
|---|---|
| Black screen or login fails | Ctrl + Alt + F2, log in, read `hyprctl configerrors` and `~/.local/share/hyprland/hyprland.log` |
| Login loops after boot | Ctrl + Alt + F2, `sudo systemctl disable sddm`, reboot, read `journalctl -b -1 -u sddm` |
| LUKS password asked in text, no boot screen | `plymouth` missing from `HOOKS` or placed after the encrypt hook; fix, `sudo mkinitcpio -P` |
| Boot hangs with no text | In the Limine menu press E, remove `quiet splash`, boot to see the messages |
| Lock crashed | Ctrl + Alt + F3, log in, `WAYLAND_DISPLAY=wayland-1 hyprlock`, back with Ctrl + Alt + F1 |
| Bar gone | Run `quickshell` in a terminal to see the file and line |
| Update broke the system | Boot the previous snapshot from the Limine menu |
