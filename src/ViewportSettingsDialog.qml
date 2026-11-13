import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import CCTV_Viewer.Utils 1.0

Dialog {
    id: viewportSettingsDialog
    title: qsTr("LNG_00463")
    modal: true
    anchors.centerIn: parent
    width: 420

    leftPadding: 16
    rightPadding: 16
    topPadding: 16
    bottomPadding: 16

    property int index: -1
    property bool isRemoteRecorderViewport: false

    function findRecorderForUrl(urlStr) {
        var s = String(urlStr || "").trim();
        var schemeIdx = s.indexOf("://");
        if (schemeIdx === -1) return null;
        var rest = s.substring(schemeIdx + 3);
        var slashIdx = rest.indexOf("/");
        var addrPart = slashIdx !== -1 ? rest.substring(0, slashIdx) : rest;
        var atIdx = addrPart.lastIndexOf("@");
        var hostPort = atIdx !== -1 ? addrPart.substring(atIdx + 1) : addrPart;
        var vpIp = (hostPort.split(":")[0] || "").trim();
        if (vpIp === "" || typeof rootWindow === "undefined" || !rootWindow || !rootWindow.hikvisionRecordersJson) {
            return null;
        }
        try {
            var recordersList = JSON.parse(rootWindow.hikvisionRecordersJson);
            for (var i = 0; i < recordersList.length; ++i) {
                var recIp = String(recordersList[i].ip || "").trim();
                if (recIp === vpIp || recIp.split(":")[0] === vpIp) {
                    return recordersList[i];
                }
            }
        } catch (e) {}
        return null;
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

        // Prevent bottom corners from rounding in the header
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
            text: viewportSettingsDialog.title + (index >= 0 ? " #" + (index + 1) : "")
            color: "#00f5d4"
            font.bold: true
            font.pixelSize: 13
            verticalAlignment: Text.AlignVCenter
        }
    }

    onVisibleChanged: {
        if (visible) {
            loadSettings();
        }
    }

    contentItem: ColumnLayout {
        spacing: 16

        // Camera Streams Configuration
        GroupBox {
            title: qsTr("LNG_00305")
            Layout.fillWidth: true

            background: Rectangle {
                color: "#141a21"
                border.color: "#2a3540"
                border.width: 1
                radius: 8
            }
            label: Text {
                text: parent.title
                color: "#00f5d4"
                font.bold: true
                font.pixelSize: 12
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("LNG_00304")
                        color: "#8898a6"
                        font.pixelSize: 11
                    }
                    TextField {
                        id: primaryUrlField
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        font.pixelSize: 12
                        placeholderText: "rtsp://..."
                        onTextChanged: {
                            var rec = viewportSettingsDialog.findRecorderForUrl(text);
                            viewportSettingsDialog.isRemoteRecorderViewport = !!(rec && rec.remoteRecorder);
                        }
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: primaryUrlField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                    }
                }

                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("LNG_00303")
                        color: "#8898a6"
                        font.pixelSize: 11
                    }
                    TextField {
                        id: secondaryUrlField
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        font.pixelSize: 12
                        placeholderText: "rtsp://..."
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: secondaryUrlField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                    }
                }
            }
        }

        // Channel Viewport Settings
        GroupBox {
            title: qsTr("LNG_00462")
            Layout.fillWidth: true

            background: Rectangle {
                color: "#141a21"
                border.color: "#2a3540"
                border.width: 1
                radius: 8
            }
            label: Text {
                text: parent.title
                color: "#00f5d4"
                font.bold: true
                font.pixelSize: 12
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    Label {
                        text: qsTr("LNG_00461")
                        color: "#8898a6"
                        font.pixelSize: 11
                    }

                    TextField {
                        id: channelAVFormatOptions
                        selectByMouse: true
                        enabled: !viewportSettingsDialog.isRemoteRecorderViewport
                        Layout.fillWidth: true
                        color: enabled ? "white" : "#7c8b99"
                        font.pixelSize: 12
                        background: Rectangle {
                            color: channelAVFormatOptions.enabled ? "#0f151b" : "#12171d"
                            radius: 4
                            border.color: channelAVFormatOptions.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                    }

                    Text {
                        visible: viewportSettingsDialog.isRemoteRecorderViewport
                        text: qsTr("LNG_00584")
                        color: "#00f5d4"
                        font.pixelSize: 10
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }

                    CheckBox {
                        id: channelIgnoreGlobalAVFormatOptions
                        text: qsTr("LNG_00460")
                        enabled: !viewportSettingsDialog.isRemoteRecorderViewport
                        checked: false
                        opacity: enabled ? 1.0 : 0.45
                        contentItem: Text {
                            text: channelIgnoreGlobalAVFormatOptions.text
                            font.pixelSize: 12
                            color: "#8898a6"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: channelIgnoreGlobalAVFormatOptions.indicator.width + channelIgnoreGlobalAVFormatOptions.spacing
                        }
                    }
                }
            }
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

            Item { Layout.fillWidth: true }

            Button {
                id: cancelBtn
                text: qsTr("LNG_00059")
                Layout.preferredWidth: 80
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
                onClicked: viewportSettingsDialog.reject()
            }

            Button {
                id: confirmBtn
                text: qsTr("LNG_00058")
                Layout.preferredWidth: 80
                Layout.preferredHeight: 30

                contentItem: Text {
                    text: confirmBtn.text
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: confirmBtn.pressed ? "#00ccb0" : (confirmBtn.hovered ? "#00ffd8" : "#00f5d4")
                    radius: 4
                }
                onClicked: {
                    saveSettings();
                    viewportSettingsDialog.accept();
                }
            }
        }
    }

    function loadSettings() {
        if (index >= 0) {
            var item = Utils.currentModel().get(index);
            if (item) {
                primaryUrlField.text = item.url;
                secondaryUrlField.text = item.secondaryUrl;

                var rec = findRecorderForUrl(item.url);
                isRemoteRecorderViewport = !!(rec && rec.remoteRecorder);

                var options = {};
                if (isRemoteRecorderViewport) {
                    var wanTransport = (rec && (rec.rtspTransport === "tcp" || rec.rtspTransport === "udp")) ? rec.rtspTransport : "tcp";
                    options = {
                        "analyzeduration": 3000000,
                        "probesize": 2000000,
                        "timeout": 15000000,
                        "rw_timeout": 15000000,
                        "demuxer_timeout": 20000000,
                        "flags": "low_delay",
                        "rtsp_transport": wanTransport
                    };
                } else {
                    options = Object.assign({}, item.avFormatOptions);
                    if (Object.keys(options).length === 0) {
                        options = layoutsCollectionSettings.toJSValue("defaultAVFormatOptions");
                    }
                    if (rec) {
                        var transport = rec.rtspTransport || "";
                        if (transport === "tcp" || transport === "udp") {
                            options["rtsp_transport"] = transport;
                        }
                    }
                }

                channelAVFormatOptions.text = Utils.stringifyOptions(options);
                channelIgnoreGlobalAVFormatOptions.checked = item.ignoreGlobalAVFormatOptions;
            } else {
                isRemoteRecorderViewport = false;
                primaryUrlField.text = "";
                secondaryUrlField.text = "";
                channelAVFormatOptions.text = "";
                channelIgnoreGlobalAVFormatOptions.checked = false;
            }
        } else {
            isRemoteRecorderViewport = false;
            primaryUrlField.text = "";
            secondaryUrlField.text = "";
            channelAVFormatOptions.text = "";
            channelIgnoreGlobalAVFormatOptions.checked = false;
        }
    }

    function saveSettings() {
        if (index >= 0) {
            var item = Utils.currentModel().get(index);
            if (item) {
                item.url = primaryUrlField.text;
                item.secondaryUrl = secondaryUrlField.text;

                if (isRemoteRecorderViewport) {
                    item.avFormatOptions = {};
                    item.ignoreGlobalAVFormatOptions = false;
                    return;
                }

                var options = Utils.parseOptions(channelAVFormatOptions.text);
                var defaultOpts = layoutsCollectionSettings.toJSValue("defaultAVFormatOptions");
                var identical = true;
                if (Object.keys(options).length === Object.keys(defaultOpts).length) {
                    for (var key in options) {
                        if (defaultOpts[key] === undefined || String(defaultOpts[key]) !== String(options[key])) {
                            identical = false;
                            break;
                        }
                    }
                } else {
                    identical = false;
                }
                item.avFormatOptions = identical ? {} : options;
                item.ignoreGlobalAVFormatOptions = channelIgnoreGlobalAVFormatOptions.checked;
            }
        }
    }
}
