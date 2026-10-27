import "../../../services"
import "../../../theme"
import "../../customizationCenter"
import QtQuick
import QtQuick.Controls

Item {
    id: root

    required property var items
    property int selectedIndex: -1
    property real previewRatio: 0.35 // default preview rato
    property var appliedStyle
    property string previewSource: selectedIndex !== -1 ? currentItem && currentItem.preview ? currentItem.preview : "" : appliedStyle && appliedStyle.preview ? appliedStyle.preview : ""
    property string previewTitle: currentItem ? currentItem.name : appliedStyle && appliedStyle.name ? appliedStyle.name : ""
    readonly property var currentItem: items && items.length > 0 ? items[selectedIndex] : null
    property var itemDelegates: ({
    })

    signal activated(var item)

    function ensureSelectedVisible() {
        let item = itemDelegates[selectedIndex];
        if (!item)
            return ;

        let flickable = scrollArea.contentItem;
        let pos = item.mapToItem(contentColumn, 0, 0);
        let top = pos.y;
        let bottom = top + item.height;
        if (top < flickable.contentY)
            flickable.contentY = top;
        else if (bottom > flickable.contentY + scrollArea.height)
            flickable.contentY = bottom - scrollArea.height;
    }

    onActiveFocusChanged: {
        if (activeFocus)
            selectedIndex = 0;
        else
            selectedIndex = -1;
    }
    Keys.onPressed: (event) => {
        switch (event.key) {
        case Qt.Key_R:
            RegistryManager.reloadAll();
            break;
        case Qt.Key_Up:
            if (selectedIndex > 0)
                selectedIndex--;
            else
                customizationCenter.forceActiveFocus();
            event.accepted = true;
            break;
        case Qt.Key_Down:
            if (selectedIndex < items.length - 1)
                selectedIndex++;

            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
            if (currentItem)
                activated(currentItem);

            event.accepted = true;
            break;
        }
    }
    onSelectedIndexChanged: ensureSelectedVisible()

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical

        ScrollView {
            id: scrollArea

            SplitView.fillWidth: true
            SplitView.fillHeight: true
            clip: true

            Column {
                id: contentColumn

                width: parent.width
                spacing: 12

                Repeater {
                    model: root.items

                    delegate: Rectangle {
                        id: listItem

                        required property var modelData
                        required property int index
                        property bool selected: root.selectedIndex === index

                        Component.onCompleted: {
                            root.itemDelegates[index] = listItem;
                        }
                        width: parent.width
                        height: 48
                        radius: 6
                        color: selected ? Qt.alpha(Colors.border, 0.12) : "transparent"
                        border.width: selected ? 1 : 0
                        border.color: Colors.border

                        Text {
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
                                root.selectedIndex = index;
                            }
                            onDoubleClicked: {
                                root.activated(modelData);
                            }
                        }

                    }

                }

            }

        }

        PreviewPane {
            SplitView.fillWidth: true
            SplitView.preferredHeight: root.height * root.previewRatio
            previewSource: root.previewSource
            title: root.previewTitle
        }

        handle: Item {
            implicitHeight: 0
            implicitWidth: 0
        }

    }

}
