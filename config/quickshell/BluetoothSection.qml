// Bluetooth section of the Control Center. Uses Quickshell's own BlueZ module.
// Scans while open. Click a device: connected ones disconnect, paired ones connect,
// new ones pair (and connect once paired). Nearby lists only devices with a name.
// Detail (pill-spec.md, Rows), all secondary: battery % when connected, "Connect" on a known
// device, "Pair" on a nearby one. A name that looks like an address counts as no name.
import Quickshell
import Quickshell.Bluetooth
import QtQuick

Column {
    id: section
    spacing: Theme.blockGap

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool on: adapter !== null && adapter.enabled

    readonly property var paired: Bluetooth.devices.values
        .filter(d => d.paired)
        .sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
    // "AA:BB:CC:DD:EE:FF" or "AA-BB-CC-DD-EE-FF": BlueZ falls back to the address.
    function named(d) {
        return d.name && d.name !== d.address && !/^[0-9a-f]{2}([:-][0-9a-f]{2}){2,}$/i.test(d.name.trim())
    }
    readonly property var nearby: Bluetooth.devices.values
        .filter(d => !d.paired && section.named(d))
        .slice(0, 6)

    property var pairing: null

    // BlueZ names the kind of device in its icon: input-mouse, audio-headset, phone...
    function iconFor(device) {
        const i = (device.icon || "").toLowerCase()
        if (i.includes("mouse")) return "mouse"
        if (i.includes("keyboard")) return "keyboard"
        if (i.includes("audio") || i.includes("headset") || i.includes("headphone")) return "headphones"
        if (i.includes("phone")) return "phone"
        if (i.includes("computer")) return "laptop"
        return "bluetooth"
    }

    function activate(device) {
        if (device.connected) device.disconnect()
        else if (device.paired) device.connect()
        else { section.pairing = device; device.pair() }
    }

    function note(device) {
        if (device.state === BluetoothDeviceState.Connecting) return "Connecting"
        if (device.state === BluetoothDeviceState.Disconnecting) return "Disconnecting"
        if (device.pairing) return "Pairing"
        if (device.connected) return device.batteryAvailable ? Math.round(device.battery * 100) + "%" : ""
        return device.paired ? "Connect" : "Pair"
    }

    // Once a new device finishes pairing, trust it and connect.
    Connections {
        target: section.pairing
        function onPairedChanged() {
            if (section.pairing && section.pairing.paired) {
                section.pairing.trusted = true
                section.pairing.connect()
                section.pairing = null
            }
        }
    }

    // Scan only while the section is open.
    Component.onCompleted: if (section.on) section.adapter.discovering = true
    Component.onDestruction: if (section.adapter !== null && section.adapter.discovering) section.adapter.discovering = false
    onOnChanged: if (section.on) section.adapter.discovering = true

    // Layout: the power row, a line, then the lists. No boxes.

    PowerRow {
        width: parent.width
        icon: "bluetooth"
        title: "Bluetooth"
        subtitle: section.adapter === null ? "Unavailable" : ""
        on: section.on
        onToggled: if (section.adapter !== null) section.adapter.enabled = !section.adapter.enabled
    }

    Hairline { visible: section.on }

    Column {
        id: lists
        visible: section.on
        width: parent.width
        spacing: 2

        SectionLabel { visible: section.paired.length > 0; text: "My Devices"; leftPadding: 10; topPadding: 10; bottomPadding: 4 }
        Repeater {
            model: section.paired
            ListItem {
                required property var modelData
                width: lists.width
                icon: section.iconFor(modelData)
                text: modelData.name
                subtitle: modelData.connected ? "Connected" : ""
                current: modelData.connected
                busy: modelData.state === BluetoothDeviceState.Connecting
                note: section.note(modelData)
                onActivated: section.activate(modelData)
            }
        }

        SectionLabel { text: "Nearby"; leftPadding: 10; topPadding: 10; bottomPadding: 4 }
        Repeater {
            model: section.nearby
            ListItem {
                required property var modelData
                width: lists.width
                icon: section.iconFor(modelData)
                text: modelData.name
                busy: modelData.pairing
                note: section.note(modelData)
                onActivated: section.activate(modelData)
            }
        }
        SectionLabel {
            visible: section.nearby.length === 0
            text: "Searching…"
            leftPadding: 10; topPadding: 4
        }
    }
}
