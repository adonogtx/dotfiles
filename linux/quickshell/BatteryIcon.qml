import QtQuick
import QtQuick.Layouts

// Battery drawn like the macOS one: outline, fill and a small cap
Item {
    id: bat

    property real level: 1
    property color tint: Theme.green
    property bool showPercent: false
    property bool active: false
    signal clicked

    implicitWidth: row.implicitWidth + 10
    implicitHeight: 22

    Rectangle {
        anchors.fill: parent
        radius: 5
        color: Theme.item
        visible: bat.active
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            visible: bat.showPercent
            text: Math.round(bat.level * 100) + "%"
            color: bat.tint
            font.family: Theme.mono
            font.pixelSize: 13
        }

        Item {
            implicitWidth: 25
            implicitHeight: 13

            Rectangle {
                width: 22
                height: 13
                radius: 3
                color: "transparent"
                border.width: 1.5
                border.color: Qt.alpha(bat.tint, 0.6)

                Rectangle {
                    x: 2.5
                    y: 2.5
                    height: parent.height - 5
                    width: Math.max(2, (parent.width - 5) * bat.level)
                    radius: 1.5
                    color: bat.tint
                }
            }

            Rectangle {
                x: 23
                y: 4
                width: 2
                height: 5
                radius: 1
                color: Qt.alpha(bat.tint, 0.6)
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: bat.clicked()
    }
}
