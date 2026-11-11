// A slider (pill-spec.md, Sliders): light track in line, white fill with a small shadow,
// the icon in secondary inside the fill, 7 from its left edge. The fill is never dark.
// The fill glides to outside changes and follows the pointer exactly while dragging.
// value is 0..1.
import QtQuick
import QtQuick.Effects

Item {
    id: slider
    property real value: 0
    property string icon
    property int level: -1
    property int barHeight: 24
    signal moved(real v)

    implicitHeight: barHeight
    readonly property real clamped: Math.max(0, Math.min(1, value))

    Rectangle {
        id: track
        anchors.fill: parent
        radius: 12
        color: area.containsMouse || area.pressed ? Theme.lineHover : Theme.line
        Behavior on color { ColorAnimation { duration: Theme.fast } }

        Rectangle {
            id: fill
            width: Math.max(track.height, track.width * slider.clamped)
            height: track.height
            radius: 12
            color: Theme.panel
            Behavior on width {
                enabled: !area.pressed
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "black"
                shadowOpacity: Theme.fillShadow
                shadowBlur: 0.5
                blurMax: 6
                shadowVerticalOffset: 1
            }
        }
        Glyph {
            visible: slider.icon !== ""
            name: slider.icon
            level: slider.level
            color: Theme.secondary
            width: 13; height: 13
            x: 7
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        function pick(x) { slider.moved(Math.max(0, Math.min(1, x / width))) }
        onPressed: (mouse) => pick(mouse.x)
        onPositionChanged: (mouse) => { if (pressed) pick(mouse.x) }
    }
}
