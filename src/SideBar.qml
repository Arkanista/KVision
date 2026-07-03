import QtQml 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.12
import CCTV_Viewer.Core 1.0
import CCTV_Viewer.Themes 1.0
import CCTV_Viewer.Utils 1.0
import CCTV_Viewer.Hikvision 1.0
import Qt.labs.platform 1.1 as Platform
import QtQuick.Dialogs 1.3 as QuickDialogs

FocusScope {
    id: rootSideBar

    enum State {
        Compact,
        Popup,
        Expanded
    }

    anchors.fill: parent
    implicitWidth: 800
    implicitHeight: 600

    property int state: SideBar.Expanded
    property int currentViewportIndex: Utils.currentLayout() ? Utils.currentLayout().focusIndex : -1

    onVisibleChanged: {
        resetPathChangesCheckbox();
    }

    function resetPathChangesCheckbox() {
        if (typeof activatePathChangesCheckbox !== "undefined" && activatePathChangesCheckbox) {
            activatePathChangesCheckbox.checked = false;
        }
        if (typeof activateMediaChangesCheckbox !== "undefined" && activateMediaChangesCheckbox) {
            activateMediaChangesCheckbox.checked = false;
        }
    }

    property var regularIndices: []
    property var nvrIndices: []
    property var nvrPresetIndices: []

    property bool hasNewVersion: false
    property string newVersionString: ""

    function parseVersion(vStr) {
        var clean = vStr.replace(/^v/, "");
        var match = clean.match(/^(\d+(?:\.\d+)*)(?:-(\d+))?/);
        if (!match) {
            return { base: [0], rel: 0 };
        }
        var baseParts = match[1].split(".").map(Number);
        var rel = match[2] ? Number(match[2]) : 0;
        return { base: baseParts, rel: rel };
    }

    function compareVersions(v1, v2) {
        var parsed1 = parseVersion(v1);
        var parsed2 = parseVersion(v2);
        var len = Math.max(parsed1.base.length, parsed2.base.length);
        for (var i = 0; i < len; ++i) {
            var p1 = parsed1.base[i] || 0;
            var p2 = parsed2.base[i] || 0;
            if (p1 !== p2) {
                return p1 - p2;
            }
        }
        return parsed1.rel - parsed2.rel;
    }

    function checkForUpdates() {
        if (Context.mockNewVersion) {
            hasNewVersion = true;
            newVersionString = "v9.9.9 (MOCK)";
            return;
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.github.com/repos/Arkanista/KVision/releases/latest", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        var latestVersion = response.tag_name;
                        var currentVersion = Qt.application.version;
                        
                        if (compareVersions(latestVersion, currentVersion) > 0) {
                            hasNewVersion = true;
                            newVersionString = latestVersion;
                        } else {
                            hasNewVersion = false;
                        }
                    } catch (e) {
                        console.error("Failed to parse update check response:", e);
                    }
                }
            }
        }
        xhr.send();
    }

    function updateIndices() {
        var regs = [];
        var nvrs = [];
        var nvrPres = [];
        for (var i = 0; i < layoutsCollectionModel.count; ++i) {
            var layout = layoutsCollectionModel.get(i);
            if (layout) {
                if (layout.isNvr) {
                    nvrs.push(i);
                } else if (layout.isNvrPreset) {
                    nvrPres.push(i);
                } else {
                    regs.push(i);
                }
            }
        }
        regularIndices = regs;
        nvrIndices = nvrs;
        nvrPresetIndices = nvrPres;
    }

    Component.onCompleted: {
        layoutsCollectionModel.changed.connect(updateIndices);
        updateIndices();
        resetPathChangesCheckbox();
        checkForUpdates();
    }

    property var changelogData: [
        {
            version: "v2.6.0",
            date: "03.07.2026",
            changes: [
                qsTr("LNG_00517"),
                qsTr("LNG_00518")
            ]
        },
        {
            version: "v2.5.0",
            date: "03.07.2026",
            changes: [
                qsTr("LNG_00519"),
                qsTr("LNG_00520"),
                qsTr("LNG_00521"),
                qsTr("LNG_00522"),
                qsTr("LNG_00523"),
                qsTr("LNG_00524"),
                qsTr("LNG_00525"),
                qsTr("LNG_00526")
            ]
        },
        {
            version: "v2.4.6",
            date: "02.07.2026",
            changes: [
                qsTr("LNG_00452"),
                qsTr("LNG_00451")
            ]
        },
        {
            version: "v2.4.5",
            date: "02.07.2026",
            changes: [
                qsTr("LNG_00450"),
                qsTr("LNG_00449"),
                qsTr("LNG_00448"),
                qsTr("LNG_00447"),
                qsTr("LNG_00446")
            ]
        },
        {
            version: "v2.4.4",
            date: "02.07.2026",
            changes: [
                qsTr("LNG_00445")
            ]
        },
        {
            version: "v2.4.3",
            date: "01.07.2026",
            changes: [
                qsTr("LNG_00444"),
                qsTr("LNG_00443")
            ]
        },
        {
            version: "v2.4.2",
            date: "01.07.2026",
            changes: [
                qsTr("LNG_00442"),
                qsTr("LNG_00441")
            ]
        },
        {
            version: "v2.4.1",
            date: "01.07.2026",
            changes: [
                qsTr("LNG_00440"),
                qsTr("LNG_00439"),
                qsTr("LNG_00438"),
                qsTr("LNG_00437")
            ]
        },
        {
            version: "v2.4.0",
            date: "30.06.2026",
            changes: [
                qsTr("LNG_00436")
            ]
        },
        {
            version: "v2.3.0",
            date: "30.06.2026",
            changes: [
                qsTr("LNG_00435"),
                qsTr("LNG_00434"),
                qsTr("LNG_00433"),
                qsTr("LNG_00432"),
                qsTr("LNG_00431"),
                qsTr("LNG_00430"),
                qsTr("LNG_00429")
            ]
        },
        {
            version: "v2.2.8-2",
            date: "29.06.2026",
            changes: [
                qsTr("LNG_00428"),
                qsTr("LNG_00427")
            ]
        },
        {
            version: "v2.2.8-1",
            date: "29.06.2026",
            changes: [
                qsTr("LNG_00426"),
                qsTr("LNG_00425"),
                qsTr("LNG_00424"),
                qsTr("LNG_00423"),
                qsTr("LNG_00422"),
                qsTr("LNG_00421"),
                qsTr("LNG_00420"),
                qsTr("LNG_00419")
            ]
        },
        {
            version: "v2.2.7-5",
            date: "29.06.2026",
            changes: [
                qsTr("LNG_00418")
            ]
        },
        {
            version: "v2.2.7-4",
            date: "29.06.2026",
            changes: [
                qsTr("LNG_00417")
            ]
        },
        {
            version: "v2.2.7-3",
            date: "29.06.2026",
            changes: [
                qsTr("LNG_00416"),
                qsTr("LNG_00415"),
                qsTr("LNG_00414"),
                qsTr("LNG_00413"),
                qsTr("LNG_00412"),
                qsTr("LNG_00411"),
                qsTr("LNG_00410"),
                qsTr("LNG_00409"),
                qsTr("LNG_00408"),
                qsTr("LNG_00407")
            ]
        },
        {
            version: "v2.2.6-3",
            date: "27.06.2026",
            changes: [
                qsTr("LNG_00406"),
                qsTr("LNG_00405"),
                qsTr("LNG_00404"),
                qsTr("LNG_00403"),
                qsTr("LNG_00402"),
                qsTr("LNG_00401"),
                qsTr("LNG_00400"),
                qsTr("LNG_00399"),
                qsTr("LNG_00398"),
                qsTr("LNG_00397"),
                qsTr("LNG_00396"),
                qsTr("LNG_00395")
            ]
        },
        {
            version: "v2.2.5",
            date: "25.06.2026",
            changes: [
                qsTr("LNG_00394"),
                qsTr("LNG_00393"),
                qsTr("LNG_00392"),
                qsTr("LNG_00391"),
                qsTr("LNG_00390"),
                qsTr("LNG_00389"),
                qsTr("LNG_00388"),
                qsTr("LNG_00387"),
                qsTr("LNG_00386")
            ]
        },
        {
            version: "v2.2.0",
            date: "24.06.2026",
            changes: [
                qsTr("LNG_00385"),
                qsTr("LNG_00384"),
                qsTr("LNG_00383"),
                qsTr("LNG_00382"),
                qsTr("LNG_00381")
            ]
        },
        {
            version: "v2.1.9",
            date: "23.06.2026",
            changes: [
                qsTr("LNG_00380"),
                qsTr("LNG_00379"),
                qsTr("LNG_00378"),
                qsTr("LNG_00377"),
                qsTr("LNG_00376"),
                qsTr("LNG_00375"),
                qsTr("LNG_00374"),
                qsTr("LNG_00373"),
                qsTr("LNG_00372")
            ]
        },
        {
            version: "v2.1.8",
            date: "23.06.2026",
            changes: [
                qsTr("LNG_00371"),
                qsTr("LNG_00370"),
                qsTr("LNG_00369")
            ]
        },
        {
            version: "v2.1.7",
            date: "23.06.2026",
            changes: [
                qsTr("LNG_00368")
            ]
        },
        {
            version: "v2.1.6",
            date: "23.06.2026",
            changes: [
                qsTr("LNG_00367")
            ]
        },
        {
            version: "v2.1.5",
            date: "23.06.2026",
            changes: [
                qsTr("LNG_00366"),
                qsTr("LNG_00365"),
                qsTr("LNG_00364")
            ]
        },
        {
            version: "v2.1.4",
            date: "23.06.2026",
            changes: [
                qsTr("LNG_00363"),
                qsTr("LNG_00362"),
                qsTr("LNG_00361"),
                qsTr("LNG_00360")
            ]
        },
        {
            version: "v2.1.3",
            date: "22.06.2026",
            changes: [
                qsTr("LNG_00359"),
                qsTr("LNG_00358"),
                qsTr("LNG_00357")
            ]
        },
        {
            version: "v2.1.2",
            date: "19.06.2026",
            changes: [
                qsTr("LNG_00356")
            ]
        },
        {
            version: "v2.1.1",
            date: "19.06.2026",
            changes: [
                qsTr("LNG_00355"),
                qsTr("LNG_00354"),
                qsTr("LNG_00353")
            ]
        },
        {
            version: "v2.1.0",
            date: "19.06.2026",
            changes: [
                qsTr("LNG_00352"),
                qsTr("LNG_00351"),
                qsTr("LNG_00350"),
                qsTr("LNG_00349"),
                qsTr("LNG_00348"),
                qsTr("LNG_00347"),
                qsTr("LNG_00346"),
                qsTr("LNG_00345"),
                qsTr("LNG_00344"),
                qsTr("LNG_00343")
            ]
        },
        {
            version: "v2.0.9-2 (Patch)",
            date: "19.06.2026",
            changes: [
                qsTr("LNG_00342"),
                qsTr("LNG_00341")
            ]
        },
        {
            version: "v2.0.9",
            date: "19.06.2026",
            changes: [
                qsTr("LNG_00340"),
                qsTr("LNG_00339"),
                qsTr("LNG_00338"),
                qsTr("LNG_00337")
            ]
        },
        {
            version: "v2.0.7-8",
            date: "17.06.2026",
            changes: [
                qsTr("LNG_00336"),
                qsTr("LNG_00335")
            ]
        },
        {
            version: "v2.0.6",
            date: "15.06.2026",
            changes: [
                qsTr("LNG_00334"),
                qsTr("LNG_00333"),
                qsTr("LNG_00332"),
                qsTr("LNG_00331"),
                qsTr("LNG_00330"),
                qsTr("LNG_00329"),
                qsTr("LNG_00328"),
                qsTr("LNG_00327"),
                qsTr("LNG_00326")
            ]
        },
        {
            version: "v2.0.0",
            date: "05.06.2026",
            changes: [
                qsTr("LNG_00325"),
                qsTr("LNG_00324"),
                qsTr("LNG_00323"),
                qsTr("LNG_00322"),
                qsTr("LNG_00321"),
                qsTr("LNG_00320")
            ]
        }
    ]

    Settings {
        id: sideBarSettings
        fileName: Context.config.fileName
        category: "SideBar"
        property string windowDivision
        property string itemsState
    }

    function getRecorderName(ip) {
        try {
            var list = JSON.parse(rootWindow.hikvisionRecordersJson);
            for (var i = 0; i < list.length; ++i) {
                if (list[i].ip === ip) {
                    if (list[i].name && list[i].name.trim() !== "") {
                        return list[i].name;
                    }
                    break;
                }
            }
        } catch(e) {}
        return ip;
    }

    // Split Layout Container
    RowLayout {
        id: splitLayout
        anchors.fill: parent
        spacing: 0

        // Left Navigation Sidebar
        Rectangle {
            id: leftSidebar
            Layout.fillHeight: true
            width: 220
            color: "#0b0f13"

            // Right glow separator
            Rectangle {
                anchors.right: parent.right
                width: 1
                height: parent.height
                color: "#2a3540"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                // Logo/Header area
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Image {
                        source: "qrc:/images/256.png"
                        Layout.preferredWidth: leftSidebar.width * 2 / 3
                        Layout.preferredHeight: leftSidebar.width * 2 / 3
                        Layout.alignment: Qt.AlignHCenter
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: qsTr("LNG_00003")
                        color: "#ffffff"
                        font {
                            pixelSize: 20
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        text: qsTr("LNG_00319").arg(Qt.application.version)
                        color: "#00f5d4"
                        font {
                            pixelSize: 12
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        text: qsTr("LNG_00318")
                        color: "#8898a6"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        text: qsTr("LNG_00317")
                        color: "#ff7a00"
                        font {
                            pixelSize: 10
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2a3540"
                }

                // Page selection buttons
                ColumnLayout {
                    id: tabsColumn
                    Layout.fillWidth: true
                    spacing: 8

                    property int activeIndex: 3

                    function selectTab(index) {
                        activeIndex = index;
                        pagesStack.currentIndex = index;
                        rootSideBar.resetPathChangesCheckbox();
                    }

                    // Viewport Page Button
                    Button {
                        id: btnViewport
                        visible: false
                        Layout.fillWidth: true
                        height: 40
                        hoverEnabled: true

                        background: Rectangle {
                            color: tabsColumn.activeIndex === 0 ? "#1c242c" : (btnViewport.hovered ? "#141a21" : "transparent")
                            radius: 6

                            // Active Glowing border
                            Rectangle {
                                anchors.left: parent.left
                                width: 3
                                height: parent.height
                                color: "#00f5d4"
                                visible: tabsColumn.activeIndex === 0
                            }
                        }

                        contentItem: RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 12

                            Item {
                                implicitWidth: 14
                                implicitHeight: 14

                                Image {
                                    id: imgViewport
                                    source: "qrc:/images/menu-viewport.svg"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    layer.enabled: true
                                }

                                ColorOverlay {
                                    anchors.fill: imgViewport
                                    source: imgViewport
                                    color: tabsColumn.activeIndex === 0 ? "#00f5d4" : (btnViewport.hovered ? "white" : "#8898a6")
                                    cached: true
                                }
                            }

                            Text {
                                text: qsTr("LNG_00316").arg(rootSideBar.currentViewportIndex >= 0 ? qsTr("LNG_00315").arg(rootSideBar.currentViewportIndex + 1) : "")
                                color: tabsColumn.activeIndex === 0 ? "#00f5d4" : (btnViewport.hovered ? "white" : "#8898a6")
                                font {
                                    pixelSize: 12
                                    bold: tabsColumn.activeIndex === 0
                                }
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: tabsColumn.selectTab(0)
                    }

                    // Tools Page Button
                    Button {
                        id: btnTools
                        visible: false
                        Layout.fillWidth: true
                        height: 40
                        hoverEnabled: true

                        background: Rectangle {
                            color: tabsColumn.activeIndex === 1 ? "#1c242c" : (btnTools.hovered ? "#141a21" : "transparent")
                            radius: 6

                            Rectangle {
                                anchors.left: parent.left
                                width: 3
                                height: parent.height
                                color: "#00f5d4"
                                visible: tabsColumn.activeIndex === 1
                            }
                        }

                        contentItem: RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 12

                            Item {
                                implicitWidth: 14
                                implicitHeight: 14

                                Image {
                                    id: imgTools
                                    source: "qrc:/images/menu-tools.svg"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    layer.enabled: true
                                }

                                ColorOverlay {
                                    anchors.fill: imgTools
                                    source: imgTools
                                    color: tabsColumn.activeIndex === 1 ? "#00f5d4" : (btnTools.hovered ? "white" : "#8898a6")
                                    cached: true
                                }
                            }

                            Text {
                                text: qsTr("LNG_00314")
                                color: tabsColumn.activeIndex === 1 ? "#00f5d4" : (btnTools.hovered ? "white" : "#8898a6")
                                font {
                                    pixelSize: 12
                                    bold: tabsColumn.activeIndex === 1
                                }
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: tabsColumn.selectTab(1)
                    }

                    // Recorders Page Button
                    Button {
                        id: btnRecorders
                        Layout.fillWidth: true
                        height: 40
                        hoverEnabled: true

                        background: Rectangle {
                            color: tabsColumn.activeIndex === 2 ? "#1c242c" : (btnRecorders.hovered ? "#141a21" : "transparent")
                            radius: 6

                            Rectangle {
                                anchors.left: parent.left
                                width: 3
                                height: parent.height
                                color: "#00f5d4"
                                visible: tabsColumn.activeIndex === 2
                            }
                        }

                        contentItem: RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 12

                            Item {
                                implicitWidth: 14
                                implicitHeight: 14

                                Image {
                                    id: imgRecorders
                                    source: "qrc:/images/menu-recorders.svg"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    layer.enabled: true
                                }

                                ColorOverlay {
                                    anchors.fill: imgRecorders
                                    source: imgRecorders
                                    color: tabsColumn.activeIndex === 2 ? "#00f5d4" : (btnRecorders.hovered ? "white" : "#8898a6")
                                    cached: true
                                }
                            }

                            Text {
                                text: qsTr("LNG_00313")
                                color: tabsColumn.activeIndex === 2 ? "#00f5d4" : (btnRecorders.hovered ? "white" : "#8898a6")
                                font {
                                    pixelSize: 12
                                    bold: tabsColumn.activeIndex === 2
                                }
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: tabsColumn.selectTab(2)
                    }

                    // Presets Page Button
                    Button {
                        id: btnPresets
                        Layout.fillWidth: true
                        height: 40
                        hoverEnabled: true

                        background: Rectangle {
                            color: tabsColumn.activeIndex === 3 ? "#1c242c" : (btnPresets.hovered ? "#141a21" : "transparent")
                            radius: 6

                            Rectangle {
                                anchors.left: parent.left
                                width: 3
                                height: parent.height
                                color: "#00f5d4"
                                visible: tabsColumn.activeIndex === 3
                            }
                        }

                        contentItem: RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 12

                            Item {
                                implicitWidth: 14
                                implicitHeight: 14

                                Image {
                                    id: imgPresets
                                    source: "qrc:/images/menu-presets.svg"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    layer.enabled: true
                                }

                                ColorOverlay {
                                    anchors.fill: imgPresets
                                    source: imgPresets
                                    color: tabsColumn.activeIndex === 3 ? "#00f5d4" : (btnPresets.hovered ? "white" : "#8898a6")
                                    cached: true
                                }
                            }

                            Text {
                                text: qsTr("LNG_00312")
                                color: tabsColumn.activeIndex === 3 ? "#00f5d4" : (btnPresets.hovered ? "white" : "#8898a6")
                                font {
                                    pixelSize: 12
                                    bold: tabsColumn.activeIndex === 3
                                }
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: tabsColumn.selectTab(3)
                    }

                    // General Settings Page Button
                    Button {
                        id: btnSettings
                        Layout.fillWidth: true
                        height: 40
                        hoverEnabled: true

                        background: Rectangle {
                            color: tabsColumn.activeIndex === 4 ? "#1c242c" : (btnSettings.hovered ? "#141a21" : "transparent")
                            radius: 6

                            Rectangle {
                                anchors.left: parent.left
                                width: 3
                                height: parent.height
                                color: "#00f5d4"
                                visible: tabsColumn.activeIndex === 4
                            }
                        }

                        contentItem: RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 12

                            Item {
                                implicitWidth: 14
                                implicitHeight: 14

                                Image {
                                    id: imgSettings
                                    source: "qrc:/images/menu-settings.svg"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    layer.enabled: true
                                }

                                ColorOverlay {
                                    anchors.fill: imgSettings
                                    source: imgSettings
                                    color: tabsColumn.activeIndex === 4 ? "#00f5d4" : (btnSettings.hovered ? "white" : "#8898a6")
                                    cached: true
                                }
                            }

                            Text {
                                text: qsTr("LNG_00311")
                                color: tabsColumn.activeIndex === 4 ? "#00f5d4" : (btnSettings.hovered ? "white" : "#8898a6")
                                font {
                                    pixelSize: 12
                                    bold: tabsColumn.activeIndex === 4
                                }
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: tabsColumn.selectTab(4)
                    }

                    // Changelog Page Button
                    Button {
                        id: btnChangelog
                        Layout.fillWidth: true
                        height: 40
                        hoverEnabled: true

                        background: Rectangle {
                            color: tabsColumn.activeIndex === 5 ? "#1c242c" : (btnChangelog.hovered ? "#141a21" : "transparent")
                            radius: 6

                            Rectangle {
                                anchors.left: parent.left
                                width: 3
                                height: parent.height
                                color: "#00f5d4"
                                visible: tabsColumn.activeIndex === 5
                            }
                        }

                        contentItem: RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 12

                            Item {
                                implicitWidth: 14
                                implicitHeight: 14

                                Image {
                                    id: imgChangelog
                                    source: "qrc:/images/menu-changelog.svg"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    layer.enabled: true
                                }

                                ColorOverlay {
                                    anchors.fill: imgChangelog
                                    source: imgChangelog
                                    color: tabsColumn.activeIndex === 5 ? "#00f5d4" : (btnChangelog.hovered ? "white" : "#8898a6")
                                    cached: true
                                }
                            }

                            Text {
                                text: qsTr("LNG_00310")
                                color: tabsColumn.activeIndex === 5 ? "#00f5d4" : (btnChangelog.hovered ? "white" : "#8898a6")
                                font {
                                    pixelSize: 12
                                    bold: tabsColumn.activeIndex === 5
                                }
                                Layout.fillWidth: true
                            }
                        }

                        onClicked: tabsColumn.selectTab(5)
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                MouseArea {
                    id: updateArea
                    Layout.fillWidth: true
                    implicitHeight: updateLayout.implicitHeight
                    visible: rootSideBar.hasNewVersion
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        Qt.openUrlExternally("https://github.com/Arkanista/KVision/releases/latest")
                    }

                    ColumnLayout {
                        id: updateLayout
                        anchors.fill: parent
                        spacing: 6
                        Layout.alignment: Qt.AlignHCenter

                        Item {
                            implicitWidth: 80
                            implicitHeight: 80
                            Layout.alignment: Qt.AlignHCenter

                            // Glow Ring
                            Rectangle {
                                id: glowRing
                                anchors.centerIn: parent
                                width: 32
                                height: 32
                                radius: 16
                                color: "transparent"
                                border.color: "#2ecc71"
                                border.width: 2.0

                                NumberAnimation on scale {
                                    from: 1.0
                                    to: 2.2
                                    duration: 1600
                                    loops: Animation.Infinite
                                    easing.type: Easing.OutQuad
                                }
                                OpacityAnimator on opacity {
                                    from: 0.8
                                    to: 0.0
                                    duration: 1600
                                    loops: Animation.Infinite
                                    easing.type: Easing.OutQuad
                                }
                            }

                            // Core
                            Rectangle {
                                id: pulsingDot
                                anchors.centerIn: parent
                                width: 32
                                height: 32
                                radius: 16
                                color: "#2ecc71" // Green

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    PropertyAnimation { to: 0.4; duration: 800; easing.type: Easing.InOutQuad }
                                    PropertyAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                                }
                            }
                        }

                        Text {
                            text: qsTr("LNG_00309").arg(rootSideBar.newVersionString)
                            color: updateArea.containsMouse ? "#55efc4" : "#2ecc71"
                            font.pixelSize: 11
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }
                    }
                }

                // Footer version link
                Text {
                    text: "<a href=\"https://github.com/arkanista/kvision\" style=\"color: #8898a6; text-decoration: none;\">GitHub Project</a>"
                    font.pixelSize: 11
                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }

        // Right Stack Panel showing selected page
        StackLayout {
            id: pagesStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 3

            onCurrentIndexChanged: {
                rootSideBar.resetPathChangesCheckbox();
            }

            // PAGE 0: Viewport settings
            ScrollView {
                id: page0ScrollView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: page0Layout
                    x: 24
                    width: page0ScrollView.width - 48
                    spacing: 20

                    Text {
                        text: qsTr("LNG_00308")
                        color: "#00f5d4"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                    }

                    // Placeholder when no viewport is active
                    Text {
                        text: qsTr("LNG_00307")
                        color: "#8898a6"
                        font {
                            pixelSize: 13
                            italic: true
                        }
                        visible: rootSideBar.currentViewportIndex < 0
                        Layout.fillWidth: true
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        visible: rootSideBar.currentViewportIndex >= 0

                        Switch {
                            id: configUnlockSwitch
                            text: qsTr("LNG_00306")
                            checked: false
                            palette.highlight: "#4CAF50"
                            Layout.fillWidth: true
                        }

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
                                spacing: 12

                                TextField {
                                    text: (rootSideBar.currentViewportIndex >= 0 && Utils.currentModel()) ? Utils.currentModel().get(rootSideBar.currentViewportIndex).url : ""
                                    placeholderText: qsTr("LNG_00304")
                                    selectByMouse: true
                                    enabled: configUnlockSwitch.checked && (Utils.currentModel() ? (!Utils.currentModel().isNvr && !Utils.currentModel().isNvrPreset) : true)
                                    Layout.fillWidth: true
                                    onEditingFinished: {
                                        if (rootSideBar.currentViewportIndex >= 0) {
                                            Utils.currentModel().get(rootSideBar.currentViewportIndex).url = text;
                                            Utils.currentModel().get(rootSideBar.currentViewportIndex).streamMode = 0;
                                        }
                                    }
                                }

                                TextField {
                                    text: (rootSideBar.currentViewportIndex >= 0 && Utils.currentModel()) ? Utils.currentModel().get(rootSideBar.currentViewportIndex).secondaryUrl : ""
                                    placeholderText: qsTr("LNG_00303")
                                    selectByMouse: true
                                    enabled: configUnlockSwitch.checked && (Utils.currentModel() ? (!Utils.currentModel().isNvr && !Utils.currentModel().isNvrPreset) : true)
                                    Layout.fillWidth: true
                                    onEditingFinished: {
                                        if (rootSideBar.currentViewportIndex >= 0) {
                                            Utils.currentModel().get(rootSideBar.currentViewportIndex).secondaryUrl = text;
                                        }
                                    }
                                }
                            }
                        }

                        GroupBox {
                            title: qsTr("LNG_00302")
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

                                Button {
                                    text: qsTr("LNG_00301")
                                    enabled: configUnlockSwitch.checked && (rootSideBar.currentViewportIndex >= 0 && Utils.currentLayout() ? Utils.currentLayout().get(rootSideBar.currentViewportIndex).hasAudio : false)
                                    highlighted: !(rootSideBar.currentViewportIndex >= 0 && Utils.currentModel() && Utils.currentModel().get(rootSideBar.currentViewportIndex).volume > 0 || !viewportSettings.noUnmuteWhenFullScreen && Utils.currentLayout() && Utils.currentLayout().fullScreenIndex >= 0)
                                    Layout.fillWidth: true
                                    onClicked: {
                                        if (rootSideBar.currentViewportIndex >= 0) {
                                            if (Utils.currentModel().get(rootSideBar.currentViewportIndex).volume > 0) {
                                                Utils.currentModel().get(rootSideBar.currentViewportIndex).volume = 0;
                                            } else {
                                                Utils.currentModel().get(rootSideBar.currentViewportIndex).volume = 1;
                                            }
                                        }
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: qsTr("LNG_00300")
                                        color: "white"
                                        font.pixelSize: 11
                                    }

                                    TextField {
                                        text: (rootSideBar.currentViewportIndex >= 0 && Utils.currentModel()) ? getOptionsString(Utils.currentModel().get(rootSideBar.currentViewportIndex).avFormatOptions) : ""
                                        selectByMouse: true
                                        enabled: configUnlockSwitch.checked
                                        Layout.fillWidth: true
                                        onEditingFinished: {
                                            if (rootSideBar.currentViewportIndex >= 0) {
                                                var options = Utils.parseOptions(text);
                                                var defaultAVFormatOptions = layoutsCollectionSettings.toJSValue("defaultAVFormatOptions");

                                                if (Object.keys(options).length == Object.keys(defaultAVFormatOptions).length) {
                                                    for (var key in options) {
                                                        if (defaultAVFormatOptions[key] === undefined || String(defaultAVFormatOptions[key]) !== String(options[key])) {
                                                            Utils.currentModel().get(rootSideBar.currentViewportIndex).avFormatOptions = options;
                                                            return;
                                                        }
                                                    }
                                                    Utils.currentModel().get(rootSideBar.currentViewportIndex).avFormatOptions = {};
                                                } else {
                                                    Utils.currentModel().get(rootSideBar.currentViewportIndex).avFormatOptions = options;
                                                }
                                            }
                                        }

                                        function getOptionsString(options) {
                                            Object.assignDefault(options, layoutsCollectionSettings.toJSValue("defaultAVFormatOptions"));
                                            return Utils.stringifyOptions(options);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // PAGE 1: Tools & Layout Options
            ScrollView {
                id: page1ScrollView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: page1Layout
                    x: 24
                    width: page1ScrollView.width - 48
                    spacing: 20

                    Text {
                        text: qsTr("LNG_00299")
                        color: "#00f5d4"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                    }

                    Switch {
                        id: toolsUnlockSwitch
                        text: qsTr("LNG_00298")
                        checked: false
                        palette.highlight: "#4CAF50"
                        Layout.fillWidth: true
                    }

                    GroupBox {
                        title: qsTr("LNG_00297")
                        enabled: toolsUnlockSwitch.checked && !(Utils.currentLayout() && Utils.currentLayout().fullScreenIndex >= 0)
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

                        GridLayout {
                            columns: 3
                            anchors.fill: parent
                            rowSpacing: 8
                            columnSpacing: 8

                            ListModel {
                                id: divisionModel

                                ListElement { size: "1x1" }
                                ListElement { size: "2x2" }
                                ListElement { size: "3x3" }
                                ListElement { size: "4x4" }
                                ListElement { size: "5x5" }
                                ListElement { size: "6x6" }
                                ListElement { size: "7x7" }
                                ListElement { size: "8x8" }
                                ListElement { size: "9x9" }

                                Component.onCompleted: {
                                    fromJSValue(sideBarSettings.windowDivision);
                                    divisionModel.dataChanged.connect(() => {
                                        sideBarSettings.windowDivision = JSON.stringify(toJSValue());
                                    });
                                }

                                function fromJSValue(model) {
                                    var arr;
                                    try {
                                        if (!model.isEmpty()) {
                                            arr = JSON.parse(model);
                                        }
                                    } catch(err) {
                                        Utils.log_error(qsTr("LNG_00219"));
                                    }

                                    if (arr instanceof Array) {
                                        for (var i = 0; i < arr.length; ++i) {
                                            divisionModel.set(i, arr[i]);
                                        }
                                    }
                                }

                                function toJSValue() {
                                    var arr = [];
                                    for (var i = 0; i < divisionModel.count; ++i) {
                                        arr[i] = divisionModel.get(i);
                                    }
                                    return arr;
                                }
                            }

                            Repeater {
                                model: divisionModel
                                delegate: Item {
                                    id: divisionItem
                                    implicitWidth: 100
                                    implicitHeight: 36
                                    Layout.fillWidth: true

                                    Keys.onEscapePressed: {
                                        event.accepted = divisionTextField.visible;
                                        divisionTextField.cancel();
                                    }
                                    Keys.onPressed: {
                                        if (event.key === Qt.Key_F2) {
                                            divisionTextField.edit();
                                        }
                                    }

                                    Button {
                                        text: size
                                        highlighted: Utils.currentModel() && Utils.currentModel().size === str2size(size)
                                        enabled: !generalSettings.lockGridSize
                                        anchors.fill: parent
                                        onClicked: {
                                            if (Utils.currentModel()) {
                                                Utils.currentModel().size = str2size(size);
                                            }
                                        }
                                        onPressAndHold: divisionTextField.edit()

                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: hovered
                                        ToolTip.text: qsTr("LNG_00296")
                                    }

                                    TextField {
                                        id: divisionTextField
                                        visible: false
                                        anchors.fill: parent
                                        horizontalAlignment: TextInput.AlignHCenter
                                        selectByMouse: true
                                        onEditingFinished: {
                                            visible = false;
                                            if(str2size(text)) {
                                                size = text;
                                            }
                                        }

                                        function edit() {
                                            text = size;
                                            visible = true;
                                            forceActiveFocus();
                                        }
                                        function cancel() {
                                            text = size;
                                            visible = false;
                                        }
                                    }

                                    function str2size(str) {
                                        var separatorTr = qsTr("LNG_00295");
                                        var regexp = new RegExp("^[1-9][x%1][1-9]$".arg(separatorTr));
                                        if (regexp.test(str)) {
                                            var size = str.split(new RegExp("[x%1]".arg(separatorTr)));
                                            return Qt.size(size[0], size[1]);
                                        }
                                        return null;
                                    }
                                }
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00294")
                        enabled: toolsUnlockSwitch.checked
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

                            RowLayout {
                                spacing: 12
                                Layout.fillWidth: true

                                Button {
                                    text: "16:9 Aspect Ratio"
                                    highlighted: Utils.currentModel() && Utils.currentModel().aspectRatio === Qt.size(16, 9)
                                    Layout.fillWidth: true
                                    onClicked: {
                                        if (Utils.currentModel()) {
                                            Utils.currentModel().aspectRatio = Qt.size(16, 9);
                                            setRootWindowRatio(Utils.currentModel().aspectRatio);
                                        }
                                    }
                                }
                                Button {
                                    text: "4:3 Aspect Ratio"
                                    highlighted: Utils.currentModel() && Utils.currentModel().aspectRatio === Qt.size(4, 3)
                                    Layout.fillWidth: true
                                    onClicked: {
                                        if (Utils.currentModel()) {
                                            Utils.currentModel().aspectRatio = Qt.size(4, 3);
                                            setRootWindowRatio(Utils.currentModel().aspectRatio);
                                        }
                                    }
                                }
                            }

                            Button {
                                text: qsTr("LNG_00011")
                                highlighted: Context.config.fullScreen
                                Layout.fillWidth: true
                                onClicked: Context.config.fullScreen = !Context.config.fullScreen
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00293")
                        enabled: toolsUnlockSwitch.checked
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

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            Button {
                                text: qsTr("LNG_00292")
                                enabled: Utils.currentLayout() ? Utils.currentLayout().mergeCells(true) : false
                                Layout.fillWidth: true
                                onClicked: if (Utils.currentLayout()) Utils.currentLayout().mergeCells()
                            }
                        }
                    }
                }
            }

            // PAGE 2: NVR Connection Recorders List
            ScrollView {
                id: page2ScrollView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: recordersLayout
                    x: 24
                    width: page2ScrollView.width - 48
                    spacing: 20

                    Text {
                        text: qsTr("LNG_00291")
                        color: "#00f5d4"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                    }

                    NvrSettingsPanel {
                        Layout.fillWidth: true
                    }
                }
            }

            // PAGE 3: Presets & Views list
            ScrollView {
                id: page3ScrollView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: presetsLayout
                    x: 24
                    width: page3ScrollView.width - 48
                    spacing: 20

                    Text {
                        text: qsTr("LNG_00290")
                        color: "#00f5d4"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                    }

                    // Group 1: General Camera Presets
                    GroupBox {
                        title: qsTr("LNG_00289")
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
                            anchors.margins: 4
                            spacing: 8

                            Repeater {
                                model: rootSideBar.regularIndices
                                delegate: RowLayout {
                                    id: presetRow
                                    spacing: 12
                                    Layout.fillWidth: true

                                    property var layout: layoutsCollectionModel.get(modelData)

                                    // Active preset indicator
                                    Rectangle {
                                        width: 4
                                        height: 24
                                        radius: 2
                                        color: stackLayout.currentIndex === modelData ? "#00f5d4" : "transparent"
                                    }

                                    // Editable preset name field
                                    TextField {
                                        id: nameField
                                        text: (presetRow.layout && presetRow.layout.name) ? presetRow.layout.name : ""
                                        placeholderText: qsTr("LNG_00288").arg(index + 1)
                                        selectByMouse: true
                                        Layout.fillWidth: true
                                        color: "white"
                                        background: Rectangle {
                                            color: "#0f151b"
                                            radius: 4
                                            border.color: nameField.activeFocus ? "#ff7a00" : "#2a3540"
                                        }
                                        onEditingFinished: {
                                            if (presetRow.layout) {
                                                presetRow.layout.name = text;
                                            }
                                        }
                                    }

                                    // Visible Checkbox
                                    CheckBox {
                                        text: qsTr("LNG_00278")
                                        checked: presetRow.layout ? presetRow.layout.visible : true
                                        onCheckedChanged: {
                                            if (presetRow.layout) {
                                                presetRow.layout.visible = checked;
                                            }
                                        }
                                        palette.highlight: "#00f5d4"
                                    }

                                    // Activate button
                                    Button {
                                        id: activateBtn
                                        implicitWidth: 28
                                        implicitHeight: 28
                                        highlighted: stackLayout.currentIndex === modelData
                                        onClicked: {
                                            stackLayout.currentIndex = modelData;
                                        }
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            source: {
                                                var colorStr = activateBtn.pressed ? "%23ffffff" : (activateBtn.highlighted ? "%23ffffff" : (activateBtn.hovered ? "%23ffffff" : "%238898a6"));
                                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polygon points='6 3 20 12 6 21 6 3'></polygon></svg>";
                                            }
                                        }
                                        background: Rectangle {
                                            color: activateBtn.pressed ? "#cc121214" : (activateBtn.highlighted ? "#ff7a00" : (activateBtn.hovered ? "#3a4550" : "#1c242c"))
                                            radius: 14
                                            border.color: activateBtn.highlighted ? "#ff9e00" : (activateBtn.hovered ? "#8898a6" : "#2a3540")
                                            border.width: 1
                                        }
                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: activateBtn.hovered
                                        ToolTip.text: qsTr("LNG_00287")
                                    }

                                    // Delete icon button
                                    Button {
                                        id: delPresetBtn
                                        implicitWidth: 28
                                        implicitHeight: 28
                                        visible: rootSideBar.regularIndices.length > 1
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            source: {
                                                var colorStr = delPresetBtn.hovered ? "%23ff4d4d" : "%238898a6";
                                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path><line x1='10' y1='11' x2='10' y2='17'></line><line x1='14' y1='11' x2='14' y2='17'></line></svg>";
                                            }
                                        }
                                        background: Rectangle {
                                            color: delPresetBtn.pressed ? "#40ff0000" : (delPresetBtn.hovered ? "#20ff0000" : "transparent")
                                            radius: 14
                                            border.color: delPresetBtn.hovered ? "#ff4d4d" : "#2a3540"
                                            border.width: 1
                                        }

                                        onClicked: {
                                            presetDeleteDialog.index = modelData;
                                            presetDeleteDialog.open();
                                        }
                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: delPresetBtn.hovered
                                        ToolTip.text: qsTr("LNG_00286")
                                    }
                                }
                            }

                            Button {
                                id: addPresetBtn
                                text: qsTr("LNG_00285")
                                Layout.fillWidth: true
                                implicitHeight: 32
                                onClicked: {
                                    var l = layoutsCollectionModel.append();
                                    l.size = Qt.size(3, 3);
                                }
                                background: Rectangle {
                                    color: addPresetBtn.pressed ? "#cc121214" : (addPresetBtn.hovered ? "#059669" : "#10b981")
                                    radius: 6
                                    border.color: addPresetBtn.hovered ? "#34d399" : "#059669"
                                    border.width: 1
                                }
                                contentItem: Text {
                                    text: addPresetBtn.text
                                    color: "#ffffff"
                                    font.bold: true
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }

                    // Group 2: NVR Views (Only when NVR layouts configured)
                    GroupBox {
                        title: qsTr("LNG_00284")
                        visible: rootSideBar.nvrIndices.length > 0
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
                            anchors.margins: 4
                            spacing: 8

                            Repeater {
                                model: rootSideBar.nvrIndices
                                delegate: RowLayout {
                                    id: nvrRow
                                    spacing: 12
                                    Layout.fillWidth: true

                                    property var layout: layoutsCollectionModel.get(modelData)

                                    Rectangle {
                                        width: 4
                                        height: 24
                                        radius: 2
                                        color: stackLayout.currentIndex === modelData ? "#00f5d4" : "transparent"
                                    }

                                    TextField {
                                        id: nvrNameField
                                        text: (nvrRow.layout && nvrRow.layout.name) ? nvrRow.layout.name : ""
                                        placeholderText: (nvrRow.layout && nvrRow.layout.nvrIp) ? getRecorderName(nvrRow.layout.nvrIp) : qsTr("LNG_00283")
                                        selectByMouse: true
                                        Layout.fillWidth: true
                                        color: "white"
                                        background: Rectangle {
                                            color: "#0f151b"
                                            radius: 4
                                            border.color: nvrNameField.activeFocus ? "#ff7a00" : "#2a3540"
                                        }
                                        onEditingFinished: {
                                            if (nvrRow.layout) {
                                                nvrRow.layout.name = text;
                                            }
                                        }
                                    }

                                    CheckBox {
                                        text: qsTr("LNG_00278")
                                        checked: nvrRow.layout ? nvrRow.layout.visible : true
                                        onCheckedChanged: {
                                            if (nvrRow.layout) {
                                                nvrRow.layout.visible = checked;
                                            }
                                        }
                                        palette.highlight: "#00f5d4"
                                    }

                                    Button {
                                        id: activateBtnNvr
                                        implicitWidth: 28
                                        implicitHeight: 28
                                        highlighted: stackLayout.currentIndex === modelData
                                        onClicked: {
                                            stackLayout.currentIndex = modelData;
                                        }
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            source: {
                                                var colorStr = activateBtnNvr.pressed ? "%23ffffff" : (activateBtnNvr.highlighted ? "%23ffffff" : (activateBtnNvr.hovered ? "%23ffffff" : "%238898a6"));
                                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polygon points='6 3 20 12 6 21 6 3'></polygon></svg>";
                                            }
                                        }
                                        background: Rectangle {
                                            color: activateBtnNvr.pressed ? "#cc121214" : (activateBtnNvr.highlighted ? "#ff7a00" : (activateBtnNvr.hovered ? "#3a4550" : "#1c242c"))
                                            radius: 14
                                            border.color: activateBtnNvr.highlighted ? "#ff9e00" : (activateBtnNvr.hovered ? "#8898a6" : "#2a3540")
                                            border.width: 1
                                        }
                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: activateBtnNvr.hovered
                                        ToolTip.text: qsTr("LNG_00282")
                                    }

                                    Button {
                                        id: delNvrBtn
                                        implicitWidth: 28
                                        implicitHeight: 28
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            source: {
                                                var colorStr = delNvrBtn.hovered ? "%23ff4d4d" : "%238898a6";
                                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path><line x1='10' y1='11' x2='10' y2='17'></line><line x1='14' y1='11' x2='14' y2='17'></line></svg>";
                                            }
                                        }
                                        background: Rectangle {
                                            color: delNvrBtn.pressed ? "#40ff0000" : (delNvrBtn.hovered ? "#20ff0000" : "transparent")
                                            radius: 14
                                            border.color: delNvrBtn.hovered ? "#ff4d4d" : "#2a3540"
                                            border.width: 1
                                        }

                                        onClicked: {
                                            nvrPresetDeleteDialog.index = modelData;
                                            nvrPresetDeleteDialog.open();
                                        }
                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: delNvrBtn.hovered
                                        ToolTip.text: qsTr("LNG_00281")
                                    }
                                }
                            }
                        }
                    }

                    // Group 3: NVR Preset List
                    GroupBox {
                        title: qsTr("LNG_00280")
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
                            anchors.margins: 4
                            spacing: 8

                            Repeater {
                                model: rootSideBar.nvrPresetIndices
                                delegate: RowLayout {
                                    id: nvrPresetRow
                                    spacing: 12
                                    Layout.fillWidth: true

                                    property var layout: layoutsCollectionModel.get(modelData)

                                    Rectangle {
                                        width: 4
                                        height: 24
                                        radius: 2
                                        color: stackLayout.currentIndex === modelData ? "#00f5d4" : "transparent"
                                    }

                                    TextField {
                                        id: nvrPresetNameField
                                        text: (nvrPresetRow.layout && nvrPresetRow.layout.name) ? nvrPresetRow.layout.name : ""
                                        placeholderText: qsTr("LNG_00279").arg(index + 1)
                                        selectByMouse: true
                                        Layout.fillWidth: true
                                        color: "white"
                                        background: Rectangle {
                                            color: "#0f151b"
                                            radius: 4
                                            border.color: nvrPresetNameField.activeFocus ? "#ff7a00" : "#2a3540"
                                        }
                                        onEditingFinished: {
                                            if (nvrPresetRow.layout) {
                                                nvrPresetRow.layout.name = text;
                                            }
                                        }
                                    }

                                    CheckBox {
                                        text: qsTr("LNG_00278")
                                        checked: nvrPresetRow.layout ? nvrPresetRow.layout.visible : true
                                        onCheckedChanged: {
                                            if (nvrPresetRow.layout) {
                                                nvrPresetRow.layout.visible = checked;
                                            }
                                        }
                                        palette.highlight: "#00f5d4"
                                    }

                                    Button {
                                        id: activateBtnNvrPreset
                                        implicitWidth: 28
                                        implicitHeight: 28
                                        highlighted: stackLayout.currentIndex === modelData
                                        onClicked: {
                                            stackLayout.currentIndex = modelData;
                                        }
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            source: {
                                                var colorStr = activateBtnNvrPreset.pressed ? "%23ffffff" : (activateBtnNvrPreset.highlighted ? "%23ffffff" : (activateBtnNvrPreset.hovered ? "%23ffffff" : "%238898a6"));
                                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polygon points='6 3 20 12 6 21 6 3'></polygon></svg>";
                                            }
                                        }
                                        background: Rectangle {
                                            color: activateBtnNvrPreset.pressed ? "#cc121214" : (activateBtnNvrPreset.highlighted ? "#ff7a00" : (activateBtnNvrPreset.hovered ? "#3a4550" : "#1c242c"))
                                            radius: 14
                                            border.color: activateBtnNvrPreset.highlighted ? "#ff9e00" : (activateBtnNvrPreset.hovered ? "#8898a6" : "#2a3540")
                                            border.width: 1
                                        }
                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: activateBtnNvrPreset.hovered
                                        ToolTip.text: qsTr("LNG_00277")
                                    }

                                    Button {
                                        id: delNvrPresetBtn
                                        implicitWidth: 28
                                        implicitHeight: 28
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            source: {
                                                var colorStr = delNvrPresetBtn.hovered ? "%23ff4d4d" : "%238898a6";
                                                return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path><line x1='10' y1='11' x2='10' y2='17'></line><line x1='14' y1='11' x2='14' y2='17'></line></svg>";
                                            }
                                        }
                                        background: Rectangle {
                                            color: delNvrPresetBtn.pressed ? "#40ff0000" : (delNvrPresetBtn.hovered ? "#20ff0000" : "transparent")
                                            radius: 14
                                            border.color: delNvrPresetBtn.hovered ? "#ff4d4d" : "#2a3540"
                                            border.width: 1
                                        }

                                        onClicked: {
                                            nvrPresetDeleteDialog2.index = modelData;
                                            nvrPresetDeleteDialog2.open();
                                        }
                                        ToolTip.delay: Compact.toolTipDelay
                                        ToolTip.timeout: Compact.toolTipTimeout
                                        ToolTip.visible: delNvrPresetBtn.hovered
                                        ToolTip.text: qsTr("LNG_00276")
                                    }
                                }
                            }

                            Button {
                                id: addNvrPresetBtn
                                text: qsTr("LNG_00275")
                                Layout.fillWidth: true
                                implicitHeight: 32
                                onClicked: {
                                    var l = layoutsCollectionModel.append();
                                    l.size = Qt.size(2, 2);
                                    l.isNvrPreset = true;
                                    stackLayout.currentIndex = layoutsCollectionModel.count - 1;
                                }
                                background: Rectangle {
                                    color: addNvrPresetBtn.pressed ? "#cc121214" : (addNvrPresetBtn.hovered ? "#059669" : "#10b981")
                                    radius: 6
                                    border.color: addNvrPresetBtn.hovered ? "#34d399" : "#059669"
                                    border.width: 1
                                }
                                contentItem: Text {
                                    text: addNvrPresetBtn.text
                                    color: "#ffffff"
                                    font.bold: true
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }
                }
            }

            // PAGE 4: General application settings
            ScrollView {
                id: page4ScrollView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: page4Layout
                    x: 24
                    width: page4ScrollView.width - 48
                    spacing: 20

                    Text {
                        text: qsTr("LNG_00274")
                        color: "#00f5d4"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00273")
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
                            spacing: 8

                            CheckBox {
                                text: qsTr("LNG_00272")
                                checked: !generalSettings.singleApplication
                                enabled: false
                                onCheckedChanged: generalSettings.singleApplication = !checked
                                Layout.fillWidth: true
                            }

                            Text {
                                text: qsTr("LNG_00271")
                                color: "#8898a6"
                                font.pixelSize: 10
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#2a3540"
                            }

                            CheckBox {
                                text: qsTr("LNG_00270")
                                checked: NvrStatusManager.monitoringEnabled
                                onCheckedChanged: NvrStatusManager.monitoringEnabled = checked
                                Layout.fillWidth: true
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00269")
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
                            spacing: 8

                            CheckBox {
                                text: qsTr("LNG_00268")
                                checked: generalSettings.disableAudio
                                onCheckedChanged: generalSettings.disableAudio = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00267")
                                checked: viewportSettings.noUnmuteWhenFullScreen
                                onCheckedChanged: viewportSettings.noUnmuteWhenFullScreen = checked
                                Layout.fillWidth: true
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00266")
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
                            spacing: 8

                            CheckBox {
                                text: qsTr("LNG_00265")
                                checked: generalSettings.enableContextMenu
                                onCheckedChanged: generalSettings.enableContextMenu = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00264")
                                checked: generalSettings.allowSwappingViewports
                                enabled: generalSettings.enableContextMenu
                                onCheckedChanged: generalSettings.allowSwappingViewports = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00263")
                                checked: generalSettings.enableRemoveCamera
                                enabled: generalSettings.enableContextMenu
                                onCheckedChanged: generalSettings.enableRemoveCamera = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00262")
                                checked: generalSettings.enableChangeViewportSettings
                                enabled: generalSettings.enableContextMenu
                                onCheckedChanged: generalSettings.enableChangeViewportSettings = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00261")
                                checked: generalSettings.enableStreamSelection
                                enabled: generalSettings.enableContextMenu
                                onCheckedChanged: generalSettings.enableStreamSelection = checked
                                Layout.fillWidth: true
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00260")
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
                            spacing: 8

                            CheckBox {
                                text: qsTr("LNG_00259")
                                checked: viewSettings.showChannelStatus
                                onCheckedChanged: viewSettings.showChannelStatus = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00258")
                                checked: viewSettings.showCameraInfo
                                onCheckedChanged: viewSettings.showCameraInfo = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00257")
                                checked: viewSettings.hoverControlIcons
                                onCheckedChanged: viewSettings.hoverControlIcons = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00256")
                                checked: viewSettings.showInfoOnHoverOnly
                                onCheckedChanged: viewSettings.showInfoOnHoverOnly = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00255")
                                checked: viewSettings.showTopBarByDefault
                                onCheckedChanged: viewSettings.showTopBarByDefault = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00254")
                                checked: viewSettings.hideCursorWhenFullScreen
                                onCheckedChanged: viewSettings.hideCursorWhenFullScreen = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00253")
                                checked: viewSettings.disableViewportZoomAnimation
                                onCheckedChanged: viewSettings.disableViewportZoomAnimation = checked
                                Layout.fillWidth: true
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: qsTr("LNG_00252")
                                    color: "white"
                                    font.pixelSize: 11
                                }

                                ComboBox {
                                    id: sidebarLanguageCombo
                                    Layout.fillWidth: true
                                    model: [
                                        { text: qsTr("LNG_00251"), value: "system" },
                                        { text: "English", value: "en" },
                                        { text: "Polski", value: "pl" },
                                        { text: "العربية (AI)", value: "ar" },
                                        { text: "Български (AI)", value: "bg" },
                                        { text: "简体中文 (AI)", value: "zh" },
                                        { text: "Čeština (AI)", value: "cs" },
                                        { text: "Dansk (AI)", value: "da" },
                                        { text: "Deutsch (AI)", value: "de" },
                                        { text: "Español (AI)", value: "es" },
                                        { text: "Suomi (AI)", value: "fi" },
                                        { text: "Français (AI)", value: "fr" },
                                        { text: "Ελληνικά (AI)", value: "el" },
                                        { text: "Magyar (AI)", value: "hu" },
                                        { text: "Italiano (AI)", value: "it" },
                                        { text: "Nederlands (AI)", value: "nl" },
                                        { text: "Norsk Bokmål (AI)", value: "no" },
                                        { text: "Português (AI)", value: "pt" },
                                        { text: "Română (AI)", value: "ro" },
                                        { text: "Slovenčina (AI)", value: "sk" },
                                        { text: "Svenska (AI)", value: "sv" },
                                        { text: "Türkçe (AI)", value: "tr" },
                                        { text: "Українська (AI)", value: "uk" }
                                    ]
                                    textRole: "text"

                                    background: Rectangle {
                                        implicitHeight: 32
                                        color: "#151d24"
                                        border.color: sidebarLanguageCombo.activeFocus ? "#ff7a00" : "#3a4550"
                                        border.width: 1
                                        radius: 6
                                    }

                                    contentItem: Text {
                                        text: sidebarLanguageCombo.displayText
                                        color: "#eeeeee"
                                        font {
                                            pixelSize: 11
                                            bold: true
                                        }
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: 10
                                    }

                                    delegate: ItemDelegate {
                                        width: sidebarLanguageCombo.width
                                        height: 32
                                        contentItem: Text {
                                            text: modelData.text
                                            color: hovered ? "#00f5d4" : "#eeeeee"
                                            font {
                                                pixelSize: 11
                                                bold: true
                                            }
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: 10
                                        }
                                        background: Rectangle {
                                            color: hovered ? "#2a3540" : "transparent"
                                            border.color: hovered ? "#00f5d4" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                    }

                                    popup: Popup {
                                        y: sidebarLanguageCombo.height + 2
                                        width: sidebarLanguageCombo.width
                                        implicitHeight: Math.min(320, sidebarLanguageCombo.popup.visible ? contentItem.implicitHeight : 0)
                                        padding: 4

                                        contentItem: ListView {
                                            clip: true
                                            implicitHeight: contentHeight
                                            model: sidebarLanguageCombo.popup.visible ? sidebarLanguageCombo.delegateModel : null
                                            currentIndex: sidebarLanguageCombo.highlightedIndex

                                            ScrollIndicator.vertical: ScrollIndicator { }
                                        }

                                        background: Rectangle {
                                            color: "#151d24"
                                            border.color: "#ff7a00"
                                            border.width: 1
                                            radius: 6
                                        }
                                    }
                                    
                                    Component.onCompleted: {
                                        var lang = Context.getLanguage();
                                        for (var i = 0; i < model.length; ++i) {
                                            if (model[i].value === lang) {
                                                currentIndex = i;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    onActivated: {
                                        var selectedLang = model[currentIndex].value;
                                        Context.setLanguage(selectedLang);
                                    }

                                    Connections {
                                        target: Context
                                        function onLanguageChanged() {
                                            var lang = Context.getLanguage();
                                            for (var i = 0; i < sidebarLanguageCombo.model.length; ++i) {
                                                if (sidebarLanguageCombo.model[i].value === lang) {
                                                    sidebarLanguageCombo.currentIndex = i;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: qsTr("LNG_00250")
                                    color: "white"
                                    font.pixelSize: 13
                                }

                                TextField {
                                    id: auxiliaryLimitField
                                    Layout.preferredWidth: 40
                                    Layout.preferredHeight: 30
                                    horizontalAlignment: TextInput.AlignHCenter
                                    selectByMouse: true
                                    text: generalSettings.auxiliaryLimit.toString()
                                    color: "white"
                                    font.pixelSize: 12
                                    maximumLength: 1
                                    validator: IntValidator { bottom: 0; top: 3 }
                                    background: Rectangle {
                                        color: "#0f151b"
                                        radius: 4
                                        border.color: auxiliaryLimitField.activeFocus ? "#ff7a00" : "#2a3540"
                                    }
                                    onTextChanged: {
                                        var val = parseInt(text);
                                        if (!isNaN(val) && val > 3) {
                                            text = "3";
                                        }
                                    }
                                    onEditingFinished: {
                                        var val = parseInt(text);
                                        if (!isNaN(val) && val >= 0 && val <= 3) {
                                            generalSettings.auxiliaryLimit = val;
                                        } else {
                                            text = generalSettings.auxiliaryLimit.toString();
                                        }
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00249")
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
                            spacing: 8

                            CheckBox {
                                text: qsTr("LNG_00248")
                                checked: NvrStatusManager.checkOffline
                                onCheckedChanged: NvrStatusManager.checkOffline = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00247")
                                checked: NvrStatusManager.checkCpu
                                onCheckedChanged: NvrStatusManager.checkCpu = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00246")
                                checked: NvrStatusManager.checkHw
                                onCheckedChanged: NvrStatusManager.checkHw = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00245")
                                checked: NvrStatusManager.checkHdd
                                onCheckedChanged: NvrStatusManager.checkHdd = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00244")
                                checked: NvrStatusManager.checkUnformatted
                                onCheckedChanged: NvrStatusManager.checkUnformatted = checked
                                Layout.fillWidth: true
                            }

                            CheckBox {
                                text: qsTr("LNG_00243")
                                checked: NvrStatusManager.checkFull
                                onCheckedChanged: NvrStatusManager.checkFull = checked
                                Layout.fillWidth: true
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00242")
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
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: qsTr("LNG_00241")
                                    color: "white"
                                    font.pixelSize: 11
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    TextField {
                                        id: playbackOffsetSecondsField
                                        Layout.preferredWidth: 100
                                        Layout.preferredHeight: 30
                                        selectByMouse: true
                                        text: generalSettings.playbackOffsetSeconds.toString()
                                        color: "white"
                                        font.pixelSize: 12
                                        maximumLength: 7
                                        validator: IntValidator { bottom: 0; top: 9999999 }
                                        background: Rectangle {
                                            color: "#0f151b"
                                            radius: 4
                                            border.color: playbackOffsetSecondsField.activeFocus ? "#ff7a00" : "#2a3540"
                                        }
                                        onEditingFinished: {
                                            var val = parseInt(text)
                                            if (!isNaN(val) && val >= 0) {
                                                generalSettings.playbackOffsetSeconds = val
                                            } else {
                                                text = generalSettings.playbackOffsetSeconds.toString()
                                            }
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: qsTr("LNG_00240")
                                    color: "white"
                                    font.pixelSize: 11
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    TextField {
                                        id: playbackTimelineHoursField
                                        Layout.preferredWidth: 60
                                        Layout.preferredHeight: 30
                                        selectByMouse: true
                                        text: generalSettings.playbackTimelineHours.toString()
                                        color: "white"
                                        font.pixelSize: 12
                                        maximumLength: 2
                                        validator: IntValidator { bottom: 1; top: 24 }
                                        background: Rectangle {
                                            color: "#0f151b"
                                            radius: 4
                                            border.color: playbackTimelineHoursField.activeFocus ? "#ff7a00" : "#2a3540"
                                        }
                                        onEditingFinished: {
                                            var val = parseInt(text)
                                            if (!isNaN(val) && val >= 1 && val <= 24) {
                                                generalSettings.playbackTimelineHours = val
                                            } else {
                                                text = generalSettings.playbackTimelineHours.toString()
                                            }
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00239")
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

                            CheckBox {
                                id: activatePathChangesCheckbox
                                text: qsTr("LNG_00231")
                                checked: false
                                Layout.fillWidth: true
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                enabled: activatePathChangesCheckbox.checked
                                opacity: activatePathChangesCheckbox.checked ? 1.0 : 0.5

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: qsTr("LNG_00238")
                                        color: "white"
                                        font.pixelSize: 11
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8

                                        TextField {
                                            id: snapshotPathField
                                            Layout.fillWidth: true
                                            selectByMouse: true
                                            text: generalSettings.snapshotPath
                                            color: "white"
                                            font.pixelSize: 12
                                            background: Rectangle {
                                                color: "#0f151b"
                                                radius: 4
                                                border.color: snapshotPathField.activeFocus ? "#ff7a00" : "#2a3540"
                                            }
                                            onEditingFinished: {
                                                generalSettings.snapshotPath = text
                                                Context.mkpath(text)
                                            }
                                        }

                                        Button {
                                            id: btnBrowseSnapshot
                                            text: "..."
                                            Layout.preferredWidth: 32
                                            Layout.preferredHeight: 30
                                            contentItem: Text {
                                                text: btnBrowseSnapshot.text
                                                font.bold: true
                                                color: "white"
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            background: Rectangle {
                                                color: btnBrowseSnapshot.pressed ? "#2a3540" : (btnBrowseSnapshot.hovered ? "#3a4550" : "#222c36")
                                                radius: 4
                                                border.color: "#2a3540"
                                            }
                                            onClicked: {
                                                 var initial = snapshotPathField.text;
                                                 if (!Context.dirExists(initial)) {
                                                     initial = Context.homePath();
                                                 }
                                                 var selected = Context.selectFolder(qsTr("LNG_00237"), initial);
                                                 if (selected && selected !== "") {
                                                     generalSettings.snapshotPath = selected;
                                                     Context.mkpath(selected);
                                                 }
                                             }
                                        }
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: qsTr("LNG_00236")
                                        color: "white"
                                        font.pixelSize: 11
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8

                                        TextField {
                                            id: videoPathField
                                            Layout.fillWidth: true
                                            selectByMouse: true
                                            text: generalSettings.videoPath
                                            color: "white"
                                            font.pixelSize: 12
                                            background: Rectangle {
                                                color: "#0f151b"
                                                radius: 4
                                                border.color: videoPathField.activeFocus ? "#ff7a00" : "#2a3540"
                                            }
                                            onEditingFinished: {
                                                generalSettings.videoPath = text
                                                Context.mkpath(text)
                                            }
                                        }

                                        Button {
                                            id: btnBrowseVideo
                                            text: "..."
                                            Layout.preferredWidth: 32
                                            Layout.preferredHeight: 30
                                            contentItem: Text {
                                                text: btnBrowseVideo.text
                                                font.bold: true
                                                color: "white"
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            background: Rectangle {
                                                color: btnBrowseVideo.pressed ? "#2a3540" : (btnBrowseVideo.hovered ? "#3a4550" : "#222c36")
                                                radius: 4
                                                border.color: "#2a3540"
                                            }
                                            onClicked: {
                                                 var initial = videoPathField.text;
                                                 if (!Context.dirExists(initial)) {
                                                     initial = Context.homePath();
                                                 }
                                                 var selected = Context.selectFolder(qsTr("LNG_00235"), initial);
                                                 if (selected && selected !== "") {
                                                     generalSettings.videoPath = selected;
                                                     Context.mkpath(selected);
                                                 }
                                             }
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                CctvButton {
                                    text: qsTr("LNG_00234")
                                    isCeladon: true
                                    Layout.fillWidth: true
                                    onClicked: {
                                        var path = generalSettings.snapshotPath;
                                        Context.mkpath(path);
                                        Qt.openUrlExternally("file://" + path);
                                    }
                                }

                                CctvButton {
                                    text: qsTr("LNG_00233")
                                    isCeladon: true
                                    Layout.fillWidth: true
                                    onClicked: {
                                        var path = generalSettings.videoPath;
                                        Context.mkpath(path);
                                        Qt.openUrlExternally("file://" + path);
                                    }
                                }
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("LNG_00232")
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

                            CheckBox {
                                id: activateMediaChangesCheckbox
                                text: qsTr("LNG_00231")
                                checked: false
                                Layout.fillWidth: true
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                enabled: activateMediaChangesCheckbox.checked
                                opacity: activateMediaChangesCheckbox.checked ? 1.0 : 0.5

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: qsTr("LNG_00230")
                                        color: "white"
                                        font.pixelSize: 11
                                    }

                                    TextField {
                                        id: defaultAVFormatOptionsField
                                        selectByMouse: true
                                        Layout.fillWidth: true
                                        color: "white"
                                        font.pixelSize: 12
                                        background: Rectangle {
                                            color: "#0f151b"
                                            radius: 4
                                            border.color: defaultAVFormatOptionsField.activeFocus ? "#ff7a00" : "#2a3540"
                                        }
                                        text: {
                                            var opts = "";
                                            var options = layoutsCollectionSettings.toJSValue("defaultAVFormatOptions");
                                            for (var key in options) {
                                                if (typeof options[key] === "string" || typeof options[key] === "number") {
                                                    opts += "-%1 %2 ".arg(key).arg(options[key]);
                                                }
                                            }
                                            return opts.trim();
                                        }
                                        onEditingFinished: {
                                            layoutsCollectionSettings.defaultAVFormatOptions = JSON.stringify(Utils.parseOptions(text));
                                        }
                                    }

                                    CctvButton {
                                        Layout.fillWidth: true
                                        isCeladon: true
                                        text: qsTr("LNG_00229")
                                        onClicked: {
                                            var opts = layoutsCollectionSettings.toJSValue("defaultAVFormatOptions");
                                            for (var i = 0; i < layoutsCollectionModel.count; ++i) {
                                                var layoutModel = layoutsCollectionModel.get(i);
                                                for (var j = 0; j < layoutModel.count; ++j) {
                                                    var item = layoutModel.get(j);
                                                    if (!item.ignoreGlobalAVFormatOptions) {
                                                        item.avFormatOptions = opts;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // PAGE 5: Changelog
            ScrollView {
                id: page5ScrollView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: page5Layout
                    x: 24
                    width: page5ScrollView.width - 48
                    spacing: 20

                    Text {
                        text: qsTr("LNG_00228")
                        color: "#00f5d4"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                    }

                    Text {
                        text: qsTr("LNG_00227")
                        color: "#8898a6"
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    // Repeater rendering each version entry beautifully
                    Repeater {
                        model: rootSideBar.changelogData
                        delegate: ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Layout.bottomMargin: 16

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: modelData.version
                                    color: "#00f5d4"
                                    font {
                                        pixelSize: 14
                                        bold: true
                                    }
                                }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: modelData.date
                                    color: "#8898a6"
                                    font.pixelSize: 12
                                }
                            }

                            // Divider line
                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#2a3540"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                Layout.leftMargin: 8

                                Repeater {
                                    model: modelData.changes
                                    delegate: RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8
                                        Text {
                                            text: "•"
                                            color: "#00f5d4"
                                            font.pixelSize: 14
                                            Layout.alignment: Qt.AlignTop
                                        }
                                        Text {
                                            text: modelData
                                            color: "#eeeeee"
                                            font.pixelSize: 12
                                            wrapMode: Text.WordWrap
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Modal dialogs declared safely at root scope
    ConfirmDialog {
        id: presetDeleteDialog
        title: qsTr("LNG_00222")
        iconSource: "qrc:/images/icon-trash.svg"
        message: {
            if (index >= 0 && index < layoutsCollectionModel.count) {
                var layout = layoutsCollectionModel.get(index);
                if (layout && layout.name && layout.name.trim() !== "") {
                    return qsTr("LNG_00226").arg(layout.name);
                }
            }
            return qsTr("LNG_00225").arg(index + 1);
        }
        property int index: -1
        onAccepted: layoutsCollectionModel.remove(index)
    }

    ConfirmDialog {
        id: nvrPresetDeleteDialog
        title: qsTr("LNG_00222")
        iconSource: "qrc:/images/icon-trash.svg"
        message: {
            if (index >= 0 && index < layoutsCollectionModel.count) {
                var layout = layoutsCollectionModel.get(index);
                if (layout && layout.name && layout.name.trim() !== "") {
                    return qsTr("LNG_00224").arg(layout.name);
                }
            }
            return qsTr("LNG_00223");
        }
        property int index: -1
        onAccepted: layoutsCollectionModel.remove(index)
    }

    ConfirmDialog {
        id: nvrPresetDeleteDialog2
        title: qsTr("LNG_00222")
        iconSource: "qrc:/images/icon-trash.svg"
        message: {
            if (index >= 0 && index < layoutsCollectionModel.count) {
                var layout = layoutsCollectionModel.get(index);
                if (layout && layout.name && layout.name.trim() !== "") {
                    return qsTr("LNG_00221").arg(layout.name);
                }
            }
            return qsTr("LNG_00220");
        }
        property int index: -1
        onAccepted: layoutsCollectionModel.remove(index)
    }

    Connections {
        target: generalSettings
        function onSnapshotPathChanged() {
            snapshotPathField.text = generalSettings.snapshotPath;
        }
        function onVideoPathChanged() {
            videoPathField.text = generalSettings.videoPath;
        }
        function onAuxiliaryLimitChanged() {
            auxiliaryLimitField.text = generalSettings.auxiliaryLimit.toString();
        }
    }


}
