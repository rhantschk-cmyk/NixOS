import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {
    id: root

    property bool launcherOpen: false
    property bool hovering: false
    property int selectedIndex: 0
    property string launcherQuery: ""
    property date now: new Date()
    readonly property int compactWidth: 142
    readonly property int expandedWidth: 402
    readonly property int launcherWidth: 640
    readonly property int surfaceWidth: launcherOpen ? launcherWidth : (hovering ? expandedWidth : compactWidth)
    readonly property int surfaceHeight: launcherOpen ? 438 : (hovering ? 58 : 40)
    readonly property var activePlayer: {
        const players = Mpris.players.values
        let fallback = null
        for (let index = 0; index < players.length; index++) {
            if (players[index].isPlaying)
                return players[index]
            if (fallback === null && ((players[index].trackTitle || "").length > 0 || players[index].canTogglePlaying))
                fallback = players[index]
        }
        return fallback
    }
    readonly property bool hasMusic: activePlayer !== null && (activePlayer.trackTitle || "").length > 0
    readonly property string clockText: Qt.formatTime(now, "HH:mm")
    readonly property string dateText: Qt.formatDate(now, "ddd, d. MMMM")

    signal launcherFocusRequested()

    function openLauncher() {
        launcherOpen = true
        selectedIndex = 0
        launcherFocusRequested()
    }

    function closeLauncher() {
        launcherOpen = false
        launcherQuery = ""
        selectedIndex = 0
    }

    function toggleLauncher() {
        if (launcherOpen)
            closeLauncher()
        else
            openLauncher()
    }

    function filteredApps() {
        const query = launcherQuery.trim().toLocaleLowerCase()
        const apps = DesktopEntries.applications.values
        return apps.filter(app => {
            if (app.noDisplay)
                return false
            if (query.length === 0)
                return true
            return app.name.toLocaleLowerCase().includes(query)
                || app.genericName.toLocaleLowerCase().includes(query)
                || app.comment.toLocaleLowerCase().includes(query)
        }).slice(0, 7)
    }

    function launchSelected() {
        const apps = filteredApps()
        if (apps.length === 0)
            return
        apps[Math.min(selectedIndex, apps.length - 1)].execute()
        closeLauncher()
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.now = new Date()
    }

    IpcHandler {
        target: "notch"

        function toggleLauncher(): void {
            root.toggleLauncher()
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData
            color: "transparent"
            exclusiveZone: 0
            aboveWindows: true
            focusable: root.launcherOpen
            implicitWidth: root.surfaceWidth
            implicitHeight: root.surfaceHeight

            anchors {
                top: true
                left: true
                right: true
            }
            margins {
                left: Math.round((panel.screen.width - root.surfaceWidth) / 2)
                right: Math.round((panel.screen.width - root.surfaceWidth) / 2)
                top: 8
            }

            Timer {
                id: focusTimer
                interval: 70
                onTriggered: launcherInput.forceActiveFocus()
            }

            Connections {
                target: root

                function onLauncherFocusRequested() {
                    focusTimer.restart()
                }
            }

            Rectangle {
                id: surface
                anchors.fill: parent
                color: "#383848"
                radius: root.launcherOpen ? 22 : 18
                border.width: 1
                border.color: "#555566"
                clip: true

                Behavior on width {
                    SpringAnimation {
                        spring: 3.2
                        damping: 0.27
                        epsilon: 0.4
                    }
                }
                Behavior on height {
                    SpringAnimation {
                        spring: 3.2
                        damping: 0.27
                        epsilon: 0.4
                    }
                }
                Behavior on radius {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#80ffffff"
                    opacity: root.hovering || root.launcherOpen ? 0.08 : 0
                    radius: parent.radius

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 160
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                HoverHandler {
                    onHoveredChanged: {
                        if (!root.launcherOpen)
                            root.hovering = hovered
                    }
                }

                Item {
                    id: header
                    width: parent.width
                    height: 58

                    TapHandler {
                        enabled: !root.launcherOpen && !root.hasMusic
                        onTapped: root.openLauncher()
                    }

                    Item {
                        id: primaryContent
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.right: header.right
                        anchors.rightMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                        height: 28
                        clip: true
                        opacity: root.hovering && !root.launcherOpen ? 0 : 1

                        Text {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -3
                            visible: !root.hasMusic
                            color: "#f0eef8"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            text: root.clockText
                        }

                        Text {
                            id: primaryText
                            anchors.verticalCenter: parent.verticalCenter
                            visible: root.hasMusic
                            color: "#f0eef8"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            text: root.hasMusic ? root.activePlayer.trackTitle : ""
                            property real travel: Math.max(0, implicitWidth - primaryContent.width)

                            SequentialAnimation on x {
                                id: marquee
                                running: root.hasMusic
                                    && !root.hovering
                                    && !root.launcherOpen
                                    && primaryText.travel > 2
                                loops: Animation.Infinite

                                PauseAnimation { duration: 1200 }
                                NumberAnimation {
                                    to: -primaryText.travel
                                    duration: Math.max(1800, primaryText.travel * 28)
                                    easing.type: Easing.InOutSine
                                }
                                PauseAnimation { duration: 900 }
                                NumberAnimation {
                                    to: 0
                                    duration: Math.max(900, primaryText.travel * 14)
                                    easing.type: Easing.OutCubic
                                }
                            }

                            onTextChanged: {
                                if (marquee.running)
                                    marquee.restart()
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        visible: !root.hasMusic
                        opacity: root.hovering && !root.launcherOpen && !root.hasMusic ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 140
                                easing.type: Easing.OutCubic
                            }
                        }

                        Text {
                            color: "#d8d4e8"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: root.dateText
                        }

                        Rectangle {
                            width: 4
                            height: 4
                            radius: 2
                            color: "#a8a4bd"
                        }

                        Text {
                            color: "#d8d4e8"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            text: "Alt + Space"
                        }
                    }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        visible: root.hasMusic
                        opacity: root.hovering && !root.launcherOpen && root.hasMusic ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 140
                                easing.type: Easing.OutCubic
                            }
                        }

                        Text {
                            color: "#d8d4e8"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            elide: Text.ElideRight
                            Layout.maximumWidth: 155
                            text: `${root.activePlayer.trackArtist} — ${root.activePlayer.trackTitle}`
                        }

                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 28
                            radius: 9
                            color: root.activePlayer.canGoPrevious ? "#4a4a5d" : "#3f3f4e"
                            opacity: root.activePlayer.canGoPrevious ? 1 : 0.42

                            Text {
                                anchors.centerIn: parent
                                color: "#f0eef8"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 15
                                text: "⏮"
                            }

                            TapHandler {
                                enabled: root.activePlayer.canGoPrevious
                                onTapped: root.activePlayer.previous()
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 34
                            Layout.preferredHeight: 32
                            radius: 10
                            color: root.activePlayer.canTogglePlaying ? "#aaa0d6" : "#4a4a5d"
                            opacity: root.activePlayer.canTogglePlaying ? 1 : 0.42

                            Text {
                                anchors.centerIn: parent
                                color: root.activePlayer.canTogglePlaying ? "#292735" : "#f0eef8"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 16
                                text: root.activePlayer.isPlaying ? "⏸" : "▶"
                            }

                            TapHandler {
                                enabled: root.activePlayer.canTogglePlaying
                                onTapped: root.activePlayer.togglePlaying()
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 28
                            radius: 9
                            color: root.activePlayer.canGoNext ? "#4a4a5d" : "#3f3f4e"
                            opacity: root.activePlayer.canGoNext ? 1 : 0.42

                            Text {
                                anchors.centerIn: parent
                                color: "#f0eef8"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 15
                                text: "⏭"
                            }

                            TapHandler {
                                enabled: root.activePlayer.canGoNext
                                onTapped: root.activePlayer.next()
                            }
                        }
                    }
                }

                Item {
                    id: launcher
                    anchors.top: header.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 12
                    visible: root.launcherOpen
                    opacity: root.launcherOpen ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutCubic
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "#2d2d3a"
                        radius: 13
                        border.width: 1
                        border.color: "#5c5c70"
                    }

                    TextField {
                        id: launcherInput
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 12
                        height: 42
                        color: "#f2f0f8"
                        placeholderText: "Apps suchen …"
                        placeholderTextColor: "#a7a4b5"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        selectByMouse: true
                        text: root.launcherQuery

                        background: Rectangle {
                            color: "#383848"
                            radius: 9
                            border.width: 1
                            border.color: launcherInput.activeFocus ? "#a9a0d5" : "#5c5c70"

                            Behavior on border.color {
                                ColorAnimation { duration: 140 }
                            }
                        }

                        onTextEdited: {
                            root.launcherQuery = text
                            root.selectedIndex = 0
                        }
                        Keys.onEscapePressed: root.closeLauncher()
                        Keys.onReturnPressed: root.launchSelected()
                        Keys.onDownPressed: root.selectedIndex = Math.min(root.selectedIndex + 1, Math.max(0, root.filteredApps().length - 1))
                        Keys.onUpPressed: root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
                    }

                    ListView {
                        id: results
                        anchors.top: launcherInput.bottom
                        anchors.topMargin: 8
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        clip: true
                        spacing: 5
                        model: root.filteredApps()

                        delegate: Rectangle {
                            required property var modelData
                            required property int index
                            width: results.width
                            height: 42
                            radius: 9
                            color: root.selectedIndex === index ? "#4a4a5d" : "transparent"

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 13
                                anchors.right: parent.right
                                anchors.rightMargin: 13
                                anchors.verticalCenter: parent.verticalCenter
                                color: "#edeaf5"
                                elide: Text.ElideRight
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 13
                                text: modelData.name
                            }

                            TapHandler {
                                onTapped: {
                                    modelData.execute()
                                    root.closeLauncher()
                                }
                            }

                            HoverHandler {
                                onHoveredChanged: {
                                    if (hovered)
                                        root.selectedIndex = index
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
