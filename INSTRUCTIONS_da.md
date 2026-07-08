# Brugermanual til KVision

> [!BEMÆRK]
> Denne brugsanvisning er blevet automatisk oversat og formateret ved hjælp af kunstig intelligens (AI).

**KVision** er en avanceret VMS (Video Management System) klasse desktopapplikation designet til samtidig visning af live videostreams (RTSP/ONVIF) og integration med Hikvision NVR/DVR-optagere (både i Live-tilstand og Afspilningsarkivtilstand).

Programmet er optimeret til stabilitet, jævn drift (60 FPS) og minimalt systemressourceforbrug.

---

## Indholdsfortegnelse
1. [Beskrivelse af knaphandlinger](#1-description-of-button-actions)
2. [Installation og lancering](#2-installation-and-launching)
3. [Administration af NVR/DVR-optagere](#3-managing-nvrdvr-recorders)
4. [Live View og Viewport Overlays](#4-live-view-and-viewport-overlays)
5. [Skærmlayouts, forudindstillinger og værktøjslinje](#5-screen-layouts-presets-and-toolbar)
6. [Systemstatistikpanel (Systemstatistik)](#6-system-statistics-panel-system-stats)
7. [Afspilningsarkivafspiller](#7-playback-archive-player)
8. [Downloader optagelser (Downloader)](#8-downloading-recordings-downloader)
9. [Avancerede indstillinger og tilpasning i vinduet Indstillinger](#9-advanced-settings-and-customization-in-options-window)
10. [Tastaturgenveje og musekontroller](#10-keyboard-shortcuts-and-mouse-controls)
11. [Optagelse af snapshots og stikonfiguration](#11-taking-snapshots-and-path-configuration)

---

## 1. Beskrivelse af knaphandlinger

Dette afsnit beskriver betydningen af ​​alle grafiske ikoner og knapper, der bruges i applikationen.

### Øverste værktøjslinje
* {ICON:quit} **Luk vindue**: Beder om bekræftelse og lukker det aktive vindue eller program.
* {ICON:pin} **Pin-bjælke**: Låser den øverste bjælke i udvidet tilstand eller aktiverer automatisk sammenbrud.
* {ICON:fullscreen} **Fuld skærm**: Skifter det aktive vindue til fuldskærmstilstand.
* {ICON:minimize} **Minimer**: Minimerer programvinduet til systemets proceslinje.
* {ICON:options} **Valgmuligheder**: Åbner eller lukker vinduet med konfigurationsindstillinger (indstillinger og optagere).
* {ICON:new_window} **Nyt vindue**: Åbner et nyt, uafhængigt hjælpevindue for kamerastreams.
* {ICON:archive} **Arkiv**: Åbner arkivvinduet for afspilning af optagelser (tidslinje og kalender).
* {ICON:instructions} **Instruktioner**: Åbner denne brugervejledning og vindue med teknisk assistance.
* {ICON:stats} **Stats**: Skifter det glidende systemstatistikpanel (CPU, RAM, GPU, Net).
* {ICON:lock} **Gitterlås**: Deaktiverer gitterinddelingsjusteringer for at beskytte dit aktive layout.
* {ICON:hamburger} **Flere muligheder**: Åbner den glidende værktøjskassen til avancerede divisionsstørrelser, forhold og cellesammenfletning.

### Viewport-overlejringer (kameraer)
* {ICON:snapshot} **Snapshot**: Tager et tabsfrit billede i fuld opløsning og gemmer det som en JPEG-fil.
* {ICON:play} **Kameraarkiv**: Starter tidslinjeafspilningsvinduet for dette kamera (15 minutter bagud).
* {ICON:quick_play} **Hurtig afspilning (miniafspiller)**: Starter en arkivafspilning i visningsporten af ​​de sidste 30 minutter, så du hurtigt kan gennemgå de seneste optagelser direkte i kamerafeltet uden at forlade Live view.
* {ICON:grid_1x1} **Prøv 1:1**: Viser videostrømmen i sin originale, oprindelige opløsning uden at strække sig.
* {ICON:zoom_in} **Interaktiv zoom**: Skifter klik-og-træk-forstørrelse til et valgt markeringsområde.
* {ICON:zoom_out} **Nulstil zoom**: Nulstiller den digitale forstørrelse og gendanner hele kameraets synsfelt.
* {ICON:speaker_unmute} **Slå lyd fra**: Repræsenterer en ikke-dæmpet lydstrøm; Hvis du klikker på den, dæmpes streamen.
* {ICON:speaker_mute} **Slå lyd til**: Repræsenterer en dæmpet lydstrøm; Hvis du klikker på den, slås lyden til for streamen.

### Afspilningsvinduets kontrol

**Betjeningselementer i øverste bjælke:**
* {ICON:close} **Luk**: Lukker vinduet til afspilningsarkivafspilleren.
* {ICON:pin} **Pin-bjælke**: Låser den øverste bjælke i udvidet tilstand eller aktiverer automatisk sammenbrud.
* {ICON:fullscreen} **Fuld skærm**: Skifter afspilningsvinduet til fuldskærmstilstand.
* {ICON:sidebar} **Vis/skjul sidebjælke**: Skifter synligheden af ​​venstre sidebjælke, der indeholder kameraer og optagere.
* {ICON:timeline_show} / {ICON:timeline_hide} **Vis/skjul tidslinje**: Viser eller skjuler det nederste panel, der indeholder tidslinjen og afspilningskontrollerne.
* {ICON:video_folder} **Videomappe**: Åbner den lokale systemmappe, der indeholder downloadede videoklip.
* {ICON:photo_folder} **Snapshot-mappe**: Åbner den lokale systemmappe, der indeholder optagne snapshots.
* gitterknapper `1x1`, `1x2`, `2x1`, `2x2`: Skifter kameravisningslayoutet for afspilningsvinduet til 1, 2 (lodret/vandret) eller 4 samtidige visninger.

**Bundlinje og tidslinjekontrol:**
* {ICON:prev_day} **Forrige dag**: Navigerer til optagelser fra den foregående kalenderdag.
* {ICON:calendar_select} **Datovælger**: Åbner en kalenderdialog for at vælge en bestemt dato for afspilning.
* {ICON:next_day} **Næste dag**: Navigerer til optagelser af den næste kalenderdag.
* {ICON:today} **I dag**: Skifter øjeblikkeligt afspilningsfokus til den aktuelle kalenderdag.
* {ICON:refresh_recordings} **Opdater optagelser**: Opdaterer og genforespørger tilgængelige optagelsessegmenter fra enheden.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Forudindstillinger for tidslinjezoom**: Skalerer det synlige vindue på tidslinjen (til 1 time, 8 timer eller 24 timer) til navigation med høj præcision.
* {ICON:timeline_center} **Centreret tidslinje**: Centrerer tidslinjevisningen præcist omkring det aktuelle afspilningstidsstempel.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Afspilningshastighed**: Justerer videoafspilningsmultiplikatoren (standard 1x hastighed, 2x accelereret eller 4x hurtig afspilning).
* {ICON:download} **Download**: Åbner downloadværktøjet for at eksportere et defineret videosegment fra enheden.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Hop tilbage**: Spoler afspilningstidsstemplet tilbage med 60, 45 eller 15 sekunder.
* {ICON:play} / {ICON:pause} **Afspil / Pause**: Starter eller pauser afspilning af arkivvideostream.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Hop frem**: Forlænger afspilningstidsstemplet med 15, 45 eller 60 sekunder.

**Andre diagnostiske og generelle ikoner:**
* {ICON:calendar} **Kalender**: Repræsenterer kalender-/planlægningskonfigurationer.
* {ICON:clock} **Tid**: Repræsenterer ur eller tidsmæssige statusindikatorer.
* {ICON:zoom} **Zoom**: Repræsenterer skalering eller digital zoom-konfigurationer.
* {ICON:timeline_toggle} **Tidslinjeskift**: Repræsenterer skifte eller opdatering af kronologiske visninger.
* {ICON:trash} **Slet**: Fjerner sikkert konfigurerede optagere eller layouts med bekræftelse.
* {ICON:warning} **Advarsel**: Vises i dialogbokse for irreversible handlinger eller sletteadvarsler.

---

## 2. Installation og lancering

### Installation på Arch Linux (Pacman)
For at installere programmet fra den forberedte binære pakke skal du gå til mappen `packaging/arch/` og køre:
```bash
sudo pacman -U kvision-2.6.2-1-x86_64.pkg.tar.zst
```
Pakken installerer automatisk programmet, aktiveringsfilen `.desktop` og de nødvendige Hikvision SDK-biblioteker til systemstien `/usr/lib/kvision`.

### Manuel kompilering (fra kildekode)
Hvis du ønsker at kompilere programmet manuelt (f.eks. på en anden Linux-distribution) i stedet for at bruge den færdige pakke:

1. Installer de nødvendige build- og runtime-afhængigheder ved hjælp af din pakkehåndtering. For Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Konfigurer projektet ved hjælp af CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Kompiler koden:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installer applikationen i systemet:
   ```bash
   sudo cmake --install build
   ```

### Lancering
Programmet kan startes fra systemmenuen eller ved at indtaste terminalen:
```bash
kvision
```

### Fejlfinding af systemskalering (KDE Plasma)

Fra version 2.4.4 detekterer KVision automatisk og anvender fraktioneret skrivebordsskalering korrekt (f.eks. 125 %, 145 %, 150 %) konfigureret i KDE Plasma-indstillinger ved at håndhæve native High DPI pass-through-politikker i Qt. Brugergrænsefladen skal nu skaleres korrekt ud af kassen uden nogen manuel indgriben.

#### Native Wayland Support

For at sikre den bedste skaleringsoplevelse og ydeevne under Wayland, skal du sørge for at have den valgfrie `qt5-wayland`-pakke installeret på dit system. Dette giver KVision mulighed for at køre indbygget på Wayland i stedet for at falde tilbage til XWayland.

For Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Til Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Manuel tilsidesættelse af skalering (forældet/tilbagefaldende)

Hvis du kører en ældre version, en usædvanlig konfiguration eller blot ønsker manuelt at fremtvinge en anden skaleringsfaktor end resten af ​​systemet, kan du stadig tilsidesætte applikationsskaleringen ved hjælp af miljøvariabler.

For at gennemtvinge **150 %** skalering f.eks. skal du starte programmet fra terminalen med:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Du kan anvende dette permanent ved at redigere programstarteren `kvision.desktop` i KDE-menueditoren og tilføje disse variabler til feltet "Miljøvariabler").*

---

## 3. Håndtering af NVR/DVR-optagere

Sådan konfigurerer du forbindelsen til en Hikvision-optager:
1. Åbn indstillingsvinduet, og gå til fanen **Optagere** (serverikon).
2. Indtast enhedsadgangsoplysningerne:
   * **IP-adresse**: Optagerens netværksadresse.
   * **Port**: SDK-netværksporten (standard er `8000`).
   * **Brugernavn**: Brugernavn (f.eks. `admin`).
   * **Adgangskode**: Adgangskode for at få adgang til optageren.
3. Klik på **Opret forbindelse og opdag** (eller **Gem og opdater**).
4. Ved vellykket tilslutning vil applikationen automatisk registrere alle aktive kameraer (kanaler), der er tilsluttet NVR/DVR og tilføje dem til listen.
5. Hvis du klikker på knappen **Generér gitter**, oprettes der automatisk et viewport-layout (forudindstillet), der indeholder alle aktive kameraer fra den pågældende NVR i et optimalt gitterlayout.
6. **Visning af kameralister (NvrCamerasWindow)**: Ved at klikke på computerskærmens ikonknap på en hvilken som helst optagers kort åbnes et dedikeret vindue, der viser alle registrerede kamerakanaler som interaktive fliser.
7. **Generering af miniaturebilleder (Generer miniaturer)**: I NVR-kameralistevinduet er knappen *"Generer miniaturer"* tilgængelig. Hvis du klikker på den, kommanderes applikationen til at trække enkelte frames fra hver kanals understrøm i baggrunden og indstille dem som thumbnails i baggrunden. Dette giver en hurtig visuel forhåndsvisning af hvert kamera uden at starte hele live-feeds.
8. **Klik-og-tilføj-funktion**: Applikationen understøtter ikke at trække fliser (træk og slip) fra kameralistevinduet til hovedgitteret. Kameratildeling udføres på en enkel og pålidelig måde: Venstreklik først på en hvilken som helst viewport-flise i hovedskærmens gitter for at vælge den (den fremhæves med en lys kant), og klik derefter på den grønne **"+" (Tildel til aktiv viewport)**-knap på den ønskede kameraflise i NVR-kameralistevinduet. Streamen indlæses øjeblikkeligt i det slot.
9. **SDK-sessionsstatus (punktindikator)**: Ved siden af hver optagers IP på listen er der en farvet statusprik:
   * **Grøn (LOGGET IND)**: Repræsenterer en aktiv Hikvision SDK-session, som kræves til PTZ-kontrol, tidslinjearkiveringsanmodninger og download.
   * **Rød (IKKE LOGGET IND)**: Ingen aktiv SDK-session er i øjeblikket etableret (f.eks. før den første SDK-anmodning eller efter manuel/automatisk logout). Bemærk, at kameraets RTSP-live-feeds fortsætter med at spille uafhængigt af SDK-sessionsstatus.
10. **Omdøbning af lokalt kamera**: Klik på ikonet **Rediger** (blyant) på ethvert kamerafelt på NVR-kameralisten. Dette åbner en dialog, hvor du kan indstille et brugerdefineret navn til kameraet. Dette navn gemmes lokalt og opdateres øjeblikkeligt på tværs af live-afspillere, tidslinje og flisevisninger uden at ændre den fysiske NVR-enhed. Du kan til enhver tid nulstille den til standardnavnet.
11. **Fjernelse af en optager fra listen**: Ved siden af ​​hver konfigureret optager på listen er der en rød skraldespandsknap. Ved at klikke på den starter en to-trins sikkerhedsprotokol designet til at forhindre utilsigtet sletning:
    * **Trin 1 (Bekræftelse)**: En dialogboks med titlen *“Bekræft NVR-sletning”* vises og spørger, om du er sikker på, at du vil slette optageren.
    * **Trin 2 (Advarsel)**: En anden advarselsdialogboks med titlen *"Advarsel!"* vises, og du bliver spurgt, om du er helt sikker og klar over, hvad du gør.
    * **Effekt af sletning**: Efter at have accepteret den anden advarsel, logger programmet ud fra den NVR i baggrunden, sletter dens indtastning fra applikationskonfigurationen og **gennemsøger automatisk listen over forudindstillede layouts**, og fjerner alle dynamiske gitter genereret for denne NVR-enhed.

---

## 4. Live View og Viewport Overlays

Programmets hovedvindue viser live-feedet:
* **Camera Grid**: Viser RTSP-streams eller feeds direkte fra Hikvision SDK.
* **Stream Quality Selection**: Ved at højreklikke på en kameravisningsport kan du vælge **Main Stream** for den højeste opløsning eller **Sub Stream** for at reducere netværks- og grafikkortbelastningen.
* **Dobbeltklik fuldskærm til/fra**: Dobbeltklik med venstre museknap på en hvilken som helst kameravisningsport maksimerer den øjeblikkeligt til at udfylde hele det aktive vinduesområde (enkelt visningsport i fuld skærm). Dobbeltklik igen genopretter det originale multikamera-gitterlayout.
* **Auto-skjul øverste bjælke**: Den øverste værktøjslinje (topToolBar) kan automatisk skjules til den øverste kant af skærmen, når musemarkøren forlader sit område (denne mulighed kan konfigureres i Indstillinger -> *"Skjul automatisk øverste bjælke"* eller direkte ved at bruge knappenålsikonet på den øverste bjælke).
* **Multi-monitor og hjælpevinduer**: Du kan åbne uafhængige ekstra (hjælpe) vinduer for at køre forskellige gitterlayouts samtidigt på flere skærme eller skærme. For at åbne et nyt vindue skal du bruge tastaturgenvejen `Ctrl+N` eller klikke på knappen **"Nyt vindue"** på den øverste værktøjslinje. Hvert vindue kan konfigureres med sin egen gitterstørrelse og valgt forudindstillet layout. For at sikre maksimal stabilitet på konfigurationer med flere skærme starter alle vinduer strengt centreret om den primære skærm ved 90 % af opløsningen.

### Viewport Overlay-knapper
I nederste højre hjørne af hver kameraflise/visningsport vises et kontrolpanel med fem funktionelle ikoner, når du holder musemarkøren over det (afhængigt af UI-præferencer):
1. **Kameraikon (snapshot)**: Giver dig mulighed for at tage et skærmbillede fra kamerafeedet. Snapshottet gemmes i streamens fulde, oprindelige opløsning direkte fra dekoderens rammebuffer, hvilket undgår tab på grund af den aktuelle størrelse af viewport-flisen eller skærmopløsningsskalering. Vellykket lagring af snapshot bekræftes ved, at kameraikonet blinker orange (`#ff7a00`) i nøjagtigt 1 sekund.
2. **Afspilningsikon (arkiv)**: Bruges til hurtigt at åbne optagelsesarkivet. Ved at klikke på denne knap startes automatisk tidslinjen `PlaybackWindow` for dette specifikke kamera, og afspilningen starter **nøjagtigt 15 minutter før det aktuelle systemtidspunkt** (en praktisk hurtig forskydning bagud).
3. **Cirkulært pilikon (hurtig afspilning/miniafspiller)**: Aktiverer en hurtig afspilning i visningsporten af ​​kameraarkivoptagelser fra de sidste 30 minutter direkte inde i kamerafeltet uden at forlade livegitteret eller starte hele arkivvinduet.
   * **Kontrolpanel**: Når det er aktivt, vises et glidende kontrolpanel i bunden af visningsporten, der indeholder:
     * **Afspil/Pause**: Sætter pause eller genoptager afspilningsstrømmen.
     * **Time & Offset Display**: Viser det aktuelle afspilningstidsstempel og dets relative alder sammenlignet med realtid (f.eks. repræsenterer `-12:34` 12 minutter og 34 sekunder siden).
     * **Interaktiv tidslinjeskyder**: Giver mulighed for at klikke eller trække for at søge hvor som helst inden for 30 minutters buffer. Tilgængelige optagelsessegmenter er fremhævet med en blågrøn baggrund, og et rødt afspilningshoved markerer den aktuelle position.
     * **Hastighedsmultiplikator**: Skifter gennem afspilningshastigheder (`1x`, `2x` og `4x`) for at scanne optagelser hurtigt.
     * **Luk (✕)**: Lukker miniafspilleren og returnerer øjeblikkeligt visningsporten til live-feedet.
   * **Understøttelse af panorerbar zoom**: Ligesom i Live view kan du bruge forstørrelsesglasværktøjet til at zoome ind på et område af miniafspilleren eller holde den midterste museknap nede og trække for at panorere rundt.
4. **1:1-ikon (native skala)**: Skifter pixel-til-pixel-videovisningstilstand. Når det er aktiveret, strækkes eller forvrænges videoen ikke for at udfylde flisegrænserne, men centreres i stedet og vises i sin oprindelige oprindelige opløsning. Når denne tilstand er aktiv, er knapbaggrunden og "1:1"-teksten fremhævet i lys neonlys-turkis.
5. **Forstørrelsesglasikon (interaktiv zoom)**: Giver dig mulighed for at forstørre en hvilken som helst specifik region af videofeedet:
   * **Aktivering**: Ved at klikke på ikonet skifter det til en aktiv tilstand (turkis højlys). Markøren ændrer form, og et værktøjstip instruerer: *"Klik og træk på kamerafeedet for at zoome"*.
   * **Betjening**: Venstre-klik, og træk et rektangulært markeringsfelt over det levende feed. Viewporten vil automatisk beskære og skalere det valgte område for at fylde hele flisen.
     * **Proportional zoom**: Hold **Shift**-tasten nede, mens du tegner zoomrektanglet for at tvinge markeringen til at låse sig i et 16:9 billedformat, strengt begrænset til visningsportens grænser.
     * **Panorering af det zoomede billede (panoreringszoom)**: Når du har zoomet ind, kan du holde **midterste museknap (rullehjul)** nede og trække markøren for frit at panorere den forstørrede visning rundt i videoens synsfelt. Dette fungerer i Live view, afspilningsarkivet og miniafspilleren.
   * **Nulstil**: Når der er zoomet ind, ændrer forstørrelsesglasikonet sit ikon (rød kant med et minustegn). Hvis du klikker på den, nulstilles zoomen med det samme og vender tilbage til det fulde kamerafeed.

---

## 5. Skærmlayouts, forudindstillinger og værktøjslinje

Layouts giver dig mulighed for at organisere arrangementet af kameraer på skærmen. Fra fanen **Forudindstillinger** (stjerneikon) kan du:
* **Opret nye forudindstillinger**: Tilføj dit eget layout med enhver konfiguration af kolonner og rækker (f.eks. 2x2, 3x3, 4x4).
* **Tildel kameraer**: Klik på en visningsport i gitterlayoutet for at vælge den, åbn derefter NVR-kameravinduet, og klik på knappen **"+" (Tilføj)** på det ønskede kamerafelt. Du kan også bytte viewport-positioner ved at bruge højreklik-kontekstmenuen (*„Zamień miejscami”* / *„Swap viewports”*) i kildevisningsporten og derefter klikke på målvisningsporten.

### Øverste bjælkeknapper (øverste værktøjslinje)
Den øverste glidende værktøjslinje giver et omfattende sæt navigations- og programkontrolknapper:
1. **Luk vindue (rød ✕ knap)**: Lukker det aktive vindue. For at forhindre utilsigtede klik opsnapper den lukkebegivenheden og beder dig med en dialogboks for at bekræfte, at programmet afsluttes.
2. **Fastgøringsknap**: Styrer den automatiske skjulningsadfærd for den øverste værktøjslinje. Når stiften peger lodret (stiftet tilstand), låses stangen på plads og forbliver permanent synlig. Når stiften roteres med -45 grader (ikke-fastgjort tilstand), glider stangen automatisk opad og ude af syne, når musen forlader sit område.
3. **Fuld skærm (ikon med grønne pile)**: Skifter øjeblikkeligt det aktive vindue til fuldskærmstilstand og tilbage. I fuldskærmstilstand peger pilene indad (kollaps), og i vinduestilstand peger de udad (udvid).
4. **Minimer (cyan minimeringsikon)**: Minimerer programvinduet til proceslinjen. Gendannelse returnerer vinduet til dets nøjagtige tidligere tilstand (f.eks. maksimeret eller fuldskærm).
5. **⚙️ OPTIONS (OPCJE)**: Skifter vinduet med konfigurationsindstillinger. Hvis vinduet allerede er åbent, lukkes det ved at klikke på denne knap.
6. **📺 NYT VINDU (NOWE OKNO)**: Åbner en ny, uafhængig og fuldt konfigurerbar `Auxiliary Window`, perfekt til at udvide dine kameralayouts på tværs af flere skærmopsætninger.
7. **ARKIV**: Åbner en tom `PlaybackWindow` (optagelsesafspiller) med aktiv tidslinje og kalender, hvilket tillader manuelle stream- og kamerakanalvalg fra enhver konfigureret NVR via sidebjælkelisten.
8. **INSTRUKTIONER (INSTRUKCJA)**: Åbner dette manualvindue og indlæser den komplette brugerdokumentation på engelsk eller polsk afhængigt af din aktive lokalitet.
9. **📊 STATISTIK (STATYSTYKI)-kontakt**: Skift kontakt for at skubbe systemstatistik-overvågningspanelet ud fra venstre skærmkant.
10. **Gitterlåskontakt (hængelås)**: Skift til, at når den er slået TIL (fremhævet i lys orange), deaktiverer grid-tilpasningshandlinger på de tilstødende gitterknapper, hvilket beskytter dit aktive kameralayout mod utilsigtede ændringer.
11. **Gitterstørrelsesvælgere (fra 1x1 til 9x9)**: En række med ni knapper, der giver dig mulighed for øjeblikkeligt at definere række- og kolonnestrukturen for din viewport (fra et enkelt kamera 1x1 visning op til 81 samtidige kamerafeeds i et 9x9 layout). Den aktuelt aktive størrelse fremhæves i lys orange.
12. **Flere muligheder (Hamburgermenu med tre linjer)**: Knap, der åbner den glidende `Layout & Grid Tools`-værktøjskassen til avanceret gitterjustering, geometrijusteringer og fejlfindingsindstillinger (detaljeret nedenfor).
13. **Forudindstillede/Vis-knapper**: Dynamisk gengivet knapper i højre side af værktøjslinjen, der repræsenterer dine konfigurerede og synlige forudindstillede layouts (f.eks. *📹 NVR*, *View 1* osv.). Ved at klikke på en knap skifter gitteret straks. Den aktive visning fremhæves i skarp lys-turkis.

### Avanceret gittertilpasning og -forhold (layout og gitterværktøjer)
Åbning af menuen Hamburger (Flere indstillinger) åbner en specialiseret layoutværktøjskasse. For at aktivere dens kontroller:
1. **Lås værktøjsrude op**: Skift kontakten "Lås værktøjsrude op" helt øverst. Dette er en eksplicit sikkerhedsforanstaltning for at forhindre utilsigtede ændringer af komplekse layouts.
2. **Brugerdefineret vinduesopdeling (F2 eller tryk-og-hold)**: Værktøjskassen viser tasteropdelingsknapper fra 1x1 til 9x9. En ekstremt avanceret funktion er muligheden for at **tilsidesætte og redigere divisionsstørrelser**. Hvis du klikker og holder på en gitterknap med venstre museknap (eller fokuserer på den og trykker på **F2**), vises en tekstboks. Du kan skrive enhver brugerdefineret eller asymmetrisk division (såsom `2x3`, `1x4` osv.) og trykke på Enter. Knappen omprogrammeres øjeblikkeligt, og ved at klikke på den anvendes dit brugerdefinerede layout til hovedvisningsporten.
3. **Geometriforhold**: Giver mulighed for at tvinge gittervisningen til specifikke billedformater:
   * **16:9-formatforhold**: Låser og skalerer gitterbeholderen til widescreen-format 16:9 (standard for moderne IP-kameraer).
   * **4:3-formatforhold**: Tilpasser gitterbeholderen til det traditionelle 4:3-forhold (almindeligt i ældre analoge/IP-kameraer).
4. **Gitteroperationer (Flet fremhævede celler)**: Få adgang til den asymmetriske cellefletningsfunktion (detaljeret i afsnit 9.2).

---

## 6. Systemstatistikpanel (Systemstatistik)

Dette panel glider ud fra venstre kant af Live View-skærmen og overvåger computerens helbred og belastningen genereret af applikationen:
* **Overvågede parametre**:
  * **CPU / RAM**: Brug af hovedprocessoren (i % af alle kerner) og RAM, der bruges direkte af `kvision`-processen og dens relaterede downloader-underprocesser.
  * **GPU / VRAM**: Grafikkorts kerneudnyttelse (i %) og mængden af ​​VRAM-grafisk hukommelse, der er optaget af gengivelse og hardwareafkodning (understøtter fuld liste over GPU-processer ved hjælp af XML-parseren fra `nvidia-smi`).
  * **NETVÆRK (Net)**: Faktisk downloadoverførselshastighed for applikationen fra alle aktive live-afspillere, arkivafspillere og optagelsesoverførselsprocesser.
* **Multithreading (Stutter-Free)**: Proces- og GPU-dataindsamling kører på en separat systemtråd (`StatsWorker`). Dette forhindrer enhver mikro-stamming i videogengivelsen (ingen billedfald).
* **Fastgøringsfunktion**: Ved at klikke på knappen **"Fastgør"** (stiftikon) låses panelet i dets udvidede tilstand.
* **Æstetik**: Diagrammerne har lyse, neongrønne kanter, en gradientfyldning under diagramkurven og en afbalanceret 35 % baggrundsgennemsigtighed for at sikre tekstlæsbarhed.

---

## 7. Afspilningsarkivafspiller

Tilgængelig ved at klikke på ur/afspil-ikonet ved siden af ​​et bestemt kamera eller optager. Det giver mulighed for samtidig visning af arkiverede optagelser fra flere Hikvision-kameraer i fuldtidssynkronisering.

### Tidslinje og kontroller:
* **Hurtig start (15 minutter tilbage)**: Når du åbner arkivet fra livevisningen, starter afspilleren automatisk fra et øjeblik, der falder **præcis 15 minutter før det aktuelle systemtidspunkt** (i stedet for at starte ved midnat). Dette giver mulighed for øjeblikkelig visning af en begivenhed, der lige har fundet sted.
* **Navigation**: Tidslinjen kan rulles til venstre og højre ved at trække den med venstre museknap.
* **Zoom (Skalering)**: Du kan jævnt ændre tidslinjeskalaen med musens rullehjul (eller zoomknapper) – fra at se hele dagen ned til en præcis 10-minutters præcisionsvisning.
* **Genveje til hurtig zoom**: Den nederste kontrollinje har dedikerede cirkulære ikonknapper til øjeblikkeligt at skalere tidslinjevisningen:
  * **"1h"-ikon**: Zoomer tidslinjen ind for detaljeret inspektion over et tidsrum på 1 time.
  * **"8h"-ikon**: Zoomer tidslinjen for at vise et 8-timers tidsrum.
  * **"24h"-ikon**: Nulstiller zoom, så den passer til hele 24-timers døgnet på en enkelt skærm.
  * **Center (Mål)-ikon**: Centrerer øjeblikkeligt tidslinjen, så den røde afspilningsindikator er præcis i midten af ​​skærmen (erstatter den gamle tekstknap).
* **Datonavigation (kalender og dage)**: Kontroller ved siden af den viste dato tillader hurtige spring:
  * Knapperne **„<” (Forrige dag)** og **„>” (Næste dag)**: Lader dig springe 24 timer tilbage eller frem med det samme uden at åbne kalenderdialogen.
  * **Kalenderikon**: Åbner kalender-popup'en for at vælge en bestemt dato.
  * **Opdateringsikon**: Tvinger en ny søgning efter optagelser. Hvis du klikker på den, gennemses den lokale cache af optagelse af tilgængelighedssegmenter for alle aktive kanaler og sendes nye forespørgsler til NVR, hvilket er yderst nyttigt til at indlæse filer, der er optaget for blot et par øjeblikke siden (erstatter den gamle tekstknap).
  * **Ikon i dag (dagens dato/nummer)**: Springer øjeblikkeligt tilbage til den aktuelle dag (erstatter den gamle tekstknap).
* **Genveje til afspilningshastighed**:
  * **"1x", "2x" og "4x" ikoner**: Skift øjeblikkeligt multiplikatoren for afspilningshastigheden.
* **VCR-springknapper**:
  * **"15", "45" og "60"-ikoner med cirkulære pile**: Lader dig hurtigt springe tilbage eller frem med det angivne antal sekunder.
* **Søjler for optagelsestilgængelighed**: Farvede bjælker, der repræsenterer de fundne videosegmenter på optagerens disk, gengives under tidslinjen. Et caching-system forhindrer dem i at flimre, mens de trækker.
* **Auto-følg (Indikatorsporing)**: Afspilningsindikatoren (lodret rød linje) overvåges konstant. Hvis indikatoren går uden for det synlige område af tidslinjen, vil visningen automatisk rulle for at centrere den. Denne mulighed er intelligent låst under manuel indikatortræk af brugeren.

### Kameraets sidepanel i afspilningsvinduet
En lodret sideliste i højre kant af afspilleren viser alle konfigurerede NVR'er og deres kamerakanaler:
* **Skift mellem kanaler**: Hvis du klikker på en kamerakanal på listen, tilføjes den som en aktiv afspilningsplads på tidslinjen (afføder en videoafspiller). Hvis du klikker på den igen, fjernes kanalen.
* **Kanalkontekstmenu**: Højreklik på en aktiv videoslot i afspilningsgitteret åbner en menu til:
  * Skift videokvalitet (Main Stream / Sub Stream).
  * Luk/fjern den aktive afspiller fra arkivafspilningen.

---

## 8. Download af optagelser (Downloader)

Fra vinduet Afspilningsarkiv kan du downloade udvalgte segmenter af optagelser direkte til din computers drev som MP4-filer:
1. Klik på download-ikonet (pil ned) ud for det valgte kamera.
2. Vælg tidsinterval (start og slutning af optagelsen).
3. Vælg destinationsfilens gemmeplacering.
4. Klik på **Download**.

### Avancerede downloadfunktioner:
* **Sekventiel segmentdownload (1 GB dele)**: Programmet opdeler automatisk din tidsintervalforespørgsel i fysiske filsegmenter (ca. 1 GB hver på NVR-drevet) og downloader og konverterer dem én efter én (ved hjælp af midlertidige `.pspart`-filer, der konverteres direkte til `.mp4`-format). Dette sikrer meget stabile downloads af lang varighed uden hukommelsesoverløb eller FFmpeg-konvertering hænger.
* **Visualisering af overordnet fremskridt**: Statuslinjen (lyse blågrønne farve) viser den overordnede downloadfremgang for kameraet på tværs af alle segmenter. Statusteksten overlejret på statuslinjen viser den aktuelle del og procenter, f.eks. `Downloading part 1 of 3... 45% (Overall: 15%)`, med en konturstil for at garantere læsbarhed på enhver baggrund.
* **Rensning af filnavns IP**: Videofilnavne (og live-/arkivsnapshots) fjernes automatisk for NVR/DVR IP-adresser for at holde dem rene og læselige af mennesker (f.eks. `4_Wejscie_glowne_2026-06-15.mp4` i stedet for `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Avancerede indstillinger og tilpasning i vinduet Indstillinger

Indstillinger og konfigurationsvinduet (`SideBar`) består af seks dedikerede faner:

### 1. Viewport-detaljer (monitorikon)
Viser avancerede parametre for den aktuelt valgte gitterflise. Giver dig mulighed for at:
* Indtast en tilpasset **primær stream-URL** (RTSP/ONVIF) og en **sekundær backup-URL** til manuelle konfigurationer.
* Skift til at slå lyden fra/til for den valgte kamerafeed.
* Indtast avancerede dekodertilsidesættelser i tekstboksen **FFmpeg Options Override**.
> [!TIP]
> For den hurtigste streamforbindelse og maksimal stabilitet over RTSP er de anbefalede parametre:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Layout- og gitterværktøjer (skyderikon)
Avancerede skærmgittertilpasningsmuligheder:
* Hurtig skift til fuldskærmstilstand.
* **Asymmetrisk cellefletning (flet fremhævede celler)**: En meget avanceret layouteditor. Hold **Ctrl** eller **Shift** nede, og klik for at vælge flere tilstødende felter på gitteret, eller brug dit tastatur ved at holde **Shift** nede og navigere med **piletasterne**, og klik derefter på "Flet fremhævede celler" for at fusionere dem til en enkelt større visningsport. Dette giver dig mulighed for at skabe fuldt tilpassede asymmetriske gitterdesigns (f.eks. ét stort kamerapanel med mindre feeds omkring det).

### 3. Optagere (serverikon)
Fuld konfigurationsstyring for forbindelser til Hikvision NVR/DVR-enheder (beskrevet i detaljer i afsnit 3).

### 4. Forudindstillinger (stjerneikon)
Manager for dine gemte gitterlayouts og kameraopgaver. Tillader oprettelse af tomme gitterskabeloner, ændring af deres rækkefølge, skift af synlighed på øverste bjælke (via kontakten "Synlig") eller aktivering af dem i det aktuelle vindue.

### 5. Indstillinger (tandhjulsikon)
Tillader justering af globale applikationsindstillinger:
* **Tillad at køre flere forekomster**: Ved at markere dette felt kan du starte flere parallelle kopier af KVision-processen (som standard begrænser den kørsler til en enkelt aktiv forekomst).
* **Indstillinger for automatisk sammenbrud**: Tilpasser glidende animationstidspunkt for den øverste bjælke og statistikpanelet.
* **Tillad skift af visningsporte**: Afkrydsningsfeltet *"Tillad skift af visningsportspladser"* giver dig mulighed for at omarrangere kamerapositioner på gitteret med det samme (Højreklik på kildefelt -> Vælg "Skift visningsport" -> Venstre-klik målfelt).
* **Højreklikstilladelser**: Skifter til at låse/låse op for interaktive kontroller i højreklikskontekstmenuen (Aktiver kontekstmenu, Tillad skift af visningsporte, Aktiver indstillingen 'Fjern kamera', Tillad ændring af visningsportindstillinger, Aktiver valg af hoved-/underkvalitet for stream).
* **Automatisk slå lyden til**: Slår automatisk lyden fra i den aktive visningsport til, når du går i fuldskærmstilstand.
* **Skjul markør i fuld skærm**: Afkrydsningsfeltet *"Skjul markør i fuldskærmstilstand"* skjuler automatisk musemarkøren efter en kort inaktivitetsperiode under fuldskærmsvisning for at sikre en uhindret visning.
* **Sprogvalg**: Skifter øjeblikkeligt grænsefladeoversættelse (Systemstandard, polsk, engelsk).
* **UI-præferencer**: Skjul/vis visningsportstatusetiketter eller kontrolbadges (såsom automatisk skjulning af kontroloverlejringer i nederste højre hjørne af fliser, medmindre du holder musen over).
* **Standard FFmpeg-indstillinger og masseopdatering**: Tillader konfiguration af globale FFmpeg-indstillinger, der anvendes på nye visningsporte (anbefalet: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[ANBEFALING]** Hvis du migrerer fra en ældre version af KVision (før v2.4.5), anbefales det stærkt at ændre `-analyzeduration 0` til `-analyzeduration 100000` i de globale indstillinger og klikke på "Opdater alle kameraer". Indstilling af `0` på streams uden et lydspor forårsager forsinkelser i skiftet, fordi FFmpeg vil blokere for en hardkodet 5-sekunders timeout, der venter på lydpakker. Indstilling af en meget lav værdi (f.eks. 100.000 mikrosekunder = 0,1 s) løser fuldstændigt dette problem, mens øjeblikkelig skift bevares.
  * **Opdater alle kameraer-knap**: Knappen *„Zaktualizuj wszystkie kamery”* anvender disse globale muligheder på alle konfigurerede visningsporte.
  * **Flag med lav forsinkelse (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` deaktiverer intern demuxer-pakkebuffring for at eliminere streamingforsinkelse over tid, men kan forårsage hakken, hvis din netværksforbindelse til kameraet er ustabil.
    * `-flags low_delay` fortæller dekoderen at udlæse rammer med det samme, men kan forårsage korte artefakter/udtværing i strømme, der bruger B-rammer under hurtige bevægelser.
  * **Tilsidesæt afkrydsningsfelt**: Du kan udelukke specifikke visningsporte fra globale opdateringer eller dynamiske standardindstillinger ved at markere **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** i den individuelle dialogboks for visningsportindstillinger. Nyttig til fejlfinding af hakkende kameraer.


### 6. Ændringslog (ur/dokumentikon)
Præsenterer en interaktiv tidslinje, der viser hele udgivelseshistorikken, opdateringer, fejlrettelser og tilføjelser af funktioner i KVision, hvilket sikrer, at du har direkte adgang til programopdateringsdetaljer.

---

## 10. Tastaturgenveje og musekontroller

### Tastaturgenveje:
| Tast / Genvej | Handling |
|---|---|
| **F** / **F11** | Skift fuldskærmstilstand. |
| **M** | Slå lyd fra / til (fungerer for det aktive kamera med lyd). |
| **Plads** | Afspil / Sæt afspilning på pause i vinduet Afspilningsarkiv. |
| **Alt + 1** til **Alt + 9** | Hurtigt skifte til en forudindstilling/layout ved indeks 1 til 9. |
| **Alt + venstre pil** | Hurtigt skifte til forrige forudindstilling/layout i samlingen. |
| **Alt + højre pil** | Hurtigt skifte til næste forudindstilling/layout i samlingen. |
| **Piletaster (op/ned/venstre/højre)** | Naviger og flyt det aktive fokus/valg mellem kameraets visningsporte. |
| **Shift + piletaster** | Vælg flere tilstødende kameravisningsporte samtidigt (bruges til cellefletning osv.). |
| **Ctrl + N** | Åbn et nyt, uafhængigt hjælpevindue. |
| **+** / **-** | Zoom ind / Zoom ud (PTZ-kompatible Hikvision-kameraer). |
| **Shift** (træk markeringsramme) | Tving markeringsmarkering til at låse i et 16:9 billedformat under interaktiv zoom. |
| **Esc** | Afslut fuldskærmstilstand / annuller aktiv visningsportvalg. |

### Interaktion med mus:
* **Venstre museknap**:
  * **Dobbeltklik** på en kameravisningsport i gitteret maksimerer den til fuld skærm. Et andet dobbeltklik gendanner gittervisningen.
  * Træk tidslinjen i afspilningsvinduet for at navigere.
* **Knap i midten af musen (klik og træk med rullehjul)**:
  * Træk for at panorere og flytte det digitalt zoomede/forstørrede billede rundt i viewportens synsfelt (fungerer i Live, Archive og Mini-player).
* **Højre museknap (kontekstmenu)**:
  * Åbner en hurtig indstillingsmenu for den valgte visningsport (giver mulighed for at fjerne kameraet fra nettet, skifte mellem hoved-/understrømme eller få adgang til individuelle visningsparametre).
* **Rulehjul for mus**:
  * Justerer skalaen (zoom) af tidslinjen i afspilningsarkivafspilleren.

---

## 11. Optagelse af snapshots og stikonfiguration

Applikationen giver dig mulighed for hurtigt at tage snapshots af høj kvalitet fra enhver kameravisningsport i både Live View og Playback Archive mode.

### Optagelse af snapshots:
1. En kameraikonoverlejringsknap er tilgængelig i nederste højre hjørne af hver visningsport (detaljeret i afsnit 4).
2. Hvis du klikker på kameraikonet, fanges rammen og gemmer den som et JPEG-billede (kvalitet 98 - stort set tabsfrit).
3. En vellykket optagelse bekræftes ved, at kameraikonet blinker orange (`#ff7a00`) i præcis 1 sekund.
4. **Fuld opløsning**: I afspilningsarkivtilstand gemmes snapshots med streamens fulde oprindelige kildeopløsning direkte fra dekoderens billedbuffer, uanset den aktive visningsportstørrelse på skærmen eller skærmskalering.

### Gem stikonfigurationer:
1. Gå til fanen **Indstillinger** (tandhjulsikon i indstillingsvinduet).
2. Under **Save** ("Zapis") sektionen kan du konfigurere standardstierne:
   * **Standardsnapshotsti**: Mappe, hvor snapshots vil blive gemt (standard er `~/Obrazy/CCTV`).
   * **Standardoptagelsessti**: Mappe, hvor downloadede MP4-videoer vil blive gemt (standard er `~/Wideo/CCTV`).
3. Ved at klikke på browserknappen `...` åbnes dit operativsystems oprindelige mappevælger (Breeze i KDE).
4. **Browserknap-adfærd**: Mappevælgeren åbner præcist ved den sti, der er skrevet i tekstfeltet (hvis den findes). Hvis feltet er tomt, ugyldigt eller peger på en mappe, du ikke har adgang til, falder dialogen tilbage og åbnes i din hjemmemappe (`~/`).

### Brugergrænsefladeindstillinger (UI):
1. Gå til fanen **Indstillinger** (tandhjulsikon i indstillingsvinduet), eller åbn vinduet **Indstillinger** ("Opcje").
2. I afsnittet **Brugergrænsefladeindstillinger** kan du tilpasse synligheden af elementer, der er overlejret på kameraets kafelki/viewports:
   * **Vis kanalstatus i øverste venstre hjørne af visningsporten** (standard aktiveret) — Viser oplysninger om streamindlæsning, afspilning og forbindelsesstatus.
   * **Vis kameraoplysninger i nederste venstre hjørne af viewporten** (standard aktiveret) — Viser kameranavnet hentet fra Hikvision-optageren.
   * **Vis kun kontrolikoner i nederste højre hjørne af visningsporten, når du svæver** (standard aktiveret) — Skjuler automatisk kontrolknappanelet (snapshot, arkiv, 1:1 pixel-til-pixel, regionszoom), når musemarkøren er uden for den specifikke kameravisningsport. Ikonerne vises øjeblikkeligt, så snart du bevæger musen over visningsporten (ingen klik påkrævet) og forsvinder, når du forlader, hvilket maksimerer synligheden af ​​dine kamerastrømme.
   * **Vis kun infofelter, når du svæver** (standard deaktiveret) — Analog mulighed, der skjuler status øverst til venstre og navnet nederst til venstre i visningsportene, og viser en helt ren kamerastrøm, medmindre markøren flyttes over den specifikke kamerafelt.
