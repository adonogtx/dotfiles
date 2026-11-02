pragma Singleton

import QtQuick
import Quickshell

// Gruvbox Material, one place for every color, font and icon
Singleton {
    readonly property color bg: "#1d2021"
    readonly property color panel: "#282828"
    readonly property color item: "#32302f"
    readonly property color hover: "#2c2a29"
    readonly property color border: "#3c3836"
    readonly property color track: "#3c3836"

    readonly property color fg: "#d4be98"
    readonly property color fgStrong: "#ddc7a1"
    readonly property color fgSoft: "#a89984"
    readonly property color fgFaint: "#5a524c"

    readonly property color yellow: "#d8a657"
    readonly property color orange: "#e78a4e"
    readonly property color green: "#a9b665"
    readonly property color blue: "#7daea3"
    readonly property color red: "#ea6962"
    readonly property color aqua: "#89b482"
    readonly property color purple: "#d3869b"

    readonly property string mono: "JetBrainsMono Nerd Font"
    readonly property string kamon: "kamon"  // common/fonts/kamon.ttf, the glyph at U+E900

    function icon(codepoint) {
        return String.fromCodePoint(codepoint);
    }

    // Nerd Font, Material Design range
    readonly property string iMic: icon(0xF036C)
    readonly property string iMicOff: icon(0xF036D)
    readonly property string iBluetooth: icon(0xF00AF)
    readonly property string iBluetoothOff: icon(0xF00B2)
    readonly property string iWifi: icon(0xF05A9)
    readonly property string iWifiOff: icon(0xF05AA)
    readonly property string iVolume: icon(0xF057E)
    readonly property string iVolumeOff: icon(0xF0581)
    readonly property string iMonitor: icon(0xF0379)
    readonly property string iSpeaker: icon(0xF04C3)
    readonly property string iHeadphones: icon(0xF02CB)
    readonly property string iApp: icon(0xF08C6)
    readonly property string iLock: icon(0xF033E)
    readonly property string iBattery: icon(0xF0079)
    readonly property string iBatteryCharging: icon(0xF0084)
    readonly property string iLeaf: icon(0xF032A)
    readonly property string iBalance: icon(0xF05D1)
    readonly property string iSpeed: icon(0xF04C5)
    readonly property string iSun: icon(0xF0599)
    readonly property string iMoon: icon(0xF0594)

    // Each weekday kanji in the color of its element, indexed like Date.getDay() (0 = Sunday)
    // 日 sun, 月 moon, 火 fire, 水 water, 木 wood, 金 metal, 土 earth
    readonly property var elements: ["#ea6962", "#ddc7a1", "#e78a4e", "#7daea3", "#a9b665", "#d8a657", "#a89984"]

    // Bar date: numbers bright, 月 and 日 dim, so only the weekday carries color
    readonly property color dateNumber: fgStrong
    readonly property color dateKanji: "#7c6f64"
    readonly property color dateParen: fgFaint

    readonly property color sunday: red
    readonly property color holiday: red
    readonly property color date: orange
    readonly property string iCheck: icon(0xF012C)
}
