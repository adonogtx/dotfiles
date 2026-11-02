import QtQuick
import QtQuick.Layouts

// One line in a panel list: optional icon, label with an optional subtitle,
// and on the right a detail text, a check, a lock and signal bars
Rectangle {
    id: r

    property string glyph: ""
    property string label: ""
    property string subtitle: ""
    property string detail: ""
    property bool selected: false
    property bool locked: false
    property color detailColor: Theme.fgSoft
    property int signal: -1
    signal clicked

    Layout.fillWidth: true
    implicitHeight: subtitle !== "" ? 42 : 32
    radius: 6
    color: selected ? Theme.item : (area.containsMouse ? Theme.hover : "transparent")

    Text {
        id: icon
        visible: r.glyph !== ""
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: visible ? 18 : 0
        text: r.glyph
        color: r.selected ? Theme.fgStrong : Theme.fgSoft
        font.family: Theme.mono
        font.pixelSize: 14
    }

    Column {
        anchors.left: icon.visible ? icon.right : parent.left
        anchors.leftMargin: 10
        anchors.right: right.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1

        Text {
            width: parent.width
            text: r.label
            elide: Text.ElideRight
            color: r.selected ? Theme.fgStrong : Theme.fgSoft
            font.family: Theme.mono
            font.pixelSize: 13
        }

        Text {
            visible: r.subtitle !== ""
            width: parent.width
            text: r.subtitle
            elide: Text.ElideRight
            color: Theme.green
            font.family: Theme.mono
            font.pixelSize: 10
        }
    }

    Row {
        id: right
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Text {
            visible: r.detail !== ""
            anchors.verticalCenter: parent.verticalCenter
            text: r.detail
            color: r.detailColor
            font.family: Theme.mono
            font.pixelSize: 12
        }

        Text {
            visible: r.detail === "" && r.selected
            anchors.verticalCenter: parent.verticalCenter
            text: Theme.iCheck
            color: Theme.green
            font.family: Theme.mono
            font.pixelSize: 13
        }

        Text {
            visible: r.locked
            anchors.verticalCenter: parent.verticalCenter
            text: Theme.iLock
            color: Theme.fgFaint
            font.family: Theme.mono
            font.pixelSize: 12
        }

        SignalBars {
            visible: r.signal >= 0
            anchors.verticalCenter: parent.verticalCenter
            strength: Math.max(0, r.signal)
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: r.clicked()
    }
}
