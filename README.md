# dotfiles · gus

Arch Linux and Hyprland in Gruvbox Material, with a quiet Japanese touch: the date in kanji,
the ensō on the lock screen, 道 in fastfetch, and three small rituals for the day.

## Fresh install

1. Install Arch with archinstall: btrfs, LUKS, a user `gus`, NetworkManager. No desktop profile.
2. Log in on the console and run:

```bash
sudo pacman -S --needed git
mkdir -p ~/dev && git clone git@github.com:adonogtx/dotfiles.git ~/dev/dotfiles
~/dev/dotfiles/dot install
```

3. Log out and log in on tty1. Hyprland starts by itself.
4. Optional extras: `~/dev/dotfiles/dot extra`

## The dot command

| Command | What it does |
| --- | --- |
| `dot install` | Packages (pacman, then AUR), fonts, services, login shell, then `dot apply` |
| `dot apply` | Copies every file in `manifest` into place; backs up what it replaces |
| `dot apply -n` | Shows what would change, changes nothing |
| `dot diff` | Files on the system that differ from the repo |
| `dot capture` | Brings those changes back into the repo, to commit |
| `dot restore [stamp]` | Puts back the files from a backup (default: the latest) |
| `dot extra` | Lists the optional extras; `dot extra enable plymouth` and so on |

Files are copied, never linked. Backups live in `~/.local/state/dot/backups`.

## Layout

```
dot                 the command above
manifest            source in the repo, destination on the system
packages/arch.txt   everything dot install puts on the machine
common/             works on any system, macOS included
  zsh, starship, ghostty, yazi, fastfetch, zathura, imv
  bin/              day, keiko, gus-date
  keiko/            the blocklist
  doom/gus.el       Gruvbox, fonts, journal; loaded from your config.el
  fonts/            kamon.ttf, the one glyph font for the bar
linux/              Arch and Hyprland
  hypr/             hyprland.lua and its parts, hyprlock, hypridle
  quickshell/       the bar and its panels
  mako, fuzzel, wallpapers, bin/ (screenshot, power menu, clipboard)
extras/             off until enabled: homelab, plymouth, autologin, org-gcal, zen-browser
macos/              placeholder for the future
```

## Keys

| Keys | Action |
| --- | --- |
| SUPER + RETURN | Terminal |
| SUPER + SPACE | Launcher |
| SUPER + SHIFT + F / B / N | Files (yazi), browser (Zen), notes (Doom) |
| SUPER + K | Start a keiko |
| SUPER + SHIFT + K | Show the keiko in progress |
| SUPER + SHIFT + O / C | Open the day, close the day |
| SUPER + CTRL + L | Lock |
| SUPER + ESCAPE | Power menu |
| SUPER + SHIFT + S or PRINT | Screenshot of a region (the MX Keys Mini F8) |
| SUPER + V | Clipboard history |
| SUPER + 1 to 0 | Workspaces; add SHIFT to move the window |
| SUPER + arrows | Focus; add SHIFT to swap |
| SUPER + W | Close window |
| SUPER + F / T / J | Fullscreen, float, toggle split |
| SUPER + CTRL + R | Restart the bar |

## Backend

Java 21, IntelliJ Community, Docker with Compose, DBeaver and Postman. `dot install` turns
Docker on and adds you to the docker group.

New project: in IntelliJ, File, New, Project, Spring Boot, into ~/dev/backend/projects, with
Spring Web, Spring Data JPA, PostgreSQL Driver and Docker Compose Support. Run it and Spring
Boot starts the Postgres in compose.yaml by itself. The project brings its own ./mvnw.

## Passwords and Doom

Bitwarden and Ente Auth are installed. Doom Emacs is cloned and installed by `dot install`;
put your own init.el, config.el and packages.el in ~/.config/doom, then `dot apply` and
`~/.config/emacs/bin/doom sync`.

## Video calls, Japanese, homelab

- Meet and Teams run in Zen; camera, microphone and screen sharing go through PipeWire and
  the Hyprland portal. Keiko never blocks them.
- Japanese: Ctrl + Space switches fcitx5 to mozc. Anki is installed.
- Plex and qBittorrent on this same laptop: `dot extra enable homelab`. Plex reads only
  ~/library/movies, series and animes.

## The rituals

- **Opening** runs on the first terminal of the day: date, word of the day, yesterday's note,
  open TODOs, one intention, matcha, the first keiko.
- **Keiko** blocks the sites in `~/.config/keiko/blocklist`, silences notifications and ends by
  itself. It stops early only after typing "I choose to stop". Needs DNS over HTTPS off in the
  browser (`dot extra enable zen-browser` does that for Zen).
- **Closing** (`day close`) gathers the day's keiko, commits and DONE items, asks two questions
  and writes `~/docs/notes/journal/YYYYMMDD.org`. No scores, no streaks.

## Checked before release, and what only the laptop can check

Checked here: every script with shellcheck and by running it in a test home (`dot apply`,
`apply -n`, `diff`, `capture`, `restore`, `extra`, `day open`, `day close`, keiko status and log,
fastfetch); the Hyprland Lua files compiled and run against a stand in for the `hl` API; the QML
files through qmllint; the TOML and JSON configs parsed; zsh files with `zsh -n`.

Only on the laptop: Hyprland reading the Lua config, the bar in Quickshell, hyprlock and
hypridle, mako, the AUR builds, the Plymouth splash, the org-gcal login. See CHECKLIST.md.
