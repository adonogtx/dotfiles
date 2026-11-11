// 11月11日(水)  11:35: the date in label, the time in secondary, lightly tracked.
import Quickshell
import QtQuick

Text {
    readonly property var weekdays: ["日", "月", "火", "水", "木", "金", "土"]

    SystemClock { id: clock; precision: SystemClock.Minutes }

    textFormat: Text.StyledText
    text: (clock.date.getMonth() + 1) + "月" + clock.date.getDate() + "日("
          + weekdays[clock.date.getDay()] + ")&nbsp;&nbsp;<font color=\"" + Theme.secondary + "\">"
          + Qt.formatTime(clock.date, "HH:mm") + "</font>"
    font.family: Theme.jp
    font.pixelSize: Theme.pillText
    font.weight: Font.Medium
    font.letterSpacing: 0.8
    color: Theme.label
}
