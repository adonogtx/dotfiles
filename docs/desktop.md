# Desktop

Hyprland, the pill, login, lock, look and input. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Compositor

**Decision:** Hyprland with the Lua config, split in modules: monitors, env, look, input, rules, binds, autostart, programs, theme. Each module loads in protected mode; a broken one is reported as a notification and the rest still loads.
**Why:** Hyprland 0.57 removed the old `.conf` format. Modules keep each concern small.
**Not chosen:** i3 (X11, IntelliJ glitches), Niri, Omarchy.
**Where:** `config/hypr/hyprland.lua`, `config/hypr/modules/`
**Status:** done. Dispatchers not in the upstream example (fullscreen, move window, resize mode, previous workspace) are isolated; check `hyprctl configerrors` on first start (clean on 2026-11-10). Under SDDM the session does not read `~/.zshrc`: `env.lua` puts `~/.local/bin` first in `PATH` (the `gus-*` binds failed without it), and `autostart.lua` runs `dbus-update-activation-environment --systemd --all` before starting user services (polkit, mpd-mpris, portals need `WAYLAND_DISPLAY`).

## Windows

**Decision:** Solid. No blur, no transparency. Rounding 10, gaps 6 inside and 12 outside, 1 px hairline border, one soft shadow, animations around 150 ms. No title bar buttons.
**Why:** Legible, light on the Iris Xe, calm and readable without effects.
**Not chosen:** Translucent windows or panels. hyprbars (plugins break on every Hyprland update).
**Where:** `config/hypr/modules/look.lua`
**Status:** done

## Theme: Light Solid

**Decision:** One neutral light palette for the shell and the apps.

| Token | Value | Token | Value |
|---|---|---|---|
| bar | #f6f6f8 | label | #1d1d1f |
| panel | #ffffff | secondary | #6e6e73 |
| tile | #ececf0 | tertiary | #aeaeb2 |
| line | #e0e0e4 | accent | #007aff |
| terminal | #fbfbfc | green, red | #248a3d, #d70015 |
| on accent | #ffffff | | |

Blue only selects, green and red only report state. Text, glyphs and switch knobs on a blue fill use on accent. Window borders: line, tertiary when focused (one line color on both would hide focus). 4 px grid.
Panels get depth without translucency: each surface falls one shade top to bottom (panel #ffffff to #f7f7f9), a 1 px edge in #e0e0e4, one soft shadow. Motion: hover and press 140 ms; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in just after its panel. Section labels 10 px, uppercase, tracked.
**Why:** The dark theme felt heavy and tiring; a light palette reads calmer. One system, no theme switching. The depth and motion rules come from studying Ricelin (MIT).
**Not chosen:** Dark Solid (the theme until 2026-11-11: felt heavy). Glass (blur and translucency reverse Windows). Gruvbox, Midnight Shibuya, Tokyo, Kanagawa (all tried in the decks). Palettes taken from the wallpaper (Impasto, Ricelin). Pure white terminal.
**Where:** `config/quickshell/Theme.qml`, `config/hypr/modules/theme.lua`, each app config; every token listed in `docs/theme.md`. Wallpaper: `assets/wallpapers/light-solid.png`, copied to `~/.local/share/wallpapers/` (read by `theme.lua` and `hyprlock.conf`). GTK through gsettings (`docs/post-install.md`, step 3).
**Status:** done and tested 2026-11-11 (decided the same day). Built in order: `docs/theme.md`, then `Theme.qml` and `theme.lua`, then each app, GTK and icons, then the wallpaper `light-solid.png`, the lock and the boot screen.

## Bar

**Decision:** Quickshell, one pill centred at the top, studied from Ricelin by Gakuseei, in Light Solid.
- Rest: 12 from the top edge, height 34, rounding full, panel surface, 1 px edge in line, one soft shadow. It hugs the text: the Japanese date in label and the time in secondary (`11月11日(水)  11:35`), IBM Plex Sans JP. Nothing else on screen. Windows start below it (12 + 34 + the 12 outer gap).
- Live items join the pill, left of the date, only while true, separated by one hairline: recording (red dot and elapsed time while `gus-record` runs; click stops it), microphone in use (any app capturing, through PipeWire), Awake on (cup icon), disk (red, with the use of `/`, above 90%). Icons are one line family (`Glyph.qml`, Tabler paths, MIT): 16 px, stroke 1.8 on the 24 grid.
- Workspace switch: for about 1 s the pill shows only five dots (active long, with windows grey, empty faint), then morphs back. No number, no kanji.
- A click anywhere on the pill opens the Control Center. The calendar opens from the Calendar link in the open pill's footer. Escape or click outside closes.
- Open: the pill grows down to 480 wide, the calendar 384; the date stays where it was at the top. Inside: the Control Center (below), footer with あ, workspace dots and a Calendar link.
- Motion: shape changes 300 ms on cubic-bezier(0.16, 1, 0.3, 1), content fades in after the shape; fixed window size, only the panel inside animates.
- Exact sizes and colors: `docs/pill-spec.md` (this block wins when they disagree).
**Why:** One piece that becomes every control, no separate islands (unlike Impasto's); photo wallpapers stay uncut (2026-11-11). Cost: windows get 18 px less height than under the old bar, accepted.
**Not chosen:** Waybar (less control). Focused app name and dock (removed on purpose). Separate menus per icon, hairline style, typographic bar: all tried on 2026-11-09. 28 px bar across the top (until 2026-11-11). Vertical bar on the left (2026-11-11). Floating bar on top (2026-11-11). Media and now playing in the pill (not used). 木 and the status icons at rest (2026-11-11: nothing else on screen). TUIs (bluetui, nmtui, wiremix, impala). The kamon in the bar. 八 instead of 木 (2026-11-10: no reason beyond change; 八 is too thin at bar size). A search icon (2026-11-10: Super + Space is enough). An updates indicator (2026-11-10: the weekly update stays a ritual, `base.md`, Updates). A Do Not Disturb icon (belongs to the Keiko focus mode, v3).
**Where:** `config/quickshell/`: `shell.qml` (one pill per screen, the `menus` IPC), `Pill.qml` (one window per screen, fixed size, only the shape animates; the mask follows the shape), `PillRest.qml` (live items, line, date), `PillDate.qml`, `WorkspaceDots.qml` (on switch and in the footer), `PillFooter.qml`, `Awake.qml` (the Awake state; each pill holds an idle inhibitor while it is on), `LiveItem.qml` with `RecordItem.qml` (`ps -o etimes= -C wf-recorder`: the exact name, like `gus-record`'s `pgrep -x`, plus the elapsed seconds, so the time survives a Quickshell restart), `MicItem.qml` (a PipeWire link from a hardware source to a stream), `AwakeItem.qml`, `DiskItem.qml` (`df` once a minute). Exact sizes in `docs/pill-spec.md`.
**Status:** done and tested 2026-11-11. Built in five steps, each tested: rest, open with the Control Center and the calendar, dots on workspace switch and the footer, live items, cleanup (the old bar, its items, `MenuWindow.qml`, `Toggle.qml` and `Tile.qml` removed; they stay in git). The token `onAccent` read as a signal handler in QML and stayed black; it is `textOnAccent` in `Theme.qml`. A Quickshell reload resets Awake to off.

## Control Center

**Decision:** Inside the open pill (Bar). Main view: five 38 px circles (Wi-Fi, Bluetooth, Night Shift, Awake, Battery) with fixed names; the circle toggles, the name opens the section (Night Shift and Awake have no section: the name toggles; Battery: circle and name open its section). No inner boxes: blocks sit on the panel, separated by 1 px lines. Awake holds hypridle (idle inhibitor) while on; off keeps dim 4, lock 5, suspend 30; lock before sleep in both cases. No minutes picker. Awake resets to off when Quickshell or the system restarts. Sections fill the 480 width of the open pill. Below, three capsule sliders (Display, Sound, Microphone), each with a small chevron to its section. Sections expand in place with a back chevron:

| Section | Contents |
|---|---|
| Wi-Fi | Connected, known and other networks; password asked inline, sent to nmcli through stdin |
| Bluetooth | My devices with an icon per kind and battery, nearby devices (scans while open), connect, disconnect, pair |
| Sound | Output and input picked on a segmented control, each with its volume |
| Display | Brightness, text size (GNOME `text-scaling-factor`, GTK apps only), Night Shift switch |
| Battery | Charge, time left, energy mode (Saver, Balanced, Performance) through power-profiles-daemon |

Calendar opens in the pill from the footer's Calendar link: one month, header in Japanese (`2026年11月`), weekday initials 日 月 火 水 木 金 土, today in blue, arrows, weeks start on Sunday.
**Why:** Low friction: the basics in one place, nothing else. Capture and record stay on their keys.
**Not chosen:** Separate menus per icon. Tiles grid, settings rows. Tiles behind each group (until 2026-11-11). Network, device names or percentages under the circles (until 2026-11-11). A dark slider fill (until 2026-11-11). Mixer faders. Display scale control (would break `base.md`, Hardware). Per-app volume.
**Where:** `config/quickshell/Pill.qml` (host), `ControlCenter.qml`, `*Section.qml`, `Calendar.qml`, `PillFooter.qml`, shared pieces (`CircleButton`, `Slider`, `Segmented`, `Switch`, `ListItem`, `PowerRow`, `Hairline`, `SectionLabel`, `SectionHeader`); sizes in `docs/pill-spec.md`
**Status:** done and tested 2026-11-11, inside the pill, to `pill-spec.md`. `Pill.qml` keeps a fixed window size and animates only the shape; resizing the window on every frame made the old panel shake (fixed 2026-11-10). The mask keeps the empty part click-through. The energy mode needs `python-gobject` for `powerprofilesctl` (add it next to `power-profiles-daemon` in `install/`). On the iwd backend NetworkManager reports the band only for the connected network, which is why only that row has a second line.

## Login

**Decision:** Like Omarchy: Plymouth screen in Light Solid asks the LUKS password; SDDM then logs in automatically to `hyprland.desktop`. One password per boot. Everything on the centre axis: the Mori crest (ichimonji ni mitsuboshi, `kamon.png`, dark ink in the label token, 296 x 309) with its centre at 39% of the screen height, password field 362 x 52 px with its centre 250 px below the crest's centre. Plymouth counts physical pixels, so 362 x 52 is hyprlock's 290 x 42 at scale 1.25: the same field style as the lock. The crest fades in over 300 ms on cubic-bezier(0.16, 1, 0.3, 1) (computed in the script's refresh callback) and the field appears just after. After the password the field fades and `loading.png` ("loading", IBM Plex Sans, secondary) takes its place, breathing between 40% and 100% opacity every 2 s until the desktop opens. Crest and word are images because the boot screen runs before the system fonts are available. Silent boot: the kernel line in `/etc/default/limine` (`KERNEL_CMDLINE[default]`, full line) adds `quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0`, so no text shows before Plymouth.
**Why:** The disk password already proves who you are; the lock screen protects the running session. Boot and lock are separate screens now, sharing only the field style. The crest returns because the boot screen needs one strong symbol (2026-11-11). The quiet word gives feedback that boot is alive.
**Not chosen:** greetd + tuigreet (broke the first install, enabled before the session was tested). SDDM with a second password. Text LUKS prompt. Musashi's phrase, Zen Kurenaido and IBM Plex for the boot phrase. 一期一会 in a vertical column (2026-11-10). 一期一会 (until 2026-11-11). Ensō (2026-11-11). A progress bar (2026-11-11: a quiet word is enough).
**Where:** `install/desktop.sh` (installs, never enables), `config/sddm/autologin.conf` (installed with `sed "s/@USER@/$USER/"`), `config/plymouth/ichigo/`, `/etc/default/limine`, `docs/post-install.md` step 4
**Status:** done and tested after a reboot on 2026-11-11: crest and loading word, built in `config/plymouth/ichigo/`. The previous theme (phrase) is backed up in `~/backups/plymouth-ichigo-2026-11-11-phrase`; restore it the same way as the Dark Solid backup below. Earlier: the shared geometry, the fade and Light Solid built and tested after a reboot on 2026-11-11: `phrase.png` redrawn in label ink (272 x 73), Plymouth background in the bar token, `entry.png` redrawn in panel with a line edge, `bullet.png` in label. The Dark Solid theme as installed is backed up in `~/backups/plymouth-ichigo-2026-11-11`; restore with `sudo install -m644 ~/backups/plymouth-ichigo-2026-11-11/* /usr/share/plymouth/themes/ichigo/`. Built and tested on 2026-11-10 (the first install had skipped it). Requires LUKS; without it autologin is unsafe. Theme name `ichigo`. Test from a text console with `plymouth-test.sh` (`config/bin/`, installed to `~/.local/bin/`): it shows the installed theme with a password prompt and a wrong password message, and changes neither the theme nor the initramfs. `plymouth` goes right after `systemd` (or `udev`), before `sd-encrypt` (or `encrypt`). After changing `HOOKS` or the kernel line run `sudo limine-mkinitcpio` and check the first `cmdline:` in `/boot/limine.conf`.

## Polkit agent

**Decision:** hyprpolkitagent, started from `autostart.lua` (its user unit stays disabled).
**Why:** GUI apps that need root (mounting a disk in Nautilus) fail silently without an agent.
**Not chosen:** polkit-gnome (unmaintained). A Quickshell agent (security code we would own).
**Where:** `install/desktop.sh`, `config/hypr/modules/autostart.lua`
**Status:** done

## Lock

**Decision:** hyprlock, everything on the centre axis, same field style as the boot screen (Login). Top: Japanese date and time, small, grey (`11月10日(火)  23:40`). Centre: 常に兵法の道を離れず in Yuji Syuku as an image (`musashi.png`), its centre at 44% of the screen height, with the caption "Never stray from the Way." at 14 below it. Password field 290 x 42 with its centre 120 px below the phrase's centre. hypridle dims at 4 min, locks at 5, suspends at 30, locks before sleep. Awake in the Control Center pauses dim, lock and suspend; lock before sleep stays on. Super + Ctrl + Q locks.
**Why:** Maintained upstream; a custom lock is security code we would own. Boot and lock share the field style; each has its own symbol (crest on boot, phrase on lock).
**Not chosen:** Quickshell lock (v3, after it is tested). The 2026-11-09 layout (100 px clock in the middle, field 240 px from the bottom). The phrase in a vertical column (2026-11-10).
**Where:** `config/hypr/hyprlock.conf`, `config/hypr/musashi.png`, `config/hypr/hypridle.conf`
**Status:** done and tested 2026-11-11: `musashi.png` in label ink (656 x 76), field, date and caption in Light Solid tokens, background `light-solid.png`. The image `size` is 61 (76 / 1.25) so `musashi.png` shows at its real 76 px: sharp, and the same 64 px brush as the boot phrase; the caption sits 14 px below it. Offsets are logical pixels for the laptop panel (1536 x 864 at 1.25); another monitor size moves the 44% point. Test with `hyprlock` from a terminal before replacing the old file; the old one stays in git.

## Fonts

**Decision:** IBM Plex Sans and Sans JP for the interface, PlemolJP Console NF for terminal and code, IBM Plex Serif for org headings. Yuji Syuku only for the lock phrase, drawn into an image (not installed).
**Why:** Takuya Matsuyama's family: one family, three voices.
**Not chosen:** `gus.ttf` (dropped 2026-11-09). PlemolJP35 (3:5 width, not used).
**Where:** `install/fonts.sh`, `config/fontconfig/`
**Status:** done. PlemolJP Console NF reports dual spacing (90) on most weights and none on Bold, so Ghostty picked Bold for everything. `config/fontconfig/conf.d/99-plemoljp-mono.conf` marks the family monospace; run `fc-cache -fr` after copying. Tested on 2026-11-10.

## Icons and cursor

**Decision:** WhiteSur light icons (`WhiteSur-light`), Apple cursor (`apple_cursor`), Adwaita (light) for GTK 3, prefer light for GTK 4.
**Not chosen:** WhiteSur dark, Adwaita dark (until 2026-11-11, with Dark Solid).
**Where:** `install/icons.sh`, `config/gtk-3.0/`, `config/gtk-4.0/`, gsettings in `docs/post-install.md`, step 3
**Status:** Light Solid (2026-11-11): `settings.ini` for GTK 3 and 4, fuzzel icons and the gsettings in `docs/post-install.md`, step 3, switched to light; done and tested 2026-11-11. Brave Origin follows `color-scheme` through `xdg-desktop-portal-gtk`.

## Input

**Decision:** Keyboard layout plain `us`, Caps Lock is Ctrl, touchpad natural scroll and tap. Japanese through fcitx5 + Mozc, Ctrl + Space to switch.
**Not chosen:** us international or altgr-intl (accents not needed from the keyboard).
**Where:** `config/hypr/modules/input.lua`, `config/fcitx5/`, `install/japanese.sh`
**Status:** done. fcitx5 rewrites `profile` with comments; same settings, ignore the diff.

## Keys

| Keys | Action |
|---|---|
| Super + Return / Space / B / E / D / I | Ghostty / Launcher / Brave Origin / Nautilus / Doom / IntelliJ |
| Super + Q / F / V / T | Close / fullscreen / float / flip split |
| Super + H J K L, + Shift | Focus, move window |
| Super + R | Resize mode (H J K L, Escape) |
| Super + 1 to 5, + Shift | Workspace, send window |
| Super + Tab / S | Previous workspace / scratch |
| Super + C, + Shift | Clipboard history / wipe it |
| Super + Shift + S, Print | Screenshot region (MX Keys F8), full screen |
| Super + Shift + R | Record region on and off |
| Super + Ctrl + Q | Lock |
| Super + N | Night Shift |
| Super + Shift + W / A / B | Open the pill on Wi-Fi / Sound / Bluetooth |
| Super + Shift + E | Log out |

Menus and the launcher are reached through Quickshell IPC: `quickshell ipc call menus toggle <section>`, `quickshell ipc call launcher toggle`.
**Where:** `config/hypr/modules/binds.lua`, `config/hypr/modules/programs.lua`
**Status:** done
