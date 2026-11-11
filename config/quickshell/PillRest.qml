// What the pill shows at rest, and on its top strip while open: the live items, only
// while true (recording, microphone, Awake, disk), a 1 px line 14 tall, then the date.
// The pill hugs this row, so it grows and shrinks as items come and go.
import QtQuick

Row {
    id: rest
    spacing: Theme.pillGap
    readonly property bool anyLive: record.active || mic.active || awake.active || disk.active

    RecordItem { id: record; anchors.verticalCenter: parent.verticalCenter }
    MicItem { id: mic; anchors.verticalCenter: parent.verticalCenter }
    AwakeItem { id: awake; anchors.verticalCenter: parent.verticalCenter }
    DiskItem { id: disk; anchors.verticalCenter: parent.verticalCenter }

    Rectangle {
        visible: rest.anyLive
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 14
        color: Theme.line
    }

    PillDate {
        anchors.verticalCenter: parent.verticalCenter
    }
}
