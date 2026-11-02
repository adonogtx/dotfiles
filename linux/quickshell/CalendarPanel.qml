pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

// Month grid, Monday first. Weekday kanji in the color of their element; Sundays and Brazilian national holidays red; today in yellow.
PanelFrame {
    id: p

    panelWidth: 300

    property var today: new Date()
    property int year: today.getFullYear()
    property int month: today.getMonth()

    onOpenChanged: {
        if (!open) return;
        today = new Date();
        year = today.getFullYear();
        month = today.getMonth();
    }

    function shift(delta) {
        const d = new Date(year, month + delta, 1);
        year = d.getFullYear();
        month = d.getMonth();
    }

    function key(d) {
        return (d.getMonth() + 1) + "-" + d.getDate();
    }

    // Easter Sunday (anonymous Gregorian algorithm), for the movable holidays
    function easter(y) {
        const a = y % 19, b = Math.floor(y / 100), c = y % 100;
        const d = Math.floor(b / 4), e = b % 4, f = Math.floor((b + 8) / 25);
        const g = Math.floor((b - f + 1) / 3), h = (19 * a + b - d - g + 15) % 30;
        const i = Math.floor(c / 4), k = c % 4, l = (32 + 2 * e + 2 * i - h - k) % 7;
        const m = Math.floor((a + 11 * h + 22 * l) / 451);
        const mo = Math.floor((h + l - 7 * m + 114) / 31) - 1;
        const da = ((h + l - 7 * m + 114) % 31) + 1;
        return new Date(y, mo, da);
    }

    readonly property var holidays: {
        const list = {
            "1-1": "New Year's Day",
            "4-21": "Tiradentes",
            "5-1": "Labour Day",
            "9-7": "Independence Day",
            "10-12": "Our Lady of Aparecida",
            "11-2": "All Souls' Day",
            "11-15": "Republic Day",
            "11-20": "Black Consciousness Day",
            "12-25": "Christmas"
        };
        const e = easter(year);
        const offset = (days) => new Date(e.getFullYear(), e.getMonth(), e.getDate() + days);
        list[key(offset(-47))] = "Carnival";
        list[key(offset(-2))] = "Good Friday";
        list[key(offset(60))] = "Corpus Christi";
        return list;
    }

    readonly property var cells: {
        const first = new Date(year, month, 1);
        const offset = (first.getDay() + 6) % 7;
        const list = [];
        for (let i = 0; i < 42; i++) {
            const d = new Date(year, month, 1 - offset + i);
            const inMonth = d.getMonth() === month;
            const holiday = inMonth && holidays[key(d)] !== undefined;
            const column = i % 7;
            list.push({
                day: d.getDate(),
                inMonth: inMonth,
                isToday: d.toDateString() === today.toDateString(),
                tint: !inMonth ? Theme.fgFaint
                    : (holiday || column === 6) ? Theme.sunday
                    : Theme.fg,
                holiday: holiday
            });
        }
        return list;
    }

    readonly property var monthHolidays: {
        const list = [];
        for (let d = 1; d <= 31; d++) {
            const date = new Date(year, month, d);
            if (date.getMonth() !== month) break;
            const name = holidays[key(date)];
            if (name) list.push({ day: d, name: name });
        }
        return list;
    }

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            textFormat: Text.StyledText
            text: p.year + "年 <font color='" + Theme.date + "'>" + (p.month + 1) + "月</font>"
            color: Theme.fgStrong
            font.family: Theme.mono
            font.pixelSize: 15
            font.bold: true
        }

        IconButton {
            glyph: "‹"
            tint: Theme.fgSoft
            onClicked: p.shift(-1)
        }

        IconButton {
            glyph: "›"
            tint: Theme.fgSoft
            onClicked: p.shift(1)
        }
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 7
        rowSpacing: 2
        columnSpacing: 0

        Repeater {
            model: ["月", "火", "水", "木", "金", "土", "日"]
            delegate: Text {
                required property string modelData
                required property int index
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                color: Theme.elements[(index + 1) % 7]
                font.family: Theme.mono
                font.pixelSize: 12
            }
        }

        Repeater {
            model: p.cells
            delegate: Item {
                id: cell
                required property var modelData
                Layout.fillWidth: true
                implicitHeight: 32

                Rectangle {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    radius: 13
                    color: Theme.yellow
                    visible: cell.modelData.isToday
                }

                Text {
                    anchors.centerIn: parent
                    text: cell.modelData.day
                    font.family: Theme.mono
                    font.pixelSize: 13
                    font.bold: cell.modelData.isToday
                    color: cell.modelData.isToday ? Theme.bg : cell.modelData.tint
                }

                // Small dot under holidays
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    width: 4
                    height: 4
                    radius: 2
                    color: Theme.sunday
                    visible: cell.modelData.holiday && !cell.modelData.isToday
                }
            }
        }
    }

    Separator {
        visible: p.monthHolidays.length > 0
    }

    Repeater {
        model: p.monthHolidays
        delegate: RowLayout {
            required property var modelData
            Layout.fillWidth: true
            spacing: 12

            Text {
                Layout.preferredWidth: 22
                horizontalAlignment: Text.AlignRight
                text: modelData.day
                color: Theme.sunday
                font.family: Theme.mono
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                Layout.fillWidth: true
                text: modelData.name
                color: Theme.fgSoft
                font.family: Theme.mono
                font.pixelSize: 12
            }
        }
    }
}
