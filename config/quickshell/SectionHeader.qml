// Top of an expanded section: a back chevron and the section name.
// The chevron leans left a little under the pointer.
import QtQuick

Item {
    id: header
    property string title
    signal back()
    implicitHeight: 30

    Row {
        anchors.left: parent.left
        anchors.leftMargin: mouse.containsMouse ? 2 : 6
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
        Behavior on anchors.leftMargin { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Glyph {
            name: "chevron-left"
            width: 14; height: 14
            color: mouse.containsMouse ? Theme.label : Theme.secondary
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: header.title
            font.family: Theme.sans
            font.pixelSize: 14
            font.weight: Font.Medium
            color: Theme.label
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: header.back()
    }
}
