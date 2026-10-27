import "../../../services"
import "../../../theme"
import "../../customizationCenter"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    // mapping of each theme to its rectangle button location
    // used for navigation and scrolling to out-of-view selection
    property var themeItems: ({
    })
    // to allow safe update of both group and theme on change (for when they both change  at same time)
    property bool selectionUpdateInProgress: false
    property int selectedGroupIndex: 0
    property int lastSelectedThemeIndex: -1
    property int selectedThemeIndex: -1
    property var groupsCache: ThemeRegistry.groups()
    property var previewTheme: {
        if (selectedThemeIndex !== -1 && groupsCache && groupsCache.length > selectedGroupIndex) {
            let currentGroup = groupsCache[selectedGroupIndex];
            let collection = ThemeRegistry.getThemes(currentGroup);
            if (collection && collection.length > selectedThemeIndex)
                return collection[selectedThemeIndex];

        }
        return ThemeRegistry.getTheme(UserPreferences.activeTheme);
    }

    function findThemeInDirection(direction) {
        let currentKey = selectedGroupIndex + ":" + selectedThemeIndex;
        let current = themeItems[currentKey];
        if (!current)
            return null;

        // to find the relative coordinates of "item" within the "scrollContent"
        let currentPos_within_scroll = current.mapToItem(scrollContent, current.width / 2, current.height / 2);
        let currentCenterX = currentPos_within_scroll.x;
        let currentCenterY = currentPos_within_scroll.y;
        let best = null;
        let bestScore = Number.MAX_VALUE;
        // find distance of closest button relative to its center (and currently selected center)
        for (let key in themeItems) {
            let candidate = themeItems[key];
            if (candidate === current)
                continue;

            let candidatePos = candidate.mapToItem(scrollContent, candidate.width / 2, candidate.height / 2);
            let candidateCenterX = candidatePos.x;
            let candidateCenterY = candidatePos.y;
            let dx = Math.abs(candidateCenterX - currentCenterX);
            let dy = candidateCenterY - currentCenterY;
            // only consider elements down below (cand.y > curr.y)
            if (direction === "down" && dy <= 0)
                continue;

            // only consider elements up aboce  (cand.y < curr.y)
            if (direction === "up" && dy >= 0)
                continue;

            // pythagorean distance formula
            let score = dy * dy + dx * dx;
            if (score < bestScore) {
                bestScore = score;
                best = key;
            }
        }
        // return best groupIndex:themeIndex
        return best;
    }

    function ensureSelectedVisible() {
        let key = selectedGroupIndex + ":" + selectedThemeIndex;
        let item = themeItems[key];
        if (!item)
            return ;

        let flickable = scrollArea.contentItem;
        // this line finds the relative coordinates of "item" within the "scrollContent"
        let pos_within_scroll = item.mapToItem(scrollContent, 0, 0);
        let firstRowY = Number.MAX_VALUE;
        // to find y of first row
        for (let key in themeItems) {
            let parts = key.split(":");
            if (Number(parts[0]) !== 0)
                continue;

            let p = themeItems[key].mapToItem(scrollContent, 0, 0);
            firstRowY = Math.min(firstRowY, p.y);
        }
        // if first row, just scroll to top
        if (selectedGroupIndex === 0 && Math.abs(pos_within_scroll.y - firstRowY) < 1) {
            flickable.contentY = 0;
            return ;
        }
        // else go item.y + height
        let top = pos_within_scroll.y;
        let bottom = top + item.height;
        if (top < flickable.contentY)
            flickable.contentY = top;
        else if (bottom > flickable.contentY + scrollArea.height)
            flickable.contentY = bottom - scrollArea.height;
    }

    // helper function to ensure both theme and group indexesare updated at the same time
    function setSelection(groupIndex, themeIndex) {
        selectionUpdateInProgress = true;
        selectedGroupIndex = groupIndex;
        selectedThemeIndex = themeIndex;
        selectionUpdateInProgress = false;
        ensureSelectedVisible();
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            // if came into selection and there was another selection from firstRow, go to that
            if (lastSelectedThemeIndex !== -1)
                selectedThemeIndex = lastSelectedThemeIndex;
            else
                selectedThemeIndex = 0;
        } else {
            // store the last selected index
            lastSelectedThemeIndex = selectedThemeIndex;
            selectedThemeIndex = -1;
        }
    }
    Keys.onPressed: (event) => {
        const themes = ThemeRegistry.getThemes(groupsCache[selectedGroupIndex]);
        let target;
        switch (event.key) {
        case Qt.Key_R:
            RegistryManager.reloadAll();
            break;
        case Qt.Key_Right:
            if (selectedThemeIndex < themes.length - 1) {
                selectedThemeIndex++;
            } else if (selectedGroupIndex < groupsCache.length - 1) {
                selectedGroupIndex++;
                selectedThemeIndex = 0;
            }
            event.accepted = true;
            break;
        case Qt.Key_Up:
            target = findThemeInDirection("up");
            if (!target) {
                customizationCenter.forceActiveFocus();
            } else {
                let parts = target.split(":");
                setSelection(Number(parts[0]), Number(parts[1]));
            }
            event.accepted = true;
            break;
        case Qt.Key_Down:
            target = findThemeInDirection("down");
            if (target) {
                let parts = target.split(":");
                setSelection(Number(parts[0]), Number(parts[1]));
            }
            event.accepted = true;
            break;
        case Qt.Key_Left:
            if (selectedThemeIndex > 0) {
                selectedThemeIndex--;
            } else if (selectedGroupIndex > 0) {
                selectedGroupIndex--;
                selectedThemeIndex = ThemeRegistry.getThemes(groupsCache[selectedGroupIndex]).length - 1;
            } else {
                customizationCenter.tabFocus = true;
                selectedThemeIndex = -1;
                customizationCenter.forceActiveFocus();
            }
            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
            if (selectedThemeIndex !== -1 && themes[selectedThemeIndex])
                UserPreferences.setSetting("activeTheme", themes[selectedThemeIndex].id);

            event.accepted = true;
            break;
        }
    }
    onSelectedGroupIndexChanged: {
        if (!selectionUpdateInProgress)
            ensureSelectedVisible();

    }
    onSelectedThemeIndexChanged: {
        if (!selectionUpdateInProgress)
            ensureSelectedVisible();

    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical

        ScrollView {
            id: scrollArea

            SplitView.fillWidth: true
            SplitView.fillHeight: true
            clip: true

            Column {
                id: scrollContent

                width: parent.width
                spacing: 20

                Repeater {
                    model: groupsCache

                    delegate: Column {
                        id: groupColumn

                        required property string modelData
                        required property int index
                        property int currentGroupIndex: index

                        width: parent.width
                        spacing: 12

                        Text {
                            text: ":: " + groupColumn.modelData.toUpperCase()
                            color: Colors.border
                            font.family: Typography.fontFamily
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Flow {
                            width: parent.width
                            spacing: 16

                            Repeater {
                                model: ThemeRegistry.getThemes(groupColumn.modelData)

                                delegate: Rectangle {
                                    id: themeButton

                                    required property var modelData
                                    required property int index
                                    property bool selected: root.selectedGroupIndex === groupColumn.currentGroupIndex && root.selectedThemeIndex === index

                                    Component.onCompleted: {
                                        // add this rectangle (once) box for navigation and scroll focusing later
                                        root.themeItems[groupColumn.currentGroupIndex + ":" + index] = themeButton;
                                    }
                                    radius: 6
                                    color: selected ? Qt.alpha(Colors.border, 0.15) : "transparent"
                                    border.width: selected ? 1 : 0
                                    border.color: Colors.border
                                    width: themeText.width + 20
                                    height: 34

                                    Text {
                                        id: themeText

                                        anchors.centerIn: parent
                                        text: modelData.name
                                        color: selected ? Colors.textPrimary : Colors.textSecondary
                                        font.family: Typography.fontFamily
                                        font.pixelSize: 14
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            root.forceActiveFocus();
                                            root.selectedGroupIndex = groupColumn.currentGroupIndex;
                                            root.selectedThemeIndex = themeButton.index;
                                        }
                                        onDoubleClicked: {
                                            UserPreferences.setSetting("activeTheme", themeButton.modelData.id);
                                        }
                                    }

                                }

                            }

                        }

                    }

                }

            }

        }

        // preview image for theme
        Item {
            SplitView.fillWidth: true
            // only allow a fixed area for the preview
            SplitView.preferredHeight: root.height * Metrics.themePreviewRatio

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Image {
                    width: parent.width
                    height: parent.height - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    source: root.previewTheme && root.previewTheme.preview ? root.previewTheme.preview : ""
                }

                Text {
                    text: root.previewTheme ? root.previewTheme.id : "No Theme Selected"
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    color: Colors.textSecondary
                    font.family: Typography.fontFamily
                    font.pixelSize: 13
                }

            }

        }

        // to remove the white seperator line due to SplitView
        handle: Item {
            implicitHeight: 0
            implicitWidth: 0
        }

    }

}
