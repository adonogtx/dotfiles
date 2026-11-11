// Awake (desktop.md, Control Center): while on, an idle inhibitor holds hypridle, so
// dim, lock and suspend wait; lock before sleep stays on. Starts off on every restart.
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property bool on: false
}
