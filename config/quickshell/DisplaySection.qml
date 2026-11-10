// Display section of the Control Center: brightness, text size for GTK apps, Night Shift.
// Text size is GNOME's text-scaling-factor: Nautilus, GTK dialogs and Brave's interface
// follow it; the terminal and IntelliJ keep their own font sizes.
import Quickshell
import Quickshell.Io
import QtQuick

Column {
    id: section
    property var panel
    spacing: Theme.panelPad

    property real textScale: 1.0
    readonly property var scales: [
        { label: "A", value: 0.9, size: 10 },
        { label: "A", value: 1.0, size: 11 },
        { label: "A", value: 1.1, size: 13 },
        { label: "A", value: 1.25, size: 15 }
    ]

    Process {
        id: readScale
        running: true
        command: ["gsettings", "get", "org.gnome.desktop.interface", "text-scaling-factor"]
        stdout: StdioCollector {
            id: scaleOut
            onStreamFinished: {
                const v = parseFloat(scaleOut.text)
                if (!isNaN(v)) section.textScale = Math.round(v * 100) / 100
            }
        }
    }

    Tile {
        width: parent.width
        height: bright.height + Theme.tilePad * 2
        Column {
            id: bright
            x: Theme.tilePad; y: Theme.tilePad
            width: parent.width - Theme.tilePad * 2
            spacing: 10
            SectionLabel { text: "Brightness"; leftPadding: 0 }
            Slider {
                width: parent.width
                icon: "sun"
                value: section.panel.brightness
                onMoved: (v) => {
                    section.panel.brightness = v
                    section.panel.pendingBrightness = v
                    section.panel.writeBrightness()
                }
            }
        }
    }

    Tile {
        width: parent.width
        height: textCol.height + Theme.tilePad * 2
        Column {
            id: textCol
            x: Theme.tilePad; y: Theme.tilePad
            width: parent.width - Theme.tilePad * 2
            spacing: 10
            SectionLabel { text: "Text Size"; leftPadding: 0 }
            Segmented {
                width: parent.width
                options: section.scales
                current: section.textScale
                onPicked: (v) => {
                    section.textScale = v
                    Quickshell.execDetached(["gsettings", "set", "org.gnome.desktop.interface", "text-scaling-factor", String(v)])
                }
            }
        }
    }

    Tile {
        width: parent.width
        height: 36 + Theme.tilePad
        Text {
            x: Theme.tilePad
            anchors.verticalCenter: parent.verticalCenter
            text: "Night Shift"
            font.family: Theme.sans; font.pixelSize: Theme.body; font.weight: Font.Medium
            color: Theme.label
        }
        Switch {
            anchors.right: parent.right
            anchors.rightMargin: Theme.tilePad
            anchors.verticalCenter: parent.verticalCenter
            on: section.panel.nightOn
            onToggled: section.panel.toggleNight()
        }
    }
}
