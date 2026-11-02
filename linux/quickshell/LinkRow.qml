import QtQuick
import QtQuick.Layouts

Text {
    id: l
    signal clicked

    Layout.fillWidth: true
    color: area.containsMouse ? Theme.fgStrong : Theme.fgSoft
    font.family: Theme.mono
    font.pixelSize: 12

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: l.clicked()
    }
}
