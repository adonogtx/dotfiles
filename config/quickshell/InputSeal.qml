// Input seal: あ in full ink while Mozc is active, a faint A otherwise. Click toggles.
import Quickshell
import Quickshell.Io
import QtQuick

BarItem {
    id: seal
    property bool japanese: false

    onClicked: {
        Quickshell.execDetached(["fcitx5-remote", "-t"])
        poll.running = true
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: seal.japanese ? "あ" : "A"
        font.family: Theme.jp
        font.pixelSize: 12
        color: seal.japanese ? Theme.label : seal.ink
    }

    // fcitx5-remote prints 2 when an input method (Mozc) is active.
    Process {
        id: poll
        command: ["fcitx5-remote"]
        stdout: StdioCollector { id: out; onStreamFinished: seal.japanese = out.text.trim() === "2" }
    }
    Timer { interval: 1000; running: true; repeat: true; triggeredOnStart: true; onTriggered: poll.running = true }
}
