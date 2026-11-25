# Apps

Everyday software. One app per job. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Terminal and shell

**Decision:** Ghostty (PlemolJP 13, Gruvbox theme, no decorations) with zsh, oh my zsh (robbyrussell, autosuggestions, syntax highlighting), XDG folders, eza, zoxide, fzf, ripgrep, fd, bat, btop. On the Gruvbox terminal: bat uses its `ansi` theme (follows the Ghostty palette), fzf uses `--color=dark` with Gruvbox overrides in `FZF_DEFAULT_OPTS`, btop uses its own `gruvbox` theme on the terminal background. fastfetch runs on demand only, not from `.zshrc`: the 道 logo in the six logo bands (`theme.md`), keys in the color of the band beside them, the date as in the pill, disk (use of /), 一歩一歩 and "step by step" at the end.
**Why:** Native Wayland, one text config, fast.
**Not chosen:** Kitty, Alacritty, fish. A custom prompt with user and path (2026-11-10: robbyrussell kept). A bat theme with fixed colors (ignores the palette). Light Solid on the terminal (until 2026-11-11). For fastfetch: the 間 logo, Musashi's phrase, the weekday in its element color, the ink-tone logo (all 2026-11-11).
**Where:** `install/terminal.sh`, `config/ghostty/` (`themes/gruvbox`; `themes/light-solid` stays in git), `config/zsh/.zshrc` (copied to `~/.zshrc`; also `BAT_THEME` and `FZF_DEFAULT_OPTS`), `config/btop/` (`btop.conf` and `themes/gruvbox.theme`), `config/fastfetch/` (`config.jsonc`, `do.txt`, `fetch.sh`; `fastfetch` in `install/terminal.sh`)
**Status:** done 2026-11-11 in Gruvbox (palette in `docs/theme.md`, ANSI palette), fastfetch included and tested with its colors checked in Ghostty: `themes/gruvbox`, fzf with slot 12 for matches and the prompt, tile for the current line, line for the border; btop `gruvbox.theme`. Font and colors tested on Omarchy on 2026-11-10 (needs the fontconfig rule in `desktop.md`, Fonts). A running Ghostty does not pick up a theme change by itself: reload with Ctrl + Shift + , (or open a new window). 2026-11-12: key column widened (kernel and shell were cut), disk line added, shell, cpu and bat keys recolored to match their bands.

## Launcher

**Decision:** Launcher in Quickshell on Super + Space: centred a third of the way down the screen, placeholder "Search", nothing listed until you type, ranked app results with 28 px icons on 42 px rows, an accent highlight that glides between them with on accent text, Enter opens, Escape closes. fuzzel stays only as the clipboard history picker (Super + C).
**Why:** Same look and motion as the rest of the pill; a plain name, no borrowed product names; one less app styled separately.
**Not chosen:** Walker (more parts), rofi, fuzzel as the launcher.
**Where:** `config/quickshell/Launcher.qml`, `config/hypr/modules/programs.lua`, `config/fuzzel/`
**Status:** done; Gruvbox colors done 2026-11-11. Black system palette (`desktop.md`, Theme): the Launcher through `Theme.qml` (white highlight, black text) done and tested 2026-11-18; fuzzel by hand, done and tested 2026-11-18: panel background, rows in secondary with the match in label (accent and label are both white, so a match in accent would not stand out), label input, secondary prompt, tertiary placeholder, selection in accent with text and match in text on accent, line border; no icons in dmenu mode. The window keeps a fixed height (room for 7 results) and animates only the panel inside, like the Control Center.

## Notifications

**Decision:** mako, top right, 12 from the top and right edges, black system palette, 5 s, urgent ones stay. Battery warnings at 20% (normal) and 10% (urgent), sent by `BatteryItem.qml` (`desktop.md`, Bar).
**Why:** Works today; the Notification Center is v2 work, not a reason to change now. The warnings cover the minutes when the pill is closed.
**Where:** `config/mako/`
**Status:** Gruvbox done 2026-11-11; black palette done and tested 2026-11-18 (`desktop.md`, Theme): panel background, label text, line border, red border when urgent, progress bar in tile. Battery warnings done 2026-11-11 (each once per discharge, reset by plugging in). Replaced by the Quickshell Notification Center in v2

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

## Terminal editor: Neovim

**Decision:** Neovim (`nvim`), no plugins and no config, for the git editor, `$EDITOR` and plain text files (`text/plain`). Code is IntelliJ (`dev.md`, IDE). Decided 2026-11-25, when Doom Emacs and org mode left the setup.
**Why:** IntelliJ is the only editor in daily use; git and quick edits still need one in the terminal. Neovim was already installed.
**Not chosen:** Doom Emacs with org mode (set up 2026-11 but never used; removed 2026-11-25): org files in `~/org`: `todo.org`, `lists.org`, `career.org`, `help.org`, and `daily/YYYY-MM-DD.org`. Captures: todo, list item, job application, daily note. Theme: doom-gruvbox. The org module with `+pretty` (bullets, checkboxes and priorities drawn as symbols). Daemon starts on demand (`emacsclient -a ''`). Google Calendar sync (org-gcal) off. Config and starter files stay in git history. org-modern (never decided). Inkdrop (paid, less control), Obsidian (another dependency). nano (2026-11-25: Neovim was already installed). Neovim for writing or code (2026-11-11: a third editor breaks principle 2; it is now the terminal editor only, code stays in IntelliJ).
**Where:** `install/editors.sh` (`neovim`), `config/git/config` (`core.editor`), `config/zsh/.zshrc` (`EDITOR`), `config/xdg/mimeapps.list` (`text/plain`)
**Status:** done and tested 2026-11-25: `neovim` installed, git editor and `$EDITOR` open nvim, `text/plain` opens nvim, Super + D removed. `emacs-wayland` removed with `pacman -Rns`; `~/.config/doom` and `~/.config/emacs` removed after the backup in `~/archive/2026/doom-emacs/` (16 `.org` files checked). The `.org` notes in `~/docs/notes` stay as plain text.

## Media and documents

| Job | App | Notes |
|---|---|---|
| PDF | zathura + mupdf | documents side: light chrome, page untouched, Ctrl + R night mode |
| Video | mpv + uosc | Japanese subtitles first, IBM Plex Sans JP; audio only files keep the uosc timeline and controls on screen |
| Music | mpd + rmpc | `~/media/library/music`, 127.0.0.1 only, media keys through mpd-mpris (official repos) |
| Images | imv | |

**Where:** `install/apps.sh`, `config/zathura/`, `config/mpd/`, `config/rmpc/`, `config/mpv/`
**Status:** done; rmpc and uosc in Gruvbox done 2026-11-11. rmpc stays Gruvbox (it lives in Ghostty); uosc in the black system palette done and tested 2026-11-18 (`desktop.md`, Theme), same token roles as below, text on the white fill in text on accent. uosc (`mpv-uosc`, AUR) installs to `/usr/share/mpv` and is not loaded until linked: `~/.config/mpv/scripts/uosc` links to `/usr/share/mpv/scripts/uosc`, and `~/.config/mpv/fonts/` holds links to `uosc_icons.otf` and `uosc_textures.ttf` in `/usr/share/mpv/fonts/` (2026-11-12: without them uosc never loaded, and with the built in OSC off mpv showed no interface at all; linked and tested the same day). Links, not copies, so package updates apply; the one exception to "no symlinks" (`overview.md`, Repository). `script-opts/uosc.conf` stays a copied file from `config/mpv/`. Undo: `rm -r ~/.config/mpv/scripts ~/.config/mpv/fonts`. mpd and mpd-mpris are user services; enabled after login, they start on the next one. rmpc is only a client: closing it leaves mpd playing (`p` pauses, `rmpc stop`, or the media key). Music lives only in `~/media/library/music` (moved to `~/library/music` on 2026-11-10, to `~/media/library/music` on 2026-11-23); after adding files press `u` in rmpc. Files without tags show as Unknown (to decide: rmpc falls back to the file name, `yt-dlp --embed-metadata --embed-thumbnail` for new downloads). Whether to keep rmpc is an open question (`overview.md`). zathura keeps its Light Solid `zathurarc` (2026-11-11): background around pages #ececf0, statusbar, inputbar, notifications and completion #ffffff, search #007aff, Ctrl + R night mode #1c1c1e page and #f5f5f7 text; done and tested 2026-11-11. rmpc in Gruvbox: `themes/gruvbox.ron` (light-solid and dark-solid kept), selection accent with on accent text, secondary for most text, tertiary only for icons and modes that are off; modal in panel with a line border. uosc in Gruvbox (`color=` in `script-opts/uosc.conf`): bars and menus in panel with label text, timeline fill and active items in label, search matches in accent, curtain in bar; subtitles and the video stay untouched.

## Course videos

**Decision:** Course playlists are downloaded with yt-dlp into `~/media/courses/<playlist>/`, files numbered `001 Title.mkv`, 1080p or lower, and watched in mpv. `gus-course <playlist-url>` downloads a playlist, or only the videos added since the last run (`~/media/courses/.archive`); yt-dlp options placed before the URL pass through (`--playlist-items 1:2` for a test). The DevDojo course is members only (Samurai level, paid): `gus-course` reads the YouTube session cookies from the logged in Brave Origin profile (`--cookies-from-browser "brave+gnomekeyring:$HOME/.config/BraveSoftware/Brave-Origin/Default"`) and waits a few seconds between videos and requests, so a 169 video playlist does not look like a scraper on the account. Brave encrypts its cookies with a key kept in gnome-keyring; yt-dlp reads that key through python-secretstorage; the keyring is named because yt-dlp does not recognize Hyprland and would fall back to an unencrypted store. Watch with `mpv --save-position-on-quit ~/media/courses/<playlist>`: quitting with q saves the file and the position, and opening the folder again resumes there. yt-dlp needs a JavaScript runtime (deno) and yt-dlp-ejs for YouTube (since yt-dlp 2025.11.12); on Arch, yt-dlp-ejs is a dependency of yt-dlp, and ffmpeg (already installed) merges the mkv. Brave Origin must be closed while it runs: an open browser rotates the session cookies, and every video after that fails as members only. `gus-course` refuses to start while Brave Origin runs, holds a lock so two runs never overlap, stops on the first error (`--abort-on-error`; pass `--no-abort-on-error` before the URL to skip a video that is gone for good) and announces the end through mako.
**Why:** The DevDojo course is on YouTube. Opening youtube.com shows the feed, recommendations and comments, and that is where the drift to other sites starts. Local files keep study out of the browser. Cookies from the browser (2026-11-12): every video in the playlist is members only, and the first test failed without a logged in session. python-secretstorage (2026-11-12): without it yt-dlp could not decrypt 395 of 475 cookies, the login among them, and YouTube treated the request as a visitor. Keyring named (2026-11-12): under Hyprland yt-dlp chose BASICTEXT and still could not decrypt the cookies. Abort on error (2026-11-12): the first full run lost its cookies at file 33 and kept requesting the other videos as a visitor.
**Not chosen:** Watching on youtube.com. Resume on quit in `mpv.conf` (would change every video, not only courses). quickjs or node as the JS runtime (need an extra flag; deno is the yt-dlp default). Above 1080p (disk). An exported `cookies.txt` (session secrets left on disk, goes stale). Downloading without pauses (risks the account being flagged). kwallet as the keyring (gnome-keyring already runs). Dropping the `001` prefix although the titles carry their own `01` (two digit numbers would sort `100` between `10` and `11`).
**Where:** `install/apps.sh` (`yt-dlp`, `deno` and `python-secretstorage` in the `video` array, next to `mpv`; yt-dlp-ejs comes with yt-dlp), `config/bin/gus-course`
**Status:** in trial since 2026-11-12; judge on 2026-11-19. Installed 2026-11-12 (yt-dlp 2026.10.26, deno 2.9.8). First test failed on members only videos (no session); second and third on cookie decryption (no python-secretstorage, then BASICTEXT chosen under Hyprland). Tested 2026-11-12 with two videos: 1080 high (AV1, 1672 x 1080, hardware decoding through VA-API), pauses between videos, the archive skips what is already there, mpv resumes the file and the position. If the playlist inserts or reorders videos, new files take their current position, so numbers can repeat or skip. If YouTube logs the session out, log in again in Brave Origin and rerun. First full run stopped at 33 files when the cookies rotated (Brave Origin open).

## Media server

**Decision:** Plex in Docker (`lscr.io/linuxserver/plex`), watched on the laptop, the TV and the phone at home. Host network (`network_mode: host`); port 32400 open in ufw only to the home subnet `192.168.15.0/24` (`base.md`, Security; `dev.md`, Containers). Libraries read only from `~/media/library/{movies,series,animes}`: Movies with the Plex Movie agent, Series and Animes with Plex TV Series. State in `~/.local/share/plex`. Sync My Watch State and Ratings on (Settings, Account). Before any reinstall the state folder goes to an external disk, with the container stopped and `Cache` left out. qBittorrent from the official repos saves to `~/media/library/torrents`; finished files are moved by hand to their library folder.
**Why:** The watch history must survive a reinstall. A container keeps all Plex state in one folder that can be copied out and restored; the account sync brings back what was watched if the backup is missing. Host network: with published ports Docker bypasses ufw, and 32400 would be open on every Wi-Fi. No separate server exists (2026-11-23), so it runs on this laptop.
**Not chosen:** Jellyfin. Plex from the AUR (state in `/var/lib/plex`, outside home). qBittorrent in Docker (no state worth keeping). Published ports on all interfaces. A port bound to the laptop's LAN IP (changes with DHCP). For later, if needed: remote access outside home (router port forward) and hardware transcoding (Plex Pass).
**Where:** `install/apps.sh` (`qbittorrent` in the `video` array), `config/plex/compose.yaml` (copied to `~/.config/plex/`), ufw rule added by hand (`base.md`, Security)
**Status:** to build (2026-11-23). The laptop must stay awake while the TV or phone plays (Awake in the Control Center); a locked screen is fine, suspend stops the server. Backup: `docker compose stop`, then `tar -czf <external>/plex-$(date +%F).tar.gz --exclude='Library/Application Support/Plex Media Server/Cache' -C ~/.local/share plex`, then `docker compose start`. Restore: extract into `~/.local/share/`, copy the compose file, `docker compose up -d` (no claim token needed).

## Utilities

**Decision:** Bitwarden, Anki (`anki`, official repos), Discord. Screenshots, recording, Night Shift and the wallpaper through `gus-screenshot`, `gus-record`, `gus-nightlight`, `gus-wallpaper`; files go to `~/media/pictures/screenshots` and `~/media/videos/recordings`. Region screenshots: drag for an area, or click once to take the window under the cursor (window boxes from `hyprctl`, needs `jq`). Region freezes the screen with `hyprpicker` before `slurp`, so popups, context menus and tooltips that close when `slurp` takes focus still show; for those, drag the area instead of clicking. Each screenshot is copied to the clipboard and announced by mako with a preview. `gus-wallpaper` (Super + W) picks an image from `~/media/pictures/wallpapers` in fuzzel; `gus-wallpaper <file>` copies the file there first (`cp -n`: an existing file with the same name is kept) and uses it.
**Not chosen:** `gus-float` and floating TUIs (removed with the Control Center). `anki-bin` (no longer in the AUR). bluetui (removed 2026-11-10, see `desktop.md`, Bar).
**Where:** `install/apps.sh`, `config/bin/`
**Status:** done. Region freeze tested 2026-11-23: extension popups and context menus are captured, Esc unfreezes the screen. `gus-jdate` prints the Japanese date from an array of weekday kanji, no `ja_JP` locale needed: `11月19日(木)`, or `11月19日 木曜日` with `long` (the lock date, `desktop.md`, Lock; kept 2026-11-19).

## Folders

**Decision:** Five drawers in `$HOME`, each with one test:

| Drawer | Holds | Test |
|---|---|---|
| `~/dev` | code (`backend/`, `dotfiles/`, `website/`) | has git |
| `~/docs` | `career/`, `health/`, `japanese/`, `notes/`, `personal/` | mine, lost if the disk dies |
| `~/media` | `courses/`, `library/`, `pictures/`, `videos/` | looked at, watched or listened to |
| `~/archive` | `backups/` by device, the rest by year (`2026/`) | finished, kept, never edited again |
| `~/dump` | downloads and anything temporary | temporary; emptied every Sunday |

Names: lowercase, words joined by hyphens, no spaces, ISO date first when there is one. Files from outside (torrents, episodes) keep their names. XDG user dirs pinned: download `~/dump`, documents `~/docs`, pictures `~/media/pictures`, videos `~/media/videos`, music `~/media/library/music`; desktop, templates and public share set to `$HOME`. App state that passes no drawer test stays in the XDG folders, like `.m2` (`dev.md`, Folders): Plex in `~/.local/share/plex`, its compose file in `~/.config/plex/` (Media server).
**Why:** (2026-11-23) The old layout had two homes for the same media (`~/library` and `~/homelab`), notes in three places and a `~/dump` that became an attic. One test per drawer decides where each file goes.
**Not chosen:** The 2026-11-09 layout (`~/org`, `~/library`, `~/backups` at the top). `~/vault` (one file, merged into `~/docs/notes`). PARA, Johnny.Decimal, folders by life area, by lifecycle or by backup tier, XDG default names (all compared 2026-11-23).
**Where:** `install/base.sh`, `config/xdg/`
**Status:** done 2026-11-23. Folders moved, XDG and mpd configs copied; leftovers set aside in `~/archive/2026/to-delete/` for review.
