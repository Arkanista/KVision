import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import CCTV_Viewer.Core 1.0

Window {
    id: instructionsWindow
    title: qsTr("KVision - Instrukcja Obsługi / Instructions")
    width: 750
    height: 800
    minimumWidth: 400
    minimumHeight: 500
    color: "#0f151b"

    property string rawMarkdownText: ""

    // Center window over the main rootWindow
    x: rootWindow.x + (rootWindow.width - width) / 2
    y: rootWindow.y + (rootWindow.height - height) / 2

    Component.onCompleted: {
        loadInstructions();
    }

    // Reload when language changes
    Connections {
        target: Context
        function onLanguageChanged() {
            loadInstructions();
        }
    }

    function loadInstructions() {
        // Use a translated resource string to select correct file based on active locale
        var fileUrl = qsTr("qrc:/INSTRUKCJA.md");
        var content = Context.readLocalFile(fileUrl);
        if (content) {
            rawMarkdownText = content;
            instructionsText.text = markdownToHtml(content);
        } else {
            instructionsText.text = "<p style='color: #ff4d4d;'>" + qsTr("Błąd ładowania instrukcji.") + "</p>";
        }
    }

    function findHeaderIndex(anchor) {
        if (!rawMarkdownText) return -1;
        
        // Convert anchor to lowercase and remove hyphens/spaces
        var cleanAnchor = anchor.toLowerCase().replace(/[^a-z0-9ąéćęłńóśźż]/gi, "");
        if (!cleanAnchor) return -1;
        
        // Split raw markdown into lines to find the matching header line
        var lines = rawMarkdownText.split("\n");
        var charCount = 0;
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            if (line.startsWith("#")) {
                var cleanHeader = line.toLowerCase().replace(/[^a-z0-9ąéćęłńóśźż]/gi, "");
                // Match if either contains the other
                if (cleanHeader.indexOf(cleanAnchor) !== -1 || cleanAnchor.indexOf(cleanHeader) !== -1) {
                    return charCount;
                }
            }
            charCount += line.length + 1; // +1 for the newline
        }
        
        // Fallback to simple direct text search
        return rawMarkdownText.indexOf(anchor);
    }

    function markdownToHtml(md) {
        if (!md) return "";
        
        function getIconHtml(name) {
            var n = name.trim().toLowerCase();
            var svgs = {
                "quit": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff3333' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='18' y1='6' x2='6' y2='18'></line><line x1='6' y1='6' x2='18' y2='18'></line></svg>",
                "close": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff3333' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='18' y1='6' x2='6' y2='18'></line><line x1='6' y1='6' x2='18' y2='18'></line></svg>",
                "pin": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><line x1='12' x2='12' y1='17' y2='22'></line><path d='M5 17h14v-1.76a2 2 0 0 0-.44-1.24l-2.78-3.56A2 2 0 0 1 15 9.2V5a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4.2a2 2 0 0 1-.78 1.24L5.44 14a2 2 0 0 0-.44 1.24Z'></path></svg>",
                "fullscreen": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='m21 21-6-6m6 6V15m0 6h-6M3 3l6 6M3 3v6M3 3h6M3 21l6-6M3 21v-6M3 21h6M21 3l-6 6M21 3v6M21 3h-6'></path></svg>",
                "minimize": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#38bdf8' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='5' y1='19' x2='19' y2='19'></line><line x1='12' y1='5' x2='12' y2='14'></line><polyline points='7 10 12 15 17 10'></polyline></svg>",
                "options": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff7a00' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='3'></circle><path d='M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 a2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z'></path></svg>",
                "settings": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff7a00' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='3'></circle><path d='M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 a2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2 2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z'></path></svg>",
                "sidebar": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='3' width='18' height='18' rx='2' ry='2'></rect><line x1='9' y1='3' x2='9' y2='21'></line></svg>",
                "new_window": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='2' y='3' width='14' height='12' rx='2' ry='2'></rect><path d='M8 21h8'></path><path d='M12 17v4'></path><path d='M22 8v10a2 2 0 0 1-2 2H10'></path></svg>",
                "archive": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><ellipse cx='12' cy='5' rx='9' ry='3'></ellipse><path d='M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5'></path><path d='M3 12c0 1.66 4 3 9 3s9-1.34 9-3'></path></svg>",
                "manual": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#eab308' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z'></path><path d='M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z'></path></svg>",
                "instructions": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#eab308' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z'></path><path d='M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z'></path></svg>",
                "stats": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#eab308' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='18' y1='20' x2='18' y2='10'></line><line x1='12' y1='20' x2='12' y2='4'></line><line x1='6' y1='20' x2='6' y2='14'></line></svg>",
                "lock": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff7a00' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='11' width='18' height='11' rx='2' ry='2'></rect><path d='M7 11V7a5 5 0 0 1 10 0v4'></path></svg>",
                "unlock": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#8898a6' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='11' width='18' height='11' rx='2' ry='2'></rect><path d='M7 11V7a5 5 0 0 1 9.9-1'></path></svg>",
                "hamburger": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='3' y1='12' x2='21' y2='12'></line><line x1='3' y1='6' x2='21' y2='6'></line><line x1='3' y1='18' x2='21' y2='18'></line></svg>",
                "grid_tools": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><line x1='3' y1='12' x2='21' y2='12'></line><line x1='3' y1='6' x2='21' y2='6'></line><line x1='3' y1='18' x2='21' y2='18'></line></svg>",
                "speaker_mute": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff3333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polygon points='11 5 6 9 2 9 2 15 6 15 11 19 11 5'></polygon><line x1='23' y1='9' x2='17' y2='15'></line><line x1='17' y1='9' x2='23' y2='15'></line></svg>",
                "speaker_unmute": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polygon points='11 5 6 9 2 9 2 15 6 15 11 19 11 5'></polygon><path d='M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07'></path></svg>",
                "camera": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z'></path><circle cx='12' cy='13' r='4'></circle></svg>",
                "snapshot": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z'></path><circle cx='12' cy='13' r='4'></circle></svg>",
                "play": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polygon points='5 3 19 12 5 21 5 3'></polygon></svg>",
                "pause": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='#ffffff' stroke='none'><rect x='6' y='4' width='4' height='16' rx='1'></rect><rect x='14' y='4' width='4' height='16' rx='1'></rect></svg>",
                "time": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ffffff' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline></svg>",
                "clock": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ffffff' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline></svg>",
                "zoom": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='11' cy='11' r='8'></circle><line x1='21' y1='21' x2='16.65' y2='16.65'></line><line x1='11' y1='8' x2='11' y2='14'></line><line x1='8' y1='11' x2='14' y2='11'></line></svg>",
                "zoom_in": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='11' cy='11' r='8'></circle><line x1='21' y1='21' x2='16.65' y2='16.65'></line><line x1='11' y1='8' x2='11' y2='14'></line><line x1='8' y1='11' x2='14' y2='11'></line></svg>",
                "zoom_out": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff3333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='11' cy='11' r='8'></circle><line x1='21' y1='21' x2='16.65' y2='16.65'></line><line x1='8' y1='11' x2='14' y2='11'></line></svg>",
                "folder": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z'></path></svg>",
                "video_folder": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M23 7l-7 5 7 5V7z'></path><rect x='1' y='5' width='15' height='14' rx='2' ry='2'></rect></svg>",
                "photo_folder": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z'></path><circle cx='12' cy='13' r='4'></circle></svg>",
                "timeline_toggle": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='3' width='18' height='18' rx='2' ry='2'></rect><line x1='9' y1='3' x2='9' y2='21'></line><path d='M3 3h6v18H3z' fill='#00f5d4' fill-opacity='0.2'></path></svg>",
                "grid_1x1": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='3' width='18' height='18' rx='2' ry='2'></rect></svg>",
                "grid_1x2": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='3' width='18' height='18' rx='2' ry='2'></rect><line x1='12' y1='3' x2='12' y2='21'></line></svg>",
                "grid_2x1": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='3' width='18' height='18' rx='2' ry='2'></rect><line x1='3' y1='12' x2='21' y2='12'></line></svg>",
                "grid_2x2": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='3' width='18' height='18' rx='2' ry='2'></rect><line x1='12' y1='3' x2='12' y2='21'></line><line x1='3' y1='12' x2='21' y2='12'></line></svg>",
                "forward": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='13 19 22 12 13 5'></polyline><polyline points='2 19 11 12 2 5'></polyline></svg>",
                "rewind": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='11 19 2 12 11 5'></polyline><polyline points='22 19 13 12 22 5'></polyline></svg>",
                "trash": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#ff3333' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'></path><line x1='10' y1='11' x2='10' y2='17'></line><line x1='14' y1='11' x2='14' y2='17'></line></svg>",
                "warning": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#eab308' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z'></path><line x1='12' y1='9' x2='12' y2='13'></line><line x1='12' y1='17' x2='12.01' y2='17'></line></svg>",
                "calendar": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line></svg>",
                "prev_day": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='15 18 9 12 15 6'></polyline></svg>",
                "next_day": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='9 18 15 12 9 6'></polyline></svg>",
                "calendar_select": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line><path d='M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01'></path></svg>",
                "today": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line><circle cx='12' cy='16' r='2' fill='#00f5d4'></circle></svg>",
                "refresh_recordings": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='M23 4v6h-6'></path><path d='M20.49 15a9 9 0 1 1-2.12-9.36L23 10'></path></svg>",
                "zoom_1h": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 14 14' opacity='0.4'></polyline><text x='12' y='15.5' font-family='sans-serif' font-size='9.5' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>1h</text></svg>",
                "zoom_8h": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 14 14' opacity='0.4'></polyline><text x='12' y='15.5' font-family='sans-serif' font-size='9.5' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>8h</text></svg>",
                "zoom_24h": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'></rect><line x1='16' y1='2' x2='16' y2='6'></line><line x1='8' y1='2' x2='8' y2='6'></line><line x1='3' y1='10' x2='21' y2='10'></line><text x='12' y='18' font-family='sans-serif' font-size='8.5' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>24h</text></svg>",
                "timeline_center": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><circle cx='12' cy='12' r='3'></circle><line x1='12' y1='1' x2='12' y2='4'></line><line x1='12' y1='20' x2='12' y2='23'></line><line x1='1' y1='12' x2='4' y2='12'></line><line x1='20' y1='12' x2='23' y2='12'></line></svg>",
                "speed_1x": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><text x='12' y='16' font-family='sans-serif' font-size='10.5' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>1x</text></svg>",
                "speed_2x": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><text x='12' y='16' font-family='sans-serif' font-size='10.5' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>2x</text></svg>",
                "speed_4x": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><text x='12' y='16' font-family='sans-serif' font-size='10.5' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>4x</text></svg>",
                "download": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><path d='M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'></path><polyline points='7 10 12 15 17 10'></polyline><line x1='12' y1='15' x2='12' y2='3'></line></svg>",
                "jump_back_60": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3a9 9 0 1 0 6.36 2.64'></path><polyline points='12 7 12 3 8 3'></polyline><text x='12' y='15' font-family='sans-serif' font-size='9' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>60</text></svg>",
                "jump_back_45": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3a9 9 0 1 0 6.36 2.64'></path><polyline points='12 7 12 3 8 3'></polyline><text x='12' y='15' font-family='sans-serif' font-size='9' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>45</text></svg>",
                "jump_back_15": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3a9 9 0 1 0 6.36 2.64'></path><polyline points='12 7 12 3 8 3'></polyline><text x='12' y='15' font-family='sans-serif' font-size='9' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>15</text></svg>",
                "jump_forward_15": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3a9 9 0 1 1-6.36 2.64'></path><polyline points='12 7 12 3 16 3'></polyline><text x='12' y='15' font-family='sans-serif' font-size='9' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>15</text></svg>",
                "jump_forward_45": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3a9 9 0 1 1-6.36 2.64'></path><polyline points='12 7 12 3 16 3'></polyline><text x='12' y='15' font-family='sans-serif' font-size='9' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>45</text></svg>",
                "jump_forward_60": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3a9 9 0 1 1-6.36 2.64'></path><polyline points='12 7 12 3 16 3'></polyline><text x='12' y='15' font-family='sans-serif' font-size='9' font-weight='bold' fill='#00f5d4' stroke='none' text-anchor='middle'>60</text></svg>",
                "timeline": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline></svg>",
                "timeline_show": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline></svg>",
                "timeline_hide": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='#00f5d4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><polyline points='12 6 12 12 16 14'></polyline><line x1='4' y1='4' x2='20' y2='20'></line></svg>"
            };
            var svg = svgs[n];
            if (!svg) return "";
            var base64 = Qt.btoa(svg);
            return "<img src='data:image/svg+xml;base64," + base64 + "' width='16' height='16' align='middle' />";
        }
        
        // Normalise line endings
        var content = md.replace(/\r\n/g, "\n").replace(/\n{3,}/g, "\n\n");
        
        // Escape HTML special characters to prevent QML parsing errors
        var html = content
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;");
            
        // Replace {ICON:name} placeholders with base64 embedded SVGs
        html = html.replace(/\{ICON:(.*?)\}/g, function(match, iconName) {
            return getIconHtml(iconName);
        });
            
        // Headers: # Header -> <h1>Header</h1> (lower margins to fix chapter spacing)
        html = html.replace(/^#\s+(.+)$/gm, "<h1 style='color: #00f5d4; font-size: 18px; font-weight: bold; margin-top: 14px; margin-bottom: 6px;'>$1</h1>");
        html = html.replace(/^##\s+(.+)$/gm, "<h2 style='color: #00f5d4; font-size: 15px; font-weight: bold; margin-top: 12px; margin-bottom: 4px;'>$1</h2>");
        html = html.replace(/^###\s+(.+)$/gm, "<h3 style='color: #ff7a00; font-size: 12px; font-weight: bold; margin-top: 10px; margin-bottom: 2px;'>$1</h3>");
        
        // Bold: **text** -> <b>text</b>
        html = html.replace(/\*\*(.*?)\*\*/g, "<b>$1</b>");
        
        // Markdown Links: [text](#link) -> <a href='#link'>text</a>
        html = html.replace(/\[(.*?)\]\((.*?)\)/g, "<a href='$2' style='color: #00f5d4; text-decoration: none; font-weight: bold;'>$1</a>");
        
        // Code blocks: ```bash ... ``` -> <pre>...</pre>
        html = html.replace(/```(?:bash|js|json)?([\s\S]*?)```/g, "<pre style='background-color: #141a21; color: #eeeeee; padding: 8px; border-radius: 4px; font-family: monospace; line-height: 130%;'>$1</pre>");
        
        // Inline code: `code` -> <code>code</code>
        html = html.replace(/`(.*?)`/g, "<code style='background-color: #141a21; color: #ff7a00; padding: 1px 3px; border-radius: 2px; font-family: monospace;'>$1</code>");
        
        // Numbered lists: 1. item -> <div style='color: #eeeeee; margin-left: 12px; margin-bottom: 3px;'>1. item</div>
        html = html.replace(/^\s*(\d+)\.\s+(.+)$/gm, "<div style='color: #eeeeee; margin-left: 12px; margin-bottom: 3px;'>$1. $2</div>");

        // Bullet lists: * item or - item -> <li>item</li>
        html = html.replace(/^\s*[\*\-]\s+(.+)$/gm, "<li style='color: #eeeeee; margin-left: 12px; margin-bottom: 3px;'>$1</li>");
        
        // Horizontal rule: --- -> <hr>
        html = html.replace(/^---$/gm, "<hr style='border: none; border-top: 1px solid #2a3540; margin: 10px 0;'/>");
        
        // Tighten paragraph line breaks (single <br/> for \n\n instead of double)
        html = html.replace(/\n\n/g, "<br/>");
        
        // Clean up redundant breaks around headers, code blocks and horizontal rules
        html = html.replace(/(<\/h[1-3]>|<\/pre>|<hr[^>]*\/?>)\s*(?:<br\s*\/?>\s*)+/gi, "$1");
        html = html.replace(/(?:<br\s*\/?>\s*)+(<h[1-3][^>]*>|<pre[^>]*>|<hr[^>]*\/?>)/gi, "$1");
        
        return html;
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        anchors.margins: 20
        clip: true

        Text {
            id: instructionsText
            width: scroll.width - 24
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            color: "#eeeeee"
            font {
                pixelSize: 13
                family: "sans-serif"
            }
            lineHeight: 1.3
            
            onLinkActivated: {
                var anchor = link;
                if (anchor.indexOf("#") === 0) {
                    anchor = anchor.substring(1);
                }
                anchor = decodeURIComponent(anchor);
                
                var idx = findHeaderIndex(anchor);
                if (idx !== -1) {
                    var ratio = idx / rawMarkdownText.length;
                    scroll.contentItem.contentY = ratio * (scroll.contentItem.contentHeight - scroll.height);
                }
            }
        }
    }
}
