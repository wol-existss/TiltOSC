import QtQuick
import QtQuick.Controls
import Launcher
import QtQuick.Studio.DesignEffects
import QtQuick.Studio.Components



Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    color: "#2b3545"
    radius: 0
    bottomRightRadius: 0
    bottomLeftRadius: 0

    Text {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: 347
        height: 37
        color: "#ffffff"
        text: qsTr("TiltOSC Launcher")
        font.pixelSize: 35
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenterOffset: 1
        font.family: "Space Mono"
        DesignEffect {
            effects: [
                DesignDropShadow {
                }
            ]
        }
    }

    ScrollView {
        id: scrollView
        x: 8
        y: 43
        width: 624
        height: 429
        data: [
            DesignEffect {
                effects: [
                    DesignDropShadow {
                    }
                ]
            }
        ]
        font.kerning: true
        antialiasing: false
        focus: false
        focusPolicy: Qt.StrongFocus

        Column {
            id: column
            x: 0
            y: 0
            anchors.top: title.bottom
            anchors.topMargin: 20
            anchors.horizontalCenterOffset: 79
            anchors.horizontalCenter: parent.horizontalCenter
            width: 624
            height: 435
            spacing: 10


            Text {
                id: joystick_options
                anchors.horizontalCenter: parent.horizontalCenter
                width: 246
                height: 37
                color: "#ffffff"
                text: qsTr("Joystick options")
                font.pixelSize: 25
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                font.family: "Space Mono"
                DesignEffect {
                    effects: [
                        DesignInnerShadow {}
                    ]
                }
            }

            RoundButton {
                id: onscreen_lstick
                anchors.horizontalCenter: parent.horizontalCenter
                width: 466
                height: 37
                radius: 9
                text: "Use onscreen left joystick (Overwrites tilt input)"
                icon.color: "#171d26"
                font.family: "Space Mono"
                antialiasing: true
                checkable: true

                background: Rectangle {
                    radius: onscreen_lstick.radius
                    color: onscreen_lstick.checked ? "#4e8de7" : "#171d26"
                }
            }

            RoundButton {
                id: onscreen_rstick
                width: 270
                height: 37
                radius: 9
                text: "Use onscreen right joystick"
                icon.color: "#171d26"
                font.family: "Space Mono"
                checkable: true
                background: Rectangle {
                    color: onscreen_rstick.checked ? "#4e8de7" : "#171d26"
                    radius: onscreen_rstick.radius
                }
                antialiasing: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RoundButton {
                id: invert_y_axis
                width: 139
                height: 37
                radius: 9
                text: "Invert Y axis"
                icon.color: "#171d26"
                font.family: "Space Mono"
                checkable: true
                background: Rectangle {
                    color: invert_y_axis.checked ? "#4e8de7" : "#171d26"
                    radius: invert_y_axis.radius
                }
                antialiasing: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: misc
                width: 324
                height: 37
                color: "#ffffff"
                text: qsTr("Miscellaneous Options")
                font.pixelSize: 25
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                font.family: "Space Mono"
                DesignEffect {
                    effects: [
                        DesignInnerShadow {}
                    ]
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: networking
                anchors.horizontalCenter: parent.horizontalCenter
                width: 424
                height: 40
                spacing: 16

                Text {
                    id: text2
                    anchors.verticalCenter: parent.verticalCenter
                    width: 211
                    height: 37
                    color: "#ffffff"
                    text: qsTr("Recieving Port")
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Space Mono"
                    DesignEffect {
                        effects: [
                            DesignInnerShadow {}
                        ]
                    }
                }

                Rectangle {
                    id: rectangle1
                    anchors.verticalCenter: parent.verticalCenter
                    width: 184
                    height: 37
                    color: "#171d26"
                    radius: 9

                    TextInput {
                        id: textInput
                        anchors.fill: parent
                        color: "#ffffff"
                        text: qsTr("4646")
                        font.pixelSize: 25
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Space Mono"
                    }
                }
            }

            RoundButton {
                id: enable_controller_input
                width: 239
                height: 37
                radius: 9
                text: "Enable Controller Input"
                checked: true
                autoExclusive: false
                icon.color: "#171d26"
                font.family: "Space Mono"
                checkable: true
                background: Rectangle {
                    color: enable_controller_input.checked ? "#4e8de7" : "#171d26"
                    radius: enable_controller_input.radius
                }
                antialiasing: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: backend_status
                color: "#ffffff"
                text: qsTr("TiltOSC backend status: Online")
                font.pixelSize: 25
                font.family: "Space Mono"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RoundButton {
                id: save_settings
                width: 140
                height: 37
                radius: 9
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Save settings"
                icon.color: "#171d26"
                font.family: "Space Mono"
                checkable: false
                background: Rectangle {
                    color: save_settings.checked ? "#4e8de7" : "#171d26"
                    radius: save_settings.radius
                }
                antialiasing: true
            }

            RoundButton {
                id: start_backend
                width: 140
                height: 37
                radius: 9
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Start TiltOSC"
                icon.color: "#171d26"
                font.family: "Space Mono"
                checkable: false
                background: Rectangle {
                    color: start_backend.checked ? "#4e8de7" : "#171d26"
                    radius: start_backend.radius
                }
                antialiasing: true
            }

            RoundButton {
                id: kill_backend
                width: 140
                height: 37
                radius: 9
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Stop TiltOSC"
                icon.color: "#171d26"
                font.family: "Space Mono"
                checkable: false
                background: Rectangle {
                    color: kill_backend.checked ? "#4e8de7" : "#171d26"
                    radius: kill_backend.radius
                }
                antialiasing: true
            }
        }
    }
}
