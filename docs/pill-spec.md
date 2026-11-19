# Pill spec

Exact values for the pill and its open panel, taken from the approved slides. Sizes are logical px (screen px divided by 1.25). Colors are the black system tokens from `docs/theme.md` (Color: system). When this file and the code disagree, this file wins; when this file and `desktop.md` disagree, `desktop.md` wins.

## Rest

| Part | Value |
|---|---|
| Position | centred, 12 from the top edge |
| Size | height 34, width hugs the content |
| Padding | 0 13; gap between items 10 |
| Surface | panel gradient (#0c0c0d to #000000), 1 px edge in line, the panel shadow, rounding full |
| Date | IBM Plex Sans JP 15, label: `11月11日(水)` |
| Time | same size, secondary, two spaces after the date |
| Click | anywhere on the pill opens the Control Center |

Workspace switch: for about 1 s the date fades out and the five footer dots (sizes under Footer) fade in, the pill morphing to hug them (300 ms, the shape curve); then it morphs back. Only at rest.

Level indicator (volume and brightness): on a change, for about 1 s the date fades out and the level fades in, with the same motion as the dots; a new change while it shows only resets the timer. Only at rest; nothing extra while the pill is open. Silent for 2 s after Quickshell starts and for 2 s after the default sink changes. The last of dots or level replaces the other.

| Part | Value |
|---|---|
| Icon | 16, label, `Glyph.qml`: `volume` (waves follow the level, as in the sound slider), `volume-muted`, `sun` |
| Bar | 120 × 6, rounding 3; track line, fill label |
| Number | IBM Plex Sans 13, secondary, tabular figures, right aligned in the fixed width of "100%" |
| Gap | 10 between icon, bar and number |
| Muted | speaker off icon; bar fill and number in tertiary, the volume kept |

Live items sit left of the date, 16 px icons, separated from the date by a 1 px line, 14 tall. In order, gap 10, each only while true: recording (red dot 8, elapsed time 13 label with tabular figures; a click stops it), microphone in use (icon, label), Awake on (cup, label), battery below 20% (battery icon and the percentage, 13, red; not shown while charging), disk above 90% (database icon and the use of `/`, 13, red). A click on any other item opens the Control Center like the rest of the pill.

## Open panel

| Part | Value |
|---|---|
| Width | 480 |
| Rounding | 21 |
| Padding | 14 top, 19 sides, 19 bottom |
| Gap between blocks | 14 |
| Surface | same as the pill, no inner boxes |
| Separators | 1 px line, full width inside the padding |

No card or tile background behind groups. Blocks sit directly on the panel and are separated only by the 1 px line.

Order in the main view: date (stays where it was), circles row, three sliders, line, footer.

## Circles row

| Part | Value |
|---|---|
| Layout | five equal columns |
| Circle | 38 diameter |
| On | background accent (white, #f2f2f2), icon text on accent (black, #000000) |
| Off | background tile, icon label |
| Icon | 18, stroke 1.8 |
| Name | 11, label, centred, 6 below the circle, fixed text |
| Names | Wi-Fi, Bluetooth, Night Shift, Awake, Battery |
| Click circle | toggles |
| Click name | opens the section (Night Shift and Awake have none: the name toggles) |
| Battery | nothing to toggle: the circle and the name both open the Battery section |

Never show network or device names, or percentages, under the circles. State lives in the sections.

## Sliders

| Part | Value |
|---|---|
| Label | above each slider, 10, uppercase, tracking 1.2, secondary: DISPLAY, SOUND, MICROPHONE |
| Label to track | 6 |
| Track | height 24, rounding 12, background line (#2a2a2c) |
| Fill | label (#f2f2f2), rounding 12, shadow 0 1 3 rgba(0,0,0,0.30) |
| Icon | 13, panel (#0c0c0d), inside the fill, 7 from its left edge |
| Chevron | 12, tertiary, right of the track, opens the section |
| Between sliders | 12 |

The fill is always the label color. It reports a level, not a state.

## Footer

| Part | Value |
|---|---|
| Row | after the line, height 22 |
| Left | あ, 13, secondary |
| Then | workspace dots, gap 5: active 18 × 6 in label, with windows 6 × 6 in secondary, empty 6 × 6 in tertiary, all rounding 3 |
| Right | calendar icon 14 secondary, "Calendar" 12 secondary, chevron 13 secondary; the whole group opens the calendar |

## Section header

Back chevron 16 secondary, then the title 14, weight 600, label, left aligned, on the row under the date, the same gap under the date as the circles row (row height 16). The date stays centred at the top.

## Rows (Wi-Fi, Bluetooth)

| Part | Value |
|---|---|
| Height | 40 |
| Rounding | 10 |
| Padding | 0 10, gap 11 |
| Icon | 16, no circle behind it |
| Normal | no background, icon secondary, name 14 label |
| Connected | background tile, icon label |
| Detail | right side, 12 secondary (battery %, "Connect" on a known device that is not connected, "Pair" on a nearby device) |
| Second line | optional, 11 secondary: on Wi-Fi only the connected network ("Secured, 5 GHz"); on Bluetooth "Connected" |

Wi-Fi: a lock (16, secondary, right side) on every secured network that is not connected, and no second line; the connected one says "Secured" and its band on its second line (NetworkManager on iwd reports the band only for the connected network).

White appears in rows only as the check (16, accent) on the connected Wi-Fi network. Elsewhere a white fill means on: circles, switches, today in the calendar.

Section labels between groups (CONNECTED, KNOWN, OTHER NETWORKS, MY DEVICES, NEARBY): 10, uppercase, tracking 1.2, secondary, 10 above the first row.

The power row at the top of Wi-Fi and Bluetooth is a plain row: icon, name, and a switch on the right. No accent circle, no "On" subtitle.

Bluetooth Nearby lists only devices with a name; a name that looks like an address (hex pairs joined by : or -) counts as none.

## Switch

| Part | Value |
|---|---|
| Size | 35 × 21, rounding full |
| Track | off tile, on accent (white, #f2f2f2) |
| Knob | 16; off label (#f2f2f2), on text on accent (black, #000000); shadow 0 1 3 rgba(0,0,0,0.35), 2.5 from the edge |

## Segmented control

| Part | Value |
|---|---|
| Track | background tile, rounding 8, padding 2, gap 2 |
| Cell | height 26, text 12 |
| Selected | line (#2a2a2c), rounding 6, shadow 0 1 3 rgba(0,0,0,0.30), text label |
| Other | no background, text secondary |

## Battery section

| Part | Value |
|---|---|
| Charge | number 45, weight 300, label, line height 1 |
| Status | 13 secondary, beside the number at its baseline; the green bolt (14) before it only while charging |
| Bar | height 8, rounding 4, track tile, fill label, red below 20% (`theme.md`) |
| Then | line, ENERGY MODE label, segmented control (Saver, Balanced, Performance) |

## Sound section

OUTPUT label, segmented control (only with more than one device; otherwise the device name, 12 secondary), slider; line; INPUT label, segmented control, slider. Same parts as above, no boxes.

## Display section

BRIGHTNESS label and slider, TEXT SIZE label and segmented control, line, Night Shift row with a switch. Same parts as above.

## Calendar

| Part | Value |
|---|---|
| Panel width | 384 |
| Header | `2026年11月`, IBM Plex Sans JP 18, weight 500, label; chevrons 14 secondary on the right |
| Weekdays | 日 月 火 水 木 金 土, 11, secondary, weeks start on Sunday |
| Days | 13, label, cell height 27 |
| Today | accent circle 27 (white), number in text on accent (black), weight 600 |
| Grid gap | 5 |

## Motion

Shape changes 300 ms on cubic-bezier(0.16, 1, 0.3, 1); content fades in 200 ms, 160 ms after the shape starts; on close, content fades out 120 ms before the shape shrinks. Hover and press 140 ms.
