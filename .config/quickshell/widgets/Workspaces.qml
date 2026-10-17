import "../services"
import "../theme"
import QtQuick
import Quickshell

Item {
    id: workspacesContainer

    property int activeIndex: {
        for (let i = 0; i < Niri.workspaceList.length; i++) {
            if (Niri.workspaceList[i].is_active)
                return i;

        }
        return 0;
    }

    height: 8
    width: (Niri.workspaceList.length * 8) + (Math.max(0, Niri.workspaceList.length - 1) * 12) + 12

    anchors {
        left: parent.left
        verticalCenter: parent.verticalCenter
    }

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
            color: isCurrent ? "transparent" : Colors.workspaceInactive
            x: (index * 20) + (index > workspacesContainer.activeIndex ? 12 : 0)

            Behavior on x {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutQuint
                }

            }

            Behavior on width {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutQuad
                }

            }

        }

    }

    // 2. THE PHYSICAL SLIDING INDICATOR PILL
    Rectangle {
        id: slidingIndicator

        height: 8
        width: 20
        radius: 4
        color: Colors.workspaceActive
        x: (workspacesContainer.activeIndex * 20)

        Behavior on x {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutQuint
            }

        }

    }

}
