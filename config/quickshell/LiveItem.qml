// One live item in the pill (desktop.md, Bar; pill-spec.md, Rest): shown only while
// `active`, left of the date. An optional red dot (recording), an optional 16 px icon,
// then optional text at 13.
// Clicks fall through to the pill (Control Center) unless `clickable` is set.
import QtQuick

Item {
    id: live
    property bool active: false
    property string icon
    property string text
    property color ink: Theme.label
    property bool clickable: false
    property bool dot: false
    signal clicked()

    visible: active
    implicitWidth: row.implicitWidth
    implicitHeight: 16

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Rectangle {
            visible: live.dot
            anchors.verticalCenter: parent.verticalCenter
            width: 8; height: 8; radius: 4
            color: Theme.red
        }
        Glyph {
            visible: live.icon !== ""
            anchors.verticalCenter: parent.verticalCenter
            name: live.icon
            width: 16; height: 16
            color: live.ink
        }
        Text {
            visible: live.text !== ""
            anchors.verticalCenter: parent.verticalCenter
            text: live.text
            font.family: Theme.sans
            font.pixelSize: 13
            font.features: { "tnum": 1 }      // figures keep their width as the time runs
            color: live.ink
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: -6
        enabled: live.clickable
        cursorShape: Qt.PointingHandCursor
        onClicked: live.clicked()
    }
}
