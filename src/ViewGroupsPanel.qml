import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import CCTV_Viewer.Themes 1.0

ColumnLayout {
    id: rootPanel

    spacing: 14
    Layout.fillWidth: true

    readonly property string ungroupedKey: (typeof rootWindow !== "undefined" && rootWindow && rootWindow.ungroupedOrderKey)
                                           ? rootWindow.ungroupedOrderKey : "__UNGROUPED__"
    property int revision: 0
    property var pendingEmptyGroups: []
    property var expandedSections: ({})
    property bool topLevelExpanded: true
    property bool hiddenLayoutsExpanded: false

    function bumpRevision() {
        revision++;
        prunePopulatedPendingGroups();
    }

    function groupNetworkIconSvg() {
        return "data:image/svg+xml;utf8," +
               "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'>" +
               "<rect x='5.5' y='2' width='13' height='6.5' rx='1.5' stroke='%23ffbe80' stroke-width='2'/>" +
               "<circle cx='8.5' cy='5.25' r='1.1' fill='%23ff7a00'/>" +
               "<line x1='11.5' y1='5.25' x2='15.5' y2='5.25' stroke='%23ffbe80' stroke-width='1.6' stroke-linecap='round'/>" +
               "<line x1='12' y1='8.5' x2='12' y2='12' stroke='%23ffbe80' stroke-width='1.8'/>" +
               "<line x1='6' y1='12' x2='18' y2='12' stroke='%23ffbe80' stroke-width='1.8' stroke-linecap='round'/>" +
               "<line x1='6' y1='12' x2='6' y2='15' stroke='%23ffbe80' stroke-width='1.8'/>" +
               "<line x1='18' y1='12' x2='18' y2='15' stroke='%23ffbe80' stroke-width='1.8'/>" +
               "<rect x='1.5' y='15' width='9' height='6.5' rx='1.5' stroke='%23ffbe80' stroke-width='2'/>" +
               "<circle cx='4.5' cy='18.25' r='1.1' fill='%23ff7a00'/>" +
               "<rect x='13.5' y='15' width='9' height='6.5' rx='1.5' stroke='%23ffbe80' stroke-width='2'/>" +
               "<circle cx='16.5' cy='18.25' r='1.1' fill='%23ff7a00'/>" +
               "</svg>";
    }

    function isSectionExpanded(key) {
        return !!expandedSections[key];
    }

    function toggleSectionExpanded(key) {
        var next = Object.assign({}, expandedSections);
        next[key] = !next[key];
        expandedSections = next;
    }

    function layoutCategoryKind(layout) {
        if (!layout) return "regular";
        if (layout.isNvr) return "nvr";
        if (layout.isNvrPreset) return "preset";
        return "regular";
    }

    function kindBadgeText(kind) {
        if (kind === "nvr") return qsTr("LNG_00619");
        if (kind === "preset") return qsTr("LNG_00613");
        return qsTr("LNG_00612");
    }

    function layoutLabelFor(idx, layout) {
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.formatLayoutViewLabel) {
            return rootWindow.formatLayoutViewLabel(idx, layout);
        }
        return (layout && layout.name && String(layout.name).trim() !== "") ? String(layout.name).trim() : ("#" + (idx + 1));
    }

    function layoutUidFor(idx, layout) {
        var uid = (layout && layout.uid) ? String(layout.uid).trim() : "";
        return uid !== "" ? uid : ("idx_" + idx);
    }

    function cleanGroupsList(rawList) {
        var out = [];
        var seen = Object.create(null);
        if (!rawList) return out;
        for (var i = 0; i < rawList.length; ++i) {
            var g = String(rawList[i] || "").trim();
            if (g !== "" && !seen[g]) {
                seen[g] = true;
                out.push(g);
            }
        }
        return out;
    }

    function currentGroupMeta() {
        var _r = rootPanel.revision;
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.getViewGroupMeta) {
            return rootWindow.getViewGroupMeta();
        }
        return ({});
    }

    function isGroupCollapsedByDefault(groupName) {
        var meta = currentGroupMeta();
        return !!(meta[groupName] && meta[groupName].collapsedByDefault);
    }

    function setGroupCollapsedByDefault(groupName, collapsed) {
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.setGroupCollapsedByDefault) {
            rootWindow.setGroupCollapsedByDefault(groupName, collapsed);
        }
        bumpRevision();
    }

    function groupMembersFor(groupName) {
        var _r = rootPanel.revision;
        var out = [];
        if (typeof layoutsCollectionModel === "undefined" || !layoutsCollectionModel) return out;
        for (var i = 0; i < layoutsCollectionModel.count; ++i) {
            var layout = layoutsCollectionModel.get(i);
            if (!layout) continue;
            var grpList = cleanGroupsList(layout.groups);
            if (grpList.indexOf(groupName) !== -1) {
                out.push({
                    layoutIndex: i,
                    layout: layout,
                    label: layoutLabelFor(i, layout),
                    kind: layoutCategoryKind(layout),
                    isVisibleInBar: !!layout.visible
                });
            }
        }
        return out;
    }

    // Builds:
    //  - topLevelEntries: interleaved ungrouped layouts ("layout:<uid>") & groups ("group:<name>")
    //  - groupEntries: only groups in their relative display order
    readonly property var computedModel: {
        var _r = rootPanel.revision;
        var groupCounts = Object.create(null);
        var discoveredGroups = [];
        var ungroupedMap = Object.create(null);
        var ungroupedList = [];
        var visLayoutIndices = [];
        var hidLayoutIndices = [];

        if (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) {
            for (var i = 0; i < layoutsCollectionModel.count; ++i) {
                var layout = layoutsCollectionModel.get(i);
                if (!layout) continue;

                if (layout.visible) {
                    visLayoutIndices.push(i);
                } else {
                    hidLayoutIndices.push(i);
                }

                if (layout.visible && layout.showUngrouped !== false) {
                    var uid = layoutUidFor(i, layout);
                    var tok = "layout:" + uid;
                    var uObj = {
                        itemType: "layout",
                        token: tok,
                        uid: uid,
                        layoutIndex: i,
                        label: layoutLabelFor(i, layout),
                        kind: layoutCategoryKind(layout)
                    };
                    ungroupedMap[tok] = uObj;
                    ungroupedList.push(uObj);
                }

                var grpList = cleanGroupsList(layout.groups);
                for (var j = 0; j < grpList.length; ++j) {
                    var g = grpList[j];
                    if (groupCounts[g] === undefined) {
                        groupCounts[g] = 0;
                        discoveredGroups.push(g);
                    }
                    groupCounts[g] = groupCounts[g] + 1;
                }
            }
        }

        var meta = currentGroupMeta();
        var savedOrder = (typeof rootWindow !== "undefined" && rootWindow && rootWindow.getViewGroupOrder)
                ? rootWindow.getViewGroupOrder() : [];

        // Keep any persisted group in savedOrder even after its last layout is removed
        for (var sg = 0; sg < savedOrder.length; ++sg) {
            var sTok = savedOrder[sg];
            if (sTok.indexOf("group:") === 0) {
                var sgName = sTok.substring(6).trim();
                if (sgName !== "" && groupCounts[sgName] === undefined) {
                    groupCounts[sgName] = 0;
                    discoveredGroups.push(sgName);
                }
            }
        }

        for (var e = 0; e < pendingEmptyGroups.length; ++e) {
            var eg = String(pendingEmptyGroups[e] || "").trim();
            if (eg !== "" && groupCounts[eg] === undefined) {
                groupCounts[eg] = 0;
                discoveredGroups.push(eg);
            }
        }

        var hasExplicitLayoutTokens = false;
        for (var c = 0; c < savedOrder.length; ++c) {
            if (savedOrder[c].indexOf("layout:") === 0) {
                hasExplicitLayoutTokens = true;
                break;
            }
        }

        var topLevel = [];
        var groupsOnly = [];
        var addedTokens = Object.create(null);

        function pushLayoutItem(uObj) {
            if (!uObj || addedTokens[uObj.token]) return;
            addedTokens[uObj.token] = true;
            topLevel.push(uObj);
        }

        function pushGroupItem(grpName) {
            var gTok = "group:" + grpName;
            if (addedTokens[gTok] || groupCounts[grpName] === undefined) return;
            addedTokens[gTok] = true;
            var collapsedDef = !!(meta[grpName] && meta[grpName].collapsedByDefault);
            var gObj = {
                itemType: "group",
                token: gTok,
                key: grpName,
                name: grpName,
                label: grpName,
                memberCount: groupCounts[grpName],
                collapsedByDefault: collapsedDef
            };
            topLevel.push(gObj);
            groupsOnly.push(gObj);
        }

        if (!hasExplicitLayoutTokens && savedOrder.indexOf(ungroupedKey) === -1) {
            for (var u0 = 0; u0 < ungroupedList.length; ++u0) {
                pushLayoutItem(ungroupedList[u0]);
            }
        }

        for (var p = 0; p < savedOrder.length; ++p) {
            var pk = savedOrder[p];
            if (pk === ungroupedKey) {
                for (var u1 = 0; u1 < ungroupedList.length; ++u1) {
                    if (savedOrder.indexOf(ungroupedList[u1].token) === -1) {
                        pushLayoutItem(ungroupedList[u1]);
                    }
                }
            } else if (pk.indexOf("layout:") === 0) {
                if (ungroupedMap[pk]) {
                    pushLayoutItem(ungroupedMap[pk]);
                }
            } else if (pk.indexOf("group:") === 0) {
                pushGroupItem(pk.substring(6));
            } else if (pk.indexOf("sep:") === 0) {
                if (!addedTokens[pk]) {
                    addedTokens[pk] = true;
                    topLevel.push({
                        itemType: "separator",
                        token: pk,
                        label: qsTr("LNG_00630")
                    });
                }
            }
        }

        for (var u2 = 0; u2 < ungroupedList.length; ++u2) {
            pushLayoutItem(ungroupedList[u2]);
        }
        for (var d = 0; d < discoveredGroups.length; ++d) {
            pushGroupItem(discoveredGroups[d]);
        }

        return {
            topLevel: topLevel,
            groupsOnly: groupsOnly,
            visibleLayoutIndices: visLayoutIndices,
            hiddenLayoutIndices: hidLayoutIndices
        };
    }

    readonly property var topLevelEntries: computedModel.topLevel
    readonly property var groupEntries: computedModel.groupsOnly
    readonly property var visibleLayoutIndices: computedModel.visibleLayoutIndices
    readonly property var hiddenLayoutIndices: computedModel.hiddenLayoutIndices

    readonly property var allGroupNames: {
        var names = [];
        for (var i = 0; i < groupEntries.length; ++i) {
            names.push(groupEntries[i].key);
        }
        return names;
    }

    function prunePopulatedPendingGroups() {
        var used = Object.create(null);
        if (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) {
            for (var i = 0; i < layoutsCollectionModel.count; ++i) {
                var l = layoutsCollectionModel.get(i);
                var list = cleanGroupsList(l ? l.groups : null);
                for (var j = 0; j < list.length; ++j) {
                    used[list[j]] = true;
                }
            }
        }
        var kept = [];
        for (var p = 0; p < pendingEmptyGroups.length; ++p) {
            var pg = pendingEmptyGroups[p];
            if (!used[pg]) kept.push(pg);
        }
        if (kept.length !== pendingEmptyGroups.length) {
            pendingEmptyGroups = kept;
        }
    }

    function mergeHiddenLayoutTokens(visibleTokens) {
        var out = visibleTokens ? visibleTokens.slice() : [];
        if (typeof rootWindow === "undefined" || !rootWindow || !rootWindow.getViewGroupOrder) {
            return out;
        }
        var hiddenEligible = Object.create(null);
        if (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) {
            for (var i = 0; i < layoutsCollectionModel.count; ++i) {
                var layout = layoutsCollectionModel.get(i);
                if (layout && !layout.visible && layout.showUngrouped !== false) {
                    hiddenEligible["layout:" + layoutUidFor(i, layout)] = true;
                }
            }
        }
        var inOut = Object.create(null);
        for (var j = 0; j < out.length; ++j) {
            inOut[out[j]] = true;
        }
        var prevOrder = rootWindow.getViewGroupOrder();
        for (var p = 0; p < prevOrder.length; ++p) {
            var tok = prevOrder[p];
            if (!hiddenEligible[tok] || inOut[tok]) continue;
            var insertAt = 0;
            for (var left = p - 1; left >= 0; --left) {
                var pos = out.indexOf(prevOrder[left]);
                if (pos !== -1) {
                    insertAt = pos + 1;
                    break;
                }
            }
            out.splice(insertAt, 0, tok);
            inOut[tok] = true;
        }
        return out;
    }

    function persistTokenOrder(tokens) {
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.setViewGroupOrder) {
            rootWindow.setViewGroupOrder(mergeHiddenLayoutTokens(tokens));
        }
    }

    function currentTokens() {
        var tokens = [];
        for (var i = 0; i < topLevelEntries.length; ++i) {
            tokens.push(topLevelEntries[i].token);
        }
        return tokens;
    }

    function moveTopLevelToken(fromIdx, toIdx) {
        var tokens = currentTokens();
        if (fromIdx < 0 || toIdx < 0 || fromIdx === toIdx || fromIdx >= tokens.length || toIdx >= tokens.length) {
            return;
        }
        var moved = tokens.splice(fromIdx, 1)[0];
        tokens.splice(toIdx, 0, moved);
        persistTokenOrder(tokens);
        bumpRevision();
    }

    // Reorder group cards among themselves while preserving exact interleaved slots relative to ungrouped items
    function moveGroupCardOrder(fromGroupIdx, toGroupIdx) {
        if (fromGroupIdx < 0 || toGroupIdx < 0 || fromGroupIdx === toGroupIdx ||
            fromGroupIdx >= groupEntries.length || toGroupIdx >= groupEntries.length) {
            return;
        }
        var tokens = currentTokens();
        var groupSlotIndices = [];
        var groupTokens = [];
        for (var i = 0; i < tokens.length; ++i) {
            if (tokens[i].indexOf("group:") === 0) {
                groupSlotIndices.push(i);
                groupTokens.push(tokens[i]);
            }
        }
        if (fromGroupIdx >= groupTokens.length || toGroupIdx >= groupTokens.length) return;
        var movedTok = groupTokens.splice(fromGroupIdx, 1)[0];
        groupTokens.splice(toGroupIdx, 0, movedTok);
        for (var s = 0; s < groupSlotIndices.length; ++s) {
            tokens[groupSlotIndices[s]] = groupTokens[s];
        }
        persistTokenOrder(tokens);
        bumpRevision();
    }

    function createGroup(rawName) {
        var name = String(rawName || "").trim();
        if (name === "" || name === ungroupedKey) return;
        for (var i = 0; i < allGroupNames.length; ++i) {
            if (allGroupNames[i] === name) {
                newGroupField.text = "";
                return;
            }
        }
        var nextEmpty = pendingEmptyGroups.slice();
        nextEmpty.push(name);
        pendingEmptyGroups = nextEmpty;

        var tokens = currentTokens();
        tokens.push("group:" + name);
        persistTokenOrder(tokens);
        newGroupField.text = "";
        bumpRevision();
    }

    function addSeparator() {
        var tokens = currentTokens();
        var used = Object.create(null);
        for (var i = 0; i < tokens.length; ++i) {
            used[tokens[i]] = true;
        }
        var n = 1;
        while (used["sep:" + n]) {
            n++;
        }
        tokens.push("sep:" + n);
        persistTokenOrder(tokens);
        bumpRevision();
    }

    function removeSeparator(sepToken) {
        var tokens = currentTokens();
        var filtered = [];
        for (var i = 0; i < tokens.length; ++i) {
            if (tokens[i] !== sepToken) {
                filtered.push(tokens[i]);
            }
        }
        persistTokenOrder(filtered);
        bumpRevision();
    }

    function toggleLayoutInGroup(layoutIndex, groupName) {
        if (typeof layoutsCollectionModel === "undefined" || !layoutsCollectionModel) return;
        if (layoutIndex < 0 || layoutIndex >= layoutsCollectionModel.count) return;
        var layout = layoutsCollectionModel.get(layoutIndex);
        if (!layout) return;
        var g = String(groupName || "").trim();
        if (g === "") return;

        var current = cleanGroupsList(layout.groups);
        var idx = current.indexOf(g);
        if (idx === -1) {
            var wasUngroupedOnly = (current.length === 0 && layout.showUngrouped !== false);
            current.push(g);
            layout.groups = current;
            if (wasUngroupedOnly) {
                layout.showUngrouped = false;
            }
        } else {
            // Ensure legacy/unpersisted group remains saved in groupOrder so removing its last layout keeps it empty
            if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.getViewGroupOrder) {
                var existingOrder = rootWindow.getViewGroupOrder();
                var groupTok = "group:" + g;
                if (existingOrder.indexOf(groupTok) === -1) {
                    var tokensBefore = currentTokens();
                    if (tokensBefore.indexOf(groupTok) === -1) {
                        tokensBefore.push(groupTok);
                    }
                    persistTokenOrder(tokensBefore);
                }
            }
            current.splice(idx, 1);
            layout.groups = current;
            if (current.length === 0 && !layout.showUngrouped) {
                layout.showUngrouped = true;
            }
        }
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.rebuildTopBarEntries) {
            Qt.callLater(rootWindow.rebuildTopBarEntries);
        }
        bumpRevision();
    }

    function toggleLayoutShowUngrouped(layoutIndex) {
        if (typeof layoutsCollectionModel === "undefined" || !layoutsCollectionModel) return;
        if (layoutIndex < 0 || layoutIndex >= layoutsCollectionModel.count) return;
        var layout = layoutsCollectionModel.get(layoutIndex);
        if (!layout) return;
        layout.showUngrouped = !layout.showUngrouped;
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.rebuildTopBarEntries) {
            Qt.callLater(rootWindow.rebuildTopBarEntries);
        }
        bumpRevision();
    }

    function renameGroup(oldName, rawNewName) {
        var oldN = String(oldName || "").trim();
        var newN = String(rawNewName || "").trim();
        if (oldN === "" || newN === "" || oldN === newN || newN === ungroupedKey) return;

        if (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) {
            for (var i = 0; i < layoutsCollectionModel.count; ++i) {
                var layout = layoutsCollectionModel.get(i);
                if (!layout) continue;
                var list = cleanGroupsList(layout.groups);
                var idx = list.indexOf(oldN);
                if (idx !== -1) {
                    if (list.indexOf(newN) === -1) {
                        list[idx] = newN;
                    } else {
                        list.splice(idx, 1);
                    }
                    layout.groups = list;
                }
            }
        }

        var nextPending = pendingEmptyGroups.slice();
        var pIdx = nextPending.indexOf(oldN);
        if (pIdx !== -1) {
            if (nextPending.indexOf(newN) === -1) {
                nextPending[pIdx] = newN;
            } else {
                nextPending.splice(pIdx, 1);
            }
            pendingEmptyGroups = nextPending;
        }

        // Migrate metadata
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.getViewGroupMeta && rootWindow.setViewGroupMeta) {
            var nextMeta = Object.assign({}, rootWindow.getViewGroupMeta());
            if (nextMeta.hasOwnProperty(oldN)) {
                if (!nextMeta.hasOwnProperty(newN)) {
                    nextMeta[newN] = nextMeta[oldN];
                }
                delete nextMeta[oldN];
                rootWindow.setViewGroupMeta(nextMeta);
            }
        }

        // Migrate token order
        var tokens = currentTokens();
        var oldTok = "group:" + oldN;
        var newTok = "group:" + newN;
        var outTokens = [];
        var seen = Object.create(null);
        for (var j = 0; j < tokens.length; ++j) {
            var mapped = (tokens[j] === oldTok) ? newTok : tokens[j];
            if (!seen[mapped]) {
                seen[mapped] = true;
                outTokens.push(mapped);
            }
        }
        persistTokenOrder(outTokens);
        bumpRevision();
    }

    function ungroupAll(groupName) {
        var target = String(groupName || "").trim();
        if (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) {
            for (var i = 0; i < layoutsCollectionModel.count; ++i) {
                var layout = layoutsCollectionModel.get(i);
                if (!layout) continue;
                var list = cleanGroupsList(layout.groups);
                var idx = list.indexOf(target);
                if (idx !== -1) {
                    list.splice(idx, 1);
                    layout.groups = list;
                    if (list.length === 0 && !layout.showUngrouped) {
                        layout.showUngrouped = true;
                    }
                }
            }
        }

        var nextPending = [];
        for (var j = 0; j < pendingEmptyGroups.length; ++j) {
            if (pendingEmptyGroups[j] !== target) {
                nextPending.push(pendingEmptyGroups[j]);
            }
        }
        pendingEmptyGroups = nextPending;

        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.getViewGroupMeta && rootWindow.setViewGroupMeta) {
            var nextMeta = Object.assign({}, rootWindow.getViewGroupMeta());
            if (nextMeta.hasOwnProperty(target)) {
                delete nextMeta[target];
                rootWindow.setViewGroupMeta(nextMeta);
            }
        }

        var tokens = currentTokens();
        var delTok = "group:" + target;
        var outTokens = [];
        for (var k = 0; k < tokens.length; ++k) {
            if (tokens[k] !== delTok) {
                outTokens.push(tokens[k]);
            }
        }
        persistTokenOrder(outTokens);
        bumpRevision();
    }

    function moveGlobalLayout(fromIdx, toIdx) {
        if (fromIdx === toIdx) return;
        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.moveLayout) {
            rootWindow.moveLayout(fromIdx, toIdx);
        } else if (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) {
            layoutsCollectionModel.move(fromIdx, toIdx);
        }
        bumpRevision();
    }

    Component.onCompleted: bumpRevision()

    Connections {
        target: (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel) ? layoutsCollectionModel : null
        function onChanged() { rootPanel.bumpRevision(); }
        function onCountChanged() { rootPanel.bumpRevision(); }
        function onLayoutMoved(from, to) { rootPanel.bumpRevision(); }
    }

    Connections {
        target: (typeof rootWindow !== "undefined" && rootWindow) ? rootWindow : null
        function onViewGroupOrderJsonChanged() { rootPanel.bumpRevision(); }
        function onViewGroupMetaJsonChanged() { rootPanel.bumpRevision(); }
    }

    Text {
        text: qsTr("LNG_00601")
        color: "#8898a6"
        font.pixelSize: 11
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    // Create new group bar
    Frame {
        Layout.fillWidth: true
        background: Rectangle {
            color: "#141a21"
            border.color: "#2a3540"
            border.width: 1
            radius: 8
        }

        RowLayout {
            width: parent.width
            spacing: 10

            TextField {
                id: newGroupField
                placeholderText: qsTr("LNG_00602")
                selectByMouse: true
                Layout.fillWidth: true
                color: "white"
                background: Rectangle {
                    color: "#0f151b"
                    radius: 4
                    border.color: newGroupField.activeFocus ? "#00f5d4" : "#2a3540"
                }
                onAccepted: rootPanel.createGroup(newGroupField.text)
            }

            Button {
                id: createGroupBtn
                text: qsTr("LNG_00603")
                enabled: newGroupField.text.trim() !== ""
                implicitWidth: Math.max(120, createGroupTxt.implicitWidth + 24)
                implicitHeight: 34

                contentItem: Text {
                    id: createGroupTxt
                    text: createGroupBtn.text
                    font.bold: true
                    font.pixelSize: 11
                    color: createGroupBtn.enabled ? "#0f151b" : "#6c7f90"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 6
                    color: createGroupBtn.enabled ? (createGroupBtn.pressed ? "#00c4a7" : (createGroupBtn.hovered ? "#2effe1" : "#00f5d4")) : "#1c242c"
                    border.color: createGroupBtn.enabled ? "#00f5d4" : "#2a3540"
                    border.width: 1
                }

                onClicked: rootPanel.createGroup(newGroupField.text)
            }
        }
    }

    // 1) Special Higher-Level Card: Top Bar Main Sequence (interleaved ungrouped views & groups)
    Rectangle {
        id: topLevelCard
        Layout.fillWidth: true
        implicitHeight: topLevelCol.implicitHeight + 18
        radius: 8
        color: "#111921"
        border.color: "#4f738e"
        border.width: 1

        ColumnLayout {
            id: topLevelCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 9
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: "#00f5d4"
                }

                Text {
                    text: qsTr("LNG_00627")
                    color: "#00f5d4"
                    font.bold: true
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Button {
                    id: addSeparatorBtn
                    text: "+ " + qsTr("LNG_00629")
                    implicitWidth: addSepTxt.implicitWidth + 18
                    implicitHeight: 24
                    onClicked: rootPanel.addSeparator()

                    contentItem: Text {
                        id: addSepTxt
                        text: addSeparatorBtn.text
                        color: addSeparatorBtn.hovered ? "#ffffff" : "#d8b4fe"
                        font.pixelSize: 10
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 6
                        color: addSeparatorBtn.hovered ? "#3b2754" : "#221a30"
                        border.color: addSeparatorBtn.hovered ? "#c084fc" : "#7e57c2"
                        border.width: 1
                    }
                }

                Button {
                    id: topLevelExpandBtn
                    implicitWidth: topLevelExpandRow.implicitWidth + 16
                    implicitHeight: 24
                    onClicked: rootPanel.topLevelExpanded = !rootPanel.topLevelExpanded

                    contentItem: Row {
                        id: topLevelExpandRow
                        anchors.centerIn: parent
                        spacing: 5
                        Text {
                            text: String(rootPanel.topLevelEntries.length)
                            color: rootPanel.topLevelExpanded ? "#00f5d4" : "#b8c7d4"
                            font.pixelSize: 10
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: rootPanel.topLevelExpanded ? "▴" : "▾"
                            color: rootPanel.topLevelExpanded ? "#00f5d4" : "#8898a6"
                            font.pixelSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    background: Rectangle {
                        radius: 6
                        color: rootPanel.topLevelExpanded ? "#162d36" : (topLevelExpandBtn.hovered ? "#25323e" : "#1c242c")
                        border.color: rootPanel.topLevelExpanded ? "#00f5d4" : (topLevelExpandBtn.hovered ? "#4f738e" : "#2a3540")
                        border.width: 1
                    }
                }
            }

            Text {
                visible: rootPanel.topLevelExpanded && rootPanel.topLevelEntries.length === 0
                text: qsTr("LNG_00618")
                color: "#6c7f90"
                font.pixelSize: 10
                font.italic: true
            }

            Item {
                id: topLevelDragWrapper
                Layout.fillWidth: true
                height: topLevelFlow.implicitHeight
                implicitHeight: topLevelFlow.implicitHeight
                visible: rootPanel.topLevelExpanded && rootPanel.topLevelEntries.length > 0

                QtObject {
                    id: topDragState
                    property int sourceIdx: -1
                    property int targetIdx: -1
                    property string previewText: ""
                    property bool previewIsGroup: false
                    function reset() {
                        sourceIdx = -1;
                        targetIdx = -1;
                        previewText = "";
                        previewIsGroup = false;
                    }
                }

                Rectangle {
                    id: topDragProxy
                    visible: topDragState.sourceIdx !== -1
                    z: 9999
                    width: Math.min(230, topDragTxt.implicitWidth + 24)
                    height: 28
                    radius: 6
                    color: topDragState.previewIsGroup ? "#2a2016" : "#1c2e38"
                    border.color: topDragState.previewIsGroup ? "#ff7a00" : "#00f5d4"
                    border.width: 1
                    opacity: 0.94

                    Text {
                        id: topDragTxt
                        anchors.centerIn: parent
                        text: topDragState.previewText
                        color: topDragState.previewIsGroup ? "#ffbe80" : "#00f5d4"
                        font.pixelSize: 11
                        font.bold: true
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, 206)
                    }
                }

                Flow {
                    id: topLevelFlow
                    width: parent.width
                    spacing: 8

                    Repeater {
                        model: rootPanel.topLevelExpanded ? rootPanel.topLevelEntries : []
                        delegate: Rectangle {
                            id: topChip
                            property var entryData: modelData
                            property int chipIdx: index
                            readonly property bool isGroupToken: !!(entryData && entryData.itemType === "group")
                            readonly property bool isSeparatorToken: !!(entryData && entryData.itemType === "separator")
                            readonly property bool isBeingDragged: topDragState.sourceIdx === chipIdx
                            readonly property bool isDropTarget: topDragState.targetIdx === chipIdx && topDragState.sourceIdx !== chipIdx && topDragState.sourceIdx !== -1
                            readonly property bool dropLeft: isDropTarget && topDragState.sourceIdx > chipIdx
                            readonly property bool dropRight: isDropTarget && topDragState.sourceIdx < chipIdx
                            readonly property real pushOffsetX: {
                                if (topDragState.sourceIdx === -1 || topDragState.targetIdx === -1 || topDragState.sourceIdx === topDragState.targetIdx)
                                    return 0;
                                if (topDragState.sourceIdx === chipIdx)
                                    return 0;
                                if (topDragState.sourceIdx < chipIdx && chipIdx <= topDragState.targetIdx)
                                    return -12;
                                if (topDragState.targetIdx <= chipIdx && chipIdx < topDragState.sourceIdx)
                                    return 12;
                                return 0;
                            }

                            implicitWidth: topChipRow.implicitWidth + (isSeparatorToken ? 14 : 18)
                            height: 28
                            radius: 6
                            opacity: isBeingDragged ? 0.35 : 1.0
                            color: isDropTarget
                                   ? (isSeparatorToken ? "#3e2759" : (isGroupToken ? "#332517" : "#1d3340"))
                                   : (isSeparatorToken ? "#221a30" : (isGroupToken ? "#211c17" : "#1b2834"))
                            border.color: isDropTarget ? "#ffffff" : (isSeparatorToken ? "#c084fc" : (isGroupToken ? "#ff7a00" : "#4f738e"))
                            border.width: 1

                            transform: Translate {
                                x: topChip.pushOffsetX
                                Behavior on x {
                                    NumberAnimation { duration: 130; easing.type: Easing.OutCubic }
                                }
                            }

                            Rectangle {
                                visible: topChip.dropLeft
                                anchors.left: parent.left
                                anchors.leftMargin: -5
                                anchors.verticalCenter: parent.verticalCenter
                                width: 3
                                height: 22
                                radius: 1.5
                                color: "#00f5d4"
                                z: 5
                            }

                            Rectangle {
                                visible: topChip.dropRight
                                anchors.right: parent.right
                                anchors.rightMargin: -5
                                anchors.verticalCenter: parent.verticalCenter
                                width: 3
                                height: 22
                                radius: 1.5
                                color: "#00f5d4"
                                z: 5
                            }

                            MouseArea {
                                id: topChipDragMouse
                                anchors.fill: parent
                                anchors.rightMargin: topChip.isSeparatorToken ? 26 : 0
                                hoverEnabled: true
                                preventStealing: true
                                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                                function updateTopDrop(px, py) {
                                    var chs = topLevelFlow.children;
                                    var bestIdx = topDragState.sourceIdx;
                                    var bestScore = 1e9;
                                    for (var i = 0; i < chs.length; ++i) {
                                        var ch = chs[i];
                                        if (!ch || !ch.visible || typeof ch.chipIdx !== "number") continue;
                                        var cx = ch.x + ch.width * 0.5;
                                        var cy = ch.y + ch.height * 0.5;
                                        var dy = Math.abs(py - cy);
                                        var dx = Math.abs(px - cx);
                                        var score = (dy <= ch.height * 0.65) ? dx : (dy * 4.0 + dx);
                                        if (score < bestScore) {
                                            bestScore = score;
                                            bestIdx = ch.chipIdx;
                                        }
                                    }
                                    topDragState.targetIdx = bestIdx;
                                }

                                onPressed: {
                                    topDragProxy.x = Math.max(0, Math.min(topLevelDragWrapper.width - topDragProxy.width, topChip.x));
                                    topDragProxy.y = topChip.y;
                                    topDragState.sourceIdx = topChip.chipIdx;
                                    topDragState.targetIdx = topChip.chipIdx;
                                    topDragState.previewText = topChip.entryData.label;
                                    topDragState.previewIsGroup = topChip.isGroupToken;
                                }
                                onPositionChanged: {
                                    if (!pressed || topDragState.sourceIdx === -1) return;
                                    var p = topChipDragMouse.mapToItem(topLevelDragWrapper, mouse.x, mouse.y);
                                    topDragProxy.x = Math.max(0, Math.min(topLevelDragWrapper.width - topDragProxy.width, p.x - topDragProxy.width * 0.5));
                                    topDragProxy.y = Math.max(0, Math.min(Math.max(0, topLevelDragWrapper.height - topDragProxy.height), p.y - topDragProxy.height * 0.5));
                                    updateTopDrop(p.x, p.y);
                                }
                                onReleased: {
                                    var fromI = topDragState.sourceIdx;
                                    var toI = topDragState.targetIdx;
                                    topDragState.reset();
                                    if (fromI !== -1 && toI !== -1 && fromI !== toI) {
                                        rootPanel.moveTopLevelToken(fromI, toI);
                                    }
                                }
                                onCanceled: topDragState.reset()

                                ToolTip.delay: Compact.toolTipDelay
                                ToolTip.timeout: Compact.toolTipTimeout
                                ToolTip.visible: topChipDragMouse.containsMouse && topDragState.sourceIdx === -1
                                ToolTip.text: qsTr("LNG_00631")
                            }

                            Row {
                                id: topChipRow
                                anchors.centerIn: parent
                                spacing: 6

                                Rectangle {
                                    visible: !topChip.isGroupToken && !topChip.isSeparatorToken
                                    width: topKindTxt.implicitWidth + 8
                                    height: 16
                                    radius: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: (topChip.entryData && topChip.entryData.kind === "nvr") ? "#2e2214" : ((topChip.entryData && topChip.entryData.kind === "preset") ? "#112b2a" : "#222e3a")
                                    border.color: (topChip.entryData && topChip.entryData.kind === "nvr") ? "#ff7a00" : ((topChip.entryData && topChip.entryData.kind === "preset") ? "#00f5d4" : "#4f738e")
                                    border.width: 1
                                    Text {
                                        id: topKindTxt
                                        anchors.centerIn: parent
                                        text: (!topChip.isGroupToken && !topChip.isSeparatorToken && topChip.entryData) ? rootPanel.kindBadgeText(topChip.entryData.kind) : ""
                                        color: (topChip.entryData && topChip.entryData.kind === "nvr") ? "#ffbe80" : ((topChip.entryData && topChip.entryData.kind === "preset") ? "#00f5d4" : "#c7d4df")
                                        font.pixelSize: 9
                                        font.bold: true
                                    }
                                }

                                Image {
                                    visible: topChip.isGroupToken
                                    width: 13
                                    height: 13
                                    sourceSize.width: 13
                                    sourceSize.height: 13
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: rootPanel.groupNetworkIconSvg()
                                }

                                Text {
                                    visible: topChip.isGroupToken
                                    text: topChip.isGroupToken ? (topChip.entryData.collapsedByDefault ? "▸" : "▾") : ""
                                    color: "#ffbe80"
                                    font.pixelSize: 10
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    visible: topChip.isSeparatorToken
                                    text: "↵"
                                    color: "#c084fc"
                                    font.pixelSize: 12
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: topChip.entryData ? topChip.entryData.label : ""
                                    color: topChip.isSeparatorToken ? "#e9d5ff" : (topChip.isGroupToken ? "#ffbe80" : "white")
                                    font.pixelSize: 11
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    visible: topChip.isGroupToken
                                    text: topChip.isGroupToken ? ("(" + topChip.entryData.memberCount + ")") : ""
                                    color: "#a89886"
                                    font.pixelSize: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Button {
                                    id: removeSepBtn
                                    visible: topChip.isSeparatorToken
                                    implicitWidth: 20
                                    implicitHeight: 20
                                    z: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    contentItem: Text {
                                        text: "✕"
                                        color: removeSepBtn.hovered ? "#ffffff" : "#ff6b6b"
                                        font.pixelSize: 11
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        radius: 4
                                        color: removeSepBtn.hovered ? "#b91c1c" : "#3a161a"
                                        border.color: removeSepBtn.hovered ? "#ff4d4d" : "#a83232"
                                        border.width: 1
                                    }
                                    onClicked: rootPanel.removeSeparator(topChip.entryData.token)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 2) Groups Header & Draggable Group Bars (with vertical push-aside animation)
    Text {
        visible: rootPanel.groupEntries.length > 0
        text: qsTr("LNG_00628")
        color: "#00f5d4"
        font.bold: true
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    Item {
        id: groupDragWrapper
        visible: rootPanel.groupEntries.length > 0
        Layout.fillWidth: true
        height: groupsCol.implicitHeight
        implicitHeight: groupsCol.implicitHeight

        QtObject {
            id: groupDragState
            property int sourceIdx: -1
            property int targetIdx: -1
            property string previewText: ""
            function reset() {
                sourceIdx = -1;
                targetIdx = -1;
                previewText = "";
            }
        }

        Rectangle {
            id: groupDragProxy
            visible: groupDragState.sourceIdx !== -1
            z: 9999
            width: Math.min(280, groupDragWrapper.width - 20)
            height: 32
            radius: 6
            color: "#1c2a33"
            border.color: "#00f5d4"
            border.width: 1
            opacity: 0.94

            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                text: groupDragState.previewText
                color: "#00f5d4"
                font.pixelSize: 11
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        ColumnLayout {
            id: groupsCol
            width: parent.width
            spacing: 8

            Repeater {
                model: rootPanel.groupEntries
                delegate: Rectangle {
                    id: groupCard
                    property var grpData: modelData
                    property int grpIdx: index
                    readonly property string groupName: grpData ? grpData.name : ""
                    readonly property bool isExpanded: rootPanel.isSectionExpanded(groupName)
                    readonly property var expandedMembers: isExpanded ? rootPanel.groupMembersFor(groupName) : []
                    readonly property bool isBeingDragged: groupDragState.sourceIdx === grpIdx
                    readonly property bool isDropTarget: groupDragState.targetIdx === grpIdx && groupDragState.sourceIdx !== grpIdx && groupDragState.sourceIdx !== -1
                    readonly property bool dropAbove: isDropTarget && groupDragState.sourceIdx > grpIdx
                    readonly property bool dropBelow: isDropTarget && groupDragState.sourceIdx < grpIdx
                    readonly property real pushOffsetY: {
                        if (groupDragState.sourceIdx === -1 || groupDragState.targetIdx === -1 || groupDragState.sourceIdx === groupDragState.targetIdx)
                            return 0;
                        if (groupDragState.sourceIdx === grpIdx)
                            return 0;
                        if (groupDragState.sourceIdx < grpIdx && grpIdx <= groupDragState.targetIdx)
                            return -12;
                        if (groupDragState.targetIdx <= grpIdx && grpIdx < groupDragState.sourceIdx)
                            return 12;
                        return 0;
                    }

                    Layout.fillWidth: true
                    implicitHeight: groupCardCol.implicitHeight + 16
                    opacity: isBeingDragged ? 0.35 : 1.0
                    color: isDropTarget ? "#172530" : "#141a21"
                    radius: 8
                    border.color: isDropTarget ? "#00f5d4" : "#354c5e"
                    border.width: 1

                    transform: Translate {
                        y: groupCard.pushOffsetY
                        Behavior on y {
                            NumberAnimation { duration: 135; easing.type: Easing.OutCubic }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: groupCard.dropAbove ? parent.top : undefined
                        anchors.bottom: groupCard.dropBelow ? parent.bottom : undefined
                        height: 3
                        radius: 1.5
                        color: "#00f5d4"
                        visible: groupCard.isDropTarget
                        z: 5
                    }

                    ColumnLayout {
                        id: groupCardCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 8
                        spacing: 8

                        // Group header row
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Item {
                                id: grpGrip
                                width: 22
                                height: 28

                                Image {
                                    anchors.centerIn: parent
                                    width: 14
                                    height: 14
                                    sourceSize.width: 14
                                    sourceSize.height: 14
                                    source: {
                                        var c = (grpDragMouse.containsMouse || groupCard.isBeingDragged) ? "%2300f5d4" : "%236b7c8a";
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

                                    function updateGroupDropTarget(pointerYInParent) {
                                        var chs = groupsCol.children;
                                        var bestIdx = groupDragState.sourceIdx;
                                        var bestDist = 1e9;
                                        for (var i = 0; i < chs.length; ++i) {
                                            var ch = chs[i];
                                            if (!ch || !ch.visible || typeof ch.grpIdx !== "number") continue;
                                            var topY = ch.mapToItem(groupDragWrapper, 0, 0).y;
                                            var bottomY = topY + ch.height;
                                            if (pointerYInParent >= topY - 4 && pointerYInParent <= bottomY + 4) {
                                                bestIdx = ch.grpIdx;
                                                break;
                                            }
                                            var dist = Math.abs(pointerYInParent - (topY + bottomY) * 0.5);
                                            if (dist < bestDist) {
                                                bestDist = dist;
                                                bestIdx = ch.grpIdx;
                                            }
                                        }
                                        groupDragState.targetIdx = bestIdx;
                                    }

                                    onPressed: {
                                        var pt = grpGrip.mapToItem(groupDragWrapper, 0, 0);
                                        groupDragProxy.x = pt.x;
                                        groupDragProxy.y = pt.y;
                                        groupDragState.sourceIdx = groupCard.grpIdx;
                                        groupDragState.targetIdx = groupCard.grpIdx;
                                        groupDragState.previewText = groupCard.groupName;
                                    }
                                    onPositionChanged: {
                                        if (!pressed || groupDragState.sourceIdx === -1) return;
                                        var p = grpDragMouse.mapToItem(groupDragWrapper, mouse.x, mouse.y);
                                        var maxY = Math.max(0, groupDragWrapper.height - groupDragProxy.height);
                                        groupDragProxy.y = Math.max(0, Math.min(maxY, p.y - groupDragProxy.height * 0.5));
                                        updateGroupDropTarget(p.y);
                                    }
                                    onReleased: {
                                        var fromI = groupDragState.sourceIdx;
                                        var toI = groupDragState.targetIdx;
                                        groupDragState.reset();
                                        if (fromI !== -1 && toI !== -1 && fromI !== toI) {
                                            rootPanel.moveGroupCardOrder(fromI, toI);
                                        }
                                    }
                                    onCanceled: groupDragState.reset()

                                    ToolTip.delay: Compact.toolTipDelay
                                    ToolTip.timeout: Compact.toolTipTimeout
                                    ToolTip.visible: grpDragMouse.containsMouse && groupDragState.sourceIdx === -1
                                    ToolTip.text: qsTr("LNG_00631")
                                }
                            }

                            Rectangle {
                                implicitWidth: Math.max(26, grpNumTxt.implicitWidth + 10)
                                implicitHeight: 22
                                radius: 6
                                color: "#1c242c"
                                border.color: "#354c5e"
                                border.width: 1
                                Text {
                                    id: grpNumTxt
                                    anchors.centerIn: parent
                                    text: "#" + (groupCard.grpIdx + 1)
                                    color: "#ffbe80"
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }

                            Image {
                                width: 14
                                height: 14
                                sourceSize.width: 14
                                sourceSize.height: 14
                                source: rootPanel.groupNetworkIconSvg()
                            }

                            TextField {
                                id: groupRenameField
                                text: groupCard.groupName
                                selectByMouse: true
                                Layout.fillWidth: true
                                color: "#00f5d4"
                                font.bold: true
                                font.pixelSize: 12
                                background: Rectangle {
                                    color: groupRenameField.activeFocus ? "#0f151b" : "transparent"
                                    radius: 4
                                    border.color: groupRenameField.activeFocus ? "#00f5d4" : "#2a3540"
                                    border.width: 1
                                }
                                onEditingFinished: {
                                    if (text.trim() !== "" && text.trim() !== groupCard.groupName) {
                                        rootPanel.renameGroup(groupCard.groupName, text);
                                    } else {
                                        text = groupCard.groupName;
                                    }
                                }
                            }

                            // "Collapsed by default" option per group
                            Button {
                                id: collapsedByDefaultBtn
                                readonly property bool isCollapsedDef: !!(groupCard.grpData && groupCard.grpData.collapsedByDefault)
                                implicitWidth: collapsedRow.implicitWidth + 16
                                implicitHeight: 24
                                onClicked: rootPanel.setGroupCollapsedByDefault(groupCard.groupName, !isCollapsedDef)

                                contentItem: Row {
                                    id: collapsedRow
                                    anchors.centerIn: parent
                                    spacing: 5
                                    Text {
                                        text: collapsedByDefaultBtn.isCollapsedDef ? "✓" : "▸"
                                        color: collapsedByDefaultBtn.isCollapsedDef ? "#0f151b" : "#9db0c0"
                                        font.pixelSize: 10
                                        font.bold: true
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Text {
                                        text: qsTr("LNG_00623")
                                        color: collapsedByDefaultBtn.isCollapsedDef ? "#0f151b" : "#c7d4df"
                                        font.pixelSize: 10
                                        font.bold: collapsedByDefaultBtn.isCollapsedDef
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                background: Rectangle {
                                    radius: 6
                                    color: collapsedByDefaultBtn.isCollapsedDef ? "#ff9e00" : (collapsedByDefaultBtn.hovered ? "#25323e" : "#1c242c")
                                    border.color: collapsedByDefaultBtn.isCollapsedDef ? "#ff9e00" : "#354c5e"
                                    border.width: 1
                                }
                            }

                            // Expand/collapse member count badge
                            Button {
                                id: expandMembersBtn
                                implicitWidth: expandRow.implicitWidth + 16
                                implicitHeight: 24
                                onClicked: rootPanel.toggleSectionExpanded(groupCard.groupName)

                                contentItem: Row {
                                    id: expandRow
                                    anchors.centerIn: parent
                                    spacing: 5
                                    Text {
                                        text: String(groupCard.grpData.memberCount)
                                        color: groupCard.isExpanded ? "#00f5d4" : "#b8c7d4"
                                        font.pixelSize: 10
                                        font.bold: true
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Text {
                                        text: groupCard.isExpanded ? "▴" : "▾"
                                        color: groupCard.isExpanded ? "#00f5d4" : "#8898a6"
                                        font.pixelSize: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                background: Rectangle {
                                    radius: 6
                                    color: groupCard.isExpanded ? "#162d36" : (expandMembersBtn.hovered ? "#25323e" : "#1c242c")
                                    border.color: groupCard.isExpanded ? "#00f5d4" : (expandMembersBtn.hovered ? "#4f738e" : "#2a3540")
                                    border.width: 1
                                }

                                ToolTip.delay: Compact.toolTipDelay
                                ToolTip.timeout: Compact.toolTipTimeout
                                ToolTip.visible: expandMembersBtn.hovered
                                ToolTip.text: qsTr("LNG_00620")
                            }

                            Button {
                                id: ungroupAllBtn
                                implicitWidth: 28
                                implicitHeight: 28

                                contentItem: Image {
                                    anchors.centerIn: parent
                                    width: 14
                                    height: 14
                                    source: {
                                        var c = ungroupAllBtn.hovered ? "%23ff4d4d" : "%238898a6";
                                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + c + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path></svg>";
                                    }
                                }

                                background: Rectangle {
                                    radius: 6
                                    color: ungroupAllBtn.hovered ? "#2a181c" : "transparent"
                                    border.color: ungroupAllBtn.hovered ? "#ff4d4d" : "#2a3540"
                                    border.width: 1
                                }

                                onClicked: {
                                    deleteGroupConfirmDialog.targetGroupName = groupCard.groupName;
                                    deleteGroupConfirmDialog.open();
                                }

                                ToolTip.delay: Compact.toolTipDelay
                                ToolTip.timeout: Compact.toolTipTimeout
                                ToolTip.visible: ungroupAllBtn.hovered
                                ToolTip.text: qsTr("LNG_00605")
                            }
                        }

                        Text {
                            visible: groupCard.isExpanded && groupCard.expandedMembers.length === 0
                            text: qsTr("LNG_00609")
                            color: "#6c7f90"
                            font.pixelSize: 10
                            font.italic: true
                        }

                        Item {
                            id: membersDragWrapper
                            Layout.fillWidth: true
                            height: membersFlow.implicitHeight
                            implicitHeight: membersFlow.implicitHeight
                            visible: groupCard.isExpanded && groupCard.expandedMembers.length > 0

                            QtObject {
                                id: chipDragState
                                property int sourceListIdx: -1
                                property int sourceLayoutIdx: -1
                                property int targetListIdx: -1
                                property int targetLayoutIdx: -1
                                property string previewText: ""
                                function reset() {
                                    sourceListIdx = -1;
                                    sourceLayoutIdx = -1;
                                    targetListIdx = -1;
                                    targetLayoutIdx = -1;
                                    previewText = "";
                                }
                            }

                            Rectangle {
                                id: chipDragProxy
                                visible: chipDragState.sourceListIdx !== -1
                                z: 9999
                                width: Math.min(220, chipDragTxt.implicitWidth + 24)
                                height: 28
                                radius: 6
                                color: "#1c2e38"
                                border.color: "#00f5d4"
                                border.width: 1
                                opacity: 0.94

                                Text {
                                    id: chipDragTxt
                                    anchors.centerIn: parent
                                    text: chipDragState.previewText
                                    color: "#00f5d4"
                                    font.pixelSize: 11
                                    font.bold: true
                                    elide: Text.ElideRight
                                    width: Math.min(implicitWidth, 196)
                                }
                            }

                            Flow {
                                id: membersFlow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: groupCard.isExpanded ? groupCard.expandedMembers : []
                                    delegate: Rectangle {
                                        id: memberChip
                                        property string kind: modelData.kind
                                        property int chipListIdx: index
                                        property int layoutIdx: modelData.layoutIndex
                                        readonly property bool isBeingDragged: chipDragState.sourceListIdx === chipListIdx
                                        readonly property bool isDropTarget: chipDragState.targetListIdx === chipListIdx && chipDragState.sourceListIdx !== chipListIdx && chipDragState.sourceListIdx !== -1
                                        readonly property bool dropLeft: isDropTarget && chipDragState.sourceListIdx > chipListIdx
                                        readonly property bool dropRight: isDropTarget && chipDragState.sourceListIdx < chipListIdx
                                        readonly property real pushOffsetX: {
                                            if (chipDragState.sourceListIdx === -1 || chipDragState.targetListIdx === -1 || chipDragState.sourceListIdx === chipDragState.targetListIdx)
                                                return 0;
                                            if (chipDragState.sourceListIdx === chipListIdx)
                                                return 0;
                                            if (chipDragState.sourceListIdx < chipListIdx && chipListIdx <= chipDragState.targetListIdx)
                                                return -12;
                                            if (chipDragState.targetListIdx <= chipListIdx && chipListIdx < chipDragState.sourceListIdx)
                                                return 12;
                                            return 0;
                                        }

                                        implicitWidth: memberRow.implicitWidth + 14
                                        height: 28
                                        radius: 6
                                        opacity: isBeingDragged ? 0.35 : 1.0
                                        color: isDropTarget ? "#1d3340" : "#1b2834"
                                        border.color: isDropTarget ? "#ffffff" : "#00f5d4"
                                        border.width: 1

                                        transform: Translate {
                                            x: memberChip.pushOffsetX
                                            Behavior on x {
                                                NumberAnimation { duration: 130; easing.type: Easing.OutCubic }
                                            }
                                        }

                                        Rectangle {
                                            visible: memberChip.dropLeft
                                            anchors.left: parent.left
                                            anchors.leftMargin: -5
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 3
                                            height: 22
                                            radius: 1.5
                                            color: "#00f5d4"
                                            z: 5
                                        }

                                        Rectangle {
                                            visible: memberChip.dropRight
                                            anchors.right: parent.right
                                            anchors.rightMargin: -5
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 3
                                            height: 22
                                            radius: 1.5
                                            color: "#00f5d4"
                                            z: 5
                                        }

                                        MouseArea {
                                            id: chipDragMouse
                                            anchors.fill: parent
                                            anchors.rightMargin: 28
                                            hoverEnabled: true
                                            preventStealing: true
                                            cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                                            function updateChipDrop(px, py) {
                                                var chs = membersFlow.children;
                                                var bestListIdx = chipDragState.sourceListIdx;
                                                var bestLayoutIdx = chipDragState.sourceLayoutIdx;
                                                var bestScore = 1e9;
                                                for (var i = 0; i < chs.length; ++i) {
                                                    var ch = chs[i];
                                                    if (!ch || !ch.visible || typeof ch.chipListIdx !== "number") continue;
                                                    var cx = ch.x + ch.width * 0.5;
                                                    var cy = ch.y + ch.height * 0.5;
                                                    var dy = Math.abs(py - cy);
                                                    var dx = Math.abs(px - cx);
                                                    var score = (dy <= ch.height * 0.65) ? dx : (dy * 4.0 + dx);
                                                    if (score < bestScore) {
                                                        bestScore = score;
                                                        bestListIdx = ch.chipListIdx;
                                                        bestLayoutIdx = ch.layoutIdx;
                                                    }
                                                }
                                                chipDragState.targetListIdx = bestListIdx;
                                                chipDragState.targetLayoutIdx = bestLayoutIdx;
                                            }

                                            onPressed: {
                                                chipDragProxy.x = Math.max(0, Math.min(membersDragWrapper.width - chipDragProxy.width, memberChip.x));
                                                chipDragProxy.y = memberChip.y;
                                                chipDragState.sourceListIdx = memberChip.chipListIdx;
                                                chipDragState.sourceLayoutIdx = memberChip.layoutIdx;
                                                chipDragState.targetListIdx = memberChip.chipListIdx;
                                                chipDragState.targetLayoutIdx = memberChip.layoutIdx;
                                                chipDragState.previewText = modelData.label;
                                            }
                                            onPositionChanged: {
                                                if (!pressed || chipDragState.sourceListIdx === -1) return;
                                                var p = chipDragMouse.mapToItem(membersDragWrapper, mouse.x, mouse.y);
                                                chipDragProxy.x = Math.max(0, Math.min(membersDragWrapper.width - chipDragProxy.width, p.x - chipDragProxy.width * 0.5));
                                                chipDragProxy.y = Math.max(0, Math.min(Math.max(0, membersDragWrapper.height - chipDragProxy.height), p.y - chipDragProxy.height * 0.5));
                                                updateChipDrop(p.x, p.y);
                                            }
                                            onReleased: {
                                                var fromIdx = chipDragState.sourceLayoutIdx;
                                                var toIdx = chipDragState.targetLayoutIdx;
                                                chipDragState.reset();
                                                if (fromIdx !== -1 && toIdx !== -1 && fromIdx !== toIdx) {
                                                    rootPanel.moveGlobalLayout(fromIdx, toIdx);
                                                }
                                            }
                                            onCanceled: chipDragState.reset()

                                            ToolTip.delay: Compact.toolTipDelay
                                            ToolTip.timeout: Compact.toolTipTimeout
                                            ToolTip.visible: chipDragMouse.containsMouse && chipDragState.sourceListIdx === -1
                                            ToolTip.text: qsTr("LNG_00631")
                                        }

                                        RowLayout {
                                            id: memberRow
                                            anchors.centerIn: parent
                                            spacing: 6

                                            Rectangle {
                                                implicitWidth: kindChipTxt.implicitWidth + 8
                                                implicitHeight: 16
                                                radius: 4
                                                color: memberChip.kind === "nvr" ? "#2e2214" : (memberChip.kind === "preset" ? "#112b2a" : "#222e3a")
                                                border.color: memberChip.kind === "nvr" ? "#ff7a00" : (memberChip.kind === "preset" ? "#00f5d4" : "#4f738e")
                                                border.width: 1
                                                Text {
                                                    id: kindChipTxt
                                                    anchors.centerIn: parent
                                                    text: rootPanel.kindBadgeText(memberChip.kind)
                                                    color: memberChip.kind === "nvr" ? "#ffbe80" : (memberChip.kind === "preset" ? "#00f5d4" : "#c7d4df")
                                                    font.pixelSize: 9
                                                    font.bold: true
                                                }
                                            }

                                            Text {
                                                text: modelData.label
                                                color: "white"
                                                font.pixelSize: 11
                                                font.bold: true
                                            }

                                            Button {
                                                id: removeMemberBtn
                                                implicitWidth: 21
                                                implicitHeight: 21
                                                z: 2
                                                contentItem: Text {
                                                    text: "✕"
                                                    color: removeMemberBtn.hovered ? "#ffffff" : "#ff6b6b"
                                                    font.pixelSize: 12
                                                    font.bold: true
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                }
                                                background: Rectangle {
                                                    radius: 4
                                                    color: removeMemberBtn.hovered ? "#b91c1c" : "#3a161a"
                                                    border.color: removeMemberBtn.hovered ? "#ff4d4d" : "#a83232"
                                                    border.width: 1
                                                }
                                                onClicked: rootPanel.toggleLayoutInGroup(modelData.layoutIndex, groupCard.groupName)

                                                ToolTip.delay: Compact.toolTipDelay
                                                ToolTip.timeout: Compact.toolTipTimeout
                                                ToolTip.visible: removeMemberBtn.hovered
                                                ToolTip.text: qsTr("LNG_00606")
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

    // 3) All layouts assignment section (no drag handles; assignment & ungrouped visibility only)
    Text {
        text: qsTr("LNG_00607")
        color: "#00f5d4"
        font.bold: true
        font.pixelSize: 13
        Layout.topMargin: 6
    }

    Text {
        visible: (typeof layoutsCollectionModel === "undefined" || !layoutsCollectionModel || layoutsCollectionModel.count === 0)
        text: qsTr("LNG_00608")
        color: "#8898a6"
        font.pixelSize: 11
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    // Shared delegate component for layout assignment cards (used by visible and hidden subsections)
    Component {
        id: layoutAssignCardComponent

        Rectangle {
            id: layoutAssignCard
            readonly property int layoutIdx: targetLayoutIndex
            readonly property var layoutObj: {
                var _r = rootPanel.revision;
                return (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel && layoutIdx >= 0 && layoutIdx < layoutsCollectionModel.count)
                        ? layoutsCollectionModel.get(layoutIdx) : null;
            }
            readonly property string itemKind: rootPanel.layoutCategoryKind(layoutObj)
            readonly property string itemLabel: rootPanel.layoutLabelFor(layoutIdx, layoutObj)
            readonly property var assignedGroups: {
                var _r = rootPanel.revision;
                return rootPanel.cleanGroupsList(layoutObj ? layoutObj.groups : null);
            }
            readonly property bool shownUngrouped: {
                var _r = rootPanel.revision;
                return layoutObj ? (layoutObj.showUngrouped !== false) : true;
            }
            readonly property bool isVisibleInBar: {
                var _r = rootPanel.revision;
                return layoutObj ? !!layoutObj.visible : true;
            }

            width: parent ? parent.width : 0
            implicitHeight: layoutAssignCol.implicitHeight + 16
            height: implicitHeight
            color: "#141a21"
            radius: 8
            border.color: assignedGroups.length > 0 ? "#354c5e" : "#2a3540"
            border.width: 1

            ColumnLayout {
                id: layoutAssignCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 8
                spacing: 6

                // Row 1: localized type badge + layout name + Visible toggle
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        implicitWidth: rowKindTxt.implicitWidth + 10
                        implicitHeight: 18
                        radius: 6
                        color: layoutAssignCard.itemKind === "nvr" ? "#2e2214" : (layoutAssignCard.itemKind === "preset" ? "#112b2a" : "#1c242c")
                        border.color: layoutAssignCard.itemKind === "nvr" ? "#ff7a00" : (layoutAssignCard.itemKind === "preset" ? "#00f5d4" : "#4f738e")
                        border.width: 1
                        Text {
                            id: rowKindTxt
                            anchors.centerIn: parent
                            text: rootPanel.kindBadgeText(layoutAssignCard.itemKind)
                            color: layoutAssignCard.itemKind === "nvr" ? "#ffbe80" : (layoutAssignCard.itemKind === "preset" ? "#00f5d4" : "#b8c7d4")
                            font.pixelSize: 9
                            font.bold: true
                        }
                    }

                    Text {
                        text: layoutAssignCard.itemLabel
                        color: "white"
                        font.bold: true
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    CheckBox {
                        text: qsTr("LNG_00278")
                        checked: layoutAssignCard.isVisibleInBar
                        palette.highlight: "#00f5d4"
                        onToggled: {
                            if (layoutAssignCard.layoutObj) {
                                layoutAssignCard.layoutObj.visible = checked;
                                rootPanel.bumpRevision();
                                if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.rebuildTopBarEntries) {
                                    Qt.callLater(rootWindow.rebuildTopBarEntries);
                                }
                                if (!checked && typeof rootWindow !== "undefined" && rootWindow && rootWindow.ensureActiveLayoutIsVisible) {
                                    rootWindow.ensureActiveLayoutIsVisible();
                                }
                            }
                        }
                    }
                }

                // Row 2: Explicit "Assigned to groups:" display
                Flow {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        height: 20
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("LNG_00614")
                        color: "#8898a6"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Repeater {
                        model: layoutAssignCard.assignedGroups
                        delegate: Rectangle {
                            implicitWidth: assignedGrpTxt.implicitWidth + 14
                            height: 20
                            radius: 6
                            color: "#1c2d3b"
                            border.color: "#ff7a00"
                            border.width: 1
                            Text {
                                id: assignedGrpTxt
                                anchors.centerIn: parent
                                text: modelData
                                color: "#ffbe80"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }
                    }

                    Rectangle {
                        visible: layoutAssignCard.shownUngrouped
                        implicitWidth: assignedUngTxt.implicitWidth + 14
                        height: 20
                        radius: 6
                        color: "#15232b"
                        border.color: "#4f738e"
                        border.width: 1
                        Text {
                            id: assignedUngTxt
                            anchors.centerIn: parent
                            text: qsTr("LNG_00604")
                            color: "#b8c7d4"
                            font.pixelSize: 10
                        }
                    }

                    Text {
                        visible: layoutAssignCard.assignedGroups.length === 0 && !layoutAssignCard.shownUngrouped
                        height: 20
                        verticalAlignment: Text.AlignVCenter
                        text: "—"
                        color: "#6c7f90"
                        font.pixelSize: 10
                    }
                }

                // Row 3: Explicit "Assign to groups:" controls (multi-select groups + show ungrouped toggle)
                Flow {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        height: 24
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("LNG_00615")
                        color: "#8898a6"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Repeater {
                        model: rootPanel.allGroupNames
                        delegate: Button {
                            id: assignBtn
                            property bool isAssigned: layoutAssignCard.assignedGroups.indexOf(modelData) !== -1
                            text: (isAssigned ? "✓ " : "+ ") + modelData
                            height: 24
                            topPadding: 0
                            bottomPadding: 0
                            leftPadding: 10
                            rightPadding: 10

                            contentItem: Text {
                                text: assignBtn.text
                                font.pixelSize: 10
                                font.bold: assignBtn.isAssigned
                                color: assignBtn.isAssigned ? "#0f151b" : "#c7d4df"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                radius: 6
                                color: assignBtn.isAssigned ? "#00f5d4" : (assignBtn.hovered ? "#2a3846" : "#1c242c")
                                border.color: assignBtn.isAssigned ? "#00f5d4" : "#354c5e"
                                border.width: 1
                            }

                            onClicked: rootPanel.toggleLayoutInGroup(layoutAssignCard.layoutIdx, modelData)
                        }
                    }

                    Button {
                        id: ungroupedToggleBtn
                        property bool isUngroupedOn: layoutAssignCard.shownUngrouped
                        text: (isUngroupedOn ? "✓ " : "+ ") + qsTr("LNG_00617")
                        height: 24
                        topPadding: 0
                        bottomPadding: 0
                        leftPadding: 10
                        rightPadding: 10

                        contentItem: Text {
                            text: ungroupedToggleBtn.text
                            font.pixelSize: 10
                            font.bold: ungroupedToggleBtn.isUngroupedOn
                            color: ungroupedToggleBtn.isUngroupedOn ? "#0f151b" : "#b8c7d4"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            radius: 6
                            color: ungroupedToggleBtn.isUngroupedOn ? "#6c8ea8" : (ungroupedToggleBtn.hovered ? "#2a3846" : "#151d24")
                            border.color: ungroupedToggleBtn.isUngroupedOn ? "#92b4ce" : "#354c5e"
                            border.width: 1
                        }

                        onClicked: rootPanel.toggleLayoutShowUngrouped(layoutAssignCard.layoutIdx)
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: allLayoutsCol
        Layout.fillWidth: true
        spacing: 8
        visible: (typeof layoutsCollectionModel !== "undefined" && layoutsCollectionModel && layoutsCollectionModel.count > 0)

        Repeater {
            model: rootPanel.visibleLayoutIndices
            delegate: Loader {
                readonly property int targetLayoutIndex: modelData
                Layout.fillWidth: true
                Layout.preferredHeight: item ? item.implicitHeight : 0
                sourceComponent: layoutAssignCardComponent
            }
        }

        // Collapsible subsection for hidden layouts (visible: false), collapsed by default
        Frame {
            Layout.fillWidth: true
            Layout.topMargin: 4
            padding: 10
            background: Rectangle {
                color: "#11161c"
                border.color: rootPanel.hiddenLayoutsExpanded ? "#4f738e" : "#25303b"
                border.width: 1
                radius: 8
            }

            ColumnLayout {
                width: parent.width
                spacing: 8

                MouseArea {
                    id: hiddenHeaderMouse
                    Layout.fillWidth: true
                    implicitHeight: hiddenHeaderRow.implicitHeight
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: rootPanel.hiddenLayoutsExpanded = !rootPanel.hiddenLayoutsExpanded

                    RowLayout {
                        id: hiddenHeaderRow
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 8

                        Text {
                            text: qsTr("LNG_00639")
                            color: rootPanel.hiddenLayoutsExpanded ? "#00f5d4" : (hiddenHeaderMouse.containsMouse ? "white" : "#b8c7d4")
                            font.bold: true
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            implicitWidth: hiddenCountRow.implicitWidth + 14
                            implicitHeight: 24
                            radius: 6
                            color: rootPanel.hiddenLayoutsExpanded ? "#162d36" : (hiddenHeaderMouse.containsMouse ? "#25323e" : "#1c242c")
                            border.color: rootPanel.hiddenLayoutsExpanded ? "#00f5d4" : (hiddenHeaderMouse.containsMouse ? "#4f738e" : "#2a3540")
                            border.width: 1

                            Row {
                                id: hiddenCountRow
                                anchors.centerIn: parent
                                spacing: 5
                                Text {
                                    text: String(rootPanel.hiddenLayoutIndices.length)
                                    color: rootPanel.hiddenLayoutsExpanded ? "#00f5d4" : "#b8c7d4"
                                    font.pixelSize: 10
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: rootPanel.hiddenLayoutsExpanded ? "▴" : "▾"
                                    color: rootPanel.hiddenLayoutsExpanded ? "#00f5d4" : "#8898a6"
                                    font.pixelSize: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: rootPanel.hiddenLayoutsExpanded && rootPanel.hiddenLayoutIndices.length === 0
                    text: qsTr("LNG_00640")
                    color: "#6c7f90"
                    font.pixelSize: 10
                    font.italic: true
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    visible: rootPanel.hiddenLayoutsExpanded && rootPanel.hiddenLayoutIndices.length > 0

                    Repeater {
                        model: rootPanel.hiddenLayoutsExpanded ? rootPanel.hiddenLayoutIndices : []
                        delegate: Loader {
                            readonly property int targetLayoutIndex: modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: item ? item.implicitHeight : 0
                            sourceComponent: layoutAssignCardComponent
                        }
                    }
                }
            }
        }
    }

    ConfirmDialog {
        id: deleteGroupConfirmDialog
        property string targetGroupName: ""
        title: qsTr("LNG_00605")
        iconSource: "qrc:/images/icon-warning.svg"
        message: qsTr("LNG_00626").arg(targetGroupName)

        onAccepted: {
            if (targetGroupName !== "") {
                rootPanel.ungroupAll(targetGroupName);
                targetGroupName = "";
            }
        }
        onRejected: targetGroupName = ""
    }
}
