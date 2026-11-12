# Apps

Everyday software. One app per job. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Terminal and shell

**Decision:** Ghostty (PlemolJP 13, Gruvbox theme, no decorations) with zsh, oh my zsh (robbyrussell, autosuggestions, syntax highlighting), XDG folders, eza, zoxide, fzf, ripgrep, fd, bat, btop. On the Gruvbox terminal: bat uses its `ansi` theme (follows the Ghostty palette), fzf uses `--color=dark` with Gruvbox overrides in `FZF_DEFAULT_OPTS`, btop uses its own `gruvbox` theme on the terminal background. fastfetch runs on demand only, not from `.zshrc`: the 道 logo in the six logo bands (`theme.md`), keys in the color of the band beside them, the date as in the pill, 一歩一歩 and "step by step" at the end.
**Why:** Native Wayland, one text config, fast.
**Not chosen:** Kitty, Alacritty, fish. A custom prompt with user and path (2026-11-10: robbyrussell kept). A bat theme with fixed colors (ignores the palette). Light Solid on the terminal (until 2026-11-11). For fastfetch: the 間 logo, Musashi's phrase, the weekday in its element color, the ink-tone logo (all 2026-11-11).
**Where:** `install/terminal.sh`, `config/ghostty/` (`themes/gruvbox`; `themes/light-solid` stays in git), `config/zsh/.zshrc` (copied to `~/.zshrc`; also `BAT_THEME` and `FZF_DEFAULT_OPTS`), `config/btop/` (`btop.conf` and `themes/gruvbox.theme`), `config/fastfetch/` (`config.jsonc`, `do.txt`, `fetch.sh`; `fastfetch` in `install/terminal.sh`)
**Status:** done 2026-11-11 in Gruvbox (palette in `docs/theme.md`, ANSI palette), fastfetch included and tested with its colors checked in Ghostty: `themes/gruvbox`, fzf with slot 12 for matches and the prompt, tile for the current line, line for the border; btop `gruvbox.theme`. Font and colors tested on Omarchy on 2026-11-10 (needs the fontconfig rule in `desktop.md`, Fonts). A running Ghostty does not pick up a theme change by itself: reload with Ctrl + Shift + , (or open a new window).

## Launcher

**Decision:** Launcher in Quickshell on Super + Space: centred a third of the way down the screen, placeholder "Search", nothing listed until you type, ranked app results with 28 px icons on 42 px rows, an accent highlight that glides between them with on accent text, Enter opens, Escape closes. fuzzel stays only as the clipboard history picker (Super + C).
**Why:** Same look and motion as the rest of the pill; a plain name, no borrowed product names; one less app styled separately.
**Not chosen:** Walker (more parts), rofi, fuzzel as the launcher.
**Where:** `config/quickshell/Launcher.qml`, `config/hypr/modules/programs.lua`, `config/fuzzel/`
**Status:** done; Gruvbox colors done 2026-11-11 (Launcher through `Theme.qml`; fuzzel by hand: panel background, label text and input, secondary prompt, tertiary placeholder, accent match and selection with on accent text, line border). The window keeps a fixed height (room for 7 results) and animates only the panel inside, like the Control Center.

## Notifications

**Decision:** mako, top right, 12 from the top and right edges, Gruvbox, 5 s, urgent ones stay. Battery warnings at 20% (normal) and 10% (urgent), sent by `BatteryItem.qml` (`desktop.md`, Bar).
**Why:** Works today; the Notification Center is v2 work, not a reason to change now. The warnings cover the minutes when the pill is closed.
**Where:** `config/mako/`
**Status:** Gruvbox done 2026-11-11: panel background, label text, line border, red border when urgent, progress bar in tile. Battery warnings done 2026-11-11 (each once per discharge, reset by plugging in). Replaced by the Quickshell Notification Center in v2

## Browser

**Decision:** Brave Origin (`brave-origin`), main browser and web apps. Stays light (documents side, `desktop.md`, Theme).
**Why:** TODO (Gus): one line on why Origin over regular Brave.
**Not chosen:** Firefox, Zen. Brave (`brave-bin`), replaced by Origin on 2026-11-10; two Braves would break principle 2.
**Where:** `install/apps.sh` (brave-origin-bin, AUR), `config/xdg/mimeapps.list` (`brave-origin.desktop`), `config/hypr/modules/programs.lua` (`browser = "brave-origin"`)
**Status:** done. The installed `~/.config/mimeapps.list` also carries a `claude-cli` handler (Claude Code login); keep it when copying.

## Files

**Decision:** Nautilus, icon grid, with gvfs for phones and archives (file-roller). Stays light.
**Where:** `install/desktop.sh`
**Status:** done

## Notes: Doom Emacs

**Decision:** Doom Emacs (pgtk, Wayland) with org mode in `~/org`: `todo.org`, `lists.org`, `career.org`, `help.org`, and `daily/YYYY-MM-DD.org`. Captures: todo, list item, job application, daily note. Theme: doom-gruvbox. The org module with `+pretty` (bullets, checkboxes and priorities drawn as symbols). Daemon starts on demand (`emacsclient -a ''`). Google Calendar sync (org-gcal) off. Doom is the writing editor; code is IntelliJ (`dev.md`, IDE).
**Why:** Agenda and capture already built; one text format for life.
**Not chosen:** Inkdrop (paid, less control), Obsidian (another dependency). Neovim for writing or code (2026-11-11: a third editor breaks principle 2). doom-one-light (until 2026-11-11, with Light Solid). doom-xcode (until 2026-11-11: dark, matched Dark Solid).
**Rule:** if configuring takes more than a day, go back to these four files.
**Where:** `install/editors.sh`, `config/doom/` (`init.el`: `(org +pretty)`; `config.el`: `doom-theme`), `org/` (starter files with the capture headings: inbox, refile, applications)
**Status:** to build: doom-gruvbox and `+pretty`. Starter files copied to `~/org` on 2026-11-10 with `cp -n`.

## Media and documents

| Job | App | Notes |
|---|---|---|
| PDF | zathura + mupdf | documents side: light chrome, page untouched, Ctrl + R night mode |
| Video | mpv + uosc | Japanese subtitles first, IBM Plex Sans JP; audio only files keep the uosc timeline and controls on screen |
| Music | mpd + rmpc | `~/library/music`, 127.0.0.1 only, media keys through mpd-mpris (official repos) |
| Images | imv | |

**Where:** `install/apps.sh`, `config/zathura/`, `config/mpd/`, `config/rmpc/`, `config/mpv/`
**Status:** done; rmpc and uosc in Gruvbox done 2026-11-11. mpd and mpd-mpris are user services; enabled after login, they start on the next one. rmpc is only a client: closing it leaves mpd playing (`p` pauses, `rmpc stop`, or the media key). Music lives only in `~/library/music` (moved there from `~/media/music` on 2026-11-10); after adding files press `u` in rmpc. Files without tags show as Unknown (to decide: rmpc falls back to the file name, `yt-dlp --embed-metadata --embed-thumbnail` for new downloads). Whether to keep rmpc is an open question (`overview.md`). zathura keeps its Light Solid `zathurarc` (2026-11-11): background around pages #ececf0, statusbar, inputbar, notifications and completion #ffffff, search #007aff, Ctrl + R night mode #1c1c1e page and #f5f5f7 text; done and tested 2026-11-11. rmpc in Gruvbox: `themes/gruvbox.ron` (light-solid and dark-solid kept), selection accent with on accent text, secondary for most text, tertiary only for icons and modes that are off; modal in panel with a line border. uosc in Gruvbox (`color=` in `script-opts/uosc.conf`): bars and menus in panel with label text, timeline fill and active items in label, search matches in accent, curtain in bar; subtitles and the video stay untouched.

## Utilities

**Decision:** Bitwarden, Anki (`anki`, official repos), Discord. Screenshots, recording, Night Shift and the wallpaper through `gus-screenshot`, `gus-record`, `gus-nightlight`, `gus-wallpaper`; files go to `~/media/pictures/screenshots` and `~/media/videos/recordings`. Region screenshots: drag for an area, or click once to take the window under the cursor (window boxes from `hyprctl`, needs `jq`). Each screenshot is copied to the clipboard and announced by mako with a preview. `gus-wallpaper` (Super + W) picks an image from `~/media/pictures/wallpapers` in fuzzel; `gus-wallpaper <file>` copies the file there first (`cp -n`: an existing file with the same name is kept) and uses it.
**Not chosen:** `gus-float` and floating TUIs (removed with the Control Center). `anki-bin` (no longer in the AUR). bluetui (removed 2026-11-10, see `desktop.md`, Bar).
**Where:** `install/apps.sh`, `config/bin/`
**Status:** done. Open: `config/bin/gus-jdate` is in the repo but not documented; record its use here or remove it.

## Folders

**Decision:** `~/dev`, `~/docs`, `~/dump` (downloads), `~/org`, `~/media/{pictures,videos}`, `~/library/{music,books,movies,series,animes,torrents}`, `~/backups`. XDG user dirs pinned to these; no Desktop, Downloads, Templates.
**Where:** `install/base.sh`, `config/xdg/`
**Status:** done. `xdg-user-dir DESKTOP` answers `~/Desktop` because the file sets it to `$HOME`; harmless while the folder does not exist.
