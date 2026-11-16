import QtQuick 2.12
import QtQuick.Controls 2.12

ScrollBar {
    id: control

    // Set scrollView when attached to a QtQuick.Controls ScrollView (which does
    // not auto-position overridden ScrollBars the way Flickable/ListView does).
    property Item scrollView: null

    width: 12
    padding: 2
    z: 10
    policy: ScrollBar.AsNeeded
    visible: policy === ScrollBar.AlwaysOn || (policy !== ScrollBar.AlwaysOff && size > 0 && size < 1.0)

    Component.onCompleted: {
        if (scrollView) {
            x = Qt.binding(function() { return scrollView.width - width - 6; });
            y = Qt.binding(function() { return scrollView.topPadding + 4; });
            height = Qt.binding(function() { return Math.max(0, scrollView.availableHeight - 8); });
        }
    }

    contentItem: Rectangle {
        implicitWidth: 8
        radius: 4
        color: control.pressed ? "#00f5d4" : (control.hovered ? "#33f7dc" : "#5a6e7f")
    }

    background: Rectangle {
        implicitWidth: 12
        radius: 6
        color: "#0f151b"
        border.color: "#2a3540"
        border.width: 1
    }
}
