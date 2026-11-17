import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import CCTV_Viewer.Themes 1.0

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: rowLayout.implicitHeight

    property int globalIndex: -1
    property string category: "regular"
    property var layout: null
    property bool isCurrent: false
    property string placeholderText: ""
    property bool showDelete: true
    property string activateTooltip: ""
    property string deleteTooltip: ""
    property bool reorderEnabled: false
    property var dragState: null
    property Item dragParent: null
    property Item dragProxy: null
    property Item rowsContainer: null

    signal activateRequested()
    signal deleteRequested()

    readonly property bool isBeingDragged: dragState && dragState.sourceGlobalIndex === root.globalIndex && dragState.category === root.category
    readonly property bool isDropTarget: dragState && dragState.category === root.category && dragState.targetGlobalIndex === root.globalIndex && dragState.sourceGlobalIndex !== root.globalIndex
    readonly property bool dropAbove: isDropTarget && dragState.sourceGlobalIndex > root.globalIndex
    readonly property bool dropBelow: isDropTarget && dragState.sourceGlobalIndex < root.globalIndex

    opacity: isBeingDragged ? 0.35 : 1.0

    // Highlight background when hovered as a drop target
    Rectangle {
        anchors.fill: parent
        radius: 6
        color: root.isDropTarget ? "#14242c" : "transparent"
    }

    // Drop indicator line (top or bottom edge)
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: root.dropAbove ? parent.top : undefined
        anchors.bottom: root.dropBelow ? parent.bottom : undefined
        height: 2
        radius: 1
        color: "#00f5d4"
        visible: root.isDropTarget
        z: 5
    }

    RowLayout {
        id: rowLayout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        // Active view indicator
        Rectangle {
            width: 4
            height: 24
            radius: 2
            color: root.isCurrent ? "#00f5d4" : "transparent"
        }

        // Drag grip handle (only when reorderEnabled)
        Item {
            id: gripHandle
            visible: root.reorderEnabled
            width: visible ? 20 : 0
            height: 28

            Image {
                anchors.centerIn: parent
                width: 14
                height: 14
                sourceSize.width: 14
                sourceSize.height: 14
                source: {
                    var c = (dragMouseArea.containsMouse || root.isBeingDragged) ? "%2300f5d4" : "%236b7c8a";
                    return "data:image/svg+xml;utf8," +
                           "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='" + c + "'>" +
                           "<circle cx='9' cy='5' r='1.8'/><circle cx='15' cy='5' r='1.8'/>" +
                           "<circle cx='9' cy='12' r='1.8'/><circle cx='15' cy='12' r='1.8'/>" +
                           "<circle cx='9' cy='19' r='1.8'/><circle cx='15' cy='19' r='1.8'/>" +
                           "</svg>";
                }
            }

            MouseArea {
                id: dragMouseArea
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                function updateDropTarget(pointerYInParent) {
                    if (!root.rowsContainer || !root.dragParent) return;
                    var childrenList = root.rowsContainer.children;
                    var bestIdx = root.dragState.sourceGlobalIndex;
                    var bestDist = 1e9;
                    for (var i = 0; i < childrenList.length; ++i) {
                        var ch = childrenList[i];
                        if (!ch || !ch.visible || typeof ch.globalIndex !== "number" || ch.category !== root.category) {
                            continue;
                        }
                        var topY = ch.mapToItem(root.dragParent, 0, 0).y;
                        var bottomY = topY + ch.height;
                        if (pointerYInParent >= topY - 4 && pointerYInParent <= bottomY + 4) {
                            bestIdx = ch.globalIndex;
                            break;
                        }
                        var midY = (topY + bottomY) * 0.5;
                        var dist = Math.abs(pointerYInParent - midY);
                        if (dist < bestDist) {
                            bestDist = dist;
                            bestIdx = ch.globalIndex;
                        }
                    }
                    root.dragState.targetGlobalIndex = bestIdx;
                }

                onPressed: {
                    if (!root.dragState || !root.dragParent || !root.dragProxy) return;
                    var pt = gripHandle.mapToItem(root.dragParent, 0, 0);
                    root.dragProxy.x = pt.x;
                    root.dragProxy.y = pt.y;
                    root.dragState.sourceGlobalIndex = root.globalIndex;
                    root.dragState.targetGlobalIndex = root.globalIndex;
                    root.dragState.category = root.category;
                    root.dragState.previewText = (nameField.text && nameField.text.trim() !== "") ? nameField.text : root.placeholderText;
                }
                onPositionChanged: {
                    if (!pressed || !root.dragState || root.dragState.sourceGlobalIndex === -1 || !root.dragParent || !root.dragProxy) return;
                    var p = dragMouseArea.mapToItem(root.dragParent, mouse.x, mouse.y);
                    var maxY = Math.max(0, root.dragParent.height - root.dragProxy.height);
                    root.dragProxy.y = Math.max(0, Math.min(maxY, p.y - root.dragProxy.height * 0.5));
                    updateDropTarget(p.y);
                }
                onReleased: {
                    if (!root.dragState) return;
                    var fromIdx = root.dragState.sourceGlobalIndex;
                    var toIdx = root.dragState.targetGlobalIndex;
                    var sameCat = (root.dragState.category === root.category);
                    root.dragState.reset();
                    if (sameCat && fromIdx !== -1 && toIdx !== -1 && fromIdx !== toIdx) {
                        if (typeof rootWindow !== "undefined" && rootWindow && rootWindow.moveLayout) {
                            rootWindow.moveLayout(fromIdx, toIdx);
                        } else {
                            layoutsCollectionModel.move(fromIdx, toIdx);
                        }
                    }
                }
                onCanceled: {
                    if (root.dragState) {
                        root.dragState.reset();
                    }
                }

                ToolTip.delay: Compact.toolTipDelay
                ToolTip.timeout: Compact.toolTipTimeout
                ToolTip.visible: dragMouseArea.containsMouse && (!root.dragState || root.dragState.sourceGlobalIndex === -1)
                ToolTip.text: qsTr("LNG_00631")
            }
        }

        // Editable view name field
        TextField {
            id: nameField
            text: (root.layout && root.layout.name) ? root.layout.name : ""
            placeholderText: root.placeholderText
            selectByMouse: true
            Layout.fillWidth: true
            color: "white"
            background: Rectangle {
                color: "#0f151b"
                radius: 4
                border.color: nameField.activeFocus ? "#ff7a00" : "#2a3540"
            }
            onEditingFinished: {
                if (root.layout) {
                    root.layout.name = text;
                }
            }
        }

        // Group badge(s) (if assigned to one or more groups)
        Rectangle {
            readonly property string grpSummary: {
                if (!root.layout || !root.layout.groups || root.layout.groups.length === 0) return "";
                var parts = [];
                for (var i = 0; i < root.layout.groups.length; ++i) {
                    var g = String(root.layout.groups[i] || "").trim();
                    if (g !== "") parts.push(g);
                }
                return parts.join(", ");
            }
            visible: grpSummary !== ""
            implicitWidth: Math.min(180, rowGroupTxt.implicitWidth + 12)
            implicitHeight: 20
            radius: 6
            color: "#1c2d3b"
            border.color: "#ff7a00"
            border.width: 1
            Text {
                id: rowGroupTxt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                text: parent.grpSummary
                color: "#ffbe80"
                font.pixelSize: 9
                font.bold: true
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Visible Checkbox
        CheckBox {
            text: qsTr("LNG_00278")
            checked: root.layout ? root.layout.visible : true
            onCheckedChanged: {
                if (root.layout) {
                    root.layout.visible = checked;
                }
            }
            palette.highlight: "#00f5d4"
        }

        // Activate button
        Button {
            id: activateBtn
            implicitWidth: 28
            implicitHeight: 28
            highlighted: root.isCurrent
            onClicked: root.activateRequested()
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
                radius: 6
                border.color: activateBtn.highlighted ? "#ff9e00" : (activateBtn.hovered ? "#8898a6" : "#2a3540")
                border.width: 1
            }
            ToolTip.delay: Compact.toolTipDelay
            ToolTip.timeout: Compact.toolTipTimeout
            ToolTip.visible: activateBtn.hovered
            ToolTip.text: root.activateTooltip
        }

        // Delete button
        Button {
            id: delBtn
            implicitWidth: 28
            implicitHeight: 28
            visible: root.showDelete
            contentItem: Image {
                anchors.centerIn: parent
                width: 14
                height: 14
                source: {
                    var colorStr = delBtn.hovered ? "%23ff4d4d" : "%238898a6";
                    return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path><line x1='10' y1='11' x2='10' y2='17'></line><line x1='14' y1='11' x2='14' y2='17'></line></svg>";
                }
            }
            background: Rectangle {
                color: delBtn.pressed ? "#40ff0000" : (delBtn.hovered ? "#20ff0000" : "transparent")
                radius: 6
                border.color: delBtn.hovered ? "#ff4d4d" : "#2a3540"
                border.width: 1
            }
            onClicked: root.deleteRequested()
            ToolTip.delay: Compact.toolTipDelay
            ToolTip.timeout: Compact.toolTipTimeout
            ToolTip.visible: delBtn.hovered
            ToolTip.text: root.deleteTooltip
        }
    }
}
