// The pill: one shape centred at the top that becomes every control (desktop.md, Bar).
// At rest it hugs the date. On a workspace switch it shows only the five dots for about
// 1 s and morphs back (desktop.md, Bar); on a volume or brightness change it shows the level
// the same way (PillLevel.qml). Open, it grows down to 480 wide (the calendar 384) and hosts
// the Control Center or the calendar; the date stays where it was at the top.
// Exact sizes: docs/pill-spec.md. The shape changes first and the
// content fades in after it; closing fades the content out, then the shape shrinks back.
// The window keeps a fixed size so nothing resizes on every frame; the mask keeps
// everything but the shape click-through.
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
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
            levelTimer.stop()
            win.showLevel = false
            win.showDots = true
            dotsTimer.restart()
        }
    }

    // Volume and brightness: the level replaces the date for about 1 s, only on the focused
    // monitor and only at rest. A new change while it shows only restarts the timer.
    // Quiet for the first 2 s and after the default output changes, so login and
    // plugging in headphones do not flash it.
    property bool showLevel: false
    property string levelKind: ""      // "volume" or "brightness"
    property real brightness: 0
    Timer { id: levelTimer; interval: 1000; onTriggered: win.showLevel = false }
    Timer { id: levelQuiet; interval: 2000; running: true }

    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: win.sink ? [win.sink] : [] }
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    onSinkChanged: levelQuiet.restart()
    onVolumeChanged: showLevelFor("volume")
    onMutedChanged: showLevelFor("volume")

    function showLevelFor(kind) {
        if (levelQuiet.running || win.expanded) return
        if (Hyprland.focusedMonitor !== Hyprland.monitorFor(win.screen)) return
        dotsTimer.stop()
        showDots = false
        levelKind = kind
        showLevel = true
        levelTimer.restart()
    }

    // The brightness keys call this through IPC (shell.qml, "level") after brightnessctl.
    // Same reading as the Control Center; a key pressed while it runs reads once more after.
    property bool readAgain: false
    function readBrightness() {
        if (brightGet.running) { readAgain = true; return }
        brightGet.running = true
    }
    Process {
        id: brightGet
        command: ["brightnessctl", "-e4", "-m"]
        stdout: StdioCollector {
            id: brightOut
            onStreamFinished: {
                const pct = parseInt(brightOut.text.split(",")[3])
                if (isNaN(pct)) return
                win.brightness = pct / 100
                win.showLevelFor("brightness")
            }
        }
        onExited: if (win.readAgain) { win.readAgain = false; brightGet.running = true }
    }

    onMenuChanged: {
        if (menu !== "") {
            dotsTimer.stop()
            showDots = false
            levelTimer.stop()
            showLevel = false
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
             : (win.showDots ? dots.implicitWidth : win.showLevel ? levelView.implicitWidth : rest.implicitWidth) + Theme.pillPad * 2
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
            shadowColor: Theme.shadow
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

        // The date, the dots and the level cross-fade while the shape morphs between them.
        PillRest {
            id: rest
            anchors.horizontalCenter: parent.horizontalCenter
            y: (Theme.pillHeight - height) / 2
            opacity: win.showDots || win.showLevel ? 0 : 1
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
        PillLevel {
            id: levelView
            anchors.horizontalCenter: parent.horizontalCenter
            y: (Theme.pillHeight - height) / 2
            readonly property bool isVolume: win.levelKind === "volume"
            icon: !isVolume ? "sun" : win.muted ? "volume-muted" : "volume"
            glyphLevel: !isVolume ? -1 : win.muted || win.volume <= 0 ? 0 : win.volume < 0.5 ? 1 : 2
            value: isVolume ? win.volume : win.brightness
            muted: isVolume && win.muted
            opacity: win.showLevel ? 1 : 0
            visible: opacity > 0
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
