import QtQuick
import QtQuick.Layouts

// Slider: a 6px track filled in the section color, with a small dot that grows on hover
Item {
    id: s

    property real value: 0
    property color tint: Theme.yellow
    signal moved(real v)

    readonly property real clamped: Math.max(0, Math.min(1, value))

    Layout.fillWidth: true
    implicitHeight: 20

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 3
        color: Theme.track
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * s.clamped
        height: 6
        radius: 3
        color: s.tint
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: area.pressed || area.containsMouse ? 16 : 12
        height: width
        radius: width / 2
        x: (parent.width - width) * s.clamped
        color: s.tint
        border.width: 2
        border.color: Theme.panel

        Behavior on width {
            NumberAnimation { duration: 100 }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        function report(mx) {
            s.moved(Math.max(0, Math.min(1, mx / width)));
        }

        onPressed: mouse => report(mouse.x)
        onPositionChanged: mouse => { if (pressed) report(mouse.x); }
    }
}
