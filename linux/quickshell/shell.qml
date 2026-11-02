pragma ComponentBehavior: Bound

// gus-bar
// Lives in ~/.config/quickshell, so a plain `qs` starts it (Hyprland does that on login).
// Restart: SUPER + CTRL + R

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Bluetooth

ShellRoot {
    id: root

    // Which panel is open: "", "calendar", "wifi", "bluetooth", "sound", "display", "battery"
    property string openPanel: ""
    property bool nightShift: false

    function toggle(name) {
        openPanel = openPanel === name ? "" : name;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    // Network state, checked every 10 seconds
    property bool online: true
    Process {
        id: netCheck
        command: ["nmcli", "-t", "-f", "STATE", "general"]
        stdout: StdioCollector {
            onStreamFinished: root.online = this.text.trim().startsWith("connected")
        }
    }
    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netCheck.running = true
    }

    // Keiko in progress ("稽古 23m · intent"), checked every 15 seconds
    property string keiko: ""
    Process {
        id: keikoCheck
        command: ["sh", "-c", "keiko status --short 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: root.keiko = this.text.trim()
        }
    }
    Timer {
        interval: 15000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: keikoCheck.running = true
    }

    readonly property bool btOn: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property bool btConnected: Bluetooth.devices.values.some(d => d.connected)
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property bool micMuted: source?.audio?.muted ?? false

    readonly property var battery: UPower.displayDevice
    readonly property real batteryLevel: battery?.percentage ?? 1
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging
    readonly property bool batteryLow: batteryLevel <= 0.2 && !charging

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: Theme.bg

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: Theme.panel
            }

            // Left: kamon and workspaces
            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                spacing: 14

                Text {
                    text: ""
                    font.family: Theme.kamon
                    font.pixelSize: 17
                    color: Theme.fg
                }

                RowLayout {
                    spacing: 4

                    Repeater {
                        model: 5

                        delegate: Item {
                            id: ws
                            required property int index
                            readonly property int wsId: index + 1
                            readonly property bool active: Hyprland.focusedWorkspace?.id === wsId
                            readonly property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

                            implicitWidth: 18
                            implicitHeight: 22

                            Rectangle {
                                anchors.centerIn: parent
                                visible: ws.active
                                width: 10
                                height: 10
                                radius: 2
                                color: Theme.yellow
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: !ws.active
                                text: ws.wsId
                                font.family: Theme.mono
                                font.pixelSize: 13
                                color: ws.occupied ? Theme.fg : Theme.fgFaint
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                // Lua Hyprland takes a dispatcher expression
                                onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + ws.wsId + '" })')
                            }
                        }
                    }
                }
            }

            // Center: 11月1日(日) and the time; click opens the calendar
            Item {
                id: dateButton
                anchors.centerIn: parent
                implicitWidth: dateRow.implicitWidth + 20
                implicitHeight: 22

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: Theme.item
                    visible: root.openPanel === "calendar"
                }

                RowLayout {
                    id: dateRow
                    anchors.centerIn: parent
                    spacing: 10

                    // 11月1日(日): bright numbers, dim 月 and 日, weekday kanji in the color of its element
                    Text {
                        function paint(color, s) {
                            return "<font color='" + color + "'>" + s + "</font>";
                        }
                        readonly property var d: clock.date
                        textFormat: Text.StyledText
                        text: paint(Theme.dateNumber, d.getMonth() + 1) + paint(Theme.dateKanji, "月")
                            + paint(Theme.dateNumber, d.getDate()) + paint(Theme.dateKanji, "日")
                            + paint(Theme.dateParen, "(")
                            + paint(Theme.elements[d.getDay()], Qt.locale("ja_JP").toString(d, "ddd"))
                            + paint(Theme.dateParen, ")")
                        font.family: Theme.mono
                        font.pixelSize: 13
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "HH:mm")
                        font.family: Theme.mono
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.fgStrong
                    }

                    // 稽古 23m, only while a keiko runs
                    Text {
                        visible: root.keiko !== ""
                        textFormat: Text.StyledText
                        text: "<font color='" + Theme.yellow + "'>稽古</font> <font color='" + Theme.fgSoft + "'>"
                            + root.keiko.replace(/^稽古\s*/, "").split(" · ")[0] + "</font>"
                        font.family: Theme.mono
                        font.pixelSize: 13
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggle("calendar")
                }
            }

            // Right: status icons, each one opens its panel
            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                IconButton {
                    id: btButton
                    glyph: root.btOn ? Theme.iBluetooth : Theme.iBluetoothOff
                    tint: root.btConnected ? Theme.blue : (root.btOn ? Theme.fg : Theme.fgFaint)
                    active: root.openPanel === "bluetooth"
                    onClicked: root.toggle("bluetooth")
                }

                IconButton {
                    id: wifiButton
                    glyph: root.online ? Theme.iWifi : Theme.iWifiOff
                    tint: root.online ? Theme.fg : Theme.red
                    active: root.openPanel === "wifi"
                    onClicked: root.toggle("wifi")
                }

                IconButton {
                    id: soundButton
                    glyph: root.muted ? Theme.iVolumeOff : Theme.iVolume
                    tint: root.muted ? Theme.red : Theme.fg
                    active: root.openPanel === "sound"
                    onClicked: root.toggle("sound")
                    onScrolled: direction => {
                        if (!root.sink?.audio) return;
                        root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + 0.05 * direction));
                    }
                }

                IconButton {
                    id: displayButton
                    glyph: root.nightShift ? Theme.iMoon : Theme.iMonitor
                    tint: root.nightShift ? Theme.orange : Theme.fg
                    active: root.openPanel === "display"
                    onClicked: root.toggle("display")
                }

                BatteryIcon {
                    id: batteryButton
                    level: root.batteryLevel
                    tint: root.batteryLow ? Theme.red : (root.charging ? Theme.yellow : Theme.green)
                    showPercent: root.batteryLow
                    active: root.openPanel === "battery"
                    onClicked: root.toggle("battery")
                }
            }

            CalendarPanel {
                anchorItem: dateButton
                open: root.openPanel === "calendar"
                onDismissed: root.openPanel = ""
            }

            WifiPanel {
                anchorItem: wifiButton
                open: root.openPanel === "wifi"
                onDismissed: root.openPanel = ""
            }

            BluetoothPanel {
                anchorItem: btButton
                open: root.openPanel === "bluetooth"
                onDismissed: root.openPanel = ""
            }

            SoundPanel {
                anchorItem: soundButton
                open: root.openPanel === "sound"
                onDismissed: root.openPanel = ""
            }

            DisplayPanel {
                anchorItem: displayButton
                open: root.openPanel === "display"
                nightShift: root.nightShift
                onNightShiftRequested: on => root.nightShift = on
                onDismissed: root.openPanel = ""
            }

            BatteryPanel {
                anchorItem: batteryButton
                open: root.openPanel === "battery"
                onDismissed: root.openPanel = ""
            }
        }
    }
}
