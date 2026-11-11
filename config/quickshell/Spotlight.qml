// Spotlight: search the installed apps, arrows to move, Enter to open, Escape to close.
// Opens from the search icon, Super + Space, or: quickshell ipc call spotlight toggle
// Nothing is listed until you type.
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: spot
    property bool open: false
    property int selected: 0

    // Stays mapped while it fades out.
    property bool shown: false
    onOpenChanged: {
        if (open) { closing.stop(); shown = true; field.text = ""; field.forceActiveFocus() }
        else closing.restart()
    }
    Timer { id: closing; interval: 160; onTriggered: spot.shown = false }

    visible: shown
    color: "transparent"
    anchors { top: true }
    // A quarter of the way down the screen.
    margins { top: -4 + Math.round((spot.screen ? spot.screen.height : (Quickshell.screens[0] ? Quickshell.screens[0].height : 864)) * 0.25) }
    exclusiveZone: 0
    implicitWidth: 560 + Theme.shadowPad * 2
    implicitHeight: body.height + Theme.shadowPad + 4
    mask: Region { item: body }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "spotlight"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    IpcHandler {
        target: "spotlight"
        function toggle(): void { spot.open = !spot.open }
        function show(): void { spot.open = true }
        function hide(): void { spot.open = false }
    }

    HyprlandFocusGrab {
        active: spot.open
        windows: [spot]
        onCleared: spot.open = false
    }

    // Ranking: name starts with the query, then a word in the name does,
    // then the name contains it, then the description or keywords do.
    readonly property var results: {
        const q = field.text.trim().toLowerCase()
        if (q === "") return []
        const scored = []
        for (const app of DesktopEntries.applications.values) {
            if (app.noDisplay) continue
            const name = (app.name || "").toLowerCase()
            const extra = ((app.genericName || "") + " " + (app.comment || "") + " " + Array.from(app.keywords || []).join(" ")).toLowerCase()
            let score = 0
            if (name.startsWith(q)) score = 4
            else if (name.split(/[\s\-_.]+/).some(w => w.startsWith(q))) score = 3
            else if (name.includes(q)) score = 2
            else if (extra.includes(q)) score = 1
            if (score > 0) scored.push({ app: app, score: score })
        }
        scored.sort((a, b) => (b.score - a.score) || a.app.name.localeCompare(b.app.name))
        return scored.slice(0, 7).map(s => s.app)
    }
    onResultsChanged: selected = 0

    function launch(app) {
        if (!app) return
        app.execute()
        spot.open = false
    }

    readonly property int rowHeight: 36

    Rectangle {
        id: body
        x: Theme.shadowPad
        y: 4
        width: 560
        height: column.height + 24
        radius: Theme.radiusPanel
        border.width: 1
        border.color: Theme.rim
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.panelTop }
            GradientStop { position: 1.0; color: Theme.panelBottom }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: 0.5
            shadowBlur: 1.0
            blurMax: 32
            shadowVerticalOffset: 10
        }

        opacity: spot.open ? 1 : 0
        scale: spot.open ? 1 : 0.97
        Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        Behavior on scale {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        Behavior on height {
            NumberAnimation { duration: 220; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        clip: true

        Rectangle {
            x: Theme.radiusPanel; y: 1
            width: parent.width - Theme.radiusPanel * 2
            height: 1
            color: Theme.sheen
        }

        Column {
            id: column
            x: 18
            y: 12
            width: parent.width - 36
            spacing: 6

            Item {
                width: parent.width
                height: 34

                Glyph {
                    id: lens
                    name: "search"
                    width: 17; height: 17
                    color: Theme.secondary
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextInput {
                    id: field
                    anchors.left: lens.right
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: Theme.sans
                    font.pixelSize: 18
                    font.weight: Font.Light
                    font.letterSpacing: 0.3
                    color: Theme.label
                    selectionColor: Theme.accent
                    clip: true

                    Keys.onEscapePressed: spot.open = false
                    Keys.onDownPressed: spot.selected = Math.min(spot.selected + 1, spot.results.length - 1)
                    Keys.onUpPressed: spot.selected = Math.max(spot.selected - 1, 0)
                    Keys.onTabPressed: spot.selected = (spot.selected + 1) % Math.max(1, spot.results.length)
                    onAccepted: spot.launch(spot.results[spot.selected])

                    Text {
                        visible: field.text.length === 0
                        text: "Spotlight Search"
                        font: field.font
                        color: Theme.tertiary
                    }
                }
            }

            Hairline { visible: spot.results.length > 0 }

            Item {
                visible: spot.results.length > 0
                width: parent.width
                height: spot.results.length * spot.rowHeight

                // One highlight that glides between results instead of jumping.
                Rectangle {
                    width: parent.width
                    height: spot.rowHeight
                    radius: 8
                    color: Theme.accent
                    y: spot.selected * spot.rowHeight
                    Behavior on y { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                }

                Column {
                    width: parent.width

                    Repeater {
                        model: spot.results

                        Item {
                            id: hit
                            required property var modelData
                            required property int index
                            readonly property bool chosen: index === spot.selected
                            width: parent.width
                            height: spot.rowHeight

                            IconImage {
                                id: appIcon
                                x: 10
                                anchors.verticalCenter: parent.verticalCenter
                                implicitSize: 22
                                source: Quickshell.iconPath(hit.modelData.icon, "application-x-executable")
                            }
                            Text {
                                anchors.left: appIcon.right
                                anchors.leftMargin: 12
                                anchors.right: kind.left
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                text: hit.modelData.name
                                elide: Text.ElideRight
                                font.family: Theme.sans
                                font.pixelSize: Theme.body
                                color: Theme.label
                            }
                            Text {
                                id: kind
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                text: hit.modelData.genericName || ""
                                font.family: Theme.sans
                                font.pixelSize: 11
                                color: hit.chosen ? Qt.rgba(1, 1, 1, 0.75) : Theme.tertiary
                                Behavior on color { ColorAnimation { duration: 160 } }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: spot.selected = hit.index
                                onClicked: spot.launch(hit.modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
