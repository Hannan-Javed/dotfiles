import Quickshell
import QtQuick
import "../services"

Item {

    id: workspacesContainer
    anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
    height: 8
    
    property int activeIndex: {
        for (let i = 0; i < Niri.workspaceList.length; i++) {
            if (Niri.workspaceList[i].is_active) return i;
        }
        return 0;
    }

    width: (Niri.workspaceList.length * 8) + (Math.max(0, Niri.workspaceList.length - 1) * 12) + 12

    // 1. THE STATIONARY DOT TRACK
    Repeater {
        model: Niri.workspaceList.length
        
        delegate: Rectangle {
            id: dotItem
            required property int index
            property bool isCurrent: (index === workspacesContainer.activeIndex)
            
            height: 8
            radius: 4
            width: isCurrent ? 20 : 8
            color: isCurrent ? "transparent" : "#45475a"

            x: (index * 20) + (index > workspacesContainer.activeIndex ? 12 : 0)

            Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
            Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
        }
    }

    // 2. THE PHYSICAL SLIDING INDICATOR PILL
    Rectangle {
        id: slidingIndicator
        height: 8
        width: 20
        radius: 4
        color: "#cba6f7" 

        x: (workspacesContainer.activeIndex * 20)

        Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
        }
    }
}