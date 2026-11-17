import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: control
    property int layoutIndex: -1
    property bool isActive: false
    property bool showNvrIcon: false
    property int buttonHeight: 30
    property int horizontalPad: 12

    implicitHeight: buttonHeight
    height: buttonHeight
    topPadding: 0
    bottomPadding: 0
    leftPadding: horizontalPad
    rightPadding: horizontalPad

    readonly property string iconColorStr: control.isActive ? "%23121214" : (control.hovered ? "%23ffffff" : "%238898a6")
    readonly property string iconLedStr: control.isActive ? "%23121214" : "%2300f5d4"

    contentItem: Row {
        spacing: 6
        Image {
            visible: control.showNvrIcon
            width: 14
            height: 14
            sourceSize.width: 14
            sourceSize.height: 14
            anchors.verticalCenter: parent.verticalCenter
            source: "data:image/svg+xml;utf8," +
                    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'>" +
                    "<rect x='2' y='6' width='20' height='11' rx='2' stroke='" + control.iconColorStr + "' stroke-width='2'/>" +
                    "<line x1='2' y1='12.5' x2='22' y2='12.5' stroke='" + control.iconColorStr + "' stroke-width='1.3'/>" +
                    "<circle cx='5.5' cy='9.2' r='1.2' fill='" + control.iconLedStr + "'/>" +
                    "<circle cx='8.5' cy='9.2' r='1.0' fill='" + control.iconColorStr + "'/>" +
                    "<line x1='12' y1='9.2' x2='19' y2='9.2' stroke='" + control.iconColorStr + "' stroke-width='1.7' stroke-linecap='round'/>" +
                    "<line x1='5' y1='14.8' x2='9' y2='14.8' stroke='" + control.iconColorStr + "' stroke-width='1.4' stroke-linecap='round'/>" +
                    "<line x1='15' y1='14.8' x2='19' y2='14.8' stroke='" + control.iconColorStr + "' stroke-width='1.4' stroke-linecap='round'/>" +
                    "<line x1='5.5' y1='17' x2='5.5' y2='19.2' stroke='" + control.iconColorStr + "' stroke-width='2' stroke-linecap='round'/>" +
                    "<line x1='18.5' y1='17' x2='18.5' y2='19.2' stroke='" + control.iconColorStr + "' stroke-width='2' stroke-linecap='round'/>" +
                    "</svg>"
        }
        Text {
            text: control.text.toUpperCase()
            font.bold: true
            font.pixelSize: 10
            color: control.isActive ? "#121214" : (control.hovered ? "#ffffff" : "#8898a6")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    background: Rectangle {
        color: control.isActive ? "#00f5d4" : (control.pressed ? "#cc121214" : (control.hovered ? "#3a4550" : "#1c242c"))
        radius: control.buttonHeight / 2
        border.color: control.isActive ? "#00f5d4" : (control.hovered ? "#8898a6" : "#2a3540")
        border.width: 1
    }
}
