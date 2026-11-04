import "../../../services"
import QtQuick
pragma Singleton

QtObject {
    property var registryIndex: PresetRegistry.presetIndex

    function applyPreset(presetId) {
        if (!registryIndex || Object.keys(registryIndex).length === 0)
            return ;
        const preset = registryIndex[presetId];
        if (!preset) {
            console.warn("Preset not found:", presetId);
            return ;
        }
        // metadata
        UserPreferences.activePreset = presetId;
        for (const key in preset.presets) {
            const value = preset.presets[key];
            UserPreferences.setSetting(key, value);
        }
        console.log("Applied preset:", presetId);
    }

}
