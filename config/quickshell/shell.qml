// Gus · Quickshell entry point. One pill per screen (desktop.md, Bar) and one Launcher.
// A click on the pill opens the Control Center; keys reach it through IPC:
//   quickshell ipc call menus toggle wifi | bluetooth | sound | display | battery | control | calendar
//   quickshell ipc call launcher toggle
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

ShellRoot {
    id: root
    property string menu: ""          // "", "control", "calendar"
    property string section: "main"
    property var menuPill: null       // the pill that holds the open panel

    // kind: wifi, bluetooth, sound, microphone, display, battery, control (main view) or calendar.
    function toggle(kind, pill) {
        const menu = kind === "calendar" ? "calendar" : "control"
        const section = kind === "control" || kind === "calendar" ? "main"
                      : kind === "microphone" ? "sound" : kind
        if (root.menu === menu && root.section === section) { root.menu = ""; return }
        root.menuPill = pill
        root.section = section
        root.menu = menu
    }

    // The pill on the focused monitor, for keys and IPC.
    function focusedPill() {
        const list = pills.instances
        const mon = Hyprland.focusedMonitor
        for (let i = 0; i < list.length; i++)
            if (mon && list[i].screen && list[i].screen.name === mon.name) return list[i]
        return list.length > 0 ? list[0] : null
    }

    Variants {
        id: pills
        model: Quickshell.screens

        Pill {
            id: pill
            menu: root.menuPill === pill ? root.menu : ""
            section: root.menuPill === pill ? root.section : "main"
            onMenuRequested: (name) => root.toggle(name, pill)
            onDismissed: root.menu = ""
            onSwitchTo: (name) => root.section = name
            IdleInhibitor { window: pill; enabled: Awake.on }
        }
    }

    Launcher { id: launcher }

    IpcHandler {
        target: "menus"
        function toggle(name: string): void { root.toggle(name, root.focusedPill()) }
        function close(): void { root.menu = "" }
    }
}
