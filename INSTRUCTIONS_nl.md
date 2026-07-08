# Gebruikershandleiding voor KVision

> [!NOTE]
> Deze handleiding is automatisch vertaald en opgemaakt met behulp van kunstmatige intelligentie (AI).

**KVision** is een geavanceerde desktopapplicatie van VMS-klasse (Video Management System), ontworpen voor het gelijktijdig bekijken van live videostreams (RTSP/ONVIF) en integratie met Hikvision NVR/DVR-recorders (zowel in Live-modus als in Afspeelarchiefmodus).

Het programma is geoptimaliseerd voor stabiliteit, soepele werking (60 FPS) en minimaal verbruik van systeembronnen.

---

## Inhoudsopgave
1. [Beschrijving van knopacties](#1-description-of-button-actions)
2. [Installatie en lancering](#2-installation-and-launching)
3. [NVR/DVR-recorders beheren](#3-managing-nvrdvr-recorders)
4. [Liveweergave en viewport-overlays](#4-live-view-and-viewport-overlays)
5. [Schermindelingen, voorinstellingen en werkbalk](#5-screen-layouts-presets-and-toolbar)
6. [Systeemstatistiekenpaneel (Systeemstatistieken)](#6-system-statistics-panel-system-stats)
7. [Afspeelarchiefspeler](#7-playback-archive-player)
8. [Opnames downloaden (Downloader)](#8-downloading-recordings-downloader)
9. [Geavanceerde instellingen en aanpassingen in het optievenster](#9-advanced-settings-and-customization-in-options-window)
10. [Sneltoetsen en muisbediening](#10-keyboard-shortcuts-and-mouse-controls)
11. [Momentopnamen maken en padconfiguratie](#11-taking-snapshots-and-path-configuration)

---

## 1. Beschrijving van knopacties

In dit gedeelte wordt de betekenis beschreven van alle grafische pictogrammen en knoppen die in de toepassing worden gebruikt.

### Bovenste werkbalk
* {ICON:quit} **Venster sluiten**: vraagt ​​om bevestiging en sluit het actieve venster of de actieve toepassing.
* {ICON:pin} **Pin Bar**: Vergrendelt de bovenste balk in uitgevouwen toestand of maakt automatisch samenvouwen mogelijk.
* {ICON:fullscreen} **Volledig scherm**: schakelt het actieve venster over naar de modus Volledig scherm.
* {ICON:minimize} **Minimaliseren**: Minimaliseert het toepassingsvenster tot de systeemtaakbalk.
* {ICON:options} **Opties**: Opent of sluit het venster met configuratieopties (instellingen en recorders).
* {ICON:new_window} **Nieuw venster**: Opent een nieuw, onafhankelijk hulpvenster voor camerastreams.
* {ICON:archive} **Archief**: Opent het archiefvenster voor afspeelopnamen (tijdlijn en kalender).
* {ICON:instructions} **Instructies**: Opent deze gebruikershandleiding en het venster voor technische assistentie.
* {ICON:stats} **Statistieken**: Schakelt het glijdende paneel met systeemstatistieken in of uit (CPU, RAM, GPU, Net).
* {ICON:lock} **Rastervergrendeling**: schakelt aanpassingen van de rasterverdeling uit om uw actieve lay-out te beschermen.
* {ICON:hamburger} **Meer opties**: Opent de schuifwerkset voor geavanceerde deelgroottes, verhoudingen en het samenvoegen van cellen.

### Viewport-overlays (camera's)
* {ICON:snapshot} **Momentopname**: legt een verliesvrije afbeelding met volledige resolutie vast en slaat deze op als een JPEG-bestand.
* {ICON:play} **Camera-archief**: Start het tijdlijnafspeelvenster voor deze camera (15 minuten achteruit).
* {ICON:quick_play} **Snel afspelen (minispeler)**: Start een archiefweergave in de viewport van de afgelopen 30 minuten, zodat u snel recente beelden rechtstreeks in de camerategel kunt bekijken zonder Live View te verlaten.
* {ICON:grid_1x1} **Probeer 1:1**: geeft de videostream weer in de oorspronkelijke, native resolutie zonder uitrekken.
* {ICON:zoom_in} **Interactief zoomen**: schakelt de vergroting door klikken en slepen in of uit voor een geselecteerd selectiekadergebied.
* {ICON:zoom_out} **Zoom resetten**: reset de digitale vergroting en herstelt het volledige gezichtsveld van de camera.
* {ICON:speaker_unmute} **Audio dempen**: vertegenwoordigt een niet-gedempte audiostream; Als u erop klikt, wordt de stream gedempt.
* {ICON:speaker_mute} **Dempen van audio opheffen**: vertegenwoordigt een gedempte audiostream; Als u erop klikt, wordt het dempen van de stream opgeheven.

### Bedieningselementen voor het afspeelvenster

**Besturingselementen op de bovenste balk:**
* {ICON:close} **Sluiten**: Sluit het afspeelarchiefspelervenster.
* {ICON:pin} **Pin Bar**: Vergrendelt de bovenste balk in uitgevouwen toestand of maakt automatisch samenvouwen mogelijk.
* {ICON:fullscreen} **Volledig scherm**: schakelt het afspeelvenster over naar de modus Volledig scherm.
* {ICON:sidebar} **Zijbalk tonen/verbergen**: schakelt de zichtbaarheid van de linkerzijbalk met camera's en recorders in of uit.
* {ICON:timeline_show} / {ICON:timeline_hide} **Tijdlijn tonen/verbergen**: Toont of verbergt het onderste paneel met de tijdlijn en afspeelknoppen.
* {ICON:video_folder} **Videomap**: Opent de lokale systeemmap met gedownloade videoclips.
* {ICON:photo_folder} **Map momentopnamen**: Opent de lokale systeemmap met vastgelegde momentopnamen.
* rasterknoppen `1x1`, `1x2`, `2x1`, `2x2`: Schakelt de cameraweergave-indeling van het afspeelvenster naar 1, 2 (verticaal/horizontaal) of 4 gelijktijdige weergaven.

**Besturingselementen onderbalk en tijdlijn:**
* {ICON:prev_day} **Vorige dag**: navigeert naar opnamen van de vorige kalenderdag.
* {ICON:calendar_select} **Datumkiezer**: Opent een kalenderdialoogvenster om een ​​specifieke datum voor afspelen te selecteren.
* {ICON:next_day} **Volgende dag**: navigeert naar opnamen van de volgende kalenderdag.
* {ICON:today} **Vandaag**: verschuift de afspeelfocus onmiddellijk naar de huidige kalenderdag.
* {ICON:refresh_recordings} **Opnames vernieuwen**: vernieuwt en vraagt ​​beschikbare opnamesegmenten opnieuw op vanaf het apparaat.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Voorinstellingen voor tijdlijnzoomen**: schaalt het zichtbare venster van de tijdlijn (naar 1 uur, 8 uur of 24 uur) voor uiterst nauwkeurige navigatie.
* {ICON:timeline_center} **Tijdlijn centreren**: Centreert de tijdlijnweergave precies rond de huidige afspeeltijdstempel.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Afspeelsnelheid**: Past de multiplier voor het afspelen van video aan (standaard 1x snelheid, 2x versneld of 4x snel afspelen).
* {ICON:download} **Download**: Opent de downloadtool om een ​​gedefinieerd videosegment vanaf het apparaat te exporteren.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Spring achteruit**: spoelt de afspeeltijdstempel 60, 45 of 15 seconden terug.
* {ICON:play} / {ICON:pause} **Afspelen / Pauze**: Start of pauzeert het afspelen van de archiefvideostream.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Spring vooruit**: Verschuift de afspeeltijdstempel met 15, 45 of 60 seconden.

**Andere diagnostische en algemene pictogrammen:**
* {ICON:calendar} **Agenda**: vertegenwoordigt agenda-/planningsconfiguraties.
* {ICON:clock} **Tijd**: vertegenwoordigt klok- of temporele statusindicatoren.
* {ICON:zoom} **Zoom**: vertegenwoordigt schaal- of digitale zoomconfiguraties.
* {ICON:timeline_toggle} **Tijdlijn wisselen**: vertegenwoordigt het wisselen of vernieuwen van chronologische weergaven.
* {ICON:trash} **Verwijderen**: Verwijdert veilig geconfigureerde recorders of lay-outs met bevestiging.
* {ICON:warning} **Waarschuwing**: weergegeven in dialoogvensters voor onomkeerbare acties of verwijderingswaarschuwingen.

---

## 2. Installatie en lancering

### Installeren op Arch Linux (Pacman)
Om het programma vanuit het voorbereide binaire pakket te installeren, gaat u naar de map `packaging/arch/` en voert u het volgende uit:
```bash
sudo pacman -U kvision-2.6.2-1-x86_64.pkg.tar.zst
```
Het pakket installeert automatisch het programma, het activeringsbestand `.desktop` en de vereiste Hikvision SDK-bibliotheken naar het systeempad `/usr/lib/kvision`.

### Handmatige compilatie (van broncode)
Als je het programma handmatig wilt compileren (bijvoorbeeld op een andere Linux-distributie) in plaats van het kant-en-klare pakket te gebruiken:

1. Installeer de vereiste build- en runtime-afhankelijkheden met behulp van uw pakketbeheerder. Voor Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Configureer het project met CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Compileer de code:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installeer de applicatie in het systeem:
   ```bash
   sudo cmake --install build
   ```

### Lancering
Het programma kan worden gestart vanuit het systeemmenu of door in de terminal te typen:
```bash
kvision
```

### Problemen met systeemschaling oplossen (KDE Plasma)

Vanaf versie 2.4.4 detecteert KVision automatisch fractionele bureaubladschaling (bijvoorbeeld 125%, 145%, 150%), geconfigureerd in KDE Plasma-instellingen, en past deze correct toe door het afdwingen van native High DPI pass-through-beleid in Qt. De gebruikersinterface zou nu out-of-the-box correct moeten schalen zonder enige handmatige tussenkomst.

#### Ondersteuning voor inheemse Wayland

Om de beste schaalervaring en prestaties onder Wayland te garanderen, moet u ervoor zorgen dat het optionele `qt5-wayland` pakket op uw systeem is geïnstalleerd. Hierdoor kan KVision native op Wayland draaien in plaats van terug te vallen op XWayland.

Voor Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Voor Debian/Ubuntu/Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Handmatige schaaloverschrijving (verouderd/terugval)

Als u een oudere versie of een ongebruikelijke configuratie gebruikt, of eenvoudigweg handmatig een andere schaalfactor wilt forceren dan de rest van het systeem, kunt u de schaalbaarheid van de toepassing nog steeds overschrijven met behulp van omgevingsvariabelen.

Als u bijvoorbeeld een schaling van **150%** wilt forceren, start u de applicatie vanaf de terminal met:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(U kunt dit permanent toepassen door het programmastartprogramma `kvision.desktop` in de KDE-menu-editor te bewerken en deze variabelen toe te voegen aan het veld "Omgevingsvariabelen").*

---

## 3. NVR/DVR-recorders beheren

Om de verbinding met een Hikvision-recorder te configureren:
1. Open het optievenster en ga naar het tabblad **Recorders** (serverpictogram).
2. Voer de toegangsgegevens van het apparaat in:
   * **IP-adres**: het netwerkadres van de recorder.
   * **Poort**: de SDK-netwerkpoort (standaard is `8000`).
   * **Gebruikersnaam**: gebruikersnaam (bijvoorbeeld `admin`).
   * **Wachtwoord**: Wachtwoord voor toegang tot de recorder.
3. Klik op **Verbinden en ontdekken** (of **Opslaan en bijwerken**).
4. Na een succesvolle verbinding zal de applicatie automatisch alle actieve camera's (kanalen) detecteren die op de NVR/DVR zijn aangesloten en deze aan de lijst toevoegen.
5. Als u op de knop **Raster genereren** klikt, wordt automatisch een viewport-indeling (voorinstelling) gemaakt met alle actieve camera's van die NVR in een optimale rasterindeling.
6. **Cameralijsten weergeven (NvrCamerasWindow)**: als u op de pictogramknop van de computermonitor op de kaart van een recorder klikt, wordt een speciaal venster geopend waarin alle gedetecteerde camerakanalen als interactieve tegels worden weergegeven.
7. **Miniaturen genereren (Miniaturen genereren)**: In het lijstvenster van de NVR-camera's is een knop *„Miniaturen genereren”* beschikbaar. Als u erop klikt, krijgt de toepassing de opdracht om afzonderlijke frames uit de substream van elk kanaal op de achtergrond te halen en deze in te stellen als tegelachtergrondminiaturen. Dit biedt een snelle visuele preview van elke camera zonder volledige livefeeds te starten.
8. **Klik-en-toevoegfunctie**: de applicatie biedt geen ondersteuning voor het slepen van tegels (slepen en neerzetten) van het cameralijstvenster naar het hoofdraster. Cameratoewijzing gebeurt op een eenvoudige en betrouwbare manier: klik eerst met de linkermuisknop op een weergavevenstertegel in het hoofdschermraster om deze te selecteren (deze wordt gemarkeerd met een heldere rand), en klik vervolgens op de groene knop **"+" (Toewijzen aan actieve weergavepoort)** op de gewenste camerategel in het NVR-cameralijstvenster. De stream wordt onmiddellijk in dat slot geladen.
9. **SDK-sessiestatus (puntindicator)**: naast het IP-adres van elke recorder in de lijst staat een gekleurde statuspunt:
   * **Groen (INGELOGD)**: vertegenwoordigt een actieve Hikvision SDK-sessie, die vereist is voor PTZ-besturing, tijdlijnarchiefverzoeken en downloaden.
   * **Rood (NIET INGELOGD)**: Er is momenteel geen actieve SDK-sessie tot stand gebracht (bijvoorbeeld vóór het eerste SDK-verzoek of na handmatig/automatisch uitloggen). Houd er rekening mee dat camera-RTSP-livefeeds onafhankelijk van de SDK-sessiestatus blijven spelen.
10. **Lokale cameranaam wijzigen**: klik op een camerategel in de lijst met NVR-camera's op het pictogram **Bewerken** (potlood). Hierdoor wordt een dialoogvenster geopend waarin u een aangepaste naam voor de camera kunt instellen. Deze naam wordt lokaal opgeslagen en wordt onmiddellijk bijgewerkt in de live spelers, tijdlijn en tegelweergaven zonder het fysieke NVR-apparaat te wijzigen. U kunt deze op elk gewenst moment terugzetten naar de standaardnaam.
11. **Een recorder uit de lijst verwijderen**: naast elke geconfigureerde recorder in de lijst staat een rode prullenbakknop. Als u erop klikt, wordt een beveiligingsprotocol in twee fasen gestart dat is ontworpen om onbedoelde verwijdering te voorkomen:
    * **Stap 1 (Bevestiging)**: Er verschijnt een dialoogvenster met de titel *“Bevestig NVR-verwijdering”*, waarin u wordt gevraagd of u zeker weet dat u de recorder wilt verwijderen.
    * **Stap 2 (Waarschuwing)**: Er verschijnt een tweede waarschuwingsvenster met de titel *“Waarschuwing!”*, waarin u wordt gevraagd of u absoluut zeker weet wat u doet.
    * **Effect van verwijdering**: na acceptatie van de tweede waarschuwing logt het programma op de achtergrond uit bij die NVR, verwijdert de invoer ervan uit de applicatieconfiguratie en **veegt automatisch de lijst met vooraf ingestelde lay-outs**, waarbij alle dynamische rasters worden verwijderd die voor dit NVR-apparaat zijn gegenereerd.

---

## 4. Liveweergave en Viewport-overlays

Het hoofdvenster van het programma toont de livefeed:
* **Cameraraster**: geeft RTSP-streams of feeds rechtstreeks vanuit de Hikvision SDK weer.
* **Selectie van streamkwaliteit**: door met de rechtermuisknop op een cameraviewport te klikken, kunt u de **hoofdstream** selecteren voor de hoogste resolutie, of de **substream** om de netwerk- en grafische kaartbelasting te verminderen.
* **Dubbelklikken op volledig scherm**: Dubbelklikken met de linkermuisknop op een cameravenster maximaliseert deze onmiddellijk om het volledige actieve venstergebied te vullen (volledig scherm met één weergavevenster). Als u nogmaals dubbelklikt, wordt de oorspronkelijke rasterindeling met meerdere camera's hersteld.
* **Bovenste balk automatisch verbergen**: de bovenste optiewerkbalk (topToolBar) kan automatisch samenvouwen naar de bovenrand van het scherm wanneer de muiscursor het gebied verlaat (deze optie is configureerbaar in Instellingen -> *"Bovenste balk automatisch samenvouwen"* of rechtstreeks via het punaisepictogram op de bovenste balk).
* **Multi-monitor- en hulpvensters**: u kunt onafhankelijke extra (hulp)vensters openen om verschillende rasterindelingen tegelijkertijd op meerdere schermen of monitoren uit te voeren. Als u een nieuw venster wilt openen, gebruikt u de sneltoets `Ctrl+N`, of klikt u op de knop **'Nieuw venster'** op de werkbalk met de muis en glijbaan. Elk venster kan worden geconfigureerd met zijn eigen rastergrootte en geselecteerde vooraf ingestelde lay-out. Om maximale stabiliteit bij configuraties met meerdere monitoren te garanderen, worden alle vensters strikt gecentreerd op het primaire beeldscherm gestart met 90% van de resolutie.

### Viewport-overlayknoppen
In de rechterbenedenhoek van elke camerategel/viewport wordt een bedieningspaneel met vijf functionele pictogrammen weergegeven wanneer u de muiscursor erover beweegt (afhankelijk van de UI-voorkeuren):
1. **Camerapictogram (momentopname)**: Hiermee kunt u een screenshot maken van de camerafeed. De momentopname wordt rechtstreeks vanuit de framebuffer van de decoder in de volledige oorspronkelijke resolutie van de stream opgeslagen, waardoor verliezen als gevolg van de huidige grootte van de viewport-tegel of schaalvergroting van de schermresolutie worden vermeden. Het succesvol opslaan van de momentopname wordt bevestigd doordat het camerapictogram precies 1 seconde oranje knippert (`#ff7a00`).
2. **Afspeelpictogram (archief)**: wordt gebruikt om het opnamearchief snel te openen. Als u op deze knop klikt, wordt automatisch de tijdlijn `PlaybackWindow` voor deze specifieke camera gestart, waarbij het afspelen **exact 15 minuten vóór de huidige systeemtijd** begint (een handige snelle achterwaartse offset).
3. **Circulair pijlpictogram (snel afspelen / minispeler)**: Activeert een snelle weergave in de viewport van camera-archiefopnamen van de afgelopen 30 minuten, rechtstreeks in de camerategel zonder het liveraster te verlaten of het volledige archiefvenster te openen.
   * **Configuratiescherm**: Indien actief, verschijnt er onderaan de viewport een verschuifbaar bedieningspaneel met daarin:
     * **Afspelen/pauzeren**: pauzeert of hervat de afspeelstream.
     * **Tijd- en offsetweergave**: toont de huidige afspeeltijdstempel en de relatieve leeftijd ervan vergeleken met realtime (`-12:34` vertegenwoordigt bijvoorbeeld 12 minuten en 34 seconden geleden).
     * **Interactieve tijdlijnschuifregelaar**: hiermee kunt u klikken of slepen om overal binnen de buffer van 30 minuten te zoeken. Beschikbare opnamesegmenten worden gemarkeerd met een groenblauw achtergrond, en een rode afspeelkop markeert de huidige positie.
     * **Snelheidsvermenigvuldiger**: Bladert door afspeelsnelheden (`1x`, `2x` en `4x`) om beelden snel te scannen.
     * **Sluiten (✕)**: Sluit de minispeler en keert de viewport onmiddellijk terug naar de live feed.
   * **Ondersteuning voor panneerbare zoom**: net als in de liveweergave kunt u het vergrootglas gebruiken om in te zoomen op een gebied van de minispeler, of u kunt de middelste muisknop ingedrukt houden en slepen om rond te pannen.
4. **1:1-pictogram (native schaal)**: schakelt de pixel-naar-pixel videoweergavemodus in. Indien ingeschakeld, wordt de video niet uitgerekt of vervormd om de tegelgrenzen te vullen, maar in plaats daarvan gecentreerd en weergegeven in de oorspronkelijke oorspronkelijke resolutie. Wanneer deze modus actief is, worden de knopachtergrond en de "1:1"-tekst gemarkeerd in helder neonlicht-turkoois.
5. **Vergrootglaspictogram (interactieve zoom)**: Hiermee kunt u elk specifiek gedeelte van de videofeed vergroten:
   * **Activering**: als u op het pictogram klikt, wordt het in een actieve status gezet (turquoise markering). De cursor verandert van vorm en een tooltip geeft instructies: *“Klik en sleep op de camerafeed om in te zoomen”*.
   * **Bewerking**: klik met de linkermuisknop en sleep een rechthoekig selectiegebied over de live feed. De viewport zal het geselecteerde gebied automatisch bijsnijden en schalen om de hele tegel te vullen.
     * **Proportionele zoom**: Houd de **Shift**-toets ingedrukt terwijl u de zoomrechthoek tekent om de selectie te dwingen te vergrendelen in een beeldverhouding van 16:9, strikt beperkt tot de grenzen van de viewport.
     * **Het ingezoomde beeld pannen (Pan Zoom)**: Eenmaal ingezoomd, kunt u de **middelste muisknop (scrollwiel)** ingedrukt houden en de cursor slepen om de vergrote weergave vrij rond het videobeeldveld te pannen. Dit werkt in Live View, het Afspeelarchief en de Minispeler.
   * **Resetten**: wanneer er wordt ingezoomd, verandert het vergrootglaspictogram van pictogram (rode rand met een minteken). Als u erop klikt, wordt de zoom onmiddellijk opnieuw ingesteld en keert u terug naar de volledige camerafeed.

---

## 5. Schermindelingen, voorinstellingen en werkbalk

Met lay-outs kunt u de plaatsing van camera's op het scherm organiseren. Op het tabblad **Voorinstellingen** (sterpictogram) kunt u:
* **Nieuwe voorinstellingen maken**: voeg uw eigen lay-out toe met elke configuratie van kolommen en rijen (bijvoorbeeld 2x2, 3x3, 4x4).
* **Camera's toewijzen**: klik op een kijkvenster in de rasterindeling om deze te selecteren, open vervolgens het venster NVR-camera's en klik op de knop **"+" (Toevoegen)** op de gewenste camerategel. U kunt ook de posities van de viewports wisselen door met de rechtermuisknop te klikken op het contextmenu (*„Zamień miejscami”* / *„Viewports wisselen”*) van de bronviewport en vervolgens op de doelviewport te klikken.

### Knoppen op de bovenste balk (bovenste werkbalk)
De bovenste schuifwerkbalk biedt een uitgebreide set navigatie- en applicatiebedieningsknoppen:
1. **Venster sluiten (rode knop ✕)**: Sluit het actieve venster. Om onbedoelde klikken te voorkomen, onderschept het de afsluitende gebeurtenis en wordt u in een dialoogvenster gevraagd om het afsluiten van de toepassing te bevestigen.
2. **Pin-knop**: regelt het automatisch verbergen van de bovenste werkbalk. Wanneer de pin verticaal wijst (vastgezette toestand), wordt de balk vergrendeld en blijft deze permanent zichtbaar. Wanneer de pin -45 graden wordt gedraaid (niet-vastgezette toestand), schuift de balk automatisch naar boven uit het zicht wanneer de muis zijn gebied verlaat.
3. **Volledig scherm (pictogram met groene pijlen)**: schakelt het actieve venster onmiddellijk over naar de modus Volledig scherm en terug. In de modus Volledig scherm wijzen de pijlen naar binnen (samenvouwen), en in de venstermodus wijzen ze naar buiten (uitvouwen).
4. **Minimaliseren (cyaan minimalisatiepictogram)**: Minimaliseert het toepassingsvenster tot de taakbalk. Als u het herstelt, keert het venster terug naar de exacte vorige staat (bijvoorbeeld gemaximaliseerd of volledig scherm).
5. **⚙️ OPTIES (OPCJE)**: Schakelt het venster met configuratieopties in of uit. Als het venster al geopend is, wordt het door op deze knop te klikken gesloten.
6. **📺 NIEUW VENSTER (NU OKNO)**: Opent een nieuwe, onafhankelijke en volledig configureerbare `Auxiliary Window`, perfect voor het uitbreiden van uw camera-indelingen over meerdere monitoropstellingen.
7. **ARCHIEF**: Opent een lege `PlaybackWindow` (opnamespeler) met actieve tijdlijn en kalender, waardoor handmatige stream- en camerakanaalselecties mogelijk zijn vanaf elke geconfigureerde NVR via de zijbalklijst.
8. **INSTRUCTIES (INSTRUKCJA)**: Opent dit handleidingvenster en laadt de volledige gebruikersdocumentatie in het Engels of Pools, afhankelijk van uw actieve landinstelling.
9. **📊 STATS (STATYSTYKI)-schakelaar**: tuimelschakelaar om het controlepaneel voor systeemstatistieken vanaf de linkerrand van het scherm naar buiten te schuiven.
10. **Grid Lock-schakelaar (hangslot)**: schakelaar die, wanneer ingeschakeld (gemarkeerd in fel oranje), acties voor het wijzigen van de rastergrootte op de aangrenzende rasterknoppen uitschakelt, waardoor uw actieve camera-indeling wordt beschermd tegen onbedoelde wijzigingen.
11. **Kiezers voor rastergrootte (van 1x1 tot 9x9)**: een rij van negen knoppen waarmee u direct de rij- en kolomstructuur van uw viewport kunt definiëren (van een 1x1-weergave van een enkele camera tot 81 gelijktijdige camerafeeds in een 9x9-indeling). Het momenteel actieve formaat wordt fel oranje gemarkeerd.
12. **Meer opties (Hamburgermenu met drie regels)**: knop die de glijdende `Layout & Grid Tools`-toolbox opent voor geavanceerde rasterafstemming, geometrie-aanpassingen en foutopsporingsopties (hieronder gedetailleerd beschreven).
13. **Voorinstellingen/weergaveknoppen**: dynamisch weergegeven knoppen aan de rechterkant van de werkbalk die uw geconfigureerde en zichtbare vooraf ingestelde lay-outs vertegenwoordigen (bijv. *📹 NVR*, *View 1*, enz.). Als u op een knop klikt, wordt het raster onmiddellijk gewijzigd. De actieve weergave wordt benadrukt in helder lichtturkoois.

### Geavanceerde rasteraanpassing en -verhoudingen (lay-out- en rasterhulpmiddelen)
Als u het Hamburger-menu (Meer opties) opent, verschijnt een gespecialiseerde lay-outtoolbox. Om de bedieningselementen te activeren:
1. **Hulpmiddelenvenster ontgrendelen**: schakel de schakelaar 'Hulpmiddelenvenster ontgrendelen' helemaal bovenaan in. Dit is een expliciete veiligheidsmaatregel om onbedoelde wijzigingen aan complexe lay-outs te voorkomen.
2. **Aangepaste vensterverdeling (F2 of ingedrukt houden)**: de toolbox geeft knoppen voor rasterverdeling weer van 1x1 tot 9x9. Een uiterst geavanceerde functie is de mogelijkheid om **verdelingsgroottes te overschrijven en te bewerken**. Als u met de linkermuisknop op een rasterknop klikt en deze ingedrukt houdt (of de focus erop legt en op **F2** drukt), verschijnt er een tekstvak. U kunt elke aangepaste of asymmetrische verdeling typen (zoals `2x3`, `1x4`, enz.) en op Enter drukken. De knop wordt onmiddellijk opnieuw geprogrammeerd en als u erop klikt, wordt uw aangepaste lay-out toegepast op het hoofdvenster.
3. **Geometrieverhoudingen**: Hiermee kunt u de rasterweergave forceren naar specifieke beeldverhoudingen:
   * **16:9-beeldverhouding**: vergrendelt en schaalt de rastercontainer naar breedbeeldformaat 16:9 (standaard voor moderne IP-camera's).
   * **4:3-beeldverhouding**: past de rastercontainer aan de traditionele 4:3-verhouding aan (gebruikelijk bij oudere analoge/IP-camera's).
4. **Rasterbewerkingen (gemarkeerde cellen samenvoegen)**: toegang tot de asymmetrische functie voor het samenvoegen van cellen (gedetailleerd in paragraaf 9.2).

---

## 6. Paneel Systeemstatistieken (Systeemstatistieken)

Dit paneel schuift vanaf de linkerrand van het Live View-scherm naar buiten en bewaakt de gezondheid van de computer en de belasting die door de applicatie wordt gegenereerd:
* **Bewaakte parameters**:
  * **CPU/RAM**: gebruik van de hoofdprocessor (in % van alle kernen) en het RAM-geheugen dat rechtstreeks wordt gebruikt door het `kvision`-proces en de bijbehorende downloader-subprocessen.
  * **GPU/VRAM**: kerngebruik van grafische kaart (in %) en de hoeveelheid grafisch VRAM-geheugen die wordt ingenomen door rendering en hardwaredecodering (ondersteunt een volledige lijst van GPU-processen met behulp van de XML-parser van `nvidia-smi`).
  * **NETWERK (Net)**: werkelijke downloadoverdrachtsnelheid van de applicatie van alle actieve livespelers, archiefspelers en downloadprocessen voor opnames.
* **Multithreading (stottervrij)**: de verzameling van proces- en GPU-gegevens wordt uitgevoerd op een afzonderlijke systeemthread (`StatsWorker`). Dit voorkomt micro-stuttering bij videoweergave (geen framedrops).
* **Pinfunctie**: als u op de knop **'Pin'** (pinpictogram) klikt, wordt het paneel in de uitgevouwen toestand vergrendeld.
* **Esthetiek**: de diagrammen hebben heldere, neongroene randen, een verloopvulling onder de diagramcurve en een uitgebalanceerde achtergrondtransparantie van 35% om de leesbaarheid van de tekst te garanderen.

---

## 7. Archiefspeler afspelen

Beschikbaar door op het klok-/afspeelpictogram naast een specifieke camera of recorder te klikken. Het maakt het gelijktijdig bekijken van gearchiveerde opnames van meerdere Hikvision-camera's mogelijk, in fulltime synchronisatie.

### Tijdlijn en bediening:
* **Snelle start (15 minuten terug)**: bij het openen van het archief vanuit de liveweergave start de speler automatisch vanaf een moment dat **precies 15 minuten vóór de huidige systeemtijd** valt (in plaats van te beginnen om middernacht). Hierdoor kunt u onmiddellijk een gebeurtenis bekijken die zojuist heeft plaatsgevonden.
* **Navigatie**: de tijdlijn kan naar links en rechts worden gescrolld door deze met de linkermuisknop te slepen.
* **Zoom (schalen)**: u kunt de schaal van de tijdlijn soepel wijzigen met het muiswiel (of de zoomknoppen) – van weergave van de hele dag tot een nauwkeurige weergave van 10 minuten.
* **Snelle zoomsnelkoppelingen**: de onderste bedieningsbalk bevat speciale ronde pictogramknoppen om de tijdlijnweergave onmiddellijk te schalen:
  * **pictogram '1 uur'**: zoomt in op de tijdlijn voor gedetailleerde inspectie over een periode van 1 uur.
  * **pictogram '8 uur'**: zoomt in op de tijdlijn om een ​​periode van 8 uur weer te geven.
  * **pictogram '24 uur'**: reset de zoom zodat de volledige dag van 24 uur op één scherm wordt weergegeven.
  * **Centreerpictogram (doel)**: centreert de tijdlijn onmiddellijk zodat de rode afspeelindicator zich precies in het midden van het scherm bevindt (ter vervanging van de oude tekstknop).
* **Datumnavigatie (kalender en dagen)**: met de bedieningselementen naast de weergegeven datum kunt u snel springen:
  * Knoppen **„<” (Vorige dag)** en **„>” (Volgende dag)**: Hiermee kunt u direct 24 uur terug of vooruit springen zonder het kalenderdialoogvenster te openen.
  * **Kalenderpictogram**: Opent de kalenderpop-up om een ​​specifieke datum te selecteren.
  * **Vernieuwingspictogram**: Forceert een nieuwe zoekactie naar opnamen. Als u erop klikt, wordt de lokale cache van opnamebeschikbaarheidssegmenten voor alle actieve kanalen leeggemaakt en worden nieuwe zoekopdrachten naar de NVR verzonden, wat zeer handig is om bestanden te laden die zojuist zijn opgenomen (ter vervanging van de oude tekstknop).
  * **Pictogram Vandaag (datum/nummer van vandaag)**: springt onmiddellijk terug naar de huidige dag (ter vervanging van de oude tekstknop).
* **Snelkoppelingen voor afspeelsnelheid**:
  * **pictogrammen '1x', '2x' en '4x'**: verander onmiddellijk de vermenigvuldiger van de afspeelsnelheid.
* **VCR-springknoppen**:
  * **pictogrammen '15', '45' en '60' met ronde pijlen**: hiermee kunt u snel het opgegeven aantal seconden achteruit of vooruit springen.
* **Beschikbaarheidsbalken voor opnames**: gekleurde balken die de gevonden videosegmenten op de schijf van de recorder vertegenwoordigen, worden onder de tijdlijn weergegeven. Een cachingsysteem voorkomt dat ze flikkeren tijdens het slepen.
* **Automatisch volgen (indicatortracking)**: de afspeelindicator (verticale rode lijn) wordt voortdurend gecontroleerd. Als de indicator buiten het zichtbare bereik van de tijdlijn komt, scrollt de weergave automatisch om deze te centreren. Deze optie wordt op intelligente wijze vergrendeld tijdens het handmatig slepen van indicatoren door de gebruiker.

### Camerazijpaneel in afspeelvenster
Een verticale zijlijst aan de rechterrand van de speler vermeldt alle geconfigureerde NVR's en hun camerakanalen:
* **Kanalen schakelen**: door op een camerakanaal in de lijst te klikken, wordt het als een actief afspeelslot op de tijdlijn toegevoegd (waardoor een videospeler wordt gegenereerd). Als u er nogmaals op klikt, wordt het kanaal verwijderd.
* **Kanaalcontextmenu**: als u met de rechtermuisknop op een actieve videoslot in het afspeelraster klikt, wordt een menu geopend waarin u:
  * Schakel tussen videokwaliteit (hoofdstream / substream).
  * Sluit/verwijder de actieve speler uit de archiefweergave.

---

## 8. Opnames downloaden (Downloader)

Vanuit het venster Afspeelarchief kunt u geselecteerde segmenten van opnamen rechtstreeks naar de schijf van uw computer downloaden als MP4-bestanden:
1. Klik op het downloadpictogram (pijl omlaag) naast de geselecteerde camera.
2. Selecteer het tijdsbereik (begin en einde van de opname).
3. Selecteer de opslaglocatie voor het doelbestand.
4. Klik op **Downloaden**.

### Geavanceerde downloadfuncties:
* **Sequentieel segment downloaden (delen van 1 GB)**: het programma splitst uw tijdsbereikquery automatisch op in fysieke bestandssegmenten (elk ongeveer 1 GB op de NVR-schijf) en downloadt en converteert deze één voor één (met behulp van tijdelijke `.pspart`-bestanden die rechtstreeks worden geconverteerd naar het `.mp4`-formaat). Dit zorgt voor zeer stabiele downloads van lange duur zonder geheugenoverloop of vastlopen van FFmpeg-conversie.
* **Algemene voortgangsvisualisatie**: de voortgangsbalk (heldere blauwgroen kleur) geeft de algehele downloadvoortgang voor de camera in alle segmenten weer. De statustekst op de voortgangsbalk toont het huidige onderdeel en de percentages, bijvoorbeeld `Downloading part 1 of 3... 45% (Overall: 15%)`, met een contourstijl om de leesbaarheid op elke achtergrond te garanderen.
* **IP-opschoning van bestandsnamen**: videobestandsnamen (en live/archief-snapshots) worden automatisch ontdaan van de NVR/DVR-IP-adressen om ze schoon en leesbaar voor mensen te houden (bijvoorbeeld `4_Wejscie_glowne_2026-06-15.mp4` in plaats van `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Geavanceerde instellingen en aanpassingen in het optievenster

Het opties- en configuratievenster (`SideBar`) bestaat uit zes speciale tabbladen:

### 1. Viewport-details (monitorpictogram)
Toont geavanceerde parameters van de momenteel geselecteerde rastertegel. Hiermee kunt u:
* Typ een aangepaste **primaire stream-URL** (RTSP/ONVIF) en een **secundaire back-up-URL** voor handmatige configuraties.
* Schakel het dempen/dempen van het audiokanaal van de geselecteerde camerafeed in of uit.
* Voer geavanceerde decoderoverschrijvingen in het tekstvak **FFmpeg Opties overschrijven** in.
> [!TIP]
> Voor de snelste streamverbinding en maximale stabiliteit via RTSP zijn de aanbevolen parameters:
> ```ini
> -analyseduur 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Lay-out- en rasterhulpmiddelen (schuifregelaarspictogram)
Geavanceerde aanpassingsopties voor het schermraster:
* Snel schakelen naar de modus Volledig scherm.
* **Asymmetrische cellen samenvoegen (gemarkeerde cellen samenvoegen)**: een zeer geavanceerde lay-outeditor. Houd **Ctrl** of **Shift** ingedrukt en klik om meerdere aangrenzende tegels op het raster te selecteren, of gebruik uw toetsenbord door **Shift** ingedrukt te houden en te navigeren met de **pijltoetsen**. Klik vervolgens op 'Gemarkeerde cellen samenvoegen' om ze samen te voegen tot één groter venster. Hierdoor kunt u volledig aangepaste asymmetrische rasterontwerpen maken (bijvoorbeeld één enorm camerapaneel met kleinere feeds eromheen).

### 3. Recorders (serverpictogram)
Volledige configuratiemanager voor verbindingen met Hikvision NVR/DVR-apparaten (in detail beschreven in hoofdstuk 3).

### 4. Voorinstellingen (sterpictogram)
Manager voor uw opgeslagen rasterindelingen en cameratoewijzingen. Maakt het mogelijk om lege rastersjablonen te maken, de volgorde ervan te wijzigen, de zichtbaarheid in de bovenste balk te wijzigen (via de schakelaar "Zichtbaar") of ze in het huidige venster te activeren.

### 5. Instellingen (tandwielpictogram)
Maakt het mogelijk om algemene applicatie-instellingen aan te passen:
* **Sta het uitvoeren van meerdere exemplaren toe**: Door dit vakje aan te vinken kunt u meerdere parallelle kopieën van het KVision-proces starten (standaard beperkt dit de uitvoering tot één enkel actief exemplaar).
* **Instellingen voor automatisch samenvouwen**: past de timing van de glijdende animatie aan voor de bovenste balk en het statistiekenpaneel.
* **Sta het wisselen van kijkvensters toe**: Met het selectievakje *"Sta het wisselen van kijkvensterplaatsen toe"* kunt u de cameraposities op het raster direct herschikken (klik met de rechtermuisknop op de brontegel -> Kies 'Weergavevensters wisselen' -> klik met de linkermuisknop op de doeltegel).
* **Rechtsklikrechten**: Schakelt over naar het vergrendelen/ontgrendelen van interactieve besturingselementen in het rechtermuisknop-contextmenu (Contextmenu inschakelen, Verwisselen van weergavepoorten toestaan, 'Camera verwijderen'-optie inschakelen, Wijzigen van weergavepoortinstellingen toestaan, Selectie van stream-hoofd-/subkwaliteit inschakelen).
* **Automatisch dempen opheffen**: schakelt automatisch de audiostream van de actieve viewport uit wanneer de modus Volledig scherm wordt geopend.
* **Cursor op volledig scherm verbergen**: het selectievakje *"Cursor op volledig scherm verbergen"* verbergt automatisch de muiscursor na een korte periode van inactiviteit tijdens weergave op volledig scherm om een ​​onbelemmerd zicht te garanderen.
* **Taalselectie**: schakelt onmiddellijk over naar de vertaling van de interface (Systeemstandaard, Pools, Engels).
* **UI-voorkeuren**: statuslabels van viewports of controlebadges verbergen/tonen (zoals het automatisch verbergen van de controle-overlays in de rechterbenedenhoek van tegels, tenzij u de muisaanwijzer erop plaatst).
* **Standaard FFmpeg-opties en bulkupdate**: Maakt het configureren van algemene FFmpeg-opties mogelijk die worden toegepast op nieuwe viewports (aanbevolen: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[AANBEVELING]** Als u migreert van een oudere versie van KVision (vóór v2.4.5), wordt het ten zeerste aanbevolen om `-analyzeduration 0` in `-analyzeduration 100000` te veranderen in de algemene instellingen en op "Alle camera's bijwerken" te klikken. Het instellen van `0` op streams zonder audiotrack veroorzaakt vertragingen bij het schakelen omdat FFmpeg blokkeert gedurende een hardgecodeerde time-out van 5 seconden tijdens het wachten op audiopakketten. Het instellen van een zeer lage waarde (bijvoorbeeld 100.000 microseconden = 0,1s) lost dit probleem volledig op, terwijl het onmiddellijk schakelen behouden blijft.
  * **Knop Alle camera's bijwerken**: De knop *„Zaktualizuj wszystkie kamery”* past deze algemene opties toe op alle geconfigureerde viewports.
  * **Lage latentievlaggen (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` schakelt de interne demuxer-pakketbuffering uit om streamingvertraging in de loop van de tijd te elimineren, maar kan haperingen veroorzaken als uw netwerkverbinding met de camera instabiel is.
    * `-flags low_delay` vertelt de decoder om frames onmiddellijk uit te voeren, maar kan korte artefacten/smering veroorzaken in streams die B-frames gebruiken bij snelle bewegingen.
  * **Selectievakje negeren**: u kunt specifieke viewports uitsluiten van algemene updates of dynamische standaardinstellingen door **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** aan te vinken in het individuele dialoogvenster Viewport-instellingen. Handig voor het oplossen van problemen met stotterende camera's.


### 6. Changelog (klok/documentpictogram)
Presenteert een interactieve tijdlijn die de volledige releasegeschiedenis, updates, bugfixes en functietoevoegingen van KVision toont, zodat u direct toegang heeft tot de details van programma-updates.

---

## 10. Sneltoetsen en muisbediening

### Sneltoetsen:
| Toets / sneltoets | Actie |
|---|---|
| **F** / **F11** | Schakel de modus Volledig scherm in. |
| **M** | Audio dempen/opheffen (werkt voor de actieve camera met audio). |
| **Ruimte** | Afspelen/pauzeren in het venster Afspeelarchief. |
| **Alt + 1** tot **Alt + 9** | Snel schakelen naar een preset/lay-out op indexen 1 t/m 9. |
| **Alt + pijl-links** | Snel schakelen naar de vorige preset/lay-out in de collectie. |
| **Alt + pijl-rechts** | Snel schakelen naar de volgende preset/lay-out in de collectie. |
| **Pijltoetsen (omhoog/omlaag/links/rechts)** | Navigeer en verplaats de actieve focus/selectie tussen camerazichtvensters. |
| **Shift + pijltjestoetsen** | Selecteer meerdere aangrenzende cameravensters tegelijk (gebruikt voor het samenvoegen van cellen, enz.). |
| **Ctrl + N** | Open een nieuw, onafhankelijk hulpvenster. |
| **+** / **-** | Inzoomen / Uitzoomen (PTZ-compatibele Hikvision-camera's). |
| **Shift** (selectiekader slepen) | Forceer selectiekader om een ​​beeldverhouding van 16:9 vast te leggen tijdens interactief zoomen. |
| **Esc** | Verlaat de modus Volledig scherm / annuleer actieve viewport-selectie. |

### Muisinteractie:
* **Linkermuisknop**:
  * **Dubbelklikken** op een cameravenster in het raster maximaliseert het tot volledig scherm. Nog een keer dubbelklikken herstelt de rasterweergave.
  * Sleep de tijdlijn in het afspeelvenster om te navigeren.
* **Middelmuisknop (klik en sleep met het scrollwiel)**:
  * Sleep om de digitaal ingezoomde/vergrote afbeelding te pannen en verplaatsen rond het gezichtsveld van de viewport (werkt in Live, Archief en Minispeler).
* **Rechtermuisknop (contextmenu)**:
  * Opent een menu met snelle instellingen voor de geselecteerde viewport (maakt het mogelijk de camera uit het raster te verwijderen, te wisselen tussen hoofd-/substreams of toegang te krijgen tot individuele weergaveparameters).
* **Muisscrollwiel**:
  * Past de schaal (zoom) van de tijdlijn in de afspeelarchiefspeler aan.

---

## 11. Momentopnamen maken en padconfiguratie

Met de applicatie kunt u snel snapshots van hoge kwaliteit maken vanuit elke cameraviewport, zowel in de Live View- als de Playback Archive-modus.

### Momentopnamen maken:
1. In de rechterbenedenhoek van elke viewport is een overlayknop voor het camerapictogram beschikbaar (gedetailleerd in Hoofdstuk 4).
2. Als u op het camerapictogram klikt, wordt het frame vastgelegd en opgeslagen als een JPEG-afbeelding (kwaliteit 98 - vrijwel verliesvrij).
3. Een succesvolle opname wordt bevestigd doordat het camerapictogram precies 1 seconde oranje knippert (`#ff7a00`).
4. **Volledige resolutie**: in de Playback Archive-modus worden momentopnamen opgeslagen met de volledige oorspronkelijke bronresolutie van de stream, rechtstreeks vanuit de framebuffer van de decoder, ongeacht de actieve viewport-grootte op het scherm of de schermschaal.

### Padconfiguraties opslaan:
1. Ga naar het tabblad **Instellingen** (tandwielpictogram in het optievenster).
2. In het gedeelte **Opslaan** ("Zapis") kunt u de standaardpaden configureren:
   * **Standaardpad voor momentopnamen**: map waarin momentopnamen worden opgeslagen (standaard is dit `~/Obrazy/CCTV`).
   * **Standaard opnamepad**: map waarin gedownloade MP4-video's worden opgeslagen (standaard `~/Wideo/CCTV`).
3. Als u op de browserknop `...` klikt, wordt de eigen mappenkiezer van uw besturingssysteem geopend (Breeze in KDE).
4. **Gedrag van browserknoppen**: de mapkiezer wordt precies geopend op het pad dat in het tekstveld is getypt (als dit bestaat). Als het veld leeg of ongeldig is, of verwijst naar een map waartoe u geen toegang heeft, valt het dialoogvenster terug en wordt het geopend in uw thuismap (`~/`).

### Instellingen gebruikersinterface (UI):
1. Ga naar het tabblad **Instellingen** (tandwielpictogram in het optievenster) of open het venster **Opties** ("Opcje").
2. In het gedeelte **Gebruikersinterface-instellingen** kunt u de zichtbaarheid van elementen op de camerakafelki/viewports aanpassen:
   * **Kanaalstatus weergeven in de linkerbovenhoek van de viewport** (standaard ingeschakeld) — Geeft informatie over het laden, afspelen en verbindingsstatus van de stream weer.
   * **Toon camera-informatie in de linkerbenedenhoek van de viewport** (standaard ingeschakeld) — Toont de cameranaam die is opgehaald uit de Hikvision-recorder.
   * **Besturingspictogrammen alleen in de rechterbenedenhoek van het kijkvenster weergeven als u erover zweeft** (standaard ingeschakeld) — Verbergt automatisch het bedieningsknoppenpaneel (momentopname, archief, 1:1 pixel-naar-pixel, regiozoom) wanneer de muiscursor zich buiten dat specifieke cameravenster bevindt. De pictogrammen verschijnen onmiddellijk zodra u uw muis over de viewport beweegt (geen klik vereist) en verdwijnen wanneer u deze verlaat, waardoor de zichtbaarheid van uw camerastreams wordt gemaximaliseerd.
   * **Alleen informatievelden weergeven als u erover zweeft** (standaard uitgeschakeld) — Analoge optie die de status linksboven en de naam linksonder in de weergavevensters verbergt, waardoor een volledig schone camerastream wordt weergegeven, tenzij de cursor over die specifieke camerategel wordt bewogen.
