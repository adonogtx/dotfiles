// Launcher: search the installed apps, arrows to move, Enter to open, Escape to close.
// Opens from Super + Space, or: quickshell ipc call launcher toggle
// Nothing is listed until you type.
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: launcher
    property bool open: false
    property int selected: 0

    // Stays mapped while it fades out.
    property bool shown: false
    onOpenChanged: {
        if (open) { closing.stop(); shown = true; field.text = ""; field.forceActiveFocus() }
        else closing.restart()
    }
    Timer { id: closing; interval: 160; onTriggered: launcher.shown = false }

    readonly property int rowHeight: 42
    readonly property int maxResults: 7
    readonly property int fieldHeight: 34

    visible: shown
    color: "transparent"
    anchors { top: true }
    // A third of the way down the screen.
    margins { top: -4 + Math.round((launcher.screen ? launcher.screen.height : (Quickshell.screens[0] ? Quickshell.screens[0].height : 864)) / 3) }
    exclusiveZone: 0
    implicitWidth: 560 + Theme.shadowPad * 2
    // Fixed at the tallest the list can be, so the window never resizes while it animates.
    // The mask keeps the empty part click-through.
    implicitHeight: 12 + fieldHeight + 13 + maxResults * rowHeight + 12 + Theme.shadowPad + 4
    mask: Region { item: body }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "launcher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    IpcHandler {
        target: "launcher"
        function toggle(): void { launcher.open = !launcher.open }
        function show(): void { launcher.open = true }
        function hide(): void { launcher.open = false }
    }

    HyprlandFocusGrab {
        active: launcher.open
        windows: [launcher]
        onCleared: launcher.open = false
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
        return scored.slice(0, launcher.maxResults).map(s => s.app)
    }
    onResultsChanged: selected = 0

    function launch(app) {
        if (!app) return
        app.execute()
        launcher.open = false
    }

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
            shadowOpacity: Theme.shadowOpacity
            shadowBlur: 1.0
            blurMax: 32
            shadowVerticalOffset: 10
        }

        opacity: launcher.open ? 1 : 0
        scale: launcher.open ? 1 : 0.97
        Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        Behavior on scale {
            NumberAnimation { duration: Theme.glide; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        Behavior on height {
            NumberAnimation { duration: 220; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.settle }
        }
        clip: true

        Column {
            id: column
            x: 18
            y: 12
            width: parent.width - 36
            spacing: 6

            Item {
                width: parent.width
                height: launcher.fieldHeight

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

                    Keys.onEscapePressed: launcher.open = false
                    Keys.onDownPressed: launcher.selected = Math.min(launcher.selected + 1, launcher.results.length - 1)
                    Keys.onUpPressed: launcher.selected = Math.max(launcher.selected - 1, 0)
                    Keys.onTabPressed: launcher.selected = (launcher.selected + 1) % Math.max(1, launcher.results.length)
                    onAccepted: launcher.launch(launcher.results[launcher.selected])

                    Text {
                        visible: field.text.length === 0
                        text: "Search"
                        font: field.font
                        color: Theme.tertiary
                    }
                }
            }

            Hairline { visible: launcher.results.length > 0 }

            Item {
                visible: launcher.results.length > 0
                width: parent.width
                height: launcher.results.length * launcher.rowHeight

                // One highlight that glides between results instead of jumping.
                Rectangle {
                    width: parent.width
                    height: launcher.rowHeight
                    radius: 8
                    color: Theme.accent
                    y: launcher.selected * launcher.rowHeight
                    Behavior on y { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                }

                Column {
                    width: parent.width

                    Repeater {
                        model: launcher.results

                        Item {
                            id: hit
                            required property var modelData
                            required property int index
                            readonly property bool chosen: index === launcher.selected
                            width: parent.width
                            height: launcher.rowHeight

                            IconImage {
                                id: appIcon
                                x: 10
                                anchors.verticalCenter: parent.verticalCenter
                                implicitSize: 28
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
                                color: hit.chosen ? Theme.onAccent : Theme.label
                            }
                            Text {
                                id: kind
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                text: hit.modelData.genericName || ""
                                font.family: Theme.sans
                                font.pixelSize: 11
                                color: hit.chosen ? Qt.rgba(Theme.onAccent.r, Theme.onAccent.g, Theme.onAccent.b, 0.75) : Theme.tertiary
                                Behavior on color { ColorAnimation { duration: 160 } }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: launcher.selected = hit.index
                                onClicked: launcher.launch(hit.modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
