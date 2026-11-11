// One line icon. Every icon shares the same stroke, so the bar reads as one family.
// level: Wi-Fi 0..3 arcs, sound 0..2 waves; -1 draws every part.
// Paths adapted from Tabler Icons (MIT License, https://tabler.io/icons), 24 x 24 grid.
// Parts that are off draw faint, which is how Wi-Fi and sound show their level.
import QtQuick
import QtQuick.Shapes

Item {
    id: glyph
    property string name
    property int level: -1
    property color color: Theme.secondary
    property real stroke: 1.8

    implicitWidth: Theme.icon
    implicitHeight: Theme.icon

    readonly property var wifiArcs: [
        "M9.172 15.172a4 4 0 0 1 5.656 0",
        "M6.343 12.343a8 8 0 0 1 11.314 0",
        "M3.515 9.515c4.686 -4.687 12.284 -4.687 17 0"
    ]
    readonly property string wifiDot: "M12 18m-1.1 0a1.1 1.1 0 1 0 2.2 0a1.1 1.1 0 1 0 -2.2 0"
    readonly property string speaker: "M6 15h-2a1 1 0 0 1 -1 -1v-4a1 1 0 0 1 1 -1h2l3.5 -4.5a.8 .8 0 0 1 1.5 .5v14a.8 .8 0 0 1 -1.5 .5l-3.5 -4.5"
    readonly property var speakerWaves: ["M15 8a5 5 0 0 1 0 8", "M17.7 5a9 9 0 0 1 0 14"]

    readonly property var simple: ({
        "bluetooth": ["M7 8l10 8l-5 4l0 -16l5 4l-10 8"],
        "search": ["M3 10a7 7 0 1 0 14 0a7 7 0 1 0 -14 0", "M21 21l-6 -6"],
        "adjustments": [
            "M12 6a2 2 0 1 0 4 0a2 2 0 1 0 -4 0", "M4 6l8 0", "M16 6l4 0",
            "M6 12a2 2 0 1 0 4 0a2 2 0 1 0 -4 0", "M4 12l2 0", "M10 12l10 0",
            "M15 18a2 2 0 1 0 4 0a2 2 0 1 0 -4 0", "M4 18l11 0", "M19 18l1 0"
        ],
        "sun": [
            "M8 12a4 4 0 1 0 8 0a4 4 0 1 0 -8 0",
            "M3 12h1m8 -9v1m8 8h1m-9 8v1m-6.4 -15.4l.7 .7m12.1 -.7l-.7 .7m0 11.4l.7 .7m-12.1 -.7l-.7 .7"
        ],
        "camera": [
            "M5 7h1a2 2 0 0 0 2 -2a1 1 0 0 1 1 -1h6a1 1 0 0 1 1 1a2 2 0 0 0 2 2h1a2 2 0 0 1 2 2v9a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-9a2 2 0 0 1 2 -2",
            "M9 13a3 3 0 1 0 6 0a3 3 0 0 0 -6 0"
        ],
        "record": ["M12 12m-6 0a6 6 0 1 0 12 0a6 6 0 1 0 -12 0"],
        "chevron-right": ["M9 6l6 6l-6 6"],
        "chevron-left": ["M15 6l-6 6l6 6"],
        "check": ["M5 12l5 5l10 -10"],
        "moon": ["M12 3c.132 0 .263 0 .393 0a7.5 7.5 0 0 0 7.92 12.446a9 9 0 1 1 -8.313 -12.454z"],
        "battery": ["M6 7h11a2 2 0 0 1 2 2v.5a.5 .5 0 0 0 .5 .5a.5 .5 0 0 1 .5 .5v3a.5 .5 0 0 1 -.5 .5a.5 .5 0 0 0 -.5 .5v.5a2 2 0 0 1 -2 2h-11a2 2 0 0 1 -2 -2v-6a2 2 0 0 1 2 -2"],
        "bolt": ["M13 3l0 7l6 0l-8 11l0 -7l-6 0l8 -11"],
        "lock": [
            "M5 13a2 2 0 0 1 2 -2h10a2 2 0 0 1 2 2v6a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-6z",
            "M8 11v-4a4 4 0 1 1 8 0v4"
        ],
        "headphones": [
            "M4 15a2 2 0 0 1 2 -2h1a2 2 0 0 1 2 2v3a2 2 0 0 1 -2 2h-1a2 2 0 0 1 -2 -2l0 -3",
            "M15 15a2 2 0 0 1 2 -2h1a2 2 0 0 1 2 2v3a2 2 0 0 1 -2 2h-1a2 2 0 0 1 -2 -2l0 -3",
            "M4 15v-3a8 8 0 0 1 16 0v3"
        ],
        "mouse": ["M6 7a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v10a4 4 0 0 1 -4 4h-4a4 4 0 0 1 -4 -4z", "M12 7l0 4"],
        "keyboard": [
            "M2 8a2 2 0 0 1 2 -2h16a2 2 0 0 1 2 2v8a2 2 0 0 1 -2 2h-16a2 2 0 0 1 -2 -2z",
            "M6 10l0 .01", "M10 10l0 .01", "M14 10l0 .01", "M18 10l0 .01", "M6 14l0 .01", "M18 14l0 .01", "M10 14l4 .01"
        ],
        "phone": ["M6 5a2 2 0 0 1 2 -2h8a2 2 0 0 1 2 2v14a2 2 0 0 1 -2 2h-8a2 2 0 0 1 -2 -2v-14z", "M11 4h2", "M12 17v.01"],
        "laptop": ["M3 19l18 0", "M5 7a1 1 0 0 1 1 -1h12a1 1 0 0 1 1 1v8a1 1 0 0 1 -1 1h-12a1 1 0 0 1 -1 -1z"],
        "tv": ["M3 9a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v9a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2l0 -9z", "M16 3l-4 4l-4 -4"],
        "microphone": [
            "M9 5a3 3 0 0 1 3 -3a3 3 0 0 1 3 3v5a3 3 0 0 1 -3 3a3 3 0 0 1 -3 -3z",
            "M5 10a7 7 0 0 0 14 0", "M8 21l8 0", "M12 17l0 4"
        ]
    })

    function partsFor(name, level) {
        const all = level < 0
        if (name === "wifi") {
            const p = [{ d: wifiDot, on: true, fill: true }]
            for (let i = 0; i < 3; i++) p.push({ d: wifiArcs[i], on: all || level > i, fill: false })
            return p
        }
        if (name === "wifi-off") {
            const p = [{ d: wifiDot, on: false, fill: true }]
            for (let i = 0; i < 3; i++) p.push({ d: wifiArcs[i], on: false, fill: false })
            p.push({ d: "M3 3l18 18", on: true, fill: false })
            return p
        }
        if (name === "volume") {
            const p = [{ d: speaker, on: true, fill: false }]
            for (let i = 0; i < 2; i++) p.push({ d: speakerWaves[i], on: all || level > i, fill: false })
            return p
        }
        if (name === "volume-muted")
            return [{ d: speaker, on: true, fill: false }, { d: "M16 10l4 4m0 -4l-4 4", on: true, fill: false }]
        const list = simple[name] || []
        return list.map(d => ({ d: d, on: true, fill: false }))
    }

    readonly property var parts: partsFor(name, level)
    // Optical centring: Wi-Fi carries its ink low (dot at the bottom, faint outer arcs), so it moves up.
    readonly property var offsets: ({ "wifi": -1.5, "wifi-off": -1.5 })
    readonly property color faint: Qt.rgba(color.r, color.g, color.b, color.a * 0.28)

    Repeater {
        model: glyph.parts

        Shape {
            required property var modelData
            width: 24
            height: 24
            y: (glyph.offsets[glyph.name] || 0) * glyph.width / 24
            scale: glyph.width / 24
            transformOrigin: Item.TopLeft
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: modelData.on ? glyph.color : glyph.faint
                strokeWidth: glyph.stroke
                fillColor: modelData.fill ? strokeColor : "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                PathSvg { path: modelData.d }
            }
        }
    }
}
