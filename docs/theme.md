# Theme · Dark Solid

One set of tokens, repeated in each program's own format. When you change a value, change it everywhere in the table's last column.

## Color

| Token | Value | Used in |
|---|---|---|
| bar | #161618 | quickshell/Theme.qml |
| panel | #1f1f21 | Theme.qml, mako, fuzzel, zathura inputbar, hyprlock field |
| tile | #2a2a2d | Theme.qml |
| line | #38383a | Theme.qml |
| terminal | #1c1c1e | ghostty/themes/dark-solid |
| label | #f5f5f7 | everywhere |
| secondary | #98989d | Theme.qml, zathura statusbar, hyprlock placeholder |
| tertiary | #636366 | Theme.qml, fuzzel placeholder |
| accent | #0a84ff | Control Center switches, Ghostty cursor, zathura search |
| green | #30d158 | charging, success |
| red | #ff453a | low battery, errors, urgent banners |
| border | rgba(255,255,255,0.07 to 0.18) | Hyprland windows (theme.lua), mako, fuzzel |

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
| Control Center | macOS style, 320 wide: panel #232325 to #1c1c1e rounding 18; tiles #2c2c2f to #262629 8 px inside, rounding 10. Main view: four 38 px circles (blue when on) with names, then Display, Sound and Microphone capsule sliders. Sections: Wi-Fi list, Bluetooth list, Sound and Display with segmented controls, Battery |
| Depth | each surface falls one shade top to bottom, a 1 px edge (white 4.5 to 7%), a 1 px light on the panel's top edge, one soft shadow under panels; no blur, no translucency |
| Motion | hover and press 140 ms ease out; anything that changes shape 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in 60 ms after its panel; panels fade out in 180 ms |
| Labels | section headings 10 px, uppercase, tracked 1.2, tertiary |
| Workspaces | tabs: #38383a rounded square (5) behind the active number |
| Shadow | 24 range, 45% black, no blur anywhere |
| Animation | about 150 ms, ease out |
