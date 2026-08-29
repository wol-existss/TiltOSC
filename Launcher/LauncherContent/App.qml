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

}

