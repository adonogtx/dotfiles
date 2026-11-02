pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

// A row of equal buttons, one of them selected. items: [{ label, glyph? }]
Rectangle {
    id: seg

    property var items: []
    property int current: -1
    property color tint: Theme.yellow
    signal picked(int index)

    Layout.fillWidth: true
    implicitHeight: 34
    radius: 8
    color: Theme.bg

    RowLayout {
        anchors.fill: parent
        anchors.margins: 3
        spacing: 3

        Repeater {
            model: seg.items
            delegate: Rectangle {
                id: cell
                required property var modelData
                required property int index
                readonly property bool on: index === seg.current

                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 6
                color: on ? Theme.item : (area.containsMouse ? Theme.hover : "transparent")

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        visible: !!cell.modelData.glyph
                        text: cell.modelData.glyph || ""
                        color: cell.on ? (cell.modelData.tint || seg.tint) : Theme.fgSoft
                        font.family: Theme.mono
                        font.pixelSize: 13
                    }

                    Text {
                        text: cell.modelData.label
                        color: cell.on ? (cell.modelData.glyph ? Theme.fgStrong : seg.tint) : Theme.fgSoft
                        font.family: Theme.mono
                        font.pixelSize: 12
                        font.bold: cell.on
                    }
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: seg.picked(cell.index)
                }
            }
        }
    }
}
