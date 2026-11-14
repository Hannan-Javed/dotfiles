import QtQuick
import QtQuick.Controls
import Quickshell

Window {
    id: root

    visible: true
    title: "qs-greeter"
    flags: Qt.Window | Qt.FramelessWindowHint
    Component.onCompleted: {
        showMaximized();
        loginManager.username = LoginState.lastSelectedUser;
        loginManager.selectedSession = LoginState.lastSelectedSession;
        passwordField.forceActiveFocus();
    }

    LoginManager {
        id: loginManager
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    Rectangle {
        id: loginCard

        width: 500
        height: 70
        anchors.centerIn: parent
        color: "#000000"
        radius: 6
        border.width: 1
        border.color: "#604a7fc1"

        TextField {
            id: passwordField

            anchors.fill: parent
            anchors.margins: 12
            color: "#b0b0b0"
            selectionColor: "#3b82f6"
            selectedTextColor: "#ffffff"
            echoMode: TextInput.Password
            placeholderText: ""
            focus: true
            font.pixelSize: 18
            onTextChanged: {
                loginManager.password = text;
            }
            onAccepted: {
                loginManager.startLogin();
            }

            background: Item {
            }

        }

    }

    Text {
        visible: loginManager.errorMessage.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: loginCard.bottom
        anchors.topMargin: 24
        color: "#ff5555"
        font.pixelSize: 16
        text: loginManager.errorMessage
    }

}
