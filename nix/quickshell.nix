{ config, pkgs, ... }:

{
  programs.quickshell.enable = true;
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    import Quickshell.Hyprland
    import QtQuick
    import QtQuick.Layouts

    ShellRoot {
        id: root

        // Theme colors
        property color colBg: "#1a1b26"
        property color colFg: "#a9b1d6"
        property color colMuted: "#444b6a"
        property color colCyan: "#0db9d7"
        property color colPurple: "#ad8ee6"
        property color colRed: "#f7768e"
        property color colYellow: "#e0af68"
        property color colBlue: "#7aa2f7"

        // Font
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14

        // System info properties
        property string kernelVersion: "Linux"
        property int cpuUsage: 0
        property int memUsage: 0
        property int diskUsage: 0
        property int volumeLevel: 0
        property string activeWindow: "Window"
        property string currentLayout: "Tile"

        // CPU tracking
        property var lastCpuIdle: 0
        property var lastCpuTotal: 0

        // Kernel version
        Process {
            id: kernelProc
            command: ["uname", "-r"]
            stdout: SplitParser {
                onRead: data => {
                    if (data) kernelVersion = data.trim()
                }
            }
            Component.onCompleted: running = true
        }

        // CPU usage
        Process {
            id: cpuProc
            command: ["sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var parts = data.trim().split(/\s+/)
                    var user = parseInt(parts[1]) || 0
                    var nice = parseInt(parts[2]) || 0
                    var system = parseInt(parts[3]) || 0
                    var idle = parseInt(parts[4]) || 0
                    var iowait = parseInt(parts[5]) || 0
                    var irq = parseInt(parts[6]) || 0
                    var softirq = parseInt(parts[7]) || 0

                    var total = user + nice + system + idle + iowait + irq + softirq
                    var idleTime = idle + iowait

                    if (lastCpuTotal > 0) {
                        var totalDiff = total - lastCpuTotal
                        var idleDiff = idleTime - lastCpuIdle
                        if (totalDiff > 0) {
                            cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                        }
                    }
                    lastCpuTotal = total
                    lastCpuIdle = idleTime
                }
            }
            Component.onCompleted: running = true
        }

        // Disk usage
        Process {
            id: diskProc
            command: ["sh", "-c", "df / | tail -1"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var parts = data.trim().split(/\s+/)
                    var percentStr = parts[4] || "0%"
                    diskUsage = parseInt(percentStr) || 0
                }
            }
            Component.onCompleted: running = true
        }

        // Volume level (wpctl for PipeWire)
        Process {
            id: volProc
            command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var match = data.match(/Volume:\s*([\d.]+)/)
                    if (match) {
                        volumeLevel = Math.round(parseFloat(match[1]) * 100)
                    }
                }
            }
            Component.onCompleted: running = true
        }

        // Active window title
        Process {
            id: windowProc
            command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
            stdout: SplitParser {
                onRead: data => {
                    if (data && data.trim()) {
                        activeWindow = data.trim()
                    }
                }
            }
            Component.onCompleted: running = true
        }

        // Current layout (Hyprland: dwindle/master/floating)
        Process {
            id: layoutProc
            command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
            stdout: SplitParser {
                onRead: data => {
                    if (data && data.trim()) {
                        currentLayout = data.trim()
                    }
                }
            }
            Component.onCompleted: running = true
        }

        // Slow timer for system stats
        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                cpuProc.running = true
                diskProc.running = true
                volProc.running = true
            }
        }

        // Event-based updates for window/layout (instant)
        Connections {
            target: Hyprland
            function onRawEvent(event) {
                windowProc.running = true
                layoutProc.running = true
            }
        }

        // Backup timer for window/layout (catches edge cases)
        Timer {
            interval: 200
            running: true
            repeat: true
            onTriggered: {
                windowProc.running = true
                layoutProc.running = true
            }
        }

        Variants {
            model: Quickshell.screens

            PanelWindow {
                property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: 30
                color: root.colBg

                margins {
                    top: 0
                    bottom: 0
                    left: 0
                    right: 0
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.colBg

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item { width: 8 }

                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            color: "transparent"

                            Image {
                                anchors.fill: parent
                                source: "file:///home/raphael/.config/quickshell/icons/tonybtw.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Item { width: 8 }

                        Repeater {
                            model: 9

                            Rectangle {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: parent.height
                                color: "transparent"

                                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                                property bool hasWindows: workspace !== null

                                Text {
                                    text: index + 1
                                    color: parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted)
                                    font.pixelSize: root.fontSize
                                    font.family: root.fontFamily
                                    font.bold: true
                                    anchors.centerIn: parent
                                }

                                Rectangle {
                                    width: 20
                                    height: 3
                                    color: parent.isActive ? root.colPurple : root.colBg
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 8
                            Layout.rightMargin: 8
                            color: root.colMuted
                        }

                        Text {
                            text: currentLayout
                            color: root.colFg
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.leftMargin: 5
                            Layout.rightMargin: 5
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 2
                            Layout.rightMargin: 8
                            color: root.colMuted
                        }

                        Text {
                            text: activeWindow
                            color: root.colPurple
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.leftMargin: 8
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        Text {
                            text: kernelVersion
                            color: root.colRed
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 0
                            Layout.rightMargin: 8
                            color: root.colMuted
                        }

                        Text {
                            text: "CPU: " + cpuUsage + "%"
                            color: root.colYellow
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 0
                            Layout.rightMargin: 8
                            color: root.colMuted
                        }

                        Text {
                            text: "Disk: " + diskUsage + "%"
                            color: root.colBlue
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 0
                            Layout.rightMargin: 8
                            color: root.colMuted
                        }

                        Text {
                            text: "Vol: " + volumeLevel + "%"
                            color: root.colPurple
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 0
                            Layout.rightMargin: 8
                            color: root.colMuted
                        }

                        Text {
                            id: clockText
                            text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                            color: root.colCyan
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                            }
                        }

                        Item { width: 8 }
                    }
                }
            }
        }
        // Notifications laden
        Notifications {}
    }
  '';

  xdg.configFile."quickshell/Notifications.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Services.Notifications
    import QtQuick
    import QtQuick.Layouts
    
    import "config.js" as Config
    
    Scope {
        id: root
    
        NotificationServer {
            id: server
            actionsSupported: true
            bodySupported: true
            imageSupported: true
    
            onNotification: n => n.tracked = true
        }
    
        PanelWindow {
            anchors { top: true; right: true }
            margins { top: 40; right: 12 } // 40px Abstand, damit es unter deiner Bar liegt
    
            implicitWidth: 380
            implicitHeight: column.implicitHeight
            color: "transparent"
    
            exclusionMode: ExclusionMode.Ignore
    
            ColumnLayout {
                id: column
                width: parent.width
                spacing: 10
    
                Repeater {
                    model: server.trackedNotifications
    
                    delegate: Rectangle {
                        id: card
                        required property var modelData
    
                        Layout.fillWidth: true
                        implicitHeight: contentLayout.implicitHeight + 20
                        radius: 8
                        color: Config.colors.bg
                        border.width: 2
                        border.color: modelData.urgency === NotificationUrgency.Critical
                            ? Config.colors.red : Config.colors.purple
    
                        // Klick zum Schließen der Benachrichtigung
                        MouseArea {
                            anchors.fill: parent
                            onClicked: card.modelData.dismiss()
                        }
    
                        RowLayout {
                            id: contentLayout
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                margins: 10
                            }
                            spacing: 10
    
                            // App-Icon / Bild anzeigen
                            Image {
                                visible: card.modelData.image !== ""
                                source: card.modelData.image
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 36
                                Layout.alignment: Qt.AlignTop
                                fillMode: Image.PreserveAspectFit
                            }
    
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
    
                                Text {
                                    text: card.modelData.summary
                                    color: Config.colors.cyan
                                    font.bold: true
                                    font.pixelSize: 14
                                    font.family: Config.bar.fontFamily
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
    
                                Text {
                                    text: card.modelData.body
                                    color: Config.colors.fg
                                    font.pixelSize: 12
                                    font.family: Config.bar.fontFamily
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                    visible: card.modelData.body !== ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    '';
}
