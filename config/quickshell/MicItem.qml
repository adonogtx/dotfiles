// Microphone in use: shown while any app captures from an input device, through PipeWire.
// A capture is a link from a hardware source (not a sink's monitor, not a stream) to a stream.
import Quickshell.Services.Pipewire
import QtQuick

LiveItem {
    active: Pipewire.linkGroups.values.some(g =>
        g.source && g.target
        && g.source.audio && !g.source.isSink && !g.source.isStream
        && g.target.isStream)
    icon: "microphone"
}
