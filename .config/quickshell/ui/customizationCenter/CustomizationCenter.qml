import "../../services"
import "../../theme"
import "./pages"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: customizationCenter

    property int currentTab: 0

    implicitWidth: Metrics.themeSwitcherWidth
    implicitHeight: Metrics.themeSwitcherHeight
    radius: 12
    color: Colors.background
    opacity: 0.9
    border.width: 1
    border.color: Colors.border
    focus: true
    Keys.onPressed: (event) => {
        if (!activeFocus)
            return ;
        switch (event.key) {
        case Qt.Key_Right:
            // limit dynamically based on items in tabRepeater
            currentTab = Math.min(currentTab + 1, tabRepeater.count - 1);
            break;
        case Qt.Key_Left:
            currentTab = Math.max(currentTab - 1, 0);
            break;
        case Qt.Key_Down:
            const page = pages.children[currentTab].forceActiveFocus();
            break;
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: UIManager.hideAppearanceCenter()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        Text {
            text: "Customization Center"
            color: Colors.textPrimary
            font.pixelSize: 22
            font.family: "JetBrains Mono"
            font.bold: true
        }

        Row {
            id: tabsRow

            Layout.fillWidth: true
            spacing: 24

            Repeater {
                id: tabRepeater

                model: ["Themes", "Bars", "Notifications"]

                delegate: Item {
                    required property int index
                    required property string modelData
                    property bool selected: customizationCenter.currentTab === index

                    width: tabText.contentWidth + 24
                    height: tabText.height

                    Row {
                        anchors.centerIn: parent
                        spacing: 2

                        // square brackets around currently selected tab
                        Text {
                            text: "["
                            color: Colors.border
                            opacity: parent.parent.selected ? 1 : 0
                            font.family: "JetBrains Mono"
                            font.pixelSize: 15

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 120
                                }

                            }

                        }

                        Text {
                            id: tabText

                            text: modelData
                            color: parent.parent.selected ? Colors.textPrimary : Colors.textSecondary
                            font.family: "JetBrains Mono"
                            font.pixelSize: 15

                            Behavior on color {
                                ColorAnimation {
                                    duration: 120
                                }

                            }

                        }

                        Text {
                            text: "]"
                            color: Colors.border
                            opacity: parent.parent.selected ? 1 : 0
                            font.family: "JetBrains Mono"
                            font.pixelSize: 15

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 120
                                }

                            }

                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            customizationCenter.currentTab = index;
                            customizationCenter.forceActiveFocus();
                        }
                    }

                }

            }

        }
        // white seperator line

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.border
            opacity: 0.4
        }

        StackLayout {
            id: pages

            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: customizationCenter.currentTab

            ThemePage {
            }

            BarPage {
            }

            NotificationPage {
            }

        }

    }

}
