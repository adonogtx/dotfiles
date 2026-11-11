// Disk: red, with the use of / , while it is above 90% (snapshots can fill btrfs before
// pacman breaks). df is read once a minute.
import Quickshell.Io
import QtQuick

LiveItem {
    id: disk
    property int percent: 0

    active: percent > 90
    icon: "database"
    text: percent + "%"
    ink: Theme.red

    // "Use%\n 93%": the second line is the use of /.
    Process {
        id: poll
        command: ["df", "--output=pcent", "/"]
        stdout: StdioCollector {
            id: out
            onStreamFinished: {
                const n = parseInt((out.text.trim().split("\n")[1] || "").replace("%", ""))
                disk.percent = isNaN(n) ? 0 : n
            }
        }
    }
    Timer { interval: 60000; running: true; repeat: true; triggeredOnStart: true; onTriggered: poll.running = true }
}
