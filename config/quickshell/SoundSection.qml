// Sound section of the Control Center: pick the output and the microphone on a
// segmented control, then set each volume. One tile for each direction.
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Column {
    id: section
    property var panel
    spacing: Theme.panelPad

    readonly property var nodes: Pipewire.nodes.values
    readonly property var outputs: nodes.filter(n => n.audio && n.isSink && !n.isStream)
    readonly property var inputs: nodes.filter(n => n.audio && !n.isSink && !n.isStream)
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    PwObjectTracker { objects: section.outputs.concat(section.inputs) }

    // Short names and icons for the segments: "Speakers", "HDMI", or the device's own name.
    function kind(node) {
        const n = (section.panel.nodeName(node) + " " + (node.name || "")).toLowerCase()
        if (n.includes("hdmi") || n.includes("displayport")) return "hdmi"
        if (n.includes("bluez") || n.includes("headset") || n.includes("headphone") || n.includes("usb")) return "device"
        return "builtin"
    }
    function shortName(node, builtinName) {
        const k = section.kind(node)
        if (k === "hdmi") return "HDMI"
        if (k === "builtin") return builtinName
        return section.panel.nodeName(node).replace(/ (Analog|Digital) (Stereo|Mono|Input|Output).*$/i, "")
    }
    function icon(node, builtinIcon) {
        const k = section.kind(node)
        return k === "hdmi" ? "tv" : k === "device" ? "headphones" : builtinIcon
    }

    Repeater {
        model: [
            { title: "Output", isOutput: true },
            { title: "Input", isOutput: false }
        ]

        Tile {
            id: tile
            required property var modelData
            readonly property var list: modelData.isOutput ? section.outputs : section.inputs
            readonly property var node: modelData.isOutput ? section.sink : section.source
            width: section.width
            height: col.height + Theme.tilePad * 2

            Column {
                id: col
                x: Theme.tilePad; y: Theme.tilePad
                width: parent.width - Theme.tilePad * 2
                spacing: 10

                SectionLabel { text: tile.modelData.title; leftPadding: 0 }

                Segmented {
                    visible: tile.list.length > 1
                    width: parent.width
                    options: tile.list.map(n => ({
                        label: section.shortName(n, tile.modelData.isOutput ? "Speakers" : "Built-in"),
                        icon: section.icon(n, tile.modelData.isOutput ? "laptop" : "microphone"),
                        value: n
                    }))
                    current: tile.node
                    onPicked: (n) => {
                        if (tile.modelData.isOutput) Pipewire.preferredDefaultAudioSink = n
                        else Pipewire.preferredDefaultAudioSource = n
                    }
                }

                // With a single device there is nothing to choose: just say which one it is.
                Text {
                    visible: tile.list.length <= 1
                    text: tile.node ? section.panel.nodeName(tile.node) : "No device"
                    font.family: Theme.sans; font.pixelSize: 11
                    color: Theme.secondary
                }

                Slider {
                    width: parent.width
                    icon: tile.modelData.isOutput
                          ? (tile.node && tile.node.audio && tile.node.audio.muted ? "volume-muted" : "volume")
                          : "microphone"
                    level: tile.modelData.isOutput ? section.panel.soundLevel(tile.node) : -1
                    value: tile.node && tile.node.audio ? tile.node.audio.volume : 0
                    onMoved: (v) => section.panel.setVolume(tile.node, v)
                }
            }
        }
    }
}
