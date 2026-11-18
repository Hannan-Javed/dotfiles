import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services.system
import qs.services.ui
import qs.theme

Rectangle {
    id: root

    property string searchText: ""
    readonly property var filteredApps: {
        if (searchText.trim() === "")
            return AppScanner.apps;

        const query = searchText.trim().toLowerCase();
        return AppScanner.apps.filter((app) => {
            return app.name.toLowerCase().includes(query) || (app.comment && app.comment.toLowerCase().includes(query));
        });
    }
    property bool keyboardNavigation: false

    implicitWidth: Metrics.appLauncherWidth
    implicitHeight: Metrics.appLauncherHeight
    color: Colors.background
    focus: true
    Keys.onPressed: (event) => {
        switch (event.key) {
        case Qt.Key_Down:
            keyboardNavigation = true;
            results.currentIndex = Math.min(results.currentIndex + 1, filteredApps.length - 1);
            event.accepted = true;
            break;
        case Qt.Key_Up:
            keyboardNavigation = true;
            results.currentIndex = Math.max(results.currentIndex - 1, 0);
            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (results.currentIndex >= 0 && results.currentIndex < filteredApps.length) {
                AppScanner.launch(filteredApps[results.currentIndex]);
                UIManager.hideOverlay();
            }
            event.accepted = true;
            break;
        }
    }
    Component.onCompleted: {
        searchField.forceActiveFocus();
    }

    Shortcut {
        sequence: "Escape"
        onActivated: UIManager.hideOverlay()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        TextField {
            id: searchField

            Layout.fillWidth: true
            focus: true
            placeholderText: "Search applications..."
            color: Colors.black
            text: root.searchText
            onTextChanged: {
                root.searchText = text;
                results.currentIndex = 0;
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.border
            opacity: 0.4
        }

        ListView {
            id: results

            Layout.fillWidth: true
            Layout.fillHeight: true
            model: filteredApps
            clip: true
            currentIndex: 0

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onPositionChanged: (mouse) => {
                    keyboardNavigation = false;
                    // Find which item is under the cursor (accounting for scroll offset)
                    let hoveredIndex = results.indexAt(mouse.x, mouse.y + results.contentY);
                    if (hoveredIndex !== -1 && hoveredIndex !== results.currentIndex)
                        results.currentIndex = hoveredIndex;

                }
                onClicked: (mouse) => {
                    let clickedIndex = results.indexAt(mouse.x, mouse.y + results.contentY);
                    if (clickedIndex !== -1 && clickedIndex < filteredApps.length) {
                        AppScanner.launch(filteredApps[clickedIndex]);
                        UIManager.hideOverlay();
                    }
                }
            }

            delegate: Rectangle {
                required property var modelData
                required property int index

                width: results.width
                height: 44
                color: ListView.isCurrentItem ? Qt.alpha(Colors.border, 0.15) : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    IconImage {
                        source: modelData.icon !== "" ? modelData.icon : Quickshell.iconPath("fallback")
                        implicitWidth: 24
                        implicitHeight: 24
                        mipmap: true
                    }

                    Column {
                        Layout.fillWidth: true

                        Text {
                            text: modelData.name
                            color: Colors.textPrimary
                            font.family: Typography.fontFamily
                        }

                        Text {
                            visible: modelData.comment
                            text: modelData.comment
                            color: Colors.textSecondary
                            font.family: Typography.fontFamily
                            font.pixelSize: 11
                        }

                    }

                }

            }

        }

    }

}
