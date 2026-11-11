// Recording: a red dot and the elapsed time while wf-recorder runs (started by gus-record).
// ps -C matches the exact command name, like gus-record's pgrep -x, and also gives the
// elapsed seconds, so the time stays right after a Quickshell restart. A click stops it:
// gus-record stops a running recording when called again.
import Quickshell
import Quickshell.Io
import QtQuick

LiveItem {
    id: rec
    property int seconds: -1

    active: seconds >= 0
    dot: true
    clickable: true
    text: {
        if (seconds < 0) return ""
        const h = Math.floor(seconds / 3600)
        const m = Math.floor((seconds % 3600) / 60)
        const s = seconds % 60
        const two = (n) => (n < 10 ? "0" : "") + n
        return h > 0 ? h + ":" + two(m) + ":" + two(s) : m + ":" + two(s)
    }
    onClicked: {
        Quickshell.execDetached(["gus-record"])
        poll.running = true
    }


    Process {
        id: poll
        command: ["ps", "-o", "etimes=", "-C", "wf-recorder"]
        stdout: StdioCollector {
            id: out
            onStreamFinished: {
                const n = parseInt(out.text.trim().split("\n")[0])
                rec.seconds = isNaN(n) ? -1 : n
            }
        }
        onExited: (code) => { if (code !== 0) rec.seconds = -1 }
    }
    Timer { interval: 1000; running: true; repeat: true; triggeredOnStart: true; onTriggered: poll.running = true }
}
