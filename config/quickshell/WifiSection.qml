// Wi-Fi section of the Control Center. Talks to NetworkManager through nmcli.
// Saved networks connect with one click; a new secured one asks for its password inline.
// The password goes to nmcli through stdin, never on the command line, which any
// process on the machine can read while nmcli runs. Names never reach a shell.
import Quickshell
import Quickshell.Io
import QtQuick

Column {
    id: section
    spacing: Theme.blockGap

    property bool available: true
    property bool radioOn: false
    property var networks: []          // [{ ssid, signal, secure, active, band }]
    property var saved: []             // names of saved Wi-Fi connections
    property string asking: ""          // SSID waiting for a password
    property string connecting: ""
    property string failed: ""

    readonly property var current: networks.filter(n => n.active)
    readonly property var known: networks.filter(n => !n.active && saved.indexOf(n.ssid) >= 0)
    readonly property var others: networks.filter(n => !n.active && saved.indexOf(n.ssid) < 0)

    // nmcli -t separates fields with ":" and escapes a ":" inside a field as "\:".
    function splitTerse(line) {
        const out = []
        let cur = ""
        for (let i = 0; i < line.length; i++) {
            const c = line[i]
            if (c === "\\" && i + 1 < line.length) { cur += line[++i]; continue }
            if (c === ":") { out.push(cur); cur = ""; continue }
            cur += c
        }
        out.push(cur)
        return out
    }

    function refresh() {
        radio.running = true
        list.running = true
        savedList.running = true
    }

    function choose(net) {
        section.failed = ""
        if (net.active) return
        if (section.saved.indexOf(net.ssid) >= 0) {
            connect.command = ["nmcli", "connection", "up", "id", net.ssid]
            section.connecting = net.ssid
            connect.running = true
        } else if (net.secure) {
            section.asking = section.asking === net.ssid ? "" : net.ssid
        } else {
            connect.command = ["nmcli", "device", "wifi", "connect", net.ssid]
            section.connecting = net.ssid
            connect.running = true
        }
    }

    function sendPassword(ssid, password) {
        if (password.length === 0) return
        connect.command = ["nmcli", "--ask", "device", "wifi", "connect", ssid]
        section.connecting = ssid
        section.asking = ""
        connect.pendingPassword = password
        connect.running = true
    }

    // "5180 MHz" -> "5 GHz". The second line, only on the connected network: "Secured, 5 GHz".
    // NetworkManager on iwd reports 2417 MHz for every network it is not connected to,
    // so the band is only true for the connected one.
    function band(mhz) {
        if (!mhz) return ""
        return mhz >= 5925 ? "6 GHz" : mhz >= 4900 ? "5 GHz" : "2.4 GHz"
    }
    function subtitle(net) {
        return [net.secure ? "Secured" : "Open", net.band].filter(x => x !== "").join(", ")
    }

    function note(net) {
        if (section.connecting === net.ssid) return "Connecting"
        if (section.failed === net.ssid) return "Failed"
        return ""
    }

    Component.onCompleted: { rescan.running = true; refresh() }
    Timer { interval: 4000; repeat: true; running: true; onTriggered: section.refresh() }
    Timer { id: soon; interval: 1500; onTriggered: section.refresh() }

    Process {
        id: radio
        command: ["nmcli", "-t", "-f", "WIFI", "general"]
        stdout: StdioCollector { id: radioOut; onStreamFinished: section.radioOn = radioOut.text.trim() === "enabled" }
        onExited: (code) => section.available = code === 0
    }
    Process { id: rescan; command: ["nmcli", "device", "wifi", "rescan"]; onExited: soon.restart() }
    Process {
        id: list
        command: ["nmcli", "-t", "-f", "IN-USE,SIGNAL,SECURITY,FREQ,SSID", "device", "wifi", "list"]
        stdout: StdioCollector {
            id: listOut
            onStreamFinished: {
                const best = {}
                for (const line of listOut.text.split("\n")) {
                    if (!line) continue
                    const f = section.splitTerse(line)
                    const ssid = f[4]
                    if (!ssid) continue
                    const net = { ssid: ssid, signal: parseInt(f[1]) || 0, secure: f[2] !== "" && f[2] !== "--",
                                  active: f[0] === "*", band: section.band(parseInt(f[3])) }
                    const old = best[ssid]
                    if (!old || net.active || (!old.active && net.signal > old.signal)) best[ssid] = net
                }
                section.networks = Object.values(best)
                    .sort((a, b) => (b.active - a.active) || (b.signal - a.signal))
                    .slice(0, 10)
            }
        }
    }
    Process {
        id: savedList
        command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show"]
        stdout: StdioCollector {
            id: savedOut
            onStreamFinished: section.saved = savedOut.text.split("\n")
                .map(l => section.splitTerse(l))
                .filter(f => f[1] === "802-11-wireless")
                .map(f => f[0])
        }
    }
    Process {
        id: connect
        property string pendingPassword: ""
        stdinEnabled: true
        onStarted: {
            if (pendingPassword !== "") {
                write(pendingPassword + "\n")
                pendingPassword = ""
            }
        }
        onExited: (code) => {
            if (code !== 0) section.failed = section.connecting
            section.connecting = ""
            section.refresh()
        }
    }

    // Layout (pill-spec.md, Rows): the power row, a line, then the lists. No boxes.

    PowerRow {
        width: parent.width
        icon: section.radioOn ? "wifi" : "wifi-off"
        title: "Wi-Fi"
        subtitle: section.available ? "" : "NetworkManager is not running"
        on: section.radioOn
        onToggled: {
            if (!section.available) return
            Quickshell.execDetached(["nmcli", "radio", "wifi", section.radioOn ? "off" : "on"])
            soon.restart()
        }
    }

    Hairline { visible: section.available && section.radioOn }

    Column {
        id: lists
        visible: section.available && section.radioOn
        width: parent.width
        spacing: 2

        Repeater {
            model: [
                { title: "Connected", items: section.current },
                { title: "Known", items: section.known },
                { title: "Other Networks", items: section.others }
            ]

            Column {
                id: group
                required property var modelData
                visible: modelData.items.length > 0
                width: lists.width
                spacing: 2

                SectionLabel { text: group.modelData.title; leftPadding: 10; topPadding: 10; bottomPadding: 4 }

                Repeater {
                    model: group.modelData.items

                    Column {
                        id: entry
                        required property var modelData
                        width: group.width
                        spacing: 4

                        ListItem {
                            width: parent.width
                            icon: "wifi"
                            level: entry.modelData.signal < 40 ? 1 : entry.modelData.signal < 70 ? 2 : 3
                            text: entry.modelData.ssid
                            subtitle: entry.modelData.active ? section.subtitle(entry.modelData) : ""
                            current: entry.modelData.active
                            checked: entry.modelData.active && section.note(entry.modelData) === ""
                            locked: entry.modelData.secure && !entry.modelData.active
                            busy: section.connecting === entry.modelData.ssid
                            note: section.note(entry.modelData)
                            onActivated: section.choose(entry.modelData)
                        }

                        // Password, inline under the network that needs it.
                        Rectangle {
                            visible: section.asking === entry.modelData.ssid
                            x: 37
                            width: parent.width - 47
                            height: visible ? 30 : 0
                            radius: 8
                            color: Theme.panel
                            border.width: 1
                            border.color: password.activeFocus ? Theme.accent : Theme.line

                            TextInput {
                                id: password
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                echoMode: TextInput.Password
                                passwordCharacter: "•"
                                font.family: Theme.sans
                                font.pixelSize: Theme.body
                                color: Theme.label
                                selectionColor: Theme.accent
                                clip: true
                                onVisibleChanged: if (visible) forceActiveFocus(); else text = ""
                                onAccepted: section.sendPassword(entry.modelData.ssid, text)
                                Keys.onEscapePressed: section.asking = ""

                                Text {
                                    visible: password.text.length === 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Password"
                                    font: password.font
                                    color: Theme.tertiary
                                }
                            }
                        }
                    }
                }
            }
        }

        SectionLabel {
            visible: section.networks.length === 0
            text: "Searching…"
            leftPadding: 10; topPadding: 10
        }
    }
}
