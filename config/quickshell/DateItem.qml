// 11月9日(月)  20:40, the date in full ink and the time in grey, lightly tracked.
import Quickshell
import QtQuick

BarItem {
    id: date
    readonly property var weekdays: ["日", "月", "火", "水", "木", "金", "土"]

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        textFormat: Text.StyledText
        text: (clock.date.getMonth() + 1) + "月" + clock.date.getDate() + "日("
              + date.weekdays[clock.date.getDay()] + ")&nbsp;&nbsp;<font color=\"" + Theme.secondary + "\">"
              + Qt.formatTime(clock.date, "HH:mm") + "</font>"
        font.family: Theme.jp
        font.pixelSize: Theme.body
        font.weight: Font.Medium
        font.letterSpacing: 0.8
        color: Theme.label
    }
}
