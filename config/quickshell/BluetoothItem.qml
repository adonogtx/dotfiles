// Bluetooth adapter state: grey when on, faint when off. Click opens the Bluetooth menu.
import Quickshell
import Quickshell.Bluetooth
import QtQuick

BarItem {
    id: bt
    readonly property bool on: Bluetooth.defaultAdapter !== null && Bluetooth.defaultAdapter.enabled
    Glyph { name: "bluetooth"; color: bt.on ? bt.ink : Theme.tertiary }
}
