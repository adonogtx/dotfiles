import QtQuick
import QtQuick.Layouts

// Small uppercase section title, with an optional value on the right
RowLayout {
    property string text: ""
    property string value: ""
    property color tint: Theme.orange

    Layout.fillWidth: true
    Layout.topMargin: 4

    Text {
        Layout.fillWidth: true
        text: parent.text.toUpperCase()
        color: parent.tint
        font.family: Theme.mono
        font.pixelSize: 10
        font.letterSpacing: 1
    }

    Text {
        visible: parent.value !== ""
        text: parent.value
        color: Theme.fgSoft
        font.family: Theme.mono
        font.pixelSize: 11
    }
}
