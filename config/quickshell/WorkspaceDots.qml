// Five workspace dots (pill-spec.md, Footer): gap 5, active 18 x 6 in label,
// with windows 6 x 6 in secondary, empty 6 x 6 in tertiary, all rounding 3.
// A click on a dot goes to that workspace.
import Quickshell.Hyprland
import QtQuick

Row {
    spacing: 5

    Repeater {
        model: 5

        Rectangle {
            id: dot
            required property int index
            readonly property int wsId: index + 1
            readonly property bool active: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === wsId
            readonly property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

            anchors.verticalCenter: parent.verticalCenter
            width: active ? 18 : 6
            height: 6
            radius: 3
            color: active ? Theme.label : occupied ? Theme.secondary : Theme.tertiary
            Behavior on width {
                NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
            }
            Behavior on color { ColorAnimation { duration: Theme.fast } }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                // Hyprland 0.55+ takes Lua dispatchers over IPC.
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + dot.wsId + " })")
            }
        }
    }
}
