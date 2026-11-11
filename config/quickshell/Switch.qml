// An iOS style switch: grey track off, blue on; the knob slides, and stretches while pressed.
// Adapted from Ricelin's LinkToggle (MIT, github.com/Gakuseei/Ricelin).
import QtQuick

Rectangle {
    id: sw
    property bool on: false
    signal toggled()

    readonly property real knob: 14
    readonly property real inset: 2

    implicitWidth: 32
    implicitHeight: 18
    radius: height / 2
    color: on ? (area.containsMouse ? Qt.lighter(Theme.accent, 1.08) : Theme.accent)
              : (area.containsMouse ? Theme.lineHover : Theme.line)
    Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        height: sw.knob
        width: area.pressed ? sw.knob + 4 : sw.knob
        radius: height / 2
        color: Theme.onAccent
        x: sw.on ? sw.width - width - sw.inset : sw.inset
        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sw.toggled()
    }
}
