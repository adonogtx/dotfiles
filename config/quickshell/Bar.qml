// The menu bar: 木 and workspaces on the left, status on the right.
// Status icons open the Control Center on their section, the date opens the calendar,
// search opens Spotlight. Panels drop right under the icon that opened them.
import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    property string menu: ""                    // "control" or "calendar" when open from this bar
    property string section: ""                 // Control Center section shown
    signal menuRequested(string name, real x)   // x: centre of the icon, in screen pixels
    signal spotlightRequested()

    function request(name, item) {
        const p = item.mapToItem(null, item.width / 2, 0)
        bar.menuRequested(name, p.x)
    }

    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight
    color: Theme.bar

    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 1
        color: Theme.hairline
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.edge
        anchors.rightMargin: Theme.edge
        spacing: Theme.itemGap

        Tree {}
        Item { implicitWidth: 10 }
        Workspaces {}

        Item { Layout.fillWidth: true }

        InputSeal {}
        BluetoothItem {
            id: btItem
            active: bar.menu === "control" && bar.section === "bluetooth"
            onClicked: bar.request("bluetooth", btItem)
        }
        WifiItem {
            id: wifiItem
            active: bar.menu === "control" && bar.section === "wifi"
            onClicked: bar.request("wifi", wifiItem)
        }
        SoundItem {
            id: soundItem
            active: bar.menu === "control" && bar.section === "sound"
            onClicked: bar.request("sound", soundItem)
        }
        BatteryItem {
            id: batteryItem
            active: bar.menu === "control" && bar.section === "battery"
            onClicked: bar.request("battery", batteryItem)
        }
        SearchItem {
            onClicked: bar.spotlightRequested()
        }
        ControlCenterItem {
            id: controlItem
            open: bar.menu === "control" && bar.section === "main"
            onClicked: bar.request("control", controlItem)
        }
        DateItem {
            id: dateItem
            active: bar.menu === "calendar"
            onClicked: bar.request("calendar", dateItem)
        }
    }
}
