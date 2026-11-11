// Gus · Quickshell entry point. One bar per screen; one panel and one Launcher shared.
// Bar icons open the Control Center on their section; keys reach it through IPC:
//   quickshell ipc call menus toggle wifi | bluetooth | sound | display | battery | control
//   quickshell ipc call launcher toggle
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root
    property string menu: ""          // "", "control", "calendar"
    property string section: "main"
    property real menuX: 0
    property var menuBar: null

    // kind: wifi, bluetooth, sound, microphone, battery, control (main view) or calendar.
    function toggle(kind, x, barWindow) {
        const menu = kind === "calendar" ? "calendar" : "control"
        const section = kind === "control" || kind === "calendar" ? "main"
                      : kind === "microphone" ? "sound" : kind
        if (root.menu === menu && root.section === section) { root.menu = ""; return }
        root.menuX = x
        root.menuBar = barWindow
        root.section = section
        root.menu = menu
    }

    Variants {
        model: Quickshell.screens

        Bar {
            id: bar
            menu: root.menuBar === bar ? root.menu : ""
            section: root.menuBar === bar ? root.section : ""
            onMenuRequested: (name, x) => root.toggle(name, x, bar)
            onLauncherRequested: launcher.open = !launcher.open
        }
    }

    MenuWindow {
        screen: root.menuBar ? root.menuBar.screen : Quickshell.screens[0]
        menu: root.menu
        section: root.section
        anchorX: root.menuX
        barWindow: root.menuBar
        onDismissed: root.menu = ""
        onSwitchTo: (name) => root.section = name
    }

    Launcher { id: launcher }

    // From keys there is no icon to sit under, so the panel opens at the right edge.
    IpcHandler {
        target: "menus"
        function toggle(name: string): void {
            const width = Quickshell.screens[0] ? Quickshell.screens[0].width : 1536
            root.toggle(name, width, root.menuBar)
        }
        function close(): void { root.menu = "" }
    }
}
