import "../../services"
import QtQuick
pragma Singleton

// Theme is the owner of colors. On update theme, asks other owners to change as well (if theme asks so)
QtObject {
    id: root

    property color background: "#11111b"
    property color border: "#cba6f7"
    property color textPrimary: "#cdd6f4"

    function applyTheme(themeId) {
        if (!themeId)
            return ;

        const theme = ThemeRegistry.getTheme(themeId);
        if (!theme)
            return ;

        // Loop through all incoming color keys dynamically
        if (theme.colors) {
            for (const key in theme.colors) {
                if (root.hasOwnProperty(key))
                    root[key] = theme.colors[key];

            }
        } else {
            console.warn("Theme missing colors:", themeId);
        }
        // iterate through whatever suggestions are provided
        if (theme.suggestions) {
            const managerMap = {
                "bar": BarManager,
                "greetd": GreetdManager,
                "kitty": KittyManager,
                "notification": NotificationManager,
                "wallpaper": WallpaperManager
            };
            for (const key in theme.suggestions) {
                const manager = managerMap[key];
                const value = theme.suggestions[key];
                if (manager && typeof manager.update === "function")
                    manager.update(value);
                else
                    console.warn("No manager found or missing applySuggestion function for key:", key);
            }
        }
    }

}
