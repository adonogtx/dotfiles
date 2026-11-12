// Battery (desktop.md, Bar; pill-spec.md, Rest): red icon and percentage while the
// charge is below 20% and not charging. Also sends the warnings (apps.md, Notifications):
// 20% normal, 10% urgent, each once per discharge; plugging in resets them.
// Every pill has one of these; only the pill on the first screen sends the warnings.
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

LiveItem {
    id: battery
    readonly property var dev: UPower.displayDevice
    // Until UPower has read the battery it reports 0% in an unknown state; wait for it.
    readonly property bool present: dev !== null && dev.ready && dev.isPresent
                                    && dev.state !== UPowerDeviceState.Unknown
    readonly property int percent: {
        if (!present) return 100
        const p = dev.percentage
        return Math.round(p > 1 ? p : p * 100)
    }
    readonly property bool charging: present && dev.state === UPowerDeviceState.Charging
    readonly property bool notifies: QsWindow.window !== null && Quickshell.screens.length > 0
                                     && QsWindow.window.screen === Quickshell.screens[0]
    property int warned: 100            // lowest level already warned in this discharge

    active: present && !charging && percent < 20
    icon: "battery"
    text: percent + "%"
    ink: Theme.red

    function check() {
        if (!present || charging || percent > 20) { warned = 100; return }
        if (!notifies) return
        if (percent <= 10 && warned > 10) {
            warned = 10
            send.command = ["notify-send", "-a", "Battery", "-u", "critical",
                            "Battery at " + percent + "%", "Plug in the charger."]
            send.running = true
        } else if (percent <= 20 && warned > 20) {
            warned = 20
            send.command = ["notify-send", "-a", "Battery", "-u", "normal",
                            "Battery at " + percent + "%", "About to run low."]
            send.running = true
        }
    }
    onPercentChanged: check()
    onChargingChanged: check()
    onNotifiesChanged: check()
    Component.onCompleted: check()

    Process { id: send }
}
