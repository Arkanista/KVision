import QtQuick 2.12
import QtQuick.Controls 2.12
import CCTV_Viewer.Themes 1.0

Item {
    id: root
    property var entry: null
    property int currentLayoutIndex: -1
    property real maxFlowWidth: 600
    property bool hasGroupedEntries: false
    property bool collapsed: false
    signal activateLayout(int layoutIndex)
    signal toggleCollapse(string groupName)
    signal togglePin(string groupName, bool pinOpen)
    signal targetSizeChanged()

    readonly property bool isGroup: !!(entry && entry.isGroup)
    readonly property bool isPinnedOpen: isGroup && entry ? !entry.collapsedByDefault : true
    readonly property string groupName: (isGroup && entry && entry.groupName) ? String(entry.groupName) : ""
    readonly property var groupItems: (isGroup && entry && entry.items) ? entry.items : []

    function pinIconSource(colorStr, filled) {
        var fillAttr = filled ? colorStr : "none";
        return "data:image/svg+xml;utf8," +
               "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='" + fillAttr + "' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'>" +
               "<line x1='12' x2='12' y1='17' y2='22'></line>" +
               "<path d='M5 17h14v-1.76a2 2 0 0 0-.44-1.24l-2.78-3.56A2 2 0 0 1 15 9.2V5a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4.2a2 2 0 0 1-.78 1.24L5.44 14a2 2 0 0 0-.44 1.24Z'></path>" +
               "</svg>";
    }

    function groupIconSource(sCol, aCol) {
        return "data:image/svg+xml;utf8," +
               "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'>" +
               "<rect x='5.5' y='2' width='13' height='6.5' rx='1.5' stroke='" + sCol + "' stroke-width='2'/>" +
               "<circle cx='8.5' cy='5.25' r='1.1' fill='" + aCol + "'/>" +
               "<line x1='11.5' y1='5.25' x2='15.5' y2='5.25' stroke='" + sCol + "' stroke-width='1.6' stroke-linecap='round'/>" +
               "<line x1='12' y1='8.5' x2='12' y2='12' stroke='" + sCol + "' stroke-width='1.8'/>" +
               "<line x1='6' y1='12' x2='18' y2='12' stroke='" + sCol + "' stroke-width='1.8' stroke-linecap='round'/>" +
               "<line x1='6' y1='12' x2='6' y2='15' stroke='" + sCol + "' stroke-width='1.8'/>" +
               "<line x1='18' y1='12' x2='18' y2='15' stroke='" + sCol + "' stroke-width='1.8'/>" +
               "<rect x='1.5' y='15' width='9' height='6.5' rx='1.5' stroke='" + sCol + "' stroke-width='2'/>" +
               "<circle cx='4.5' cy='18.25' r='1.1' fill='" + aCol + "'/>" +
               "<rect x='13.5' y='15' width='9' height='6.5' rx='1.5' stroke='" + sCol + "' stroke-width='2'/>" +
               "<circle cx='16.5' cy='18.25' r='1.1' fill='" + aCol + "'/>" +
               "</svg>";
    }

    property bool _readyForAnim: false
    property real expandProgress: (isGroup && collapsed) ? 0.0 : 1.0

    Behavior on expandProgress {
        enabled: root._readyForAnim
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    readonly property real collapsedW: Math.max(30, Math.ceil(collapsedPill.implicitWidth))
    readonly property real collapsedH: 30
    readonly property real expandedW: Math.max(titleRow.width + 28, groupBoxFrame.flowMeasuredWidth + 16)
    readonly property real expandedH: titleRow.height + 3 + groupBoxFrame.flowMeasuredHeight + 6

    readonly property real targetWidth: isGroup ? (collapsed ? collapsedW : expandedW) : standaloneBtn.implicitWidth
    readonly property real targetHeight: isGroup ? (collapsed ? collapsedH : expandedH) : standaloneBtn.implicitHeight

    readonly property real animW: collapsedW + (expandedW - collapsedW) * expandProgress
    readonly property real animH: collapsedH + (expandedH - collapsedH) * expandProgress

    implicitWidth: isGroup ? animW : standaloneBtn.implicitWidth
    implicitHeight: isGroup ? animH : standaloneBtn.implicitHeight
    width: implicitWidth
    height: implicitHeight
    clip: isGroup && expandProgress > 0.001 && expandProgress < 0.999

    onTargetWidthChanged: targetSizeChanged()
    onTargetHeightChanged: targetSizeChanged()

    Component.onCompleted: {
        Qt.callLater(function() {
            root._readyForAnim = true;
        });
    }

    TopBarViewButton {
        id: standaloneBtn
        visible: !root.isGroup
        layoutIndex: (!root.isGroup && root.entry) ? root.entry.layoutIndex : -1
        showNvrIcon: (!root.isGroup && root.entry) ? !!root.entry.showNvrIcon : false
        badgeColor: (!root.isGroup && root.entry && root.entry.badgeColor) ? String(root.entry.badgeColor) : ""
        isSearchHighlighted: (typeof rootWindow !== "undefined" && rootWindow && rootWindow.highlightedLayoutIndices) ? (rootWindow.highlightedLayoutIndices.indexOf(layoutIndex) !== -1) : false
        isActive: root.currentLayoutIndex === layoutIndex
        text: (!root.isGroup && root.entry) ? root.entry.label : ""
        buttonHeight: 30
        horizontalPad: 12
        onClicked: root.activateLayout(layoutIndex)
    }

    Button {
        id: collapsedPill
        visible: root.isGroup && opacity > 0.01
        enabled: root.isGroup && root.collapsed
        opacity: root.isGroup ? Math.max(0.0, Math.min(1.0, 1.0 - root.expandProgress * 2.2)) : 0.0

        implicitHeight: 30
        height: 30
        topPadding: 0
        bottomPadding: 0
        leftPadding: 12
        rightPadding: 12

        contentItem: Row {
            spacing: 6
            Image {
                width: 14
                height: 14
                sourceSize.width: 14
                sourceSize.height: 14
                anchors.verticalCenter: parent.verticalCenter
                source: root.groupIconSource(groupBoxFrame.groupHasActive ? "%2300f5d4" : (collapsedPill.hovered ? "%23ffffff" : "%239db0c0"),
                                             groupBoxFrame.groupHasActive ? "%2300f5d4" : "%23ff7a00")
            }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0
                Text {
                    text: root.groupName.toUpperCase()
                    font.bold: true
                    font.pixelSize: groupBoxFrame.activeGroupItemLabel !== "" ? 9 : 10
                    color: groupBoxFrame.groupHasActive ? "#00f5d4" : (collapsedPill.hovered ? "#ffffff" : "#e2ecf5")
                }
                Text {
                    visible: groupBoxFrame.activeGroupItemLabel !== ""
                    text: groupBoxFrame.activeGroupItemLabel
                    font.pixelSize: 8
                    font.bold: true
                    color: collapsedPill.hovered ? "#ffffff" : "#9efcf0"
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    width: Math.min(implicitWidth, 160)
                }
            }
        }

        readonly property bool groupHasSearchHighlight: {
            if (!root.isGroup || typeof rootWindow === "undefined" || !rootWindow || !rootWindow.highlightedLayoutIndices || rootWindow.highlightedLayoutIndices.length === 0) {
                return false;
            }
            for (var i = 0; i < root.groupItems.length; ++i) {
                if (rootWindow.highlightedLayoutIndices.indexOf(root.groupItems[i].layoutIndex) !== -1) {
                    return true;
                }
            }
            return false;
        }

        background: Rectangle {
            radius: 15
            color: groupBoxFrame.groupHasActive
                   ? (collapsedPill.hovered ? "#1b3a44" : "#152d36")
                   : (collapsedPill.hovered ? "#2a3846" : "#172028")
            border.color: collapsedPill.groupHasSearchHighlight ? "#00f5d4" : (groupBoxFrame.groupHasActive ? "#00f5d4" : (collapsedPill.hovered ? "#ff9e00" : "#5e7f99"))
            border.width: collapsedPill.groupHasSearchHighlight ? 2 : 1

            Rectangle {
                visible: collapsedPill.groupHasSearchHighlight
                anchors.fill: parent
                anchors.margins: -4
                radius: 19
                color: "transparent"
                border.color: "#00f5d4"
                border.width: 2

                SequentialAnimation on opacity {
                    running: collapsedPill.groupHasSearchHighlight
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.95; to: 0.20; duration: 420; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 0.20; to: 0.95; duration: 420; easing.type: Easing.InOutQuad }
                }
            }
        }

        onClicked: {
            if (root.groupName !== "") {
                root.toggleCollapse(root.groupName);
            }
        }

        ToolTip.delay: Compact.toolTipDelay
        ToolTip.timeout: Compact.toolTipTimeout
        ToolTip.visible: enabled && hovered
        ToolTip.text: qsTr("LNG_00625")
    }

    Item {
        id: groupBoxFrame
        visible: root.isGroup && root.expandProgress > 0.01
        opacity: root.isGroup ? Math.max(0.0, Math.min(1.0, (root.expandProgress - 0.1) / 0.9)) : 0.0
        width: Math.max(24, root.animW)
        height: Math.max(24, root.animH)

        readonly property int activeGroupItemIdx: {
            for (var i = 0; i < root.groupItems.length; ++i) {
                if (root.groupItems[i].layoutIndex === root.currentLayoutIndex) {
                    return i;
                }
            }
            return -1;
        }
        readonly property string activeGroupItemLabel: (activeGroupItemIdx >= 0 && root.groupItems[activeGroupItemIdx].label)
                                                       ? String(root.groupItems[activeGroupItemIdx].label) : ""
        readonly property bool groupHasActive: activeGroupItemIdx >= 0
        readonly property string strokeColor: groupHasActive ? "#00f5d4" : ((titleClickArea.containsMouse || pinClickArea.containsMouse) ? "#9fc2db" : "#6c8ea8")
        readonly property real maxInnerWidth: Math.max(120, root.maxFlowWidth - 18)
        readonly property real borderTopY: Math.max(7, titleRow.height * 0.5)

        property real flowMeasuredWidth: 40
        property real flowMeasuredHeight: 30

        onMaxInnerWidthChanged: Qt.callLater(relayoutButtons)
        onStrokeColorChanged: borderCanvas.requestPaint()

        function relayoutButtons() {
            var btns = [];
            for (var i = 0; i < btnRepeater.count; ++i) {
                var b = btnRepeater.itemAt(i);
                if (b && b.implicitWidth > 0 && b.implicitHeight > 0) {
                    btns.push(b);
                }
            }
            if (btns.length === 0) {
                flowMeasuredWidth = 40;
                flowMeasuredHeight = 30;
                borderCanvas.requestPaint();
                return;
            }
            var hGap = 4;
            var vGap = 4;
            var maxW = maxInnerWidth;
            var x = 0;
            var y = 0;
            var rowH = 0;
            var usedMaxW = 0;

            for (var k = 0; k < btns.length; ++k) {
                var btn = btns[k];
                var bw = Math.max(btn.width, btn.implicitWidth);
                var bh = Math.max(btn.height, btn.implicitHeight);
                if (x > 0 && (x + bw) > maxW) {
                    y += rowH + vGap;
                    x = 0;
                    rowH = 0;
                }
                btn.x = x;
                btn.y = y;
                if (x + bw > usedMaxW) {
                    usedMaxW = x + bw;
                }
                x += bw + hGap;
                if (bh > rowH) {
                    rowH = bh;
                }
            }
            flowMeasuredWidth = Math.max(1, Math.ceil(usedMaxW));
            flowMeasuredHeight = Math.max(30, Math.ceil(y + rowH));
            borderCanvas.requestPaint();
        }

        // Transparent border with real gap behind inline title text
        Canvas {
            id: borderCanvas
            anchors.fill: parent
            z: 0

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                var w = width;
                var h = height;
                if (w < 16 || h < 16) return;

                var r = 8;
                var leftX = 0.5;
                var rightX = w - 0.5;
                var topY = Math.floor(groupBoxFrame.borderTopY) + 0.5;
                var bottomY = h - 0.5;
                var safeR = Math.min(r, (bottomY - topY) * 0.45, (rightX - leftX) * 0.45);
                var gapStart = Math.max(leftX + safeR + 2, titleRow.x - 5);
                var gapEnd = Math.min(rightX - safeR - 2, titleRow.x + titleRow.width + 5);

                ctx.strokeStyle = groupBoxFrame.strokeColor;
                ctx.lineWidth = 1;
                ctx.beginPath();
                if (gapEnd > gapStart) {
                    ctx.moveTo(gapStart, topY);
                    ctx.lineTo(leftX + safeR, topY);
                    ctx.arcTo(leftX, topY, leftX, topY + safeR, safeR);
                    ctx.lineTo(leftX, bottomY - safeR);
                    ctx.arcTo(leftX, bottomY, leftX + safeR, bottomY, safeR);
                    ctx.lineTo(rightX - safeR, bottomY);
                    ctx.arcTo(rightX, bottomY, rightX, bottomY - safeR, safeR);
                    ctx.lineTo(rightX, topY + safeR);
                    ctx.arcTo(rightX, topY, rightX - safeR, topY, safeR);
                    ctx.lineTo(gapEnd, topY);
                } else {
                    ctx.moveTo(leftX + safeR, topY);
                    ctx.lineTo(rightX - safeR, topY);
                    ctx.arcTo(rightX, topY, rightX, topY + safeR, safeR);
                    ctx.lineTo(rightX, bottomY - safeR);
                    ctx.arcTo(rightX, bottomY, rightX - safeR, bottomY, safeR);
                    ctx.lineTo(leftX + safeR, bottomY);
                    ctx.arcTo(leftX, bottomY, leftX, bottomY - safeR, safeR);
                    ctx.lineTo(leftX, topY + safeR);
                    ctx.arcTo(leftX, topY, leftX + safeR, topY, safeR);
                }
                ctx.stroke();
            }
        }

        // Inline title sitting directly in the top border gap (clickable to collapse)
        Row {
            id: titleRow
            x: 12
            y: 0
            spacing: 4
            height: Math.max(14, groupTitleText.implicitHeight)
            z: 2

            onXChanged: borderCanvas.requestPaint()
            onWidthChanged: borderCanvas.requestPaint()

            Image {
                width: 12
                height: 12
                sourceSize.width: 12
                sourceSize.height: 12
                anchors.verticalCenter: parent.verticalCenter
                source: root.groupIconSource(groupBoxFrame.groupHasActive ? "%2300f5d4" : (titleClickArea.containsMouse ? "%23ffffff" : "%239db0c0"),
                                             groupBoxFrame.groupHasActive ? "%2300f5d4" : "%23ff7a00")
            }

            Text {
                text: "▾"
                font.pixelSize: 10
                font.bold: true
                color: titleClickArea.containsMouse ? "#00f5d4" : "#9db0c0"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: groupTitleText
                text: root.groupName.toUpperCase()
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 0.6
                color: groupBoxFrame.groupHasActive ? "#00f5d4" : (titleClickArea.containsMouse ? "#ffffff" : "#e2ecf5")
                elide: Text.ElideRight
                width: Math.min(implicitWidth, Math.max(40, groupBoxFrame.maxInnerWidth - 44))
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: pinBtnWrap
                width: 14
                height: 14
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.centerIn: parent
                    width: 11
                    height: 11
                    sourceSize.width: 11
                    sourceSize.height: 11
                    rotation: root.isPinnedOpen ? 0 : -45

                    Behavior on rotation {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.InOutQuad
                        }
                    }

                    source: root.pinIconSource(
                                pinClickArea.containsMouse ? "%23ffffff" : (root.isPinnedOpen ? "%2300f5d4" : "%238898a6"),
                                root.isPinnedOpen)
                }
            }
        }

        MouseArea {
            id: titleClickArea
            x: titleRow.x - 4
            y: 0
            width: Math.max(0, titleRow.width - pinBtnWrap.width - titleRow.spacing) + 4
            height: titleRow.height + 2
            enabled: root.isGroup && !root.collapsed
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            z: 3
            onClicked: {
                if (root.groupName !== "") {
                    root.toggleCollapse(root.groupName);
                }
            }

            ToolTip.delay: Compact.toolTipDelay
            ToolTip.timeout: Compact.toolTipTimeout
            ToolTip.visible: enabled && containsMouse
            ToolTip.text: qsTr("LNG_00624")
        }

        MouseArea {
            id: pinClickArea
            x: titleRow.x + titleRow.width - pinBtnWrap.width - 2
            y: -2
            width: pinBtnWrap.width + 6
            height: titleRow.height + 6
            enabled: root.isGroup && !root.collapsed
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            z: 4
            onClicked: {
                if (root.groupName !== "") {
                    root.togglePin(root.groupName, !root.isPinnedOpen);
                }
            }

            ToolTip.delay: Compact.toolTipDelay
            ToolTip.timeout: Compact.toolTipTimeout
            ToolTip.visible: enabled && containsMouse
            ToolTip.text: root.isPinnedOpen ? qsTr("LNG_00634") : qsTr("LNG_00633")
        }

        Item {
            id: groupButtonsWrap
            x: 8
            y: titleRow.height + 3
            width: groupBoxFrame.flowMeasuredWidth
            height: groupBoxFrame.flowMeasuredHeight
            enabled: root.isGroup && !root.collapsed

            Repeater {
                id: btnRepeater
                model: root.groupItems
                onItemAdded: Qt.callLater(groupBoxFrame.relayoutButtons)
                onItemRemoved: Qt.callLater(groupBoxFrame.relayoutButtons)
                delegate: TopBarViewButton {
                    layoutIndex: modelData.layoutIndex
                    showNvrIcon: !!modelData.showNvrIcon
                    badgeColor: modelData.badgeColor ? String(modelData.badgeColor) : ""
                    isSearchHighlighted: (typeof rootWindow !== "undefined" && rootWindow && rootWindow.highlightedLayoutIndices) ? (rootWindow.highlightedLayoutIndices.indexOf(layoutIndex) !== -1) : false
                    isActive: root.currentLayoutIndex === layoutIndex
                    text: modelData.label
                    buttonHeight: 30
                    horizontalPad: 12
                    onWidthChanged: Qt.callLater(groupBoxFrame.relayoutButtons)
                    onHeightChanged: Qt.callLater(groupBoxFrame.relayoutButtons)
                    onClicked: root.activateLayout(layoutIndex)
                }
            }
        }

        Component.onCompleted: relayoutButtons()
    }
}
