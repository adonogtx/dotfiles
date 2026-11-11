// One row in Wi-Fi or Bluetooth (pill-spec.md, Rows): height 40, rounding 10, padding 0 10,
// gap 11, icon 16 with no circle. Normal: no background, icon secondary, name 14 label.
// Connected (current): tile background, icon label. Detail on the right, 12 secondary
// ("Connect", "Pair", battery %); an optional second line, 11 secondary. checked draws the blue check;
// locked draws the lock (16, secondary) on a secured Wi-Fi network that is not connected.
import QtQuick

Rectangle {
    id: item
    property string icon
    property int level: -1
    property string text
    property string subtitle
    property string note
    property bool current: false
    property bool checked: false
    property bool locked: false
    property bool busy: false
    signal activated()

    implicitHeight: Theme.rowHeight
    radius: 10
    color: item.current ? Theme.tile
         : mouse.pressed ? Theme.washStrong : mouse.containsMouse ? Theme.wash : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }

    Glyph {
        id: glyph
        name: item.icon
        level: item.level
        color: item.current ? Theme.label : Theme.secondary
        width: 16; height: 16
        x: 10
        anchors.verticalCenter: parent.verticalCenter
    }
    Column {
        anchors.left: glyph.right
        anchors.leftMargin: 11
        anchors.right: right.left
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1
        Text {
            width: parent.width
            text: item.text
            elide: Text.ElideRight
            font.family: Theme.sans
            font.pixelSize: 14
            color: Theme.label
        }
        Text {
            visible: item.subtitle !== ""
            width: parent.width
            text: item.subtitle
            elide: Text.ElideRight
            font.family: Theme.sans
            font.pixelSize: 11
            color: Theme.secondary
        }
    }
    Row {
        id: right
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        Text {
            visible: item.note !== ""
            anchors.verticalCenter: parent.verticalCenter
            text: item.note
            font.family: Theme.sans
            font.pixelSize: 12
            color: Theme.secondary
            SequentialAnimation on opacity {
                running: item.busy
                loops: Animation.Infinite
                NumberAnimation { from: 1; to: 0.35; duration: 700; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.35; to: 1; duration: 700; easing.type: Easing.InOutSine }
            }
        }
        Glyph {
            visible: item.locked
            anchors.verticalCenter: parent.verticalCenter
            name: "lock"
            width: 16; height: 16
            color: Theme.secondary
        }
        Glyph {
            visible: item.checked
            anchors.verticalCenter: parent.verticalCenter
            name: "check"
            width: 16; height: 16
            color: Theme.accent
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: item.activated()
    }
}
