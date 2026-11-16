import qs.services.ui
import Quickshell
import Quickshell.Io
import QtQuick

Item {    
    IpcHandler {
        target: "customizationCenter"
        function toggleCustomizationCenter(): void { UIManager.toggleOverlay(UIManager.overlay.customizationCenter) }
        function showCustomizationCenter(): void { UIManager.showOverlay(UIManager.overlay.customizationCenter) }
        function hideCustomizationCenter(): void { UIManager.hideOverlay() }
    }

    LazyLoader {
        id: appearanceCenterLoader

        active: UIManager.activeOverlay === UIManager.overlay.customizationCenter

        component: Window {
            id: appearanceCenterWindow

            color: "transparent"
            flags: Qt.Window | Qt.FramelessWindowHint
            // Provide a hardcoded or calculated fallback sizing if implicit values are 0
            width: switcherContent.implicitWidth
            height: switcherContent.implicitHeight
            title: "Customization Center"
            Component.onCompleted: show()

            CustomizationCenter {
                id: switcherContent

                anchors.fill: parent
            }

        }

    }

}
