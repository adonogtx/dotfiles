# Theme · Gruvbox

Gruvbox dark hard for the system (pill, launcher, notifications, terminal, editors, boot and lock); documents stay light (GTK apps, Brave Origin, Anki, the zathura page). One set of tokens per side, repeated in each program's own format. When you change a value, change it everywhere in the table's last column.

## Color: system (dark)

| Token | Value | Used in |
|---|---|---|
| bar | #1d2021 | Plymouth and hyprlock background |
| panel | #282828 to #262626 | Theme.qml, mako, fuzzel, Launcher, hyprlock and Plymouth field |
| tile | #3c3836 | Theme.qml (circles that are off, connected rows, switch track off, segmented track), mako progress bar |
| line | #504945 | Theme.qml, slider track, 1 px edges, segmented selected cell, field edge |
| terminal | #1d2021 | ghostty/themes/gruvbox, editor background |
| label | #ebdbb2 | everywhere; slider fill, switch knob, uosc timeline fill, fastfetch values and date |
| secondary | #a89984 | Theme.qml, loading word, placeholder, time in the pill and in fastfetch |
| tertiary | #7c6f64 | Theme.qml, fuzzel placeholder, focused window border, line numbers, "step by step" in fastfetch |
| accent | #83a598 | Control Center switches, pill circles that are on, the connected Wi-Fi check, Launcher selection, Ghostty cursor and selection, btop follow |
| on accent | #1d2021 | text, glyphs and knobs on an accent fill (`textOnAccent` in Theme.qml), Ghostty selection text |
| green | #b8bb26 | charging, success |
| red | #fb4934 | low battery, errors, urgent banners |
| phrase | #fbf1c7 | 一歩一歩 on boot, lock and fastfetch only |
| border | line, tertiary when focused | Hyprland windows (theme.lua), mako, fuzzel |

Blue only selects, green and red only report state. The one exception is the fastfetch logo bands below.

## Logo bands (fastfetch only)

The 道 logo in `config/fastfetch/do.txt` is drawn in six bands, top to bottom; each key takes the color of the band beside it. Used nowhere else. All are standard Gruvbox dark colors: five are the ANSI brights (10, 11, 9, 13, 14), and orange #fe8019 is Gruvbox's bright orange, outside the 16 slots. Kept during the palette freeze (2026-11-11): no new color invented.

| Band | Value | Band | Value |
|---|---|---|---|
| 1 green | #b8bb26 | 4 red | #fb4934 |
| 2 yellow | #fabd2f | 5 purple | #d3869b |
| 3 orange | #fe8019 | 6 aqua | #8ec07c |

## Color: documents (light)

Kept from Light Solid for what is read like paper: GTK 3 and 4 (Adwaita light, WhiteSur light icons), Brave Origin (`color-scheme` prefer light), Anki, zathura.

| Token | Value | Used in |
|---|---|---|
| page | #ffffff | zathura statusbar, inputbar, completion |
| page tile | #ececf0 | zathura background around pages |
| page label | #1d1d1f | zathura text |
| page accent | #007aff | zathura search |
| night | #1c1c1e page, #f5f5f7 text | zathura Ctrl + R |

## ANSI palette (terminal only)

The standard Gruvbox dark palette, used by `ghostty/themes/gruvbox` and through it by every terminal program (prompt, bat `ansi` theme, fzf, syntax highlighting). The btop theme `btop/themes/gruvbox.theme` uses the same values. Text slots are the brights (9 to 14); normals stay for backgrounds and dim text.

| Slot | Value | Slot | Value |
|---|---|---|---|
| 0 black | #282828 | 8 bright black | #928374 |
| 1 red | #cc241d | 9 bright red | #fb4934 |
| 2 green | #98971a | 10 bright green | #b8bb26 |
| 3 yellow | #d79921 | 11 bright yellow | #fabd2f |
| 4 blue | #458588 | 12 bright blue | #83a598 |
| 5 magenta | #b16286 | 13 bright magenta | #d3869b |
| 6 cyan | #689d6a | 14 bright cyan | #8ec07c |
| 7 white | #a89984 | 15 bright white | #ebdbb2 |

Foreground #ebdbb2, background #1d2021, cursor accent, selection accent with on accent text.

## Type

| Role | Font | Size |
|---|---|---|
| Pill date | IBM Plex Sans JP, 500 | 15 |
| Detail | IBM Plex Sans | 12 |
| Terminal, Emacs code | PlemolJP Console NF | 13 pt, 17 px in Emacs |
| Emacs prose, headings | IBM Plex Sans, IBM Plex Serif | 17 |
| Boot and lock phrase | Yuji Boku, drawn into an image (`ippo.png`, vertical) | 180 px glyphs, image 200 x 732 physical |
| Boot loading word | IBM Plex Sans, drawn into an image (`loading.png`), secondary | image |

## Shape and space

| Thing | Value |
|---|---|
| Grid | 4 px |
| Windows | rounding 10, gaps 6 inside and 12 outside, 1 px hairline |
| Menus and banners | rounding 12 to 14 |
| Pill icons | one line family (`Glyph.qml`, Tabler paths), stroke 1.8 on a 24 grid; sizes and colors in `pill-spec.md` |
| Pill and Control Center | every size, color and motion in `pill-spec.md` |
| Depth | each surface falls one shade top to bottom (panel #282828 to #262626), a 1 px edge in line, one soft shadow under panels; no blur, no translucency |
| Motion | hover and press 140 ms; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in 200 ms, 160 ms after the shape starts; on close, content fades out 120 ms before the shape shrinks (`pill-spec.md`, Motion) |
| Labels | section headings 10 px, uppercase, tracked 1.2, secondary |
| Shadow | 24 range, 30% black, no blur anywhere |
| Window animation | about 150 ms, ease out (Hyprland, `desktop.md`, Windows) |
