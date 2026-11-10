// Default output: waves follow the volume. Scroll changes it in 5% steps, click opens the Sound menu.
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

BarItem {
    id: sound
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink !== null && sink.audio !== null
    readonly property bool muted: ready && sink.audio.muted
    readonly property real volume: ready ? sink.audio.volume : 0

    PwObjectTracker { objects: [sound.sink] }

    onWheeled: (delta) => {
        if (!ready) return
        const step = delta > 0 ? 0.05 : -0.05
        sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + step))
    }

    Glyph {
        name: sound.muted ? "volume-muted" : "volume"
        level: sound.volume <= 0 ? 0 : sound.volume < 0.5 ? 1 : 2
        color: sound.ink
    }
}
