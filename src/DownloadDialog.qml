import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import CCTV_Viewer.Hikvision 1.0
import CCTV_Viewer.Utils 1.0
import CCTV_Viewer.Core 1.0
import CCTV_Viewer.Themes 1.0
import Qt.labs.platform 1.1 as Platform


Popup {
    id: downloadDialog
    modal: true
    focus: true
    anchors.centerIn: parent
    width: 1200
    height: 550
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    signal downloadStarted()

    // Backwards compatibility properties
    property var recorderInfo
    property int channelId: 0
    property string recorderName: ""
    property string cameraName: ""
    property var targetDate: new Date()
    property var startDate: new Date()
    property var endDate: new Date()
    property bool isSelectingStart: true

    // Multi-camera properties
    property var activeCamerasList: []
    property int activeCameraIndex: -1

    ListModel {
        id: downloadModel
    }

    property bool hasValidationErrors: {
        var e1 = false, e2 = false, e3 = false, e4 = false;
        try { e1 = startDateField.hasError; } catch(e) {}
        try { e2 = endDateField.hasError; } catch(e) {}
        try { e3 = startTimeField.hasError; } catch(e) {}
        try { e4 = endTimeField.hasError; } catch(e) {}
        return e1 || e2 || e3 || e4;
    }

    function validateAllFields() {
        startDateField.customErrorText = ""
        startTimeField.customErrorText = ""
        endDateField.customErrorText = ""
        endTimeField.customErrorText = ""
        
        startDateField.forceShow = false
        startTimeField.forceShow = false
        endDateField.forceShow = false
        endTimeField.forceShow = false

        var startDtValid = validateDate(startDateField.text)
        startDateField.hasError = !startDtValid
        
        var startTmValid = validateTime(startTimeField.text)
        startTimeField.hasError = !startTmValid
        
        var endDtValid = validateDate(endDateField.text)
        endDateField.hasError = !endDtValid
        
        var endTmValid = validateTime(endTimeField.text)
        endTimeField.hasError = !endTmValid
        
        if (!startDtValid) {
            startDateField.forceShow = true
            startDateField.forceActiveFocus()
            return false
        }
        if (!startTmValid) {
            startTimeField.forceShow = true
            startTimeField.forceActiveFocus()
            return false
        }
        if (!endDtValid) {
            endDateField.forceShow = true
            endDateField.forceActiveFocus()
            return false
        }
        if (!endTmValid) {
            endTimeField.forceShow = true
            endTimeField.forceActiveFocus()
            return false
        }
        
        var startDt = getStartDateTime()
        var endDt = getEndDateTime()
        if (startDt >= endDt) {
            endDateField.hasError = true
            endDateField.customErrorText = qsTr("LNG_00054")
            endDateField.forceShow = true
            
            endTimeField.hasError = true
            endTimeField.customErrorText = qsTr("LNG_00054")
            endTimeField.forceShow = true
            
            endDateField.forceActiveFocus()
            return false
        }
        
        return true
    }

    function validateDate(text) {
        var dateRegex = /^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])\.\d{4}$/;
        if (!dateRegex.test(text)) return false;
        var parts = text.split(".");
        var day = parseInt(parts[0]);
        var month = parseInt(parts[1]);
        var year = parseInt(parts[2]);
        var d = new Date(year, month - 1, day);
        return d.getFullYear() === year && d.getMonth() === month - 1 && d.getDate() === day;
    }

    function validateTime(text) {
        var timeRegex = /^([01]\d|2[0-3])[:.][0-5]\d[:.][0-5]\d$/;
        return timeRegex.test(text);
    }

    background: Rectangle {
        color: "#1e2227"
        border.color: "#30363d"
        radius: 8
    }

    Popup {
        id: calendarPopup
        width: 320
        height: 380
        modal: true
        focus: true
        anchors.centerIn: parent
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle { 
            color: "#151d24"
            border.color: "#ff7a00"
            border.width: 1
            radius: 6
        }
        
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100; easing.type: Easing.InQuad }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100; easing.type: Easing.InQuad }
        }
        
        property int viewYear: targetDate.getFullYear()
        property int viewMonth: targetDate.getMonth()
        property var monthNames: [qsTr("LNG_00053"), qsTr("LNG_00052"), qsTr("LNG_00051"), qsTr("LNG_00050"), qsTr("LNG_00049"), qsTr("LNG_00048"), qsTr("LNG_00047"), qsTr("LNG_00046"), qsTr("LNG_00045"), qsTr("LNG_00044"), qsTr("LNG_00043"), qsTr("LNG_00042")]
        
        function updateDaysModel() {
            var firstDay = new Date(viewYear, viewMonth, 1)
            var lastDay = new Date(viewYear, viewMonth + 1, 0)
            var startOffset = firstDay.getDay() === 0 ? 6 : firstDay.getDay() - 1
            var totalDays = lastDay.getDate()
            
            var cells = []
            for (var i = 0; i < startOffset; i++) cells.push(0)
            for (var d = 1; d <= totalDays; d++) cells.push(d)
            while (cells.length % 7 !== 0) cells.push(0)
            
            daysRepeater.model = cells
        }

        onOpened: {
            viewYear = targetDate.getFullYear()
            viewMonth = targetDate.getMonth()
            updateDaysModel()
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            
            Text {
                text: calendarPopup.monthNames[calendarPopup.viewMonth] + " " + calendarPopup.viewYear
                color: "white"
                font.bold: true
                font.pixelSize: 18
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                Layout.bottomMargin: 10
            }
            
            GridLayout {
                columns: 7
                rowSpacing: 5
                columnSpacing: 5
                Layout.alignment: Qt.AlignHCenter
                
                Repeater {
                    model: ["Pn", "Wt", "Śr", "Cz", "Pt", "So", "Nd"]
                    Text { 
                        text: modelData; color: "#8898a6"; font.bold: true; 
                        horizontalAlignment: Text.AlignHCenter; 
                        Layout.preferredWidth: 36 
                    }
                }
                
                Repeater {
                    id: daysRepeater
                    model: []
                    
                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        color: {
                            if (modelData === 0) return "transparent"
                            var isCurrent = (calendarPopup.viewYear === targetDate.getFullYear() && calendarPopup.viewMonth === targetDate.getMonth() && modelData === targetDate.getDate())
                            if (isCurrent) return "#33ffffff"
                            return "transparent"
                        }
                        border.width: 0
                        radius: 4
                        
                        Text {
                            text: modelData > 0 ? modelData : ""
                            anchors.centerIn: parent
                            color: "white"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            enabled: modelData > 0
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var newDate = new Date(calendarPopup.viewYear, calendarPopup.viewMonth, modelData)
                                if (isSelectingStart) {
                                    startDate = newDate
                                    startDateField.text = Qt.formatDateTime(startDate, "dd.MM.yyyy")
                                } else {
                                    endDate = newDate
                                    endDateField.text = Qt.formatDateTime(endDate, "dd.MM.yyyy")
                                }
                                calendarPopup.close()
                            }
                        }
                    }
                }
            }
            
            Item { Layout.fillHeight: true }
            
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 20
                
                CctvButton {
                    text: ""
                    isSmall: true
                    iconSource: {
                        var colorStr = hovered ? "%2300f5d4" : "%238898a6"
                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='15 18 9 12 15 6'></polyline></svg>"
                    }
                    onClicked: {
                        if (calendarPopup.viewMonth === 0) { 
                            calendarPopup.viewMonth = 11; 
                            calendarPopup.viewYear--; 
                        } else { 
                            calendarPopup.viewMonth--; 
                        }
                        calendarPopup.updateDaysModel()
                    }
                    ToolTip.delay: 500
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("LNG_00041")
                }
                CctvButton {
                    text: ""
                    isSmall: true
                    iconSource: {
                        var colorStr = hovered ? "%2300f5d4" : "%238898a6"
                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='9 18 15 12 9 6'></polyline></svg>"
                    }
                    onClicked: {
                        if (calendarPopup.viewMonth === 11) { 
                            calendarPopup.viewMonth = 0; 
                            calendarPopup.viewYear++; 
                        } else { 
                            calendarPopup.viewMonth++; 
                        }
                        calendarPopup.updateDaysModel()
                    }
                    ToolTip.delay: 500
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("LNG_00040")
                }
            }
        }
    }

    Popup {
        id: timePickerPopup
        width: 320
        height: 320
        modal: true
        focus: true
        anchors.centerIn: parent
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle { 
            color: "#151d24"
            border.color: "#2a3540"
            border.width: 1
            radius: 6
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (timePickerContent) {
                        timePickerContent.forceActiveFocus()
                    }
                }
            }
        }
        
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100; easing.type: Easing.InQuad }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100; easing.type: Easing.InQuad }
        }

        property var targetField: null
        property int selectedHour: 0
        property int selectedMinute: 0
        property int selectedSecond: 0
        property int activeColumn: 0 // 0: Godziny, 1: Minuty, 2: Sekundy

        function changeSelectedValue(delta) {
            if (activeColumn === 0) {
                selectedHour = (selectedHour + delta + 24) % 24
                hourListView.positionViewAtIndex(selectedHour, ListView.Center)
            } else if (activeColumn === 1) {
                selectedMinute = (selectedMinute + delta + 60) % 60
                minuteListView.positionViewAtIndex(selectedMinute, ListView.Center)
            } else if (activeColumn === 2) {
                selectedSecond = (selectedSecond + delta + 60) % 60
                secondListView.positionViewAtIndex(selectedSecond, ListView.Center)
            }
        }

        function openTimePicker(field) {
            targetField = field
            var textVal = field.text
            var parts = textVal.split(/[:\.]/)
            var h = 0, m = 0, s = 0
            if (parts.length >= 3) {
                h = Math.max(0, Math.min(23, parseInt(parts[0]) || 0))
                m = Math.max(0, Math.min(59, parseInt(parts[1]) || 0))
                s = Math.max(0, Math.min(59, parseInt(parts[2]) || 0))
            }
            selectedHour = h
            selectedMinute = m
            selectedSecond = s
            activeColumn = 0
            
            open()
            
            Qt.callLater(function() {
                hourListView.positionViewAtIndex(h, ListView.Center)
                minuteListView.positionViewAtIndex(m, ListView.Center)
                secondListView.positionViewAtIndex(s, ListView.Center)
                if (timePickerContent) {
                    timePickerContent.forceActiveFocus()
                }
            })
        }

        function applyTime() {
            if (targetField) {
                var hStr = selectedHour < 10 ? "0" + selectedHour : selectedHour.toString()
                var mStr = selectedMinute < 10 ? "0" + selectedMinute : selectedMinute.toString()
                var sStr = selectedSecond < 10 ? "0" + selectedSecond : selectedSecond.toString()
                
                targetField.text = hStr + ":" + mStr + ":" + sStr
                targetField.hasError = false
            }
            close()
        }

        ColumnLayout {
            id: timePickerContent
            focus: true
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            Keys.onLeftPressed: {
                timePickerPopup.activeColumn = (timePickerPopup.activeColumn - 1 + 3) % 3
            }
            Keys.onRightPressed: {
                timePickerPopup.activeColumn = (timePickerPopup.activeColumn + 1) % 3
            }
            Keys.onUpPressed: {
                timePickerPopup.changeSelectedValue(-1)
            }
            Keys.onDownPressed: {
                timePickerPopup.changeSelectedValue(1)
            }
            Keys.onReturnPressed: {
                timePickerPopup.applyTime()
            }
            Keys.onEnterPressed: {
                timePickerPopup.applyTime()
            }

            Text {
                text: qsTr("LNG_00039")
                color: "white"
                font.bold: true
                font.pixelSize: 16
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Hours Column
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    Text {
                        text: qsTr("LNG_00038")
                        color: timePickerPopup.activeColumn === 0 ? timePickerPopup.palette.highlight : "#8898a6"
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: timePickerPopup.palette.base
                        border.color: timePickerPopup.activeColumn === 0 ? timePickerPopup.palette.highlight : "#2a3540"
                        border.width: timePickerPopup.activeColumn === 0 ? 1.5 : 1
                        radius: Compact.radius
                        clip: true

                        ListView {
                            id: hourListView
                            anchors.fill: parent
                            model: 24
                            clip: true
                            ScrollBar.vertical: ScrollBar {
                                id: hourScrollBar
                                policy: ScrollBar.AlwaysOn
                                hoverEnabled: true
                                width: 16
                                padding: 4
                                contentItem: Rectangle {
                                    implicitWidth: 8
                                    radius: 4
                                    color: hourScrollBar.pressed ? "#00f5d4" : (hourScrollBar.hovered ? "#8800f5d4" : "#4d5e6d")
                                    Behavior on color {
                                        ColorAnimation { duration: 150 }
                                    }
                                }
                                background: Rectangle {
                                    implicitWidth: 16
                                    color: "transparent"
                                }
                            }
                            delegate: Rectangle {
                                width: parent.width
                                height: 30
                                color: timePickerPopup.selectedHour === index ? "#1400f5d4" : "transparent"
                                border.color: timePickerPopup.selectedHour === index ? "#4400f5d4" : "transparent"
                                border.width: 1
                                radius: Compact.radius
                                Text {
                                    text: index < 10 ? "0" + index : index.toString()
                                    color: timePickerPopup.selectedHour === index ? "#00f5d4" : "#8898a6"
                                    font.bold: timePickerPopup.selectedHour === index
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        timePickerPopup.selectedHour = index
                                        timePickerPopup.activeColumn = 0
                                        timePickerContent.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }
                }

                // Minutes Column
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    Text {
                        text: qsTr("LNG_00037")
                        color: timePickerPopup.activeColumn === 1 ? timePickerPopup.palette.highlight : "#8898a6"
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: timePickerPopup.palette.base
                        border.color: timePickerPopup.activeColumn === 1 ? timePickerPopup.palette.highlight : "#2a3540"
                        border.width: timePickerPopup.activeColumn === 1 ? 1.5 : 1
                        radius: Compact.radius
                        clip: true

                        ListView {
                            id: minuteListView
                            anchors.fill: parent
                            model: 60
                            clip: true
                            ScrollBar.vertical: ScrollBar {
                                id: minuteScrollBar
                                policy: ScrollBar.AlwaysOn
                                hoverEnabled: true
                                width: 16
                                padding: 4
                                contentItem: Rectangle {
                                    implicitWidth: 8
                                    radius: 4
                                    color: minuteScrollBar.pressed ? "#00f5d4" : (minuteScrollBar.hovered ? "#8800f5d4" : "#4d5e6d")
                                    Behavior on color {
                                        ColorAnimation { duration: 150 }
                                    }
                                }
                                background: Rectangle {
                                    implicitWidth: 16
                                    color: "transparent"
                                }
                            }
                            delegate: Rectangle {
                                width: parent.width
                                height: 30
                                color: timePickerPopup.selectedMinute === index ? "#1400f5d4" : "transparent"
                                border.color: timePickerPopup.selectedMinute === index ? "#4400f5d4" : "transparent"
                                border.width: 1
                                radius: Compact.radius
                                Text {
                                    text: index < 10 ? "0" + index : index.toString()
                                    color: timePickerPopup.selectedMinute === index ? "#00f5d4" : "#8898a6"
                                    font.bold: timePickerPopup.selectedMinute === index
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        timePickerPopup.selectedMinute = index
                                        timePickerPopup.activeColumn = 1
                                        timePickerContent.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }
                }

                // Seconds Column
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    Text {
                        text: qsTr("LNG_00036")
                        color: timePickerPopup.activeColumn === 2 ? timePickerPopup.palette.highlight : "#8898a6"
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: timePickerPopup.palette.base
                        border.color: timePickerPopup.activeColumn === 2 ? timePickerPopup.palette.highlight : "#2a3540"
                        border.width: timePickerPopup.activeColumn === 2 ? 1.5 : 1
                        radius: Compact.radius
                        clip: true

                        ListView {
                            id: secondListView
                            anchors.fill: parent
                            model: 60
                            clip: true
                            ScrollBar.vertical: ScrollBar {
                                id: secondScrollBar
                                policy: ScrollBar.AlwaysOn
                                hoverEnabled: true
                                width: 16
                                padding: 4
                                contentItem: Rectangle {
                                    implicitWidth: 8
                                    radius: 4
                                    color: secondScrollBar.pressed ? "#00f5d4" : (secondScrollBar.hovered ? "#8800f5d4" : "#4d5e6d")
                                    Behavior on color {
                                        ColorAnimation { duration: 150 }
                                    }
                                }
                                background: Rectangle {
                                    implicitWidth: 16
                                    color: "transparent"
                                }
                            }
                            delegate: Rectangle {
                                width: parent.width
                                height: 30
                                color: timePickerPopup.selectedSecond === index ? "#1400f5d4" : "transparent"
                                border.color: timePickerPopup.selectedSecond === index ? "#4400f5d4" : "transparent"
                                border.width: 1
                                radius: Compact.radius
                                Text {
                                    text: index < 10 ? "0" + index : index.toString()
                                    color: timePickerPopup.selectedSecond === index ? "#00f5d4" : "#8898a6"
                                    font.bold: timePickerPopup.selectedSecond === index
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        timePickerPopup.selectedSecond = index
                                        timePickerPopup.activeColumn = 2
                                        timePickerContent.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                CctvButton {
                    text: qsTr("LNG_00023")
                    Layout.fillWidth: true
                    onClicked: timePickerPopup.close()
                }
                CctvButton {
                    text: qsTr("LNG_00035")
                    isPrimary: true
                    Layout.fillWidth: true
                    onClicked: timePickerPopup.applyTime()
                }
            }
        }
    }

    onOpened: {
        var baseDate = targetDate || new Date()
        
        startDate = new Date(baseDate)
        startDate.setHours(0, 0, 0, 0)
        
        endDate = new Date(baseDate)
        endDate.setHours(23, 59, 59, 0)
        
        startDateField.text = Qt.formatDateTime(startDate, "dd.MM.yyyy")
        endDateField.text = Qt.formatDateTime(endDate, "dd.MM.yyyy")
        startTimeField.text = "00:00:00"
        endTimeField.text = "01:00:00"

        downloadModel.clear();
        for (var i = 0; i < activeCamerasList.length; i++) {
            var cam = activeCamerasList[i];
            if (!cam) continue;
            
            var d = Qt.formatDateTime(startDate, "yyyy-MM-dd");
            var cleanRecName = cam.recorderName || "";
            // Strip IPv4 and IPv6 addresses
            cleanRecName = cleanRecName.replace(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/g, "");
            cleanRecName = cleanRecName.replace(/([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}/g, "");
            cleanRecName = cleanRecName.trim().replace(/^[_-\s]+|[_-\s]+$/g, "");
            
            var filename = "";
            if (cleanRecName !== "") {
                filename = cleanRecName + "_" + cam.channelId + "_" + cam.cameraName + "_" + d + ".mp4";
            } else {
                filename = cam.channelId + "_" + cam.cameraName + "_" + d + ".mp4";
            }
            filename = filename.replace(/ /g, "_").replace(/[^a-zA-Z0-9_\-\.]/g, "");
            
            var moviesPath = "";
            if (typeof rootWindow !== "undefined" && rootWindow.generalSettings && rootWindow.generalSettings.videoPath !== "") {
                moviesPath = rootWindow.generalSettings.videoPath;
            } else {
                moviesPath = Platform.StandardPaths.writableLocation(Platform.StandardPaths.MoviesLocation).toString();
                if (moviesPath.indexOf("file://") === 0) {
                    moviesPath = moviesPath.substring(7);
                }
                moviesPath = moviesPath + "/CCTV";
            }
            var defaultSavePath = moviesPath + "/" + filename;
            
            downloadModel.append({
                "cameraIndex": i,
                "cameraName": cam.cameraName,
                "channelId": cam.channelId,
                "ip": cam.ip,
                "port": cam.port || 8000,
                "username": cam.username,
                "password": cam.password,
                "recorderName": cam.recorderName,
                "savePath": defaultSavePath,
                "downloadEnabled": true,
                "progress": 0,
                "overallProgress": 0,
                "isDownloading": false,
                "statusText": "",
                "downloadSuccess": false
            });
        }
    }
    
    onClosed: {
        stopAllDownloads()
    }

    function isAnyDownloading() {
        for (var i = 0; i < downloadModel.count; i++) {
            if (downloadModel.get(i).isDownloading) {
                return true;
            }
        }
        return false;
    }

    function isAnyEnabled() {
        for (var i = 0; i < downloadModel.count; i++) {
            if (downloadModel.get(i).downloadEnabled) {
                return true;
            }
        }
        return false;
    }

    function stopAllDownloads() {
        for (var i = 0; i < cameraRepeater.count; i++) {
            var delegateItem = cameraRepeater.itemAt(i);
            if (delegateItem && downloadModel.get(i).isDownloading) {
                delegateItem.stopRowDownload();
            }
        }
    }

    function getStartDateTime() {
        var partsDateStart = startDateField.text.split(".")
        var start = new Date()
        if (partsDateStart.length === 3) {
            start.setFullYear(parseInt(partsDateStart[2]), parseInt(partsDateStart[1])-1, parseInt(partsDateStart[0]))
        }
        var partsStart = startTimeField.text.split(/[:\.]/)
        start.setHours(parseInt(partsStart[0]||"0"), parseInt(partsStart[1]||"0"), parseInt(partsStart[2]||"0"), 0)
        return start
    }
    
    function getEndDateTime() {
        var partsDateEnd = endDateField.text.split(".")
        var end = new Date()
        if (partsDateEnd.length === 3) {
            end.setFullYear(parseInt(partsDateEnd[2]), parseInt(partsDateEnd[1])-1, parseInt(partsDateEnd[0]))
        }
        var partsEnd = endTimeField.text.split(/[:\.]/)
        end.setHours(parseInt(partsEnd[0]||"23"), parseInt(partsEnd[1]||"59"), parseInt(partsEnd[2]||"59"), 0)
        return end
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: qsTr("LNG_00034")
            color: "white"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
        }

        GridLayout {
            columns: 4
            rowSpacing: 10
            columnSpacing: 10
            Layout.fillWidth: true

            Text { text: qsTr("LNG_00033"); color: "white"; Layout.alignment: Qt.AlignVCenter }
            RowLayout {
                spacing: 2
                Layout.preferredWidth: 150
                Layout.fillWidth: false
                TextField {
                    id: startDateField
                    Layout.fillWidth: true
                    selectByMouse: true
                    palette.highlight: "#00f5d4"
                    palette.highlightedText: "#000000"
                    enabled: !downloadDialog.isAnyDownloading()
                    
                    property bool hasError: false
                    property bool forceShow: false
                    property string customErrorText: ""
                    onTextChanged: {
                        forceShow = false
                        customErrorText = ""
                        if (text.length === 10) {
                            hasError = !downloadDialog.validateDate(text)
                        } else if (text.length > 10) {
                            hasError = true
                        } else {
                            hasError = false
                        }
                    }
                    onActiveFocusChanged: {
                        if (!activeFocus) {
                            hasError = !downloadDialog.validateDate(text)
                        }
                    }
                    
                    background: Rectangle {
                        color: startDateField.palette.base
                        radius: Compact.radius
                        border.color: startDateField.hasError ? "#ff3333" : (startDateField.activeFocus ? startDateField.palette.highlight : startDateField.palette.mid)
                        border.width: startDateField.activeFocus || startDateField.hasError ? 2 : 1
                    }
                    
                    ToolTip {
                        id: startDateFieldTip
                        visible: startDateField.hasError && (startDateField.hovered || startDateField.activeFocus || startDateField.forceShow)
                        text: startDateField.customErrorText !== "" ? startDateField.customErrorText : qsTr("LNG_00031")
                        delay: 0
                        timeout: 5000
                        background: Rectangle {
                            color: "#3a1c1e"
                            border.color: "#ff3333"
                            radius: Compact.radius
                        }
                        contentItem: Text {
                            text: startDateFieldTip.text
                            color: "white"
                            font.bold: true
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                        }
                    }
                }
                CctvButton {
                    iconSource: {
                        var colorStr = hovered ? "%2300f5d4" : "%23ffffff"
                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line><path d='M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01'></path></svg>"
                    }
                    isSmall: true
                    Layout.preferredWidth: 30
                    enabled: !downloadDialog.isAnyDownloading()
                    onClicked: {
                        isSelectingStart = true
                        var parts = startDateField.text.split(".")
                        if (parts.length === 3) {
                            startDate.setFullYear(parseInt(parts[2]), parseInt(parts[1])-1, parseInt(parts[0]))
                        }
                        calendarPopup.viewYear = startDate.getFullYear()
                        calendarPopup.viewMonth = startDate.getMonth()
                        calendarPopup.updateDaysModel()
                        calendarPopup.open()
                    }
                }
            }
            RowLayout {
                spacing: 2
                Layout.preferredWidth: 130
                Layout.fillWidth: false
                TextField {
                    id: startTimeField
                    Layout.fillWidth: true
                    selectByMouse: true
                    palette.highlight: "#00f5d4"
                    palette.highlightedText: "#000000"
                    enabled: !downloadDialog.isAnyDownloading()
                    
                    property bool hasError: false
                    property bool forceShow: false
                    property string customErrorText: ""
                    onTextChanged: {
                        forceShow = false
                        customErrorText = ""
                        if (text.length === 8) {
                            hasError = !downloadDialog.validateTime(text)
                        } else if (text.length > 8) {
                            hasError = true
                        } else {
                            hasError = false
                        }
                    }
                    onActiveFocusChanged: {
                        if (!activeFocus) {
                            hasError = !downloadDialog.validateTime(text)
                        }
                    }
                    
                    background: Rectangle {
                        color: startTimeField.palette.base
                        radius: Compact.radius
                        border.color: startTimeField.hasError ? "#ff3333" : (startTimeField.activeFocus ? startTimeField.palette.highlight : startTimeField.palette.mid)
                        border.width: startTimeField.activeFocus || startTimeField.hasError ? 2 : 1
                    }
                    
                    ToolTip {
                        id: startTimeFieldTip
                        visible: startTimeField.hasError && (startTimeField.hovered || startTimeField.activeFocus || startTimeField.forceShow)
                        text: startTimeField.customErrorText !== "" ? startTimeField.customErrorText : qsTr("LNG_00030")
                        delay: 0
                        timeout: 5000
                        background: Rectangle {
                            color: "#3a1c1e"
                            border.color: "#ff3333"
                            radius: Compact.radius
                        }
                        contentItem: Text {
                            text: startTimeFieldTip.text
                            color: "white"
                            font.bold: true
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                        }
                    }
                }
                CctvButton {
                    iconSource: {
                        var colorStr = hovered ? "%2300f5d4" : "%23ffffff"
                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline></svg>"
                    }
                    isSmall: true
                    Layout.preferredWidth: 30
                    enabled: !downloadDialog.isAnyDownloading()
                    onClicked: {
                        timePickerPopup.openTimePicker(startTimeField)
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }

            Text { text: qsTr("LNG_00032"); color: "white"; Layout.alignment: Qt.AlignVCenter }
            RowLayout {
                spacing: 2
                Layout.preferredWidth: 150
                Layout.fillWidth: false
                TextField {
                    id: endDateField
                    Layout.fillWidth: true
                    selectByMouse: true
                    palette.highlight: "#00f5d4"
                    palette.highlightedText: "#000000"
                    enabled: !downloadDialog.isAnyDownloading()
                    
                    property bool hasError: false
                    property bool forceShow: false
                    property string customErrorText: ""
                    onTextChanged: {
                        forceShow = false
                        customErrorText = ""
                        if (text.length === 10) {
                            hasError = !downloadDialog.validateDate(text)
                        } else if (text.length > 10) {
                            hasError = true
                        } else {
                            hasError = false
                        }
                    }
                    onActiveFocusChanged: {
                        if (!activeFocus) {
                            hasError = !downloadDialog.validateDate(text)
                        }
                    }
                    
                    background: Rectangle {
                        color: endDateField.palette.base
                        radius: Compact.radius
                        border.color: endDateField.hasError ? "#ff3333" : (endDateField.activeFocus ? endDateField.palette.highlight : endDateField.palette.mid)
                        border.width: endDateField.activeFocus || endDateField.hasError ? 2 : 1
                    }
                    
                    ToolTip {
                        id: endDateFieldTip
                        visible: endDateField.hasError && (endDateField.hovered || endDateField.activeFocus || endDateField.forceShow)
                        text: endDateField.customErrorText !== "" ? endDateField.customErrorText : qsTr("LNG_00031")
                        delay: 0
                        timeout: 5000
                        background: Rectangle {
                            color: "#3a1c1e"
                            border.color: "#ff3333"
                            radius: Compact.radius
                        }
                        contentItem: Text {
                            text: endDateFieldTip.text
                            color: "white"
                            font.bold: true
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                        }
                    }
                }
                CctvButton {
                    iconSource: {
                        var colorStr = hovered ? "%2300f5d4" : "%23ffffff"
                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line><path d='M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01'></path></svg>"
                    }
                    isSmall: true
                    Layout.preferredWidth: 30
                    enabled: !downloadDialog.isAnyDownloading()
                    onClicked: {
                        isSelectingStart = false
                        var parts = endDateField.text.split(".")
                        if (parts.length === 3) {
                            endDate.setFullYear(parseInt(parts[2]), parseInt(parts[1])-1, parseInt(parts[0]))
                        }
                        calendarPopup.viewYear = endDate.getFullYear()
                        calendarPopup.viewMonth = endDate.getMonth()
                        calendarPopup.updateDaysModel()
                        calendarPopup.open()
                    }
                }
            }
            RowLayout {
                spacing: 2
                Layout.preferredWidth: 130
                Layout.fillWidth: false
                TextField {
                    id: endTimeField
                    Layout.fillWidth: true
                    selectByMouse: true
                    palette.highlight: "#00f5d4"
                    palette.highlightedText: "#000000"
                    enabled: !downloadDialog.isAnyDownloading()
                    
                    property bool hasError: false
                    property bool forceShow: false
                    property string customErrorText: ""
                    onTextChanged: {
                        forceShow = false
                        customErrorText = ""
                        if (text.length === 8) {
                            hasError = !downloadDialog.validateTime(text)
                        } else if (text.length > 8) {
                            hasError = true
                        } else {
                            hasError = false
                        }
                    }
                    onActiveFocusChanged: {
                        if (!activeFocus) {
                            hasError = !downloadDialog.validateTime(text)
                        }
                    }
                    
                    background: Rectangle {
                        color: endTimeField.palette.base
                        radius: Compact.radius
                        border.color: endTimeField.hasError ? "#ff3333" : (endTimeField.activeFocus ? endTimeField.palette.highlight : endTimeField.palette.mid)
                        border.width: endTimeField.activeFocus || endTimeField.hasError ? 2 : 1
                    }
                    
                    ToolTip {
                        id: endTimeFieldTip
                        visible: endTimeField.hasError && (endTimeField.hovered || endTimeField.activeFocus || endTimeField.forceShow)
                        text: endTimeField.customErrorText !== "" ? endTimeField.customErrorText : qsTr("LNG_00030")
                        delay: 0
                        timeout: 5000
                        background: Rectangle {
                            color: "#3a1c1e"
                            border.color: "#ff3333"
                            radius: Compact.radius
                        }
                        contentItem: Text {
                            text: endTimeFieldTip.text
                            color: "white"
                            font.bold: true
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                        }
                    }
                }
                CctvButton {
                    iconSource: {
                        var colorStr = hovered ? "%2300f5d4" : "%23ffffff"
                        return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" + colorStr + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline></svg>"
                    }
                    isSmall: true
                    Layout.preferredWidth: 30
                    enabled: !downloadDialog.isAnyDownloading()
                    onClicked: {
                        timePickerPopup.openTimePicker(endTimeField)
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }
          // Cameras List inside a scrollable view with a fixed height layout
        ScrollView {
            id: cameraScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                id: scrollColumn
                width: cameraScroll.width - 16
                spacing: 12
                
                Repeater {
                    id: cameraRepeater
                    model: downloadModel
                    
                    delegate: ColumnLayout {
                        id: rowLayout
                        Layout.fillWidth: true
                        spacing: 4
                        
                        HikvisionDownloader {
                            id: rowDownloader
                            onStatusTextChanged: {
                                if (rowDownloader.statusText !== "") {
                                    if (rowDownloader.isDownloading && rowDownloader.isConverting) {
                                        model.statusText = rowDownloader.statusText + " (" + rowDownloader.overallProgress + "%)"
                                    } else {
                                        model.statusText = rowDownloader.statusText
                                    }
                                }
                            }
                            onProgressChanged: {
                                model.progress = rowDownloader.overallProgress
                                if (rowDownloader.isDownloading) {
                                    if (rowDownloader.isConverting) {
                                        model.statusText = rowDownloader.statusText + " (" + rowDownloader.overallProgress + "%)"
                                    } else if (rowDownloader.statusText !== "") {
                                        model.statusText = rowDownloader.statusText + " " + rowDownloader.progress + "% (" + qsTr("LNG_00029") + " " + rowDownloader.overallProgress + "%)"
                                    } else {
                                        model.statusText = qsTr("LNG_00028") + " " + rowDownloader.overallProgress + "%"
                                    }
                                }
                            }
                            onDownloadFinished: {
                                model.isDownloading = false
                                if (success) {
                                    model.statusText = message
                                    model.downloadSuccess = true
                                } else {
                                    model.statusText = qsTr("LNG_00027") + " " + message
                                }
                            }
                        }
                        
                        function startRowDownload(recInfo, startDt, endDt) {
                            model.downloadSuccess = false
                            model.isDownloading = true
                            model.statusText = qsTr("LNG_00026")
                            rowDownloader.startDownload(recInfo, model.channelId, startDt, endDt, model.savePath)
                        }
                        
                        function stopRowDownload() {
                            rowDownloader.stopDownload()
                            model.isDownloading = false
                            model.downloadSuccess = false
                            model.statusText = qsTr("LNG_00025")
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            
                            CheckBox {
                                checked: model.downloadEnabled
                                onCheckedChanged: model.downloadEnabled = checked
                                enabled: !downloadDialog.isAnyDownloading()
                            }
                            
                            Text {
                                text: model.cameraName
                                color: "white"
                                font.bold: true
                                Layout.preferredWidth: 180
                                elide: Text.ElideRight
                            }
                            
                            TextField {
                                id: savePathInput
                                Layout.fillWidth: true
                                enabled: model.downloadEnabled && !downloadDialog.isAnyDownloading()
                                selectByMouse: true
                                palette.highlight: "#00f5d4"
                                palette.highlightedText: "#000000"
                                onTextEdited: model.savePath = text
     
                                Binding {
                                    target: savePathInput
                                    property: "text"
                                    value: model.savePath
                                    when: !savePathInput.activeFocus
                                }
                            }
                            
                            CctvButton {
                                text: "..."
                                Layout.preferredWidth: 36
                                enabled: model.downloadEnabled && !downloadDialog.isAnyDownloading()
                                onClicked: {
                                    var p = model.savePath
                                    if (p.indexOf("file://") !== 0) {
                                        p = "file://" + p
                                    }
                                    activeCameraIndex = index
                                    fileDialog.currentFile = p
                                    fileDialog.open()
                                }
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.leftMargin: 40
                            visible: model.isDownloading || model.statusText !== ""
                            
                            Item {
                                Layout.fillWidth: true
                                implicitHeight: 18
                                
                                ProgressBar {
                                    id: bar
                                    anchors.fill: parent
                                    from: 0
                                    to: 100
                                    value: model.progress
                                    visible: model.isDownloading
                                    
                                    background: Rectangle {
                                        implicitWidth: 200
                                        implicitHeight: 18
                                        color: "#282c34"
                                        radius: 4
                                    }
                                    contentItem: Item {
                                        implicitWidth: 200
                                        implicitHeight: 18
                                        Rectangle {
                                            width: bar.visualPosition * parent.width
                                            height: parent.height
                                            radius: 4
                                            color: "#00f5d4"
                                        }
                                    }
                                }
                                
                                Text {
                                    text: model.statusText
                                    anchors.centerIn: parent
                                    color: model.statusText.indexOf("Błąd") !== -1 ? "#ff3b30" : "white"
                                    font.pixelSize: 11
                                    font.bold: true
                                    style: Text.Outline
                                    styleColor: "#1e2227"
                                }
                            }

                            CctvButton {
                                text: qsTr("LNG_00024")
                                isSmall: true
                                isCeladon: true
                                visible: !!model.downloadSuccess
                                onClicked: {
                                    var path = model.savePath;
                                    var dirPath = "";
                                    var idx = path.lastIndexOf("/");
                                    if (idx !== -1) {
                                        dirPath = path.substring(0, idx);
                                    } else {
                                        dirPath = path;
                                    }
                                    Qt.openUrlExternally("file://" + dirPath);
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item { Layout.fillWidth: true } // Spacer

            CctvButton {
                text: qsTr("LNG_00023")
                onClicked: {
                    downloadDialog.close()
                }
            }

            CctvButton {
                text: downloadDialog.isAnyDownloading() ? qsTr("LNG_00022") : qsTr("LNG_00021")
                isPrimary: true
                enabled: downloadDialog.isAnyDownloading() || downloadDialog.isAnyEnabled()
                onClicked: {
                    if (downloadDialog.isAnyDownloading()) {
                        downloadDialog.stopAllDownloads()
                    } else {
                        if (!downloadDialog.validateAllFields()) {
                            return
                        }
                        
                        downloadStarted()
                        
                        var startDt = downloadDialog.getStartDateTime()
                        var endDt = downloadDialog.getEndDateTime()
                        
                        for (var i = 0; i < cameraRepeater.count; i++) {
                            var modelItem = downloadModel.get(i)
                            if (modelItem.downloadEnabled) {
                                var delegateItem = cameraRepeater.itemAt(i)
                                if (delegateItem) {
                                     var recInfo = {
                                         "ip": modelItem.ip,
                                         "port": modelItem.port,
                                         "username": modelItem.username,
                                         "password": modelItem.password
                                     }
                                     var path = modelItem.savePath;
                                     var dirPath = path.substring(0, Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\")));
                                     if (dirPath !== "") {
                                         Context.mkpath(dirPath);
                                     }
                                     delegateItem.startRowDownload(recInfo, startDt, endDt)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Platform.FileDialog {
        id: fileDialog
        title: "Zapisz jako"
        fileMode: Platform.FileDialog.SaveFile
        nameFilters: ["Filmy MP4 (*.mp4)", "Wszystkie pliki (*)"]
        defaultSuffix: "mp4"
        folder: {
            if (typeof rootWindow !== "undefined" && rootWindow.generalSettings && rootWindow.generalSettings.videoPath !== "") {
                Context.mkpath(rootWindow.generalSettings.videoPath);
                return "file://" + rootWindow.generalSettings.videoPath;
            }
            var mLoc = Platform.StandardPaths.writableLocation(Platform.StandardPaths.MoviesLocation).toString();
            if (mLoc.indexOf("file://") === 0) mLoc = mLoc.substring(7);
            var defaultPath = mLoc + "/CCTV";
            Context.mkpath(defaultPath);
            return "file://" + defaultPath;
        }
        onAccepted: {
            var path = fileDialog.file.toString()
            if (path.indexOf("file://") === 0) {
                path = path.substring(7)
            }
            if (activeCameraIndex >= 0 && activeCameraIndex < downloadModel.count) {
                downloadModel.setProperty(activeCameraIndex, "savePath", path)
            }
        }
    }
}
