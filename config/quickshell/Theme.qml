// Light Solid tokens. Real pixels; the deck draws them at 2x.
// Same values as hypr/modules/theme.lua, ghostty, mako and fuzzel.
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // Surfaces
    readonly property color bar: "#f6f6f8"
    readonly property color panel: "#ffffff"
    readonly property color tile: "#ececf0"
    readonly property color line: "#e0e0e4"
    readonly property color hairline: line

    // Text
    readonly property color label: "#1d1d1f"
    readonly property color secondary: "#6e6e73"
    readonly property color tertiary: "#aeaeb2"
    readonly property color onAccent: panel        // text and glyphs on an accent fill

    // Meaning
    readonly property color accent: "#007aff"
    readonly property color green: "#248a3d"
    readonly property color red: "#d70015"

    // Type
    readonly property string sans: "IBM Plex Sans"
    readonly property string jp: "IBM Plex Sans JP"
    readonly property int body: 13
    readonly property int detail: 12

    // Grid
    readonly property int barHeight: 28
    readonly property int icon: 16
    readonly property int itemPad: 5      // horizontal padding inside a bar item
    readonly property int itemGap: 2      // space between bar items
    readonly property int edge: 12        // bar padding at the screen edges
    readonly property int radiusItem: 5
    readonly property int fast: 150       // ms, every animation

    // Panels. Tiles sit 8 px inside an 18 px panel, so their corners are 10.
    readonly property int radiusPanel: 18
    readonly property int radiusTile: 10
    readonly property int panelPad: 8
    readonly property int tilePad: 12
    readonly property int controlWidth: 320

    // Depth without translucency: each surface falls one shade from top to bottom,
    // has a 1 px edge in line, and the panel casts one soft shadow (no blur anywhere).
    readonly property color panelTop: panel
    readonly property color panelBottom: "#f7f7f9"
    readonly property color tileTop: tile
    readonly property color tileBottom: Qt.darker(tile, 1.02)
    readonly property color rim: line
    readonly property color edgeSoft: line
    readonly property color wash: Qt.rgba(0, 0, 0, 0.04)        // hover
    readonly property color washStrong: Qt.rgba(0, 0, 0, 0.08)  // pressed
    readonly property int shadowPad: 28                          // room around a panel for its shadow
    readonly property real shadowOpacity: 0.12                    // black, under every panel
    readonly property color lineHover: Qt.darker(line, 1.06)     // a grey control under the pointer
    readonly property color labelSoft: Qt.rgba(label.r, label.g, label.b, 0.8) // list text that is not the current one

    // Motion: quick for hover, slow settle for anything that changes shape.
    readonly property int glide: 300
    readonly property var settle: [0.16, 1, 0.3, 1, 1, 1]        // cubic-bezier(0.16, 1, 0.3, 1)
    readonly property real labelTracking: 1.2
}
