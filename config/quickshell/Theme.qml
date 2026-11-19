// Black system tokens (docs/theme.md, Color: system). Real pixels; the deck draws them at 2x.
// Same values as hypr/modules/theme.lua, mako, fuzzel and uosc. The terminal stays Gruvbox (Color: code).
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // Surfaces
    readonly property color bar: "#000000"
    readonly property color panel: "#0c0c0d"
    readonly property color tile: "#1f1f21"
    readonly property color line: "#2a2a2c"

    // Text
    readonly property color label: "#d8d8d8"
    readonly property color secondary: "#8c8c8c"
    readonly property color tertiary: "#636366"
    // "on accent" in theme.md. Not named onAccent: QML reads on + capital as a signal handler,
    // and the property silently stayed black.
    readonly property color textOnAccent: bar      // text, glyphs and knobs on an accent fill (#000000)

    // Meaning
    readonly property color accent: "#d8d8d8"
    readonly property color green: "#46a758"
    readonly property color red: "#e5484d"
    // Hover on an accent fill: a step darker.
    readonly property color accentHover: Qt.darker(accent, 1.08)

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
    // Small shadows under raised parts: slider fill, switch knob, chosen segment (black, 0 1 3).
    readonly property real fillShadow: 0.30
    readonly property real knobShadow: 0.35
    readonly property real segmentShadow: 0.30
    readonly property color shadow: "#000000"                     // every shadow (theme.md, shadow)

    // Depth without translucency: each surface falls one shade from top to bottom,
    // has a 1 px edge in line, and the panel casts one soft shadow (no blur anywhere).
    readonly property color panelTop: panel
    readonly property color panelBottom: "#000000"
    readonly property color rim: line
    readonly property color edgeSoft: line
    readonly property color wash: Qt.rgba(1, 1, 1, 0.04)        // hover, light over the dark panel
    readonly property color washStrong: Qt.rgba(1, 1, 1, 0.08)  // pressed
    readonly property int shadowPad: 28                          // room around a panel for its shadow
    readonly property real shadowOpacity: 0.30                    // black, under every panel (theme.md, Shadow)
    readonly property color lineHover: Qt.lighter(line, 1.15)    // a grey control under the pointer

    // Motion: quick for hover, slow settle for anything that changes shape.
    readonly property int glide: 300
    readonly property var settle: [0.16, 1, 0.3, 1, 1, 1]        // cubic-bezier(0.16, 1, 0.3, 1)
    readonly property real labelTracking: 1.2
}
