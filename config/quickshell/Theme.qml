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

    // Text
    readonly property color label: "#1d1d1f"
    readonly property color secondary: "#6e6e73"
    readonly property color tertiary: "#aeaeb2"
    // "on accent" in theme.md. Not named onAccent: QML reads on + capital as a signal handler,
    // and the property silently stayed black.
    readonly property color textOnAccent: panel    // text and glyphs on an accent fill

    // Meaning
    readonly property color accent: "#007aff"
    readonly property color green: "#248a3d"
    readonly property color red: "#d70015"

    // Type
    readonly property string sans: "IBM Plex Sans"
    readonly property string jp: "IBM Plex Sans JP"
    readonly property int body: 13

    // Grid
    readonly property int icon: 16
    readonly property int fast: 140       // ms, hover and press (pill-spec.md, Motion)

    // Panels (the Launcher).
    readonly property int radiusPanel: 18

    // Pill (desktop.md, Bar; exact values in docs/pill-spec.md).
    readonly property int pillTop: 12         // from the screen's top edge
    readonly property int pillHeight: 34      // rounding is full: radius 17 at rest
    readonly property int pillPad: 13         // text to the pill's ends
    readonly property int pillGap: 10         // between items at rest
    readonly property int pillText: 15        // date and time
    readonly property int pillOpenWidth: 480
    readonly property int calendarWidth: 384
    readonly property int openRadius: 21
    readonly property int openTop: 14         // date strip to the first block
    readonly property int openSide: 19
    readonly property int openBottom: 19
    readonly property int blockGap: 14        // between blocks of the open panel
    readonly property int rowHeight: 40       // list rows in Wi-Fi and Bluetooth
    // Small shadows under white parts: slider fill, switch knob, chosen segment (black, 0 1 3).
    readonly property real fillShadow: 0.18
    readonly property real knobShadow: 0.25
    readonly property real segmentShadow: 0.15

    // Depth without translucency: each surface falls one shade from top to bottom,
    // has a 1 px edge in line, and the panel casts one soft shadow (no blur anywhere).
    readonly property color panelTop: panel
    readonly property color panelBottom: "#f7f7f9"
    readonly property color rim: line
    readonly property color edgeSoft: line
    readonly property color wash: Qt.rgba(0, 0, 0, 0.04)        // hover
    readonly property color washStrong: Qt.rgba(0, 0, 0, 0.08)  // pressed
    readonly property int shadowPad: 28                          // room around a panel for its shadow
    readonly property real shadowOpacity: 0.12                    // black, under every panel
    readonly property color lineHover: Qt.darker(line, 1.06)     // a grey control under the pointer

    // Motion: quick for hover, slow settle for anything that changes shape.
    readonly property int glide: 300
    readonly property var settle: [0.16, 1, 0.3, 1, 1, 1]        // cubic-bezier(0.16, 1, 0.3, 1)
    readonly property real labelTracking: 1.2
}
