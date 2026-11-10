// Wi-Fi signal in three arcs, from NetworkManager every 10 s. Click opens the Wi-Fi menu.
// Commands are argument lists, never shell strings (SSIDs are untrusted text).
import Quickshell
import Quickshell.Io
import QtQuick

BarItem {
    id: wifi
    property int signal: -1          // -1 not connected, else 0..100
    readonly property int level: signal < 0 ? 0 : signal < 40 ? 1 : signal < 70 ? 2 : 3

    Glyph { name: wifi.signal < 0 ? "wifi-off" : "wifi"; level: wifi.level; color: wifi.ink }

    // Lines look like "yes:72"; the active network is the one starting with yes.
    Process {
        id: poll
        command: ["nmcli", "-t", "-f", "ACTIVE,SIGNAL", "device", "wifi"]
        stdout: StdioCollector {
            id: out
            onStreamFinished: {
                const line = out.text.split("\n").find(l => l.startsWith("yes:"))
                wifi.signal = line ? parseInt(line.slice(4)) : -1
            }
        }
        onExited: (code) => { if (code !== 0) wifi.signal = -1 }
    }
    Timer { interval: 10000; running: true; repeat: true; triggeredOnStart: true; onTriggered: poll.running = true }
}
