// Hosts the Control Center or the calendar under the bar. It drops below the icon
// that opened it, and closes on Escape, on a click anywhere else, or on the same icon again.
// Opening settles in with a slow tail; closing fades out before the window goes away.
// The window is larger than the panel so its soft shadow has room; only the panel takes clicks.
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: win
    property string menu: ""           // "", "control", "calendar"
    property string section: "main"    // Control Center section
    property real anchorX: 0            // centre of the icon that opened it, in screen pixels
    property var barWindow: null
    signal dismissed()
    signal switchTo(string name)

    readonly property bool open: menu !== ""
    property string shownMenu: ""        // stays set while the panel fades out
    readonly property int panelWidth: shownMenu === "calendar" ? 264 : Theme.controlWidth
    readonly property int pad: shownMenu === "calendar" ? 14 : Theme.panelPad
    readonly property int screenWidth: screen ? screen.width : 1536
    readonly property int shadow: Theme.shadowPad
    // Where the panel's right edge sits from the screen edge, and how much of the
    // shadow's room fits on that side without a negative margin.
    readonly property int panelRight: Math.max(8, Math.min(screenWidth - panelWidth - 8,
                                                            screenWidth - anchorX - panelWidth / 2))
    readonly property int windowRight: Math.max(0, panelRight - shadow)
    readonly property int roomRight: panelRight - windowRight

    onMenuChanged: {
        if (menu !== "") {
            closing.stop()
            if (shownMenu !== menu) { shownMenu = menu; reveal.restart() }
            body.forceActiveFocus()
        } else if (shownMenu !== "") {
            closing.restart()
        }
    }
    Timer { id: closing; interval: 180; onTriggered: win.shownMenu = "" }

    visible: shownMenu !== ""
    color: "transparent"
    anchors { top: true; right: true }
    margins {
        top: 6 - 4
        right: win.windowRight
    }
    exclusiveZone: 0
    implicitWidth: panelWidth + shadow + roomRight
    // Fixed height: resizing the window on every frame made the panel shake.
    // The mask below keeps the empty part click-through.
    implicitHeight: (screen ? screen.height : 864) - 40
    mask: Region { item: body }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "menu"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    HyprlandFocusGrab {
        active: win.open
        windows: win.barWindow ? [win, win.barWindow] : [win]
        onCleared: win.dismissed()
    }

    Component { id: controlMenu; ControlCenter { host: win; section: win.section } }
    Component { id: calendarMenu; Calendar { host: win } }

    Rectangle {
        id: body
        x: win.shadow
        y: 4
        width: win.panelWidth
        height: (loader.item ? loader.item.implicitHeight : 0) + win.pad * 2
        radius: Theme.radiusPanel
        border.width: 1
        border.color: Theme.rim
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.panelTop }
            GradientStop { position: 1.0; color: Theme.panelBottom }
        }
        focus: true
        Keys.onEscapePressed: win.dismissed()

        // One soft shadow under the panel.
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: Theme.shadowOpacity
            shadowBlur: 1.0
            blurMax: 24
            shadowVerticalOffset: 8
        }

        opacity: win.open ? 1 : 0
        scale: win.open ? 1 : 0.96
        transformOrigin: Item.Top
        Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on scale {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        Behavior on height {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }

        Loader {
            id: loader
            x: win.pad
            y: win.pad
            width: parent.width - win.pad * 2
            sourceComponent: win.shownMenu === "control" ? controlMenu
                           : win.shownMenu === "calendar" ? calendarMenu
                           : null
        }

        // The content arrives a moment after the panel, once it has nearly settled.
        SequentialAnimation {
            id: reveal
            PropertyAction { target: loader; property: "opacity"; value: 0 }
            PauseAnimation { duration: 60 }
            NumberAnimation { target: loader; property: "opacity"; to: 1; duration: 220; easing.type: Easing.OutCubic }
        }
    }
}
