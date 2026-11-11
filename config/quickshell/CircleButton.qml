// A big round switch with a name under it, the top row of the Control Center.
// The circle toggles and gives a little when pressed; the name opens the section.
import QtQuick

Item {
    id: btn
    property string icon
    property int level: -1
    property string label
    property bool on: false
    signal toggled()
    signal opened()

    implicitWidth: 64
    implicitHeight: 62

    Rectangle {
        id: circle
        width: 38; height: 38; radius: 19
        anchors.horizontalCenter: parent.horizontalCenter
        color: btn.on ? (mouse.containsMouse ? Qt.lighter(Theme.accent, 1.08) : Theme.accent)
                      : (mouse.containsMouse ? Theme.lineHover : Theme.line)
        scale: mouse.pressed ? 0.92 : 1
        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }
        Glyph { name: btn.icon; level: btn.level; color: btn.on ? Theme.onAccent : Theme.label; width: 17; height: 17; anchors.centerIn: parent }
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.toggled()
        }
    }

    Text {
        anchors.top: circle.bottom
        anchors.topMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: btn.label
        elide: Text.ElideRight
        font.family: Theme.sans
        font.pixelSize: 11
        color: nameMouse.containsMouse ? Theme.label : Theme.secondary
        Behavior on color { ColorAnimation { duration: Theme.fast } }
        MouseArea {
            id: nameMouse
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.opened()
        }
    }
}
