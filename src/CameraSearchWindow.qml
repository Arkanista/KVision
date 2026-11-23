import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import CCTV_Viewer.Core 1.0
import CCTV_Viewer.Utils 1.0
import CCTV_Viewer.Themes 1.0

Window {
    id: searchWin

    width: 660
    height: computedHeight
    minimumWidth: 480
    minimumHeight: headerHeight
    maximumHeight: maxScreenHeight
    color: "#0f151b"
    title: qsTr("LNG_00656")

    readonly property int headerHeight: 74
    readonly property int rowHeight: 66
    readonly property int rowSpacing: 6
    readonly property int availScreenHeight: {
        var dh = Screen.desktopAvailableHeight;
        var sh = Screen.height;
        if (dh > 0 && sh > 0) return Math.min(dh, sh);
        if (dh > 0) return dh;
        if (sh > 0) return sh;
        return 900;
    }
    readonly property int maxScreenHeight: Math.max(260, Math.round(availScreenHeight * 0.90))
    readonly property int desiredListHeight: {
        if (searchQuery.trim() === "") return 0;
        if (filteredResults.length === 0) return 56;
        return filteredResults.length * (rowHeight + rowSpacing) + 8;
    }
    readonly property int computedHeight: Math.min(maxScreenHeight, headerHeight + desiredListHeight)

    property string searchQuery: ""
    property var allCamerasIndex: []
    property var filteredResults: []

    onComputedHeightChanged: {
        height = computedHeight;
        clampToScreen();
    }

    onHeightChanged: {
        if (height > maxScreenHeight) {
            height = maxScreenHeight;
        }
        clampToScreen();
    }

    function clampToScreen() {
        var minTop = Screen.desktopAvailableTop + 16;
        var maxBottom = Screen.desktopAvailableTop + Screen.desktopAvailableHeight - 16;
        if (y + height > maxBottom) {
            y = Math.max(minTop, maxBottom - height);
        }
        if (y < minTop) {
            y = minTop;
        }
    }

    function escapeHtml(s) {
        return String(s || "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
    }

    function addViewEntry(map, url, entry) {
        if (!map[url]) map[url] = [];
        for (var k = 0; k < map[url].length; ++k) {
            if (map[url][k].label === entry.label) return;
        }
        map[url].push(entry);
    }

    function rebuildIndex() {
        var list = [];
        if (typeof rootWindow === "undefined" || !rootWindow) {
            allCamerasIndex = [];
            updateFilter();
            return;
        }

        // Build map of cameraUrl -> array of { label, color }
        var urlToViews = Object.create(null);
        var collection = rootWindow.layoutsCollectionModel;
        if (collection) {
            for (var li = 0; li < collection.count; ++li) {
                var layout = collection.get(li);
                if (!layout || layout.visible === false) continue;
                var viewLabel = rootWindow.formatLayoutViewLabel ? rootWindow.formatLayoutViewLabel(li, layout) : (layout.name || ("View " + (li + 1)));
                var viewColor = (layout.badgeColor && String(layout.badgeColor).trim() !== "") ? String(layout.badgeColor).trim() : "#cfd8dc";
                var entry = { label: viewLabel, color: viewColor };
                var vpCount = typeof layout.count === "function" ? layout.count() : (layout.count || 0);
                for (var vi = 0; vi < vpCount; ++vi) {
                    var vp = layout.get(vi);
                    if (!vp) continue;
                    var u1 = String(vp.url || "").trim();
                    var u2 = String(vp.secondaryUrl || "").trim();
                    if (u1 !== "") addViewEntry(urlToViews, u1, entry);
                    if (u2 !== "" && u2 !== u1) addViewEntry(urlToViews, u2, entry);
                }
            }
        }

        try {
            var recorders = JSON.parse(rootWindow.hikvisionRecordersJson || "[]");
            for (var ri = 0; ri < recorders.length; ++ri) {
                var rec = recorders[ri];
                if (!rec) continue;
                var recName = (rec.name && String(rec.name).trim() !== "") ? String(rec.name).trim() : String(rec.ip || "");
                var cams = rec.cameras || [];
                for (var ci = 0; ci < cams.length; ++ci) {
                    var cam = cams[ci];
                    if (!cam) continue;
                    var chId = String(cam.channelId || "");
                    var sysName = String(cam.name || "").trim();
                    var custName = String(cam.customName || "").trim();
                    var displayName = custName !== "" ? custName : (sysName !== "" ? sysName : ("CH " + chId));
                    var cameraUrl = "hikvision://" + rec.ip + "/" + chId;
                    var views = urlToViews[cameraUrl] || [];
                    var viewsHtmlParts = [];
                    for (var vIdx = 0; vIdx < views.length; ++vIdx) {
                        viewsHtmlParts.push("<b style='color:" + escapeHtml(views[vIdx].color) + ";'>" + escapeHtml(views[vIdx].label) + "</b>");
                    }
                    var searchBlob = (displayName + " " + sysName + " " + custName + " " + recName + " " + String(rec.ip || "")).toLowerCase();

                    list.push({
                        recorderName: recName,
                        recorderIp: String(rec.ip || ""),
                        recorderInfo: {
                            "ip": String(rec.ip || ""),
                            "port": rec.sdkPort || rec.port || 8000,
                            "sdkPort": rec.sdkPort || rec.port || 8000,
                            "httpPort": rec.httpPort || (rec.port == 8000 ? 80 : rec.port) || 80,
                            "rtspPort": rec.rtspPort || 554,
                            "remoteRecorder": !!rec.remoteRecorder,
                            "username": rec.username || "",
                            "password": rec.password || "",
                            "name": recName
                        },
                        channelId: chId,
                        systemName: sysName,
                        customName: custName,
                        displayName: displayName,
                        cameraUrl: cameraUrl,
                        thumbnailCacheKey: String(rec.ip || "") + "_" + chId,
                        hasViews: views.length > 0,
                        viewsRichText: viewsHtmlParts.join(", "),
                        searchBlob: searchBlob
                    });
                }
            }
        } catch (e) {}

        allCamerasIndex = list;
        updateFilter();
    }

    function updateFilter() {
        var q = searchQuery.trim().toLowerCase();
        if (q === "") {
            filteredResults = [];
            return;
        }
        var tokens = q.split(/\s+/);
        var out = [];
        for (var i = 0; i < allCamerasIndex.length; ++i) {
            var item = allCamerasIndex[i];
            var matched = true;
            for (var t = 0; t < tokens.length; ++t) {
                if (item.searchBlob.indexOf(tokens[t]) === -1) {
                    matched = false;
                    break;
                }
            }
            if (matched) {
                out.push(item);
            }
        }
        filteredResults = out;
    }

    Component.onCompleted: {
        rebuildIndex();
        if (typeof rootWindow !== "undefined" && rootWindow) {
            x = Math.round(rootWindow.x + (rootWindow.width - width) / 2);
            y = Math.round(rootWindow.y + (rootWindow.height - height) / 3);
        }
        clampToScreen();
        searchField.forceActiveFocus();
    }

    onClosing: {
        if (typeof rootWindow !== "undefined" && rootWindow) {
            if (rootWindow.cameraSearchWindowInstance === searchWin) {
                rootWindow.cameraSearchWindowInstance = null;
            }
            if (rootWindow.clearCameraSearchHighlight) {
                rootWindow.clearCameraSearchHighlight();
            }
        }
        searchWin.destroy();
    }

    Component.onDestruction: {
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.cameraSearchWindowInstance === searchWin) {
            rootWindow.cameraSearchWindowInstance = null;
        }
    }

    Connections {
        target: typeof rootWindow !== "undefined" ? rootWindow : null
        function onHikvisionRecordersJsonChanged() {
            searchWin.rebuildIndex();
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: searchWin.close()
    }

    Shortcut {
        sequences: ["Ctrl+F", "Ctrl+S"]
        onActivated: searchWin.close()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Search input bar
        TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            placeholderText: qsTr("LNG_00657")
            placeholderTextColor: "#6c7a89"
            color: "white"
            font.pixelSize: 13
            selectByMouse: true
            leftPadding: 36
            rightPadding: clearBtn.visible ? 34 : 12

            onTextChanged: {
                searchWin.searchQuery = text;
                searchWin.updateFilter();
            }

            background: Rectangle {
                color: "#151d24"
                radius: 6
                border.color: searchField.activeFocus ? "#00f5d4" : "#2a3540"
                border.width: 1
            }

            Image {
                anchors.left: parent.left
                anchors.leftMargin: 11
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: 16
                sourceSize: Qt.size(32, 32)
                fillMode: Image.PreserveAspectFit
                source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%2300f5d4' stroke-width='2.2' stroke-linecap='round' stroke-linejoin='round'><circle cx='11' cy='11' r='8'/><line x1='21' y1='21' x2='16.65' y2='16.65'/></svg>"
            }

            Button {
                id: clearBtn
                visible: searchField.text.length > 0
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                width: 24
                height: 24
                background: Rectangle {
                    color: clearBtn.hovered ? "#2a3540" : "transparent"
                    radius: 4
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 12
                    height: 12
                    source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%238898a6' stroke-width='2.5' stroke-linecap='round'><line x1='18' y1='6' x2='6' y2='18'/><line x1='6' y1='6' x2='18' y2='18'/></svg>"
                }
                onClicked: {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                }
            }
        }

        // Empty state message
        Text {
            visible: searchWin.searchQuery.trim() !== "" && searchWin.filteredResults.length === 0
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            text: qsTr("LNG_00658")
            color: "#8898a6"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        // Results list
        ListView {
            id: resultsListView
            visible: searchWin.filteredResults.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: Math.max(100, searchWin.maxScreenHeight - searchWin.headerHeight - 28)
            clip: true
            spacing: searchWin.rowSpacing
            boundsBehavior: Flickable.StopAtBounds
            model: searchWin.filteredResults

            ScrollBar.vertical: StyledScrollBar {
                scrollView: resultsListView
            }

            delegate: Rectangle {
                id: resultRow
                width: resultsListView.width - (resultsListView.ScrollBar.vertical.visible ? 18 : 0)
                height: searchWin.rowHeight
                radius: 6
                color: rowHover.containsMouse || addBtn.hovered ? "#1a232c" : "#141a21"
                border.color: rowHover.containsMouse || addBtn.hovered ? "#00f5d4" : "#2a3540"
                border.width: 1

                MouseArea {
                    id: rowHover
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 10

                    // Camera thumbnail
                    Rectangle {
                        Layout.preferredWidth: 96
                        Layout.fillHeight: true
                        radius: 4
                        color: "#0b1015"
                        clip: true

                        Image {
                            id: thumbImg
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: "image://thumbnail/" + modelData.thumbnailCacheKey
                            cache: false
                            asynchronous: true
                            smooth: true
                        }

                        Rectangle {
                            anchors.fill: parent
                            visible: thumbImg.status === Image.Error || thumbImg.status === Image.Null
                            color: "#151c24"
                            Text {
                                anchors.centerIn: parent
                                text: "CH " + modelData.channelId
                                color: "#5a6b7c"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }
                    }

                    // Camera + Recorder + User View description
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 3

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: modelData.displayName
                                color: "#eeeeee"
                                font.pixelSize: 12
                                font.bold: true
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                id: sysNameText
                                visible: modelData.customName !== "" && modelData.systemName !== "" && modelData.customName !== modelData.systemName
                                text: "(" + modelData.systemName + ")"
                                color: "#8898a6"
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                Layout.maximumWidth: 220
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: modelData.recorderName
                                color: "#00f5d4"
                                font.pixelSize: 11
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: "•"
                                color: "#5a6b7c"
                                font.pixelSize: 11
                            }

                            Text {
                                Layout.fillWidth: true
                                textFormat: modelData.hasViews ? Text.RichText : Text.PlainText
                                text: modelData.hasViews
                                      ? (searchWin.escapeHtml(qsTr("LNG_00663")) + " " + modelData.viewsRichText)
                                      : qsTr("LNG_00659")
                                color: modelData.hasViews ? "#8898a6" : "#6c7a89"
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }
                        }
                    }

                    // Highlight on layout button
                    Button {
                        id: locateBtn
                        padding: 0
                        enabled: modelData.hasViews
                        opacity: enabled ? 1.0 : 0.35
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        Layout.minimumWidth: 34
                        Layout.maximumWidth: 34
                        Layout.minimumHeight: 34
                        Layout.maximumHeight: 34
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Item {
                            implicitWidth: 34
                            implicitHeight: 34

                            Image {
                                anchors.centerIn: parent
                                width: 18
                                height: 18
                                sourceSize: Qt.size(36, 36)
                                fillMode: Image.PreserveAspectFit
                                source: {
                                    var colorStr = !locateBtn.enabled ? "%2355606d" : (locateBtn.hovered ? "%23ffbe80" : "%238898a6");
                                    return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.1' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='7'/><circle cx='12' cy='12' r='2.5'/><line x1='12' y1='2' x2='12' y2='5'/><line x1='12' y1='19' x2='12' y2='22'/><line x1='2' y1='12' x2='5' y2='12'/><line x1='19' y1='12' x2='22' y2='12'/></svg>";
                                }
                            }
                        }

                        background: Rectangle {
                            color: locateBtn.pressed ? "#cc121214" : (locateBtn.hovered ? "#3a4550" : "#d51c242c")
                            radius: 6
                            border.color: locateBtn.hovered ? "#ffbe80" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.highlightCameraInLayouts) {
                                rootWindow.highlightCameraInLayouts(modelData.cameraUrl);
                            }
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: locateBtn.hovered && locateBtn.enabled
                        ToolTip.text: qsTr("LNG_00665")
                    }

                    // Play in archive button (uses existing app play_small.svg icon)
                    Button {
                        id: playBtn
                        padding: 0
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        Layout.minimumWidth: 34
                        Layout.maximumWidth: 34
                        Layout.minimumHeight: 34
                        Layout.maximumHeight: 34
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Item {
                            implicitWidth: 34
                            implicitHeight: 34

                            Image {
                                id: playBtnIcon
                                anchors.centerIn: parent
                                width: 18
                                height: 18
                                sourceSize: Qt.size(36, 36)
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/images/play_small.svg"
                                visible: false
                            }

                            ColorOverlay {
                                anchors.fill: playBtnIcon
                                source: playBtnIcon
                                color: playBtn.hovered ? "#00f5d4" : "#8898a6"
                            }
                        }

                        background: Rectangle {
                            color: playBtn.pressed ? "#cc121214" : (playBtn.hovered ? "#3a4550" : "#d51c242c")
                            radius: 6
                            border.color: playBtn.hovered ? "#00f5d4" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.openPlaybackWindow) {
                                rootWindow.openPlaybackWindow(modelData.recorderInfo, parseInt(modelData.channelId), modelData.displayName);
                            }
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: playBtn.hovered
                        ToolTip.text: qsTr("LNG_00469")
                    }

                    // Add to selected viewport button (identical to NvrCamerasWindow)
                    Button {
                        id: addBtn
                        padding: 0
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        Layout.minimumWidth: 34
                        Layout.maximumWidth: 34
                        Layout.minimumHeight: 34
                        Layout.maximumHeight: 34
                        Layout.alignment: Qt.AlignVCenter

                        contentItem: Item {
                            implicitWidth: 34
                            implicitHeight: 34

                            Image {
                                anchors.centerIn: parent
                                width: 18
                                height: 18
                                sourceSize: Qt.size(36, 36)
                                fillMode: Image.PreserveAspectFit
                                source: {
                                    var colorStr = addBtn.hovered ? "%2300ff66" : "%238898a6";
                                    return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='12' y1='5' x2='12' y2='19'></line><line x1='5' y1='12' x2='19' y2='12'></line></svg>";
                                }
                            }
                        }

                        background: Rectangle {
                            color: addBtn.pressed ? "#cc121214" : (addBtn.hovered ? "#3a4550" : "#d51c242c")
                            radius: 6
                            border.color: addBtn.hovered ? "#00ff66" : "#2a3540"
                            border.width: 1
                        }

                        onClicked: {
                            var currentLayoutItem = Utils.currentLayout();
                            var activeLayoutModel = Utils.currentModel();
                            var focusIdx = currentLayoutItem ? currentLayoutItem.focusIndex : 0;
                            if (focusIdx < 0) focusIdx = 0;

                            var vp = activeLayoutModel ? activeLayoutModel.get(focusIdx) : null;
                            if (vp) {
                                vp.url = modelData.cameraUrl;
                                vp.secondaryUrl = modelData.cameraUrl;
                                vp.streamMode = 0;
                                Utils.log_info(qsTr("LNG_00069").arg(modelData.recorderName).arg(modelData.channelId).arg(focusIdx + 1));
                            }
                        }

                        ToolTip.delay: Compact.toolTipDelay
                        ToolTip.timeout: Compact.toolTipTimeout
                        ToolTip.visible: addBtn.hovered
                        ToolTip.text: qsTr("LNG_00664")
                    }
                }
            }
        }
    }
}
