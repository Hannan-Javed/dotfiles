import "../../../services"
import "../../../theme"
import "../../customizationCenter"
import QtQuick
import QtQuick.Controls

Item {
    id: root

    property var wallpapers: WallpaperRegistry.wallpapers
    property int selectedIndex: -1
    property int lastSelectedIndex: -1
    property var wallpaperItems: ({
    })
    readonly property int columns: Math.max(1, Math.floor(scrollArea.availableWidth / (Metrics.wallpaperTileWidth + Metrics.wallpaperTileSpacing)))

    function ensureSelectedVisible() {
        let item = wallpaperItems[selectedIndex];
        if (!item)
            return ;

        let flickable = scrollArea.contentItem;
        let pos = item.mapToItem(gridContainer, 0, 0);
        let top = pos.y;
        let bottom = top + item.height;
        if (top < flickable.contentY)
            flickable.contentY = top;
        else if (bottom > flickable.contentY + scrollArea.height)
            flickable.contentY = bottom - scrollArea.height;
    }

    focus: true
    onSelectedIndexChanged: ensureSelectedVisible()
    onActiveFocusChanged: {
        if (activeFocus) {
            selectedIndex = lastSelectedIndex !== -1 ? lastSelectedIndex : 0;
        } else {
            lastSelectedIndex = selectedIndex;
            selectedIndex = -1;
        }
    }
    Keys.onPressed: (event) => {
        let target;
        switch (event.key) {
        case Qt.Key_R:
            RegistryManager.reloadAll();
            break;
        case Qt.Key_Left:
            if (selectedIndex > 0) {
                selectedIndex--;
            } else {
                customizationCenter.tabFocus = true;
                customizationCenter.forceActiveFocus();
            }
            event.accepted = true;
            break;
        case Qt.Key_Right:
            if (selectedIndex < wallpapers.length - 1)
                selectedIndex++;

            event.accepted = true;
            break;
        case Qt.Key_Up:
            target = selectedIndex - columns;
            if (target >= 0)
                selectedIndex = target;
            else
                customizationCenter.forceActiveFocus();
            event.accepted = true;
            break;
        case Qt.Key_Down:
            target = selectedIndex + columns;
            if (target < wallpapers.length)
                selectedIndex = target;

            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
            let wallpaper = wallpapers[selectedIndex];
            if (selectedIndex && wallpaper)
                UserPreferences.setSetting("wallpaper", wallpaper.path);

            event.accepted = true;
            break;
        }
    }

    ScrollView {
        id: scrollArea

        anchors.fill: parent
        clip: true

        Item {
            id: gridContainer

            width: scrollArea.availableWidth
            height: wallpaperGrid.implicitHeight

            Grid {
                id: wallpaperGrid

                width: parent.width
                columns: root.columns
                spacing: Metrics.wallpaperTileSpacing

                Repeater {
                    model: root.wallpapers

                    delegate: Rectangle {
                        id: wallpaperCard

                        required property var modelData
                        required property int index
                        readonly property bool selected: root.selectedIndex === index

                        width: Metrics.wallpaperTileWidth
                        height: Metrics.wallpaperTileHeight
                        radius: 8
                        color: selected ? Qt.alpha(Colors.border, 0.15) : "transparent"
                        border.width: selected ? 1 : 0
                        border.color: Colors.border
                        Component.onCompleted: {
                            root.wallpaperItems[index] = wallpaperCard;
                        }

                        Column {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            Text {
                                width: parent.width
                                height: 24
                                text: modelData.name
                                color: wallpaperCard.selected ? Colors.textPrimary : Colors.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                font.family: "JetBrains Mono"
                                font.pixelSize: 13
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height - 32
                                radius: 6
                                clip: true
                                color: Colors.surface ?? Colors.background

                                Image {
                                    anchors.fill: parent
                                    source: modelData.path
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: true
                                    smooth: true
                                    mipmap: true
                                }

                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.forceActiveFocus();
                                root.selectedIndex = wallpaperCard.index;
                            }
                            onDoubleClicked: {
                                root.forceActiveFocus();
                                root.selectedIndex = wallpaperCard.index;
                                root.applySelectedWallpaper();
                            }
                        }

                    }

                }

            }

        }

    }

}
