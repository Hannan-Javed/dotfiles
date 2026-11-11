pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string lastSelectedUser: ""
    property string lastSelectedSession: ""

    property FileView stateFile: FileView {
        path: "/var/cache/qs-greeter/state.json"
        blockLoading: true
    }

    property FileView usersFile: FileView {
        path: "/var/cache/qs-greeter/users.json"
        blockLoading: true
    }

    property FileView sessionsFile: FileView {
        path: "/var/cache/qs-greeter/sessions.json"
        blockLoading: true
    }

    function save() {
        stateFile.setText(JSON.stringify({
            lastSelectedUser: lastSelectedUser,
            lastSelectedSession: lastSelectedSession
        }, null, 4));
    }

    function loadState() {
        try {
            const content = stateFile.text();

            if (!content || content.trim() === "")
                return false;

            const data = JSON.parse(content);

            if (data.lastSelectedUser)
                lastSelectedUser = data.lastSelectedUser;

            if (data.lastSelectedSession)
                lastSelectedSession = data.lastSelectedSession;

            return true;
        } catch (e) {
            console.warn("Failed loading state.json:", e);
            return false;
        }
    }

    function getUsers() {
        try {
            const content = usersFile.text();

            if (!content || content.trim() === "")
                return [];

            const data = JSON.parse(content);

            return data.users || [];
        } catch (e) {
            console.warn("Failed loading users.json:", e);
            return [];
        }
    }

    function getSessions() {
        try {
            const content = sessionsFile.text();

            if (!content || content.trim() === "")
                return [];

            const data = JSON.parse(content);

            return data.sessions || [];
        } catch (e) {
            console.warn("Failed loading sessions.json:", e);
            return [];
        }
    }

    function validateUser() {
        const users = getUsers();

        if (users.length === 0) {
            console.warn("No users available");
            return;
        }

        const exists = users.some(user => user.username === lastSelectedUser);

        if (!exists) {
            lastSelectedUser = users[0].username;

            console.log(
                "Defaulting selected user to",
                lastSelectedUser
            );
        }
    }

    function validateSession() {
        const sessions = getSessions();

        if (sessions.length === 0) {
            console.warn("No sessions available");
            return;
        }

        const exists = sessions.some(
            session => session.exec === lastSelectedSession
        );

        if (!exists) {
            lastSelectedSession = sessions[0].exec;

            console.log(
                "Defaulting selected session to",
                lastSelectedSession
            );
        }
    }

    function initialize() {
        loadState();

        validateUser();
        validateSession();

        save();
    }

    Component.onCompleted: initialize()
}