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
**Why:** Legible, light on the Iris Xe, closest to macOS with Reduce Transparency.
**Not chosen:** Translucent windows or panels. hyprbars (plugins break on every Hyprland update).
**Where:** `config/hypr/modules/look.lua`
**Status:** done

## Theme: Dark Solid

**Decision:** One neutral palette for the shell and the apps.

| Token | Value | Token | Value |
|---|---|---|---|
| bar | #161618 | label | #f5f5f7 |
| panel | #1f1f21 | secondary | #98989d |
| tile | #2a2a2d | tertiary | #636366 |
| line | #38383a | accent | #0a84ff |
| terminal | #1c1c1e | green, red | #30d158, #ff453a |

Blue only selects, green and red only report state. 4 px grid.
Panels get depth without translucency: each surface falls one shade top to bottom (panel #232325 to #1c1c1e, tiles #2c2c2f to #262629), a 1 px edge in white at 4.5 to 7%, a 1 px light on the panel's top edge, one soft shadow. Motion: hover and press 140 ms; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in just after its panel. Section labels 10 px, uppercase, tracked.
**Why:** One system, no theme switching. The depth and motion rules come from studying Ricelin (MIT).
**Not chosen:** Gruvbox, Midnight Shibuya, Tokyo, Kanagawa (all tried in the decks). Palettes taken from the wallpaper (Impasto, Ricelin). Pure black terminal.
**Where:** `config/quickshell/Theme.qml`, `config/hypr/modules/theme.lua`, each app config; every token listed in `docs/theme.md`. Wallpaper: `assets/wallpapers/dark-solid.png`, copied to `~/.local/share/wallpapers/` (read by `theme.lua` and `hyprlock.conf`). GTK through gsettings (`docs/post-install.md`, step 3).
**Status:** done. Ghostty theme tested on 2026-11-10. Wallpaper and gsettings were missed on the first install; applied 2026-11-10.

## Bar

**Decision:** Quickshell, 28 px, solid #161618. Left: 木 (tree) in white, five workspace tabs (grey rounded square behind the active number, numbers with windows grey, empty ones faint). Right: あ input seal, Bluetooth, Wi-Fi, sound, battery, search, Control Center, date `11月9日(月)  14:24` (date white, time grey). Icons are one line family (`Glyph.qml`, Tabler paths, MIT): grey, full ink on hover; Wi-Fi arcs and sound waves show the level. Each status icon opens the Control Center on its section; the date opens the calendar; search opens Spotlight; scroll on sound changes volume.
**Why:** macOS structure, one panel for every control, no TUIs.
**Not chosen:** Waybar (less control). Focused app name and dock (removed on purpose). Separate menus per icon, hairline style, pill groups, Dynamic Island (Impasto), typographic bar: all tried on 2026-11-09. TUIs (bluetui, nmtui, wiremix, impala). The kamon in the bar. 八 instead of 木 (2026-11-10: no reason beyond change; 八 is too thin at bar size).
**Where:** `config/quickshell/`, one file per piece (`Bar.qml`, `Tree.qml`, `Workspaces.qml`, `*Item.qml`)
**Status:** done. Frozen after the 2026-11-09 redesigns. Check whether `Hairline.qml` and `Toggle.qml` are still used; remove them if not.

## Control Center

**Decision:** One panel under the bar, macOS style. Main view: four 38 px circles (Wi-Fi, Bluetooth, Night Shift, Battery) with their names; the circle toggles, the name opens the section. Below, three capsule sliders (Display, Sound, Microphone), each with a small chevron to its section. Sections expand in place with a back chevron:

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

**Decision:** Like Omarchy: Plymouth screen in Dark Solid shows 一期一会 in Yuji Syuku (brush, 64 px) and asks the LUKS password; SDDM then logs in automatically to `hyprland.desktop`. One password per boot. The phrase is an image (`phrase.png`) because the boot screen runs before any Japanese font is available. Password field 362 x 52 px, the same as hyprlock's. Silent boot: the kernel line in `/etc/default/limine` (`KERNEL_CMDLINE[default]`, full line) adds `quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0`, so no text shows before Plymouth.
**Why:** The disk password already proves who you are; the lock screen protects the running session.
**Not chosen:** greetd + tuigreet (broke the first install, enabled before the session was tested). SDDM with a second password. Text LUKS prompt. The kamon (dropped). Musashi's phrase, Zen Kurenaido and IBM Plex on the boot screen. A progress bar or spinner after the password (2026-11-10: the still image was NetworkManager-wait-online; disabling it fixed the wait, see `base.md`, Network).
**Where:** `install/desktop.sh` (installs, never enables), `config/sddm/autologin.conf` (installed with `sed "s/@USER@/$USER/"`), `config/plymouth/ichigo/`, `/etc/default/limine`, `docs/post-install.md` step 4
**Status:** done. Built and tested on 2026-11-10 (the first install had skipped it). Requires LUKS; without it autologin is unsafe. Theme name `ichigo` (renamed from `zenos` on 2026-11-10). Test from a text console with `plymouth-test.sh` (restores the previous theme). `plymouth` goes right after `systemd` (or `udev`), before `sd-encrypt` (or `encrypt`). After changing `HOOKS` or the kernel line run `sudo limine-mkinitcpio` and check the first `cmdline:` in `/boot/limine.conf`.

## Polkit agent

**Decision:** hyprpolkitagent, started from `autostart.lua` (its user unit stays disabled).
**Why:** GUI apps that need root (mounting a disk in Nautilus) fail silently without an agent.
**Not chosen:** polkit-gnome (unmaintained). A Quickshell agent (security code we would own).
**Where:** `install/desktop.sh`, `config/hypr/modules/autostart.lua`
**Status:** done

## Lock

**Decision:** hyprlock. Japanese date 18, 100 px light clock, 常に兵法の道を離れず at 28 with the caption "Never stray from the Way." at 14, password field 290 x 42 at 240 px from the bottom; the text block sits 60 px lower than the deck. hypridle dims at 4 min, locks at 5, suspends at 30, locks before sleep. Super + Ctrl + Q locks.
**Why:** Maintained upstream; a custom lock is security code we would own. Sizes tuned on the T14 at 1.25.
**Not chosen:** Quickshell lock (v3, after it is tested).
**Where:** `config/hypr/hyprlock.conf`, `config/hypr/hypridle.conf`
**Status:** done

## Fonts

**Decision:** IBM Plex Sans and Sans JP for the interface, PlemolJP Console NF for terminal and code, IBM Plex Serif for org headings. Yuji Syuku only for the boot phrase, drawn into an image (not installed).
**Why:** Takuya Matsuyama's family: one family, three voices.
**Not chosen:** `gus.ttf` and the kamon (dropped 2026-11-09). PlemolJP35 (3:5 width, not used).
**Where:** `install/fonts.sh`, `config/fontconfig/`
**Status:** done. PlemolJP Console NF reports dual spacing (90) on most weights and none on Bold, so Ghostty picked Bold for everything. `config/fontconfig/conf.d/99-plemoljp-mono.conf` marks the family monospace; run `fc-cache -fr` after copying. Tested on 2026-11-10.

## Icons and cursor

**Decision:** WhiteSur dark icons, macOS cursor, Adwaita dark for GTK 3, prefer dark for GTK 4.
**Where:** `install/icons.sh`, `config/gtk-3.0/`, `config/gtk-4.0/`, gsettings in `docs/post-install.md`, step 3
**Status:** done

## Input

**Decision:** Keyboard layout plain `us`, Caps Lock is Ctrl, touchpad natural scroll and tap. Japanese through fcitx5 + Mozc, Ctrl + Space to switch.
**Not chosen:** us international or altgr-intl (accents not needed from the keyboard).
**Where:** `config/hypr/modules/input.lua`, `config/fcitx5/`, `install/japanese.sh`
**Status:** done. fcitx5 rewrites `profile` with comments; same settings, ignore the diff.

## Keys

| Keys | Action |
|---|---|
| Super + Return / Space / B / E / D / I | Ghostty / Spotlight / Brave Origin / Nautilus / Doom / IntelliJ |
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

Menus and Spotlight are reached through Quickshell IPC: `quickshell ipc call menus toggle <section>`, `quickshell ipc call spotlight toggle`.
**Where:** `config/hypr/modules/binds.lua`, `config/hypr/modules/programs.lua`
**Status:** done
