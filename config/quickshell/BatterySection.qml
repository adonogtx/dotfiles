// Battery section of the Control Center: charge, time left, and the power mode
// (power-profiles-daemon, through Quickshell's UPower module).
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Column {
    id: section
    property var panel
    spacing: Theme.panelPad

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
    readonly property var modes: [
        { label: "Saver", value: PowerProfile.PowerSaver },
        { label: "Balanced", value: PowerProfile.Balanced },
        { label: "Performance", value: PowerProfile.Performance }
    ]

    Tile {
        width: parent.width
        height: col.height + Theme.tilePad * 2

        Column {
            id: col
            x: Theme.tilePad; y: Theme.tilePad
            width: parent.width - Theme.tilePad * 2
            spacing: 4

            Item {
                width: parent.width
                height: 22
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Battery"
                    font.family: Theme.sans; font.pixelSize: Theme.body; font.weight: Font.Medium
                    color: Theme.label
                }
                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: section.panel.hasBattery ? Math.round(section.panel.charge * 100) + "%" : ""
                    font.family: Theme.sans; font.pixelSize: 17; font.weight: Font.Light
                    color: section.panel.charging ? Theme.green : section.panel.charge < 0.2 ? Theme.red : Theme.label
                }
            }
            Text {
                text: section.timeText
                font.family: Theme.sans; font.pixelSize: 11
                color: Theme.secondary
            }

            // Charge bar
            Rectangle {
                width: parent.width
                height: 6
                radius: 3
                color: Theme.line
                Rectangle {
                    width: parent.width * section.panel.charge
                    height: parent.height
                    radius: 3
                    color: section.panel.charging ? Theme.green : section.panel.charge < 0.2 ? Theme.red : Theme.label
                }
            }
        }
    }

    Tile {
        width: parent.width
        height: modeCol.height + Theme.tilePad * 2

        Column {
            id: modeCol
            x: Theme.tilePad; y: Theme.tilePad
            width: parent.width - Theme.tilePad * 2
            spacing: 8

            Text {
                text: "Energy Mode"
                font.family: Theme.sans; font.pixelSize: Theme.body; font.weight: Font.Medium
                color: Theme.label
            }

            // A segmented control: the chosen mode sits on a lighter pill.
            Rectangle {
                width: parent.width
                height: 28
                radius: 8
                color: Theme.panel

                Row {
                    anchors.fill: parent
                    anchors.margins: 3
                    Repeater {
                        model: section.modes
                        Rectangle {
                            required property var modelData
                            readonly property bool chosen: PowerProfiles.profile === modelData.value
                            readonly property bool usable: modelData.value !== PowerProfile.Performance || PowerProfiles.hasPerformanceProfile
                            width: (modeCol.width - 6) / 3
                            height: parent.height
                            radius: 6
                            color: chosen ? Theme.line : "transparent"
                            Behavior on color { ColorAnimation { duration: Theme.fast } }
                            Text {
                                anchors.centerIn: parent
                                text: modelData.label
                                font.family: Theme.sans; font.pixelSize: 11
                                color: !usable ? Theme.tertiary : chosen ? Theme.label : Theme.secondary
                            }
                            MouseArea {
                                anchors.fill: parent
                                enabled: usable
                                onClicked: PowerProfiles.profile = modelData.value
                            }
                        }
                    }
                }
            }
        }
    }
}
