# dotfiles

Gus's personal Arch Linux + Hyprland setup for a ThinkPad T14 Gen 2i. One bar on top, one panel for every control, Light Solid look (opaque, no translucency), IBM Plex type. Japanese only in the bar's date, 木 in the bar, 一期一会 on the boot screen, and Musashi's phrase on the lock screen.

This file and four others are the source of truth: `base.md`, `desktop.md`, `apps.md`, `dev.md`, all in `docs/`. Every topic in them uses the same block: **Decision, Why, Not chosen, Where, Status.**

Status values: **done** (in the repo), **to build** (decided, not written yet), **later** (roadmap).

## Principles

1. **Ma (間).** Only what is used. Icons appear when relevant, nothing decorative.
2. **One way to do each thing.** One terminal, one editor, one player, one launcher.
3. **Frozen by default.** Changing a decision means editing its block here first, with a reason.
4. **Modular install.** Scripts only install packages; configs are copied by hand, one folder per program.
5. **Safe without effort.** LUKS, snapshots, firewall and a working lock from day one.

## Repository

GitHub: `github.com/adonogtx/dotfiles`. Lives at `~/dev/dotfiles`.

| Path | Role |
|---|---|
| `install.sh` | Entry point: `./install.sh` lists modules, `./install.sh base system` runs them |
| `install/lib.sh` | Helpers: `pac`, `aur` (interactive yay), `enable_system`, `enable_user` |
| `install/<module>.sh` | One per category, packages listed inside: base, system, desktop, fonts, icons, japanese, terminal, backend, editors, apps |
| `config/<program>/` | Copied to `~/.config/<program>/` by hand |
| `config/plymouth/ichigo/`, `config/sddm/`, `config/networkmanager/` | System files, copied with sudo (`docs/post-install.md`, step 4) |
| `config/bin/` | Small scripts (`gus-*`), copied to `~/.local/bin/` |
| `assets/wallpapers/` | Wallpaper (`light-solid.png`, copied to `~/.local/share/wallpapers/`) |
| `org/` | Starter org files |
| `templates/` | `compose.yaml`: PostgreSQL 17 for Spring projects |
| `docs/` | The five decision docs, plus `post-install.md` (step by step), `risks.md`, `keybindings.md`, `theme.md` |

No symlinks, no Stow, no package list files.

## Install steps

| Step | Command or action | Check before moving on |
|---|---|---|
| 0 | Back up `~/docs`, `~/media`, `~/org`. Push the repo to GitHub | Repo opens on GitHub |
| 1 | archinstall with the choices in `base.md`, Installation (Limine as bootloader) | Boots, asks the LUKS password |
| 2 | `nmtui`, `git clone https://github.com/adonogtx/dotfiles.git ~/dev/dotfiles`, `./install.sh base system` | No errors |
| 3 | Snapper setup by hand, timeline off, cleanup on (`base.md`, Snapshots) | `snapper list` shows a snapshot |
| 4 | `./install.sh desktop fonts icons japanese terminal`, copy configs (including `~/.zshrc`, the wallpaper and the gsettings), `fc-cache -fr` | `start-hyprland` from the TTY shows the bar; new terminal shows the robbyrussell prompt |
| 5 | Network fix (`base.md`, Network). Test `hyprlock` once, wrong password once; then the login, silent boot in `/etc/default/limine` and `sudo limine-mkinitcpio` (`docs/post-install.md`, step 4) | `nmcli device` connected; lock works; `HOOKS` has `plymouth` before the encrypt hook; first `cmdline:` in `/boot/limine.conf` starts with `cryptdevice=` |
| 6 | Reboot | 一期一会 screen asks the password once, no text before it, desktop opens |
| 7 | `./install.sh backend editors apps`, copy configs, `sudo usermod -aG docker "$USER"`, open IntelliJ once then copy `idea64.vmoptions` | Apps open from their keys; `groups` shows docker; IntelliJ checks in `dev.md`, IDE |

The zip exported from Claude keeps the executable bits; only a repo uploaded through the GitHub website needs `chmod +x install.sh install/*.sh config/bin/*`.

Escape hatch at any time: **Ctrl + Alt + F2** gives a text login.

## Roadmap

| Version | Contents |
|---|---|
| v1 | Everything marked done in these docs: the bar, the Control Center with its sections, the calendar, the launcher, the lock, the login |
| v1.1 | One command install: `./install.sh all` installs every module, copies configs with a backup of what exists, enables services, and stops twice (AUR review, lock test before autologin). Changes principle 4 when built |
| v2 | Notification Center (replaces mako) |
| v3 | Quickshell lock screen, rituals: opening on the lock screen, Keiko focus mode, end of day closing |

## Open questions

| Topic | Note |
|---|---|
| Fastfetch | `config/fastfetch/` is untracked and undocumented; document it in `apps.md` or remove it |
| Brave Origin | Why line in `apps.md`, Browser, still to write |
| Repo leftovers | Stray `config/~` folder (find the `"~/` path that creates it); `post-install.md` wallpaper path should be `assets/wallpapers/`; add `jq` next to `slurp` and `python-gobject` next to `power-profiles-daemon` in `install/`; commit today's changes |
| Layer animations | `look.lua` `layers` was turned off while fixing the shaking panels; test with it back on. If panels stay smooth keep it on, else record "layer animations off" in `desktop.md`, Windows |
| Music | Untagged files show Unknown in rmpc; `~/homelab/music` duplicates the Nujabes folder (dojo mirror or leftover?) |
| fastfetch | `config/fastfetch/` is untracked and undocumented: document it in `apps.md` or remove it |
| IntelliJ | Open once, copy `idea64.vmoptions`, run the checks in `dev.md`, IDE |
