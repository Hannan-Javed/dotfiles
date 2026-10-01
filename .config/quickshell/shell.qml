import Quickshell
import QtQuick
import "./services"
import "./widgets"
import "./widgets/rightWidgets"
import "./theme"

ShellRoot {
    
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            
            color: "transparent"
            anchors { 
                top: true 
                left: true 
                right: true 
            }
            margins { 
                top: 8
                left: 12
                right: 12 
            }
            implicitHeight: Metrics.barHeight
            
            // --- BAR LAYOUT UI ---
            Rectangle {
                
                anchors.fill: parent
                color: Colors.background

                border.color: Colors.border
                border.width: Metrics.borderWidth

                radius: Metrics.barRadius

                // only workspaces on left
                Workspaces {
                    id: workspaces
                    anchors {
                        left: parent.left
                        leftMargin: Metrics.sideMargin
                        verticalCenter: parent.verticalCenter
                    }
                }

                // window title always in middle
                WindowTitle {
                    id: windowTitle
                    anchors.centerIn: parent
                }

                // clock with dynamic positioning
                Item {
                    id: clockDock

                    width: 1
                    height: 1

                    anchors {
                        right: rightWidgets.left
                        rightMargin: Metrics.sideMargin
                        verticalCenter: parent.verticalCenter
                    }
                }
                Clock {
                    id: clock

                    anchors.verticalCenter: parent.verticalCenter

                    x: Niri.focusedWindowTitle === ""
                        ? (parent.width - width) / 2
                        : clockDock.x - width

                    Behavior on x {
                        NumberAnimation {
                            duration: Metrics.clockAnimation
                            easing.type: Easing.OutQuint
                        }
                    }
                }

                // add widgets on right in this row container
                Row {
                    id: rightWidgets
                    anchors {
                        right: parent.right
                        rightMargin: Metrics.sideMargin
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: Metrics.widgetSpacing

                    Mic {
                        id: mic
                    }
                    Volume {
                        id: volume
                    }
                    SystemStats {
                        id: systemStats
                    }
                    Battery {
                        id: battery
                    }
                    PowerButton {
                        icon: "↻"
                        command: "systemctl reboot"
                        accent: Colors.peach
                    }
                    PowerButton {
                        icon: "⏻"
                        command: "systemctl poweroff"
                        accent: Colors.red
                    }
                  
                }
               
            }
        }
    }
}