import QtQuick
import Launcher
Window {
    width: mainScreen.width
    height: mainScreen.height
    visible: true
    title: "Launcher"
    Screen01 {
        id: mainScreen
        anchors.centerIn: parent
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
            backendManager.stopBackend()
        }
    }
}
