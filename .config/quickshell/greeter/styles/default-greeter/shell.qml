import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "components"

Window {
    id: root

    property var users: []
    property var sessions: []

    visible: true
    title: "qs-greeter"
    flags: Qt.Window | Qt.FramelessWindowHint
    Component.onCompleted: {
        showMaximized();
        try {
            users = JSON.parse(usersFile.text()).users || [];
        } catch (e) {
            console.warn("Failed loading users.json:", e);
        }
        try {
            sessions = JSON.parse(sessionsFile.text()).sessions || [];
        } catch (e) {
            console.warn("Failed loading sessions.json:", e);
        }
        loginManager.username = LoginState.lastSelectedUser;
        loginManager.selectedSession = LoginState.lastSelectedSession;
    }

    // to make password field the focus automatically on window render
    Timer {
        interval: 0
        running: true
        repeat: false
        onTriggered: {
            passwordField.forceActiveFocus();
        }
    }

    FileView {
        id: usersFile

        path: "/var/cache/qs-greeter/users.json"
        blockLoading: true
    }

    FileView {
        id: sessionsFile

        path: "/var/cache/qs-greeter/sessions.json"
        blockLoading: true
    }

    LoginManager {
        id: loginManager
    }

    Image {
        id: wallpaper

        anchors.fill: parent
        source: "./wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    FastBlur {
        anchors.fill: wallpaper
        source: wallpaper
        radius: 18
    }

    Rectangle {
        anchors.fill: parent
        color: "#55000000"
    }

    ClockWidget {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 70
        }

    }

    Rectangle {
        id: loginCard

        width: 460
        implicitHeight: contentColumn.implicitHeight + 48
        anchors.centerIn: parent
        radius: 24
        color: "#80111111"
        border.width: 1
        border.color: "#25ffffff"

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: "#08ffffff"
        }

        Column {
            id: contentColumn

            anchors.fill: parent
            anchors.margins: 24
            spacing: 14

            Text {
                text: "Welcome"
                color: "white"
                font.pixelSize: 28
                font.bold: true
            }

            Text {
                text: "Sign in to continue"
                color: "#c0c0c0"
                font.pixelSize: 14
            }

            ComboBox {
                id: userBox

                width: parent.width
                height: 44
                model: users.map((user) => {
                    return user.username;
                })

                contentItem: Text {
                    text: userBox.displayText
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 14
                    font.pixelSize: 14
                    elide: Text.ElideRight
                }

                indicator: Text {
                    text: "⌄"
                    color: "white"
                    font.pixelSize: 16

                    anchors {
                        right: parent.right
                        rightMargin: 14
                        verticalCenter: parent.verticalCenter
                    }

                }

                background: Rectangle {
                    radius: 12
                    color: "#22ffffff"
                    border.width: 1
                    border.color: userBox.activeFocus ? "#70a5f3ff" : "#20ffffff"
                }

                popup: Popup {
                    y: userBox.height + 4
                    width: userBox.width
                    padding: 6

                    background: Rectangle {
                        radius: 12
                        color: "#dd1a1a1a"
                        border.color: "#30ffffff"
                    }

                    contentItem: ListView {
                        clip: true
                        model: userBox.popup.visible ? userBox.delegateModel : null
                    }

                }

            }

            ComboBox {
                id: sessionsBox

                width: parent.width
                height: 44
                model: sessions.map((session) => {
                    return session.name;
                })

                contentItem: Text {
                    text: sessionsBox.displayText
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 14
                    font.pixelSize: 14
                    elide: Text.ElideRight
                }

                indicator: Text {
                    text: "⌄"
                    color: "white"
                    font.pixelSize: 16

                    anchors {
                        right: parent.right
                        rightMargin: 14
                        verticalCenter: parent.verticalCenter
                    }

                }

                background: Rectangle {
                    radius: 12
                    color: "#22ffffff"
                    border.width: 1
                    border.color: sessionsBox.activeFocus ? "#70a5f3ff" : "#20ffffff"
                }

                popup: Popup {
                    y: sessionsBox.height + 4
                    width: sessionsBox.width
                    padding: 6

                    background: Rectangle {
                        radius: 12
                        color: "#dd1a1a1a"
                        border.color: "#30ffffff"
                    }

                    contentItem: ListView {
                        clip: true
                        model: sessionsBox.popup.visible ? sessionsBox.delegateModel : null
                    }

                }

            }

            TextField {
                id: passwordField

                width: parent.width
                height: 44
                color: "white"
                echoMode: TextInput.Password
                placeholderText: "Password"
                selectByMouse: true
                onTextChanged: {
                    loginManager.password = text;
                }
                onAccepted: {
                    loginManager.startLogin();
                }
                placeholderTextColor: "#99ffffff"

                background: Rectangle {
                    radius: 12
                    color: "#22ffffff"
                    border.width: 1
                    border.color: passwordField.activeFocus ? "#70a5f3ff" : "#20ffffff"
                }

            }

            Button {
                width: parent.width
                height: 44
                text: loginManager.authenticating ? "Authenticating..." : "Log In"
                enabled: !loginManager.authenticating
                onClicked: {
                    loginManager.startLogin();
                }

                background: Rectangle {
                    radius: 12
                    color: loginManager.authenticating ? "#555555" : "#6b7cff"
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

            Text {
                visible: loginManager.errorMessage.length > 0
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#ff6b6b"
                text: loginManager.errorMessage
            }

        }

    }

}
