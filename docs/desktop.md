# Desktop

Hyprland, the bar, login, lock, look and input. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

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
**Status:** building (decided 2026-11-11). Step 1, `docs/theme.md`, done 2026-11-11. Step 2, `Theme.qml` and `theme.lua`, done and tested 2026-11-11; wallpaper stays `dark-solid.png` until step 5. Order: `docs/theme.md`, then `Theme.qml` and `theme.lua`, then each app, then the wallpaper, lock and boot images.

## Bar

**Decision:** Quickshell, 28 px, solid bar token. Left: 木 (tree) in label ink, five workspace tabs (tile rounded square behind the active number, numbers with windows grey, empty ones faint). Right: あ input seal, Bluetooth, Wi-Fi, sound, battery, Control Center, date `11月9日(月)  14:24` (date in label ink, time grey). Icons are one line family (`Glyph.qml`, Tabler paths, MIT): 16 px, stroke 1.8 on the 24 grid (1.2 px on screen), grey, full ink on hover; the battery outline uses the same ink, and a green bolt stands beside it while charging; Wi-Fi arcs and sound waves show the level. Each status icon opens the Control Center on its section; the date opens the calendar; scroll on sound changes volume.
Three status items appear only while relevant, left of あ: recording (red dot and elapsed time while `gus-record` runs; click stops it), microphone in use (full ink while any app captures the microphone, through PipeWire), disk (red, with the use of `/`, above 90%).
**Why:** One panel for every control, no TUIs. The conditional items cover what a fixed bar cannot show: a recording left running, an app listening, snapshots filling btrfs before pacman breaks.
**Not chosen:** Waybar (less control). Focused app name and dock (removed on purpose). Separate menus per icon, hairline style, pill groups, Dynamic Island (Impasto), typographic bar: all tried on 2026-11-09. TUIs (bluetui, nmtui, wiremix, impala). The kamon in the bar. 八 instead of 木 (2026-11-10: no reason beyond change; 八 is too thin at bar size). A search icon (2026-11-10: Super + Space is enough). An updates indicator (2026-11-10: the weekly update stays a ritual, `base.md`, Updates). A Do Not Disturb icon (belongs to the Keiko focus mode, v3).
**Where:** `config/quickshell/`, one file per piece (`Bar.qml`, `Tree.qml`, `Workspaces.qml`, `*Item.qml`); conditional items in `RecordItem.qml`, `MicItem.qml`, `DiskItem.qml`; `config/bin/gus-record` writes its pid to `$XDG_RUNTIME_DIR` so the bar can see it.
**Status:** done. Frozen after the 2026-11-09 redesigns, except the three conditional items decided on 2026-11-10 (to build) and the Light Solid colors (2026-11-11, to build; colors come from `Theme.qml`). Wi-Fi sits 1.5 grid units higher (`offsets` in `Glyph.qml`) because its ink is low. Check whether `Hairline.qml` and `Toggle.qml` are still used; remove them if not.

## Control Center

**Decision:** One panel under the bar. Main view: four 38 px circles (Wi-Fi, Bluetooth, Night Shift, Battery) with their names; the circle toggles, the name opens the section. Below, three capsule sliders (Display, Sound, Microphone), each with a small chevron to its section. Sections expand in place with a back chevron:

| Section | Contents |
|---|---|
| Wi-Fi | Connected, known and other networks; password asked inline, sent to nmcli through stdin |
| Bluetooth | My devices with an icon per kind and battery, nearby devices (scans while open), connect, disconnect, pair |
| Sound | Output and input picked on a segmented control, each with its volume |
| Display | Brightness, text size (GNOME `text-scaling-factor`, GTK apps only), Night Shift switch |
| Battery | Charge, time left, energy mode (Saver, Balanced, Performance) through power-profiles-daemon |

Calendar drops from the date: one month, today in blue, arrows, weeks start on Sunday.
**Why:** Low friction: the basics in one place, nothing else. Capture and record stay on their keys.
**Not chosen:** Separate menus per icon. Tiles grid, settings rows. Mixer faders. Display scale control (would break `base.md`, Hardware). Per-app volume.
**Where:** `config/quickshell/MenuWindow.qml`, `ControlCenter.qml`, `*Section.qml`, `Calendar.qml`, shared pieces (`Tile`, `CircleButton`, `Slider`, `Segmented`, `Switch`, `ListItem`)
**Status:** done. `MenuWindow.qml` keeps a fixed height (screen height minus 40) and animates only the panel inside; resizing the window on every frame made it shake (fixed 2026-11-10). The mask keeps the empty part click-through. The energy mode needs `python-gobject` for `powerprofilesctl` (add it next to `power-profiles-daemon` in `install/`). Wi-Fi section to confirm with NetworkManager on the iwd backend (`base.md`, Network).

## Login

**Decision:** Like Omarchy: Plymouth screen in Light Solid asks the LUKS password; SDDM then logs in automatically to `hyprland.desktop`. One password per boot. Same skeleton as the lock (Lock): everything on the centre axis, 一期一会 in Yuji Syuku (brush, 64 px) with its centre at 44% of the screen height, password field 362 x 52 px with its centre 150 px below the phrase's centre. Plymouth counts physical pixels, so 362 x 52 and 150 are hyprlock's 290 x 42 and 120 at scale 1.25: the same field in the same place. The phrase fades in over 300 ms on cubic-bezier(0.16, 1, 0.3, 1) (computed in the script's refresh callback) and the field appears just after. The phrase is an image (`phrase.png`) because the boot screen runs before any Japanese font is available. Silent boot: the kernel line in `/etc/default/limine` (`KERNEL_CMDLINE[default]`, full line) adds `quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0`, so no text shows before Plymouth.
**Why:** The disk password already proves who you are; the lock screen protects the running session. Boot and lock read as one family; only the phrase changes.
**Not chosen:** greetd + tuigreet (broke the first install, enabled before the session was tested). SDDM with a second password. Text LUKS prompt. The kamon (dropped). Musashi's phrase, Zen Kurenaido and IBM Plex on the boot screen. A progress bar or spinner after the password (2026-11-10: the still image was NetworkManager-wait-online; disabling it fixed the wait, see `base.md`, Network). 一期一会 in a vertical column (2026-11-10).
**Where:** `install/desktop.sh` (installs, never enables), `config/sddm/autologin.conf` (installed with `sed "s/@USER@/$USER/"`), `config/plymouth/ichigo/`, `/etc/default/limine`, `docs/post-install.md` step 4
**Status:** done; the shared geometry and the fade are to build (decided 2026-11-10). Light Solid (2026-11-11, to build): `phrase.png` redrawn in label ink, Plymouth background in the bar token. Built and tested on 2026-11-10 (the first install had skipped it). Requires LUKS; without it autologin is unsafe. Theme name `ichigo`. Test from a text console with `plymouth-test.sh` (restores the previous theme). `plymouth` goes right after `systemd` (or `udev`), before `sd-encrypt` (or `encrypt`). After changing `HOOKS` or the kernel line run `sudo limine-mkinitcpio` and check the first `cmdline:` in `/boot/limine.conf`.

## Polkit agent

**Decision:** hyprpolkitagent, started from `autostart.lua` (its user unit stays disabled).
**Why:** GUI apps that need root (mounting a disk in Nautilus) fail silently without an agent.
**Not chosen:** polkit-gnome (unmaintained). A Quickshell agent (security code we would own).
**Where:** `install/desktop.sh`, `config/hypr/modules/autostart.lua`
**Status:** done

## Lock

**Decision:** hyprlock, everything on the centre axis, same skeleton as the boot screen (Login). Top: Japanese date and time, small, grey (`11月10日(火)  23:40`). Centre: 常に兵法の道を離れず in Yuji Syuku as an image (`musashi.png`), its centre at 44% of the screen height, with the caption "Never stray from the Way." at 14 below it. Password field 290 x 42 with its centre 120 px below the phrase's centre. hypridle dims at 4 min, locks at 5, suspends at 30, locks before sleep. Super + Ctrl + Q locks.
**Why:** Maintained upstream; a custom lock is security code we would own. Boot and lock read as one family: same axis, same field, same place; only the phrase changes.
**Not chosen:** Quickshell lock (v3, after it is tested). The 2026-11-09 layout (100 px clock in the middle, field 240 px from the bottom). The phrase in a vertical column (2026-11-10).
**Where:** `config/hypr/hyprlock.conf`, `config/hypr/musashi.png`, `config/hypr/hypridle.conf`
**Status:** to build (decided 2026-11-10). `musashi.png` in label ink and the field in Light Solid colors (2026-11-11). Test with `hyprlock` from a terminal before replacing the old file; the old one stays in git.

## Fonts

**Decision:** IBM Plex Sans and Sans JP for the interface, PlemolJP Console NF for terminal and code, IBM Plex Serif for org headings. Yuji Syuku only for the boot and lock phrases, drawn into images (not installed).
**Why:** Takuya Matsuyama's family: one family, three voices.
**Not chosen:** `gus.ttf` and the kamon (dropped 2026-11-09). PlemolJP35 (3:5 width, not used).
**Where:** `install/fonts.sh`, `config/fontconfig/`
**Status:** done. PlemolJP Console NF reports dual spacing (90) on most weights and none on Bold, so Ghostty picked Bold for everything. `config/fontconfig/conf.d/99-plemoljp-mono.conf` marks the family monospace; run `fc-cache -fr` after copying. Tested on 2026-11-10.

## Icons and cursor

**Decision:** WhiteSur light icons, macOS cursor, Adwaita (light) for GTK 3, prefer light for GTK 4.
**Not chosen:** WhiteSur dark, Adwaita dark (until 2026-11-11, with Dark Solid).
**Where:** `install/icons.sh`, `config/gtk-3.0/`, `config/gtk-4.0/`, gsettings in `docs/post-install.md`, step 3
**Status:** to build (Light Solid, 2026-11-11). The dark set is installed today.

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
| Super + Shift + W / A / B | Control Center on Wi-Fi / Sound / Bluetooth |
| Super + Shift + E | Log out |

Menus and the launcher are reached through Quickshell IPC: `quickshell ipc call menus toggle <section>`, `quickshell ipc call launcher toggle`.
**Where:** `config/hypr/modules/binds.lua`, `config/hypr/modules/programs.lua`
**Status:** done
