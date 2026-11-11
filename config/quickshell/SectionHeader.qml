// Top of an expanded section, on the row under the date (pill-spec.md, Section header):
// back chevron 16 secondary, then the title 14, weight 600, label, left aligned.
// The chevron leans left a little under the pointer. The height is the chevron's 16, so the
// title's ink starts about where the circles start in the main view (same gap under the date).
import QtQuick

Item {
    id: header
    property string title
    signal back()
    implicitHeight: 16

    Row {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: mouse.containsMouse ? -2 : 0
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        Behavior on anchors.leftMargin { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Glyph {
            name: "chevron-left"
            width: 16; height: 16
            color: mouse.containsMouse ? Theme.label : Theme.secondary
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: header.title
            font.family: Theme.sans
            font.pixelSize: 14
            font.weight: Font.DemiBold
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
