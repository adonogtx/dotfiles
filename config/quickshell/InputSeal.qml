// Input seal: あ in full ink while Mozc is active, a faint A otherwise. Click toggles.
// Medium weight at 13 px so the letter carries the same weight as the 1.2 px icon strokes.
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
        anchors.verticalCenterOffset: 1      // capitals sit above the text box centre
        text: seal.japanese ? "あ" : "A"
        font.family: Theme.jp
        font.pixelSize: Theme.body
        font.weight: Font.Medium
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
