# dotfiles

personal arch linux & hyprland config

Arch Linux + Hyprland on a ThinkPad T14 Gen 2i: a macOS like desktop in Dark Solid (no translucency), set in IBM Plex, with Doom Emacs for notes and IntelliJ for Java.

## Principles

1. **Ma (間).** Only what is used.
2. **One way to do each thing.** One terminal, one editor, one player, one launcher.
3. **Frozen by default.** A change starts with a reason.
4. **Scripts install packages, nothing else.** One module per category, with its packages listed inside it.
5. **Configs are copied by hand.** One folder per program under `config/`. No symlinks, no sync tool.
6. **Safe without effort.** LUKS, snapshots, firewall and a working lock from day one.

Decisions and the reasons behind them: `docs/overview.md` first, then `base.md`, `desktop.md`, `apps.md`, `dev.md`.

## Structure

```
dotfiles/
├── install.sh                 entry point: ./install.sh <module>... | all
├── install/                   one script per category, packages inside
│   ├── lib.sh                 shared helpers (pac, aur, enable, logging)
│   ├── base.sh                build tools, git, yay, home folders
│   ├── system.sh              network, audio, bluetooth, power, firewall, snapshots, Limine hooks, Intel GPU
│   ├── desktop.sh             Hyprland, Quickshell, hyprlock, hypridle, polkit agent, Plymouth, SDDM, portals, capture
│   ├── fonts.sh               IBM Plex, PlemolJP, CJK, symbols
│   ├── icons.sh               WhiteSur icons, macOS cursor, Adwaita dark
│   ├── japanese.sh            fcitx5 + Mozc
│   ├── terminal.sh            Ghostty, zsh + oh my zsh, CLI tools
│   ├── backend.sh             sdkman (Java, Maven, Gradle), Docker, PostgreSQL, DBeaver, IntelliJ, Bruno
│   ├── editors.sh             Emacs (Wayland) and Doom
│   └── apps.sh                Brave, zathura, mpv + uosc, mpd + rmpc, imv, Anki, Bitwarden, Discord
├── config/                    one folder per program, copy what you want
│   ├── hypr/                  hyprland.lua + modules/, hyprlock, hypridle
│   ├── quickshell/            bar, Control Center with its sections, calendar, Spotlight: one file per piece
│   ├── ghostty/               config + themes/dark-solid
│   ├── zsh/                   .zshrc
│   ├── git/                   config, global ignore
│   ├── doom/                  init.el, config.el, packages.el
│   ├── fcitx5/                Ctrl + Space, Mozc profile
│   ├── fuzzel/  mako/         clipboard picker, and banners until the Notification Center
│   ├── mpv/  mpd/  rmpc/  zathura/
│   ├── gtk-3.0/  gtk-4.0/  fontconfig/  xdg/
│   ├── plymouth/ichigo/       boot screen: 一期一会 and the LUKS password field (system files)
│   ├── sddm/                  autologin.conf (system file)
│   ├── intellij/              Wayland VM option and notes
│   └── bin/                   gus-screenshot, gus-record, gus-nightlight, gus-jdate
├── assets/
│   └── wallpapers/            dark-solid.png
├── org/                       starter todo, lists, career, help
├── templates/                 compose.yaml: PostgreSQL 17 for Spring projects on 127.0.0.1:5433
└── docs/
    ├── overview.md            principles, repository, install steps, roadmap
    ├── base.md  desktop.md  apps.md  dev.md   one block per decision
    ├── post-install.md        step by step from a fresh archinstall, plus fixes
    ├── risks.md               what can break, what is not safe, what the repo does about it
    ├── keybindings.md
    └── theme.md               every token and where it lives
```

## Install

archinstall first: minimal profile, btrfs, LUKS, NetworkManager, PipeWire, Limine. Then:

```bash
git clone https://github.com/adonogtx/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh            # lists the modules
./install.sh base system
```

Then follow `docs/post-install.md`: snapshots first, desktop from the TTY second, login third, work tools and apps last. Each step ends with a check.

AUR packages go through yay, which shows each PKGBUILD and asks before building. Read them.

Escape hatch at any time: **Ctrl + Alt + F2** gives a text login.

## Configs

| Folder | Copy to |
|---|---|
| `config/<program>/` | `~/.config/<program>/` |
| `config/zsh/.zshrc` | `~/.zshrc` |
| `config/xdg/*` | `~/.config/` |
| `config/fontconfig/` | `~/.config/fontconfig/`, then `fc-cache -fr` |
| `config/bin/*` | `~/.local/bin/` (`install -m755`) |
| `config/plymouth/ichigo/` | `/usr/share/plymouth/themes/ichigo/` (sudo) |
| `config/sddm/autologin.conf` | `/etc/sddm.conf.d/autologin.conf` (sudo, user name filled in) |
| `templates/compose.yaml` | root of each Spring project |
| `config/intellij/idea64.vmoptions` | `~/.config/JetBrains/<IdeaVersion>/` |

## Security choices

| Choice | Why |
|---|---|
| Lock screen is hyprlock for now | Maintained by the Hyprland team and widely tested. A Quickshell lock comes after the rest is stable. |
| `allow_session_lock_restore` on | If the lock crashes, the session stays locked and you can restart the lock from a TTY. |
| Bar runs commands as argument lists | Wi-Fi and Bluetooth names are text from strangers; they never reach a shell. |
| mpd listens on 127.0.0.1 only | Nobody on the network controls your player. |
| ufw: deny incoming | Nothing is reachable from outside unless you open it. |
| docker group warning | Being in it is the same as root; the script says so before adding you. |
| No hyprbars plugin | Plugins break on every Hyprland update. Windows go without title buttons, like most tiling setups. |
| Clipboard history capped at 50 | Copied passwords stay in it; Super + Shift + C wipes it. |
| PostgreSQL with peer and scram | initdb's default would let any local user in as superuser. |
| LUKS required in the docs | The only protection if the laptop is stolen, and what makes autologin safe. |
| One password per boot | Plymouth asks for LUKS, SDDM logs in without asking again, hyprlock guards the running session. |
| SSH server never enabled | openssh is installed for the client (GitHub, other machines); nothing listens. |

Full list: `docs/risks.md`.

## Roadmap

| Version | Contents |
|---|---|
| v1 | This repo: the bar, the Control Center (Wi-Fi, Bluetooth, Night Shift, Battery, Display, Sound, Microphone), the calendar, Spotlight, the lock, the login, every app configured |
| v1.1 | `./install.sh all` also copies configs and enables services, stopping for AUR review and a lock test |
| v2 | Notification Center (replaces mako) |
| v3 | Quickshell lock screen, rituals: opening on the lock screen, Keiko focus mode, end of day closing |

## Notes

Hyprland 0.57 removed the old `hyprland.conf` format, so the config is Lua. hyprlock and hypridle still use their own `.conf` files. If a Hyprland update renames a dispatcher, `hyprctl configerrors` names the line.

## License

MIT, except third-party assets noted in their folders.
