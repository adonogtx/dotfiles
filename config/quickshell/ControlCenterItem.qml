// Control Center button, between search and the date. Bright while the panel is open.
import QtQuick

BarItem {
    id: control
    property bool open: false
    active: open
    Glyph { name: "adjustments"; color: control.ink }
}
