// Display section of the Control Center (pill-spec.md): BRIGHTNESS and its slider, TEXT SIZE
// and its segmented control, a line, the Night Shift row with a switch. No boxes.
// Text size is GNOME's text-scaling-factor: Nautilus, GTK dialogs and Brave's interface
// follow it; the terminal and IntelliJ keep their own font sizes.
import Quickshell
import Quickshell.Io
import QtQuick

Column {
    id: section
    property var panel
    spacing: Theme.blockGap

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

    Column {
        width: parent.width
        spacing: 6
        SectionLabel { text: "Brightness" }
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

    Column {
        width: parent.width
        spacing: 6
        SectionLabel { text: "Text Size" }
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

    Hairline {}

    PowerRow {
        width: parent.width
        icon: "moon"
        title: "Night Shift"
        on: section.panel.nightOn
        onToggled: section.panel.toggleNight()
    }
}
