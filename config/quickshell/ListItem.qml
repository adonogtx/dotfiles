// One entry in an expanded section: a small circle icon, a name, a note or a check.
// current entries get a blue circle; the row washes in softly under the pointer.
import QtQuick

Rectangle {
    id: item
    property string icon
    property int level: -1
    property string text
    property string note
    property bool current: false
    property bool busy: false
    signal activated()

    implicitHeight: 34
    radius: 8
    color: mouse.pressed ? Theme.washStrong : mouse.containsMouse ? Theme.wash : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.fast; easing.type: Easing.OutCubic } }

    Rectangle {
        id: circle
        width: 24; height: 24; radius: 12
        x: 6
        anchors.verticalCenter: parent.verticalCenter
        color: item.current ? Theme.accent : Theme.line
        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Glyph { name: item.icon; level: item.level; color: Theme.label; width: 13; height: 13; anchors.centerIn: parent }
    }
    Text {
        anchors.left: circle.right
        anchors.leftMargin: 10
        anchors.right: noteText.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: item.text
        elide: Text.ElideRight
        font.family: Theme.sans
        font.pixelSize: Theme.body
        color: item.current ? Theme.label : Theme.labelSoft
    }
    Text {
        id: noteText
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: item.note
        font.family: Theme.sans
        font.pixelSize: 11
        color: Theme.secondary
        SequentialAnimation on opacity {
            running: item.busy
            loops: Animation.Infinite
            NumberAnimation { from: 1; to: 0.35; duration: 700; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.35; to: 1; duration: 700; easing.type: Easing.InOutSine }
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
