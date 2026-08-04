import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import CCTV_Viewer.Hikvision 1.0
import CCTV_Viewer.Utils 1.0
import CCTV_Viewer.Themes 1.0

ColumnLayout {
    id: rootPanel

    spacing: 12
    Layout.fillWidth: true
    Layout.margins: 10

    // Persist active recorders in application settings as JSON
    // Format: [{"ip":"...", "port":8000, "username":"...", "password":"...", "cameras":[{"channelId":1, "name":"..."}]}]
    property var recorders: []

    // Map of active session IPs (IP -> bool)
    property var activeSessionIps: ({})

    // Live UX feedback state
    property string statusMessage: ""
    property string statusColor: "#ff7a00"

    // Track NVR editing state
    property int editingIndex: -1
    property bool isDiscovering: false

    // ── NvrCamerasWindow Component ──────────────────────────────────────
    // Declared here (outside the Repeater) so its QML creation context
    // belongs to rootPanel, NOT to any Repeater delegate.  When the
    // Repeater rebuilds its delegates (e.g. after loadRecorders()),
    // already-opened NvrCamerasWindow instances keep a valid context
    // because rootPanel is never destroyed.
    Component {
        id: nvrCamerasWindowComponent
        NvrCamerasWindow {}
    }

    function openCamerasWindow(recorderData) {
        var win = nvrCamerasWindowComponent.createObject(rootWindow);
        win.recorder = JSON.parse(JSON.stringify(recorderData));
        win.show();
    }

    Component.onCompleted: {
        loadRecorders();
    }

    Connections {
        target: rootWindow
        function onHikvisionRecordersJsonChanged() {
            rootPanel.loadRecorders();
        }
    }

    Connections {
        target: HikvisionManager
        function onSessionStatusChanged(ip, loggedIn) {
            var states = Object.assign({}, rootPanel.activeSessionIps);
            states[ip] = loggedIn;
            rootPanel.activeSessionIps = states;
        }

        function onDiscoveryFinished(ip, cameras, success, errorMsg) {
            if (!rootPanel.isDiscovering) return;
            rootPanel.isDiscovering = false;

            if (!success) {
                rootPanel.statusColor = "#ff3333";
                rootPanel.statusMessage = errorMsg || qsTr("LNG_00099");
                return;
            }

            var sdkP = parseInt(portField.text) || 8000;
            var httpP = parseInt(httpPortField.text) || 80;
            var rtspP = parseInt(rtspPortField.text) || 554;
            var rtspTransport = rtspTransportField.currentText === "TCP" ? "tcp" : (rtspTransportField.currentText === "UDP" ? "udp" : "");

            var newRecorder = {
                name: nameField.text.trim(),
                ip: ip,
                port: sdkP,
                sdkPort: sdkP,
                httpPort: httpP,
                rtspPort: rtspP,
                username: userField.text.trim(),
                password: passField.text,
                cameras: cameras,
                rtspTransport: rtspTransport
            };

            if (rootPanel.editingIndex === -1) {
                // ADD MODE
                var arr = rootPanel.recorders.slice();
                // Check if already added
                for (var idx = 0; idx < arr.length; idx++) {
                    if (arr[idx].ip === ip) {
                        arr.splice(idx, 1); // overwrite
                        break;
                    }
                }

                arr.push(newRecorder);
                rootPanel.recorders = arr;
                saveRecorders();

                // Generate a dynamic preset layout containing all discovered cameras
                var numCams = cameras.length;
                var gridSize = Math.ceil(Math.sqrt(numCams));
                
                var newLayout = layoutsCollectionModel.append();
                newLayout.size = Qt.size(gridSize, gridSize);
                newLayout.isNvr = true;
                newLayout.nvrIp = ip;

                for (var i = 0; i < numCams; ++i) {
                    var vp = newLayout.get(i);
                    if (vp) {
                        // Store Hikvision URI
                        vp.url = "hikvision://" + newRecorder.username + ":" + newRecorder.password + "@" + newRecorder.ip + ":" + newRecorder.port + "/" + cameras[i].channelId;
                        vp.secondaryUrl = vp.url;
                        vp.volume = 0;
                    }
                }

                // Force navigation to the newly created preset!
                stackLayout.currentIndex = layoutsCollectionModel.count - 1;

            } else {
                // EDIT MODE
                var arr2 = rootPanel.recorders.slice();
                var oldIp = arr2[rootPanel.editingIndex].ip;
                arr2[rootPanel.editingIndex] = newRecorder;
                rootPanel.recorders = arr2;
                saveRecorders();

                // Update corresponding NVR view layout and any custom layouts
                for (var j = 0; j < layoutsCollectionModel.count; ++j) {
                    var l = layoutsCollectionModel.get(j);
                    if (l && l.isNvr && l.nvrIp === oldIp) {
                        l.nvrIp = newRecorder.ip;
                        var numCams2 = cameras.length;
                        var gridSize2 = Math.ceil(Math.sqrt(numCams2));
                        l.size = Qt.size(gridSize2, gridSize2);

                        for (var k = 0; k < numCams2; ++k) {
                            var vp2 = l.get(k);
                            if (vp2) {
                                var newUrl = "hikvision://" + newRecorder.username + ":" + newRecorder.password + "@" + newRecorder.ip + ":" + newRecorder.port + "/" + cameras[k].channelId;
                                if (vp2.url === newUrl) {
                                    vp2.url = ""; // force refresh in case only RTSP/HTTP ports changed
                                }
                                vp2.url = newUrl;
                                vp2.secondaryUrl = vp2.url;
                                vp2.volume = 0;
                            }
                        }
                    } else if (l && !l.isNvr) {
                        // Update any standalone viewports in custom layouts
                        for (var k2 = 0; k2 < l.count; ++k2) {
                            var vp = l.get(k2);
                            if (vp && vp.url && vp.url.indexOf("hikvision://") !== -1) {
                                var uriStr = String(vp.url);
                                var idx = uriStr.indexOf("hikvision://");
                                var content = uriStr.substring(idx + 12);
                                var parts = content.split("/");
                                var mainPart = parts[0];
                                var addrParts = mainPart.split("@");
                                var addrPort = (addrParts.length > 1) ? addrParts[1] : addrParts[0];
                                var ipPort = addrPort.split(":");
                                var vpIp = ipPort[0] || "";

                                if (vpIp === oldIp) {
                                    var chanId = parts.length > 1 ? parts[1] : "1";
                                    var newUrl2 = "hikvision://" + newRecorder.username + ":" + newRecorder.password + "@" + newRecorder.ip + ":" + newRecorder.port + "/" + chanId;
                                    if (vp.url === newUrl2) {
                                        vp.url = ""; // force refresh
                                    }
                                    vp.url = newUrl2;
                                    if (String(vp.secondaryUrl).indexOf("hikvision://") !== -1) {
                                        vp.secondaryUrl = newUrl2;
                                    }
                                }
                            }
                        }
                    }
                }
                rootPanel.editingIndex = -1;
            }

            // Clear fields & status
            nameField.text = "";
            ipField.text = "";
            portField.text = "8000";
            httpPortField.text = "80";
            rtspPortField.text = "554";
            userField.text = "admin";
            passField.text = "";
            rtspTransportField.currentIndex = 0;
            rootPanel.statusMessage = "";
        }
    }

    function initializeActiveSessions() {
        var states = {};
        for (var i = 0; i < recorders.length; i++) {
            var ip = recorders[i].ip;
            states[ip] = HikvisionManager.isLogged(ip);
        }
        activeSessionIps = states;
    }

    function loadRecorders() {
        try {
            var data = rootWindow.hikvisionRecordersJson;
            if (data) {
                recorders = JSON.parse(data);
            } else {
                recorders = [];
            }
            initializeActiveSessions();
        } catch(e) {
            console.log("[Hikvision QML Error] Failed to load recorders:", e);
            recorders = [];
        }
    }

    function saveRecorders() {
        try {
            rootWindow.hikvisionRecordersJson = JSON.stringify(recorders);
        } catch(e) {
            console.log("[Hikvision QML Error] Failed to save recorders:", e);
        }
    }

    Text {
        text: qsTr("LNG_00098")
        color: "white"
        font {
            pixelSize: 13
            bold: true
        }
        Layout.fillWidth: true
    }

    Frame {
        Layout.fillWidth: true
        background: Rectangle {
            color: "#1c242c"
            radius: 6
            border.color: "#2a3540"
            border.width: 1
        }

        ColumnLayout {
            width: parent.width
            spacing: 8
            enabled: !rootPanel.isDiscovering

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: qsTr("LNG_00097")
                    color: "#8898a6"
                    font.pixelSize: 10
                }

                TextField {
                    id: nameField
                    placeholderText: qsTr("LNG_00097")
                    selectByMouse: true
                    Layout.fillWidth: true
                    color: "white"
                    background: Rectangle {
                        color: "#0f151b"
                        radius: 4
                        border.color: nameField.activeFocus ? "#ff7a00" : "#2a3540"
                    }
                    onTextChanged: rootPanel.statusMessage = ""
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: qsTr("LNG_00096")
                    color: "#8898a6"
                    font.pixelSize: 10
                }

                TextField {
                    id: ipField
                    placeholderText: "192.168.1.100"
                    selectByMouse: true
                    Layout.fillWidth: true
                    color: "white"
                    background: Rectangle {
                        color: "#0f151b"
                        radius: 4
                        border.color: ipField.activeFocus ? "#ff7a00" : "#2a3540"
                    }
                    onTextChanged: rootPanel.statusMessage = ""
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("LNG_00532")
                        color: "#8898a6"
                        font.pixelSize: 10
                    }

                    TextField {
                        id: portField
                        placeholderText: "8000"
                        text: "8000"
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: portField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                        onTextChanged: rootPanel.statusMessage = ""
                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: portField.hovered
                        ToolTip.text: "SDK / Server Port (default 8000)"
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("LNG_00533")
                        color: "#8898a6"
                        font.pixelSize: 10
                    }

                    TextField {
                        id: httpPortField
                        placeholderText: "80"
                        text: "80"
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: httpPortField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                        onTextChanged: rootPanel.statusMessage = ""
                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: httpPortField.hovered
                        ToolTip.text: "HTTP / ISAPI Port (default 80)"
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("LNG_00534")
                        color: "#8898a6"
                        font.pixelSize: 10
                    }

                    TextField {
                        id: rtspPortField
                        placeholderText: "554"
                        text: "554"
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: rtspPortField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                        onTextChanged: rootPanel.statusMessage = ""
                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: rtspPortField.hovered
                        ToolTip.text: "RTSP Port (default 554)"
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("LNG_00094")
                        color: "#8898a6"
                        font.pixelSize: 10
                    }

                    TextField {
                        id: userField
                        placeholderText: "admin"
                        text: "admin"
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: userField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                        onTextChanged: rootPanel.statusMessage = ""
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("LNG_00093")
                        color: "#8898a6"
                        font.pixelSize: 10
                    }

                    TextField {
                        id: passField
                        placeholderText: "••••••••"
                        echoMode: TextInput.Password
                        selectByMouse: true
                        Layout.fillWidth: true
                        color: "white"
                        background: Rectangle {
                            color: "#0f151b"
                            radius: 4
                            border.color: passField.activeFocus ? "#ff7a00" : "#2a3540"
                        }
                        onTextChanged: rootPanel.statusMessage = ""
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: "RTSP Transport"
                        color: "#8898a6"
                        font.pixelSize: 10
                    }

                    ComboBox {
                        id: rtspTransportField
                        Layout.fillWidth: true
                        model: ["Auto (Global)", "TCP", "UDP"]
                        
                        background: Rectangle {
                            implicitHeight: 32
                            color: "#0f151b"
                            border.color: rtspTransportField.activeFocus ? "#ff7a00" : "#2a3540"
                            border.width: 1
                            radius: 4
                        }

                        contentItem: Text {
                            text: rtspTransportField.displayText
                            color: "white"
                            font.pixelSize: 11
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                        }

                        delegate: ItemDelegate {
                            width: rtspTransportField.width
                            height: 32
                            contentItem: Text {
                                text: modelData
                                color: hovered ? "#ff7a00" : "white"
                                font.pixelSize: 11
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                            background: Rectangle {
                                color: hovered ? "#2a3540" : "transparent"
                                border.color: hovered ? "#ff7a00" : "transparent"
                                border.width: 1
                                radius: 4
                            }
                        }

                        popup: Popup {
                            y: rtspTransportField.height + 2
                            width: rtspTransportField.width
                            implicitHeight: Math.min(320, rtspTransportField.popup.visible ? contentItem.implicitHeight : 0)
                            padding: 4

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: rtspTransportField.popup.visible ? rtspTransportField.delegateModel : null
                                currentIndex: rtspTransportField.highlightedIndex
                            }

                            background: Rectangle {
                                color: "#0f151b"
                                border.color: "#ff7a00"
                                border.width: 1
                                radius: 6
                            }
                        }
                    }
                }
            }

            // Live status message feedback
            Text {
                text: rootPanel.statusMessage
                color: rootPanel.statusColor
                font.pixelSize: 10
                font.bold: true
                visible: text !== ""
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    id: addBtn
                    text: rootPanel.isDiscovering ? qsTr("LNG_00092") : (rootPanel.editingIndex === -1 ? qsTr("LNG_00091") : qsTr("LNG_00090"))
                    Layout.fillWidth: true
                    highlighted: true

                    contentItem: RowLayout {
                        spacing: 8
                        Image {
                            source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='3' stroke-linecap='round'><path d='M12 2a10 10 0 1 0 10 10'></path></svg>"
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            visible: rootPanel.isDiscovering
                            fillMode: Image.PreserveAspectFit

                            RotationAnimation on rotation {
                                from: 0
                                to: 360
                                duration: 1000
                                loops: Animation.Infinite
                                running: rootPanel.isDiscovering
                            }
                        }
                        Text {
                            text: addBtn.text
                            font.bold: true
                            color: "white"
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        color: addBtn.pressed ? "#d66600" : (addBtn.hovered ? "#ff8c00" : "#ff7a00")
                        radius: 4
                    }

                    onClicked: {
                        if (ipField.text === "" || passField.text === "") {
                            rootPanel.statusColor = "#ff3333";
                            rootPanel.statusMessage = qsTr("LNG_00089");
                            return;
                        }

                        var ip = ipField.text.trim();
                        var port = parseInt(portField.text) || 8000;
                        var user = userField.text.trim();
                        var pass = passField.text;

                        rootPanel.statusColor = "#00f5d4"; // Cyan glowing text for loading
                        rootPanel.statusMessage = qsTr("LNG_00088");
                        rootPanel.isDiscovering = true;

                        // Log in and fetch camera channels from NVR asynchronously
                        HikvisionManager.discoverCamerasAsync(ip, port, user, pass);
                    }
                }

                Button {
                    id: cancelBtn
                    text: qsTr("LNG_00059")
                    visible: rootPanel.editingIndex !== -1
                    implicitWidth: 80
                    Layout.fillHeight: true

                    contentItem: Text {
                        text: cancelBtn.text
                        font.bold: true
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: cancelBtn.pressed ? "#404040" : (cancelBtn.hovered ? "#505050" : "#303030")
                        radius: 4
                    }

                    onClicked: {
                        rootPanel.editingIndex = -1;
                        nameField.text = "";
                        ipField.text = "";
                        portField.text = "8000";
                        httpPortField.text = "80";
                        rtspPortField.text = "554";
                        userField.text = "admin";
                        passField.text = "";
                        rtspTransportField.currentIndex = 0;
                        rootPanel.statusMessage = "";
                    }
                }
            }
        }
    }

    Text {
        text: qsTr("LNG_00087")
        color: "white"
        font {
            pixelSize: 13
            bold: true
        }
        Layout.fillWidth: true
        visible: rootPanel.recorders.length > 0
    }

    ColumnLayout {
        id: recordersListColumn
        Layout.fillWidth: true
        spacing: 6
        visible: rootPanel.recorders.length > 0

        Repeater {
            model: rootPanel.recorders
            delegate: Rectangle {
                Layout.fillWidth: true
                height: 38
                color: "#1c242c"
                radius: 4
                border.color: "#2a3540"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 8

                    ColumnLayout {
                        spacing: 1
                        Layout.fillWidth: true

                        Text {
                            text: modelData.name ? modelData.name + " (" + modelData.ip + ")" : modelData.ip
                            color: "white"
                            font.bold: true
                            font.pixelSize: 11
                        }
                        Text {
                            text: qsTr("LNG_00086").arg(modelData.cameras ? modelData.cameras.length : 0)
                            color: "#8898a6"
                            font.pixelSize: 9
                        }
                    }

                    MouseArea {
                        id: statusArea
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 4
                        implicitWidth: statusLayout.implicitWidth
                        implicitHeight: statusLayout.implicitHeight
                        hoverEnabled: true

                        RowLayout {
                            id: statusLayout
                            anchors.fill: parent
                            spacing: 6

                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                antialiasing: true
                                color: (rootPanel.activeSessionIps[modelData.ip] || false) ? "#00ff66" : "#ff3333"
                            }

                            Text {
                                text: (rootPanel.activeSessionIps[modelData.ip] || false) ? qsTr("LNG_00085") : qsTr("LNG_00084")
                                color: (rootPanel.activeSessionIps[modelData.ip] || false) ? "#00ff66" : "#ff3333"
                                font.pixelSize: 9
                                font.bold: true
                            }
                        }

                        ToolTip {
                            delay: Compact.toolTipDelay
                            timeout: Compact.toolTipTimeout
                            visible: statusArea.containsMouse
                            text: qsTr("LNG_00083")
                        }
                    }

                    Button {
                        id: webBtn
                        implicitWidth: 30
                        implicitHeight: 30
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            source: {
                                var colorStr = webBtn.hovered ? "%2300f5d4" : "%238898a6";
                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6'></path><polyline points='15 3 21 3 21 9'></polyline><line x1='10' y1='14' x2='21' y2='3'></line></svg>";
                            }
                        }

                        background: Rectangle {
                            color: webBtn.pressed ? "#cc121214" : (webBtn.hovered ? "#3a4550" : "#1c242c")
                            radius: 15
                            border.color: webBtn.hovered ? "#00f5d4" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            var hPort = modelData.httpPort || (modelData.port == 8000 ? 80 : modelData.port) || 80;
                            var url = "http://" + modelData.ip + (hPort == 80 ? "" : ":" + hPort);
                            Qt.openUrlExternally(url);
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: webBtn.hovered
                        ToolTip.text: qsTr("LNG_00082")
                    }

                    Button {
                        id: listBtn
                        implicitWidth: 30
                        implicitHeight: 30
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            source: {
                                var colorStr = listBtn.hovered ? "%2300f5d4" : "%238898a6";
                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='2' y='3' width='20' height='14' rx='2' ry='2'></rect><line x1='8' y1='21' x2='16' y2='21'></line><line x1='12' y1='17' x2='12' y2='21'></line></svg>";
                            }
                        }

                        background: Rectangle {
                            color: listBtn.pressed ? "#cc121214" : (listBtn.hovered ? "#3a4550" : "#1c242c")
                            radius: 15
                            border.color: listBtn.hovered ? "#00f5d4" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            rootPanel.openCamerasWindow(modelData);
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: listBtn.hovered
                        ToolTip.text: qsTr("LNG_00081")
                    }

                    Button {
                        id: editBtn
                        implicitWidth: 30
                        implicitHeight: 30
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            source: {
                                var colorStr = editBtn.hovered ? "%23ff7a00" : "%238898a6";
                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polygon points='16 3 21 8 8 21 3 21 3 16 16 3'></polygon></svg>";
                            }
                        }

                        background: Rectangle {
                            color: editBtn.pressed ? "#cc121214" : (editBtn.hovered ? "#3a4550" : "#1c242c")
                            radius: 15
                            border.color: editBtn.hovered ? "#ff7a00" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            // Populate input fields for editing
                            nameField.text = modelData.name || "";
                            ipField.text = modelData.ip;
                            portField.text = modelData.sdkPort || modelData.port || "8000";
                            httpPortField.text = modelData.httpPort || (modelData.port == 8000 ? "80" : modelData.port) || "80";
                            rtspPortField.text = modelData.rtspPort || "554";
                            userField.text = modelData.username;
                            passField.text = modelData.password;
                            
                            if (modelData.rtspTransport === "tcp") {
                                rtspTransportField.currentIndex = 1;
                            } else if (modelData.rtspTransport === "udp") {
                                rtspTransportField.currentIndex = 2;
                            } else {
                                rtspTransportField.currentIndex = 0;
                            }
                            
                            rootPanel.editingIndex = index;
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: editBtn.hovered
                        ToolTip.text: qsTr("LNG_00080")
                    }

                    Button {
                        id: delBtn
                        implicitWidth: 30
                        implicitHeight: 30
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            source: {
                                var colorStr = delBtn.hovered ? "%23ff4d4d" : "%238898a6";
                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path><line x1='10' y1='11' x2='10' y2='17'></line><line x1='14' y1='11' x2='14' y2='17'></line></svg>";
                            }
                        }

                        background: Rectangle {
                            color: delBtn.pressed ? "#cc121214" : (delBtn.hovered ? "#3a4550" : "#1c242c")
                            radius: 15
                            border.color: delBtn.hovered ? "#ff4d4d" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            deleteConfirmDialog1.targetIndex = index;
                            deleteConfirmDialog1.targetIp = modelData.ip;
                            deleteConfirmDialog1.open();
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: delBtn.hovered
                        ToolTip.text: qsTr("LNG_00079")
                    }
                }
            }
        }
    }

    ConfirmDialog {
        id: deleteConfirmDialog1
        title: qsTr("LNG_00078")
        iconSource: "qrc:/images/icon-warning.svg"
        message: qsTr("LNG_00077")
        property int targetIndex: -1
        property string targetIp: ""
        
        onAccepted: {
            deleteConfirmDialog2.targetIndex = targetIndex;
            deleteConfirmDialog2.targetIp = targetIp;
            deleteConfirmDialog2.open();
        }
    }

    ConfirmDialog {
        id: deleteConfirmDialog2
        title: qsTr("LNG_00076")
        iconSource: "qrc:/images/icon-warning.svg"
        message: qsTr("LNG_00075")
        property int targetIndex: -1
        property string targetIp: ""
        
        onAccepted: {
            if (targetIndex >= 0 && targetIndex < rootPanel.recorders.length) {
                HikvisionManager.logout(targetIp);
                
                // Remove from active recorders list
                var arr = rootPanel.recorders.slice();
                arr.splice(targetIndex, 1);
                rootPanel.recorders = arr;
                rootPanel.saveRecorders();

                // Automatically remove corresponding NVR view layout(s)
                for (var j = layoutsCollectionModel.count - 1; j >= 0; --j) {
                    var l = layoutsCollectionModel.get(j);
                    if (l && l.isNvr && l.nvrIp === targetIp) {
                        layoutsCollectionModel.remove(j);
                    }
                }
            }
        }
    }
}
