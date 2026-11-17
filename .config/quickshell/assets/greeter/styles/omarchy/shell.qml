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

            property string prevText: ""

            // Diff previous and current text to insert/remove at the exact cursor index
            function syncDots(oldStr, newStr) {
                let prefix = 0;
                const minLen = Math.min(oldStr.length, newStr.length);
                while (prefix < minLen && oldStr[prefix] === newStr[prefix])
                    prefix++;

                let oldSuffix = oldStr.length - 1;
                let newSuffix = newStr.length - 1;
                while (oldSuffix >= prefix && newSuffix >= prefix && oldStr[oldSuffix] === newStr[newSuffix]) {
                    oldSuffix--;
                    newSuffix--;
                }
                const removedCount = oldSuffix - prefix + 1;
                const addedCount = newSuffix - prefix + 1;
                // Map string index to active (non-removing) index in dotModel
                let activeIdx = 0;
                let modelIdx = 0;
                while (modelIdx < dotModel.count && activeIdx < prefix) {
                    if (!dotModel.get(modelIdx).removing)
                        activeIdx++;

                    modelIdx++;
                }
                // Mark deleted characters at the exact spot so they fade out in place
                let marked = 0;
                let scanIdx = modelIdx;
                while (scanIdx < dotModel.count && marked < removedCount) {
                    if (!dotModel.get(scanIdx).removing) {
                        dotModel.setProperty(scanIdx, "removing", true);
                        marked++;
                    }
                    scanIdx++;
                }
                // Insert newly typed characters at the exact spot
                for (let i = 0; i < addedCount; i++) {
                    dotModel.insert(scanIdx + i, {
                        "removing": false
                    });
                }
            }

            anchors.fill: parent
            anchors.margins: 12
            color: "transparent"
            cursorVisible: false
            selectionColor: "transparent"
            selectedTextColor: "transparent"
            echoMode: TextInput.Password
            placeholderText: ""
            focus: true
            font.pixelSize: 18
            onTextChanged: {
                loginManager.password = text;
                syncDots(prevText, text);
                prevText = text;
            }
            onAccepted: {
                loginManager.startLogin();
            }

            ListModel {
                id: dotModel
            }

            // Placeholder that fades out when typing
            Text {
                anchors.fill: parent
                leftPadding: passwordField.leftPadding
                verticalAlignment: Text.AlignVCenter
                text: "Password"
                color: "#505050"
                font.pixelSize: 18
                opacity: passwordField.text.length === 0 ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }

                }

            }

            // Clipped viewport so dots never overflow outside the card
            Flickable {
                id: dotViewport

                // Keep the scroll position aligned with the active cursor position
                function updateScroll() {
                    const step = 18; // dot width (10) + spacing (8)
                    const cursorX = passwordField.cursorPosition * step;
                    const maxScroll = Math.max(0, contentWidth - width);
                    if (cursorX > contentX + width - step)
                        contentX = Math.min(maxScroll, cursorX - width + step);
                    else if (cursorX < contentX)
                        contentX = Math.max(0, cursorX);
                    else if (contentX > maxScroll)
                        contentX = maxScroll;
                }

                anchors.fill: parent
                anchors.leftMargin: passwordField.leftPadding
                anchors.rightMargin: passwordField.rightPadding
                clip: true
                interactive: false
                contentWidth: dotRow.width
                contentHeight: height

                Connections {
                    function onCursorPositionChanged() {
                        dotViewport.updateScroll();
                    }

                    target: passwordField
                }

                Row {
                    id: dotRow

                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8
                    onWidthChanged: dotViewport.updateScroll()

                    Repeater {
                        model: dotModel

                        delegate: Item {
                            id: delegateRoot

                            required property int index
                            required property bool removing

                            // Collapsing width to 0 triggers Row's `move` transition to slide right dots left
                            width: removing ? 0 : 10
                            height: 10

                            Rectangle {
                                id: dot

                                anchors.centerIn: parent
                                width: 9
                                height: 9
                                radius: 4.5
                                color: "#b0b0b0"
                                opacity: 0
                                scale: 0.4
                                Component.onCompleted: {
                                    if (!removing) {
                                        opacity = 1;
                                        scale = 1;
                                    }
                                }

                                states: State {
                                    name: "fadingOut"
                                    when: removing

                                    PropertyChanges {
                                        target: dot
                                        opacity: 0
                                        scale: 0.4
                                    }

                                }

                                transitions: Transition {
                                    to: "fadingOut"

                                    SequentialAnimation {
                                        ParallelAnimation {
                                            NumberAnimation {
                                                property: "opacity"
                                                duration: 120
                                                easing.type: Easing.OutQuad
                                            }

                                            NumberAnimation {
                                                property: "scale"
                                                duration: 120
                                                easing.type: Easing.OutQuad
                                            }

                                        }

                                        ScriptAction {
                                            script: {
                                                for (let i = 0; i < dotModel.count; i++) {
                                                    if (dotModel.get(i).removing && i === delegateRoot.index) {
                                                        dotModel.remove(i);
                                                        break;
                                                    }
                                                }
                                            }
                                        }

                                    }

                                }

                                Behavior on opacity {
                                    enabled: !removing

                                    NumberAnimation {
                                        duration: 130
                                        easing.type: Easing.OutCubic
                                    }

                                }

                                Behavior on scale {
                                    enabled: !removing

                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.OutBack
                                    }

                                }

                            }

                            Behavior on width {
                                NumberAnimation {
                                    duration: 130
                                    easing.type: Easing.OutCubic
                                }

                            }

                        }

                    }

                    // Smoothly slide remaining dots on the right when dots are inserted or removed
                    move: Transition {
                        NumberAnimation {
                            properties: "x"
                            duration: 140
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Behavior on contentX {
                    NumberAnimation {
                        duration: 130
                        easing.type: Easing.OutCubic
                    }

                }

            }

            // Completely suppress the native caret and blue selection handle at all lengths
            cursorDelegate: Item {
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
