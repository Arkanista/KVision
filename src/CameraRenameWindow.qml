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
    property string recorderName: ""
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

        var recName = recIp;
        var origName = "";
        var custName = "";
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.hikvisionRecordersJson) {
            try {
                var list = JSON.parse(rootWindow.hikvisionRecordersJson);
                for (var i = 0; i < list.length; ++i) {
                    if (list[i] && list[i].ip === recIp && list[i].cameras) {
                        recName = (list[i].name && String(list[i].name).trim() !== "") ? String(list[i].name).trim() : recIp;
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
        recorderName = recName;
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
        spacing: 10

        Text {
            text: (renameDialog.recorderName ? (renameDialog.recorderName + "  •  ") : "") + qsTr("LNG_00064").arg(renameDialog.channelId)
            color: "#cfd8dc"
            font.pixelSize: 12
            font.bold: true
            elide: Text.ElideRight
            Layout.fillWidth: true
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
    }

    footer: Rectangle {
        implicitHeight: 48
        color: "#0f151b"
        border.color: "#2a3540"
        border.width: 1
        radius: 8

        // Round only bottom corners
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 1
            height: 4
            color: "#0f151b"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Button {
                id: resetBtn
                text: qsTr("LNG_00060")
                leftPadding: 14
                rightPadding: 14
                Layout.preferredHeight: 30
                Layout.minimumWidth: 84
                contentItem: Text {
                    text: resetBtn.text
                    color: "#ff7a00"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: resetBtn.pressed ? "#2a3540" : (resetBtn.hovered ? "#3a4550" : "#222c36")
                    radius: 4
                    border.color: "#ff7a00"
                    border.width: 1
                }
                onClicked: {
                    customNameField.text = renameDialog.originalName || "";
                    customNameField.forceActiveFocus();
                    customNameField.selectAll();
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                id: cancelBtn
                text: qsTr("LNG_00677")
                leftPadding: 14
                rightPadding: 14
                Layout.minimumWidth: 84
                Layout.preferredHeight: 30
                contentItem: Text {
                    text: cancelBtn.text
                    font.bold: true
                    color: cancelBtn.pressed ? "#8898a6" : "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: cancelBtn.pressed ? "#2a3540" : (cancelBtn.hovered ? "#3a4550" : "#222c36")
                    radius: 4
                    border.color: "#2a3540"
                }
                onClicked: renameDialog.reject()
            }

            Button {
                id: saveBtn
                text: qsTr("LNG_00676")
                leftPadding: 14
                rightPadding: 14
                Layout.minimumWidth: 84
                Layout.preferredHeight: 30
                contentItem: Text {
                    text: saveBtn.text
                    font.bold: true
                    color: "#121214"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: saveBtn.pressed ? "#00ccb0" : (saveBtn.hovered ? "#00ffd8" : "#00f5d4")
                    radius: 4
                }
                onClicked: {
                    var trimmed = customNameField.text.trim();
                    var shouldClear = (trimmed === "" || trimmed === renameDialog.originalName);
                    renameDialog.saveCustomName(shouldClear ? null : trimmed);
                    renameDialog.accept();
                }
            }
        }
    }
}
