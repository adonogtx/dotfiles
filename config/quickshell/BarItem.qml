// One clickable slot in the bar. No pill: the item's ink brightens on hover,
// and stays bright while its panel is open (active).
import QtQuick

Item {
    id: item
    default property alias content: row.data
    property bool active: false
    readonly property bool lit: active || mouse.containsMouse
    property color ink: lit ? Theme.label : Theme.secondary
    Behavior on ink { ColorAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }
    signal clicked()
    signal wheeled(real delta)

    implicitWidth: row.implicitWidth + Theme.itemPad * 2
    implicitHeight: Theme.barHeight - 6

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: item.clicked()
        onWheel: (wheel) => item.wheeled(wheel.angleDelta.y)
    }
}
