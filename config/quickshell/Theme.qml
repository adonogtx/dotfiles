// Dark Solid tokens. Real pixels; the deck draws them at 2x.
// Same values as hypr/modules/theme.lua, ghostty, mako and fuzzel.
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // Surfaces
    readonly property color bar: "#161618"
    readonly property color panel: "#1f1f21"
    readonly property color tile: "#2a2a2d"
    readonly property color line: "#38383a"
    readonly property color hairline: Qt.rgba(1, 1, 1, 0.06)
    readonly property color hover: Qt.rgba(1, 1, 1, 0.14)

    // Text
    readonly property color label: "#f5f5f7"
    readonly property color secondary: "#98989d"
    readonly property color tertiary: "#636366"

    // Meaning
    readonly property color accent: "#0a84ff"
    readonly property color green: "#30d158"
    readonly property color red: "#ff453a"

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
    readonly property color panelBorder: Qt.rgba(1, 1, 1, 0.08)

    // Depth without translucency: each surface falls one shade from top to bottom,
    // has a hairline edge, and the panel casts one soft shadow (no blur anywhere).
    readonly property color panelTop: "#232325"
    readonly property color panelBottom: "#1c1c1e"
    readonly property color tileTop: "#2c2c2f"
    readonly property color tileBottom: "#262629"
    readonly property color rim: Qt.rgba(1, 1, 1, 0.07)
    readonly property color edgeSoft: Qt.rgba(1, 1, 1, 0.045)
    readonly property color sheen: Qt.rgba(1, 1, 1, 0.05)       // 1 px light on a panel's top edge
    readonly property color wash: Qt.rgba(1, 1, 1, 0.06)        // hover
    readonly property color washStrong: Qt.rgba(1, 1, 1, 0.10)  // pressed
    readonly property int shadowPad: 28                          // room around a panel for its shadow
    readonly property color lineHover: "#444447"                 // a grey control under the pointer
    readonly property color labelSoft: "#d1d1d6"                 // list text that is not the current one

    // Motion: quick for hover, slow settle for anything that changes shape.
    readonly property int glide: 300
    readonly property var settle: [0.16, 1, 0.3, 1, 1, 1]        // cubic-bezier(0.16, 1, 0.3, 1)
    readonly property real labelTracking: 1.2
}
