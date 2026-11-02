pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

// Brightness, text size, scale and Night Shift.
// Text size and scale use Omarchy's own scripts when they exist, and portable commands otherwise,
// so the panel keeps working after leaving Omarchy.
PanelFrame {
    id: p

    property bool nightShift: false
    signal nightShiftRequested(bool on)

    property real brightness: 0.5
    property string monitor: ""
    property int monWidth: 0
    property int monHeight: 0
    property real monScale: 1
    property int textSize: 12

    readonly property var textStops: [9, 10, 11, 12, 14, 16, 20]
    readonly property var scales: ["1", "1.25", "1.5", "2"]
    readonly property int textIndex: {
        let best = 0;
        for (let i = 0; i < textStops.length; i++)
            if (Math.abs(textStops[i] - textSize) < Math.abs(textStops[best] - textSize)) best = i;
        return best;
    }

    onOpenChanged: if (open) refresh()

    function refresh() {
        readBrightness.running = true;
        readMonitor.running = true;
        readText.running = true;
    }

    function setTextSize(px) {
        p.textSize = px;
        Quickshell.execDetached(["sh", "-c",
            "if command -v omarchy-display-text-size >/dev/null; then omarchy-display-text-size " + px + "; "
            + "else gsettings set org.gnome.desktop.interface text-scaling-factor " + (px / 12).toFixed(3) + "; fi"]);
    }

    function setScale(s) {
        p.monScale = parseFloat(s);
        const lua = 'hl.monitor({ output = "' + p.monitor + '", mode = "preferred", position = "auto", scale = ' + s + ' })';
        Quickshell.execDetached(["sh", "-c",
            "if command -v omarchy-hyprland-monitor-scaling >/dev/null; then omarchy-hyprland-monitor-scaling " + s + "; "
            + "else hyprctl eval '" + lua + "'; fi"]);
    }

    // brightnessctl -m prints: device,class,current,percent%,max
    Process {
        id: readBrightness
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const f = this.text.trim().split(",");
                if (f.length >= 4) p.brightness = parseInt(f[3]) / 100;
            }
        }
    }

    Process {
        id: readMonitor
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const list = JSON.parse(this.text);
                    const m = list.find(x => x.focused) || list[0];
                    if (!m) return;
                    p.monitor = m.name;
                    p.monWidth = m.width;
                    p.monHeight = m.height;
                    p.monScale = m.scale;
                } catch (e) {}
            }
        }
    }

    Process {
        id: readText
        command: ["gsettings", "get", "org.gnome.desktop.interface", "text-scaling-factor"]
        stdout: StdioCollector {
            onStreamFinished: {
                const f = parseFloat(this.text.trim());
                if (f > 0) p.textSize = Math.round(f * 12);
            }
        }
    }

    PanelHero {
        glyph: p.nightShift ? Theme.iMoon : Theme.iMonitor
        tint: p.nightShift ? Theme.orange : Theme.fg
        title: "Display"
        status: p.monWidth > 0 ? p.monWidth + "×" + p.monHeight + " · " + (Math.round(p.monScale * 100) / 100) + "x" : (p.monitor || "")
    }

    SectionLabel {
        text: "Brightness"
        tint: Theme.yellow
        value: Math.round(p.brightness * 100) + "%"
    }

    FillSlider {
        value: p.brightness
        tint: Theme.yellow
        onMoved: v => {
            p.brightness = Math.max(0.05, v);
            Quickshell.execDetached(["brightnessctl", "-q", "set", Math.round(p.brightness * 100) + "%"]);
        }
    }

    SectionLabel {
        text: "Text size"
        tint: Theme.green
        value: p.textSize + "px"
    }

    Segmented {
        tint: Theme.green
        items: p.textStops.map(s => ({ label: String(s) }))
        current: p.textIndex
        onPicked: i => p.setTextSize(p.textStops[i])
    }

    SectionLabel {
        text: "Scale"
        tint: Theme.blue
    }

    Segmented {
        tint: Theme.blue
        items: p.scales.map(s => ({ label: s + "x" }))
        current: p.scales.findIndex(s => Math.abs(parseFloat(s) - p.monScale) < 0.02)
        onPicked: i => p.setScale(p.scales[i])
    }

    Separator {}

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            text: "Night Shift"
            color: Theme.fgStrong
            font.family: Theme.mono
            font.pixelSize: 13
        }

        Toggle {
            checked: p.nightShift
            tint: Theme.orange
            onToggled: {
                const on = !p.nightShift;
                p.nightShiftRequested(on);
                Quickshell.execDetached(["sh", "-c", on
                    ? "pgrep -x hyprsunset >/dev/null || { setsid hyprsunset >/dev/null 2>&1 & sleep 1; }; hyprctl hyprsunset temperature 4000"
                    : "hyprctl hyprsunset identity"]);
            }
        }
    }
}
