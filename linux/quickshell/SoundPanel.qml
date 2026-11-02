pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

// Output, input with a live level meter, and per app volume.
// Device naming follows Omarchy's audio panel (MIT): prefer the node nick or profile description,
// which gives "Speaker" or "Digital Microphone" instead of the long chipset name.
PanelFrame {
    id: p

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var nodes: Pipewire.nodes ? Pipewire.nodes.values : []
    readonly property var sinks: nodes.filter(n => n && n.audio && n.isSink && !n.isStream)
    readonly property var sources: nodes.filter(n => n && n.audio && !n.isSink && !n.isStream && n.name !== "quickshell")
    readonly property var streams: nodes.filter(n => n && n.audio && n.isStream && n.isSink)

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    PwObjectTracker { objects: p.sinks }
    PwObjectTracker { objects: p.sources }
    PwObjectTracker { objects: p.streams }

    PwNodePeakMonitor {
        id: micLevel
        node: p.source
        enabled: p.open && !!p.source
    }

    function props(n) {
        return n && n.ready && n.properties ? n.properties : {};
    }

    function clean(text) {
        return String(text || "").trim()
            .replace(/^sof-soundwire\s+/i, "")
            .replace(/^built-?in audio\s+/i, "")
            .replace(/\s+Output$/i, "")
            .replace(/\s+Input$/i, "")
            .replace(/\bMicrophones\b/g, "Microphone");
    }

    function label(n) {
        if (!n) return "Unknown";
        const pr = props(n);
        const nick = clean(n.nickname || pr["node.nick"] || pr["device.profile.description"] || "");
        return nick || clean(n.description || pr["node.description"] || n.name || "Unknown");
    }

    function blob(n) {
        const pr = props(n);
        return [n.name, n.description, n.nickname, pr["device.icon-name"] || "", pr["device.product.name"] || ""].join(" ").toLowerCase();
    }

    function glyph(n, input) {
        const b = blob(n);
        if (b.indexOf("headphone") !== -1 || b.indexOf("headset") !== -1 || b.indexOf("earbud") !== -1) return Theme.iHeadphones;
        if (b.indexOf("bluetooth") !== -1 || b.indexOf("bluez") !== -1) return Theme.iBluetooth;
        if (b.indexOf("hdmi") !== -1 || b.indexOf("display") !== -1) return Theme.iMonitor;
        return input ? Theme.iMic : Theme.iSpeaker;
    }

    function appName(n) {
        const pr = props(n);
        return pr["application.name"] || n.description || pr["media.name"] || n.name || "App";
    }

    PanelHero {
        glyph: p.muted ? Theme.iVolumeOff : Theme.iVolume
        tint: p.muted ? Theme.red : Theme.fg
        title: "Sound"
        status: p.muted ? "Muted" : p.label(p.sink) + " · " + Math.round(p.volume * 100) + "%"
        onGlyphClicked: if (p.sink?.audio) p.sink.audio.muted = !p.sink.audio.muted
    }

    SectionLabel {
        text: "Output"
        tint: Theme.yellow
        value: Math.round(p.volume * 100) + "%"
    }

    FillSlider {
        value: p.volume
        tint: Theme.yellow
        onMoved: v => { if (p.sink?.audio) p.sink.audio.volume = v; }
    }

    Repeater {
        model: p.sinks
        delegate: ListRow {
            required property var modelData
            glyph: p.glyph(modelData, false)
            label: p.label(modelData)
            selected: modelData === p.sink
            onClicked: Pipewire.preferredDefaultAudioSink = modelData
        }
    }

    SectionLabel {
        text: "Input"
        tint: Theme.green
        value: (p.source?.audio?.muted ?? false) ? "muted" : Math.round((p.source?.audio?.volume ?? 0) * 100) + "%"
    }

    FillSlider {
        value: p.source?.audio?.volume ?? 0
        tint: Theme.green
        onMoved: v => { if (p.source?.audio) p.source.audio.volume = v; }
    }

    // Live microphone level
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 3
        radius: 2
        color: Theme.track

        Rectangle {
            height: parent.height
            radius: 2
            width: parent.width * Math.max(0, Math.min(1, micLevel.peak))
            color: Theme.green

            Behavior on width {
                NumberAnimation { duration: 80 }
            }
        }
    }

    Repeater {
        model: p.sources
        delegate: ListRow {
            required property var modelData
            glyph: p.glyph(modelData, true)
            label: p.label(modelData)
            selected: modelData === p.source
            onClicked: Pipewire.preferredDefaultAudioSource = modelData
        }
    }

    SectionLabel {
        visible: p.streams.length > 0
        text: "Apps"
        tint: Theme.purple
    }

    Repeater {
        model: p.streams
        delegate: RowLayout {
            required property var modelData
            Layout.fillWidth: true
            spacing: 10

            Text {
                Layout.preferredWidth: 90
                text: p.appName(modelData)
                elide: Text.ElideRight
                color: Theme.fgSoft
                font.family: Theme.mono
                font.pixelSize: 12
            }

            FillSlider {
                tint: Theme.purple
                value: modelData.audio ? modelData.audio.volume : 0
                onMoved: v => { if (modelData.audio) modelData.audio.volume = v; }
            }
        }
    }

    Separator {}

    LinkRow {
        text: "Sound settings…"
        onClicked: {
            Quickshell.execDetached(["ghostty", "-e", "wiremix"]);
            p.dismissed();
        }
    }
}
