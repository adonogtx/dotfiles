import QtQuick
import QtQuick.Layouts

// Panel header: icon in a soft tile, title, one line of status, and an optional control on the right
RowLayout {
    id: hero

    property string glyph: ""
    property color tint: Theme.fg
    property string title: ""
    property string status: ""
    default property alias trailing: trail.data
    signal glyphClicked

    Layout.fillWidth: true
    spacing: 12

    Rectangle {
        implicitWidth: 38
        implicitHeight: 38
        radius: 10
        color: Theme.item

        Text {
            anchors.centerIn: parent
            text: hero.glyph
            color: hero.tint
            font.family: Theme.mono
            font.pixelSize: 19
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: hero.glyphClicked()
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 1

        Text {
            text: hero.title
            color: Theme.fgStrong
            font.family: Theme.mono
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            Layout.fillWidth: true
            text: hero.status
            elide: Text.ElideRight
            color: Theme.fgSoft
            font.family: Theme.mono
            font.pixelSize: 11
        }
    }

    Row {
        id: trail
        spacing: 8
    }
}
