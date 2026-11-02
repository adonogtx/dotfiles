pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

// Two columns of label and value pairs, like the stats block in the Omarchy panels
GridLayout {
    id: grid

    property var items: []

    Layout.fillWidth: true
    columns: 2
    columnSpacing: 18
    rowSpacing: 5

    Repeater {
        model: grid.items
        delegate: RowLayout {
            required property var modelData
            Layout.fillWidth: true
            Layout.preferredWidth: 1

            Text {
                Layout.fillWidth: true
                text: modelData.label
                color: Theme.fgSoft
                font.family: Theme.mono
                font.pixelSize: 11
            }

            Text {
                text: modelData.value
                color: Theme.fg
                font.family: Theme.mono
                font.pixelSize: 11
            }
        }
    }
}
