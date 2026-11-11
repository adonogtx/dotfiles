// The pill: one shape centred at the top that becomes every control (desktop.md, Bar).
// At rest it hugs the date. On a workspace switch it shows only the five dots for about
// 1 s and morphs back (desktop.md, Bar). Open, it grows down to 480 wide (the calendar 384) and hosts
// the Control Center or the calendar; the date stays where it was at the top.
// Exact sizes: docs/pill-spec.md. The shape changes first and the
// content fades in after it; closing fades the content out, then the shape shrinks back.
// The window keeps a fixed size so nothing resizes on every frame; the mask keeps
// everything but the shape click-through.
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: win
    required property var modelData
    screen: modelData

    property string menu: ""           // "", "control", "calendar"
    property string section: "main"    // Control Center section
    signal menuRequested(string name)  // "control" from the pill, "calendar" from the footer
    signal dismissed()
    signal switchTo(string name)

    readonly property bool open: menu !== ""
    property string shownMenu: ""      // stays set while the content fades out
    readonly property bool expanded: shownMenu !== ""
    readonly property int openWidth: shownMenu === "calendar" ? Theme.calendarWidth : Theme.pillOpenWidth
    readonly property int shadow: Theme.shadowPad
    readonly property int lift: 4      // room above the shape for the shadow's blur

    function openCalendar() { win.menuRequested("calendar") }

    // Workspace switch: the dots replace the date for about 1 s, only on this pill's monitor
    // and only at rest. Quiet for the first second, so starting up does not flash them.
    property bool showDots: false
    property bool settled: false
    Timer { interval: 1000; running: true; onTriggered: win.settled = true }
    Timer { id: dotsTimer; interval: 1000; onTriggered: win.showDots = false }
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            if (!win.settled || win.expanded) return
            if (Hyprland.focusedMonitor !== Hyprland.monitorFor(win.screen)) return
            win.showDots = true
            dotsTimer.restart()
        }
    }

    onMenuChanged: {
        if (menu !== "") {
            dotsTimer.stop()
            showDots = false
            hide.stop()
            shownMenu = menu
            reveal.restart()
            shape.forceActiveFocus()
        } else if (shownMenu !== "") {
            reveal.stop()
            hide.restart()
        }
    }

    color: "transparent"
    anchors { top: true }              // not anchored left or right: centred
    margins.top: Theme.pillTop - lift
    // Hyprland reserves the exclusive zone plus the top margin: 8 + 38 = 12 + 34.
    exclusiveZone: Theme.pillTop + Theme.pillHeight - margins.top
    implicitWidth: Theme.pillOpenWidth + shadow * 2
    implicitHeight: (screen ? screen.height : 864) - 40
    mask: Region { item: shape }

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "pill"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    HyprlandFocusGrab {
        active: win.open
        windows: [win]
        onCleared: win.dismissed()
    }

    Component { id: controlMenu; ControlCenter { host: win; section: win.section } }
    Component { id: calendarMenu; Calendar { host: win } }

    Rectangle {
        id: shape
        anchors.horizontalCenter: parent.horizontalCenter
        y: win.lift
        width: win.expanded ? win.openWidth
             : (win.showDots ? dots.implicitWidth : rest.implicitWidth) + Theme.pillPad * 2
        height: Theme.pillHeight + (win.expanded && loader.item
                ? Theme.openTop + loader.item.implicitHeight + Theme.openBottom : 0)
        radius: win.expanded ? Theme.openRadius : Theme.pillHeight / 2
        border.width: 1
        border.color: Theme.rim
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.panelTop }
            GradientStop { position: 1.0; color: Theme.panelBottom }
        }
        clip: true
        focus: true
        Keys.onEscapePressed: win.dismissed()

        // One soft shadow, the same as the panels.
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: Theme.shadowOpacity
            shadowBlur: 1.0
            blurMax: 24
            shadowVerticalOffset: 8
        }

        Behavior on width {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        Behavior on height {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        Behavior on radius {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }

        // The top strip: a click anywhere opens the Control Center (or closes it);
        // from the calendar it goes back to the Control Center.
        MouseArea {
            width: parent.width
            height: Theme.pillHeight
            cursorShape: Qt.PointingHandCursor
            onClicked: win.menuRequested("control")
        }

        // The date and the dots cross-fade while the shape morphs between them.
        PillRest {
            id: rest
            anchors.horizontalCenter: parent.horizontalCenter
            y: (Theme.pillHeight - height) / 2
            opacity: win.showDots ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        }
        WorkspaceDots {
            id: dots
            anchors.horizontalCenter: parent.horizontalCenter
            y: (Theme.pillHeight - height) / 2
            opacity: win.showDots ? 1 : 0
            visible: opacity > 0          // no clicks on the dots while they are hidden
            Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        }

        // Fixed width, so the content lays out once and does not follow the growing shape.
        Loader {
            id: loader
            x: Theme.openSide
            y: Theme.pillHeight + Theme.openTop
            width: win.openWidth - Theme.openSide * 2
            opacity: 0
            sourceComponent: win.shownMenu === "control" ? controlMenu
                           : win.shownMenu === "calendar" ? calendarMenu
                           : null
        }
    }

    // The content arrives once the shape has nearly settled.
    SequentialAnimation {
        id: reveal
        PropertyAction { target: loader; property: "opacity"; value: 0 }
        PauseAnimation { duration: 160 }
        NumberAnimation { target: loader; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
    }
    // The content leaves first, then the shape shrinks back to the date.
    SequentialAnimation {
        id: hide
        NumberAnimation { target: loader; property: "opacity"; to: 0; duration: 120; easing.type: Easing.OutCubic }
        ScriptAction { script: win.shownMenu = "" }
    }
}
