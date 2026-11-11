// A slider: dark capsule, white fill with a dark icon drawn inside it.
// The fill glides to outside changes, follows the pointer exactly while dragging,
// and the track lightens a touch under the pointer. value is 0..1.
import QtQuick

Item {
    id: slider
    property real value: 0
    property string icon
    property int level: -1
    property int barHeight: 22
    signal moved(real v)

    implicitHeight: barHeight
    readonly property real clamped: Math.max(0, Math.min(1, value))

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: area.containsMouse || area.pressed ? Theme.lineHover : Theme.line
        Behavior on color { ColorAnimation { duration: Theme.fast } }
        clip: true

        Rectangle {
            id: fill
            width: Math.max(track.height, track.width * slider.clamped)
            height: track.height
            radius: track.radius
            color: Theme.label
            Behavior on width {
                enabled: !area.pressed
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }
        Glyph {
            visible: slider.icon !== ""
            name: slider.icon
            level: slider.level
            color: Theme.panel
            stroke: 2
            width: 13; height: 13
            anchors.left: parent.left
            anchors.leftMargin: (track.height - 13) / 2 + 1
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
