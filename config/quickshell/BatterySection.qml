// Battery section of the Control Center (pill-spec.md): the charge in large light figures,
// the status beside it, a bar (label, red below 20%), a line, then the energy mode
// (power-profiles-daemon, through Quickshell's UPower module). No boxes.
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Column {
    id: section
    property var panel
    spacing: Theme.blockGap

    readonly property var dev: UPower.displayDevice
    readonly property string timeText: {
        if (!section.panel.hasBattery) return "No battery"
        if (section.panel.charging) {
            const t = section.panel.duration(dev.timeToFull)
            return t ? t + " until full" : "Charging"
        }
        if (dev.state === UPowerDeviceState.FullyCharged) return "Fully charged"
        const t = section.panel.duration(dev.timeToEmpty)
        return t ? t + " remaining" : "On battery"
    }
    readonly property bool low: section.panel.hasBattery && !section.panel.charging && section.panel.charge < 0.2
    readonly property var modes: [
        { label: "Saver", value: PowerProfile.PowerSaver },
        { label: "Balanced", value: PowerProfile.Balanced },
        { label: "Performance", value: PowerProfile.Performance, disabled: !PowerProfiles.hasPerformanceProfile }
    ]

    Column {
        width: parent.width
        spacing: 10

        Row {
            spacing: 10

            Text {
                id: charge
                text: section.panel.hasBattery ? Math.round(section.panel.charge * 100) + "%" : ""
                font.family: Theme.sans; font.pixelSize: 45; font.weight: Font.Light
                lineHeight: 1
                color: Theme.label
            }
            Row {
                // Sits on the number's baseline: a Row has no baseline of its own.
                baselineOffset: statusText.y + statusText.baselineOffset
                anchors.baseline: charge.baseline
                spacing: 4
                Glyph {
                    visible: section.panel.charging
                    name: "bolt"
                    width: 14; height: 14
                    color: Theme.green
                    anchors.verticalCenter: statusText.verticalCenter
                }
                Text {
                    id: statusText
                    text: section.timeText
                    font.family: Theme.sans; font.pixelSize: 13
                    color: Theme.secondary
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 8
            radius: 4
            color: Theme.tile
            Rectangle {
                width: parent.width * section.panel.charge
                height: parent.height
                radius: 4
                color: section.low ? Theme.red : Theme.label
            }
        }
    }

    Hairline {}

    Column {
        width: parent.width
        spacing: 6
        SectionLabel { text: "Energy Mode" }
        Segmented {
            width: parent.width
            options: section.modes
            current: PowerProfiles.profile
            onPicked: (v) => PowerProfiles.profile = v
        }
    }
}
