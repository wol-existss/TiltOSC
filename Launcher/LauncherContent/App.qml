import QtQuick
import Launcher
Window {
    width: mainScreen.width
    height: mainScreen.height
    minimumWidth: mainScreen.width
    maximumWidth: mainScreen.width
    minimumHeight: mainScreen.height
    maximumHeight: mainScreen.height
    visible: true
    title: "TiltOSC Launcher"
    Screen01 {
        id: mainScreen
        anchors.centerIn: parent

        Component.onCompleted: {
            mainScreen.textInput.text = backendManager.receivePort.toString()
            mainScreen.onscreen_lstick.checked = backendManager.useDigitalLstick
            mainScreen.onscreen_rstick.checked = backendManager.useDigitalRstick
            mainScreen.invert_y_axis.checked = backendManager.invertYAxis
            mainScreen.enable_controller_input.checked = backendManager.controllerEnabled
            mainScreen.network_indicator.text = backendManager.localIp + ":" + backendManager.receivePort.toString() // The IP and port with a colon
        }
    }
    Connections {
        target: mainScreen.start_backend
        function onClicked() {
            backendManager.startBackend()
        }
    }
    Connections {
        target: mainScreen.kill_backend
        function onClicked() {
            console.log("Stop button clicked!")
            backendManager.stopBackend()
        }
    }
    Connections {
        target: mainScreen.save_settings
        function onClicked() {
            backendManager.saveSettings(
                parseInt(mainScreen.textInput.text),
                mainScreen.onscreen_lstick.checked,
                mainScreen.onscreen_rstick.checked,
                mainScreen.invert_y_axis.checked,
                mainScreen.enable_controller_input.checked
            )
        }
    }
}
