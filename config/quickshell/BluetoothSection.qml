// Bluetooth section of the Control Center. Uses Quickshell's own BlueZ module.
// Scans while open. Click a device: connected ones disconnect, paired ones connect,
// new ones pair (and connect once paired).
import Quickshell
import Quickshell.Bluetooth
import QtQuick

Column {
    id: section
    spacing: Theme.panelPad

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool on: adapter !== null && adapter.enabled

    readonly property var paired: Bluetooth.devices.values
        .filter(d => d.paired)
        .sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
    readonly property var nearby: Bluetooth.devices.values
        .filter(d => !d.paired && d.name && d.name !== d.address)
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
        if (device.connected) return device.batteryAvailable ? Math.round(device.battery * 100) + "%" : "Connected"
        return device.paired ? "" : "Connect"
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

    Tile {
        width: parent.width
        height: 36 + Theme.tilePad
        Toggle {
            x: Theme.tilePad; width: parent.width - Theme.tilePad * 2
            anchors.verticalCenter: parent.verticalCenter
            icon: "bluetooth"
            title: "Bluetooth"
            detail: section.adapter === null ? "Unavailable" : section.on ? "On" : "Off"
            on: section.on
            onToggled: if (section.adapter !== null) section.adapter.enabled = !section.adapter.enabled
        }
    }

    Tile {
        visible: section.on
        width: parent.width
        height: lists.height + 12

        Column {
            id: lists
            x: 6; y: 6
            width: parent.width - 12
            spacing: 2

            SectionLabel { visible: section.paired.length > 0; text: "My Devices"; topPadding: 6; bottomPadding: 4 }
            Repeater {
                model: section.paired
                ListItem {
                    required property var modelData
                    width: lists.width
                    icon: section.iconFor(modelData)
                    text: modelData.name
                    current: modelData.connected
                    busy: modelData.state === BluetoothDeviceState.Connecting
                    note: section.note(modelData)
                    onActivated: section.activate(modelData)
                }
            }

            SectionLabel { text: "Nearby"; topPadding: 6; bottomPadding: 4 }
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
                color: Theme.tertiary
                bottomPadding: 6
            }
        }
    }
}
