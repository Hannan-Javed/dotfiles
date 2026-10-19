import "../../services"
import QtQuick
pragma Singleton

// runtime owner of colors
QtObject {
    id: root

    property color background
    property color border
    property color textPrimary
    // pull activeTheme from User Preferences, but also force ThemeRegistry to be loaded before applying that theme
    // since applying a theme before its metadata is loaded will cause issue
    property string currentThemeId: UserPreferences.activeTheme
    property var registryIndex: ThemeRegistry.themeIndex

    function updateTheme() {
        // exit early if either piece of data isn't ready yet
        if (!currentThemeId || !registryIndex || Object.keys(registryIndex).length === 0)
            return ;

        const theme = registryIndex[currentThemeId];
        if (!theme) {
            console.warn("Theme not found in registry yet:", currentThemeId);
            return ;
        }
        // loop through all incoming color keys dynamically
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
            for (const key in theme.suggestions) {
                const value = theme.suggestions[key];
                UserPreferences.setSetting(key, value);
            }
        }
    }

    onCurrentThemeIdChanged: updateTheme()
    onRegistryIndexChanged: updateTheme()
}
