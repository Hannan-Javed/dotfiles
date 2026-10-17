import "../../services"
import QtQuick
pragma Singleton

// Runtime owner of colors
QtObject {
    id: root

    property color background
    property color border
    property color textPrimary
    // pull activeTheme from Customization Manager, but also force ThemeRegistry to be loaded before applying that theme
    // since applying a theme before its metadata is loaded will cause issue
    property string currentThemeId: CustomizationManager.activeTheme
    property var registryIndex: ThemeRegistry.themeIndex

    function updateTheme() {
        // Exit early if either piece of data isn't ready yet
        if (!currentThemeId || !registryIndex || Object.keys(registryIndex).length === 0)
            return ;

        const theme = registryIndex[currentThemeId];
        if (!theme) {
            console.warn("Theme not found in registry yet:", currentThemeId);
            return ;
        }
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
            for (const key in theme.suggestions) {
                const value = theme.suggestions[key];
                CustomizationManager.setSetting(key, value);
            }
        }
    }

    // 2. Watch for changes in either the active theme ID OR the loaded index
    onCurrentThemeIdChanged: updateTheme()
    onRegistryIndexChanged: updateTheme()
}
