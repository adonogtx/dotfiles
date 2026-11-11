// Battery: hairline outline, fill by charge in the bar ink, green charging, red low.
import Quickshell.Services.UPower
import QtQuick

BarItem {
    id: bat
    readonly property var dev: UPower.displayDevice
    readonly property real level: {
        if (!dev) return 0
        const p = dev.percentage
        return p > 1 ? p / 100 : p          // accept 0..1 or 0..100
    }
    readonly property bool charging: dev !== null && dev.state === UPowerDeviceState.Charging
    visible: dev !== null && dev.isPresent

    Item {
        width: 21; height: 10
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: shell
            width: 19; height: 10; radius: 2.5
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(bat.ink.r, bat.ink.g, bat.ink.b, 0.55)
            Rectangle {
                x: 1.5; y: 1.5
                height: parent.height - 3
                width: Math.max(1.5, (parent.width - 3) * bat.level)
                radius: 1.5
                color: bat.charging ? Theme.green : (bat.level < 0.2 ? Theme.red : bat.ink)
            }
        }
        Rectangle {
            x: 19.5; y: 3
            width: 1.5; height: 4; radius: 0.75
            color: Qt.rgba(bat.ink.r, bat.ink.g, bat.ink.b, 0.55)
        }
    }
}
