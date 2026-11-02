import QtQuick

// A bar icon. Gets a soft background while its panel is open.
Item {
    id: b

    property string glyph: ""
    property color tint: Theme.fg
    property bool active: false
    signal clicked
    signal scrolled(int direction)

    implicitWidth: 28
    implicitHeight: 22

    Rectangle {
        anchors.fill: parent
        radius: 5
        color: Theme.item
        visible: b.active
    }

    Text {
        anchors.centerIn: parent
        text: b.glyph
        color: b.tint
        font.family: Theme.mono
        font.pixelSize: 15
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: b.clicked()
        onWheel: wheel => b.scrolled(wheel.angleDelta.y > 0 ? 1 : -1)
    }
}
