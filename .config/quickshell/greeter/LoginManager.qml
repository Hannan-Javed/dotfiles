import QtQuick
import Quickshell
import Quickshell.Services.Greetd

QtObject {
    id: manager

    property string username: ""
    property string password: ""
    property bool authenticating: false
    property string errorMessage: ""
    property string selectedSession: ""

    function startLogin() {
        if (username === "")
            return;

        authenticating = true;
        errorMessage = "";
        Greetd.createSession(username);
    }

    function cancel() {
        Greetd.cancelSession();
    }

    property Connections greetdConnections: Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            if (responseRequired)
                Greetd.respond(manager.password);
        }

        function onAuthFailure(message) {
            Greetd.cancelSession();
            manager.authenticating = false;
            manager.errorMessage = message;
        }

        function onReadyToLaunch() {
            Greetd.launch([manager.selectedSession]);
        }
    }
}
