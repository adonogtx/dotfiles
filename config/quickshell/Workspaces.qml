// Five tabs, like a segmented control. A grey rounded square sits behind
// the active number; numbers with windows are grey, empty ones faint.
import Quickshell.Hyprland
import QtQuick

Row {
    spacing: 4

    Repeater {
        model: 5

        Rectangle {
            id: tab
            required property int index
            readonly property int wsId: index + 1
            readonly property bool active: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === wsId
            readonly property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 18
            radius: 5
            color: active ? Theme.line : (mouse.containsMouse ? Theme.wash : "transparent")
            Behavior on color { ColorAnimation { duration: Theme.fast } }

            Text {
                anchors.centerIn: parent
                text: tab.wsId
                font.family: Theme.sans
                font.pixelSize: 11
                font.weight: tab.active ? Font.Medium : Font.Normal
                color: tab.active ? Theme.label : tab.occupied ? Theme.secondary : Theme.tertiary
                opacity: tab.active || tab.occupied ? 1 : 0.7
                Behavior on color { ColorAnimation { duration: Theme.fast } }
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                // Hyprland 0.55+ takes Lua dispatchers over IPC.
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + tab.wsId + " })")
            }
        }
    }
}
