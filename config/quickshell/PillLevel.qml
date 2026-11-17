// Volume or brightness at rest (desktop.md, Bar; pill-spec.md, Rest): the icon, a bar and
// the percentage. Shown by Pill.qml for about 1 s after a change, like the workspace dots.
// value is 0..1. Muted: the speaker off icon, the bar and the number in tertiary.
import QtQuick

Row {
    id: pl
    property string icon: "volume"      // volume, volume-muted, sun
    property int glyphLevel: -1          // sound waves 0..2, -1 draws every part
    property real value: 0
    property bool muted: false
    spacing: Theme.pillGap

    readonly property real clamped: Math.max(0, Math.min(1, value))

    Glyph {
        anchors.verticalCenter: parent.verticalCenter
        name: pl.icon
        level: pl.glyphLevel
        color: Theme.label
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 120
        height: 6
        radius: 3
        color: Theme.line

        Rectangle {
            width: parent.width * pl.clamped
            height: parent.height
            radius: 3
            color: pl.muted ? Theme.tertiary : Theme.label
            Behavior on width {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }
    }

    // Fixed to the width of "100%", so the pill does not move as the number changes.
    TextMetrics { id: widest; font: percent.font; text: "100%" }
    Text {
        id: percent
        anchors.verticalCenter: parent.verticalCenter
        width: widest.advanceWidth
        horizontalAlignment: Text.AlignRight
        text: Math.round(pl.clamped * 100) + "%"
        font.family: Theme.sans
        font.pixelSize: 13
        font.features: { "tnum": 1 }
        color: pl.muted ? Theme.tertiary : Theme.secondary
    }
}
