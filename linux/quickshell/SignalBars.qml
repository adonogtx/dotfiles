import QtQuick

// Four rising bars, filled up to the signal strength (0 to 100)
Row {
    id: s

    property int strength: 0
    readonly property int level: strength > 75 ? 4 : strength > 50 ? 3 : strength > 25 ? 2 : 1

    spacing: 2
    height: 12

    Repeater {
        model: 4
        delegate: Rectangle {
            required property int index
            width: 3
            height: 4 + index * 2.7
            y: s.height - height
            radius: 1
            color: index < s.level ? Theme.fg : Theme.track
        }
    }
}
