# Benutzerhandbuch für KVision

> [!NOTE]
> Diese Bedienungsanleitung wurde mithilfe künstlicher Intelligenz (KI) automatisch übersetzt und formatiert.

**KVision** ist eine fortschrittliche Desktop-Anwendung der VMS-Klasse (Video Management System), die für die gleichzeitige Anzeige von Live-Videostreams (RTSP/ONVIF) und die Integration mit Hikvision NVR/DVR-Rekordern (sowohl im Live-Modus als auch im Wiedergabe-Archivmodus) entwickelt wurde.

Das Programm wurde auf Stabilität, reibungslosen Betrieb (60 FPS) und minimalen Systemressourcenverbrauch optimiert.

---

## Inhaltsverzeichnis
1. [Beschreibung der Schaltflächenaktionen](#1-description-of-button-actions)
2. [Installation und Start](#2-installation-and-launching)
3. [NVR/DVR-Recorder verwalten](#3-managing-nvrdvr-recorders)
4. [Live-Ansicht und Viewport-Overlays](#4-live-view-and-viewport-overlays)
5. [Bildschirmlayouts, Voreinstellungen und Symbolleiste](#5-screen-layouts-presets-and-toolbar)
6. [Systemstatistik-Panel (Systemstatistiken)](#6-system-statistics-panel-system-stats)
7. [Archiv-Player wiedergeben](#7-playback-archive-player)
8. [Aufnahmen herunterladen (Downloader)](#8-downloading-recordings-downloader)
9. [Erweiterte Einstellungen und Anpassung im Optionsfenster](#9-advanced-settings-and-customization-in-options-window)
10. [Tastaturkürzel und Maussteuerung](#10-keyboard-shortcuts-and-mouse-controls)
11. [Schnappschüsse erstellen und Pfadkonfiguration](#11-taking-snapshots-and-path-configuration)

---

## 1. Beschreibung der Tastenaktionen

In diesem Abschnitt wird die Bedeutung aller in der Anwendung verwendeten grafischen Symbole und Schaltflächen beschrieben.

### Obere Symbolleiste
* {ICON:quit} **Fenster schließen**: Fordert zur Bestätigung auf und schließt das aktive Fenster oder die aktive Anwendung.
* {ICON:pin} **Leiste anheften**: Sperrt die obere Leiste im erweiterten Zustand oder ermöglicht das automatische Reduzieren.
* {ICON:fullscreen} **Vollbild**: Schaltet das aktive Fenster in den Vollbildmodus.
* {ICON:minimize} **Minimieren**: Minimiert das Anwendungsfenster auf die System-Taskleiste.
* {ICON:options} **Optionen**: Öffnet oder schließt das Fenster mit den Konfigurationsoptionen (Einstellungen und Rekorder).
* {ICON:new_window} **Neues Fenster**: Öffnet ein neues, unabhängiges Hilfsfenster für Kamerastreams.
* {ICON:archive} **Archiv**: Öffnet das Archivfenster der Wiedergabeaufzeichnungen (Zeitleiste und Kalender).
* {ICON:instructions} **Anweisungen**: Öffnet dieses Benutzerhandbuch und das Fenster für technische Hilfe.
* {ICON:stats} **Statistik**: Schaltet das verschiebbare Systemstatistikfenster um (CPU, RAM, GPU, Netz).
* {ICON:lock} **Rastersperre**: Deaktiviert Anpassungen der Rasterteilung, um Ihr aktives Layout zu schützen.
* {ICON:hamburger} **Weitere Optionen**: Öffnet die verschiebbare Toolbox für erweiterte Unterteilungsgrößen, Verhältnisse und Zellenzusammenführung.

### Ansichtsfenster-Overlays (Kameras)
* {ICON:snapshot} **Schnappschuss**: Erfasst ein verlustfreies Bild in voller Auflösung und speichert es als JPEG-Datei.
* {ICON:play} **Kameraarchiv**: Startet das Timeline-Wiedergabefenster für diese Kamera (15 Minuten rückwärts).
* {ICON:quick_play} **Schnelle Wiedergabe (Miniplayer)**: Startet eine Archivwiedergabe der letzten 30 Minuten im Ansichtsfenster, sodass Sie aktuelles Filmmaterial direkt in der Kamerakachel schnell überprüfen können, ohne die Live-Ansicht zu verlassen.
* {ICON:grid_1x1} **Versuchen Sie es mit 1:1**: Zeigt den Videostream in seiner ursprünglichen, nativen Auflösung ohne Dehnung an.
* {ICON:zoom_in} **Interaktiver Zoom**: Schaltet die Vergrößerung durch Klicken und Ziehen für einen ausgewählten Auswahlbereich um.
* {ICON:zoom_out} **Zoom zurücksetzen**: Setzt die digitale Vergrößerung zurück und stellt das volle Sichtfeld der Kamera wieder her.
* {ICON:speaker_unmute} **Audio stumm schalten**: Stellt einen nicht stummgeschalteten Audiostream dar; Wenn Sie darauf klicken, wird der Stream stummgeschaltet.
* {ICON:speaker_mute} **Stummschaltung von Audio aufheben**: Stellt einen stummgeschalteten Audiostream dar; Wenn Sie darauf klicken, wird die Stummschaltung des Streams aufgehoben.

### Steuerelemente für das Wiedergabefenster

**Bedienelemente in der oberen Leiste:**
* {ICON:close} **Schließen**: Schließt das Wiedergabearchiv-Player-Fenster.
* {ICON:pin} **Leiste anheften**: Sperrt die obere Leiste im erweiterten Zustand oder ermöglicht das automatische Reduzieren.
* {ICON:fullscreen} **Vollbild**: Schaltet das Wiedergabefenster in den Vollbildmodus um.
* {ICON:sidebar} **Seitenleiste anzeigen/ausblenden**: Schaltet die Sichtbarkeit der linken Seitenleiste mit Kameras und Rekordern um.
* {ICON:timeline_show} / {ICON:timeline_hide} **Zeitleiste anzeigen/ausblenden**: Zeigt das untere Bedienfeld mit der Zeitleiste und den Wiedergabesteuerungen an oder blendet es aus.
* {ICON:video_folder} **Videoordner**: Öffnet den lokalen Systemordner mit heruntergeladenen Videoclips.
* {ICON:photo_folder} **Snapshot-Ordner**: Öffnet den lokalen Systemordner mit den erfassten Snapshots.
* Rasterschaltflächen `1x1`, `1x2`, `2x1`, `2x2`: Schaltet das Kameraanzeigelayout des Wiedergabefensters auf 1, 2 (vertikal/horizontal) oder 4 gleichzeitige Ansichten um.

**Bedienelemente für die untere Leiste und die Zeitleiste:**
* {ICON:prev_day} **Vorheriger Tag**: Navigiert zu Aufzeichnungen des vorherigen Kalendertages.
* {ICON:calendar_select} **Datumsauswahl**: Öffnet einen Kalenderdialog, um ein bestimmtes Datum für die Wiedergabe auszuwählen.
* {ICON:next_day} **Nächster Tag**: Navigiert zu Aufzeichnungen des nächsten Kalendertages.
* {ICON:today} **Heute**: Verschiebt den Wiedergabefokus sofort auf den aktuellen Kalendertag.
* {ICON:refresh_recordings} **Aufzeichnungen aktualisieren**: Aktualisiert verfügbare Aufzeichnungssegmente vom Gerät und fragt sie erneut ab.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Timeline-Zoom-Voreinstellungen**: Skaliert das sichtbare Fenster der Timeline (auf 1 Stunde, 8 Stunden oder 24 Stunden) für eine hochpräzise Navigation.
* {ICON:timeline_center} **Zeitleiste zentrieren**: Zentriert die Zeitleistenansicht genau um den aktuellen Wiedergabezeitstempel.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Wiedergabegeschwindigkeit**: Passt den Videowiedergabemultiplikator an (Standard 1x Geschwindigkeit, 2x beschleunigte oder 4x schnelle Wiedergabe).
* {ICON:download} **Herunterladen**: Öffnet das Download-Tool zum Exportieren eines definierten Videosegments vom Gerät.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Rückwärts springen**: Spult den Wiedergabezeitstempel um 60, 45 oder 15 Sekunden zurück.
* {ICON:play} / {ICON:pause} **Wiedergabe / Pause**: Startet oder pausiert die Wiedergabe des Archivvideostreams.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Vorwärts springen**: Verschiebt den Wiedergabezeitstempel um 15, 45 oder 60 Sekunden.

**Andere Diagnose- und allgemeine Symbole:**
* {ICON:calendar} **Kalender**: Stellt Kalender-/Terminplanungskonfigurationen dar.
* {ICON:clock} **Zeit**: Stellt die Uhr oder zeitliche Statusanzeigen dar.
* {ICON:zoom} **Zoom**: Stellt Skalierungs- oder Digitalzoomkonfigurationen dar.
* {ICON:timeline_toggle} **Timeline-Umschaltung**: Stellt das Umschalten oder Aktualisieren chronologischer Ansichten dar.
* {ICON:trash} **Löschen**: Entfernt konfigurierte Rekorder oder Layouts sicher mit Bestätigung.
* {ICON:warning} **Warnung**: Wird in Dialogfeldern für irreversible Aktionen oder Löschwarnungen angezeigt.

---

## 2. Installation und Start

### Installation unter Arch Linux (Pacman)
Um das Programm aus dem vorbereiteten Binärpaket zu installieren, gehen Sie in das Verzeichnis `packaging/arch/` und führen Sie Folgendes aus:
```bash
sudo pacman -U kvision-2.6.3-1-x86_64.pkg.tar.zst
```
Das Paket installiert automatisch das Programm, die Aktivierungsdatei `.desktop` und die erforderlichen Hikvision SDK-Bibliotheken im Systempfad `/usr/lib/kvision`.

### Manuelle Kompilierung (aus Quellcode)
Wenn Sie das Programm manuell kompilieren möchten (z. B. auf einer anderen Linux-Distribution), anstatt das vorgefertigte Paket zu verwenden:

1. Installieren Sie die erforderlichen Build- und Laufzeitabhängigkeiten mit Ihrem Paketmanager. Für Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Konfigurieren Sie das Projekt mit CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Kompilieren Sie den Code:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installieren Sie die Anwendung im System:
   ```bash
   sudo cmake --install build
   ```

### Start
Das Programm kann über das Systemmenü oder durch Eingabe im Terminal gestartet werden:
```bash
kvision
```

### Fehlerbehebung bei der Systemskalierung (KDE Plasma)

Ab Version 2.4.4 erkennt KVision die in den KDE-Plasma-Einstellungen konfigurierte fraktionierte Desktop-Skalierung (z. B. 125 %, 145 %, 150 %) automatisch und wendet sie korrekt an, indem in Qt native Pass-Through-Richtlinien für hohe DPI erzwungen werden. Die Benutzeroberfläche sollte nun sofort und ohne manuelle Eingriffe korrekt skaliert werden.

#### Native Wayland-Unterstützung

Um das beste Skalierungserlebnis und die beste Leistung unter Wayland zu gewährleisten, stellen Sie sicher, dass das optionale Paket `qt5-wayland` auf Ihrem System installiert ist. Dadurch kann KVision nativ auf Wayland ausgeführt werden, anstatt auf XWayland zurückzugreifen.

Für Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Für Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Manuelle Skalierungsüberschreibung (Legacy/Fallback)

Wenn Sie eine ältere Version oder eine ungewöhnliche Konfiguration ausführen oder einfach manuell einen anderen Skalierungsfaktor als der Rest des Systems erzwingen möchten, können Sie die Anwendungsskalierung immer noch mithilfe von Umgebungsvariablen überschreiben.

Um beispielsweise eine Skalierung von **150 %** zu erzwingen, starten Sie die Anwendung vom Terminal aus mit:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Sie können dies dauerhaft anwenden, indem Sie den Anwendungsstarter `kvision.desktop` im KDE-Menüeditor bearbeiten und diese Variablen zum Feld „Umgebungsvariablen“ hinzufügen.*

---

## 3. NVR/DVR-Rekorder verwalten

So konfigurieren Sie die Verbindung zu einem Hikvision-Recorder:
1. Öffnen Sie das Optionsfenster und gehen Sie zur Registerkarte **Rekorder** (Serversymbol).
2. Geben Sie die Gerätezugriffsdaten ein:
   * **IP-Adresse**: Die Netzwerkadresse des Rekorders.
   * **Port**: Der SDK-Netzwerkport (Standard ist `8000`).
   * **Benutzername**: Benutzername (z. B. `admin`).
   * **Passwort**: Passwort für den Zugriff auf den Rekorder.
3. Klicken Sie auf **Verbinden und entdecken** (oder **Speichern und aktualisieren**).
4. Bei erfolgreicher Verbindung erkennt die Anwendung automatisch alle aktiven Kameras (Kanäle), die mit dem NVR/DVR verbunden sind, und fügt sie der Liste hinzu.
5. Durch Klicken auf die Schaltfläche **Raster generieren** wird automatisch ein Ansichtsfenster-Layout (Voreinstellung) erstellt, das alle aktiven Kameras dieses NVR in einem optimalen Raster-Layout enthält.
6. **Kameralisten anzeigen (NvrCamerasWindow)**: Durch Klicken auf die Computermonitor-Symbolschaltfläche auf der Karte eines Rekorders wird ein spezielles Fenster geöffnet, in dem alle erkannten Kamerakanäle als interaktive Kacheln angezeigt werden.
7. **Miniaturansichten generieren (Miniaturansichten generieren)**: Im Listenfenster der NVR-Kameras ist die Schaltfläche *„Miniaturansichten generieren“* verfügbar. Wenn Sie darauf klicken, wird die Anwendung angewiesen, einzelne Frames aus dem Substream jedes Kanals im Hintergrund abzurufen und sie als Miniaturansichten für den Kachelhintergrund festzulegen. Dies ermöglicht eine schnelle visuelle Vorschau jeder Kamera, ohne dass vollständige Live-Feeds gestartet werden müssen.
8. **Click-and-Add-Funktion**: Die Anwendung unterstützt das Ziehen von Kacheln (Drag & Drop) aus dem Kameralistenfenster in das Hauptraster nicht. Die Kamerazuweisung erfolgt auf einfache und zuverlässige Weise: Klicken Sie zunächst mit der linken Maustaste auf eine beliebige Ansichtsfensterkachel im Hauptbildschirmraster, um sie auszuwählen (sie wird mit einem hellen Rand hervorgehoben), und klicken Sie dann auf die grüne Schaltfläche **„+“ (Zu aktivem Ansichtsfenster zuweisen)** auf der gewünschten Kamerakachel im NVR-Kameralistenfenster. Der Stream wird sofort in diesem Slot geladen.
9. **SDK-Sitzungsstatus (Punktanzeige)**: Neben der IP jedes Rekorders in der Liste befindet sich ein farbiger Statuspunkt:
   * **Grün (ANGEMELDET)**: Stellt eine aktive Hikvision SDK-Sitzung dar, die für die PTZ-Steuerung, Timeline-Archivierungsanfragen und das Herunterladen erforderlich ist.
   * **Rot (NICHT ANGEMELDET)**: Derzeit ist keine aktive SDK-Sitzung eingerichtet (z. B. vor der ersten SDK-Anfrage oder nach der manuellen/automatischen Abmeldung). Beachten Sie, dass RTSP-Live-Feeds der Kamera unabhängig vom SDK-Sitzungsstatus weiterhin abgespielt werden.
10. **Umbenennen lokaler Kameras**: Klicken Sie auf einer beliebigen Kamerakachel in der NVR-Kameraliste auf das Symbol **Bearbeiten** (Bleistift). Dadurch wird ein Dialog geöffnet, in dem Sie einen benutzerdefinierten Namen für die Kamera festlegen können. Dieser Name wird lokal gespeichert und sofort in den Live-Playern, der Zeitleiste und den Kachelansichten aktualisiert, ohne dass das physische NVR-Gerät geändert werden muss. Sie können ihn jederzeit auf den Standardnamen zurücksetzen.
11. **Entfernen eines Rekorders aus der Liste**: Neben jedem konfigurierten Rekorder in der Liste gibt es eine rote Mülltonnen-Schaltfläche. Wenn Sie darauf klicken, wird ein zweistufiges Sicherheitsprotokoll gestartet, das ein versehentliches Löschen verhindern soll:
    * **Schritt 1 (Bestätigung)**: Ein Dialogfeld mit dem Titel *„Löschen des NVR bestätigen“* erscheint und fragt Sie, ob Sie den Rekorder wirklich löschen möchten.
    * **Schritt 2 (Warnung)**: Ein zweiter Warndialog mit dem Titel *„Warnung!“* erscheint und fragt Sie, ob Sie absolut sicher sind und wissen, was Sie tun.
    * **Auswirkung des Löschens**: Beim Akzeptieren der zweiten Warnung meldet sich das Programm im Hintergrund von diesem NVR ab, löscht seinen Eintrag aus der Anwendungskonfiguration und **durchsucht automatisch die Liste der voreingestellten Layouts** und entfernt alle für dieses NVR-Gerät generierten dynamischen Raster.

---

## 4. Live-Ansicht und Viewport-Overlays

Das Hauptfenster des Programms zeigt den Live-Feed an:
* **Kameraraster**: Zeigt RTSP-Streams oder Feeds direkt vom Hikvision SDK an.
* **Stream-Qualitätsauswahl**: Durch Klicken mit der rechten Maustaste auf ein Kameraansichtsfenster können Sie den **Hauptstream** für die höchste Auflösung oder den **Substream** auswählen, um die Netzwerk- und Grafikkartenlast zu reduzieren.
* **Doppelklick-Vollbild-Umschaltung**: Ein Doppelklick mit der linken Maustaste auf ein beliebiges Kamera-Ansichtsfenster maximiert es sofort, um den gesamten aktiven Fensterbereich auszufüllen (Einzelansicht-Vollbild). Durch erneutes Doppelklicken wird das ursprüngliche Multikamera-Rasterlayout wiederhergestellt.
* **Obere Leiste automatisch ausblenden**: Die Symbolleiste mit den oberen Optionen (topToolBar) kann automatisch bis zum oberen Rand des Bildschirms ausgeblendet werden, wenn der Mauszeiger ihren Bereich verlässt (diese Option kann in den Einstellungen -> *„Obere Leiste automatisch einblenden“* oder direkt über das Stecknadelsymbol in der oberen Leiste konfiguriert werden).
* **Mehrere Monitore und Hilfsfenster**: Sie können unabhängige zusätzliche (Hilfs-)Fenster öffnen, um verschiedene Rasterlayouts gleichzeitig auf mehreren Bildschirmen oder Monitoren auszuführen. Um ein neues Fenster zu öffnen, verwenden Sie die Tastenkombination `Ctrl+N` oder klicken Sie auf die Schaltfläche **Neues Fenster** in der oberen Symbolleiste des Hover-Slides. Jedes Fenster kann mit seiner eigenen Rastergröße und dem ausgewählten voreingestellten Layout konfiguriert werden. Um maximale Stabilität bei Konfigurationen mit mehreren Monitoren zu gewährleisten, werden alle Fenster streng zentriert auf dem primären Display mit 90 % seiner Auflösung gestartet.

### Ansichtsfenster-Overlay-Schaltflächen
In der unteren rechten Ecke jeder Kamerakachel/jedem Kameraansichtsfenster wird ein Bedienfeld mit fünf Funktionssymbolen angezeigt, wenn Sie mit dem Mauszeiger darüber fahren (abhängig von den Benutzeroberflächeneinstellungen):
1. **Kamerasymbol (Schnappschuss)**: Ermöglicht die Erstellung eines Screenshots aus dem Kamera-Feed. Der Schnappschuss wird in der vollen, nativen Auflösung des Streams direkt aus dem Frame-Puffer des Decoders gespeichert, wodurch Verluste aufgrund der aktuellen Größe der Viewport-Kachel oder der Skalierung der Bildschirmauflösung vermieden werden. Das erfolgreiche Speichern des Schnappschusses wird dadurch bestätigt, dass das Kamerasymbol genau 1 Sekunde lang orange blinkt (`#ff7a00`).
2. **Abspielsymbol (Archiv)**: Wird zum schnellen Öffnen des Aufzeichnungsarchivs verwendet. Durch Klicken auf diese Schaltfläche wird automatisch die Zeitleiste `PlaybackWindow` für diese bestimmte Kamera gestartet und die Wiedergabe **genau 15 Minuten vor der aktuellen Systemzeit** gestartet (ein praktischer schneller Rückwärtsversatz).
3. **Rundpfeilsymbol (Schnellwiedergabe/Miniplayer)**: Aktiviert eine schnelle Wiedergabe von Kameraarchivaufzeichnungen der letzten 30 Minuten im Ansichtsfenster direkt in der Kamerakachel, ohne das Live-Raster zu verlassen oder das vollständige Archivfenster zu starten.
   * **Bedienfeld**: Wenn es aktiviert ist, erscheint am unteren Rand des Ansichtsfensters ein verschiebbares Bedienfeld mit Folgendem:
     * **Play/Pause**: Pausiert oder setzt den Wiedergabestream fort.
     * **Zeit- und Offset-Anzeige**: Zeigt den aktuellen Wiedergabezeitstempel und sein relatives Alter im Vergleich zur Echtzeit an (z. B. steht `-12:34` für die Zeit vor 12 Minuten und 34 Sekunden).
     * **Interaktiver Timeline-Schieberegler**: Ermöglicht das Klicken oder Ziehen, um irgendwo innerhalb des 30-Minuten-Puffers zu suchen. Verfügbare Aufnahmesegmente werden mit einem blaugrünen Hintergrund hervorgehoben und ein roter Abspielkopf markiert die aktuelle Position.
     * **Geschwindigkeitsmultiplikator**: Wechselt zwischen den Wiedergabegeschwindigkeiten (`1x`, `2x` und `4x`), um Filmmaterial schnell zu scannen.
     * **Schließen (✕)**: Schließt den Miniplayer und kehrt sofort zum Live-Feed zurück.
   * **Unterstützung für schwenkbaren Zoom**: Genau wie in der Live-Ansicht können Sie das Lupenwerkzeug verwenden, um in einen Bereich des Miniplayers hineinzuzoomen, oder die mittlere Maustaste gedrückt halten und ziehen, um herumzuschwenken.
4. **1:1-Symbol (native Skalierung)**: Schaltet den Pixel-zu-Pixel-Videoanzeigemodus um. Wenn diese Option aktiviert ist, wird das Video nicht gestreckt oder verzerrt, um die Kachelgrenzen auszufüllen, sondern wird stattdessen zentriert und in seiner ursprünglichen nativen Auflösung angezeigt. Wenn dieser Modus aktiv ist, werden der Button-Hintergrund und der „1:1“-Text in leuchtendem Neonlicht-Türkis hervorgehoben.
5. **Lupensymbol (interaktiver Zoom)**: Ermöglicht das Vergrößern eines bestimmten Bereichs des Video-Feeds:
   * **Aktivierung**: Durch Klicken auf das Symbol wird es in den aktiven Zustand versetzt (türkise Hervorhebung). Der Cursor ändert seine Form und ein Tooltip weist darauf hin: *„Zum Zoomen auf den Kamera-Feed klicken und ziehen“*.
   * **Vorgang**: Klicken Sie mit der linken Maustaste und ziehen Sie einen rechteckigen Auswahlbereich über den Live-Feed. Das Ansichtsfenster schneidet und skaliert den ausgewählten Bereich automatisch, um die gesamte Kachel auszufüllen.
     * **Proportionaler Zoom**: Halten Sie die **Umschalttaste** gedrückt, während Sie das Zoomrechteck zeichnen, um zu erzwingen, dass die Auswahl im Seitenverhältnis 16:9 fixiert wird, das streng auf die Grenzen des Ansichtsfensters beschränkt ist.
     * **Schwenken des gezoomten Bildes (Pan Zoom)**: Nach dem Vergrößern können Sie die **mittlere Maustaste (Scrollrad)** gedrückt halten und den Cursor ziehen, um die vergrößerte Ansicht frei um das Videosichtfeld zu schwenken. Dies funktioniert in der Live-Ansicht, im Wiedergabearchiv und im Mini-Player.
   * **Zurücksetzen**: Beim Zoomen ändert das Lupensymbol sein Symbol (roter Rand mit Minuszeichen). Wenn Sie darauf klicken, wird der Zoom sofort zurückgesetzt und Sie kehren zum vollständigen Kamerabild zurück.

---

## 5. Bildschirmlayouts, Voreinstellungen und Symbolleiste

Mit Layouts können Sie die Anordnung der Kameras auf dem Bildschirm organisieren. Auf der Registerkarte **Voreinstellungen** (Sternsymbol) können Sie:
* **Neue Voreinstellungen erstellen**: Fügen Sie Ihr eigenes Layout mit einer beliebigen Konfiguration von Spalten und Zeilen hinzu (z. B. 2x2, 3x3, 4x4).
* **Kameras zuweisen**: Klicken Sie auf ein Ansichtsfenster im Rasterlayout, um es auszuwählen, öffnen Sie dann das Fenster der NVR-Kameras und klicken Sie auf der gewünschten Kamerakachel auf die Schaltfläche **„+“ (Hinzufügen)**. Sie können die Ansichtsfensterpositionen auch austauschen, indem Sie mit der rechten Maustaste auf das Kontextmenü (*„Zamień miejscami”* / *„Swap viewports”*) des Quellansichtsfensters klicken und dann auf das Zielansichtsfenster klicken.

### Schaltflächen der oberen Leiste (obere Symbolleiste)
Die obere verschiebbare Symbolleiste bietet einen umfassenden Satz an Navigations- und Anwendungssteuerungsschaltflächen:
1. **Fenster schließen (rote ✕-Schaltfläche)**: Schließt das aktive Fenster. Um versehentliche Klicks zu verhindern, fängt es das Schließereignis ab und fordert Sie in einem Dialogfeld auf, das Beenden der Anwendung zu bestätigen.
2. **Pin-Schaltfläche**: Steuert das automatische Ausblenden der oberen Symbolleiste. Wenn der Stift senkrecht zeigt (gepinnter Zustand), ist die Leiste arretiert und bleibt dauerhaft sichtbar. Wenn der Pin um -45 Grad gedreht wird (nicht fixierter Zustand), verschiebt sich die Leiste automatisch nach oben aus dem Sichtfeld, wenn die Maus ihren Bereich verlässt.
3. **Vollbild (Symbol mit grünen Pfeilen)**: Schaltet das aktive Fenster sofort in den Vollbildmodus und zurück. Im Vollbildmodus zeigen die Pfeile nach innen (verkleinern), im Fenstermodus nach außen (erweitern).
4. **Minimieren (Cyan-Minimierungssymbol)**: Minimiert das Anwendungsfenster auf die Taskleiste. Durch die Wiederherstellung wird das Fenster wieder in seinen genauen vorherigen Zustand zurückversetzt (z. B. maximiert oder Vollbild).
5. **⚙️ OPTIONEN (OPCJE)**: Schaltet das Fenster mit den Konfigurationsoptionen um. Wenn das Fenster bereits geöffnet ist, wird es durch Klicken auf diese Schaltfläche geschlossen.
6. **📺 NEUES FENSTER (JETZT OK NEIN)**: Öffnet einen neuen, unabhängigen und vollständig konfigurierbaren `Auxiliary Window`, der sich perfekt zum Erweitern Ihrer Kameralayouts auf mehrere Monitorkonfigurationen eignet.
7. **ARCHIV**: Öffnet einen leeren `PlaybackWindow` (Aufzeichnungsplayer) mit aktiver Zeitleiste und Kalender und ermöglicht die manuelle Auswahl von Streams und Kamerakanälen von jedem konfigurierten NVR über die Seitenleistenliste.
8. **ANWEISUNGEN (INSTRUKCJA)**: Öffnet dieses Handbuchfenster und lädt die vollständige Benutzerdokumentation in Englisch oder Polnisch, abhängig von Ihrem aktiven Gebietsschema.
9. **📊 STATYS (STATYSTYKI)-Schalter**: Kippschalter, um das Systemstatistik-Überwachungsfeld vom linken Bildschirmrand herauszuschieben.
10. **Rastersperrschalter (Vorhängeschloss):**: Wenn dieser Schalter eingeschaltet ist (in leuchtendem Orange hervorgehoben), werden Aktionen zur Größenänderung des Rasters auf den angrenzenden Rasterschaltflächen deaktiviert und so Ihr aktives Kameralayout vor versehentlichen Änderungen geschützt.
11. **Rastergrößenauswahl (von 1x1 bis 9x9):**: Eine Reihe von neun Schaltflächen, mit denen Sie sofort die Zeilen- und Spaltenstruktur Ihres Ansichtsfensters definieren können (von einer 1x1-Ansicht mit einer einzelnen Kamera bis zu 81 gleichzeitigen Kamera-Feeds in einem 9x9-Layout). Die aktuell aktive Größe wird in leuchtendem Orange hervorgehoben.
12. **Weitere Optionen (Hamburger-Menü mit drei Zeilen)**: Schaltfläche zum Öffnen der verschiebbaren `Layout & Grid Tools`-Toolbox für erweiterte Rasteroptimierung, Geometrieanpassungen und Debugging-Optionen (siehe unten).
13. **Voreinstellungs-/Ansichtsschaltflächen**: Dynamisch gerenderte Schaltflächen auf der rechten Seite der Symbolleiste, die Ihre konfigurierten und sichtbaren voreingestellten Layouts darstellen (z. B. *📹 NVR*, *Ansicht 1* usw.). Durch Klicken auf eine Schaltfläche wird das Raster sofort umgeschaltet. Der aktive Blick wird in hellem Hell-Türkis hervorgehoben.

### Erweiterte Rasteranpassung und -verhältnisse (Layout- und Rastertools)
Wenn Sie das Hamburger-Menü (Weitere Optionen) öffnen, wird eine spezielle Layout-Toolbox angezeigt. So aktivieren Sie die Steuerelemente:
1. **Werkzeugbereich entsperren**: Schalten Sie den Schalter „Werkzeugbereich entsperren“ ganz oben um. Dies ist eine explizite Sicherheitsmaßnahme, um versehentliche Änderungen an komplexen Layouts zu verhindern.
2. **Benutzerdefinierte Fensteraufteilung (F2 oder gedrückt halten)**: In der Toolbox werden Rasterteilungsschaltflächen von 1x1 bis 9x9 angezeigt. Eine äußerst erweiterte Funktion ist die Möglichkeit, **Teilungsgrößen zu überschreiben und zu bearbeiten**. Wenn Sie mit der linken Maustaste auf eine beliebige Rasterschaltfläche klicken und diese gedrückt halten (oder sie fokussieren und **F2** drücken), wird ein Textfeld angezeigt. Sie können eine beliebige benutzerdefinierte oder asymmetrische Unterteilung eingeben (z. B. `2x3`, `1x4` usw.) und die Eingabetaste drücken. Die Schaltfläche wird sofort neu programmiert und durch Klicken darauf wird Ihr benutzerdefiniertes Layout auf das Hauptansichtsfenster angewendet.
3. **Geometrieverhältnisse**: Ermöglicht das Erzwingen bestimmter Seitenverhältnisse für die Rasteranzeige:
   * **16:9-Seitenverhältnis**: Sperrt und skaliert den Rastercontainer auf das Breitbildformat 16:9 (Standard für moderne IP-Kameras).
   * **4:3-Seitenverhältnis**: Passt den Rastercontainer an das traditionelle 4:3-Verhältnis an (üblich bei älteren Analog-/IP-Kameras).
4. **Rasteroperationen (hervorgehobene Zellen zusammenführen)**: Greifen Sie auf die Funktion zum asymmetrischen Zusammenführen von Zellen zu (ausführlich in Abschnitt 9.2).

---

## 6. Systemstatistik-Panel (Systemstatistiken)

Dieses vom linken Rand des Live View-Bildschirms aus verschiebbare Bedienfeld überwacht den Zustand des Computers und die von der Anwendung erzeugte Auslastung:
* **Überwachte Parameter**:
  * **CPU/RAM**: Nutzung des Hauptprozessors (in % aller Kerne) und des RAM, der direkt vom `kvision`-Prozess und seinen zugehörigen Downloader-Unterprozessen verwendet wird.
  * **GPU/VRAM**: Auslastung des Grafikkartenkerns (in %) und die Menge an VRAM-Grafikspeicher, die durch Rendering und Hardware-Decodierung belegt wird (unterstützt die vollständige Auflistung der GPU-Prozesse mithilfe des XML-Parsers von `nvidia-smi`).
  * **NETZWERK (Netto)**: Tatsächliche Download-Übertragungsgeschwindigkeit der Anwendung von allen aktiven Live-Playern, Archiv-Playern und Aufzeichnungs-Download-Prozessen.
* **Multithreading (ruckelfrei)**: Die Prozess- und GPU-Datenerfassung läuft in einem separaten Systemthread (`StatsWorker`). Dies verhindert Mikroruckler bei der Videowiedergabe (keine Frame-Drops).
* **Pin-Funktion**: Durch Klicken auf die Schaltfläche **„Pin“** (Pin-Symbol) wird das Panel im erweiterten Zustand gesperrt.
* **Ästhetik**: Die Diagramme verfügen über helle, neongrüne Ränder, eine Verlaufsfüllung unter der Diagrammkurve und eine ausgewogene Hintergrundtransparenz von 35 %, um die Lesbarkeit des Textes zu gewährleisten.

---

## 7. Archiv-Player wiedergeben

Verfügbar durch Klicken auf das Uhr-/Wiedergabesymbol neben einer bestimmten Kamera oder einem bestimmten Rekorder. Es ermöglicht die gleichzeitige Anzeige archivierter Aufzeichnungen mehrerer Hikvision-Kameras in Vollzeitsynchronisation.

### Zeitleiste und Kontrollen:
* **Schnellstart (15 Minuten zurück)**: Beim Öffnen des Archivs aus der Live-Ansicht startet der Player automatisch ab einem Zeitpunkt, der **genau 15 Minuten vor der aktuellen Systemzeit** liegt (anstatt um Mitternacht zu starten). Dies ermöglicht die sofortige Anzeige eines gerade aufgetretenen Ereignisses.
* **Navigation**: Die Zeitleiste kann durch Ziehen mit der linken Maustaste nach links und rechts gescrollt werden.
* **Zoom (Skalierung)**: Sie können die Zeitleistenskalierung mit dem Mausrad (oder den Zoomtasten) stufenlos ändern – von der Anzeige des gesamten Tages bis hin zu einer präzisen 10-Minuten-Präzisionsansicht.
* **Schnellzoom-Verknüpfungen**: Die untere Steuerleiste verfügt über spezielle kreisförmige Symbolschaltflächen, mit denen Sie die Zeitleistenansicht sofort skalieren können:
  * **„1h“-Symbol**: Vergrößert die Zeitleiste für eine detaillierte Betrachtung über einen Zeitraum von 1 Stunde.
  * **„8h“-Symbol**: Zoomt die Zeitleiste, um eine Zeitspanne von 8 Stunden anzuzeigen.
  * **„24-Stunden“-Symbol**: Setzt den Zoom zurück, um den gesamten 24-Stunden-Tag auf einem einzigen Bildschirm darzustellen.
  * **Symbol „Zentrieren (Ziel)“**: Zentriert die Timeline sofort, sodass sich die rote Wiedergabeanzeige genau in der Mitte des Bildschirms befindet (anstelle der alten Textschaltfläche).
* **Datumsnavigation (Kalender & Tage)**: Steuerelemente neben dem angezeigten Datum ermöglichen schnelle Sprünge:
  * Schaltflächen **„<“ (Vorheriger Tag)** und **„>“ (Nächster Tag)**: Ermöglichen einen sofortigen Sprung um 24 Stunden vor oder zurück, ohne den Kalenderdialog zu öffnen.
  * **Kalendersymbol**: Öffnet das Kalender-Popup zur Auswahl eines bestimmten Datums.
  * **Aktualisierungssymbol**: Erzwingt eine erneute Suche nach Aufzeichnungen. Wenn Sie darauf klicken, wird der lokale Cache der Aufzeichnungsverfügbarkeitssegmente für alle aktiven Kanäle durchsucht und neue Abfragen an den NVR gesendet. Dies ist äußerst nützlich, um Dateien zu laden, die erst vor wenigen Augenblicken aufgezeichnet wurden (und die alte Textschaltfläche ersetzt).
  * **Symbol „Heute“ (heutiges Datum/heutige Zahl)**: Springt sofort zum aktuellen Tag zurück (ersetzt die alte Textschaltfläche).
* **Tastenkürzel für die Wiedergabegeschwindigkeit**:
  * **Symbole „1x“, „2x“ und „4x“**: Ändern Sie sofort den Wiedergabegeschwindigkeitsmultiplikator.
* **VCR-Sprungtasten**:
  * **Symbole „15“, „45“ und „60“ mit kreisförmigen Pfeilen**: Ermöglichen das schnelle Vor- oder Zurückspringen um die angegebene Anzahl von Sekunden.
* **Aufnahmeverfügbarkeitsbalken**: Farbige Balken, die die gefundenen Videosegmente auf der Festplatte des Rekorders darstellen, werden unterhalb der Zeitleiste gerendert. Ein Caching-System verhindert, dass sie beim Ziehen flackern.
* **Auto-Follow (Indikatorverfolgung)**: Der Wiedergabeindikator (vertikale rote Linie) wird ständig überwacht. Wenn der Indikator den sichtbaren Bereich der Zeitleiste verlässt, scrollt die Ansicht automatisch, um ihn zu zentrieren. Diese Option wird beim manuellen Ziehen des Indikators durch den Benutzer intelligent gesperrt.

### Seitenbereich der Kamera im Wiedergabefenster
Eine vertikale Seitenliste am rechten Rand des Players listet alle konfigurierten NVRs und ihre Kamerakanäle auf:
* **Kanäle umschalten**: Durch Klicken auf einen beliebigen Kamerakanal in der Liste wird dieser als aktiver Wiedergabeplatz auf der Timeline hinzugefügt (wodurch ein Videoplayer entsteht). Durch erneutes Klicken wird der Kanal entfernt.
* **Kanal-Kontextmenü**: Wenn Sie mit der rechten Maustaste auf einen aktiven Video-Slot im Wiedergaberaster klicken, wird ein Menü geöffnet, um Folgendes zu tun:
  * Videoqualität umschalten (Hauptstream / Substream).
  * Schließen/entfernen Sie den aktiven Player aus der Archivwiedergabe.

---

## 8. Aufnahmen herunterladen (Downloader)

Im Fenster „Wiedergabearchiv“ können Sie ausgewählte Aufnahmesegmente als MP4-Dateien direkt auf das Laufwerk Ihres Computers herunterladen:
1. Klicken Sie auf das Download-Symbol (Abwärtspfeil) neben der ausgewählten Kamera.
2. Wählen Sie den Zeitbereich (Beginn und Ende der Aufnahme) aus.
3. Wählen Sie den Speicherort der Zieldatei aus.
4. Klicken Sie auf **Herunterladen**.

### Erweiterte Download-Funktionen:
* **Sequentielles Herunterladen von Segmenten (1 GB-Teile)**: Das Programm teilt Ihre Zeitbereichsabfrage automatisch in physische Dateisegmente auf (jeweils etwa 1 GB auf dem NVR-Laufwerk) und lädt sie einzeln herunter und konvertiert sie (unter Verwendung temporärer `.pspart`-Dateien, die direkt in das `.mp4`-Format konvertiert werden). Dies gewährleistet äußerst stabile Downloads über lange Zeiträume ohne Speicherüberlauf oder Hänger der FFmpeg-Konvertierung.
* **Gesamtfortschrittsvisualisierung**: Der Fortschrittsbalken (hellblaue Farbe) zeigt den gesamten Download-Fortschritt für die Kamera in allen Segmenten an. Der dem Fortschrittsbalken überlagerte Statustext zeigt den aktuellen Teil und die Prozentsätze an, z. B. `Downloading part 1 of 3... 45% (Overall: 15%)`, mit einem Umrissstil, um die Lesbarkeit auf jedem Hintergrund zu gewährleisten.
* **IP-Bereinigung von Dateinamen**: Videodateinamen (und Live-/Archiv-Schnappschüsse) werden automatisch von NVR/DVR-IP-Adressen befreit, um sie sauber und für Menschen lesbar zu halten (z. B. `4_Wejscie_glowne_2026-06-15.mp4` anstelle von `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Erweiterte Einstellungen und Anpassung im Optionsfenster

Das Options- und Konfigurationsfenster (`SideBar`) besteht aus sechs speziellen Registerkarten:

### 1. Ansichtsfensterdetails (Monitorsymbol)
Zeigt erweiterte Parameter der aktuell ausgewählten Rasterkachel an. Ermöglicht Ihnen:
* Geben Sie eine benutzerdefinierte **Primäre Stream-URL** (RTSP/ONVIF) und eine **Sekundäre Backup-URL** für manuelle Konfigurationen ein.
* Schalten Sie die Stummschaltung bzw. Aufhebung der Stummschaltung des Audiokanals des ausgewählten Kamera-Feeds um.
* Geben Sie erweiterte Decoder-Überschreibungen in das Textfeld **FFmpeg Options Override** ein.
> [!TIP]
> Für die schnellste Stream-Verbindung und maximale Stabilität über RTSP sind die empfohlenen Parameter:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Layout- und Raster-Tools (Schieberegler-Symbol)
Erweiterte Optionen zur Anpassung des Bildschirmrasters:
* Schnelles Umschalten in den Vollbildmodus.
* **Asymmetrische Zellenzusammenführung (hervorgehobene Zellen zusammenführen)**: Ein hochentwickelter Layout-Editor. Halten Sie **Strg** oder **Umschalt** gedrückt und klicken Sie, um mehrere benachbarte Kacheln im Raster auszuwählen, oder verwenden Sie Ihre Tastatur, indem Sie **Umschalt** gedrückt halten und mit den **Pfeiltasten** navigieren. Klicken Sie dann auf „Hervorgehobene Zellen zusammenführen“, um sie in einem einzigen größeren Ansichtsfenster zusammenzuführen. Auf diese Weise können Sie vollständig benutzerdefinierte asymmetrische Rasterdesigns erstellen (z. B. ein großes Kamerapanel mit kleineren Feeds darum herum).

### 3. Rekorder (Serversymbol)
Vollständiger Konfigurationsmanager für Verbindungen zu Hikvision NVR/DVR-Geräten (ausführlich beschrieben in Abschnitt 3).

### 4. Voreinstellungen (Sternsymbol)
Manager für Ihre gespeicherten Rasterlayouts und Kamerazuweisungen. Ermöglicht das Erstellen leerer Rastervorlagen, das Ändern ihrer Reihenfolge, das Umschalten ihrer Sichtbarkeit in der oberen Leiste (über den Schalter „Sichtbar“) oder deren Aktivierung im aktuellen Fenster.

### 5. Einstellungen (Zahnradsymbol)
Ermöglicht das Anpassen globaler Anwendungseinstellungen:
* **Ausführung mehrerer Instanzen zulassen**: Durch Aktivieren dieses Kontrollkästchens können mehrere parallele Kopien des KVision-Prozesses gestartet werden (standardmäßig werden die Ausführungen auf eine einzelne aktive Instanz beschränkt).
* **Einstellungen für die automatische Minimierung**: Passt das Timing der Gleitanimation für die obere Leiste und das Statistikfeld an.
* **Austauschen von Ansichtsfenstern zulassen**: Mit dem Kontrollkästchen *„Austauschen von Ansichtsfenstern zulassen“* können Sie die Kamerapositionen im Raster im Handumdrehen neu anordnen (Rechtsklick auf Quellkachel -> Wählen Sie „Ansichtsfenster tauschen“ -> Linksklick auf Zielkachel).
* **Rechtsklick-Berechtigungen**: Wechselt zum Sperren/Entsperren interaktiver Steuerelemente im Kontextmenü mit der rechten Maustaste (Kontextmenü aktivieren, Austauschen von Ansichtsfenstern zulassen, Option „Kamera entfernen“ aktivieren, Ändern der Ansichtsfenstereinstellungen zulassen, Auswahl der Stream-Haupt-/Unterqualität aktivieren).
* **Automatische Stummschaltung aufheben**: Hebt automatisch die Stummschaltung des Audiostreams des aktiven Ansichtsfensters auf, wenn in den Vollbildmodus gewechselt wird.
* **Cursor im Vollbildmodus ausblenden**: Das Kontrollkästchen *„Cursor im Vollbildmodus ausblenden“* blendet den Mauszeiger nach einer kurzen Inaktivitätsphase während der Vollbildansicht automatisch aus, um eine freie Sicht zu gewährleisten.
* **Sprachauswahl**: Schaltet die Schnittstellenübersetzung sofort um (Systemstandard: Polnisch, Englisch).
* **Benutzeroberflächeneinstellungen**: Anzeigefenster-Statusbeschriftungen oder Steuerelement-Badges ein-/ausblenden (z. B. automatisches Ausblenden der Steuerelement-Overlays in der unteren rechten Ecke von Kacheln, sofern Sie nicht mit der Maus darüber fahren).
* **Standard-FFmpeg-Optionen und Massenaktualisierung**: Ermöglicht die Konfiguration globaler FFmpeg-Optionen, die auf neue Ansichtsfenster angewendet werden (empfohlen: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[EMPFEHLUNG]** Wenn Sie von einer älteren Version von KVision (vor v2.4.5) migrieren, wird dringend empfohlen, in den globalen Einstellungen `-analyzeduration 0` in `-analyzeduration 100000` zu ändern und auf „Alle Kameras aktualisieren“ zu klicken. Das Festlegen von `0` für Streams ohne Audiospur führt zu Verzögerungen beim Umschalten, da FFmpeg beim Warten auf Audiopakete eine fest codierte Zeitüberschreitung von 5 Sekunden blockiert. Durch die Einstellung eines sehr niedrigen Werts (z. B. 100.000 Mikrosekunden = 0,1 s) wird dieses Problem vollständig behoben und gleichzeitig ein sofortiges Umschalten gewährleistet.
  * **Schaltfläche „Alle Kameras aktualisieren“**: Die Schaltfläche *„Zaktualizuj wszystkie kamery“* wendet diese globalen Optionen auf alle konfigurierten Ansichtsfenster an.
  * **Flags für niedrige Latenz (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` deaktiviert die interne Paketpufferung des Demuxers, um Streaming-Verzögerungen im Laufe der Zeit zu vermeiden, kann jedoch zu Stottern führen, wenn Ihre Netzwerkverbindung zur Kamera instabil ist.
    * `-flags low_delay` weist den Decoder an, Frames sofort auszugeben, kann jedoch bei schnellen Bewegungen zu kurzen Artefakten/Verschmierungen in Streams führen, die B-Frames verwenden.
  * <b>Kontrollkästchen „Überschreiben“: Sie können bestimmte Ansichtsfenster von globalen Aktualisierungen oder dynamischen Standardeinstellungen ausschließen, indem Sie im Dialogfeld „Einstellungen für einzelne Ansichtsfenster“ die Option „Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg“ aktivieren. Nützlich zur Fehlerbehebung bei stotternden Kameras.


### 6. Änderungsprotokoll (Uhr-/Dokumentsymbol)
Präsentiert eine interaktive Zeitleiste mit dem vollständigen Veröffentlichungsverlauf, Aktualisierungen, Fehlerbehebungen und Funktionserweiterungen von KVision und stellt so sicher, dass Sie direkten Zugriff auf Details zu Programmaktualisierungen haben.

---

## 10. Tastaturkürzel und Maussteuerung

### Tastaturkürzel:
| Taste / Verknüpfung | Aktion |
|---|---|
| **F** / **F11** | Schalten Sie den Vollbildmodus um. |
| **M** | Audio stummschalten/Stummschaltung aufheben (funktioniert für die aktive Kamera mit Audio). |
| **Leerzeichen** | Wiedergabe starten/anhalten im Fenster „Wiedergabearchiv“. |
| **Alt + 1** bis **Alt + 9** | Schneller Wechsel zu einem Preset/Layout bei den Indizes 1 bis 9. |
| **Alt + Pfeil nach links** | Wechseln Sie schnell zur vorherigen Voreinstellung/zum vorherigen Layout in der Sammlung. |
| **Alt + Rechtspfeil** | Wechseln Sie schnell zur nächsten Voreinstellung/zum nächsten Layout in der Sammlung. |
| **Pfeiltasten (oben/unten/links/rechts)** | Navigieren und verschieben Sie den aktiven Fokus/die Auswahl zwischen Kameraansichtsfenstern. |
| **Umschalt + Pfeiltasten** | Wählen Sie mehrere benachbarte Kameraansichtsfenster gleichzeitig aus (wird zum Zusammenführen von Zellen usw. verwendet). |
| **Strg + N** | Öffnen Sie ein neues, unabhängiges Hilfsfenster. |
| **+** / **-** | Vergrößern/Verkleinern (PTZ-fähige Hikvision-Kameras). |
| **Umschalt** (Ziehmarke) | Erzwingen Sie, dass die Auswahl des Auswahlrahmens beim interaktiven Zoomen ein Seitenverhältnis von 16:9 einhält. |
| **Esc** | Vollbildmodus verlassen / aktive Ansichtsfensterauswahl abbrechen. |

### Mausinteraktion:
* **Linke Maustaste**:
  * Durch einen **Doppelklick** auf ein Kameraansichtsfenster im Raster wird es auf den Vollbildmodus maximiert. Ein weiterer Doppelklick stellt die Rasteransicht wieder her.
  * Ziehen Sie die Zeitleiste im Wiedergabefenster, um zu navigieren.
* **Mittlere Maustaste (Klicken und Ziehen mit dem Scrollrad)**:
  * Ziehen Sie, um das digital gezoomte/vergrößerte Bild im Sichtfeld des Ansichtsfensters zu schwenken und zu verschieben (funktioniert in Live, Archiv und Mini-Player).
* **Rechte Maustaste (Kontextmenü)**:
  * Öffnet ein Schnelleinstellungsmenü für das ausgewählte Ansichtsfenster (ermöglicht das Entfernen der Kamera aus dem Raster, den Wechsel zwischen Haupt-/Unterstreams oder den Zugriff auf einzelne Anzeigeparameter).
* **Mausrad**:
  * Passt den Maßstab (Zoom) der Zeitleiste im Wiedergabearchiv-Player an.

---

## 11. Erstellen von Snapshots und Pfadkonfiguration

Mit der Anwendung können Sie schnell hochwertige Schnappschüsse aus jedem Kameraansichtsfenster sowohl im Live-Ansichts- als auch im Wiedergabearchivmodus aufnehmen.

### Schnappschüsse machen:
1. In der unteren rechten Ecke jedes Ansichtsfensters ist eine Schaltfläche zum Überlagern eines Kamerasymbols verfügbar (ausführlich beschrieben in Abschnitt 4).
2. Durch Klicken auf das Kamerasymbol wird das Bild erfasst und als JPEG-Bild gespeichert (Qualität 98 – nahezu verlustfrei).
3. Eine erfolgreiche Aufnahme wird dadurch bestätigt, dass das Kamerasymbol genau 1 Sekunde lang orange blinkt (`#ff7a00`).
4. **Volle Auflösung**: Im Wiedergabearchivmodus werden Schnappschüsse mit der vollen nativen Quellauflösung des Streams direkt aus dem Bildpuffer des Decoders gespeichert, unabhängig von der aktiven Ansichtsfenstergröße auf dem Bildschirm oder der Anzeigeskalierung.

### Pfadkonfigurationen speichern:
1. Gehen Sie zur Registerkarte **Einstellungen** (Zahnradsymbol im Optionsfenster).
2. Im Abschnitt **Speichern** („Zapis“) können Sie die Standardpfade konfigurieren:
   * **Standard-Snapshot-Pfad**: Ordner, in dem Snapshots gespeichert werden (standardmäßig `~/Obrazy/CCTV`).
   * **Standardaufzeichnungspfad**: Ordner, in dem heruntergeladene MP4-Videos gespeichert werden (standardmäßig `~/Wideo/CCTV`).
3. Durch Klicken auf die Browserschaltfläche `...` wird die native Ordnerauswahl Ihres Betriebssystems (Breeze in KDE) geöffnet.
4. **Verhalten der Browser-Schaltfläche**: Die Verzeichnisauswahl wird genau an dem im Textfeld eingegebenen Pfad geöffnet (falls vorhanden). Wenn das Feld leer oder ungültig ist oder auf einen Ordner verweist, auf den Sie keinen Zugriff haben, wird das Dialogfeld zurückgesetzt und in Ihrem Home-Verzeichnis (`~/`) geöffnet.

### Benutzeroberflächeneinstellungen (UI):
1. Gehen Sie zur Registerkarte **Einstellungen** (Zahnradsymbol im Optionsfenster) oder öffnen Sie das Fenster **Optionen** („Opcje“).
2. Im Abschnitt **Benutzeroberflächeneinstellungen** können Sie die Sichtbarkeit von Elementen anpassen, die den Kamerafenstern/Ansichtsfenstern überlagert sind:
   * **Kanalstatus in der oberen linken Ecke des Ansichtsfensters anzeigen** (standardmäßig aktiviert) – Zeigt Informationen zum Laden, Abspielen und Verbindungsstatus des Streams an.
   * **Kamerainformationen in der unteren linken Ecke des Ansichtsfensters anzeigen** (standardmäßig aktiviert) – Zeigt den vom Hikvision-Recorder abgerufenen Kameranamen an.
   * **Steuersymbole in der unteren rechten Ecke des Ansichtsfensters nur anzeigen, wenn Sie den Mauszeiger darüber bewegen** (Standardeinstellung aktiviert) – Blendet das Steuerschaltflächenfeld (Schnappschuss, Archiv, 1:1 Pixel-zu-Pixel, Bereichszoom) automatisch aus, wenn sich der Mauszeiger außerhalb des bestimmten Kamera-Ansichtsfensters befindet. Die Symbole erscheinen sofort, sobald Sie mit der Maus über das Ansichtsfenster fahren (kein Klick erforderlich) und verschwinden beim Verlassen, wodurch die Sichtbarkeit Ihrer Kamerastreams maximiert wird.
   * **Infofelder nur beim Bewegen des Mauszeigers anzeigen** (standardmäßig deaktiviert) – Analoge Option, die den Status oben links und den Namen unten links in Ansichtsfenstern verbirgt und einen völlig sauberen Kamerastream anzeigt, es sei denn, der Cursor wird über diese bestimmte Kamerakachel bewegt.
