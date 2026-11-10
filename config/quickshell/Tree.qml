// 木 (tree), in white at the left of the bar, before the workspaces.
import QtQuick

Item {
    implicitWidth: tree.implicitWidth + 4
    implicitHeight: Theme.barHeight

    Text {
        id: tree
        anchors.centerIn: parent
        text: "木"
        font.family: Theme.jp
        font.pixelSize: 15
        font.weight: Font.Medium
        color: Theme.label
    }
}
