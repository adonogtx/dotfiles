# Theme · Light Solid

One set of tokens, repeated in each program's own format. When you change a value, change it everywhere in the table's last column.

## Color

| Token | Value | Used in |
|---|---|---|
| bar | #f6f6f8 | quickshell/Theme.qml |
| panel | #ffffff to #f7f7f9 | Theme.qml, mako, fuzzel, zathura statusbar, inputbar, notifications and completion, hyprlock field |
| tile | #ececf0 | Theme.qml, zathura background around pages (pages stand out), mako progress bar (progress is not a selection; label reads on both halves) |
| line | #e0e0e4 | Theme.qml, workspace tab, 1 px edges |
| terminal | #fbfbfc | ghostty/themes/light-solid |
| label | #1d1d1f | everywhere; uosc timeline fill and active items |
| secondary | #6e6e73 | Theme.qml, zathura statusbar, hyprlock placeholder |
| tertiary | #aeaeb2 | Theme.qml, fuzzel placeholder, focused window border |
| accent | #007aff | Control Center switches, Ghostty cursor and selection, zathura search, btop follow |
| green | #248a3d | charging, success |
| red | #d70015 | low battery, errors, urgent banners |
| night | #1c1c1e page, #f5f5f7 text | zathura Ctrl + R only: night mode in the old Dark Solid values |
| on accent | #ffffff (panel) | text, glyphs and switch knobs on an accent fill, Ghostty selection text |
| border | line, tertiary when focused | Hyprland windows (theme.lua), mako, fuzzel |

## ANSI palette (terminal only)

Used only by `ghostty/themes/light-solid` and, through it, by every terminal program (prompt, bat, fzf, syntax highlighting). The btop theme `btop/themes/light-solid.theme` uses the same values. Normal slots 1 to 6 read at 5:1 or more on terminal. Brights repeat the normals, because brighter variants fall under 3:1 on a light background.

| Slot | Name | Value | Note |
|---|---|---|---|
| 0 | black | #1d1d1f | label |
| 1 | red | #d70015 | red token |
| 2 | green | #1f7a36 | darker than the green token (#248a3d reads 4.25:1 on terminal); terminal only |
| 3 | yellow | #b25000 | |
| 4 | blue | #0040dd | darker than accent, for text |
| 5 | magenta | #8944ab | |
| 6 | cyan | #0071a4 | |
| 7 | white | #aeaeb2 | tertiary |
| 8 | bright black | #6e6e73 | secondary; autosuggestions, comments |
| 9 to 14 | bright colors | same as 1 to 6 | |
| 15 | bright white | #e0e0e4 | line |

## Type

| Role | Font | Size |
|---|---|---|
| Bar, menus | IBM Plex Sans JP, 500 | 13 |
| Detail | IBM Plex Sans | 12 |
| Terminal, Emacs code | PlemolJP Console NF | 13 pt, 17 px in Emacs |
| Emacs prose, headings | IBM Plex Sans, IBM Plex Serif | 17 |
| Lock clock | IBM Plex Sans Light | 100 |
| Lock phrase | IBM Plex Sans JP | 28 |

## Shape and space

| Thing | Value |
|---|---|
| Grid | 4 px |
| Bar | 28 tall, 14 px icons, 12 px edge padding |
| Windows | rounding 10, gaps 6 inside and 12 outside, 1 px hairline |
| Menus and banners | rounding 12 to 14 |
| Bar icons | one line family (`Glyph.qml`, Tabler paths), stroke 1.6 on a 24 grid, grey, full ink on hover or when open |
| Control Center | 320 wide: panel rounding 18; tiles in tile, 8 px inside, rounding 10. Main view: four 38 px circles (blue when on) with names, then Display, Sound and Microphone capsule sliders. Sections: Wi-Fi list, Bluetooth list, Sound and Display with segmented controls, Battery |
| Depth | each surface falls one shade top to bottom (panel #ffffff to #f7f7f9), a 1 px edge in line, one soft shadow under panels; no blur, no translucency |
| Motion | hover and press 140 ms ease out; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in 60 ms after its panel; panels fade out in 180 ms |
| Labels | section headings 10 px, uppercase, tracked 1.2, tertiary |
| Workspaces | tabs: line rounded square (5) behind the active number |
| Shadow | 24 range, 12% black, no blur anywhere |
| Animation | about 150 ms, ease out |
