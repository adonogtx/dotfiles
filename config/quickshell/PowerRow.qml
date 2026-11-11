// A plain row with a switch (pill-spec.md): icon, name, and a switch on the right.
// Used for the Wi-Fi and Bluetooth power rows and for Night Shift in Display.
// A click anywhere on the row toggles.
import QtQuick

Item {
    id: row
    property string icon
    property string title
    property string subtitle
    property bool on: false
    signal toggled()

    implicitHeight: Theme.rowHeight

    Glyph {
        id: glyph
        name: row.icon
        color: Theme.secondary
        width: 16; height: 16
        x: 10
        anchors.verticalCenter: parent.verticalCenter
    }
    Column {
        anchors.left: glyph.right
        anchors.leftMargin: 11
        anchors.right: sw.left
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1
        Text {
            width: parent.width
            text: row.title
            elide: Text.ElideRight
            font.family: Theme.sans
            font.pixelSize: 14
            color: Theme.label
        }
        Text {
            visible: row.subtitle !== ""
            width: parent.width
            text: row.subtitle
            elide: Text.ElideRight
            font.family: Theme.sans
            font.pixelSize: 11
            color: Theme.secondary
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: row.toggled()
    }
    Switch {
        id: sw
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        on: row.on
        onToggled: row.toggled()
    }
}
