import Quickshell
import QtQuick
import "./services"
import "./widgets"
import "./widgets/rightWidgets"

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
            implicitHeight: 44
            
            // --- BAR LAYOUT UI ---
            Rectangle {
                
                anchors.fill: parent
                color: "#11111b" // Deep dark background (Catppuccin Crust)
                radius: 12        // Rounded bar look
                
                // Fine elegant framing border
                border.color: "#313244"
                border.width: 2

                // only workspaces on left
                Workspaces {
                    id: workspaces
                    anchors {
                        left: parent.left
                        leftMargin: 16
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
                        rightMargin: 16
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
                            duration: 1000
                            easing.type: Easing.OutQuint
                        }
                    }
                }

                // add widgets on right in this row container
                Row {
                    id: rightWidgets
                    anchors {
                        right: parent.right
                        rightMargin: 16
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 7
                
                    SystemStats {
                        id: systemStats
                    }
                    Battery {
                        id: battery
                    }
                  
                }
               
            }
        }
    }
}