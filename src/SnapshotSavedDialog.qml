import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: rootOverlay
    anchors.centerIn: parent
    width: parent ? Math.min(parent.width - 24, 380) : 380
    height: contentColumn.implicitHeight + 24
    visible: false

    property string filePath: ""

    function open() {
        visible = true;
        autoCloseTimer.restart();
    }

    function close() {
        visible = false;
        autoCloseTimer.stop();
    }

    // Block mouse clicks/hovers from passing through to the video viewport underneath
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {}
    }

    Timer {
        id: autoCloseTimer
        interval: 10000 // 10 seconds auto-dismiss
        repeat: false
        onTriggered: rootOverlay.close()
    }

    Rectangle {
        anchors.fill: parent
        color: "#1c242c"
        border.color: "#00f5d4"
        border.width: 1.5
        radius: 8
    }

    ColumnLayout {
        id: contentColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Image {
                source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2300f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z'></path><circle cx='12' cy='13' r='4'></circle></svg>"
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: qsTr("LNG_00457")
                color: "#00f5d4"
                font.bold: true
                font.pixelSize: 12
                Layout.fillWidth: true
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#2a3540"
        }

        // Content Path Text
        Text {
            text: qsTr("LNG_00456") + rootOverlay.filePath
            color: "white"
            font.pixelSize: 11
            wrapMode: Text.WrapAnywhere
            Layout.fillWidth: true
            maximumLineCount: 2
            elide: Text.ElideMiddle
        }

        // Action Buttons Footer
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Item { Layout.fillWidth: true }

            Button {
                id: browseBtn
                text: qsTr("LNG_00455")
                Layout.preferredWidth: 90
                Layout.preferredHeight: 28

                contentItem: Text {
                    text: browseBtn.text
                    font.bold: true
                    color: "#1c242c" // High-contrast dark grey/black text on bright seledyn background
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: browseBtn.pressed ? "#00ccb0" : (browseBtn.hovered ? "#00ffd8" : "#00f5d4")
                    radius: 4
                }
                onClicked: {
                    var folderPath = rootOverlay.filePath.substring(0, rootOverlay.filePath.lastIndexOf("/"));
                    if (folderPath !== "") {
                        Qt.openUrlExternally("file://" + folderPath);
                    }
                    rootOverlay.close();
                }
            }

            Button {
                id: exitBtn
                text: qsTr("LNG_00454")
                Layout.preferredWidth: 70
                Layout.preferredHeight: 28

                contentItem: Text {
                    text: exitBtn.text
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: exitBtn.pressed ? "#2a3540" : (exitBtn.hovered ? "#3a4550" : "#222c36")
                    radius: 4
                    border.color: "#2a3540"
                    border.width: 1
                }
                onClicked: rootOverlay.close()
            }
        }
    }
}
