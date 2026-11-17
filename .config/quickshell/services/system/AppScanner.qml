import QtQuick
import Quickshell
pragma Singleton

QtObject {

    id: root

    // Automatically updates whenever system .desktop files change
    readonly property var apps: {
        let list = [];
        const entries = DesktopEntries.applications.values;
        for (let i = 0; i < entries.length; i++) {
            const entry = entries[i];
            // Skip hidden/background entries (like Wofi does)
            if (entry.noDisplay)
                continue;

            list.push({
                "name": entry.name,
                "comment": entry.comment,
                "icon": Quickshell.iconPath(entry.icon, true),
                "command": entry.command,
                "workingDir": entry.workingDirectory,
                "runInTerminal": entry.runInTerminal,
                "rawEntry": entry 
            });
        }
        // ================ CUSTOM APPS HERE ================
        list.push({
            "name": "Customization Center",
            "comment": "Manage themes, wallpapers, lock screens, styles and more",
            "icon": Quickshell.iconPath("org.quickshell", "fallback"),
            "command": ["qs", "ipc", "call", "customizationCenter", "showCustomizationCenter"],
            "runInTerminal": false // optional, not currently used
        });
        list.push({
            "name": "App Launcher",
            "comment": "bro",
            "icon": Quickshell.iconPath("org.quickshell", "fallback"),
            "command": ["qs", "ipc", "call", "appLauncher", "showAppLauncher"],
            "runInTerminal": false 
        });
        // Sort alphabetically by app name
        list.sort((a, b) => {
            return a.name.localeCompare(b.name);
        });
        return list;
    }

    function launch(appItem) {
        if (appItem.rawEntry)
            appItem.rawEntry.execute();
        else
            Quickshell.execDetached({
            "command": appItem.command,
            "workingDirectory": appItem.workingDir || ""
        });
    }

}
