import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            required property var modelData
            screen: modelData
            
            color: "transparent"
            // --- BAR STRUCTURE WITH TOP, LEFT, RIGHT MARGINS ---
            anchors { top: true; left: true; right: true }
            margins { top: 8; left: 12; right: 12 }
            implicitHeight: 44
            
            // --- STATE STORE ---
            property var workspaceList: []
            property var windowsMap: ({}) 
            property int focusedWindowId: 0
            property string focusedWindowTitle: "" // Clear by default to show clock centered initially

            property var bat: UPower.displayDevice

            property real batteryPercent:
                bat ? bat.percentage * 100 : 0

            property bool batteryCharging:
                bat ? bat.state === UPowerDeviceState.Charging : false

            function getBatteryIcon() {
                if (batteryCharging)
                    return "󰂄";

                if (batteryPercent > 85)
                    return "󰁹";

                if (batteryPercent > 60)
                    return "󰂀";

                if (batteryPercent > 40)
                    return "󰁾";

                if (batteryPercent > 20)
                    return "󰁻";

                return "󰂎";
            }

            function updateTitle() {
                if (focusedWindowId === 0) {
                    focusedWindowTitle = "";
                    return;
                }
                let win = windowsMap[focusedWindowId];
                focusedWindowTitle = (win && win.title) ? win.title : "";
            }

            // --- 1. INITIAL SEED PROCESS ---
            Process {
                command: ["niri", "msg", "--json", "workspaces"]
                running: true
                stdout: SplitParser {
                    onRead: (data) => {
                        try { workspaceList = JSON.parse(data); } catch(e){}
                    }
                }
            }

            Process {
                command: ["niri", "msg", "--json", "windows"]
                running: true
                stdout: SplitParser {
                    onRead: (data) => {
                        try {
                            let winList = JSON.parse(data);
                            let newMap = {};
                            winList.forEach(w => {
                                newMap[w.id] = w;
                                if (w.is_focused) focusedWindowId = w.id;
                            });
                            windowsMap = newMap;
                            updateTitle();
                        } catch(e){}
                    }
                }
            }

            // --- 2. LIVE IPC EVENT STREAM ---
            Process {
                id: niriIpc
                command: ["niri", "msg", "--json", "event-stream"]
                running: true
                onRunningChanged: if (!running) running = true 

                stdout: SplitParser {
                    onRead: (line) => {
                        if (!line.trim()) return;
                        
                        try {
                            let obj = JSON.parse(line);
                            
                            if (obj.WorkspacesChanged) {
                                workspaceList = obj.WorkspacesChanged.workspaces;
                            }
                            
                            if (obj.WindowsChanged) {
                                let newMap = {};
                                obj.WindowsChanged.windows.forEach(w => {
                                    newMap[w.id] = w;
                                    if (w.is_focused) focusedWindowId = w.id;
                                });
                                windowsMap = newMap;
                                updateTitle();
                            }
                            
                            if (obj.WindowFocusChanged) {
                                let nextId = obj.WindowFocusChanged.id;
                                if (nextId === null) {
                                    focusedWindowId = 0;
                                    focusedWindowTitle = ""; 
                                } else {
                                    focusedWindowId = nextId;
                                    updateTitle();
                                }
                            }
                            
                            if (obj.WindowOpenedOrChanged) {
                                let w = obj.WindowOpenedOrChanged.window;
                                let currentMap = windowsMap;
                                currentMap[w.id] = w;
                                windowsMap = currentMap;
                                
                                if (w.is_focused) {
                                    focusedWindowId = w.id;
                                    updateTitle();
                                }
                            }
                            
                            if (obj.WorkspaceActivated && obj.WorkspaceActivated.focused) {
                                let activeId = obj.WorkspaceActivated.id;
                                workspaceList = workspaceList.map(ws => {
                                    let copy = Object.assign({}, ws);
                                    copy.is_active = (ws.id === activeId);
                                    copy.is_focused = (ws.id === activeId);
                                    return copy;
                                });
                            }

                            if (obj.WorkspaceActiveWindowChanged && obj.WorkspaceActiveWindowChanged.active_window_id === null) {
                                let activeWs = workspaceList.find(ws => ws.is_active);
                                if (activeWs && activeWs.id === obj.WorkspaceActiveWindowChanged.workspace_id) {
                                    focusedWindowId = 0;
                                    focusedWindowTitle = "";
                                }
                            }
                        } catch (e) {}
                    }
                }
            }

            // --- 3. LIVE CLOCK DATA MODULE ---
            property string currentDateTimeString: ""
            
            Timer {
                id: clockTimer
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    let date = new Date();
                    
                    // Arrays to map short strings manually
                    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
                    let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                    
                    let dayName = days[date.getDay()];
                    let monthName = months[date.getMonth()];
                    
                    // Zero padding formatting helpers
                    let dd = String(date.getDate()).padStart(2, '0');
                    let hh = String(date.getHours()).padStart(2, '0');
                    let mm = String(date.getMinutes()).padStart(2, '0');
                    let ss = String(date.getSeconds()).padStart(2, '0');
                    
                    // Output matches standard layout template: DAY, DD-MON, HH:MM:SS
                    currentDateTimeString = `${dayName}, ${dd}-${monthName}, ${hh}:${mm}:${ss}`;
                }
            }


            // --- BAR LAYOUT UI ---
            Rectangle {
                anchors.fill: parent
                color: "#11111b" // Deep dark background (Catppuccin Crust)
                radius: 12        // Rounded bar look
                
                // Fine elegant framing border
                border.color: "#313244"
                border.width: 1
                
                // Left-aligned: Physical Slider Container
                Item {
                    id: workspacesContainer
                    anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
                    height: 8
                    
                    property int activeIndex: {
                        for (let i = 0; i < workspaceList.length; i++) {
                            if (workspaceList[i].is_active) return i;
                        }
                        return 0;
                    }

                    width: (workspaceList.length * 8) + (Math.max(0, workspaceList.length - 1) * 12) + 12

                    // 1. THE STATIONARY DOT TRACK
                    Repeater {
                        model: workspaceList.length
                        
                        delegate: Rectangle {
                            id: dotItem
                            required property int index
                            property bool isCurrent: (index === workspacesContainer.activeIndex)
                            
                            height: 8
                            radius: 4
                            width: isCurrent ? 20 : 8
                            color: isCurrent ? "transparent" : "#45475a"

                            x: (index * (8 + 12)) + (index > workspacesContainer.activeIndex ? 12 : 0)

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

                // Centered: Active Window Title (Fades smoothly out if empty)
                Text {
                    id: windowTitleText
                    anchors.centerIn: parent
                    text: barWindow.focusedWindowTitle
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    opacity: text !== "" ? 1.0 : 0.0
                    Behavior on opacity { 
                        NumberAnimation { 
                            duration: 200 
                        } 
                    }
                }

                Row {
                    id: rightWidgets
                    anchors {
                        right: parent.right
                        rightMargin: 16
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 12
                    //
                    // BATTERY
                    //
                    Row {
                        spacing: 6

                        Text {
                            text: barWindow.getBatteryIcon()
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18

                            color:
                                barWindow.batteryPercent <= 20 &&
                                !barWindow.batteryCharging
                                ? "#f38ba8"
                                : "#cdd6f4"
                        }
                        Text {
                            text: Math.round(barWindow.batteryPercent) + "%"
                            color: "#cdd6f4"
                            font.pixelSize: 13
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    //
                    // Placeholder future widgets
                    //
                    Text {
                        text: "󰍛" // CPU
                        color: "#cdd6f4"
                        visible: false
                    }

                    Text {
                        text: "󰘚" // MEM
                        color: "#cdd6f4"
                        visible: false
                    }
                }
                // Smoothly Sliding Clock Component
                Text {
                    id: dynamicClock
                    text: currentDateTimeString
                    color: '#ffffff'
                    font.pixelSize: 14
                    font.bold: true
                    font.family: "monospace" // Fixed-width prevents text layout jittering
                    anchors.verticalCenter: parent.verticalCenter// --- DYNAMIC ALIGNMENT CALCULATION ---// Target coordinates: Center of the bar vs Right margin offset
                    property bool isCentered: (barWindow.focusedWindowTitle === "")// Mathematical positions to switch between
                    property real targetX: isCentered? (parent.width / 2) - (width / 2): rightWidgets.x - width - 16
                    x: targetX// Smooth physical glide behavior when position parameters swap
                    Behavior on x {
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.OutQuint
                        }
                    }
                }
            }
        }
    }
}