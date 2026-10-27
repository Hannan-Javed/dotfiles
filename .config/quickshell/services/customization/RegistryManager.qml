import QtQuick
pragma Singleton

QtObject {
    property var registries: []

    function register(registry) {
        registries.push(registry);
    }

    function reloadAll() {
        for (let i = 0; i < registries.length; i++) registries[i].reload()
    }

}
