pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

// Level, health and power profile. Capacity and cycles come straight from /sys, which every laptop exposes.
PanelFrame {
    id: p

    readonly property var dev: UPower.displayDevice
    readonly property real level: dev?.percentage ?? 0
    readonly property bool charging: dev?.state === UPowerDeviceState.Charging
    readonly property bool full: dev?.state === UPowerDeviceState.FullyCharged
    readonly property bool low: level <= 0.2 && !charging
    readonly property color tint: low ? Theme.red : (charging ? Theme.yellow : Theme.green)

    property string cycles: ""
    property string sizeWh: ""

    readonly property var profiles: [
        { label: "Saver", glyph: Theme.iLeaf, tint: Theme.green, value: PowerProfile.PowerSaver },
        { label: "Balanced", glyph: Theme.iBalance, tint: Theme.yellow, value: PowerProfile.Balanced },
        { label: "Performance", glyph: Theme.iSpeed, tint: Theme.red, value: PowerProfile.Performance }
    ]

    function duration(seconds) {
        if (!seconds || seconds <= 0) return "–";
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        return h > 0 ? h + " h " + m + " m" : m + " m";
    }

    onOpenChanged: if (open) sysfs.running = true

    Process {
        id: sysfs
        command: ["sh", "-c",
            "b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1); [ -z \"$b\" ] && exit 0; "
            + "printf 'cycles\\t%s\\nenergy\\t%s\\n' \"$(cat $b/cycle_count 2>/dev/null)\" \"$(cat $b/energy_full 2>/dev/null)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                for (const line of this.text.split("\n")) {
                    const [k, v] = line.split("\t");
                    if (k === "cycles" && v) p.cycles = v.trim();
                    if (k === "energy" && v) p.sizeWh = Math.round(parseInt(v) / 1000000) + " Wh";
                }
            }
        }
    }

    PanelHero {
        glyph: p.charging ? Theme.iBatteryCharging : Theme.iBattery
        tint: p.tint
        title: "Battery"
        status: p.full ? "Fully charged" : (p.charging ? "Charging" : "On battery")

        Text {
            text: Math.round(p.level * 100) + "%"
            color: p.tint
            font.family: Theme.mono
            font.pixelSize: 22
            font.bold: true
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 6
        radius: 3
        color: Theme.track

        Rectangle {
            height: parent.height
            radius: 3
            width: parent.width * Math.min(1, p.level)
            color: p.tint
        }
    }

    InfoGrid {
        items: [
            { label: "Capacity", value: p.sizeWh || "–" },
            { label: "Cycles", value: p.cycles || "–" },
            { label: p.charging ? "To full" : "Time left", value: p.full ? "–" : p.duration(p.charging ? p.dev?.timeToFull : p.dev?.timeToEmpty) },
            { label: "Draw", value: (p.dev?.changeRate ?? 0) > 0 ? (p.dev.changeRate).toFixed(1) + " W" : "–" }
        ]
    }

    SectionLabel {
        text: "Power mode"
        tint: Theme.green
    }

    Segmented {
        items: p.profiles
        current: p.profiles.findIndex(x => x.value === PowerProfiles.profile)
        onPicked: i => PowerProfiles.profile = p.profiles[i].value
    }
}
