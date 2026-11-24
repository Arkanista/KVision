import QtQml 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.12
import CCTV_Viewer.Core 1.0
import CCTV_Viewer.Utils 1.0
import CCTV_Viewer.Models 1.0
import CCTV_Viewer.Hikvision 1.0
import QtQuick.Controls 2.12

FocusScope {
    id: root

    property var size: model.size
    property var model: ViewportsLayoutModel {}
    property string color: "black"
    property int pendingSwapSourceIndex: -1

    Component.onDestruction: {
        playerPool.releaseAll();
    }

    QtObject {
        id: playerPool

        property var pool: []
        property var activePlayersMap: ({}) // index -> Player
        property var mediaErrorSlotsMap: ({}) // index -> function

        function acquirePlayer(index, parentContainer, viewportItem) {
            if (activePlayersMap[index] !== undefined) {
                releasePlayer(index);
            }

            var player = null;
            if (pool.length > 0) {
                player = pool.pop();
            } else {
                var component = Qt.createComponent("Player.qml");
                if (component.status === Component.Ready) {
                    player = component.createObject(root);
                } else {
                    console.error("Failed to create Player: " + component.errorString());
                    return null;
                }
            }

            player.parent = parentContainer;

            // Set bindings
            player.visible = Qt.binding(function() {
                var vItem = root.model ? root.model.get(index) : null;
                var itemVis = vItem ? (vItem.visible === ViewportsLayoutItem.Visible) : true;
                return root.effectiveVisible && itemVis;
            });
            player.index = index;
            player.color = Qt.binding(function() { return root.color; });
            player.volume = Qt.binding(function() {
                var vItem = root.model.get(index);
                return vItem ? vItem.volume : 0.0;
            });
            player.muted = Qt.binding(function() {
                if (typeof generalSettings !== "undefined" && generalSettings.disableAudio) {
                    return true;
                }
                if (typeof rootWindow !== "undefined" && rootWindow.isPlaybackWindowOpen) {
                    return true;
                }
                if ((root.size.width > 1 || root.size.height > 1) && !player.isFullScreen) {
                    return true;
                }
                return player.volume <= 0.0;
            });
            player.avOptions = Qt.binding(function() {
                var vItem = root.model.get(index);
                return vItem ? vItem.avFormatOptions : ({});
            });

            player.ignoreGlobalAVFormatOptions = Qt.binding(function() {
                var vItem = root.model.get(index);
                return vItem ? vItem.ignoreGlobalAVFormatOptions : false;
            });

            player.source = Qt.binding(function() {
                var vItem = root.model.get(index);
                if (!vItem) return "";
                var d2Failed = viewportItem.d2SecondaryUrlFailed;
                if (vItem.streamMode === 1) {
                    return vItem.url;
                } else if (vItem.streamMode === 2) {
                    return (String(vItem.secondaryUrl) !== "" && !d2Failed) ? vItem.secondaryUrl : vItem.url;
                } else { // Auto (0)
                    if (!player.isOneToOne && (root.size.width > 1 || root.size.height > 1) && !viewportItem.fullScreen && String(vItem.secondaryUrl) !== "" && !d2Failed) {
                        return vItem.secondaryUrl;
                    }
                    return vItem.url;
                }
            });

            player.isSubStream = Qt.binding(function() {
                var vItem = root.model.get(index);
                if (!vItem) return false;
                var d2Failed = viewportItem.d2SecondaryUrlFailed;
                var urlStr = String(vItem.url);
                var isHik = urlStr.indexOf("hikvision://") === 0;
                var canUseSub = (isHik && !d2Failed) || (String(vItem.secondaryUrl) !== "" && !d2Failed);
                if (vItem.streamMode === 1) {
                    return false;
                } else if (vItem.streamMode === 2) {
                    return canUseSub;
                }
                if (player.isOneToOne) {
                    return false;
                }
                return (root.size.width > 1 || root.size.height > 1) && !viewportItem.fullScreen && canUseSub;
            });

            player.scale = Qt.binding(function() {
                return viewportItem.zoomEnabled ? viewportItem.zoomScale : 1.0;
            });
            player.transformOrigin = Item.TopLeft;
            player.x = Qt.binding(function() {
                return viewportItem.zoomEnabled ? viewportItem.panX : 0;
            });
            player.y = Qt.binding(function() {
                return viewportItem.zoomEnabled ? viewportItem.panY : 0;
            });

            player.width = Qt.binding(function() { return parentContainer.width; });
            player.height = Qt.binding(function() { return parentContainer.height; });
            player.loops = MediaPlayer.Infinite;
            player.isFullScreen = Qt.binding(function() { return root.fullScreenIndex === index; });
            player.layoutModel = root.model;

            // Connect mediaError signal
            var slot = function(errorSource) {
                var vItem = root.model.get(index);
                if (!vItem) return;
                if (errorSource === String(vItem.secondaryUrl)) {
                    viewportItem.d2SecondaryUrlFailed = true;
                } else if (String(vItem.url).indexOf("hikvision://") === 0
                           && /\/Streaming\/Channels\/\d+02$/.test(errorSource)
                           && !player.rtspPortUnreachable
                           && !player.subStreamEverPresented
                           && player.consecutiveSubStreamFailures >= 2) {
                    console.log("[ViewportsLayout] Sub-stream failed twice while RTSP port is reachable; falling back to Main Stream for viewport " + index);
                    viewportItem.d2SecondaryUrlFailed = true;
                }
            };
            player.mediaError.connect(slot);
            mediaErrorSlotsMap[index] = slot;

            activePlayersMap[index] = player;
            return player;
        }

        function releasePlayer(index) {
            var player = activePlayersMap[index];
            if (player) {
                player.parent = null;
                try {
                    var slot = mediaErrorSlotsMap[index];
                    if (slot) {
                        player.mediaError.disconnect(slot);
                    }
                } catch(e) {}
                delete mediaErrorSlotsMap[index];
                
                // Clear bindings so they don't capture parentContainer and viewportItem anymore!
                player.visible = false;
                player.index = -1;
                player.color = "black";
                player.volume = 0;
                player.avOptions = ({});
                player.source = "";
                player.isSubStream = false;
                player.scale = 1.0;
                player.x = 0;
                player.y = 0;
                player.width = 0;
                player.height = 0;

                if (!root.visible) {
                    player.destroy();
                } else {
                    pool.push(player);
                }
                delete activePlayersMap[index];
            }
        }

        function clearPool() {
            for (var i = 0; i < pool.length; i++) {
                if (pool[i]) {
                    pool[i].destroy();
                }
            }
            pool = [];
        }

        function releaseAll() {
            var indices = Object.keys(activePlayersMap);
            for (var i = 0; i < indices.length; i++) {
                releasePlayer(indices[i]);
            }
            clearPool();
            gc(); // Force garbage collection to free detached UI nodes and bindings
        }
    }

    readonly property alias fullScreenIndex: d.fullScreenIndex
    readonly property alias focusIndex: d.focusIndex
    readonly property alias activeFocusIndex: d.activeFocusIndex
    readonly property alias pressAndHoldIndex: d.pressAndHoldIndex
    readonly property alias multiselect: d.multiselect

    property bool holdActiveDuringMove: false
    readonly property bool isHostMovingLayout: (typeof rootWindow !== "undefined" && rootWindow && rootWindow.isMovingLayout) ? true : false
    readonly property bool effectiveVisible: visible || holdActiveDuringMove

    Connections {
        target: (typeof rootWindow !== "undefined" && rootWindow) ? rootWindow : null
        function onIsMovingLayoutChanged() {
            if (rootWindow.isMovingLayout && root.visible) {
                root.holdActiveDuringMove = true;
            } else if (!rootWindow.isMovingLayout) {
                root.holdActiveDuringMove = false;
                if (!root.visible) {
                    d.selectionReset();
                    playerPool.clearPool();
                    gc();
                }
            }
        }
    }

    onVisibleChanged: {
        if (!visible && isHostMovingLayout) {
            holdActiveDuringMove = true;
            return;
        }
        if (visible) {
            holdActiveDuringMove = false;
        }
        d.selectionReset()
        if (!visible) {
            playerPool.clearPool();
            gc(); // Collect garbage immediately after hiding
        }
    }

    QtObject {
        id: d

        property real layoutRatio: (model.aspectRatio.width * model.size.width) / (model.aspectRatio.height * model.size.height);
        property int fullScreenIndex: -1
        property int focusIndex: -1
        property int activeFocusIndex: -1
        property int pressAndHoldIndex: -1
        property int selectionIndex1: focusIndex
        property int selectionIndex2
        property bool multiselect: selectionIndex2 != selectionIndex1
        property int keyModifiers: 0
        property int previewTopLeftIndex: -1
        property int previewSpan: 1

        onLayoutRatioChanged: selectionReset()
        onSelectionIndex1Changed: selectionReset()

        function columnFromIndex(index) {
            return index % root.size.width;
        }

        function rowFromIndex(index) {
            return Math.floor(index / root.size.width);
        }

        function indexFromAddress(column, row) {
            return row * root.size.width + column;
        }

        function selectionTop() {
            var top1 = rowFromIndex(selectionIndex1);
            var top2 = rowFromIndex(selectionIndex2);

            return Math.min(top1, top2);
        }

        function selectionRight() {
            var item1 = root.get(selectionIndex1);
            var item2 = root.get(selectionIndex2);
            var right1 = columnFromIndex(selectionIndex1);
            var right2 = columnFromIndex(selectionIndex2);

            if (item1 !== undefined) {
                right1 += root.get(selectionIndex1).columnSpan;
            }
            if (item2 !== undefined) {
                right2 += root.get(selectionIndex2).columnSpan;
            }

            return Math.max(right1, right2);
        }

        function selectionBottom() {
            var item1 = root.get(selectionIndex1);
            var item2 = root.get(selectionIndex2);
            var bottom1 = rowFromIndex(selectionIndex1);
            var bottom2 = rowFromIndex(selectionIndex2);

            if (item1 !== undefined) {
                bottom1 += root.get(selectionIndex1).rowSpan;
            }
            if (item2 !== undefined) {
                bottom2 += root.get(selectionIndex2).rowSpan;
            }

            return Math.max(bottom1, bottom2);
        }

        function selectionLeft() {
            var left1 = columnFromIndex(selectionIndex1);
            var left2 = columnFromIndex(selectionIndex2);

            return Math.min(left1, left2);
        }

        function selectionWidth() {
            return selectionRight() - selectionLeft();
        }

        function selectionHeight() {
            return selectionBottom() - selectionTop();
        }

        function selectionContains(index) {
            var column = columnFromIndex(index);
            var row = rowFromIndex(index);

            if (get(index) !== undefined && get(index).visible &&
                    column >= selectionLeft() && column < selectionRight() &&
                    row >= selectionTop() && row < selectionBottom()) {
                return true;
            }

            return false;
        }

        function selectionReset() {
            selectionIndex2 = selectionIndex1;
        }

        function previewContains(index) {
            if (previewTopLeftIndex < 0 || previewSpan < 2) {
                return false;
            }
            var pc = columnFromIndex(previewTopLeftIndex);
            var pr = rowFromIndex(previewTopLeftIndex);
            var col = columnFromIndex(index);
            var row = rowFromIndex(index);
            return col >= pc && col < pc + previewSpan && row >= pr && row < pr + previewSpan;
        }
    }

    Rectangle {
        color: root.color
        anchors.fill: parent
    }

    GridLayout {
        id: layout

        width: (root.width / root.height <= d.layoutRatio) ? root.width : root.height * d.layoutRatio;
        height: (root.width / root.height < d.layoutRatio) ? root.width / d.layoutRatio : root.height;
        columns: root.size.width
        rows: root.size.height
        columnSpacing: 0
        rowSpacing: 0
        anchors.centerIn: parent

        Repeater {
            id: repeater

            model: root.effectiveVisible ? root.model : null

            onCountChanged: {
                if (d.fullScreenIndex >= count) {
                    d.fullScreenIndex = -1;
                }
                if (d.focusIndex) {
                    if (count == 1) {
                        d.focusIndex = 0;
                    } else {
                        d.focusIndex = -1;
                    }
                }
                if (d.activeFocusIndex) {
                    d.activeFocusIndex = -1;
                }
                if (d.pressAndHoldIndex) {
                    d.pressAndHoldIndex = -1;
                }
            }

            delegate: Item {
                id: container

                implicitWidth: (layout.width / root.size.width) * Math.max(viewport.columnSpan, 0)
                implicitHeight: (layout.height / root.size.height) * Math.max(viewport.rowSpan, 0)
                visible: root.effectiveVisible && ((model.visible === ViewportsLayoutItem.Visible) ? true : false)

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: Math.max(viewport.columnSpan, 1);
                Layout.rowSpan: Math.max(viewport.rowSpan, 1);

                Item {
                    id: viewport

                    x: 0
                    y: 0
                    width: parent.width
                    height: parent.height
                    activeFocusOnTab: d.fullScreenIndex < 0 || d.fullScreenIndex === model.index

                    // Drag source on the visible viewport itself!
                    Drag.active: viewportMouseArea.drag.active
                    Drag.dragType: Drag.Automatic
                    Drag.supportedActions: Qt.MoveAction
                    Drag.mimeData: {
                        "application/x-cctv-viewport-index": String(model.index)
                    }

                    readonly property int viewportIndex: model.index
                    property int cursorColumnOffset: 0
                    property int cursorRowOffset: 0
                    property bool fullScreen: false

                    property var player: null
                    property alias d2SecondaryUrlFailed: d2.secondaryUrlFailed

                    Component.onCompleted: {
                        player = playerPool.acquirePlayer(model.index, playerContainer, viewport);
                    }
                    Component.onDestruction: {
                        playerPool.releasePlayer(model.index);
                    }
                    
                    // Zoom properties
                    property real zoomScale: 1.0
                    property real panX: 0
                    property real panY: 0
                    readonly property bool zoomEnabled: fullScreen || (root.size.width === 1 && root.size.height === 1)

                    readonly property alias selected: d2.selected

                    readonly property alias url: d2.url
                    readonly property alias secondaryUrl: d2.secondaryUrl
                    readonly property alias column: d2.column
                    readonly property alias row: d2.row
                    readonly property alias columnSpan: d2.columnSpan
                    readonly property alias rowSpan: d2.rowSpan
                    readonly property alias volume: d2.volume
                    readonly property alias avFormatOptions: d2.avFormatOptions
                    readonly property alias streamMode: d2.streamMode

                    readonly property alias topIndex: d2.topIndex
                    readonly property alias rightIndex: d2.rightIndex
                    readonly property alias bottomIndex: d2.bottomIndex
                    readonly property alias leftIndex: d2.leftIndex

                    readonly property bool hasAudio: player ? player.hasAudio : false

                    states: [
                        State {
                            name: "fullScreen"
                            when: viewport.fullScreen

                            PropertyChanges {
                                target: viewport
                                // HACK: Вводим зависимость от размера container для того,
                                // чтобы инициировать пересчет позиции viewport при изменении размера GridLayout.
                                x: container.width ? -container.mapToItem(layout, 0, 0).x : 0
                                y: container.height ? -container.mapToItem(layout, 0, 0).y : 0
                                width: layout.width
                                height: layout.height
                            }
                            PropertyChanges {
                                target: viewport.parent
                                z: 1
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            enabled: typeof viewSettings !== "undefined" ? !viewSettings.disableViewportZoomAnimation : true
                            ParallelAnimation {
                                PropertyAnimation {
                                    properties: "x, y, z, width, height"
                                    easing.type: Easing.Linear
                                    duration: 250
                                }
                            }
                        }
                    ]

                    onVisibleChanged: {
                        fullScreen = false;
                        resetZoom();
                    }
                    property real preFullScreenVolume: 0.0

                    onFullScreenChanged: {
                        d2.setCurrentIndex("fullScreenIndex", fullScreen)
                        var vItem = root.model.get(model.index);
                        if (vItem) {
                            if (fullScreen) {
                                preFullScreenVolume = vItem.volume;
                                if (!viewportSettings.noUnmuteWhenFullScreen && vItem.volume <= 0.0) {
                                    vItem.volume = 1.0;
                                }
                            } else {
                                resetZoom();
                                if (!viewportSettings.noUnmuteWhenFullScreen) {
                                    vItem.volume = preFullScreenVolume;
                                }
                            }
                        } else if (!fullScreen) {
                            resetZoom();
                        }
                    }
                    onZoomEnabledChanged: {
                        if (!zoomEnabled) {
                            resetZoom();
                        }
                    }
                    onFocusChanged: {
                        d2.setCurrentIndex("focusIndex", focus);
                        d2.setCurrentIndex("pressAndHoldIndex", false);
                        if (!activeFocus) {
                            fullScreen = false;
                        }
                    }
                    onActiveFocusChanged: d2.setCurrentIndex("activeFocusIndex", activeFocus)
                    onSelectedChanged: {
                        if (!selected) {
                            cursorColumnOffset = 0;
                            cursorRowOffset = 0;
                        }
                    }

                    function resetZoom() {
                        zoomScale = 1.0;
                        panX = 0;
                        panY = 0;
                    }

                    Keys.onPressed: {
                        var fullScreenKey = QT_TR_NOOP("F", "Shortcut");
                        if (event.text.toUpperCase() === fullScreenKey ||
                            event.text.toUpperCase() === qsTr(fullScreenKey)) {
                            fullScreen = (root.size.width > 1 || root.size.height > 1) ? !fullScreen : false;
                            d.selectionReset();
                        }

                        function keyNavigationHandler(keyNavigationCallback) {
                            if (!fullScreen) {
                                if (d.activeFocusIndex >= 0 && d.keyModifiers & Qt.ShiftModifier) {
                                    d.selectionIndex2 = keyNavigationCallback(d.selectionIndex2);
                                } else {
                                    root.get(keyNavigationCallback(model.index)).forceActiveFocus();
                                }
                            }
                        }

                        switch (event.key) {
                        case Qt.Key_Escape:
                            focus = false;
                            fullScreen = false;
                            break;
                        case Qt.Key_Up:
                            function keyUpCallback(index) {
                                var topIndex = root.get(index).topIndex;

                                if (topIndex !== index) {
                                    root.get(topIndex).cursorColumnOffset =
                                            d.columnFromIndex(index) + root.get(index).cursorColumnOffset - d.columnFromIndex(topIndex);
                                } else {
                                    root.get(index).cursorRowOffset = Math.max(root.get(index).cursorRowOffset - 1, 0);
                                }

                                return topIndex;
                            }

                            keyNavigationHandler(keyUpCallback);
                            break;
                        case Qt.Key_Down:
                            function keyDownCallback(index) {
                                var bottomIndex = root.get(index).bottomIndex;

                                if (bottomIndex !== index) {
                                    root.get(bottomIndex).cursorColumnOffset =
                                            d.columnFromIndex(index) + root.get(index).cursorColumnOffset - d.columnFromIndex(bottomIndex);
                                } else {
                                    root.get(index).cursorRowOffset = Math.min(root.get(index).cursorRowOffset + 1, root.get(index).rowSpan - 1);
                                }

                                return bottomIndex;
                            }

                            keyNavigationHandler(keyDownCallback);
                            break;
                        case Qt.Key_Right:
                            function keyRightCallback(index) {
                                var rightIndex = root.get(index).rightIndex;

                                if (rightIndex !== index) {
                                    root.get(rightIndex).cursorRowOffset =
                                            d.rowFromIndex(index) + root.get(index).cursorRowOffset - d.rowFromIndex(rightIndex);
                                } else {
                                    root.get(index).cursorColumnOffset = Math.min(root.get(index).cursorColumnOffset + 1, root.get(index).columnSpan - 1);
                                }

                                return rightIndex;
                            }

                            keyNavigationHandler(keyRightCallback);
                            break;
                        case Qt.Key_Left:
                            function keyLeftCallback(index) {
                                var leftIndex = root.get(index).leftIndex;

                                if (leftIndex !== index) {
                                    root.get(leftIndex).cursorRowOffset =
                                            d.rowFromIndex(index) + root.get(index).cursorRowOffset - d.rowFromIndex(leftIndex);
                                } else {
                                    root.get(index).cursorColumnOffset = Math.max(root.get(index).cursorColumnOffset - 1, 0);
                                }

                                return leftIndex;
                            }

                            keyNavigationHandler(keyLeftCallback);
                            break;
                        case Qt.Key_Plus:
                        case Qt.Key_Equal:
                            if (event.text === "+" || event.key === Qt.Key_Plus) {
                                if (viewport.player && viewport.player.recorderIp !== "") {
                                     if (!event.isAutoRepeat) {
                                         HikvisionManager.ptzZoom(viewport.player.recorderIp, viewport.player.recorderPort, viewport.player.username, viewport.player.password, viewport.player.channelId, 11, false);
                                     }
                                     event.accepted = true;
                                 }
                            }
                            break;
                        case Qt.Key_Minus:
                            if (event.text === "-" || event.key === Qt.Key_Minus) {
                                if (viewport.player && viewport.player.recorderIp !== "") {
                                     if (!event.isAutoRepeat) {
                                         HikvisionManager.ptzZoom(viewport.player.recorderIp, viewport.player.recorderPort, viewport.player.username, viewport.player.password, viewport.player.channelId, 12, false);
                                     }
                                     event.accepted = true;
                                 }
                            }
                            break;
                        }
                    }

                    Keys.onReleased: {
                        if (event.isAutoRepeat) {
                            return;
                        }
                        if (event.key === Qt.Key_Plus || event.key === Qt.Key_Equal || event.text === "+") {
                            if (viewport.player && viewport.player.recorderIp !== "") {
                                HikvisionManager.ptzZoom(viewport.player.recorderIp, viewport.player.recorderPort, viewport.player.username, viewport.player.password, viewport.player.channelId, 11, true);
                                event.accepted = true;
                            }
                        } else if (event.key === Qt.Key_Minus || event.text === "-") {
                            if (viewport.player && viewport.player.recorderIp !== "") {
                                HikvisionManager.ptzZoom(viewport.player.recorderIp, viewport.player.recorderPort, viewport.player.username, viewport.player.password, viewport.player.channelId, 12, true);
                                event.accepted = true;
                            }
                        }
                    }

                    QtObject {
                        id: d2

                        property bool selected: d.selectionContains(model.index)

                        property string url: model.url
                        property string secondaryUrl: model.secondaryUrl
                        property bool secondaryUrlFailed: false
                        property int column: d.columnFromIndex(model.index)
                        property int row: d.rowFromIndex(model.index)
                        property int columnSpan: model.columnSpan
                        property int rowSpan: model.rowSpan
                        property real volume: model.volume
                        property var avFormatOptions: model.avFormatOptions
                        property int streamMode: model.streamMode

                        onSecondaryUrlChanged: secondaryUrlFailed = false

                        property int topIndex: spanningIndex(viewport.column + viewport.cursorColumnOffset,
                                                             Number(viewport.row - 1).clamp(0, root.size.height - 1))

                        property int bottomIndex: spanningIndex(viewport.column + viewport.cursorColumnOffset,
                                                                Number(viewport.row + viewport.rowSpan).clamp(0, root.size.height - 1))

                        property int rightIndex: spanningIndex(Utils.ifLeftToRight(
                                                               Number(viewport.column + viewport.columnSpan).clamp(0, root.size.width - 1),
                                                               Number(viewport.column - 1).clamp(0, root.size.width - 1)),
                                                               viewport.row + viewport.cursorRowOffset)

                        property int leftIndex: spanningIndex(Utils.ifLeftToRight(
                                                              Number(viewport.column - 1).clamp(0, root.size.width - 1),
                                                              Number(viewport.column + viewport.columnSpan).clamp(0, root.size.width - 1)),
                                                              viewport.row + viewport.cursorRowOffset)

                        function setCurrentIndex(key, current) {
                            if (current === true) {
                                d[key] = model.index;
                            } else if (d[key] === model.index) {
                                d[key] = -1;
                            }
                        }

                        function spanningIndex(column, row) {
                            var spanningIndex = d.indexFromAddress(column, row);

                            if (spanningIndex !== model.index) {
                                var spanningItem = root.get(spanningIndex);

                                if (spanningItem !== undefined && !spanningItem.visible) {
                                    spanningIndex = d.indexFromAddress(d.columnFromIndex(spanningIndex) + spanningItem.columnSpan,
                                                                       d.rowFromIndex(spanningIndex) + spanningItem.rowSpan);
                                }
                            }

                            return spanningIndex;
                        }
                    }

                    Rectangle {
                        id: playerContainer

                        color: root.color
                        anchors.fill: parent
                        clip: true
                    }

                    Rectangle {
                        id: emptyViewportBorder
                        anchors.fill: parent
                        color: "transparent"
                        border.width: 1
                        border.color: "#182026"
                        visible: model.url === ""
                    }

                    Rectangle {
                        id: selectionRect

                        color: "transparent"
                        anchors.fill: parent

                        states: [
                            State {
                                name: "multiselect"
                                when: root.multiselect && viewport.selected

                                PropertyChanges {
                                    target: selectionRect
                                    color: "#4000a8ff"
                                }
                            },
                            State {
                                name: "mergePreview"
                                when: d.previewContains(model.index)

                                PropertyChanges {
                                    target: selectionRect
                                    color: "#4500f5d4"
                                }
                            }
                        ]
                    }

                    Rectangle {
                        id: selectionFrame

                        color: "transparent"
                        border.color: "transparent"
                        anchors.fill: parent

                        states: [
                            State {
                                name: "active"
                                when: viewport.activeFocus && !Context.config.kioskMode

                                PropertyChanges {
                                    target: selectionFrame
                                    border.width: 1
                                    border.color: "#00dd00"
                                }
                            },
                            State {
                                name: "swapSource"
                                when: root.pendingSwapSourceIndex === model.index

                                PropertyChanges {
                                    target: selectionFrame
                                    border.width: 2
                                    border.color: "#00f5d4"
                                }
                            },
                            State {
                                name: "mergePreview"
                                when: d.previewContains(model.index)

                                PropertyChanges {
                                    target: selectionFrame
                                    border.width: 2
                                    border.color: "#00f5d4"
                                }
                            }
                        ]
                    }

                    // Search highlight frame (pulsing glowing border when located from CameraSearchWindow)
                    Rectangle {
                        id: searchHighlightFrame
                        anchors.fill: parent
                        z: 25
                        readonly property bool isHighlighted: (typeof rootWindow !== "undefined" && rootWindow && rootWindow.highlightedCameraUrl !== "")
                                                              && (String(model.url || "").trim() === rootWindow.highlightedCameraUrl || String(model.secondaryUrl || "").trim() === rootWindow.highlightedCameraUrl)
                        visible: isHighlighted
                        color: "#1800f5d4"
                        border.color: "#00f5d4"
                        border.width: 3

                        SequentialAnimation on opacity {
                            running: searchHighlightFrame.visible
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.35; duration: 420; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 0.35; to: 1.0; duration: 420; easing.type: Easing.InOutQuad }
                        }
                    }

                    Item {
                        id: dragDummyViewport
                        width: 1; height: 1
                        visible: false
                    }
                    MouseArea {
                        id: viewportMouseArea
                        z: -1
                        anchors.fill: parent
                        
                        // Enable wheel events for zooming
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        drag.target: dragDummyViewport
                        drag.threshold: 15
                        cursorShape: root.pendingSwapSourceIndex >= 0 ? Qt.DragMoveCursor : Qt.ArrowCursor

                        onPressed: {
                            if (mouse.button === Qt.RightButton) {
                                if (generalSettings.enableContextMenu) {
                                    root.pendingSwapSourceIndex = -1;
                                    if (!d.multiselect || !d.selectionContains(model.index)) {
                                        viewport.forceActiveFocus();
                                        d.selectionReset();
                                    }
                                    contextMenu.popupAt(viewportMouseArea, mouse.x, mouse.y);
                                }
                                return;
                            }
                            console.log("[CCTV Viewer Debug] Pressed viewport. index =", model.index, "pendingSwapSourceIndex =", root.pendingSwapSourceIndex);
                            if (root.pendingSwapSourceIndex >= 0 && generalSettings.allowSwappingViewports) {
                                var sourceIndex = root.pendingSwapSourceIndex;
                                var targetIndex = model.index;
                                if (sourceIndex !== targetIndex) {
                                    var sourceItem = root.model.get(sourceIndex);
                                    var targetItem = root.model.get(targetIndex);
                                    if (sourceItem && targetItem) {
                                        var tempUrl = sourceItem.url;
                                        var tempSecUrl = sourceItem.secondaryUrl;
                                        var tempVol = sourceItem.volume;
                                        var tempOpts = sourceItem.avFormatOptions;
                                        var tempStreamMode = sourceItem.streamMode;

                                        sourceItem.url = targetItem.url;
                                        sourceItem.secondaryUrl = targetItem.secondaryUrl;
                                        sourceItem.volume = targetItem.volume;
                                        sourceItem.avFormatOptions = targetItem.avFormatOptions;
                                        sourceItem.streamMode = targetItem.streamMode;

                                        targetItem.url = tempUrl;
                                        targetItem.secondaryUrl = tempSecUrl;
                                        targetItem.volume = tempVol;
                                        targetItem.avFormatOptions = tempOpts;
                                        targetItem.streamMode = tempStreamMode;

                                        Utils.log_info("Swapped viewport " + (sourceIndex + 1) + " with " + (targetIndex + 1));
                                    }
                                }
                                root.pendingSwapSourceIndex = -1;
                            } else {
                                if (d.activeFocusIndex >= 0 && d.keyModifiers & Qt.ShiftModifier) {
                                    d.selectionIndex2 = model.index;
                                } else {
                                    viewport.forceActiveFocus();
                                    d.selectionReset();
                                }
                            }
                        }
                        onReleased: {
                            dragDummyViewport.x = 0;
                            dragDummyViewport.y = 0;
                        }
                        onPressAndHold: d2.setCurrentIndex("pressAndHoldIndex", true)
                        onDoubleClicked: {
                            viewport.fullScreen = (root.size.width > 1 || root.size.height > 1) ? !viewport.fullScreen : false;
                            d.selectionReset();
                        }

                        onMouseXChanged: mouseMoveHandler()
                        onMouseYChanged: mouseMoveHandler()
                        
                        // Handle mousewheel zoom when in fullscreen (requires CTRL modifier)
                        onWheel: {
                            if (wheel.modifiers & Qt.ControlModifier) {
                                if (!viewport.fullScreen && (root.size.width > 1 || root.size.height > 1)) {
                                    viewport.fullScreen = true;
                                    viewport.forceActiveFocus();
                                    d.selectionReset();
                                }

                                if (viewport.zoomEnabled) {
                                    var delta = wheel.angleDelta.y / 120;
                                    var zoomFactor = 1 + (delta * 0.1);

                                    var newScale = viewport.zoomScale * zoomFactor;
                                    newScale = Number(newScale).clamp(1.0, 10.0);

                                    if (newScale !== viewport.zoomScale) {
                                        var mouseX = wheel.x;
                                        var mouseY = wheel.y;

                                        var imageX = (mouseX - viewport.panX) / viewport.zoomScale;
                                        var imageY = (mouseY - viewport.panY) / viewport.zoomScale;

                                        viewport.zoomScale = newScale;

                                        viewport.panX = mouseX - imageX * newScale;
                                        viewport.panY = mouseY - imageY * newScale;

                                        var minPanX = viewport.width - (viewport.width * newScale);
                                        var maxPanX = 0;
                                        var minPanY = viewport.height - (viewport.height * newScale);
                                        var maxPanY = 0;

                                        viewport.panX = Number(viewport.panX).clamp(minPanX, maxPanX);
                                        viewport.panY = Number(viewport.panY).clamp(minPanY, maxPanY);
                                    }
                                }

                                wheel.accepted = true;
                            }
                        }

                        function mouseMoveHandler() {
                            if (!containsMouse) {
                                var selectionIndex2 = viewport.indexAt(mouseX, mouseY);

                                if (selectionIndex2 >= 0) {
                                    d.selectionIndex2 = selectionIndex2;
                                }
                            } else {
                                if (!(d.keyModifiers & Qt.ShiftModifier)) {
                                    d.selectionReset();
                                }
                            }
                        }
                    }

                    Popup {
                        id: contextMenu
                        parent: Overlay.overlay
                        modal: false
                        focus: true
                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                        padding: 0
                        topPadding: 5
                        bottomPadding: 5
                        leftPadding: 1
                        rightPadding: 1

                        function popupAt(sourceItem, mx, my) {
                            var pt = sourceItem.mapToItem(Overlay.overlay, mx, my);
                            var menuW = Math.max(implicitWidth, 167);
                            var menuH = Math.max(implicitHeight, contextMenuColumn.implicitHeight + topPadding + bottomPadding);
                            var maxX = Overlay.overlay ? Math.max(0, Overlay.overlay.width - menuW) : pt.x;
                            var maxY = Overlay.overlay ? Math.max(0, Overlay.overlay.height - menuH) : pt.y;
                            x = Math.max(0, Math.min(pt.x, maxX));
                            y = Math.max(0, Math.min(pt.y, maxY));
                            open();
                        }
                        
                        onClosed: {
                            streamSubMenu.close();
                            mergeSubMenu.close();
                            addCameraSubMenu.close();
                            d.previewTopLeftIndex = -1;
                            d.previewSpan = 1;
                        }
                        
                        enter: Transition {
                            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                        }
                        exit: Transition {
                            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100; easing.type: Easing.InQuad }
                            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100; easing.type: Easing.InQuad }
                        }
                        
                        background: Rectangle {
                            id: contextMenuBg
                            implicitWidth: 167
                            color: "#151d24"
                            border.color: "#ff7a00"
                            border.width: 1
                            radius: 6
                        }

                        function menuIconSvg(svgBody, colorHex) {
                            return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + encodeURIComponent(colorHex) + "' stroke-width='2.1' stroke-linecap='round' stroke-linejoin='round'>" + svgBody + "</svg>";
                        }

                        contentItem: Column {
                            id: contextMenuColumn
                            width: 165
                            spacing: 0
                        
                        Rectangle {
                            id: swapMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            visible: generalSettings.allowSwappingViewports
                            readonly property bool itemEnabled: model.url !== ""
                            readonly property bool hovered: swapMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<polyline points='16 3 21 3 21 8'/><line x1='4' y1='20' x2='21' y2='3'/><polyline points='21 16 21 21 16 21'/><line x1='15' y1='15' x2='21' y2='21'/><line x1='4' y1='4' x2='9' y2='9'/>", swapMenuItem.itemEnabled ? (swapMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00475")
                                    font { pixelSize: 11; bold: true }
                                    color: swapMenuItem.itemEnabled ? (swapMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: swapMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!swapMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    root.pendingSwapSourceIndex = model.index;
                                }
                            }
                        }

                        Rectangle {
                            id: addCameraMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            visible: generalSettings.enableAddCamera
                            readonly property var recordersList: {
                                try {
                                    return JSON.parse(rootWindow.hikvisionRecordersJson || "[]");
                                } catch(e) {
                                    return [];
                                }
                            }
                            readonly property bool itemEnabled: recordersList && recordersList.length > 0
                            readonly property bool hovered: addCameraMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<path d='M23 7l-7 5 7 5V7z'/><rect x='1' y='5' width='15' height='14' rx='2' ry='2'/><line x1='8.5' y1='9' x2='8.5' y2='15'/><line x1='5.5' y1='12' x2='11.5' y2='12'/>", addCameraMenuItem.itemEnabled ? (addCameraMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00642")
                                    font { pixelSize: 11; bold: true }
                                    color: addCameraMenuItem.itemEnabled ? (addCameraMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    text: "▶"
                                    font { pixelSize: 9; bold: true }
                                    color: addCameraMenuItem.itemEnabled ? (addCameraMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: addCameraMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    if (addCameraMenuItem.itemEnabled) {
                                        addCameraSubMenu.popup(addCameraMenuItem, addCameraMenuItem.width, 0);
                                    }
                                }
                                onClicked: {
                                    if (!addCameraMenuItem.itemEnabled) return;
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.popup(addCameraMenuItem, addCameraMenuItem.width, 0);
                                }
                            }
                        }

                        Rectangle {
                            id: streamSelectMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            visible: generalSettings.enableStreamSelection
                            readonly property bool itemEnabled: model.url !== ""
                            readonly property bool hovered: streamSelectMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<polygon points='12 2 2 7 12 12 22 7 12 2'/><polyline points='2 17 12 22 22 17'/><polyline points='2 12 12 17 22 12'/>", streamSelectMenuItem.itemEnabled ? (streamSelectMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00474")
                                    font { pixelSize: 11; bold: true }
                                    color: streamSelectMenuItem.itemEnabled ? (streamSelectMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    text: "▶"
                                    font { pixelSize: 9; bold: true }
                                    color: streamSelectMenuItem.itemEnabled ? (streamSelectMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: streamSelectMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                    if (streamSelectMenuItem.itemEnabled) {
                                        streamSubMenu.popup(streamSelectMenuItem, streamSelectMenuItem.width, 0);
                                    }
                                }
                                onClicked: {
                                    if (!streamSelectMenuItem.itemEnabled) return;
                                    streamSubMenu.popup(streamSelectMenuItem, streamSelectMenuItem.width, 0);
                                }
                            }
                        }

                        Rectangle {
                            id: removeCameraMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            visible: generalSettings.enableRemoveCamera
                            readonly property bool itemEnabled: model.url !== ""
                            readonly property bool hovered: removeCameraMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#ff3333" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<polyline points='3 6 5 6 21 6'/><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'/>", removeCameraMenuItem.itemEnabled ? (removeCameraMenuItem.hovered ? "#ff3333" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00473")
                                    font { pixelSize: 11; bold: true }
                                    color: removeCameraMenuItem.itemEnabled ? (removeCameraMenuItem.hovered ? "#ff3333" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: removeCameraMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!removeCameraMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    removeCameraConfirmDialog.index = model.index;
                                    removeCameraConfirmDialog.open();
                                }
                            }
                        }

                        Rectangle {
                            id: changeSettingsMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            visible: generalSettings.enableChangeViewportSettings
                            readonly property bool itemEnabled: model.url !== ""
                            readonly property bool hovered: changeSettingsMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<circle cx='12' cy='12' r='3'/><path d='M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z'/>", changeSettingsMenuItem.itemEnabled ? (changeSettingsMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00472")
                                    font { pixelSize: 11; bold: true }
                                    color: changeSettingsMenuItem.itemEnabled ? (changeSettingsMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: changeSettingsMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!changeSettingsMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    viewportSettingsDialog.index = model.index;
                                    viewportSettingsDialog.open();
                                }
                            }
                        }

                        Rectangle {
                            id: renameCameraMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            visible: generalSettings.enableRenameCamera
                            readonly property bool itemEnabled: model.url !== "" && String(model.url).indexOf("hikvision://") === 0
                            readonly property bool hovered: renameCameraMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<polygon points='16 3 21 8 8 21 3 21 3 16 16 3'/>", renameCameraMenuItem.itemEnabled ? (renameCameraMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00674")
                                    font { pixelSize: 11; bold: true }
                                    color: renameCameraMenuItem.itemEnabled ? (renameCameraMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: renameCameraMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!renameCameraMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    cameraRenameDialog.openForUrl(model.url);
                                }
                            }
                        }

                        Rectangle {
                            id: reloadMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            readonly property bool itemEnabled: model.url !== "" && (playerPool.activePlayersMap[model.index] ? !playerPool.activePlayersMap[model.index].isQuickPlayback : true)
                            readonly property bool hovered: reloadMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<polyline points='23 4 23 10 17 10'/><path d='M20.49 15a9 9 0 1 1-2.12-9.36L23 10'/>", reloadMenuItem.itemEnabled ? (reloadMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00471")
                                    font { pixelSize: 11; bold: true }
                                    color: reloadMenuItem.itemEnabled ? (reloadMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: reloadMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!reloadMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    var player = playerPool.activePlayersMap[model.index];
                                    if (player) {
                                        player.reload();
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: snapshotMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            readonly property bool itemEnabled: model.url !== ""
                            readonly property bool hovered: snapshotMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<path d='M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z'/><circle cx='12' cy='13' r='4'/>", snapshotMenuItem.itemEnabled ? (snapshotMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00470")
                                    font { pixelSize: 11; bold: true }
                                    color: snapshotMenuItem.itemEnabled ? (snapshotMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: snapshotMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!snapshotMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    var player = playerPool.activePlayersMap[model.index];
                                    if (player) {
                                        player.takeSnapshot(false);
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: playMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            readonly property bool itemEnabled: model.url !== ""
                            readonly property bool hovered: playMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg("<circle cx='12' cy='12' r='10'/><polygon points='10 8 16 12 10 16 10 8'/>", playMenuItem.itemEnabled ? (playMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: qsTr("LNG_00469")
                                    font { pixelSize: 11; bold: true }
                                    color: playMenuItem.itemEnabled ? (playMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: playMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    mergeSubMenu.close();
                                    addCameraSubMenu.close();
                                }
                                onClicked: {
                                    if (!playMenuItem.itemEnabled) return;
                                    contextMenu.close();
                                    var player = playerPool.activePlayersMap[model.index];
                                    if (player) {
                                        player.openPlayback();
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: mergeMenuItem
                            width: 165
                            height: 32
                            radius: 4
                            readonly property bool isMergedCell: viewport.columnSpan > 1 || viewport.rowSpan > 1
                            readonly property bool isSelectionMerge: !isMergedCell && d.multiselect && d.selectionContains(model.index) && d.selectionWidth() > 1 && root.mergeCells(true)
                            readonly property bool hasSubMenuOptions: !isMergedCell && !isSelectionMerge && root.hasAnyMergeOption(viewport.viewportIndex)
                            visible: generalSettings.enableMergeViewports
                            readonly property bool itemEnabled: visible && (isMergedCell || isSelectionMerge || hasSubMenuOptions)
                            readonly property bool hovered: mergeMouseArea.containsMouse
                            color: (itemEnabled && hovered) ? "#2a3540" : "transparent"
                            border.color: (itemEnabled && hovered) ? "#00f5d4" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: contextMenu.menuIconSvg(mergeMenuItem.isMergedCell ? "<rect x='3' y='3' width='8' height='8' rx='1'/><rect x='13' y='3' width='8' height='8' rx='1'/><rect x='3' y='13' width='8' height='8' rx='1'/><rect x='13' y='13' width='8' height='8' rx='1'/>" : "<rect x='3' y='3' width='18' height='18' rx='2'/><polyline points='9 12 12 12 12 9'/><polyline points='15 12 12 12 12 15'/>", mergeMenuItem.itemEnabled ? (mergeMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896")
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: mergeMenuItem.isMergedCell
                                          ? qsTr("LNG_00594").arg(viewport.columnSpan)
                                          : (mergeMenuItem.isSelectionMerge
                                             ? qsTr("LNG_00593").arg(d.selectionWidth())
                                             : qsTr("LNG_00592"))
                                    font { pixelSize: 11; bold: true }
                                    color: mergeMenuItem.itemEnabled ? (mergeMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    text: "▶"
                                    visible: mergeMenuItem.hasSubMenuOptions
                                    font { pixelSize: 9; bold: true }
                                    color: mergeMenuItem.itemEnabled ? (mergeMenuItem.hovered ? "#00f5d4" : "#eeeeee") : "#788896"
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: mergeMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    streamSubMenu.close();
                                    addCameraSubMenu.close();
                                    if (mergeMenuItem.itemEnabled && mergeMenuItem.hasSubMenuOptions) {
                                        mergeSubMenu.popup(mergeMenuItem, mergeMenuItem.width, 0);
                                    }
                                }
                                onClicked: {
                                    if (!mergeMenuItem.itemEnabled) return;
                                    if (mergeMenuItem.isMergedCell) {
                                        contextMenu.close();
                                        root.splitAt(viewport.viewportIndex);
                                    } else if (mergeMenuItem.isSelectionMerge) {
                                        contextMenu.close();
                                        root.mergeCells();
                                    } else if (mergeMenuItem.hasSubMenuOptions) {
                                        mergeSubMenu.popup(mergeMenuItem, mergeMenuItem.width, 0);
                                    }
                                }
                            }
                        }
                        }
                    }

                    Menu {
                        id: mergeSubMenu

                        topPadding: 5
                        bottomPadding: 5

                        onClosed: {
                            d.previewTopLeftIndex = -1;
                            d.previewSpan = 1;
                        }

                        enter: Transition {
                            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                        }
                        exit: Transition {
                            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100; easing.type: Easing.InQuad }
                            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100; easing.type: Easing.InQuad }
                        }

                        background: Rectangle {
                            implicitWidth: 110
                            color: "#151d24"
                            border.color: "#ff7a00"
                            border.width: 1
                            radius: 6
                        }

                        Instantiator {
                            model: Math.max(0, Math.min(root.size.width, root.size.height) - 2)
                            delegate: MenuItem {
                                id: mergeOptionItem
                                opacity: 1.0
                                readonly property int spanSize: index + 2
                                readonly property int anchorIdx: (contextMenu.visible || mergeSubMenu.visible) ? root.findMergeAnchor(viewport.viewportIndex, spanSize) : -1
                                readonly property bool itemEnabled: anchorIdx >= 0
                                text: spanSize + "×" + spanSize
                                leftPadding: 12

                                contentItem: Text {
                                    opacity: 1.0
                                    text: mergeOptionItem.text
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: mergeOptionItem.itemEnabled ? (mergeOptionItem.hovered ? "#00f5d4" : "#eeeeee") : "#8898a6"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    implicitWidth: 110
                                    implicitHeight: 32
                                    color: (mergeOptionItem.itemEnabled && mergeOptionItem.hovered) ? "#2a3540" : "transparent"
                                    border.color: (mergeOptionItem.itemEnabled && mergeOptionItem.hovered) ? "#00f5d4" : "transparent"
                                    border.width: 1
                                    radius: 4
                                }

                                onHoveredChanged: {
                                    if (hovered && itemEnabled && anchorIdx >= 0) {
                                        d.previewTopLeftIndex = anchorIdx;
                                        d.previewSpan = spanSize;
                                    } else if (!hovered && d.previewTopLeftIndex === anchorIdx && d.previewSpan === spanSize) {
                                        d.previewTopLeftIndex = -1;
                                        d.previewSpan = 1;
                                    }
                                }

                                onTriggered: {
                                    if (!itemEnabled) return;
                                    d.previewTopLeftIndex = -1;
                                    d.previewSpan = 1;
                                    if (anchorIdx >= 0) {
                                        root.mergeAt(anchorIdx, spanSize);
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    z: 100
                                    visible: !mergeOptionItem.itemEnabled
                                    hoverEnabled: true
                                    onPressed: mouse.accepted = true
                                    onReleased: mouse.accepted = true
                                    onClicked: mouse.accepted = true
                                }
                            }
                            onObjectAdded: mergeSubMenu.insertItem(index, object)
                            onObjectRemoved: mergeSubMenu.removeItem(object)
                        }
                    }

                    Menu {
                        id: streamSubMenu
                        
                        topPadding: 5
                        bottomPadding: 5
                        
                        enter: Transition {
                            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                        }
                        exit: Transition {
                            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100; easing.type: Easing.InQuad }
                            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100; easing.type: Easing.InQuad }
                        }
                        
                        background: Rectangle {
                            implicitWidth: 160
                            color: "#151d24"
                            border.color: "#ff7a00"
                            border.width: 1
                            radius: 6
                        }
                        
                        MenuItem {
                            id: streamAutoItem
                            text: qsTr("LNG_00468")
                            leftPadding: 12
                            
                            contentItem: RowLayout {
                                opacity: 1.0
                                spacing: 8
                                Text {
                                    Layout.fillWidth: true
                                    text: streamAutoItem.text
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: streamAutoItem.hovered ? "#00f5d4" : (viewport.streamMode === 0 ? "#00f5d4" : "#eeeeee")
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    text: "✓"
                                    visible: viewport.streamMode === 0
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: "#00f5d4"
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    rightPadding: 8
                                }
                            }
                            
                            background: Rectangle {
                                implicitWidth: 150
                                implicitHeight: 32
                                color: streamAutoItem.hovered ? "#2a3540" : "transparent"
                                border.color: streamAutoItem.hovered ? "#00f5d4" : "transparent"
                                border.width: 1
                                radius: 4
                            }
                            
                            onTriggered: {
                                var item = root.model.get(model.index);
                                if (item) {
                                    item.streamMode = 0;
                                }
                            }
                        }
                        
                        MenuItem {
                            id: streamMainItem
                            text: qsTr("LNG_00467")
                            leftPadding: 12
                            
                            contentItem: RowLayout {
                                opacity: 1.0
                                spacing: 8
                                Text {
                                    Layout.fillWidth: true
                                    text: streamMainItem.text
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: streamMainItem.hovered ? "#00f5d4" : (viewport.streamMode === 1 ? "#00f5d4" : "#eeeeee")
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    text: "✓"
                                    visible: viewport.streamMode === 1
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: "#00f5d4"
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    rightPadding: 8
                                }
                            }
                            
                            background: Rectangle {
                                implicitWidth: 150
                                implicitHeight: 32
                                color: streamMainItem.hovered ? "#2a3540" : "transparent"
                                border.color: streamMainItem.hovered ? "#00f5d4" : "transparent"
                                border.width: 1
                                radius: 4
                            }
                            
                            onTriggered: {
                                var item = root.model.get(model.index);
                                if (item) {
                                    item.streamMode = 1;
                                }
                            }
                        }
                        
                        MenuItem {
                            id: streamSubItem
                            text: qsTr("LNG_00466")
                            leftPadding: 12
                            
                            contentItem: RowLayout {
                                opacity: 1.0
                                spacing: 8
                                Text {
                                    Layout.fillWidth: true
                                    text: streamSubItem.text
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: streamSubItem.hovered ? "#00f5d4" : (viewport.streamMode === 2 ? "#00f5d4" : "#eeeeee")
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    text: "✓"
                                    visible: viewport.streamMode === 2
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: "#00f5d4"
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    rightPadding: 8
                                }
                            }
                            
                            background: Rectangle {
                                implicitWidth: 150
                                implicitHeight: 32
                                color: streamSubItem.hovered ? "#2a3540" : "transparent"
                                border.color: streamSubItem.hovered ? "#00f5d4" : "transparent"
                                border.width: 1
                                radius: 4
                            }
                            
                            onTriggered: {
                                var item = root.model.get(model.index);
                                if (item) {
                                    item.streamMode = 2;
                                }
                            }
                        }
                    }

                    Menu {
                        id: addCameraSubMenu

                        topPadding: 5
                        bottomPadding: 5

                        enter: Transition {
                            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                        }
                        exit: Transition {
                            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100; easing.type: Easing.InQuad }
                            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100; easing.type: Easing.InQuad }
                        }

                        readonly property real maxHeight: Math.max(120, (Overlay.overlay ? Overlay.overlay.height : (rootWindow ? rootWindow.height : 600)) - 60)
                        readonly property real naturalHeight: contentItem ? (contentItem.contentHeight + topPadding + bottomPadding) : 0
                        height: naturalHeight > maxHeight ? maxHeight : naturalHeight

                        contentItem: ListView {
                            implicitHeight: contentHeight
                            model: addCameraSubMenu.contentModel
                            interactive: true
                            clip: true
                            currentIndex: addCameraSubMenu.currentIndex
                            boundsBehavior: Flickable.StopAtBounds

                            ScrollIndicator.vertical: ScrollIndicator {
                                active: addCameraSubMenu.contentItem.contentHeight > addCameraSubMenu.contentItem.height
                            }
                        }

                        background: Rectangle {
                            implicitWidth: 180
                            color: "#151d24"
                            border.color: "#ff7a00"
                            border.width: 1
                            radius: 6
                        }

                        MenuItem {
                            id: searchCameraMenuItem
                            text: qsTr("LNG_00655")
                            leftPadding: 12

                            contentItem: RowLayout {
                                opacity: 1.0
                                spacing: 8
                                Image {
                                    Layout.preferredWidth: 13
                                    Layout.preferredHeight: 13
                                    source: {
                                        var colorStr = searchCameraMenuItem.hovered ? "%2300f5d4" : "%23eeeeee";
                                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.2' stroke-linecap='round' stroke-linejoin='round'><circle cx='11' cy='11' r='8'/><line x1='21' y1='21' x2='16.65' y2='16.65'/></svg>";
                                    }
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: searchCameraMenuItem.text
                                    font {
                                        pixelSize: 11
                                        bold: true
                                    }
                                    color: searchCameraMenuItem.hovered ? "#00f5d4" : "#eeeeee"
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            background: Rectangle {
                                implicitWidth: 180
                                implicitHeight: 32
                                color: searchCameraMenuItem.hovered ? "#2a3540" : "transparent"
                                border.color: searchCameraMenuItem.hovered ? "#00f5d4" : "transparent"
                                border.width: 1
                                radius: 4
                            }

                            onTriggered: {
                                addCameraSubMenu.close();
                                contextMenu.close();
                                rootWindow.openCameraSearchWindow();
                            }
                        }

                        Instantiator {
                            model: addCameraMenuItem.recordersList
                            delegate: MenuItem {
                                id: recMenuItem
                                readonly property var recorderData: modelData
                                text: (modelData.name && String(modelData.name).trim() !== "") ? modelData.name : (modelData.ip || "")
                                leftPadding: 12

                                contentItem: RowLayout {
                                    spacing: 6
                                    Text {
                                        Layout.fillWidth: true
                                        text: recMenuItem.text
                                        font {
                                            pixelSize: 11
                                            bold: true
                                        }
                                        color: recMenuItem.hovered ? "#00f5d4" : "#eeeeee"
                                        elide: Text.ElideRight
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    Text {
                                        text: (recorderData.cameras ? recorderData.cameras.length : 0) + " " + qsTr("LNG_00678")
                                        font.pixelSize: 9
                                        color: "#8898a6"
                                        horizontalAlignment: Text.AlignRight
                                        verticalAlignment: Text.AlignVCenter
                                        rightPadding: 8
                                    }
                                }

                                background: Rectangle {
                                    implicitWidth: 180
                                    implicitHeight: 32
                                    color: recMenuItem.hovered ? "#2a3540" : "transparent"
                                    border.color: recMenuItem.hovered ? "#00f5d4" : "transparent"
                                    border.width: 1
                                    radius: 4
                                }

                                onTriggered: {
                                    addCameraSubMenu.close();
                                    contextMenu.close();
                                    rootWindow.openNvrCamerasWindow(recorderData);
                                }
                            }
                            onObjectAdded: addCameraSubMenu.insertItem(index + 1, object)
                            onObjectRemoved: addCameraSubMenu.removeItem(object)
                        }
                    }

                    // DropArea ON TOP of everything — accepts both camera and viewport drops
                    DropArea {
                        id: dropArea
                        anchors.fill: parent

                        // Highlight on drag hover
                        Rectangle {
                            anchors.fill: parent
                            color: dropArea.containsDrag ? "#3000f5d4" : "transparent"
                            border.color: dropArea.containsDrag ? "#00f5d4" : "transparent"
                            border.width: 2
                            z: 100

                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        onEntered: {
                            if (drag.hasFormat("application/x-cctv-viewport-index") || drag.hasFormat("application/x-cctv-camera-url") || drag.hasText) {
                                drag.accept();
                            } else {
                                drag.accepted = false;
                            }
                        }

                        onPositionChanged: {
                            if (drag.hasFormat("application/x-cctv-viewport-index") || drag.hasFormat("application/x-cctv-camera-url") || drag.hasText) {
                                drag.accept();
                            } else {
                                drag.accepted = false;
                            }
                        }

                        onDropped: {
                            // Camera drop from NvrCamerasWindow
                            if (drop.hasText) {
                                var url = "";
                                // Try custom MIME type first
                                if (drop.hasFormat("application/x-cctv-camera-url")) {
                                    url = drop.getDataAsString("application/x-cctv-camera-url");
                                } else {
                                    url = drop.text;
                                }

                                if (url && url.indexOf("hikvision://") === 0) {
                                    root.model.get(model.index).url = url;
                                    root.model.get(model.index).secondaryUrl = url;
                                    root.model.get(model.index).streamMode = 0;
                                    drop.accept(Qt.CopyAction);
                                    Utils.log_info("Dropped camera on viewport " + (model.index + 1));
                                    return;
                                }
                            }

                            // Viewport swap
                            if (drop.hasFormat("application/x-cctv-viewport-index")) {
                                var sourceIndex = parseInt(drop.getDataAsString("application/x-cctv-viewport-index"));
                                if (sourceIndex !== model.index && sourceIndex >= 0 && sourceIndex < root.model.count) {
                                    var sourceItem = root.model.get(sourceIndex);
                                    var targetItem = root.model.get(model.index);
                                    if (sourceItem && targetItem) {
                                        var tempUrl = sourceItem.url;
                                        var tempSecUrl = sourceItem.secondaryUrl;
                                        var tempVol = sourceItem.volume;
                                        var tempOpts = sourceItem.avFormatOptions;
                                        var tempStreamMode = sourceItem.streamMode;

                                        sourceItem.url = targetItem.url;
                                        sourceItem.secondaryUrl = targetItem.secondaryUrl;
                                        sourceItem.volume = targetItem.volume;
                                        sourceItem.avFormatOptions = targetItem.avFormatOptions;
                                        sourceItem.streamMode = targetItem.streamMode;

                                        targetItem.url = tempUrl;
                                        targetItem.secondaryUrl = tempSecUrl;
                                        targetItem.volume = tempVol;
                                        targetItem.avFormatOptions = tempOpts;
                                        targetItem.streamMode = tempStreamMode;

                                        drop.accept(Qt.MoveAction);
                                        Utils.log_info("Swapped viewport " + (sourceIndex + 1) + " with " + (model.index + 1));
                                    }
                                }
                                return;
                            }
                        }
                    }

                    function indexAt(x, y) {
                        for (var i = 0; i < repeater.count; ++i) {
                            var itemTo = repeater.itemAt(i);

                            if (i === model.index) {
                                if (contains(Qt.point(x, y))) {
                                    return i;
                                }
                            } else {
                                var mappedPoint = mapToItem(itemTo, x, y);

                                if (itemTo.contains(mappedPoint)) {
                                    return i;
                                }
                            }
                        }

                        return -1;
                    }
                }
            }
        }
    }

    Keys.onPressed: {
        d.keyModifiers = event.modifiers;

        switch (event.key) {
        case Qt.Key_Delete:
            for (var i = 0; i < root.size.width * root.size.height; ++i) {
                if (root.get(i).selected) {
                    model.get(i).url = "";
                    model.get(i).secondaryUrl = "";
                    model.get(i).volume = 0;
                    model.get(i).avFormatOptions = layoutsCollectionSettings.toJSValue("defaultAVFormatOptions");
                    model.get(i).streamMode = 0;
                }
            }
            break;
        }
    }
    Keys.onReleased: d.keyModifiers = event.modifiers

    function get(index) {
        if (index >= 0 && index < repeater.count) {
            var item = repeater.itemAt(index);
            if (item === null) {
                return undefined;
            }

            return item.children[0];
        }

        return;
    }

    function indexAt(x, y) {
        for (var i = 0; i < repeater.count; ++i) {
            var itemTo = repeater.itemAt(i);
            var mappedPoint = mapToItem(itemTo, x, y);

            if (itemTo.contains(mappedPoint)) {
                return i;
            }
        }

        return -1;
    }

    function mergeCells(testMode) {
        var topLeftIndex = d.indexFromAddress(d.selectionLeft(), d.selectionTop());
        if (topLeftIndex < 0 || topLeftIndex >= model.count) {
            return false;
        }
        var topLeftElement = model.get(topLeftIndex);

        if (d.selectionWidth() !== d.selectionHeight() ||
            d.selectionWidth() <= 0 || d.selectionHeight() <= 0 ||
            (d.selectionWidth() >= root.size.width && d.selectionHeight() >= root.size.height)) {
            return false;
        }

        if (!testMode) {
            if (topLeftElement.columnSpan > 1 || topLeftElement.rowSpan > 1) {
                topLeftElement.savedColumnSpan = 1;
                topLeftElement.savedRowSpan = 1;
                topLeftElement.columnSpan = 1;
                topLeftElement.rowSpan = 1;
            } else if (d.selectionWidth() > 1 || d.selectionHeight() > 1) {
                topLeftElement.savedColumnSpan = d.selectionWidth();
                topLeftElement.savedRowSpan = d.selectionHeight();
                topLeftElement.columnSpan = d.selectionWidth();
                topLeftElement.rowSpan = d.selectionHeight();
            }

            d.selectionReset();
            model.normalize();
        }

        return true;
    }

    function findMergeAnchor(targetIndex, span) {
        if (targetIndex < 0 || span < 2 || span > root.size.width || span > root.size.height ||
                (span >= root.size.width && span >= root.size.height)) {
            return -1;
        }
        var col = d.columnFromIndex(targetIndex);
        var row = d.rowFromIndex(targetIndex);
        var minCol = Math.max(0, col - span + 1);
        var maxCol = Math.min(col, root.size.width - span);
        var minRow = Math.max(0, row - span + 1);
        var maxRow = Math.min(row, root.size.height - span);

        var candidates = [[maxCol, maxRow]];
        for (var r = maxRow; r >= minRow; --r) {
            for (var c = maxCol; c >= minCol; --c) {
                if (c !== maxCol || r !== maxRow) {
                    candidates.push([c, r]);
                }
            }
        }

        for (var i = 0; i < candidates.length; ++i) {
            var ac = candidates[i][0];
            var ar = candidates[i][1];
            var ok = true;
            for (var dr = 0; dr < span && ok; ++dr) {
                for (var dc = 0; dc < span && ok; ++dc) {
                    var cell = model.get(d.indexFromAddress(ac + dc, ar + dr));
                    if (!cell || cell.visible !== ViewportsLayoutItem.Visible || cell.columnSpan > 1 || cell.rowSpan > 1) {
                        ok = false;
                    }
                }
            }
            if (ok) {
                return d.indexFromAddress(ac, ar);
            }
        }
        return -1;
    }

    function hasAnyMergeOption(targetIndex) {
        var maxSpan = Math.min(root.size.width, root.size.height) - 1;
        for (var s = 2; s <= maxSpan; ++s) {
            if (findMergeAnchor(targetIndex, s) >= 0) {
                return true;
            }
        }
        return false;
    }

    function mergeAt(anchorIndex, span) {
        if (anchorIndex < 0 || anchorIndex >= model.count || span < 2) {
            return;
        }
        var item = model.get(anchorIndex);
        if (item) {
            item.savedColumnSpan = span;
            item.savedRowSpan = span;
            item.columnSpan = span;
            item.rowSpan = span;
            d.selectionReset();
            model.normalize();
            var vp = root.get(anchorIndex);
            if (vp) {
                vp.forceActiveFocus();
            }
        }
    }

    function splitAt(targetIndex) {
        if (targetIndex < 0 || targetIndex >= model.count) {
            return;
        }
        var item = model.get(targetIndex);
        if (item && (item.columnSpan > 1 || item.rowSpan > 1)) {
            item.savedColumnSpan = 1;
            item.savedRowSpan = 1;
            item.columnSpan = 1;
            item.rowSpan = 1;
            d.selectionReset();
            model.normalize();
        }
    }

    ConfirmDialog {
        id: removeCameraConfirmDialog
        title: qsTr("LNG_00465")
        iconSource: "qrc:/images/icon-trash.svg"
        message: qsTr("LNG_00464")
        property int index: -1
        
        onAccepted: {
            if (index >= 0 && index < root.model.count) {
                var item = root.model.get(index);
                if (item) {
                    item.url = "";
                    item.secondaryUrl = "";
                    item.volume = 0.0;
                    item.avFormatOptions = {};
                    item.streamMode = 0;
                }
            }
        }
    }

    ViewportSettingsDialog {
        id: viewportSettingsDialog
    }

    CameraRenameWindow {
        id: cameraRenameDialog
    }
}
