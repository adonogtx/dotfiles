import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

// A popup that drops below a bar icon. Clicking anywhere else closes it.
PopupWindow {
    id: popup

    required property Item anchorItem
    property bool open: false
    property int panelWidth: 330
    default property alias content: body.data
    signal dismissed

    visible: open
    color: "transparent"
    implicitWidth: panelWidth
    implicitHeight: frame.height + 6

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    Rectangle {
        id: frame
        y: 6
        width: parent.width
        height: body.implicitHeight + 28
        radius: 12
        color: Theme.panel
        border.width: 2
        border.color: Qt.alpha(Theme.blue, 0.55)

        ColumnLayout {
            id: body
            x: 14
            y: 14
            width: parent.width - 28
            spacing: 10
        }
    }

    HyprlandFocusGrab {
        windows: [popup]
        active: popup.visible
        onCleared: popup.dismissed()
    }
}
