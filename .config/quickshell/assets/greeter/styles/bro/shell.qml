import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import "components"

Window {
    id: root

    visible: true

    title: "qs-greeter"

    flags: Qt.Window | Qt.FramelessWindowHint

    Component.onCompleted: showMaximized()

    LoginManager {
        id: loginManager
    }

    Image {
        id: wallpaper

        anchors.fill: parent

        source: "/var/cache/qs-greeter/wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    FastBlur {
        anchors.fill: wallpaper

        source: wallpaper
        radius: 32
    }

    Rectangle {
        anchors.fill: parent

        color: "#80000000"
    }

    ClockWidget {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 80
        }
    }

    Rectangle {
        id: loginCard

        width: 420
        height: 320

        radius: 18

        color: "#dd111111"

        border.color: "#30ffffff"

        anchors.centerIn: parent

        Column {
            anchors.fill: parent
            anchors.margins: 24

            spacing: 12

            ComboBox {
                id: userBox

                width: parent.width

                model: [
                    "hannan"
                ]

                onCurrentTextChanged: {
                    loginManager.username = currentText
                }
            }

            ComboBox {
                id: sessionBox

                width: parent.width

                model: [
                    "niri-session"
                ]

                onCurrentTextChanged: {
                    loginManager.selectedSession = currentText
                }
            }

            TextField {
                id: passwordField

                width: parent.width

                echoMode: TextInput.Password

                placeholderText: "Password"

                onTextChanged: {
                    loginManager.password = text
                }

                onAccepted: {
                    loginManager.startLogin()
                }
            }

            Button {
                width: parent.width

                text: loginManager.authenticating
                    ? "Authenticating..."
                    : "Login"

                onClicked: loginManager.startLogin()
            }

            Text {
                width: parent.width

                visible: loginManager.errorMessage.length > 0

                color: "#ff6b6b"

                wrapMode: Text.WordWrap

                text: loginManager.errorMessage
            }
        }
    }
}