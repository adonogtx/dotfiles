// A tile inside a panel: falls one shade from top to bottom, hairline edge, corners 10.
// Clickable tiles wash lighter on hover and sink a little when pressed.
import QtQuick

Rectangle {
    id: tile
    property bool clickable: false
    signal clicked()

    radius: Theme.radiusTile
    border.width: 1
    border.color: Theme.edgeSoft
    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.tileTop }
        GradientStop { position: 1.0; color: Theme.tileBottom }
    }
    scale: tile.clickable && press.pressed ? 0.985 : 1
    Behavior on scale { NumberAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: press.pressed ? Theme.washStrong : Theme.wash
        opacity: tile.clickable && press.containsMouse ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }
    }
    MouseArea {
        id: press
        anchors.fill: parent
        enabled: tile.clickable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: tile.clicked()
    }
}
