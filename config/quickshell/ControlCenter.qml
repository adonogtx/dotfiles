// Control Center, shown inside the open pill.
// Exact sizes: docs/pill-spec.md. No inner boxes: blocks sit on the panel, 1 px lines between.
// Main view: five circles with fixed names (Wi-Fi, Bluetooth, Night Shift, Awake, Battery),
// three labelled sliders (Display, Sound, Microphone), a line, the footer. A circle toggles;
// its name opens the section. Night Shift and Awake have no section: the name toggles.
// Battery has nothing to toggle: circle and name open its section. The small chevron
// beside a slider opens Display or Sound.
// Every command is an argument list: network and device names never reach a shell.
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import QtQuick

Column {
    id: cc
    property var host
    property string section: "main"     // main, wifi, bluetooth, sound, display, battery
    spacing: Theme.blockGap

    // State

    property bool wifiOn: false
    property bool wifiAvailable: true
    property string wifiName: ""
    property int wifiSignal: -1
    property bool nightOn: false
    property real brightness: 0

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool btOn: adapter !== null && adapter.enabled
    readonly property var btDevice: Bluetooth.devices.values.find(d => d.connected) || null

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    PwObjectTracker { objects: [cc.sink, cc.source] }

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery !== null && battery.isPresent
    readonly property real charge: {
        if (!hasBattery) return 0
        const p = battery.percentage
        return p > 1 ? p / 100 : p
    }
    readonly property bool charging: hasBattery && battery.state === UPowerDeviceState.Charging

    function nodeName(node) {
        return node ? (node.description || node.nickname || node.name || "") : ""
    }
    function soundLevel(node) {
        if (!node || !node.audio || node.audio.muted) return 0
        return node.audio.volume <= 0 ? 0 : node.audio.volume < 0.5 ? 1 : 2
    }
    function setVolume(node, v) {
        if (!node || !node.audio) return
        node.audio.volume = v
        if (node.audio.muted && v > 0) node.audio.muted = false
    }
    function duration(seconds) {
        if (!seconds || seconds <= 0) return ""
        const h = Math.floor(seconds / 3600)
        const m = Math.floor((seconds % 3600) / 60)
        return h + ":" + (m < 10 ? "0" : "") + m
    }

    function refresh() {
        wifiRadio.running = true
        wifiSsid.running = true
        nightPoll.running = true
        brightGet.running = true
    }
    Component.onCompleted: refresh()

    // Changing section: the pill's height glides (Pill.qml) while the content fades back in.
    onSectionChanged: sectionFade.restart()
    NumberAnimation { id: sectionFade; target: cc; property: "opacity"; from: 0; to: 1; duration: 240; easing.type: Easing.OutCubic }
    Timer { interval: 2000; repeat: true; running: true; onTriggered: cc.refresh() }
    Timer { id: soon; interval: 600; onTriggered: cc.refresh() }

    // nmcli prints "enabled" or "disabled"; a failure means NetworkManager is not running.
    Process {
        id: wifiRadio
        command: ["nmcli", "-t", "-f", "WIFI", "general"]
        stdout: StdioCollector { id: radioOut; onStreamFinished: cc.wifiOn = radioOut.text.trim() === "enabled" }
        onExited: (code) => cc.wifiAvailable = code === 0
    }
    // Lines look like "yes:72:omori"; nmcli escapes ":" inside names as "\:".
    Process {
        id: wifiSsid
        command: ["nmcli", "-t", "-f", "ACTIVE,SIGNAL,SSID", "device", "wifi"]
        stdout: StdioCollector {
            id: ssidOut
            onStreamFinished: {
                const line = ssidOut.text.split("\n").find(l => l.startsWith("yes:"))
                if (!line) { cc.wifiName = ""; cc.wifiSignal = -1; return }
                const rest = line.slice(4)
                const cut = rest.indexOf(":")
                cc.wifiSignal = parseInt(rest.slice(0, cut))
                cc.wifiName = rest.slice(cut + 1).replace(/\\:/g, ":")
            }
        }
    }
    Process { id: nightPoll; command: ["pgrep", "-x", "hyprsunset"]; onExited: (code) => cc.nightOn = code === 0 }
    // "intel_backlight,backlight,412,57%,1000": the fourth field is the percent.
    Process {
        id: brightGet
        command: ["brightnessctl", "-e4", "-m"]
        stdout: StdioCollector {
            id: brightOut
            onStreamFinished: {
                const pct = parseInt(brightOut.text.split(",")[3])
                if (!isNaN(pct) && !brightSet.running) cc.brightness = pct / 100
            }
        }
    }
    function writeBrightness() { if (!brightTimer.running) brightTimer.start() }
    function toggleNight() {
        Quickshell.execDetached(["gus-nightlight"])
        soon.restart()
    }

    // Brightness is written at most every 60 ms while dragging.
    property real pendingBrightness: -1
    Process { id: brightSet }
    Timer {
        id: brightTimer
        interval: 60
        onTriggered: {
            if (cc.pendingBrightness < 0) return
            brightSet.command = ["brightnessctl", "-e4", "-n2", "set", Math.round(cc.pendingBrightness * 100) + "%"]
            brightSet.running = true
            cc.pendingBrightness = -1
        }
    }

    // Expanded section

    SectionHeader {
        visible: cc.section !== "main"
        width: parent.width
        title: ({ wifi: "Wi-Fi", bluetooth: "Bluetooth", sound: "Sound", display: "Display", battery: "Battery" })[cc.section] || ""
        onBack: cc.host.switchTo("main")
    }

    Loader {
        visible: cc.section !== "main"
        width: parent.width
        sourceComponent: cc.section === "wifi" ? wifiSection
                       : cc.section === "bluetooth" ? bluetoothSection
                       : cc.section === "sound" ? soundSection
                       : cc.section === "display" ? displaySection
                       : cc.section === "battery" ? batterySection
                       : null
    }
    Component { id: wifiSection; WifiSection {} }
    Component { id: bluetoothSection; BluetoothSection {} }
    Component { id: soundSection; SoundSection { panel: cc } }
    Component { id: displaySection; DisplaySection { panel: cc } }
    Component { id: batterySection; BatterySection { panel: cc } }

    // Main view: five circles in equal columns

    Row {
        id: circles
        visible: cc.section === "main"
        width: parent.width
        readonly property real column: width / 5

        CircleButton {
            width: circles.column
            icon: cc.wifiOn && cc.wifiSignal >= 0 ? "wifi" : "wifi-off"
            level: cc.wifiSignal < 0 ? -1 : cc.wifiSignal < 40 ? 1 : cc.wifiSignal < 70 ? 2 : 3
            label: "Wi-Fi"
            on: cc.wifiOn
            onToggled: {
                if (!cc.wifiAvailable) { cc.host.switchTo("wifi"); return }
                Quickshell.execDetached(["nmcli", "radio", "wifi", cc.wifiOn ? "off" : "on"])
                soon.restart()
            }
            onOpened: cc.host.switchTo("wifi")
        }
        CircleButton {
            width: circles.column
            icon: "bluetooth"
            label: "Bluetooth"
            on: cc.btOn
            onToggled: if (cc.adapter !== null) cc.adapter.enabled = !cc.adapter.enabled
            onOpened: cc.host.switchTo("bluetooth")
        }
        CircleButton {
            width: circles.column
            icon: "moon"
            label: "Night Shift"
            on: cc.nightOn
            onToggled: cc.toggleNight()
            onOpened: cc.toggleNight()
        }
        CircleButton {
            width: circles.column
            icon: "cup"
            label: "Awake"
            on: Awake.on
            onToggled: Awake.on = !Awake.on
            onOpened: Awake.on = !Awake.on
        }
        CircleButton {
            width: circles.column
            icon: cc.charging ? "bolt" : "battery"
            label: "Battery"
            on: false
            onToggled: cc.host.switchTo("battery")
            onOpened: cc.host.switchTo("battery")
        }
    }

    // Main view: three sliders, each with its label above and a chevron to its section

    Column {
        id: sliders
        visible: cc.section === "main"
        width: parent.width
        spacing: 12

        Repeater {
            model: [
                { key: "display", title: "Display", icon: "sun", section: "display" },
                { key: "sound", title: "Sound", icon: "volume", section: "sound" },
                { key: "microphone", title: "Microphone", icon: "microphone", section: "sound" }
            ]

            Column {
                id: line
                required property var modelData
                readonly property var node: modelData.key === "sound" ? cc.sink : modelData.key === "microphone" ? cc.source : null
                width: sliders.width
                spacing: 6

                SectionLabel { text: line.modelData.title }

                Item {
                    width: parent.width
                    height: 24

                    Slider {
                        anchors.left: parent.left
                        anchors.right: more.left
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        icon: line.modelData.key === "sound" && line.node && line.node.audio && line.node.audio.muted ? "volume-muted" : line.modelData.icon
                        level: line.modelData.key === "sound" ? cc.soundLevel(line.node) : -1
                        value: line.modelData.key === "display" ? cc.brightness
                             : line.node && line.node.audio ? line.node.audio.volume : 0
                        onMoved: (v) => {
                            if (line.modelData.key === "display") {
                                cc.brightness = v
                                cc.pendingBrightness = v
                                cc.writeBrightness()
                            } else {
                                cc.setVolume(line.node, v)
                            }
                        }
                    }
                    Rectangle {
                        id: more
                        width: 22; height: 22; radius: 11
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: moreMouse.containsMouse ? Theme.wash : "transparent"
                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                        Glyph {
                            name: "chevron-right"
                            width: 12; height: 12
                            color: moreMouse.containsMouse ? Theme.secondary : Theme.tertiary
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            id: moreMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: cc.host.switchTo(line.modelData.section)
                        }
                    }
                }
            }
        }
    }

    // Main view: a line, then the footer (only inside the pill, which can open the calendar)

    readonly property bool hasFooter: cc.host !== undefined && cc.host !== null && typeof cc.host.openCalendar === "function"

    Hairline { visible: cc.section === "main" && cc.hasFooter }

    PillFooter {
        visible: cc.section === "main" && cc.hasFooter
        width: parent.width
        onCalendarRequested: cc.host.openCalendar()
    }
}
