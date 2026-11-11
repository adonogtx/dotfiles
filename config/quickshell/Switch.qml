// A switch (pill-spec.md, Switch): 35 x 21, tile off, accent on, a white knob of 16
// with a small shadow, 2.5 from the edge. The knob stretches a little while pressed.
// Adapted from Ricelin's LinkToggle (MIT, github.com/Gakuseei/Ricelin).
import QtQuick
import QtQuick.Effects

Rectangle {
    id: sw
    property bool on: false
    signal toggled()

    readonly property real knob: 16
    readonly property real inset: 2.5

    implicitWidth: 35
    implicitHeight: 21
    radius: height / 2
    color: on ? (area.containsMouse ? Qt.lighter(Theme.accent, 1.08) : Theme.accent)
              : (area.containsMouse ? Theme.line : Theme.tile)
    Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        height: sw.knob
        width: area.pressed ? sw.knob + 4 : sw.knob
        radius: height / 2
        color: Theme.textOnAccent
        x: sw.on ? sw.width - width - sw.inset : sw.inset
        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: Theme.knobShadow
            shadowBlur: 0.5
            blurMax: 6
            shadowVerticalOffset: 1
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sw.toggled()
    }
}
