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

## Theme: Gruvbox

**Decision:** Gruvbox dark hard for the system; documents stay light. Dark: the pill and Control Center, Launcher, fuzzel, mako, Ghostty and everything in it (btop, rmpc, fastfetch), uosc, IntelliJ, Doom Emacs, boot and lock. Light: GTK apps (Nautilus), Brave Origin, Anki, zathura (the page stays white).

| Token | Value | Token | Value |
|---|---|---|---|
| bar | #1d2021 | label | #ebdbb2 |
| panel | #282828 | secondary | #a89984 |
| tile | #3c3836 | tertiary | #7c6f64 |
| line | #504945 | accent | #83a598 |
| terminal | #1d2021 | green, red | #b8bb26, #fb4934 |
| on accent | #1d2021 | phrase | #fbf1c7 (boot, lock and fastfetch only) |

Blue only selects, green and red only report state. The one exception is the fastfetch logo bands (`theme.md`). Text, glyphs and knobs on a blue fill use on accent. Window borders: line, tertiary when focused. 4 px grid. Panels get depth without translucency: each surface falls one shade top to bottom (panel #282828 to #262626), a 1 px edge in line, one soft shadow. Motion: hover and press 140 ms; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in just after its panel. Section labels 10 px, uppercase, tracked.
**Frozen:** no palette change before 2026-11-18 (one week of real use).
**Why:** The white desktop did not suit the black ThinkPad; dark for the system and light for what is read like paper keeps both comfortable. Gruvbox has ready themes for almost every app in the list and was the favourite in the comparison deck (2026-11-11). The depth and motion rules come from studying Ricelin (MIT).
**Not chosen:** Light Solid as the system theme (2026-11-11: did not suit the black ThinkPad; its values stay for the documents side). Dark Solid (the theme until 2026-11-11: felt heavy). Gruvbox Material (softer, less contrast). Kanagawa Dragon, adjusted (2026-11-11: chosen and dropped the same night for Gruvbox). Glass (blur and translucency reverse Windows). Midnight Shibuya, Tokyo. Palettes taken from the wallpaper (Impasto, Ricelin). A brown wood background for boot and lock (2026-11-11: the palette's own background instead). Three palettes at once (Dark Solid pill, Gruvbox terminal, brown boot).
**Where:** `config/quickshell/Theme.qml`, `config/hypr/modules/theme.lua`, each app config; every token listed in `docs/theme.md`. Wallpaper: through `gus-wallpaper` (`config/bin/`, Super + W): images in `~/media/pictures/wallpapers`, the choice kept as the link `~/.local/share/wallpapers/current`, drawn by swaybg; `theme.lua` reads the link at login and falls back to `light-solid.png` when it does not exist. GTK through gsettings (`docs/post-install.md`, step 3), unchanged.
**Status:** to build. Done 2026-11-11: `docs/theme.md`, `Theme.qml`, `theme.lua`, the terminal, fuzzel, mako, rmpc, uosc. Boot and lock done and tested 2026-11-11. Wallpaper picker done 2026-11-11 (`gus-wallpaper <file>` tested; the Super + W picker still to test). Left: Doom (`config.el` still sets `doom-one-light`); IntelliJ (by hand) stays outside this work. Order: `docs/theme.md`, then `Theme.qml` and `theme.lua`, then the terminal (Ghostty, bat, fzf, btop), then fuzzel, mako, rmpc, uosc, Doom, IntelliJ, then boot and lock (Login, Lock), then the wallpaper.

## Bar

**Decision:** Quickshell, one pill centred at the top, studied from Ricelin by Gakuseei, in Gruvbox.
- Rest: 12 from the top edge, height 34, rounding full, panel surface, 1 px edge in line, one soft shadow. It hugs the text: the Japanese date in label and the time in secondary (`11月11日(水)  11:35`), IBM Plex Sans JP. Nothing else on screen. Windows start below it (12 + 34 + the 12 outer gap).
- Live items join the pill, left of the date, only while true, separated by one hairline: recording (red dot and elapsed time while `gus-record` runs; click stops it), microphone in use (any app capturing, through PipeWire), Awake on (cup icon), battery below 20% and not charging (red battery icon with the percentage), disk (red, with the use of `/`, above 90%). Icons are one line family (`Glyph.qml`, Tabler paths, MIT): 16 px, stroke 1.8 on the 24 grid.
- Workspace switch: for about 1 s the pill shows only five dots (active long, with windows grey, empty faint), then morphs back. No number, no kanji.
- A click anywhere on the pill opens the Control Center. The calendar opens from the Calendar link in the open pill's footer. Escape or click outside closes.
- Open: the pill grows down to 480 wide, the calendar 384; the date stays where it was at the top. Inside: the Control Center (below), footer with あ, workspace dots and a Calendar link.
- Motion: shape changes 300 ms on cubic-bezier(0.16, 1, 0.3, 1), content fades in after the shape; fixed window size, only the panel inside animates.
- Exact sizes and colors: `docs/pill-spec.md` (this block wins when they disagree).
**Why:** One piece that becomes every control, no separate islands (unlike Impasto's); photo wallpapers stay uncut (2026-11-11). Cost: windows get 18 px less height than under the old bar, accepted. Battery item (2026-11-11): checking the charge took two clicks; it now shows itself when it matters.
**Not chosen:** Waybar (less control). Focused app name and dock (removed on purpose). Separate menus per icon, hairline style, typographic bar: all tried on 2026-11-09. 28 px bar across the top (until 2026-11-11). Vertical bar on the left (2026-11-11). Floating bar on top (2026-11-11). Media and now playing in the pill (not used). 木 and the status icons at rest (2026-11-11: nothing else on screen). TUIs (bluetui, nmtui, wiremix, impala). The kamon in the bar. 八 instead of 木 (2026-11-10: no reason beyond change; 八 is too thin at bar size). A search icon (2026-11-10: Super + Space is enough). An updates indicator (2026-11-10: the weekly update stays a ritual, `base.md`, Updates). A Do Not Disturb icon (belongs to the Keiko focus mode, v3). Battery percentage always in the pill (2026-11-11: breaks nothing else on screen). Percentage visible as soon as the pill opens (2026-11-11: contradicts no percentages under the circles).
**Where:** `config/quickshell/`: `shell.qml` (one pill per screen, the `menus` IPC), `Pill.qml` (one window per screen, fixed size, only the shape animates; the mask follows the shape), `PillRest.qml` (live items, line, date), `PillDate.qml`, `WorkspaceDots.qml` (on switch and in the footer), `PillFooter.qml`, `Awake.qml` (the Awake state; each pill holds an idle inhibitor while it is on), `LiveItem.qml` with `RecordItem.qml` (`ps -o etimes= -C wf-recorder`: the exact name, like `gus-record`'s `pgrep -x`, plus the elapsed seconds, so the time survives a Quickshell restart), `MicItem.qml` (a PipeWire link from a hardware source to a stream), `AwakeItem.qml`, `BatteryItem.qml` (UPower; also sends the 20% and 10% notifications, `apps.md`, Notifications), `DiskItem.qml` (`df` once a minute). Exact sizes in `docs/pill-spec.md`.
**Status:** shape and behaviour done and tested 2026-11-11 (built in five steps: rest, open with the Control Center and the calendar, dots and footer, live items, cleanup; the old bar, `MenuWindow.qml`, `Toggle.qml` and `Tile.qml` stay in git). Gruvbox colors done 2026-11-11. `BatteryItem.qml` done 2026-11-11: only the pill on the first screen sends the warnings, and it waits for UPower to be ready (it reports 0% before that). The token `onAccent` read as a signal handler in QML; it is `textOnAccent` in `Theme.qml`. A Quickshell reload resets Awake to off.

## Control Center

**Decision:** Inside the open pill (Bar). Main view: five 38 px circles (Wi-Fi, Bluetooth, Night Shift, Awake, Battery) with fixed names; the circle toggles, the name opens the section (Night Shift and Awake have no section: the name toggles; Battery: circle and name open its section). No inner boxes: blocks sit on the panel, separated by 1 px lines. Awake holds hypridle (idle inhibitor) while on; off keeps dim 4, lock 5, suspend 30; lock before sleep in both cases. No minutes picker. Awake resets to off when Quickshell or the system restarts. Sections fill the 480 width of the open pill. Below, three capsule sliders (Display, Sound, Microphone), each with a small chevron to its section; the fill is the light label color. Sections expand in place with a back chevron:

| Section | Contents |
|---|---|
| Wi-Fi | Connected, known and other networks; password asked inline, sent to nmcli through stdin |
| Bluetooth | My devices with an icon per kind and battery, nearby devices (scans while open), connect, disconnect, pair |
| Sound | Output and input picked on a segmented control, each with its volume |
| Display | Brightness, text size (GNOME `text-scaling-factor`, GTK apps only), Night Shift switch |
| Battery | Charge, time left, energy mode (Saver, Balanced, Performance) through power-profiles-daemon |

Calendar opens in the pill from the footer's Calendar link: one month, header in Japanese (`2026年11月`), weekday initials 日 月 火 水 木 金 土, today in blue, arrows, weeks start on Sunday.
**Why:** Low friction: the basics in one place, nothing else. Capture and record stay on their keys.
**Not chosen:** Separate menus per icon. Tiles grid, settings rows. Tiles behind each group (until 2026-11-11). Network, device names or percentages under the circles (until 2026-11-11). Mixer faders. Display scale control (would break `base.md`, Hardware). Per-app volume.
**Where:** `config/quickshell/Pill.qml` (host), `ControlCenter.qml`, `*Section.qml`, `Calendar.qml`, `PillFooter.qml`, shared pieces (`CircleButton`, `Slider`, `Segmented`, `Switch`, `ListItem`, `PowerRow`, `Hairline`, `SectionLabel`, `SectionHeader`); sizes in `docs/pill-spec.md`
**Status:** done and tested 2026-11-11, inside the pill, to `pill-spec.md`; Gruvbox colors done 2026-11-11 (slider fill and switch knob in label, chosen segment in line, slider icon in panel). `Pill.qml` keeps a fixed window size and animates only the shape; resizing the window on every frame made the old panel shake (fixed 2026-11-10). The mask keeps the empty part click-through. The energy mode needs `python-gobject` for `powerprofilesctl` (add it next to `power-profiles-daemon` in `install/`). On the iwd backend NetworkManager reports the band only for the connected network, which is why only that row has a second line.

## Login

**Decision:** Plymouth asks the LUKS password; SDDM then logs in automatically to `hyprland.desktop`. One password per boot. Boot and lock are the same screen: background bar (#1d2021); 一歩一歩 written vertically in Yuji Boku (`ippo.png`, phrase #fbf1c7, 180 px glyphs on a 178 px step, image 200 x 732 physical px), centred horizontally, top at 70 px (its centre at 40% of the screen height); password field 362 x 52 physical px (hyprlock's 290 x 42 at scale 1.25), panel fill with a line edge, its top 60 px below the column. The column fades in over 300 ms on cubic-bezier(0.16, 1, 0.3, 1) (computed in the script's refresh callback) and the field appears just after. After the password the field fades and `loading.png` ("loading", IBM Plex Sans, secondary) takes its place, breathing between 40% and 100% opacity every 2 s until the desktop opens. Phrase and word are images because the boot screen runs before the system fonts are available. Silent boot: the kernel line in `/etc/default/limine` (`KERNEL_CMDLINE[default]`, full line) adds `quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0`, so no text shows before Plymouth.
**Why:** The disk password already proves who you are; the lock screen protects the running session. One screen for both is simpler and calmer. 一歩一歩 (step by step) is the rule for the transition to backend work. Vertical writing is classic Japanese and gives the phrase room without crowding the field (2026-11-11: reversed the earlier refusal of a vertical column).
**Not chosen:** greetd + tuigreet (broke the first install, enabled before the session was tested). SDDM with a second password. Text LUKS prompt. Musashi's phrase, Zen Kurenaido and IBM Plex for the boot phrase. 一期一会 (until 2026-11-11). Ensō (2026-11-11). The Mori crest (2026-11-11, replaced by 一歩一歩 the same night). 龍の道 (2026-11-11). 一歩一歩 horizontal (2026-11-11: vertical chosen). A kakejiku scroll behind the column, and the column on the right with the field on the left (2026-11-11). A progress bar (2026-11-11: a quiet word is enough). Fonts Potta One, Zen Kurenaido, Klee One, Zen Antique, Kaisei Tokumin (compared 2026-11-11); Yuji Syuku and Yuji Mai share Yuji Boku's kanji.
**Where:** `install/desktop.sh` (installs, never enables), `config/sddm/autologin.conf` (installed with `sed "s/@USER@/$USER/"`), `config/plymouth/ichigo/`, `/etc/default/limine`, `docs/post-install.md` step 4
**Status:** done and tested after a reboot on 2026-11-11 (one-screen vertical 一歩一歩 in Gruvbox; also tested with `plymouth-test.sh`). The crest version, tested after a reboot on 2026-11-11, is backed up in `~/backups/plymouth-ichigo-2026-11-11-crest`, next to the earlier backups (`~/backups/plymouth-ichigo-2026-11-11-phrase`, `~/backups/plymouth-ichigo-2026-11-11`; restore with `sudo install -m644 <backup>/* /usr/share/plymouth/themes/ichigo/`). Requires LUKS; without it autologin is unsafe. Theme name `ichigo`. Test from a text console with `plymouth-test.sh` (`config/bin/`, installed to `~/.local/bin/`): it shows the installed theme with a password prompt and a wrong password message, and changes neither the theme nor the initramfs. `plymouth` goes right after `systemd` (or `udev`), before `sd-encrypt` (or `encrypt`). After changing `HOOKS` or the kernel line run `sudo limine-mkinitcpio` and check the first `cmdline:` in `/boot/limine.conf`.

## Polkit agent

**Decision:** hyprpolkitagent, started from `autostart.lua` (its user unit stays disabled).
**Why:** GUI apps that need root (mounting a disk in Nautilus) fail silently without an agent.
**Not chosen:** polkit-gnome (unmaintained). A Quickshell agent (security code we would own).
**Where:** `install/desktop.sh`, `config/hypr/modules/autostart.lua`
**Status:** done

## Lock

**Decision:** hyprlock, the same screen as the boot (Login): background bar (#1d2021), no wallpaper, no date. `ippo.png` (200 x 732 physical) with `size` 160 (200 / 1.25, the smaller side) and its centre 83 logical px above the screen centre; password field 290 x 42, panel fill, line edge, placeholder secondary, its centre 278 logical px below the screen centre. hypridle dims at 4 min, locks at 5, suspends at 30, locks before sleep. Awake in the Control Center pauses dim, lock and suspend; lock before sleep stays on. Super + Ctrl + Q locks.
**Why:** Maintained upstream; a custom lock is security code we would own. One screen for boot and lock.
**Not chosen:** Quickshell lock (v3, after it is tested). The 2026-11-09 layout (100 px clock in the middle, field 240 px from the bottom). 常に兵法の道を離れず and its caption (until 2026-11-11). The date on the lock (2026-11-11: the boot cannot show it, and the screens are the same).
**Where:** `config/hypr/hyprlock.conf`, `config/hypr/ippo.png`, `config/hypr/hypridle.conf`
**Status:** done and tested 2026-11-11 (Gruvbox, the same screen as the boot): tested with `hyprlock -c` on the repo file, wrong password then right password, then installed to `~/.config/hypr/` with `ippo.png`; the Light Solid file is kept as `~/.config/hypr/hyprlock.conf.bak` and in git. Offsets are logical pixels for the laptop panel (1536 x 864 at 1.25); another monitor size moves them. Test with `hyprlock` from a terminal before replacing the old file; the old one and `musashi.png` stay in git.

## Fonts

**Decision:** IBM Plex Sans and Sans JP for the interface, PlemolJP Console NF for terminal and code, IBM Plex Serif for org headings. Yuji Boku only for 一歩一歩 on boot and lock, drawn into an image (not installed).
**Why:** Takuya Matsuyama's family: one family, three voices. Yuji Boku is the closest to brush calligraphy among the free fonts compared (2026-11-11).
**Not chosen:** `gus.ttf` (dropped 2026-11-09). PlemolJP35 (3:5 width, not used). Yuji Syuku (the lock phrase until 2026-11-11).
**Where:** `install/fonts.sh`, `config/fontconfig/`
**Status:** done. PlemolJP Console NF reports dual spacing (90) on most weights and none on Bold, so Ghostty picked Bold for everything. `config/fontconfig/conf.d/99-plemoljp-mono.conf` marks the family monospace; run `fc-cache -fr` after copying. Tested on 2026-11-10.

## Icons and cursor

**Decision:** WhiteSur light icons (`WhiteSur-light`), Apple cursor (`apple_cursor`), Adwaita (light) for GTK 3, prefer light for GTK 4. GTK belongs to the documents side and stays light under Gruvbox; the dark side (Quickshell, terminal, editors) does not use GTK.
**Not chosen:** WhiteSur dark, Adwaita dark (until 2026-11-11, with Dark Solid).
**Where:** `install/icons.sh`, `config/gtk-3.0/`, `config/gtk-4.0/`, gsettings in `docs/post-install.md`, step 3
**Status:** done and tested 2026-11-11. Brave Origin follows `color-scheme` through `xdg-desktop-portal-gtk`. fuzzel's icon theme stays WhiteSur light; check it reads on the dark panel when fuzzel moves to Gruvbox.

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
| Super + W | Wallpaper picker (`gus-wallpaper`) |
| Super + Shift + W / A / B | Open the pill on Wi-Fi / Sound / Bluetooth |
| Super + Shift + E | Log out |

Menus and the launcher are reached through Quickshell IPC: `quickshell ipc call menus toggle <section>`, `quickshell ipc call launcher toggle`.
**Where:** `config/hypr/modules/binds.lua`, `config/hypr/modules/programs.lua`
**Status:** done
