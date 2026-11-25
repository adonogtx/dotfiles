# Theme · black system, Gruvbox code

Three sides (`desktop.md`, Theme, decided 2026-11-18). Black for the system: the pill, Control Center, calendar, Launcher, fuzzel, mako, uosc, window borders. Gruvbox dark hard for code: Ghostty and everything in it (bat, fzf, btop, rmpc, fastfetch), IntelliJ, Doom Emacs. Light for documents: GTK apps, Brave Origin, Anki, the zathura page. Boot and lock use the system tokens over a fixed photo (decided 2026-11-25). One set of tokens per side, repeated in each program's own format. When you change a value, change it everywhere in the table's last column.

## Color: system (black)

| Token | Value | Used in |
|---|---|---|
| bar | #000000 | uosc curtain |
| panel | #0c0c0d to #000000 | Theme.qml, mako, fuzzel, Launcher, uosc bars and menus |
| tile | #1f1f21 | Theme.qml (circles that are off, connected rows, switch track off, segmented track), mako progress bar |
| line | #2a2a2c | Theme.qml, slider track, 1 px edges, segmented selected cell, window border |
| label | #d8d8d8 | everywhere on the system; slider fill, switch knob off, uosc timeline fill |
| secondary | #8c8c8c | Theme.qml, placeholder, time in the pill |
| tertiary | #636366 | Theme.qml, fuzzel placeholder, focused window border |
| accent | #d8d8d8 | pill circles that are on, Control Center switches on, today in the calendar, the connected Wi-Fi check, Launcher and fuzzel selection, uosc search matches |
| text on accent | #000000 | text, glyphs and knobs on an accent fill (`textOnAccent` in Theme.qml) |
| green | #46a758 | charging, success |
| red | #e5484d | low battery, errors, urgent banners |
| shadow | 30% to 45% black | under panels and raised parts |
| border | line, tertiary when focused | Hyprland windows (theme.lua), mako, fuzzel |

White means on or selected; green and red only report state.

## Color: boot and lock

Plymouth (`config/plymouth/ichigo/`) and hyprlock (`config/hypr/`) use the system tokens (Color: system) over one fixed photo (`background.png` / `lock-background.png`), decided 2026-11-25. No palette of their own (matcha 2026-11-19 to 2026-11-25).

| Part | Token | Value |
|---|---|---|
| fallback behind the photo | bar | #000000 |
| field fill | panel | #0c0c0d |
| field border, 2 px | line | #2a2a2c |
| wrong password border, 1.2 s | red | #e5484d |
| loading bar track inside the field, 296 x 4 | line | #2a2a2c |
| loading bar fill, grows to 296 x 4 | label | #d8d8d8 |
| password dots, lock clock | label | #d8d8d8 |
| lock date, lock placeholder パスワードを入力 | secondary | #8c8c8c |

## Color: code (Gruvbox)

Gruvbox dark hard, for Ghostty and everything in it, IntelliJ (Gruvbox Islands Dark Hard, `dev.md`, IDE) and Doom Emacs (`doom-gruvbox`, `apps.md`, Notes).

| Token | Value | Used in |
|---|---|---|
| terminal | #1d2021 | ghostty/themes/gruvbox, editor background |
| panel | #282828 | rmpc modal |
| tile | #3c3836 | fzf current line, rmpc |
| line | #504945 | fzf border, rmpc modal border |
| label | #ebdbb2 | foreground, fastfetch values and date |
| secondary | #a89984 | rmpc text, time in fastfetch |
| tertiary | #7c6f64 | line numbers, rmpc icons and modes that are off, "step by step" in fastfetch |
| accent | #83a598 | Ghostty cursor and selection, fzf matches and prompt, rmpc selection, btop follow |
| on accent | #1d2021 | text on an accent fill, Ghostty selection text |
| green | #b8bb26 | success |
| red | #fb4934 | errors |
| phrase | #fbf1c7 | 一歩一歩 in fastfetch only |

Blue only selects, green and red only report state. The one exception is the fastfetch logo bands below.

### ANSI palette (terminal only)

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

### Logo bands (fastfetch only)

The 道 logo in `config/fastfetch/do.txt` is drawn in six bands, top to bottom; each key takes the color of the band beside it. Used nowhere else. All are standard Gruvbox dark colors: five are the ANSI brights (10, 11, 9, 13, 14), and orange #fe8019 is Gruvbox's bright orange, outside the 16 slots.

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

## Type

| Role | Font | Size |
|---|---|---|
| Pill date | IBM Plex Sans JP, 500 | 15 |
| Detail | IBM Plex Sans | 12 |
| Terminal, Emacs code | PlemolJP Console NF | 13 pt, 17 px in Emacs |
| Emacs prose, headings | IBM Plex Sans, IBM Plex Serif | 17 |
| Lock clock | IBM Plex Sans, SemiBold, letter spacing -7 | 228 physical |
| Lock date | IBM Plex Sans JP, Bold | 41 physical |
| Lock placeholder | IBM Plex Sans JP, Regular | 24 physical |

## Shape and space

| Thing | Value |
|---|---|
| Grid | 4 px |
| Windows | rounding 10, gaps 6 inside and 12 outside, 1 px hairline |
| Menus and banners | rounding 12 to 14 |
| Pill icons | one line family (`Glyph.qml`, Tabler paths), stroke 1.8 on a 24 grid; sizes and colors in `pill-spec.md` |
| Pill and Control Center | every size, color and motion in `pill-spec.md` |
| Depth | each surface falls one shade top to bottom (panel #0c0c0d to #000000), a 1 px edge in line, one soft shadow under panels; no blur, no translucency |
| Motion | hover and press 140 ms; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in 200 ms, 160 ms after the shape starts; on close, content fades out 120 ms before the shape shrinks (`pill-spec.md`, Motion) |
| Labels | section headings 10 px, uppercase, tracked 1.2, secondary |
| Shadow | 24 range, 30% to 45% black, no blur anywhere |
| Window animation | about 150 ms, ease out (Hyprland, `desktop.md`, Windows) |
