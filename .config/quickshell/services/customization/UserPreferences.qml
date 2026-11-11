// This is the Persistence Source of Truth. All changes using ThemeSwitcher are first reflected here
// Then each manager has a binding to values here. if the value changes, that manager does its own thing to reflect the change

import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    // default values for styles go here
    property string activePreset: "arch/neon"
    property string paletteStyle: "purple"
    property string barStyle: "SimpleBar/Bar"
    property string notificationStyle: "SimpleNotification"
    property string wallpaper: "Pictures/Wallpapers/wallpaper.jpg"
    property string kittyStyle: "default-kitty"
    property string niriStyle: "default-niri"
    property string greeterStyle: "default-greeter/shell"
    // assign the FileView object to a property name
    property FileView settingsFile

    function getConfigKeys() {
        const ignoredKeys = ["objectName", "settingsFile", "fileComponent"];
        return Object.keys(root).filter((key) => {
            // Ignore QML internals, functions, and explicitly ignored objects
            return !ignoredKeys.includes(key) && !key.startsWith("__") && typeof root[key] !== "function";
        });
    }

    function restore() {
        load();
    }

    function setSetting(key, value) {
        if (!key)
            return ;

        if (root.hasOwnProperty(key)) {
            root[key] = value;
            save();
            console.log("Applied style:", key, value);
        } else {
            console.warn("Attempted to set invalid configuration key:", key);
        }
    }

    function save() {
        const obj = {
        };
        const keys = getConfigKeys();
        for (let i = 0; i < keys.length; i++) {
            const key = keys[i];
            obj[key] = root[key];
        }
        settingsFile.setText(JSON.stringify(obj, null, 4));
    }

    function load() {
        try {
            const content = settingsFile.text();
            if (!content || content.trim() === "")
                return ;

            const data = JSON.parse(content);
            const keys = getConfigKeys();
            for (let i = 0; i < keys.length; i++) {
                const key = keys[i];
                if (data.hasOwnProperty(key))
                    root[key] = data[key];

            }
        } catch (e) {
            console.warn("Failed loading settings:", e);
        }
    }

    Component.onCompleted: {
        restore();
    }

    settingsFile: FileView {
        id: fileComponent

        path: Quickshell.env("HOME") + "/.config/quickshell/user-preferences.json"
        blockLoading: true // Important - Enforces immediate I/O completion for singletons otherwise will return empty for load() function
    }

}
