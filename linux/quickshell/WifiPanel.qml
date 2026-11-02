pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Networking

// Wi-Fi through Quickshell.Networking (NetworkManager), so it works on any Arch, not only Omarchy.
// Network objects are turned into plain rows, as Omarchy does: NetworkManager can drop an access point
// while a list row still points to it, and plain data avoids that crash.
PanelFrame {
    id: p

    readonly property var devices: Networking.devices ? Networking.devices.values : []
    readonly property var wifiDevice: {
        let fallback = null;
        for (const d of devices) {
            if (!d || d.type !== DeviceType.Wifi) continue;
            if (d.connected) return d;
            if (!fallback) fallback = d;
        }
        return fallback;
    }
    readonly property var networkObjects: wifiDevice && wifiDevice.networks ? wifiDevice.networks.values : []

    readonly property var rows: {
        const list = [];
        for (const n of networkObjects) {
            if (!n || !n.name) continue;
            list.push({
                ssid: n.name,
                connected: !!n.connected,
                known: !!n.known,
                signal: Math.round((n.signalStrength || 0) * 100),
                open: n.security === WifiSecurityType.Open || n.security === WifiSecurityType.Owe
            });
        }
        list.sort((a, b) => (b.connected - a.connected) || (b.known - a.known) || (b.signal - a.signal));
        return list;
    }
    readonly property var knownRows: rows.filter(r => r.known).slice(0, 5)
    readonly property var otherRows: rows.filter(r => !r.known).slice(0, 5)
    readonly property var current: rows.find(r => r.connected)

    // Live stats of the active connection
    property var info: ({})
    property real downRate: 0
    property real upRate: 0
    property real lastRx: -1
    property real lastTx: -1
    property real lastTime: 0

    function humanRate(bytesPerSecond) {
        if (bytesPerSecond >= 1048576) return (bytesPerSecond / 1048576).toFixed(1) + " MB/s";
        if (bytesPerSecond >= 1024) return (bytesPerSecond / 1024).toFixed(1) + " KB/s";
        return Math.round(bytesPerSecond) + " B/s";
    }

    function networkFor(ssid) {
        return networkObjects.find(n => n && n.name === ssid) || null;
    }

    function activate(row) {
        const net = networkFor(row.ssid);
        if (row.connected) {
            if (net) net.disconnect();
            return;
        }
        if (row.known || row.open) {
            if (net) net.connect();
            return;
        }
        // A secured network you never joined: ask for the password in a terminal
        Quickshell.execDetached(["ghostty", "-e", "nmcli", "--ask", "dev", "wifi", "connect", row.ssid]);
        p.dismissed();
    }

    onOpenChanged: {
        if (wifiDevice) wifiDevice.scannerEnabled = open;
        if (open) {
            lastRx = -1;
            statsProc.running = true;
        }
    }

    Process {
        id: statsProc
        command: ["sh", "-c",
            "dev=$(ip route show default 2>/dev/null | awk '{print $5; exit}'); [ -z \"$dev\" ] && exit 0; "
            + "gw=$(ip route show default | awk '{print $3; exit}'); "
            + "ip=$(ip -4 -o addr show dev \"$dev\" | awk '{print $4}' | cut -d/ -f1 | head -n1); "
            + "rx=$(cat /sys/class/net/$dev/statistics/rx_bytes); tx=$(cat /sys/class/net/$dev/statistics/tx_bytes); "
            + "ping=$(ping -c1 -W1 1.1.1.1 2>/dev/null | sed -n 's/.*time=\\([0-9.]*\\).*/\\1/p'); "
            + "printf 'iface\\t%s\\nip\\t%s\\ngateway\\t%s\\nrx\\t%s\\ntx\\t%s\\nping\\t%s\\n' \"$dev\" \"$ip\" \"$gw\" \"$rx\" \"$tx\" \"$ping\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const next = {};
                for (const line of this.text.split("\n")) {
                    const i = line.indexOf("\t");
                    if (i > 0) next[line.substring(0, i)] = line.substring(i + 1).trim();
                }
                const now = Date.now();
                const rx = parseFloat(next.rx || "0"), tx = parseFloat(next.tx || "0");
                if (p.lastRx >= 0 && now > p.lastTime) {
                    const dt = (now - p.lastTime) / 1000;
                    p.downRate = Math.max(0, (rx - p.lastRx) / dt);
                    p.upRate = Math.max(0, (tx - p.lastTx) / dt);
                }
                p.lastRx = rx;
                p.lastTx = tx;
                p.lastTime = now;
                p.info = next;
            }
        }
    }

    Timer {
        interval: 2000
        running: p.open
        repeat: true
        onTriggered: statsProc.running = true
    }

    PanelHero {
        glyph: Networking.wifiEnabled ? Theme.iWifi : Theme.iWifiOff
        tint: Networking.wifiEnabled ? Theme.fg : Theme.fgFaint
        title: "Wi-Fi"
        status: !Networking.wifiEnabled ? "Off"
            : p.current ? p.current.ssid + (p.info.ping ? " · " + Math.round(parseFloat(p.info.ping)) + " ms" : "")
            : "Not connected"

        Toggle {
            checked: Networking.wifiEnabled
            tint: Theme.blue
            onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
        }
    }

    InfoGrid {
        visible: !!p.current && !!p.info.ip
        items: [
            { label: "Down", value: p.humanRate(p.downRate) },
            { label: "Up", value: p.humanRate(p.upRate) },
            { label: "Signal", value: (p.current ? p.current.signal : 0) + "%" },
            { label: "Ping", value: p.info.ping ? Math.round(parseFloat(p.info.ping)) + " ms" : "–" },
            { label: "IP", value: p.info.ip || "–" },
            { label: "Gateway", value: p.info.gateway || "–" }
        ]
    }

    Separator {
        visible: !!p.current && !!p.info.ip
    }

    SectionLabel {
        visible: p.knownRows.length > 0
        text: "Known networks"
        tint: Theme.blue
    }

    Repeater {
        model: p.knownRows
        delegate: ListRow {
            required property var modelData
            label: modelData.ssid
            selected: modelData.connected
            signal: modelData.signal
            onClicked: p.activate(modelData)
        }
    }

    SectionLabel {
        visible: p.otherRows.length > 0
        text: "Other networks"
        tint: Theme.orange
    }

    Repeater {
        model: p.otherRows
        delegate: ListRow {
            required property var modelData
            label: modelData.ssid
            locked: !modelData.open
            signal: modelData.signal
            onClicked: p.activate(modelData)
        }
    }

    Separator {}

    LinkRow {
        text: "Network settings…"
        onClicked: {
            Quickshell.execDetached(["ghostty", "-e", "nmtui"]);
            p.dismissed();
        }
    }
}
