import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import CCTV_Viewer.Themes 1.0

Dialog {
    id: renameDialog

    title: qsTr("LNG_00065")
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: 420

    leftPadding: 16
    rightPadding: 16
    topPadding: 16
    bottomPadding: 16

    property string recorderIp: ""
    property int channelId: -1
    property string originalName: ""
    property string currentCustomName: ""

    function openForUrl(cameraUrl) {
        if (opened) return;
        var u = String(cameraUrl || "").trim();
        if (u.indexOf("hikvision://") !== 0) return;
        var rest = u.substring(12);
        var slashIdx = rest.indexOf("/");
        if (slashIdx === -1) return;
        var recIp = rest.substring(0, slashIdx).trim();
        var chId = parseInt(rest.substring(slashIdx + 1));
        if (recIp === "" || isNaN(chId)) return;

        var origName = "";
        var custName = "";
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.hikvisionRecordersJson) {
            try {
                var list = JSON.parse(rootWindow.hikvisionRecordersJson);
                for (var i = 0; i < list.length; ++i) {
                    if (list[i] && list[i].ip === recIp && list[i].cameras) {
                        for (var j = 0; j < list[i].cameras.length; ++j) {
                            if (String(list[i].cameras[j].channelId) === String(chId)) {
                                origName = list[i].cameras[j].name || "";
                                custName = list[i].cameras[j].customName || "";
                                break;
                            }
                        }
                        break;
                    }
                }
            } catch (e) {}
        }

        recorderIp = recIp;
        channelId = chId;
        originalName = origName;
        currentCustomName = custName;
        customNameField.text = custName || origName || "";
        open();
        customNameField.forceActiveFocus();
        customNameField.selectAll();
    }

    function saveCustomName(newCustomName) {
        if (typeof rootWindow === "undefined" || !rootWindow) return;
        try {
            var jsonStr = rootWindow.hikvisionRecordersJson;
            if (!jsonStr) return;
            var recordersList = JSON.parse(jsonStr);
            var updated = false;
            for (var i = 0; i < recordersList.length; ++i) {
                var rec = recordersList[i];
                if (rec && rec.ip === recorderIp && rec.cameras) {
                    for (var j = 0; j < rec.cameras.length; ++j) {
                        if (String(rec.cameras[j].channelId) === String(channelId)) {
                            if (newCustomName === null || newCustomName === undefined) {
                                delete rec.cameras[j].customName;
                            } else {
                                rec.cameras[j].customName = newCustomName;
                            }
                            updated = true;
                            break;
                        }
                    }
                    if (updated) break;
                }
            }
            if (updated) {
                rootWindow.hikvisionRecordersJson = JSON.stringify(recordersList);
            }
        } catch (e) {
            console.log("[CameraRenameWindow.saveCustomName] Exception:", e);
        }
    }

    background: Rectangle {
        color: "#1c242c"
        border.color: "#2a3540"
        border.width: 1
        radius: 8
    }

    header: Rectangle {
        color: "#0f151b"
        height: 42
        implicitHeight: 42
        radius: 8

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 4
            color: "#0f151b"
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#2a3540"
        }

        Text {
            anchors.fill: parent
            anchors.leftMargin: 16
            text: renameDialog.title
            color: "#00f5d4"
            font.bold: true
            font.pixelSize: 13
            verticalAlignment: Text.AlignVCenter
        }
    }

    contentItem: ColumnLayout {
        spacing: 12

        Text {
            text: qsTr("LNG_00064").arg(renameDialog.channelId)
            color: "#cfd8dc"
            font.pixelSize: 12
        }

        Text {
            text: qsTr("LNG_00063").arg(renameDialog.originalName ? renameDialog.originalName : qsTr("LNG_00062"))
            color: "#8898a6"
            font.pixelSize: 11
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        TextField {
            id: customNameField
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            placeholderText: qsTr("LNG_00061")
            placeholderTextColor: "#5a6b7c"
            color: "white"
            font.pixelSize: 13
            selectByMouse: true
            background: Rectangle {
                color: "#0f151b"
                radius: 6
                border.color: customNameField.activeFocus ? "#ff7a00" : "#2a3540"
                border.width: 1
            }
            Keys.onReturnPressed: saveBtn.clicked()
            Keys.onEnterPressed: saveBtn.clicked()
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Button {
                text: qsTr("LNG_00060")
                Layout.preferredHeight: 32
                contentItem: Text {
                    text: parent.text
                    color: "#ff7a00"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.hovered ? "#2a3540" : "#151d24"
                    radius: 6
                    border.color: "#ff7a00"
                    border.width: 1
                }
                onClicked: {
                    renameDialog.saveCustomName(null);
                    renameDialog.accept();
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: qsTr("LNG_00677")
                Layout.preferredHeight: 32
                Layout.preferredWidth: 84
                contentItem: Text {
                    text: parent.text
                    color: "#cfd8dc"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.hovered ? "#2a3540" : "#151d24"
                    radius: 6
                    border.color: "#2a3540"
                    border.width: 1
                }
                onClicked: renameDialog.reject()
            }

            Button {
                id: saveBtn
                text: qsTr("LNG_00676")
                Layout.preferredHeight: 32
                Layout.preferredWidth: 84
                contentItem: Text {
                    text: parent.text
                    color: "#121214"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: saveBtn.pressed ? "#00c4a7" : (saveBtn.hovered ? "#2effe1" : "#00f5d4")
                    radius: 6
                }
                onClicked: {
                    var trimmed = customNameField.text.trim();
                    renameDialog.saveCustomName(trimmed === "" ? null : trimmed);
                    renameDialog.accept();
                }
            }
        }
    }
}
