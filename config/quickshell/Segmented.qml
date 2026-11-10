// A macOS segmented control. options: [{ label, icon, value }]; the chosen one sits on a
// lighter pill that glides between segments.
import QtQuick

Rectangle {
    id: seg
    property var options: []
    property var current
    signal picked(var value)

    readonly property int count: Math.max(1, options.length)
    readonly property int index: Math.max(0, options.findIndex(o => o.value === current))
    readonly property real cell: (width - 4) / count

    implicitHeight: 30
    radius: 8
    color: Theme.panelBottom
    border.width: 1
    border.color: Theme.edgeSoft

    Rectangle {
        visible: seg.options.findIndex(o => o.value === seg.current) >= 0
        x: 2 + seg.index * seg.cell
        y: 2
        width: seg.cell
        height: parent.height - 4
        radius: 6
        color: Theme.line
        Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle } }
    }

    Row {
        x: 2; y: 2
        Repeater {
            model: seg.options
            Item {
                required property var modelData
                readonly property bool chosen: modelData.value === seg.current
                width: seg.cell
                height: seg.height - 4

                Row {
                    anchors.centerIn: parent
                    spacing: 5
                    width: Math.min(implicitWidth, parent.width - 8)
                    Glyph {
                        visible: (modelData.icon || "") !== ""
                        name: modelData.icon || ""
                        width: 12; height: 12
                        color: chosen ? Theme.label : Theme.secondary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.min(implicitWidth, seg.cell - 30)
                        text: modelData.label
                        elide: Text.ElideRight
                        font.family: Theme.sans
                        font.pixelSize: modelData.size || 11
                        color: chosen ? Theme.label : Theme.secondary
                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: seg.picked(modelData.value)
                }
            }
        }
    }
}
