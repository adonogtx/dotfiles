pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

// Connected, paired and available devices. Opening the panel starts a scan; closing it stops the scan.
PanelFrame {
    id: p

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var all: Bluetooth.devices ? Bluetooth.devices.values : []
    readonly property var connected: all.filter(d => d.connected)
    readonly property var paired: all.filter(d => !d.connected && (d.paired || d.bonded || d.trusted))
    readonly property var available: all.filter(d => !d.connected && !d.paired && !d.bonded && !d.trusted && d.name && d.name !== d.address)

    function battery(d) {
        return d.batteryAvailable ? Math.round(d.battery * 100) + "%" : "";
    }

    function glyphFor(d) {
        const icon = String(d.icon || "").toLowerCase();
        if (icon.indexOf("audio") !== -1 || icon.indexOf("headset") !== -1 || icon.indexOf("headphone") !== -1) return Theme.iHeadphones;
        return Theme.iBluetooth;
    }

    onOpenChanged: {
        if (adapter && adapter.enabled) adapter.discovering = open;
    }

    PanelHero {
        glyph: (p.adapter?.enabled ?? false) ? Theme.iBluetooth : Theme.iBluetoothOff
        tint: p.connected.length > 0 ? Theme.blue : ((p.adapter?.enabled ?? false) ? Theme.fg : Theme.fgFaint)
        title: "Bluetooth"
        status: !(p.adapter?.enabled ?? false) ? "Off"
            : p.connected.length === 1 ? p.connected[0].name
            : p.connected.length > 1 ? p.connected.length + " connected"
            : "No device connected"

        Toggle {
            checked: p.adapter?.enabled ?? false
            tint: Theme.blue
            onToggled: if (p.adapter) p.adapter.enabled = !p.adapter.enabled
        }
    }

    SectionLabel {
        visible: p.connected.length > 0
        text: "Connected"
        tint: Theme.blue
    }

    Repeater {
        model: p.connected
        delegate: ListRow {
            required property var modelData
            glyph: p.glyphFor(modelData)
            label: modelData.name
            subtitle: p.battery(modelData)
            selected: true
            onClicked: modelData.disconnect()
        }
    }

    SectionLabel {
        visible: p.paired.length > 0
        text: "Paired"
        tint: Theme.aqua
    }

    Repeater {
        model: p.paired
        delegate: ListRow {
            required property var modelData
            glyph: p.glyphFor(modelData)
            label: modelData.name
            detail: "connect"
            onClicked: modelData.connect()
        }
    }

    SectionLabel {
        visible: (p.adapter?.enabled ?? false)
        text: "Available"
        tint: Theme.orange
        value: (p.adapter?.discovering ?? false) ? "scanning…" : ""
    }

    Repeater {
        model: p.available.slice(0, 5)
        delegate: ListRow {
            required property var modelData
            glyph: p.glyphFor(modelData)
            label: modelData.name
            detail: "pair"
            onClicked: Quickshell.execDetached(["sh", "-c",
                "bluetoothctl pair " + modelData.address + " && bluetoothctl trust " + modelData.address
                + " && bluetoothctl connect " + modelData.address])
        }
    }

    Separator {}

    LinkRow {
        text: "Bluetooth settings…"
        onClicked: {
            Quickshell.execDetached(["ghostty", "-e", "bluetui"]);
            p.dismissed();
        }
    }
}
