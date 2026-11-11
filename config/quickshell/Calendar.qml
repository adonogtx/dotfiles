// Calendar, shown inside the open pill under the date. One month, header and weekday
// initials in Japanese (2026年11月, 日 月 火 水 木 金 土), today in a blue circle,
// arrows to move, a click on the month name returns to today. Weeks start on Sunday.
// Sizes from docs/pill-spec.md, Calendar: header 18, weekdays 11, days 13 in cells of 27,
// today in an accent circle of 27, grid gap 5.
import Quickshell
import QtQuick

Column {
    id: cal
    property var host
    spacing: 10

    SystemClock { id: clock; precision: SystemClock.Hours }

    property int offset: 0            // months away from the current one
    readonly property var today: clock.date
    readonly property var first: new Date(today.getFullYear(), today.getMonth() + offset, 1)
    readonly property int daysInMonth: new Date(first.getFullYear(), first.getMonth() + 1, 0).getDate()
    readonly property int lead: first.getDay()

    // 42 cells: the tail of last month, this month, the head of next month.
    readonly property var cells: {
        const out = []
        const prevDays = new Date(first.getFullYear(), first.getMonth(), 0).getDate()
        for (let i = 0; i < 42; i++) {
            const n = i - lead + 1
            if (n < 1) out.push({ day: prevDays + n, inMonth: false, isToday: false })
            else if (n > daysInMonth) out.push({ day: n - daysInMonth, inMonth: false, isToday: false })
            else out.push({
                day: n, inMonth: true,
                isToday: offset === 0 && n === today.getDate()
            })
        }
        // Drop the last row when the month fits in five weeks.
        return lead + daysInMonth <= 35 ? out.slice(0, 35) : out
    }

    Item {
        width: parent.width
        height: 26

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: cal.first.getFullYear() + "年" + (cal.first.getMonth() + 1) + "月"
            font.family: Theme.jp; font.pixelSize: 18; font.weight: Font.Medium
            color: Theme.label
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: cal.offset = 0 }
        }
        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            Repeater {
                model: [{ icon: "chevron-left", step: -1 }, { icon: "chevron-right", step: 1 }]
                Rectangle {
                    required property var modelData
                    width: 22; height: 22; radius: 6
                    color: arrowMouse.containsMouse ? Theme.wash : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.fast } }
                    Glyph { name: modelData.icon; width: 14; height: 14; color: Theme.secondary; anchors.centerIn: parent }
                    MouseArea { id: arrowMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: cal.offset += modelData.step }
                }
            }
        }
    }

    Grid {
        id: grid
        columns: 7
        columnSpacing: 5
        rowSpacing: 5
        width: parent.width
        readonly property real cell: (width - 6 * 5) / 7

        Repeater {
            model: ["日", "月", "火", "水", "木", "金", "土"]
            Text {
                required property var modelData
                width: grid.cell; height: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: modelData
                font.family: Theme.jp; font.pixelSize: 11; font.weight: Font.Medium
                color: Theme.secondary
            }
        }
        Repeater {
            model: cal.cells
            Item {
                required property var modelData
                width: grid.cell; height: 27
                Rectangle {
                    anchors.centerIn: parent
                    width: 27; height: 27; radius: 13.5
                    color: modelData.isToday ? Theme.accent : dayMouse.containsMouse ? Theme.wash : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.fast } }
                }
                MouseArea { id: dayMouse; anchors.fill: parent; hoverEnabled: true }
                Text {
                    anchors.centerIn: parent
                    text: modelData.day
                    font.family: Theme.sans; font.pixelSize: 13
                    font.weight: modelData.isToday ? Font.DemiBold : Font.Normal
                    color: modelData.isToday ? Theme.textOnAccent : modelData.inMonth ? Theme.label : Theme.tertiary
                    opacity: modelData.inMonth ? 1 : 0.6
                }
            }
        }
    }
}
