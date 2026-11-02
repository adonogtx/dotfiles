import QtQuick

Rectangle {
    id: t

    property bool checked: false
    property color tint: Theme.yellow
    signal toggled

    implicitWidth: 36
    implicitHeight: 20
    radius: 10
    color: checked ? tint : Theme.track

    Rectangle {
        y: 3
        x: t.checked ? t.width - 17 : 3
        width: 14
        height: 14
        radius: 7
        color: t.checked ? Theme.bg : Theme.fgSoft

        Behavior on x {
            NumberAnimation { duration: 120 }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: t.toggled()
    }
}
