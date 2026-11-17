import QtQuick 2.12
import QtQuick.Controls 2.12
import CCTV_Viewer.Themes 1.0

Item {
    id: areaRoot
    property var sections: []
    property int currentLayoutIndex: -1
    property real maxFlowWidth: 600
    property bool alignRight: true
    property bool barVisible: true

    property var expandedOverrides: ({})
    property var _lastCollapsedDefaults: ({})

    property real targetContentWidth: 0
    property real targetContentHeight: 0
    property real contentWidth: targetContentWidth
    property real contentHeight: targetContentHeight
    property int visualRowCount: 0

    property bool _layoutReady: false
    property string _lastKeysSig: ""
    property var nonSeparatorSections: []

    property bool _hasPointer: false
    property bool _pointerInBar: false
    property real _pointerLocalX: -1
    property real _pointerLocalY: -1
    property string _justExpandedGroupName: ""
    property double _justExpandedAtMs: 0
    property real _pendingClickX: -1
    property real _pendingClickY: -1
    property string _preservedExpandedGroupOnDefChange: ""

    signal activateLayout(int layoutIndex)
    signal setGroupCollapsedByDefault(string groupName, bool collapsed)

    readonly property bool hasAnyViews: nonSeparatorSections.length > 0

    width: Math.max(1, contentWidth)
    height: Math.max(0, contentHeight)
    implicitWidth: width
    implicitHeight: height

    Behavior on contentWidth {
        enabled: areaRoot._layoutReady
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Behavior on contentHeight {
        enabled: areaRoot._layoutReady
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    onBarVisibleChanged: {
        if (!barVisible) {
            barLeaveCollapseTimer.stop();
            collapseDefaultGroups();
        }
    }

    onMaxFlowWidthChanged: scheduleRelayout()
    onAlignRightChanged: scheduleRelayout()
    Component.onCompleted: scheduleRelayout()

    Timer {
        id: relayoutDebounceTimer
        interval: 0
        repeat: false
        onTriggered: areaRoot.relayoutAll()
    }

    Timer {
        id: barLeaveCollapseTimer
        interval: 120
        repeat: false
        onTriggered: {
            if (!areaRoot._pointerInBar) {
                areaRoot.collapseDefaultGroups();
            }
        }
    }

    function scheduleRelayout() {
        relayoutDebounceTimer.restart();
    }

    onSectionsChanged: {
        var nextDefaults = ({});
        var nextOverrides = Object.assign({}, expandedOverrides);
        var changedOverride = false;
        var filtered = [];
        var sigParts = [];
        var list = sections || [];

        for (var i = 0; i < list.length; ++i) {
            var it = list[i];
            if (!it) continue;
            if (it.isGroup && it.groupName) {
                var gn = it.groupName;
                var defVal = !!it.collapsedByDefault;
                nextDefaults[gn] = defVal;
                if (_lastCollapsedDefaults.hasOwnProperty(gn) && _lastCollapsedDefaults[gn] !== defVal) {
                    if (_preservedExpandedGroupOnDefChange === gn) {
                        _preservedExpandedGroupOnDefChange = "";
                        nextOverrides[gn] = true;
                    } else {
                        delete nextOverrides[gn];
                    }
                    changedOverride = true;
                }
            }
            if (!(it.isSeparator || it.itemType === "separator")) {
                filtered.push(it);
                sigParts.push(it.key || "");
            }
        }
        _lastCollapsedDefaults = nextDefaults;
        if (changedOverride) {
            expandedOverrides = nextOverrides;
        }

        var nextSig = sigParts.join("|");
        if (nextSig !== _lastKeysSig || itemsRepeater.count !== filtered.length) {
            _layoutReady = false;
            _lastKeysSig = nextSig;
            nonSeparatorSections = filtered;
        } else {
            // Same items in the same order: update entryData in-place to preserve live animations (pin rotation, expand/collapse)
            for (var u = 0; u < filtered.length; ++u) {
                var wrapItem = itemsRepeater.itemAt(u);
                if (wrapItem) {
                    wrapItem.entryData = filtered[u];
                }
            }
        }
        scheduleRelayout();
    }

    function toggleGroupPinned(groupName, pinOpen) {
        var gn = String(groupName || "");
        if (gn === "") return;
        var next = Object.assign({}, expandedOverrides);
        if (!pinOpen) {
            // Unpinning while open: preserve expanded state until user clicks elsewhere or leaves top bar
            next[gn] = true;
            _preservedExpandedGroupOnDefChange = gn;
        } else {
            delete next[gn];
            _preservedExpandedGroupOnDefChange = "";
        }
        expandedOverrides = next;
        areaRoot.setGroupCollapsedByDefault(gn, !pinOpen);
    }

    function isGroupCollapsed(entry) {
        if (!entry || !entry.isGroup || !entry.groupName) return false;
        var gn = entry.groupName;
        if (expandedOverrides.hasOwnProperty(gn)) {
            return !expandedOverrides[gn];
        }
        return !!entry.collapsedByDefault;
    }

    function setGroupCollapsed(groupName, collapsedVal) {
        var gn = String(groupName || "");
        if (gn === "") return;
        var list = sections || [];
        var defCollapsed = false;
        var found = false;
        for (var i = 0; i < list.length; ++i) {
            if (list[i] && list[i].isGroup && list[i].groupName === gn) {
                defCollapsed = !!list[i].collapsedByDefault;
                found = true;
                break;
            }
        }
        if (!found) return;
        var curExpanded = expandedOverrides.hasOwnProperty(gn) ? !!expandedOverrides[gn] : !defCollapsed;
        var targetExpanded = !collapsedVal;
        if (curExpanded === targetExpanded) return;

        var next = Object.assign({}, expandedOverrides);
        if (targetExpanded === !defCollapsed) {
            delete next[gn];
        } else {
            next[gn] = targetExpanded;
        }
        expandedOverrides = next;
        relayoutAll();
    }

    function toggleGroupExpanded(groupName) {
        var gn = String(groupName || "");
        if (gn === "") return;
        var list = sections || [];
        var defCollapsed = false;
        for (var i = 0; i < list.length; ++i) {
            if (list[i] && list[i].isGroup && list[i].groupName === gn) {
                defCollapsed = !!list[i].collapsedByDefault;
                break;
            }
        }
        var curExpanded = expandedOverrides.hasOwnProperty(gn) ? !!expandedOverrides[gn] : !defCollapsed;
        var willExpand = !curExpanded;

        var next = Object.assign({}, expandedOverrides);
        if (willExpand) {
            // Collapse other default-collapsed groups when opening a new one
            for (var j = 0; j < list.length; ++j) {
                var item = list[j];
                if (item && item.isGroup && item.collapsedByDefault && item.groupName !== gn) {
                    delete next[item.groupName];
                }
            }
        }
        next[gn] = willExpand;
        if (willExpand) {
            _justExpandedGroupName = gn;
            _justExpandedAtMs = Date.now();
        } else if (_justExpandedGroupName === gn) {
            _justExpandedGroupName = "";
        }
        expandedOverrides = next;
        relayoutAll();
    }

    function collapseDefaultGroups() {
        var list = sections || [];
        var next = Object.assign({}, expandedOverrides);
        var changed = false;
        for (var i = 0; i < list.length; ++i) {
            var it = list[i];
            if (it && it.isGroup && it.collapsedByDefault && it.groupName) {
                if (next.hasOwnProperty(it.groupName) && next[it.groupName] === true) {
                    delete next[it.groupName];
                    changed = true;
                }
            }
        }
        if (changed) {
            expandedOverrides = next;
            relayoutAll();
        }
    }

    function updatePointerScenePos(sceneX, sceneY, insideBar) {
        var pt = areaRoot.mapFromItem(null, sceneX, sceneY);
        _pointerLocalX = pt.x;
        _pointerLocalY = pt.y;
        _pointerInBar = !!insideBar;
        _hasPointer = true;
        evaluateAutoCollapse();
    }

    function clearPointer() {
        _pointerInBar = false;
        _hasPointer = false;
        evaluateAutoCollapse();
    }

    function hasExpandedDefaultCollapsedGroup() {
        for (var i = 0; i < itemsRepeater.count; ++i) {
            var iw = itemsRepeater.itemAt(i);
            if (iw && iw.isGroupEntry && iw.collapsedByDefault && !iw.isCollapsed) {
                return true;
            }
        }
        return false;
    }

    function scheduleSceneClick(sceneX, sceneY) {
        _pendingClickX = sceneX;
        _pendingClickY = sceneY;
        Qt.callLater(_flushPendingSceneClick);
    }

    function _flushPendingSceneClick() {
        handleSceneClick(_pendingClickX, _pendingClickY);
    }

    function handleSceneClick(sceneX, sceneY) {
        var pt = areaRoot.mapFromItem(null, sceneX, sceneY);
        var px = pt.x;
        var py = pt.y;
        var now = Date.now();
        var list = sections || [];
        var next = Object.assign({}, expandedOverrides);
        var changed = false;

        for (var i = 0; i < itemsRepeater.count; ++i) {
            var iw = itemsRepeater.itemAt(i);
            if (!iw || !iw.isGroupEntry || !iw.collapsedByDefault || iw.isCollapsed) continue;
            if (iw.groupName === _justExpandedGroupName && (now - _justExpandedAtMs) < 150) {
                continue;
            }
            var insideGroup = (px >= iw.x && px <= iw.x + iw.width &&
                               py >= iw.y && py <= iw.y + iw.height);
            if (!insideGroup) {
                for (var j = 0; j < list.length; ++j) {
                    if (list[j] && list[j].isGroup && list[j].groupName === iw.groupName) {
                        delete next[iw.groupName];
                        changed = true;
                        break;
                    }
                }
            }
        }

        _justExpandedGroupName = "";
        if (changed) {
            expandedOverrides = next;
            relayoutAll();
        }
    }

    function evaluateAutoCollapse() {
        if (!_pointerInBar || !_hasPointer) {
            if (hasExpandedDefaultCollapsedGroup()) {
                if (!barLeaveCollapseTimer.running) {
                    barLeaveCollapseTimer.start();
                }
            } else {
                barLeaveCollapseTimer.stop();
            }
            return;
        }
        barLeaveCollapseTimer.stop();
    }

    function relayoutAll() {
        var list = sections || [];
        if (list.length === 0 || itemsRepeater.count === 0) {
            targetContentWidth = 0;
            targetContentHeight = 0;
            visualRowCount = 0;
            return;
        }

        var wrapByKey = ({});
        for (var wIdx = 0; wIdx < itemsRepeater.count; ++wIdx) {
            var iw = itemsRepeater.itemAt(wIdx);
            if (iw && iw.entryKey !== "") {
                wrapByKey[iw.entryKey] = iw;
            }
        }

        // Split into segments at separators; collapse adjacent segments unless either has an expanded group.
        var segments = [];
        var curSeg = { wraps: [], hasExpandedGroup: false };

        for (var i = 0; i < list.length; ++i) {
            var item = list[i];
            if (!item) continue;
            if (item.isSeparator || item.itemType === "separator") {
                if (curSeg.wraps.length > 0) {
                    segments.push(curSeg);
                    curSeg = { wraps: [], hasExpandedGroup: false };
                }
            } else {
                var wrap = wrapByKey[item.key];
                if (!wrap) continue;
                if (wrap.isGroupEntry && !wrap.isCollapsed) {
                    curSeg.hasExpandedGroup = true;
                }
                curSeg.wraps.push(wrap);
            }
        }
        if (curSeg.wraps.length > 0) {
            segments.push(curSeg);
        }

        if (segments.length === 0) {
            targetContentWidth = 0;
            targetContentHeight = 0;
            visualRowCount = 0;
            return;
        }

        var rows = [];
        var merged = segments[0].wraps.slice();
        var prevHasExpanded = segments[0].hasExpandedGroup;

        for (var s = 1; s < segments.length; ++s) {
            var seg = segments[s];
            if (prevHasExpanded || seg.hasExpandedGroup) {
                rows.push(merged);
                merged = seg.wraps.slice();
            } else {
                merged = merged.concat(seg.wraps);
            }
            prevHasExpanded = seg.hasExpandedGroup;
        }
        if (merged.length > 0) {
            rows.push(merged);
        }

        var hGap = 8;
        var subVGap = 6;
        var sepVGap = 6;
        var maxWLimit = Math.max(150, areaRoot.maxFlowWidth);

        var rowPlans = [];
        var globalMaxW = 0;

        for (var r = 0; r < rows.length; ++r) {
            var rowWraps = rows[r];
            var subRows = [];
            var curSub = { items: [], width: 0, height: 0 };

            for (var c = 0; c < rowWraps.length; ++c) {
                var w = rowWraps[c];
                var tw = w.targetW;
                var th = w.targetH;
                if (tw <= 0 || th <= 0) continue;

                var neededW = (curSub.items.length > 0 ? hGap : 0) + tw;
                if (curSub.items.length > 0 && (curSub.width + neededW) > maxWLimit) {
                    subRows.push(curSub);
                    curSub = { items: [], width: 0, height: 0 };
                    neededW = tw;
                }
                curSub.width += neededW;
                if (th > curSub.height) curSub.height = th;
                curSub.items.push({ wrap: w, w: tw, h: th });
            }
            if (curSub.items.length > 0) {
                subRows.push(curSub);
            }
            if (subRows.length === 0) continue;

            var rowMaxW = 0;
            var rowTotalH = 0;
            for (var sr = 0; sr < subRows.length; ++sr) {
                if (subRows[sr].width > rowMaxW) rowMaxW = subRows[sr].width;
                rowTotalH += subRows[sr].height;
                if (sr > 0) rowTotalH += subVGap;
            }
            if (rowMaxW > globalMaxW) globalMaxW = rowMaxW;
            rowPlans.push({ subRows: subRows, width: rowMaxW, height: rowTotalH });
        }

        if (rowPlans.length === 0) {
            targetContentWidth = 0;
            targetContentHeight = 0;
            visualRowCount = 0;
            return;
        }

        var yGlobal = 0;
        for (var p = 0; p < rowPlans.length; ++p) {
            var plan = rowPlans[p];
            var ySub = yGlobal;
            for (var sr2 = 0; sr2 < plan.subRows.length; ++sr2) {
                var sub = plan.subRows[sr2];
                var xCur = areaRoot.alignRight ? Math.max(0, globalMaxW - sub.width) : 0;
                for (var k = 0; k < sub.items.length; ++k) {
                    var box = sub.items[k];
                    box.wrap.targetX = Math.round(xCur);
                    box.wrap.targetY = Math.round(ySub + (sub.height - box.h) * 0.5);
                    xCur += box.w + hGap;
                }
                ySub += sub.height + subVGap;
            }
            yGlobal += plan.height + (p + 1 < rowPlans.length ? sepVGap : 0);
        }

        targetContentWidth = Math.ceil(globalMaxW);
        targetContentHeight = Math.ceil(yGlobal);
        visualRowCount = rowPlans.length;

        if (!_layoutReady) {
            Qt.callLater(function() {
                areaRoot._layoutReady = true;
            });
        }
    }

    Repeater {
        id: itemsRepeater
        model: areaRoot.nonSeparatorSections
        onItemAdded: areaRoot.scheduleRelayout()
        onItemRemoved: areaRoot.scheduleRelayout()

        delegate: Item {
            id: itemWrap
            property var entryData: modelData
            readonly property bool isGroupEntry: !!(entryData && entryData.isGroup)
            readonly property string entryKey: (entryData && entryData.key) ? String(entryData.key) : ""
            readonly property string groupName: (isGroupEntry && entryData.groupName) ? String(entryData.groupName) : ""
            readonly property bool isCollapsed: isGroupEntry ? areaRoot.isGroupCollapsed(entryData) : false
            readonly property bool collapsedByDefault: isGroupEntry ? !!entryData.collapsedByDefault : false

            readonly property real targetW: entryDelegate.targetWidth
            readonly property real targetH: entryDelegate.targetHeight

            property real targetX: 0
            property real targetY: 0

            x: targetX
            y: targetY
            width: entryDelegate.width
            height: entryDelegate.height

            Behavior on x {
                enabled: areaRoot._layoutReady
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on y {
                enabled: areaRoot._layoutReady
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            TopBarViewDelegate {
                id: entryDelegate
                entry: itemWrap.entryData
                collapsed: itemWrap.isCollapsed
                currentLayoutIndex: areaRoot.currentLayoutIndex
                maxFlowWidth: areaRoot.maxFlowWidth
                hasGroupedEntries: true
                onTargetSizeChanged: areaRoot.scheduleRelayout()
                onActivateLayout: function(layoutIndex) {
                    areaRoot.activateLayout(layoutIndex);
                }
                onToggleCollapse: function(grpName) {
                    areaRoot.toggleGroupExpanded(grpName);
                }
                onTogglePin: function(grpName, pinOpen) {
                    areaRoot.toggleGroupPinned(grpName, pinOpen);
                }
            }
        }
    }
}
