import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: control
    property bool isPrimary: false
    property bool isCeladon: false
    property bool isSmall: false
    property bool isMini: false
    property bool isTransparent: false
    property string iconSource: ""
    
    implicitHeight: isMini ? 24 : (isSmall ? 30 : 32)
    implicitWidth: text === "" ? implicitHeight : (leftPadding + contentItem.implicitWidth + rightPadding)
    
    // Layout properties to maintain size in layout containers
    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.fillWidth: false
    Layout.fillHeight: false
    
    // Add extra padding for pill shape if it contains both text and icon
    leftPadding: text !== "" ? (iconSource !== "" ? (isMini ? 8 : (isSmall ? 12 : 14)) : (isMini ? 10 : 14)) : 0
    rightPadding: text !== "" ? (isMini ? 10 : 14) : 0
    topPadding: text !== "" ? (isMini ? 4 : (isSmall ? 6 : 0)) : 0
    bottomPadding: text !== "" ? (isMini ? 4 : (isSmall ? 6 : 0)) : 0

    contentItem: Item {
        implicitWidth: contentRow.implicitWidth
        implicitHeight: contentRow.implicitHeight
        
        Row {
            id: contentRow
            spacing: isMini ? 2 : 4
            anchors.centerIn: parent
            
            Image {
                source: control.iconSource
                visible: control.iconSource !== ""
                width: control.text !== "" ? (control.isMini ? 10 : (control.isSmall ? 12 : 16)) : (control.isMini ? 16 : (control.isSmall ? 22 : 24))
                height: control.text !== "" ? (control.isMini ? 10 : (control.isSmall ? 12 : 16)) : (control.isMini ? 16 : (control.isSmall ? 22 : 24))
                sourceSize: Qt.size(width, height)
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: control.text
                visible: control.text !== ""
                font.bold: true
                font.pixelSize: control.isMini ? 9 : (control.isSmall ? 10 : 13)
                color: control.isCeladon ? "#121214" : "white"
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    background: Rectangle {
        color: control.isTransparent
            ? (control.pressed ? "rgba(255, 255, 255, 0.15)" : (control.hovered ? "rgba(255, 255, 255, 0.1)" : "transparent"))
            : (control.pressed
                ? (control.isCeladon ? "#00c2ad" : (control.isPrimary ? "#d66600" : "#cc121214"))
                : (control.hovered
                    ? (control.isCeladon ? "#33f7dd" : (control.isPrimary ? "#ff8c00" : "#3a4550"))
                    : (control.isCeladon ? "#00f5d4" : (control.isPrimary ? "#ff7a00" : "#1c242c"))))
        radius: height / 2
        border.color: control.isTransparent
            ? (control.hovered ? "rgba(255, 255, 255, 0.35)" : "rgba(255, 255, 255, 0.12)")
            : (control.hovered
                ? (control.isCeladon ? "#33f7dd" : (control.isPrimary ? "#ff9e00" : "#8898a6"))
                : (control.isCeladon ? "#00f5d4" : (control.isPrimary ? "#ff7a00" : "#2a3540")))
        border.width: 1
    }
}
