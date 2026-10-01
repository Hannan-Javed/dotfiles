import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    property var workspaceList: []
    property var windowsMap: ({
    })
    property int focusedWindowId: 0
    property string focusedWindowTitle: "" // Clear by default to show clock centered initially

    function updateTitle() {
        if (focusedWindowId === 0) {
            focusedWindowTitle = "";
            return ;
        }
        let win = windowsMap[focusedWindowId];
        if (!win) {
            focusedWindowTitle = "";
            return ;
        }
        // check if app id is like org.kde.xxxx first
        let parts = win.app_id.split(".");
        if (parts.length > 1)
            focusedWindowTitle = capitalize(parts[parts.length - 1]);
        else
            focusedWindowTitle = capitalize(win.app_id);
    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    // for initial processing
    Process {
        command: ["niri", "msg", "--json", "workspaces"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                try {
                    workspaceList = JSON.parse(data);
                } catch (e) {
                }
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
                    let newMap = {
                    };
                    winList.forEach((w) => {
                        newMap[w.id] = w;
                        if (w.is_focused)
                            focusedWindowId = w.id;

                    });
                    windowsMap = newMap;
                    updateTitle();
                } catch (e) {
                }
            }
        }

    }

    // for continously updating
    Process {
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        onRunningChanged: {
            if (!running) {
                running = true;
            }
        }

        stdout: SplitParser {
            onRead: (line) => {
                if (!line.trim())
                    return ;

                try {
                    let obj = JSON.parse(line);
                    if (obj.WorkspacesChanged)
                        workspaceList = obj.WorkspacesChanged.workspaces;

                    if (obj.WindowsChanged) {
                        let newMap = {
                        };
                        obj.WindowsChanged.windows.forEach((w) => {
                            newMap[w.id] = w;
                            if (w.is_focused)
                                focusedWindowId = w.id;

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
                        workspaceList = workspaceList.map((ws) => {
                            let copy = Object.assign({
                            }, ws);
                            copy.is_active = (ws.id === activeId);
                            copy.is_focused = (ws.id === activeId);
                            return copy;
                        });
                    }
                    if (obj.WorkspaceActiveWindowChanged && obj.WorkspaceActiveWindowChanged.active_window_id === null) {
                        let activeWs = workspaceList.find((ws) => {
                            return ws.is_active;
                        });
                        if (activeWs && activeWs.id === obj.WorkspaceActiveWindowChanged.workspace_id) {
                            focusedWindowId = 0;
                            focusedWindowTitle = "";
                        }
                    }
                } catch (e) {
                }
            }
        }

    }

}
