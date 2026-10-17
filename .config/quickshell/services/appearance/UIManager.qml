pragma Singleton

import QtQuick

QtObject {
    id: root

    property bool appearanceCenterVisible: false

    function showAppearanceCenter(): void {
        appearanceCenterVisible = true
    }
    
    function hideAppearanceCenter(): void {
        appearanceCenterVisible = false
    }

    function toggleAppearanceCenter(): void {
        appearanceCenterVisible = !appearanceCenterVisible
    }
}