# Apps

Everyday software. One app per job. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Terminal and shell

**Decision:** Ghostty (PlemolJP 13, Dark Solid theme, no decorations) with zsh, oh my zsh (robbyrussell, autosuggestions, syntax highlighting), XDG folders, eza, zoxide, fzf, ripgrep, fd, bat, btop.
**Why:** Native Wayland, one text config, fast.
**Not chosen:** Kitty, Alacritty, fish. A custom prompt with user and path (2026-11-10: robbyrussell kept).
**Where:** `install/terminal.sh`, `config/ghostty/`, `config/zsh/.zshrc` (copied to `~/.zshrc`)
**Status:** done. Font and colors tested on Omarchy on 2026-11-10 (needs the fontconfig rule in `desktop.md`, Fonts). `.zshrc` was missed on the first install; copied 2026-11-10.

## Launcher: Spotlight

**Decision:** Spotlight in Quickshell on Super + Space and the bar's search icon: centred a quarter of the way down the screen, nothing listed until you type, ranked app results, a blue highlight that glides between them, Enter opens, Escape closes. fuzzel stays only as the clipboard history picker (Super + C).
**Why:** Same look and motion as the rest of the bar; one less app styled separately.
**Not chosen:** Walker (more parts), rofi, fuzzel as the launcher.
**Where:** `config/quickshell/Spotlight.qml`, `config/hypr/modules/programs.lua`, `config/fuzzel/`
**Status:** done

## Notifications

**Decision:** mako, top right, Dark Solid, 5 s, urgent ones stay.
**Why:** Works today; the Notification Center is v2 work, not a reason to change now.
**Where:** `config/mako/`
**Status:** done. Replaced by the Quickshell Notification Center in v2

## Browser

**Decision:** Brave Origin (`brave-origin`), main browser and web apps.
**Why:** TODO (Gus): one line on why Origin over regular Brave.
**Not chosen:** Firefox, Zen. Brave (`brave-bin`), replaced by Origin on 2026-11-10; two Braves would break principle 2.
**Where:** `install/apps.sh` (brave-origin-bin, AUR), `config/xdg/mimeapps.list` (`brave-origin.desktop`), `config/hypr/modules/programs.lua` (`browser = "brave-origin"`)
**Status:** done. The installed `~/.config/mimeapps.list` also carries a `claude-cli` handler (Claude Code login); keep it when copying.

## Files

**Decision:** Nautilus, icon grid, with gvfs for phones and archives (file-roller).
**Where:** `install/desktop.sh`
**Status:** done

## Notes: Doom Emacs

**Decision:** Doom Emacs (pgtk, Wayland) with org mode in `~/org`: `todo.org`, `lists.org`, `career.org`, `help.org`, and `daily/YYYY-MM-DD.org`. Captures: todo, list item, job application, daily note. Theme doom-xcode. Daemon starts on demand (`emacsclient -a ''`). Google Calendar sync (org-gcal) off.
**Why:** Agenda and capture already built; one text format for life.
**Not chosen:** Inkdrop (paid, less control), Obsidian (another dependency).
**Rule:** if configuring takes more than a day, go back to these four files.
**Where:** `install/editors.sh`, `config/doom/`, `org/` (starter files with the capture headings: inbox, refile, applications)
**Status:** done. Starter files copied to `~/org` on 2026-11-10 with `cp -n`.

## Media and documents

| Job | App | Notes |
|---|---|---|
| PDF | zathura + mupdf | dark chrome, page untouched, Ctrl + R inverts |
| Video | mpv + uosc | Japanese subtitles first, IBM Plex Sans JP; audio only files keep the uosc timeline and controls on screen |
| Music | mpd + rmpc | `~/library/music`, 127.0.0.1 only, media keys through mpd-mpris (official repos) |
| Images | imv | |

**Where:** `install/apps.sh`, `config/zathura/`, `config/mpd/`, `config/mpv/`
**Status:** done. mpd and mpd-mpris are user services; enabled after login, they start on the next one. rmpc is only a client: closing it leaves mpd playing (`p` pauses, `rmpc stop`, or the media key). Music lives only in `~/library/music` (moved there from `~/media/music` on 2026-11-10); after adding files press `u` in rmpc. Files without tags show as Unknown (to decide: rmpc falls back to the file name, `yt-dlp --embed-metadata --embed-thumbnail` for new downloads). Open: `zathurarc` uses #141416 and #232325, outside the Dark Solid palette (use #1c1c1e and #2a2a2d)

## Utilities

**Decision:** Bitwarden, Anki (`anki`, official repos), Discord. Screenshots, recording and Night Shift through `gus-screenshot`, `gus-record`, `gus-nightlight`; files go to `~/media/pictures/screenshots` and `~/media/videos/recordings`. Region screenshots: drag for an area, or click once to take the window under the cursor (window boxes from `hyprctl`, needs `jq`). Each screenshot is copied to the clipboard and announced by mako with a preview.
**Not chosen:** `gus-float` and floating TUIs (removed with the Control Center). `anki-bin` (no longer in the AUR). bluetui (removed 2026-11-10, see `desktop.md`, Bar).
**Where:** `install/apps.sh`, `config/bin/`
**Status:** done. Open: `config/bin/gus-jdate` is in the repo but not documented; record its use here or remove it.

## Folders

**Decision:** `~/dev`, `~/docs`, `~/dump` (downloads), `~/org`, `~/media/{pictures,videos}`, `~/library/{music,books,movies,series,animes,torrents}`, `~/backups`. XDG user dirs pinned to these; no Desktop, Downloads, Templates.
**Where:** `install/base.sh`, `config/xdg/`
**Status:** done. `xdg-user-dir DESKTOP` answers `~/Desktop` because the file sets it to `$HOME`; harmless while the folder does not exist.
