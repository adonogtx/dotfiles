// Sound section of the Control Center: pick the output and the microphone on a
// segmented control, then set each volume. OUTPUT, a line, INPUT; no boxes (pill-spec.md).
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Column {
    id: section
    property var panel
    spacing: Theme.blockGap

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

        Column {
            id: block
            required property var modelData
            required property int index
            readonly property var list: modelData.isOutput ? section.outputs : section.inputs
            readonly property var node: modelData.isOutput ? section.sink : section.source
            width: section.width
            spacing: Theme.blockGap

            Hairline { visible: block.index > 0 }

            Column {
                width: parent.width
                spacing: 6

                SectionLabel { text: block.modelData.title }

                Segmented {
                    visible: block.list.length > 1
                    width: parent.width
                    options: block.list.map(n => ({
                        label: section.shortName(n, block.modelData.isOutput ? "Speakers" : "Built-in"),
                        icon: section.icon(n, block.modelData.isOutput ? "laptop" : "microphone"),
                        value: n
                    }))
                    current: block.node
                    onPicked: (n) => {
                        if (block.modelData.isOutput) Pipewire.preferredDefaultAudioSink = n
                        else Pipewire.preferredDefaultAudioSource = n
                    }
                }

                // With a single device there is nothing to choose: just say which one it is.
                Text {
                    visible: block.list.length <= 1
                    text: block.node ? section.panel.nodeName(block.node) : "No device"
                    font.family: Theme.sans; font.pixelSize: 12
                    color: Theme.secondary
                }

                Item { width: 1; height: 2 }

                Slider {
                    width: parent.width
                    icon: block.modelData.isOutput
                          ? (block.node && block.node.audio && block.node.audio.muted ? "volume-muted" : "volume")
                          : "microphone"
                    level: block.modelData.isOutput ? section.panel.soundLevel(block.node) : -1
                    value: block.node && block.node.audio ? block.node.audio.volume : 0
                    onMoved: (v) => section.panel.setVolume(block.node, v)
                }
            }
        }
    }
}
