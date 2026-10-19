import "../../services"
import "./pages"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: PaletteManager.background
    implicitWidth: 800
    implicitHeight: 600

    Shortcut {
        sequence: "Escape"
        onActivated: UIManager.hideAppearanceCenter()
    }

    TabBar {
        id: tabBar

        width: parent.width

        TabButton {
            text: "Themes"
        }

        TabButton {
            text: "Bars"
        }

        TabButton {
            text: "Notifications"
        }

    }

    StackLayout {
        anchors.top: tabBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: tabBar.currentIndex

        ThemePage {
        }

        BarPage {
        }

        NotificationPage {
        }

    }

}
