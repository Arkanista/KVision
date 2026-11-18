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

    // Map of thumbnail generation progress per NVR IP: { "192.168.1.100": { completed: 2, total: 8, percent: 25 } }
    property var thumbnailProgressMap: ({})

    readonly property bool isDraggingRecorder: recorderDragState.sourceIdx !== -1

    function resetFormFields() {
        rootPanel.editingIndex = -1;
        nameField.text = "";
        ipField.text = "";
        portField.text = "8000";
        httpPortField.text = "80";
        rtspPortField.text = "554";
        userField.text = "admin";
        passField.text = "";
        rtspTransportField.currentIndex = 0;
        remoteRecorderCheckBox.checked = false;
        rootPanel.hasPortTestResult = false;
        rootPanel.statusMessage = "";
    }

    function saveEditedRecorderWithoutDiscovery() {
        if (editingIndex < 0 || editingIndex >= recorders.length) return;
        if (ipField.text.trim() === "" || passField.text === "") {
            statusColor = "#ff3333";
            statusMessage = qsTr("LNG_00089");
            return;
        }
        var oldRec = recorders[editingIndex];
        var newIp = ipField.text.trim();
        var sdkP = parseInt(portField.text) || 8000;
        var httpP = parseInt(httpPortField.text) || 80;
        var rtspP = parseInt(rtspPortField.text) || 554;
        var rtspTransport = rtspTransportField.currentText === "TCP" ? "tcp" : (rtspTransportField.currentText === "UDP" ? "udp" : "");

        var arr = recorders.slice();
        arr[editingIndex] = {
            name: nameField.text.trim(),
            ip: newIp,
            port: sdkP,
            sdkPort: sdkP,
            httpPort: httpP,
            rtspPort: rtspP,
            username: userField.text.trim(),
            password: passField.text,
            cameras: oldRec.cameras || [],
            rtspTransport: rtspTransport,
            remoteRecorder: remoteRecorderCheckBox.checked
        };
        recorders = arr;
        saveRecorders();

        var trimmedName = nameField.text.trim();
        if (oldRec.ip !== newIp) {
            for (var j = 0; j < layoutsCollectionModel.count; ++j) {
                var l = layoutsCollectionModel.get(j);
                if (l && l.isNvr && l.nvrIp === oldRec.ip) {
                    l.nvrIp = newIp;
                    l.name = trimmedName || newIp;
                }
            }
        } else {
            for (var k = 0; k < layoutsCollectionModel.count; ++k) {
                var lk = layoutsCollectionModel.get(k);
                if (lk && lk.isNvr && lk.nvrIp === oldRec.ip) {
                    lk.name = trimmedName || newIp;
                }
            }
        }
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.flushSettingsToDisk) {
            rootWindow.flushSettingsToDisk();
        }
        resetFormFields();
    }

    // Live UX feedback state
    property string statusMessage: ""
    property string statusColor: "#ff7a00"

    // Track NVR editing state
    property int editingIndex: -1
    property bool isDiscovering: false
    property bool isTestingPorts: false
    property bool hasPortTestResult: false
    property int testedSdkPort: 8000
    property int testedHttpPort: 80
    property int testedRtspPort: 554
    property bool testedSdkOpen: false
    property bool testedHttpOpen: false
    property bool testedRtspOpen: false
    property int testedSdkMs: -1
    property int testedHttpMs: -1
    property int testedRtspMs: -1
    property string lastDiscoveredIp: ""
    property int lastDiscoveredRtspPort: 554

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
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.openNvrCamerasWindow) {
            rootWindow.openNvrCamerasWindow(recorderData);
        } else {
            var win = nvrCamerasWindowComponent.createObject(rootWindow);
            win.recorder = JSON.parse(JSON.stringify(recorderData));
            win.show();
        }
    }

    Component.onCompleted: {
        loadRecorders();
    }

    onVisibleChanged: {
        if (visible) {
            refreshRecorders();
        }
    }

    Connections {
        target: ThumbnailProvider
        function onThumbnailProgress(ip, completed, total) {
            var m = Object.assign({}, rootPanel.thumbnailProgressMap);
            var pct = (total > 0) ? Math.round((completed * 100) / total) : 0;
            m[ip] = { completed: completed, total: total, percent: pct };
            rootPanel.thumbnailProgressMap = m;
        }
        function onThumbnailFinished(ip) {
            var m = Object.assign({}, rootPanel.thumbnailProgressMap);
            delete m[ip];
            rootPanel.thumbnailProgressMap = m;
        }
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

        function onPortsTestFinished(ip, sdkOpen, httpOpen, rtspOpen, sdkMs, httpMs, rtspMs) {
            if (!rootPanel.isTestingPorts) return;
            rootPanel.isTestingPorts = false;
            rootPanel.hasPortTestResult = true;
            rootPanel.testedSdkOpen = sdkOpen;
            rootPanel.testedHttpOpen = httpOpen;
            rootPanel.testedRtspOpen = rtspOpen;
            rootPanel.testedSdkMs = sdkMs;
            rootPanel.testedHttpMs = httpMs;
            rootPanel.testedRtspMs = rtspMs;
        }

        function onRtspPortChecked(ip, rtspPort, open) {
            if (!open && rootPanel.lastDiscoveredIp !== ""
                    && ip === rootPanel.lastDiscoveredIp
                    && rtspPort === rootPanel.lastDiscoveredRtspPort) {
                rootPanel.statusColor = "#ffaa00";
                rootPanel.statusMessage = qsTr("LNG_00580").arg(rtspPort);
                rootPanel.lastDiscoveredIp = "";
            }
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
                rtspTransport: rtspTransport,
                remoteRecorder: remoteRecorderCheckBox.checked
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
                ThumbnailProvider.generateThumbnails(newRecorder);

                // Generate a dynamic preset layout containing all discovered cameras
                var numCams = cameras.length;
                var gridSize = Math.max(1, Math.ceil(Math.sqrt(numCams)));
                
                var targetLayout = null;
                var targetLayoutIndex = -1;
                for (var li = 0; li < layoutsCollectionModel.count; ++li) {
                    var l = layoutsCollectionModel.get(li);
                    if (l && l.isNvr && l.nvrIp === ip) {
                        targetLayout = l;
                        targetLayoutIndex = li;
                        break;
                    }
                }
                if (!targetLayout) {
                    targetLayout = layoutsCollectionModel.append();
                    targetLayoutIndex = layoutsCollectionModel.count - 1;
                }

                targetLayout.size = Qt.size(gridSize, gridSize);
                targetLayout.name = (newRecorder.name && newRecorder.name.trim() !== "") ? newRecorder.name.trim() : ip;
                targetLayout.isNvr = true;
                targetLayout.nvrIp = ip;

                for (var i = 0; i < numCams; ++i) {
                    var vp = targetLayout.get(i);
                    if (vp) {
                        // Store Hikvision URI
                        vp.url = "hikvision://" + newRecorder.ip + "/" + cameras[i].channelId;
                        vp.secondaryUrl = vp.url;
                        vp.volume = 0;
                    }
                }

                // Force navigation to the newly created preset!
                stackLayout.currentIndex = targetLayoutIndex;

                if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.flushSettingsToDisk) {
                    rootWindow.flushSettingsToDisk();
                }

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
                        l.name = (newRecorder.name && newRecorder.name.trim() !== "") ? newRecorder.name.trim() : newRecorder.ip;
                        var numCams2 = cameras.length;
                        var gridSize2 = Math.max(1, Math.ceil(Math.sqrt(numCams2)));
                        l.size = Qt.size(gridSize2, gridSize2);

                        for (var k = 0; k < numCams2; ++k) {
                            var vp2 = l.get(k);
                            if (vp2) {
                                var newUrl = "hikvision://" + newRecorder.ip + "/" + cameras[k].channelId;
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
                                    var newUrl2 = "hikvision://" + newRecorder.ip + "/" + chanId;
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

                if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.flushSettingsToDisk) {
                    rootWindow.flushSettingsToDisk();
                }
            }

            // Clear fields & status, then verify RTSP port reachability for live view diagnostics
            resetFormFields();
            rootPanel.lastDiscoveredIp = ip;
            rootPanel.lastDiscoveredRtspPort = rtspP;
            HikvisionManager.checkRtspPortAsync(ip, rtspP);
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
            var data = (typeof rootWindow !== "undefined" && rootWindow) ? rootWindow.hikvisionRecordersJson : "";
            if (!data || data === "[]" || data.trim() === "") {
                data = Context.readSetting("Hikvision", "recordersJson", "[]");
                if (data && data !== "[]" && data.trim() !== "" && typeof rootWindow !== "undefined" && rootWindow) {
                    rootWindow.hikvisionRecordersJson = data;
                }
            }
            if (data && data.trim() !== "") {
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

    function refreshRecorders() {
        if (rootPanel.isDraggingRecorder) return;
        loadRecorders();
        var arr = rootPanel.recorders.slice();
        rootPanel.recorders = [];
        rootPanel.recorders = arr;
        saveRecorders();
    }

    function saveRecorders() {
        try {
            var jsonStr = JSON.stringify(recorders);
            if (typeof rootWindow !== "undefined" && rootWindow) {
                rootWindow.lastSavedRecordersJson = jsonStr;
                rootWindow.lastLoadedRecordersJson = jsonStr;
                rootWindow.lastRecordersSaveTime = Date.now();
                rootWindow.hikvisionRecordersJson = jsonStr;
            }
            Context.writeSetting("Hikvision", "recordersJson", jsonStr);
        } catch(e) {
            console.log("[Hikvision QML Error] Failed to save recorders:", e);
        }
    }

    function moveRecorderOrder(fromIdx, toIdx) {
        if (fromIdx < 0 || toIdx < 0 || fromIdx === toIdx ||
            fromIdx >= rootPanel.recorders.length || toIdx >= rootPanel.recorders.length) {
            return;
        }
        var list = rootPanel.recorders.slice();
        var moved = list.splice(fromIdx, 1)[0];
        list.splice(toIdx, 0, moved);

        if (rootPanel.editingIndex !== -1) {
            if (rootPanel.editingIndex === fromIdx) {
                rootPanel.editingIndex = toIdx;
            } else if (fromIdx < toIdx && rootPanel.editingIndex > fromIdx && rootPanel.editingIndex <= toIdx) {
                rootPanel.editingIndex--;
            } else if (toIdx < fromIdx && rootPanel.editingIndex >= toIdx && rootPanel.editingIndex < fromIdx) {
                rootPanel.editingIndex++;
            }
        }

        rootPanel.recorders = list;
        rootPanel.saveRecorders();
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
            radius: 8
            border.color: "#2a3540"
            border.width: 1
        }

        ColumnLayout {
            width: parent.width
            spacing: 8
            enabled: !rootPanel.isDiscovering && !rootPanel.isTestingPorts

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
                    onTextChanged: {
                        rootPanel.statusMessage = "";
                        rootPanel.hasPortTestResult = false;
                    }
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
                        onTextChanged: {
                            rootPanel.statusMessage = "";
                            rootPanel.hasPortTestResult = false;
                        }
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
                        onTextChanged: {
                            rootPanel.statusMessage = "";
                            rootPanel.hasPortTestResult = false;
                        }
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
                        onTextChanged: {
                            rootPanel.statusMessage = "";
                            rootPanel.hasPortTestResult = false;
                        }
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
                            radius: 6
                        }

                        contentItem: Text {
                            text: rtspTransportField.displayText
                            color: "white"
                            font.pixelSize: 11
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                            rightPadding: 28
                        }

                        indicator: Image {
                            x: rtspTransportField.width - width - 10
                            y: rtspTransportField.topPadding + (rtspTransportField.availableHeight - height) / 2
                            width: 12
                            height: 14
                            sourceSize.width: 12
                            sourceSize.height: 14
                            source: {
                                var c = (rtspTransportField.hovered || rtspTransportField.popup.visible) ? "%23ff7a00" : "%23b8c7d4";
                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + c + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='7 9 12 4 17 9'/><polyline points='7 15 12 20 17 15'/></svg>";
                            }
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

            CheckBox {
                id: remoteRecorderCheckBox
                text: qsTr("LNG_00569")
                Layout.fillWidth: true
                onCheckedChanged: {
                    if (checked && rtspTransportField.currentIndex === 0) {
                        rtspTransportField.currentIndex = 1;
                    }
                }
                ToolTip.delay: Compact.toolTipDelay
                ToolTip.timeout: Compact.toolTipTimeout
                ToolTip.visible: remoteRecorderCheckBox.hovered
                ToolTip.text: qsTr("LNG_00570")
            }

            Button {
                id: testPortsBtn
                text: rootPanel.isTestingPorts ? qsTr("LNG_00572") : qsTr("LNG_00571")
                Layout.fillWidth: true

                contentItem: RowLayout {
                    spacing: 6
                    Image {
                        source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2300f5d4' stroke-width='3' stroke-linecap='round'><path d='M12 2a10 10 0 1 0 10 10'></path></svg>"
                        Layout.preferredWidth: 14
                        Layout.preferredHeight: 14
                        visible: rootPanel.isTestingPorts
                        fillMode: Image.PreserveAspectFit

                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                            running: rootPanel.isTestingPorts
                        }
                    }
                    Text {
                        text: testPortsBtn.text
                        font.bold: true
                        font.pixelSize: 11
                        color: testPortsBtn.hovered ? "#00f5d4" : "#d0dce5"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                background: Rectangle {
                    implicitHeight: 30
                    color: testPortsBtn.pressed ? "#0c141b" : (testPortsBtn.hovered ? "#22303c" : "#15202b")
                    border.color: testPortsBtn.hovered ? "#00f5d4" : "#2a3540"
                    border.width: 1
                    radius: 6
                }

                onClicked: {
                    var ip = ipField.text.trim();
                    if (ip === "") {
                        rootPanel.statusColor = "#ff3333";
                        rootPanel.statusMessage = qsTr("LNG_00573");
                        return;
                    }
                    var sdkP = parseInt(portField.text) || 8000;
                    var httpP = parseInt(httpPortField.text) || 80;
                    var rtspP = parseInt(rtspPortField.text) || 554;

                    rootPanel.testedSdkPort = sdkP;
                    rootPanel.testedHttpPort = httpP;
                    rootPanel.testedRtspPort = rtspP;
                    rootPanel.statusMessage = "";
                    rootPanel.isTestingPorts = true;
                    HikvisionManager.testPortsAsync(ip, sdkP, httpP, rtspP);
                }
            }

            Rectangle {
                id: portTestResultBox
                visible: rootPanel.hasPortTestResult
                Layout.fillWidth: true
                implicitHeight: portTestResultCol.implicitHeight + 14
                color: "#0f151b"
                radius: 6
                border.color: (!rootPanel.testedRtspOpen || !rootPanel.testedSdkOpen) ? "#ff4d4d" : "#2a3540"
                border.width: 1

                ColumnLayout {
                    id: portTestResultCol
                    anchors.fill: parent
                    anchors.margins: 7
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: rootPanel.testedSdkOpen ? "#00ff66" : "#ff4d4d"
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                            font.pixelSize: 10
                            color: rootPanel.testedSdkOpen ? "#d8f8e5" : "#ff8080"
                            text: "SDK (" + rootPanel.testedSdkPort + "): " + (rootPanel.testedSdkOpen ? qsTr("LNG_00574").arg(rootPanel.testedSdkMs) : qsTr("LNG_00575"))
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: rootPanel.testedRtspOpen ? "#00ff66" : "#ff4d4d"
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                            font.pixelSize: 10
                            font.bold: !rootPanel.testedRtspOpen
                            color: rootPanel.testedRtspOpen ? "#d8f8e5" : "#ff6666"
                            text: "RTSP (" + rootPanel.testedRtspPort + "): " + (rootPanel.testedRtspOpen ? qsTr("LNG_00576").arg(rootPanel.testedRtspMs) : qsTr("LNG_00577"))
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: rootPanel.testedHttpOpen ? "#00ff66" : (rootPanel.testedSdkOpen ? "#ffaa00" : "#ff4d4d")
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                            font.pixelSize: 10
                            color: rootPanel.testedHttpOpen ? "#d8f8e5" : (rootPanel.testedSdkOpen ? "#ffd27f" : "#ff8080")
                            text: "HTTP (" + rootPanel.testedHttpPort + "): " + (rootPanel.testedHttpOpen ? qsTr("LNG_00578").arg(rootPanel.testedHttpMs) : qsTr("LNG_00579"))
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
                        radius: 6
                    }

                    onClicked: {
                        if (ipField.text === "" || passField.text === "") {
                            rootPanel.statusColor = "#ff3333";
                            rootPanel.statusMessage = qsTr("LNG_00089");
                            return;
                        }

                        var ip = ipField.text.trim();
                        var sdkP = parseInt(portField.text) || 8000;
                        var httpP = parseInt(httpPortField.text) || 80;
                        var user = userField.text.trim();
                        var pass = passField.text;

                        rootPanel.statusColor = "#00f5d4"; // Cyan glowing text for loading
                        rootPanel.statusMessage = qsTr("LNG_00088");
                        rootPanel.isDiscovering = true;

                        // Log in and fetch camera channels from NVR asynchronously
                        HikvisionManager.discoverCamerasAsync(ip, sdkP, httpP, user, pass, remoteRecorderCheckBox.checked);
                    }
                }

                Button {
                    id: saveChangesBtn
                    text: qsTr("LNG_00632")
                    visible: rootPanel.editingIndex !== -1
                    implicitWidth: Math.max(96, saveChangesText.implicitWidth + 20)
                    Layout.fillHeight: true

                    contentItem: Text {
                        id: saveChangesText
                        text: saveChangesBtn.text
                        font.bold: true
                        color: "#0f151b"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: saveChangesBtn.pressed ? "#00c4a7" : (saveChangesBtn.hovered ? "#2effe1" : "#00f5d4")
                        radius: 6
                    }

                    onClicked: rootPanel.saveEditedRecorderWithoutDiscovery()
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
                        radius: 6
                    }

                    onClicked: rootPanel.resetFormFields()
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

    Item {
        id: recordersDragWrapper
        Layout.fillWidth: true
        implicitHeight: Math.max(recordersListColumn.implicitHeight, recordersListColumn.childrenRect.height)
        Layout.preferredHeight: implicitHeight
        height: implicitHeight
        visible: rootPanel.recorders.length > 0

        onVisibleChanged: {
            if (visible) {
                height = Qt.binding(function() {
                    return Math.max(recordersListColumn.implicitHeight, recordersListColumn.childrenRect.height);
                });
            }
        }

        QtObject {
            id: recorderDragState
            property int sourceIdx: -1
            property int targetIdx: -1
            property string previewName: ""
            property string previewIp: ""
            property int previewCamCount: 0
            property real draggedHeight: 58
            function reset() {
                sourceIdx = -1;
                targetIdx = -1;
                previewName = "";
                previewIp = "";
                previewCamCount = 0;
                draggedHeight = 58;
            }
        }

        Rectangle {
            id: recorderDragProxy
            visible: recorderDragState.sourceIdx !== -1
            enabled: false
            z: 9999
            width: recordersDragWrapper.width
            height: recorderDragState.draggedHeight
            radius: 8
            color: "#1c242c"
            border.color: "#00f5d4"
            border.width: 1.5
            opacity: 0.94

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12

                Item {
                    width: 20
                    height: 28
                    Image {
                        anchors.centerIn: parent
                        width: 14
                        height: 14
                        sourceSize.width: 14
                        sourceSize.height: 14
                        source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2300f5d4'>" +
                               "<circle cx='9' cy='5' r='1.8'/><circle cx='15' cy='5' r='1.8'/>" +
                               "<circle cx='9' cy='12' r='1.8'/><circle cx='15' cy='12' r='1.8'/>" +
                               "<circle cx='9' cy='19' r='1.8'/><circle cx='15' cy='19' r='1.8'/>" +
                               "</svg>"
                    }
                }

                ColumnLayout {
                    spacing: 5
                    Layout.fillWidth: true

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Text {
                            text: recorderDragState.previewName
                            color: "white"
                            font.bold: true
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: qsTr("LNG_00086").arg(recorderDragState.previewCamCount)
                            color: "#8898a6"
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }

        ColumnLayout {
            id: recordersListColumn
            width: parent.width
            height: implicitHeight
            spacing: 6

            function updateRecorderDropTarget(pointerYInWrapper) {
                var chs = recordersListColumn.children;
                var bestIdx = recorderDragState.sourceIdx;
                var bestDist = 1e9;
                for (var i = 0; i < chs.length; ++i) {
                    var ch = chs[i];
                    if (!ch || !ch.visible || typeof ch.recorderIndex !== "number") continue;
                    var topY = ch.mapToItem(recordersDragWrapper, 0, 0).y - (ch.pushOffsetY || 0);
                    var bottomY = topY + ch.height;
                    if (pointerYInWrapper >= topY - 4 && pointerYInWrapper <= bottomY + 4) {
                        bestIdx = ch.recorderIndex;
                        break;
                    }
                    var dist = Math.abs(pointerYInWrapper - (topY + bottomY) * 0.5);
                    if (dist < bestDist) {
                        bestDist = dist;
                        bestIdx = ch.recorderIndex;
                    }
                }
                recorderDragState.targetIdx = bestIdx;
            }

            Repeater {
                model: rootPanel.recorders
                delegate: Rectangle {
                    id: card
                    property int recorderIndex: index
                    property var recorderData: modelData
                    readonly property bool isBeingDragged: recorderDragState.sourceIdx === recorderIndex
                    readonly property bool isDropTarget: recorderDragState.targetIdx === recorderIndex && recorderDragState.sourceIdx !== recorderIndex && recorderDragState.sourceIdx !== -1
                    readonly property bool dropAbove: isDropTarget && recorderDragState.sourceIdx > recorderIndex
                    readonly property bool dropBelow: isDropTarget && recorderDragState.sourceIdx < recorderIndex
                    readonly property real pushOffsetY: {
                        if (recorderDragState.sourceIdx === -1 || recorderDragState.targetIdx === -1 || recorderDragState.sourceIdx === recorderDragState.targetIdx)
                            return 0;
                        if (recorderDragState.sourceIdx === recorderIndex)
                            return 0;
                        if (recorderDragState.sourceIdx < recorderIndex && recorderIndex <= recorderDragState.targetIdx)
                            return -12;
                        if (recorderDragState.targetIdx <= recorderIndex && recorderIndex < recorderDragState.sourceIdx)
                            return 12;
                        return 0;
                    }

                    Layout.fillWidth: true
                    implicitHeight: Math.max(58, cardRow.implicitHeight + 16)
                    Layout.preferredHeight: implicitHeight
                    height: implicitHeight
                    color: isBeingDragged ? "#101820" : (isDropTarget ? "#172530" : "#1c242c")
                    radius: 8
                    border.color: isBeingDragged ? "#00f5d4" : (isDropTarget ? "#00f5d4" : "#2a3540")
                    border.width: isBeingDragged ? 1.5 : 1
                    opacity: isBeingDragged ? 0.35 : 1.0
                    z: isBeingDragged ? 1 : 2

                    transform: Translate {
                        y: card.pushOffsetY
                        Behavior on y {
                            NumberAnimation { duration: 135; easing.type: Easing.OutCubic }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: card.dropAbove ? parent.top : undefined
                        anchors.bottom: card.dropBelow ? parent.bottom : undefined
                        height: 3
                        radius: 1.5
                        color: "#00f5d4"
                        visible: card.isDropTarget
                        z: 5
                    }

                    RowLayout {
                        id: cardRow
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 10
                        spacing: 10

                        // Drag grip handle (only interactive when more than 1 recorder)
                        Item {
                            id: grpGrip
                            visible: rootPanel.recorders.length > 1
                            width: visible ? 24 : 0
                            height: 28
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                anchors.centerIn: parent
                                width: 14
                                height: 14
                                sourceSize.width: 14
                                sourceSize.height: 14
                                source: {
                                    var c = (grpDragMouse.containsMouse || card.isBeingDragged) ? "%2300f5d4" : "%236b7c8a";
                                    return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='" + c + "'>" +
                                           "<circle cx='9' cy='5' r='1.8'/><circle cx='15' cy='5' r='1.8'/>" +
                                           "<circle cx='9' cy='12' r='1.8'/><circle cx='15' cy='12' r='1.8'/>" +
                                           "<circle cx='9' cy='19' r='1.8'/><circle cx='15' cy='19' r='1.8'/>" +
                                           "</svg>";
                                }
                            }

                            MouseArea {
                                id: grpDragMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                preventStealing: true
                                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                                onPressed: {
                                    var pt = card.mapToItem(recordersDragWrapper, 0, 0);
                                    recorderDragProxy.x = pt.x;
                                    recorderDragProxy.y = pt.y;
                                    recorderDragState.sourceIdx = card.recorderIndex;
                                    recorderDragState.targetIdx = card.recorderIndex;
                                    recorderDragState.previewName = card.recorderData ? ((card.recorderData.name ? card.recorderData.name + " (" + card.recorderData.ip + ")" : card.recorderData.ip)) : "";
                                    recorderDragState.previewIp = card.recorderData ? card.recorderData.ip : "";
                                    recorderDragState.previewCamCount = (card.recorderData && card.recorderData.cameras) ? card.recorderData.cameras.length : 0;
                                    recorderDragState.draggedHeight = card.height;
                                    var totalH = Math.max(recordersDragWrapper.height, recordersListColumn.implicitHeight, recordersListColumn.childrenRect.height);
                                    if (recordersDragWrapper.height < totalH) {
                                        recordersDragWrapper.height = totalH;
                                    }
                                }

                                onPositionChanged: {
                                    if (!pressed || recorderDragState.sourceIdx === -1) return;
                                    var p = grpDragMouse.mapToItem(recordersDragWrapper, mouse.x, mouse.y);
                                    var totalH = Math.max(recordersDragWrapper.height, recordersListColumn.implicitHeight, recordersListColumn.childrenRect.height);
                                    var maxY = Math.max(0, totalH - recorderDragProxy.height);
                                    recorderDragProxy.y = Math.max(0, Math.min(maxY, p.y - recorderDragProxy.height * 0.5));
                                    recordersListColumn.updateRecorderDropTarget(p.y);
                                }

                                onReleased: {
                                    var fromI = recorderDragState.sourceIdx;
                                    var toI = recorderDragState.targetIdx;
                                    recorderDragState.reset();
                                    if (fromI !== -1 && toI !== -1 && fromI !== toI) {
                                        rootPanel.moveRecorderOrder(fromI, toI);
                                    }
                                }

                                onCanceled: recorderDragState.reset()

                                ToolTip.delay: Compact.toolTipDelay
                                ToolTip.timeout: Compact.toolTipTimeout
                                ToolTip.visible: grpDragMouse.containsMouse && recorderDragState.sourceIdx === -1
                                ToolTip.text: qsTr("LNG_00631")
                            }
                        }

                        ColumnLayout {
                            spacing: 5
                            Layout.fillWidth: true

                            RowLayout {
                                spacing: 8
                                Layout.fillWidth: true

                                Text {
                                    text: modelData.name ? modelData.name + " (" + modelData.ip + ")" : modelData.ip
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: qsTr("LNG_00086").arg(modelData.cameras ? modelData.cameras.length : 0)
                                    color: "#8898a6"
                                    font.pixelSize: 10
                                }
                            }

                            Flow {
                                Layout.fillWidth: true
                                spacing: 6

                                // SDK login status badge
                                Rectangle {
                                    id: sdkStatusBadge
                                    readonly property bool loggedIn: !!(rootPanel.activeSessionIps[modelData.ip])
                                    implicitWidth: sdkStatusRow.implicitWidth + 14
                                    height: 22
                                    radius: 6
                                    color: loggedIn ? "#0e291d" : "#2c1418"
                                    border.color: loggedIn ? "#00cc55" : "#cc3344"
                                    border.width: 1

                                    Row {
                                        id: sdkStatusRow
                                        anchors.centerIn: parent
                                        spacing: 5

                                        Rectangle {
                                            width: 7
                                            height: 7
                                            radius: 3.5
                                            antialiasing: true
                                            anchors.verticalCenter: parent.verticalCenter
                                            color: sdkStatusBadge.loggedIn ? "#00ff66" : "#ff4d5e"
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: sdkStatusBadge.loggedIn ? qsTr("LNG_00085") : qsTr("LNG_00084")
                                            color: sdkStatusBadge.loggedIn ? "#6effb0" : "#ff8a95"
                                            font.pixelSize: 10
                                            font.bold: true
                                        }
                                    }

                                    MouseArea {
                                        id: statusArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        enabled: recorderDragState.sourceIdx === -1
                                    }

                                    ToolTip.delay: Compact.toolTipDelay
                                    ToolTip.timeout: Compact.toolTipTimeout
                                    ToolTip.visible: statusArea.containsMouse
                                    ToolTip.text: qsTr("LNG_00083")
                                }

                                // WAN badge
                                Rectangle {
                                    visible: !!modelData.remoteRecorder
                                    implicitWidth: wanBadgeText.implicitWidth + 14
                                    height: 22
                                    radius: 6
                                    color: "#122b2e"
                                    border.color: "#00f5d4"
                                    border.width: 1

                                    Text {
                                        id: wanBadgeText
                                        anchors.centerIn: parent
                                        text: "WAN"
                                        color: "#00f5d4"
                                        font.pixelSize: 10
                                        font.bold: true
                                    }
                                }

                                // Thumbnail generation progress badge
                                Rectangle {
                                    id: thumbProgressBadge
                                    property var prog: rootPanel.thumbnailProgressMap[modelData.ip]
                                    visible: !!prog
                                    implicitWidth: thumbProgressRow.implicitWidth + 14
                                    height: 22
                                    radius: 6
                                    color: "#132733"
                                    border.color: "#00c8ff"
                                    border.width: 1

                                    Row {
                                        id: thumbProgressRow
                                        anchors.centerIn: parent
                                        spacing: 5

                                        BusyIndicator {
                                            width: 14
                                            height: 14
                                            running: thumbProgressBadge.visible
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: thumbProgressBadge.prog ? qsTr("LNG_00646").arg(thumbProgressBadge.prog.completed).arg(thumbProgressBadge.prog.total).arg(thumbProgressBadge.prog.percent) : ""
                                            color: "#60d0ff"
                                            font.pixelSize: 10
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }

                        // Right-aligned action buttons cluster
                        RowLayout {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            spacing: 6
                            enabled: recorderDragState.sourceIdx === -1

                            Button {
                                id: webBtn
                                implicitWidth: 30
                                implicitHeight: 30

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
                                    color: webBtn.pressed ? "#cc121214" : (webBtn.hovered ? "#3a4550" : "#151d24")
                                    radius: 6
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
                                    color: listBtn.pressed ? "#cc121214" : (listBtn.hovered ? "#3a4550" : "#151d24")
                                    radius: 6
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
                                    color: editBtn.pressed ? "#cc121214" : (editBtn.hovered ? "#3a4550" : "#151d24")
                                    radius: 6
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
                                    remoteRecorderCheckBox.checked = !!modelData.remoteRecorder;
                                    rootPanel.hasPortTestResult = false;
                                    rootPanel.statusMessage = "";

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
                                    color: delBtn.pressed ? "#cc121214" : (delBtn.hovered ? "#3a4550" : "#151d24")
                                    radius: 6
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
            var delIdx = -1;
            for (var idx = 0; idx < rootPanel.recorders.length; ++idx) {
                if (rootPanel.recorders[idx] && rootPanel.recorders[idx].ip === targetIp) {
                    delIdx = idx;
                    break;
                }
            }
            if (delIdx === -1 && targetIndex >= 0 && targetIndex < rootPanel.recorders.length) {
                delIdx = targetIndex;
            }
            if (delIdx >= 0 && delIdx < rootPanel.recorders.length) {
                var deletedIp = targetIp || (rootPanel.recorders[delIdx] ? rootPanel.recorders[delIdx].ip : "");
                var deletedName = (rootPanel.recorders[delIdx] && rootPanel.recorders[delIdx].name) ? rootPanel.recorders[delIdx].name : "";

                HikvisionManager.logout(deletedIp);

                // 1. Delete all disk and memory cached thumbnails for this NVR
                ThumbnailProvider.deleteRecorderThumbnails(deletedIp);

                // 2. Unmute recorder in NvrStatusManager
                if (typeof NvrStatusManager !== "undefined" && NvrStatusManager) {
                    if (deletedName) NvrStatusManager.setRecorderMuted(deletedName, false);
                    NvrStatusManager.setRecorderMuted(deletedIp, false);
                }

                // 3. Clear playback caches for this deleted recorder
                if (typeof rootWindow !== "undefined" && rootWindow) {
                    if (rootWindow.monthAvailabilitiesCache) {
                        var mCache = Object.assign({}, rootWindow.monthAvailabilitiesCache);
                        for (var mk in mCache) {
                            if (mk.indexOf(deletedIp) !== -1) {
                                delete mCache[mk];
                            }
                        }
                        rootWindow.monthAvailabilitiesCache = mCache;
                    }
                    if (rootWindow.playbackSegmentsCache) {
                        var sCache = Object.assign({}, rootWindow.playbackSegmentsCache);
                        for (var sk in sCache) {
                            if (sk.indexOf(deletedIp) !== -1) {
                                delete sCache[sk];
                            }
                        }
                        rootWindow.playbackSegmentsCache = sCache;
                    }
                }

                // 4. Remove from active recorders list
                var arr = rootPanel.recorders.slice();
                arr.splice(delIdx, 1);
                rootPanel.recorders = arr;
                rootPanel.saveRecorders();

                // 5. Automatically remove corresponding NVR view layout(s)
                for (var j = layoutsCollectionModel.count - 1; j >= 0; --j) {
                    var l = layoutsCollectionModel.get(j);
                    if (l && l.isNvr && l.nvrIp === deletedIp) {
                        layoutsCollectionModel.remove(j);
                    }
                }

                // 6. Clean up any viewports in custom layouts that reference this NVR
                for (var m = 0; m < layoutsCollectionModel.count; ++m) {
                    var lay = layoutsCollectionModel.get(m);
                    if (!lay || lay.isNvr) continue;
                    for (var v = 0; v < lay.count; ++v) {
                        var vp = lay.get(v);
                        if (vp && vp.url) {
                            var u = String(vp.url);
                            if (u.indexOf("hikvision://" + deletedIp + "/") !== -1 ||
                                u.indexOf("@" + deletedIp + ":") !== -1 ||
                                u.indexOf("://" + deletedIp + ":") !== -1 ||
                                u.indexOf("@" + deletedIp + "/") !== -1 ||
                                u.indexOf("://" + deletedIp + "/") !== -1) {
                                vp.url = "";
                                vp.secondaryUrl = "";
                                vp.streamMode = 0;
                                vp.volume = 0;
                                vp.avFormatOptions = {};
                            }
                        }
                    }
                }

                // 7. Reset form fields if they match the deleted recorder
                if (rootPanel.editingIndex === delIdx || ipField.text.trim() === deletedIp) {
                    rootPanel.resetFormFields();
                }

                // 8. Flush settings to disk
                if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.flushSettingsToDisk) {
                    rootWindow.flushSettingsToDisk();
                }
            }
        }
    }
}
