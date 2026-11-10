// A switch row inside a tile: blue circle on, grey off, title and state underneath.
// The circle toggles and gives a little when pressed. With a chevron, the rest of
// the row expands the section; without one, the whole row toggles.
import QtQuick

Item {
    id: row
    property string icon
    property int level: -1
    property string title
    property string detail
    property bool on: false
    property bool chevron: false
    signal toggled()
    signal expanded()

    implicitHeight: 38

    Rectangle {
        id: circle
        width: 26; height: 26; radius: 13
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: row.on ? (circleMouse.containsMouse ? Qt.lighter(Theme.accent, 1.08) : Theme.accent)
                      : (circleMouse.containsMouse ? Theme.lineHover : Theme.line)
        scale: circleMouse.pressed ? 0.92 : 1
        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }
        Glyph { name: row.icon; level: row.level; color: Theme.label; width: 14; height: 14; anchors.centerIn: parent }
        MouseArea {
            id: circleMouse
            anchors.fill: parent
            anchors.margins: -3
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: row.toggled()
        }
    }

    Column {
        id: labels
        anchors.left: circle.right
        anchors.leftMargin: 10
        anchors.right: arrow.visible ? arrow.left : parent.right
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2
        Text {
            width: parent.width
            text: row.title
            elide: Text.ElideRight
            font.family: Theme.sans
            font.pixelSize: Theme.body
            font.weight: Font.Medium
            color: Theme.label
        }
        Text {
            width: parent.width
            text: row.detail
            elide: Text.ElideRight
            font.family: Theme.sans
            font.pixelSize: 11
            color: Theme.secondary
        }
    }

    Glyph {
        id: arrow
        visible: row.chevron
        name: "chevron-right"
        width: 12; height: 12
        color: rowMouse.containsMouse ? Theme.secondary : Theme.tertiary
        anchors.right: parent.right
        anchors.rightMargin: rowMouse.containsMouse ? -2 : 0
        anchors.verticalCenter: parent.verticalCenter
        Behavior on anchors.rightMargin { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: rowMouse
        anchors.left: labels.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: row.chevron ? row.expanded() : row.toggled()
    }
}
