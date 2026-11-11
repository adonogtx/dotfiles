// Footer of the open pill (pill-spec.md, Footer), height 22: あ on the left (13, secondary;
// label while Mozc is active; a click toggles the input method), then the workspace dots;
// on the right the Calendar link (icon 14, text 12, chevron 13, all secondary).
import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: footer
    signal calendarRequested()
    property bool japanese: false

    implicitHeight: 22

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "あ"
            font.family: Theme.jp
            font.pixelSize: 13
            color: footer.japanese || sealMouse.containsMouse ? Theme.label : Theme.secondary
            Behavior on color { ColorAnimation { duration: Theme.fast } }
            MouseArea {
                id: sealMouse
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execDetached(["fcitx5-remote", "-t"])
                    poll.running = true
                }
            }
        }
        WorkspaceDots { anchors.verticalCenter: parent.verticalCenter }
    }

    Row {
        id: link
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5
        readonly property color ink: linkMouse.containsMouse ? Theme.label : Theme.secondary

        Glyph { name: "calendar"; width: 14; height: 14; color: link.ink; anchors.verticalCenter: parent.verticalCenter }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "Calendar"
            font.family: Theme.sans
            font.pixelSize: 12
            color: link.ink
        }
        Glyph { name: "chevron-right"; width: 13; height: 13; color: link.ink; anchors.verticalCenter: parent.verticalCenter }
    }
    MouseArea {
        id: linkMouse
        anchors.fill: link
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: footer.calendarRequested()
    }

    // fcitx5-remote prints 2 when an input method (Mozc) is active.
    Process {
        id: poll
        command: ["fcitx5-remote"]
        stdout: StdioCollector { id: out; onStreamFinished: footer.japanese = out.text.trim() === "2" }
    }
    Timer { interval: 1000; running: true; repeat: true; triggeredOnStart: true; onTriggered: poll.running = true }
}
