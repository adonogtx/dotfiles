// A segmented control (pill-spec.md): tile track, rounding 8, padding 2, gap 2, cells of 26.
// The chosen cell is white with a small shadow and glides between cells.
// options: [{ label, icon, value, size, disabled }]
import QtQuick
import QtQuick.Effects

Rectangle {
    id: seg
    property var options: []
    property var current
    signal picked(var value)

    readonly property int count: Math.max(1, options.length)
    readonly property int index: Math.max(0, options.findIndex(o => o.value === current))
    readonly property real cell: (width - 4 - 2 * (count - 1)) / count

    implicitHeight: 30
    radius: 8
    color: Theme.tile

    Rectangle {
        visible: seg.options.findIndex(o => o.value === seg.current) >= 0
        x: 2 + seg.index * (seg.cell + 2)
        y: 2
        width: seg.cell
        height: 26
        radius: 6
        color: Theme.panel
        Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle } }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: Theme.segmentShadow
            shadowBlur: 0.5
            blurMax: 6
            shadowVerticalOffset: 1
        }
    }

    Row {
        x: 2; y: 2
        spacing: 2
        Repeater {
            model: seg.options
            Item {
                required property var modelData
                readonly property bool chosen: modelData.value === seg.current
                readonly property bool usable: !modelData.disabled
                width: seg.cell
                height: 26

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
                        font.pixelSize: modelData.size || 12
                        color: !usable ? Theme.tertiary : chosen ? Theme.label : Theme.secondary
                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: usable
                    cursorShape: Qt.PointingHandCursor
                    onClicked: seg.picked(modelData.value)
                }
            }
        }
    }
}
