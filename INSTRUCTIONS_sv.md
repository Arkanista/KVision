# Användarmanual för KVision

**KVision** är en avancerad skrivbordsapplikation i VMS (Video Management System) klass designad för samtidig visning av live-videoströmmar (RTSP/ONVIF) och integration med Hikvision NVR/DVR-inspelare (både i Live-läge och Playback-arkivläge).

Programmet har optimerats för stabilitet, smidig drift (60 FPS) och minimal systemresursförbrukning.

---

## Innehållsförteckning
1. [Beskrivning av knappåtgärder](#1-description-of-button-actions)
2. [Installation och start](#2-installation-and-launching)
3. [Hantera NVR/DVR-inspelare](#3-managing-nvrdvr-recorders)
4. [Live View och Viewport Overlays](#4-live-view-and-viewport-overlays)
5. [Skärmlayouter, förinställningar och verktygsfält](#5-screen-layouts-presets-and-toolbar)
6. [Systemstatistikpanel (Systemstatistik)](#6-system-statistics-panel-system-stats)
7. [Playback Archive Player](#7-playback-archive-player)
8. [Ladda ner inspelningar (nedladdare)](#8-downloading-recordings-downloader)
9. [Avancerade inställningar och anpassning i fönstret Alternativ](#9-advanced-settings-and-customization-in-options-window)
10. [Kortkommandon och muskontroller](#10-keyboard-shortcuts-and-mouse-controls)
11. [Ta ögonblicksbilder och konfiguration av sökväg](#11-taking-snapshots-and-path-configuration)

---

## 1. Beskrivning av knappåtgärder

Det här avsnittet beskriver innebörden av alla grafiska ikoner och knappar som används i programmet.

### Översta verktygsfältet
* {ICON:quit} **Stäng fönster**: Ber om bekräftelse och stänger det aktiva fönstret eller programmet.
* {ICON:pin} **Fastfält**: Låser det övre fältet i utökat läge eller aktiverar automatisk komprimering.
* {ICON:fullscreen} **Helskärm**: Växlar det aktiva fönstret till helskärmsläge.
* {ICON:minimize} **Minimera**: Minimerar programfönstret till systemets aktivitetsfält.
* {ICON:options} **Alternativ**: Öppnar eller stänger fönstret för konfigurationsalternativ (inställningar och brännare).
* {ICON:new_window} **Nytt fönster**: Öppnar ett nytt, oberoende extra fönster för kameraströmmar.
* {ICON:archive} **Arkiv**: Öppnar arkivfönstret för uppspelningsinspelningar (tidslinje och kalender).
* {ICON:instructions} **Instruktioner**: Öppnar den här användarhandboken och fönstret för teknisk assistans.
* {ICON:stats} **Stats**: Växlar den glidande systemstatistikpanelen (CPU, RAM, GPU, Net).
* {ICON:lock} **Grid-lås**: Inaktiverar rutnätsdelningsjusteringar för att skydda din aktiva layout.
* {ICON:hamburger} **Fler alternativ**: Öppnar den glidande verktygslådan för avancerade divisionsstorlekar, förhållanden och cellsammanfogning.

### Viewport-överlägg (kameror)
* {ICON:snapshot} **Snapshot**: Fångar en förlustfri fullupplöst bild och sparar den som en JPEG-fil.
* {ICON:play} **Kameraarkiv**: Startar tidslinjens uppspelningsfönster för denna kamera (15 minuter bakåt).
* {ICON:grid_1x1} **Försök 1:1**: Visar videoströmmen i sin ursprungliga upplösning utan att töjas ut.
* {ICON:zoom_in} **Interaktiv zoom**: Växlar klicka-och-dra-förstoring för ett valt markeringsområde.
* {ICON:zoom_out} **Återställ zoom**: Återställer den digitala förstoringen och återställer hela kamerans synfält.
* {ICON:speaker_unmute} **Stäng av ljud**: Representerar en ljudström som inte är avstängd; Om du klickar på den stängs strömmen av.
* {ICON:speaker_mute} **Slå på ljud**: Representerar en dämpad ljudström; Om du klickar på den avaktiveras ljudet för strömmen.

### Uppspelningsfönsterkontroller

**Kontroller överst:**
* {ICON:close} **Stäng**: Stänger spelarfönstret för uppspelningsarkivet.
* {ICON:pin} **Fastfält**: Låser det övre fältet i utökat läge eller aktiverar automatisk komprimering.
* {ICON:fullscreen} **Helskärm**: Växlar uppspelningsfönstret till helskärmsläge.
* {ICON:sidebar} **Visa/dölj sidofält**: Växlar synligheten för det vänstra sidofältet som innehåller kameror och inspelare.
* {ICON:timeline_show} / {ICON:timeline_hide} **Visa/dölj tidslinje**: Visar eller döljer den nedre panelen som innehåller tidslinjen och uppspelningskontrollerna.
* {ICON:video_folder} **Videomapp**: Öppnar den lokala systemmappen som innehåller nedladdade videoklipp.
* {ICON:photo_folder} **Snapshot-mapp**: Öppnar den lokala systemmappen som innehåller tagna ögonblicksbilder.
* rutnätsknappar `1x1`, `1x2`, `2x1`, `2x2`: Ändrar kamerans layout för uppspelningsfönstret till 1, 2 (vertikal/horisontell) eller 4 samtidiga vyer.

**Nedre fältet och tidslinjekontroller:**
* {ICON:prev_day} **Föregående dag**: Navigerar till inspelningar från föregående kalenderdag.
* {ICON:calendar_select} **Datumväljare**: Öppnar en kalenderdialog för att välja ett specifikt datum för uppspelning.
* {ICON:next_day} **Nästa dag**: Navigerar till inspelningar av nästa kalenderdag.
* {ICON:today} **Idag**: Ändrar omedelbart uppspelningsfokus till den aktuella kalenderdagen.
* {ICON:refresh_recordings} **Uppdatera inspelningar**: Uppdaterar och återförfrågar tillgängliga inspelningssegment från enheten.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Zoomförinställningar för tidslinje**: Skalar det synliga fönstret på tidslinjen (till 1 timme, 8 timmar eller 24 timmar) för navigering med hög precision.
* {ICON:timeline_center} **Centrera tidslinjen**: Centrerar tidslinjevyn exakt runt den aktuella uppspelningstidsstämpeln.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Uppspelningshastighet**: Justerar videouppspelningsmultiplikatorn (standard 1x hastighet, 2x accelererad eller 4x snabb uppspelning).
* {ICON:download} **Ladda ner**: Öppnar nedladdningsverktyget för att exportera ett definierat videosegment från enheten.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Hoppa bakåt**: Spolar tillbaka uppspelningens tidsstämpel med 60, 45 eller 15 sekunder.
* {ICON:play} / {ICON:pause} **Spela upp/pausa**: Startar eller pausar uppspelningen av arkivvideoströmmen.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Hoppa framåt**: Förskjuter uppspelningens tidsstämpel med 15, 45 eller 60 sekunder.

**Andra diagnostiska och allmänna ikoner:**
* {ICON:calendar} **Kalender**: Representerar kalender-/schemakonfigurationer.
* {ICON:clock} **Tid**: Representerar klock- eller tidsindikatorer.
* {ICON:zoom} **Zoom**: Representerar skalning eller digital zoomkonfiguration.
* {ICON:timeline_toggle} **Tidslinjeväxling**: Representerar växling eller uppdatering av kronologiska vyer.
* {ICON:trash} **Ta bort**: Tar säkert bort konfigurerade brännare eller layouter med bekräftelse.
* {ICON:warning} **Varning**: Visas i dialogrutor för oåterkalleliga åtgärder eller raderingsvarningar.

---

## 2. Installation och start

### Installera på Arch Linux (Pacman)
För att installera programmet från det förberedda binära paketet, gå till katalogen `packaging/arch/` och kör:
```bash
sudo pacman -U kvision-2.4.6-2-x86_64.pkg.tar.zst
```
Paketet kommer automatiskt att installera programmet, aktiveringsfilen `.desktop` och de nödvändiga Hikvision SDK-biblioteken till systemsökvägen `/usr/lib/kvision`.

### Manuell kompilering (från källkod)
Om du vill kompilera programmet manuellt (t.ex. på en annan Linux-distribution) istället för att använda det färdiga paketet:

1. Installera de nödvändiga bygg- och körtidsberoendena med din pakethanterare. För Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Konfigurera projektet med CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Kompilera koden:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installera programmet i systemet:
   ```bash
   sudo cmake --install build
   ```

### Lansering
Programmet kan startas från systemmenyn eller genom att skriva i terminalen:
```bash
kvision
```

### Felsökning av systemskalning (KDE Plasma)

Från och med version 2.4.4 upptäcker KVision automatiskt och tillämpar fraktionerad skrivbordsskalning korrekt (t.ex. 125 %, 145 %, 150 %) konfigurerad i KDE-plasmainställningar genom att upprätthålla inbyggda High DPI-pass-through-policyer i Qt. Användargränssnittet bör nu skalas korrekt ur lådan utan några manuella ingrepp.

#### Native Wayland Support

För att säkerställa bästa skalningsupplevelse och prestanda under Wayland, se till att du har det valfria paketet `qt5-wayland` installerat på ditt system. Detta gör att KVision kan köras inbyggt på Wayland istället för att falla tillbaka till XWayland.

För Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

För Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Manuell åsidosättning av skalning (Legacy/Fallback)

Om du kör en äldre version, en ovanlig konfiguration, eller helt enkelt vill tvinga fram en annan skalningsfaktor manuellt än resten av systemet, kan du fortfarande åsidosätta applikationsskalningen med hjälp av miljövariabler.

Till exempel, för att tvinga fram **150 %** skalning, starta programmet från terminalen med:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Du kan tillämpa detta permanent genom att redigera programstartaren `kvision.desktop` i KDE:s menyredigerare och lägga till dessa variabler i fältet "Miljövariabler").*

---

## 3. Hantera NVR/DVR-inspelare

Så här konfigurerar du anslutningen till en Hikvision-inspelare:
1. Öppna alternativfönstret och gå till fliken **Inspelare** (serverikon).
2. Ange enhetens åtkomstdetaljer:
   * **IP-adress**: Inspelarens nätverksadress.
   * **Port**: SDK-nätverksporten (standard är `8000`).
   * **Användarnamn**: Användarnamn (t.ex. `admin`).
   * **Lösenord**: Lösenord för åtkomst till brännaren.
3. Klicka på **Anslut och upptäck** (eller **Spara och uppdatera**).
4. Efter lyckad anslutning kommer applikationen automatiskt att upptäcka alla aktiva kameror (kanaler) som är anslutna till NVR/DVR och lägga till dem i listan.
5. Genom att klicka på knappen **Generera rutnät** skapas automatiskt en visningsportlayout (förinställd) som innehåller alla aktiva kameror från den NVR-enheten i en optimal rutnätslayout.
6. **Visa kameralistor (NvrCamerasWindow)**: Genom att klicka på datorskärmens ikonknapp på en inspelares kort öppnas ett särskilt fönster som visar alla upptäckta kamerakanaler som interaktiva brickor.
7. **Generera miniatyrer (Generera miniatyrer)**: I listfönstret för NVR-kameror är knappen *"Generera miniatyrer"* tillgänglig. Genom att klicka på den får applikationen kommandon att dra enstaka bildrutor från varje kanals underström i bakgrunden och ställer in dem som bakgrundsminiatyrbilder. Detta ger en snabb visuell förhandsvisning av varje kamera utan att starta hela liveflöden.
8. **Klicka-och-lägg till funktion**: Programmet stöder inte dragning av brickor (dra och släpp) från kameralistans fönster till huvudrutnätet. Kameratilldelning görs på ett enkelt och tillförlitligt sätt: vänsterklicka först på valfri visningsportruta i huvudskärmens rutnät för att välja den (den kommer att markeras med en ljus ram), klicka sedan på den gröna **"+" (Tilldela till aktiv visningsport)**-knappen på den önskade kamerarutan i NVR-kameralistans fönster. Streamen laddas omedelbart i den platsen.
9. **SDK-sessionsstatus (punktindikator)**: Bredvid varje inspelares IP på listan finns det en färgad statusprick:
   * **Grön (INLOGGAD IN)**: Representerar en aktiv Hikvision SDK-session, som krävs för PTZ-kontroll, tidslinjearkiveringsförfrågningar och nedladdning.
   * **Röd (INTE LOGGADE IN)**: Ingen aktiv SDK-session är för närvarande etablerad (t.ex. före den första SDK-begäran eller efter manuell/automatisk utloggning). Observera att kamera RTSP live-flöden kommer att fortsätta att spela oberoende av SDK-sessionsstatus.
10. **Byte namn på lokal kamera**: Klicka på ikonen **Redigera** (penna) på valfri kameraruta i listan över NVR-kameror. Detta öppnar en dialogruta där du kan ställa in ett anpassat namn för kameran. Detta namn sparas lokalt och uppdateras omedelbart över live-spelare, tidslinje och brickvyer utan att ändra den fysiska NVR-enheten. Du kan när som helst återställa den till standardnamnet.
11. **Ta bort en brännare från listan**: Bredvid varje konfigurerad brännare på listan finns en röd papperskorgsknapp. Genom att klicka på det initieras ett säkerhetsprotokoll i två steg som är utformat för att förhindra oavsiktlig radering:
    * **Steg 1 (Bekräftelse)**: En dialogruta med titeln *“Confirm NVR Deletion”* visas och frågar om du är säker på att du vill radera inspelaren.
    * **Steg 2 (Varning)**: En andra varningsdialogruta med titeln *"Varning!"* visas och frågar om du är helt säker och medveten om vad du gör.
    * **Effekt av radering**: Efter att ha accepterat den andra varningen loggar programmet ut från den NVR-enheten i bakgrunden, raderar dess post från applikationskonfigurationen och **soppar automatiskt listan över förinställda layouter** och tar bort alla dynamiska rutnät som genererats för denna NVR-enhet.

---

## 4. Live View och Viewport Overlays

Programmets huvudfönster visar liveflödet:
* **Kamera rutnät**: Visar RTSP-strömmar eller -flöden direkt från Hikvision SDK.
* **Stream Quality Selection**: Genom att högerklicka på en kameravy kan du välja **Main Stream** för högsta upplösning eller **Sub Stream** för att minska belastningen på nätverk och grafikkort.
* **Dubbelklicka på helskärmsväxling**: Dubbelklicka med vänster musknapp på valfri kamerans vyport maximerar den omedelbart för att fylla hela det aktiva fönsterområdet (enkel visningsport i helskärm). Genom att dubbelklicka igen återställs den ursprungliga rutnätslayouten för flera kameror.
* **Auto-dölja övre fältet**: Det översta alternativverktygsfältet (topToolBar) kan automatiskt kollapsa till den övre kanten av skärmen när muspekaren lämnar sitt område (det här alternativet kan konfigureras i Inställningar -> *"Dölj översta fältet automatiskt"* eller direkt med hjälp av nålikonen i det övre fältet).
* **Multi-monitor och extra fönster**: Du kan öppna oberoende ytterligare (extra) fönster för att köra olika rutnätslayouter samtidigt på flera skärmar eller monitorer. För att öppna ett nytt fönster, använd kortkommandot `Ctrl+N` eller klicka på knappen **"Nytt fönster"** i verktygsfältet överst. Varje fönster kan konfigureras med sin egen rutnätsstorlek och vald förinställd layout.

### Viewport Overlay-knappar
I det nedre högra hörnet av varje kamerapanel/vyport visas en kontrollpanel med fyra funktionella ikoner när du håller muspekaren över den (beroende på användargränssnittets inställningar):
1. **Kameraikon (Snapshot)**: Låter dig ta en skärmdump från kameraflödet. Ögonblicksbilden sparas i strömmens fulla, ursprungliga upplösning direkt från avkodarens rambuffert, vilket undviker förluster på grund av den aktuella storleken på visningspanelen eller skärmupplösningsskalningen. Lyckad lagring av ögonblicksbilder bekräftas av att kameraikonen blinkar orange (`#ff7a00`) i exakt 1 sekund.
2. **Spelningsikon (arkiv)**: Används för att snabbt öppna inspelningsarkivet. Om du klickar på den här knappen startas automatiskt tidslinjen `PlaybackWindow` för den här kameran och startar uppspelningen **exakt 15 minuter före den aktuella systemtiden** (en bekväm snabb förskjutning bakåt).
3. **1:1-ikon (native skala)**: Växlar bildskärmsläge från bildpunkt till bildpunkt. När det är aktiverat sträcks videon inte ut eller förvrängs för att fylla brickgränserna, utan centreras istället och visas i sin ursprungliga upplösning. När detta läge är aktivt är knappbakgrunden och "1:1"-texten markerade i ljust neonljus-turkos.
4. **Ikon för förstoringsglas (interaktiv zoom)**: Låter dig förstora en specifik region i videoflödet:
   * **Aktivering**: Genom att klicka på ikonen växlas den till ett aktivt läge (turkos höjdpunkt). Markören ändrar form och ett verktygstips instruerar: *"Klicka och dra på kameraflödet för att zooma"*.
   * **Användning**: Vänsterklicka och dra en rektangulär markeringsram över liveflödet. Viewporten kommer automatiskt att beskära och skala det valda området för att fylla hela brickan.
   * **Återställ**: När du zoomar in ändrar förstoringsglasikonen sin ikon (röd kant med ett minustecken). Om du klickar på den återställs zoomen omedelbart och återgår till hela kameraflödet.

---

## 5. Skärmlayouter, förinställningar och verktygsfält

Layouter låter dig organisera arrangemanget av kameror på skärmen. Från fliken **Förinställningar** (stjärnikon) kan du:
* **Skapa nya förinställningar**: Lägg till din egen layout med valfri konfiguration av kolumner och rader (t.ex. 2x2, 3x3, 4x4).
* **Tilldela kameror**: Klicka på en visningsport i rutnätslayouten för att välja den, öppna sedan fönstret för NVR-kameror och klicka på knappen **"+" (Lägg till)** på den önskade kamerarutan. Du kan också byta vyportspositioner genom att använda högerklickskontextmenyn (*„Zamień miejscami”* / *„Swap viewports”*) i källvyporten och sedan klicka på målvyporten.

### Knappar översta fältet (Övre verktygsfältet)
Det övre skjutbara verktygsfältet tillhandahåller en omfattande uppsättning navigerings- och programkontrollknappar:
1. **Stäng fönster (röd ✕ knapp)**: Stänger det aktiva fönstret. För att förhindra oavsiktliga klick, fångar den upp stängningshändelsen och uppmanar dig med en dialogruta för att bekräfta att programmet avslutas.
2. **Fästknapp**: Styr det automatiska döljningsbeteendet för det övre verktygsfältet. När stiftet pekar vertikalt (nålt tillstånd), låses stången på plats och förblir permanent synlig. När stiftet vrids med -45 grader (oplåst läge), glider stången automatiskt uppåt och utom synhåll när musen lämnar sitt område.
3. **Helskärm (ikon med gröna pilar)**: Växlar omedelbart det aktiva fönstret till helskärmsläge och tillbaka. I helskärmsläge pekar pilarna inåt (komprimera), och i fönsterläge pekar de utåt (expandera).
4. **Minimera (cyan minimeringsikon)**: Minimerar programfönstret till aktivitetsfältet. Om du återställer det återställs fönstret till dess exakta tidigare läge (t.ex. maximerat eller helskärm).
5. **⚙️ ALTERNATIV (OPCJE)**: Växlar fönstret för konfigurationsalternativ. Om fönstret redan är öppet stänger du det genom att klicka på den här knappen.
6. **📺 NYTT FÖNSTER (NOWE OKNO)**: Öppnar en ny, oberoende och fullt konfigurerbar `Auxiliary Window`, perfekt för att utöka dina kameralayouter över flera bildskärmsinställningar.
7. **ARKIV**: Öppnar en tom `PlaybackWindow` (inspelningsspelare) med aktiv tidslinje och kalender, vilket tillåter manuella strömnings- och kameraval från valfri konfigurerad NVR via sidofältslistan.
8. **INSTRUKTIONER (INSTRUKCJA)**: Öppnar det här manualfönstret och laddar hela användardokumentationen på engelska eller polska beroende på din aktiva plats.
9. **📊 STATS (STATYSTYKI)-omkopplare**: Växlingsknapp för att dra ut övervakningspanelen för systemstatistik från den vänstra skärmkanten.
10. **Grid Lock Switch (Hänglås)**: Växla som, när den är PÅ (markerad i ljust orange), inaktiverar rutnätsändringsåtgärder på de intilliggande rutnätsknapparna, vilket skyddar din aktiva kameralayout från oavsiktliga ändringar.
11. **Väljare av rutnätsstorlek (från 1x1 till 9x9)**: En rad med nio knappar som låter dig omedelbart definiera rad- och kolumnstrukturen för din visningsport (från en enda kamera 1x1-vy upp till 81 samtidiga kameraflöden i en 9x9-layout). Den för närvarande aktiva storleken markeras i ljust orange.
12. **Fler alternativ (Hamburgermeny med tre rader)**: Knapp som öppnar den skjutbara verktygslådan `Layout & Grid Tools` för avancerad rutnätsinställning, geometrijusteringar och felsökningsalternativ (detaljerad nedan).
13. **Förinställda/Visa-knappar**: Dynamiskt återgivna knappar på höger sida av verktygsfältet som representerar dina konfigurerade och synliga förinställda layouter (t.ex. *📹 NVR*, *Visa 1*, etc.). Genom att klicka på en knapp växlar rutnätet omedelbart. Den aktiva vyn framhäver i starkt ljus-turkos.

### Avancerad rutnätsanpassning och kvoter (layout och rutnätsverktyg)
Genom att öppna menyn Hamburger (fler alternativ) visas en specialiserad layoutverktygslåda. För att aktivera dess kontroller:
1. **Lås upp verktygspanelen**: Växla omkopplaren "Lås upp verktygsrutan" längst upp. Detta är en explicit säkerhetsåtgärd för att förhindra oavsiktliga ändringar av komplexa layouter.
2. **Anpassad fönsterindelning (F2 eller tryck-och-håll)**: Verktygslådan visar rutnätsdelningsknappar från 1x1 till 9x9. En extremt avancerad funktion är möjligheten att **åsidosätta och redigera divisionsstorlekar**. Om du klickar och håller ned någon rutnätsknapp med vänster musknapp (eller fokuserar den och trycker på **F2**), visas en textruta. Du kan skriva valfri anpassad eller asymmetrisk division (som `2x3`, `1x4`, etc.) och trycka på Enter. Knappen omprogrammeras omedelbart och om du klickar på den tillämpas din anpassade layout på huvudvyporten.
3. **Geometriska förhållanden**: Gör det möjligt att tvinga rutnätsvisningen till specifika bildförhållanden:
   * **16:9 Bildförhållande**: Låser och skalar rutnätsbehållaren till widescreen 16:9-format (standard för moderna IP-kameror).
   * **4:3-bildförhållande**: Anpassar rutnätsbehållaren till det traditionella 4:3-förhållandet (vanligt i äldre analoga/IP-kameror).
4. **Gridoperationer (sammanfoga markerade celler)**: Få tillgång till den asymmetriska cellsammanfogningsfunktionen (detaljerad i avsnitt 9.2).

---

## 6. Systemstatistikpanel (Systemstatistik)

Den här panelen glider ut från den vänstra kanten av Live View-skärmen och övervakar datorns hälsa och belastningen som genereras av programmet:
* **Övervakade parametrar**:
  * **CPU/RAM**: Användning av huvudprocessorn (i % av alla kärnor) och RAM-minnet som används direkt av `kvision`-processen och dess relaterade nedladdningsunderprocesser.
  * **GPU/VRAM**: Grafikkorts kärnanvändning (i %) och mängden VRAM-grafikminne som upptas av rendering och hårdvaruavkodning (stöder fullständig lista över GPU-processer med XML-parsern från `nvidia-smi`).
  * **NÄTVERK (nät)**: Faktisk nedladdningshastighet för applikationen från alla aktiva livespelare, arkivspelare och inspelningsnedladdningsprocesser.
* **Multithreading (Stutter-Free)**: Process- och GPU-datainsamling körs på en separat systemtråd (`StatsWorker`). Detta förhindrar eventuell mikrostamning vid videorendering (inga ramar faller).
* **Fästfunktion**: Genom att klicka på knappen **"Fäst"** (stiftikon) låses panelen i expanderat tillstånd.
* **Estetik**: Diagrammen har ljusa, neongröna kanter, en gradientfyllning under diagramkurvan och en balanserad bakgrundstransparens på 35 % för att säkerställa textläsbarhet.

---

## 7. Uppspelningsarkivspelare

Tillgängligt genom att klicka på klocka/spela-ikonen bredvid en specifik kamera eller inspelare. Det möjliggör samtidig visning av arkiverade inspelningar från flera Hikvision-kameror i fulltidssynkronisering.

### Tidslinje och kontroller:
* **Snabbstart (15 minuter tillbaka)**: När du öppnar arkivet från livevyn startar spelaren automatiskt från ett ögonblick som faller **exakt 15 minuter före aktuell systemtid** (istället för att starta vid midnatt). Detta möjliggör omedelbar visning av en händelse som just inträffade.
* **Navigering**: Tidslinjen kan rullas åt vänster och höger genom att dra den med vänster musknapp.
* **Zooma (Skalning)**: Du kan smidigt ändra tidslinjeskalan med musens rullningshjul (eller zoomknappar) – från att se hela dagen ner till en exakt 10-minuters precisionsvy.
* **Genvägar för snabbzoom**: Den nedre kontrollfältet har dedikerade cirkulära ikonknappar för att omedelbart skala tidslinjevyn:
  * **"1h"-ikon**: Zoomar in tidslinjen för detaljerad inspektion över en 1-timmesperiod.
  * **ikonen "8h"**: Zoomar tidslinjen för att visa ett 8-timmarsintervall.
  * **"24h"-ikon**: Återställer zoomen så att den passar hela 24-timmarsdagen på en enda skärm.
  * **Centrera (Mål)-ikon**: Centrerar omedelbart tidslinjen så att den röda uppspelningsindikatorn är exakt i mitten av skärmen (ersätter den gamla textknappen).
* **Datumnavigering (kalender och dagar)**: Kontroller bredvid det visade datumet tillåter snabba hopp:
  * Knapparna **„<” (föregående dag)** och **„>” (Nästa dag)**: Låter dig hoppa 24 timmar bakåt eller framåt direkt utan att öppna kalenderdialogrutan.
  * **Kalenderikon**: Öppnar kalenderpopupen för att välja ett specifikt datum.
  * **Uppdatera-ikon**: Framtvingar en ny sökning av inspelningar. Genom att klicka på den sveper den lokala cachen för inspelning av tillgänglighetssegment för alla aktiva kanaler och skickar nya frågor till NVR, vilket är mycket användbart för att ladda filer som spelats in för bara några ögonblick sedan (ersätter den gamla textknappen).
  * **Ikon för idag (dagens datum/nummer)**: Hoppar omedelbart tillbaka till den aktuella dagen (ersätter den gamla textknappen).
* **Genvägar för uppspelningshastighet**:
  * **ikoner "1x", "2x" och "4x"**: Ändra uppspelningshastighetsmultiplikatorn direkt.
* **VCR-hoppknappar**:
  * **ikoner "15", "45" och "60" med cirkulära pilar**: Låter dig snabbt hoppa bakåt eller framåt med det angivna antalet sekunder.
* **Inspelningstillgänglighetsstaplar**: Färgade staplar som representerar de hittade videosegmenten på inspelarens disk återges under tidslinjen. Ett cachningssystem hindrar dem från att flimra när de dras.
* **Auto-follow (Indikatorspårning)**: Uppspelningsindikatorn (vertikal röd linje) övervakas konstant. Om indikatorn går utanför det synliga området för tidslinjen kommer vyn automatiskt att rulla för att centrera den. Detta alternativ är intelligent låst under manuell dragning av indikatorn av användaren.

### Kameras sidopanel i uppspelningsfönstret
En vertikal sidolista på spelarens högra kant listar alla konfigurerade NVR:er och deras kamerakanaler:
* **Växla kanaler**: Om du klickar på valfri kamerakanal på listan läggs den till som en aktiv uppspelningsplats på tidslinjen (som skapar en videospelare). Om du klickar på den igen tas kanalen bort.
* **Kanalkontextmeny**: Genom att högerklicka på en aktiv videoslot i uppspelningsrutnätet öppnas en meny för att:
  * Växla videokvalitet (Main Stream / Sub Stream).
  * Stäng/ta bort den aktiva spelaren från arkivuppspelningen.

---

## 8. Ladda ner inspelningar (nedladdning)

Från Playback Archive-fönstret kan du ladda ner valda segment av inspelningar direkt till din dators enhet som MP4-filer:
1. Klicka på nedladdningsikonen (nedåtpil) bredvid den valda kameran.
2. Välj tidsintervall (start och slut på inspelningen).
3. Välj destinationsfilens lagringsplats.
4. Klicka på **Ladda ner**.

### Avancerade nedladdningsfunktioner:
* **Sekventiell nedladdning av segment (1 GB delar)**: Programmet delar automatiskt upp din tidsintervallsfråga i fysiska filsegment (ungefär 1 GB vardera på NVR-enheten) och laddar ner och konverterar dem en efter en (med hjälp av tillfälliga `.pspart`-filer som konverteras direkt till `.mp4`-format). Detta säkerställer mycket stabila nedladdningar med lång varaktighet utan minnesspill eller FFmpeg-konvertering hänger sig.
* **Visualisering av övergripande framsteg**: Förloppsindikatorn (ljus blågrön färg) visar det övergripande nedladdningsförloppet för kameran över alla segment. Statustexten på förloppsfältet visar den aktuella delen och procentsatserna, t.ex. `Downloading part 1 of 3... 45% (Overall: 15%)`, med en konturstil för att garantera läsbarhet på alla bakgrunder.
* **Rengöring av IP-filnamn**: Videofilnamn (och live-/arkivögonblicksbilder) tas automatiskt bort från NVR/DVR IP-adresser för att hålla dem rena och läsbara för människor (t.ex. `4_Wejscie_glowne_2026-06-15.mp4` istället för `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Avancerade inställningar och anpassning i fönstret Alternativ

Alternativ- och konfigurationsfönstret (`SideBar`) består av sex dedikerade flikar:

### 1. Viewport-detaljer (monitorikon)
Visar avancerade parametrar för den för närvarande valda rutnätsrutan. Tillåter dig att:
* Ange en anpassad **Primär ström-URL** (RTSP/ONVIF) och en **Sekundär Backup-URL** för manuella konfigurationer.
* Växla att stänga av/avaktivera ljudkanalen för det valda kameraflödet.
* Mata in avancerade avkodare åsidosätter i textrutan **FFmpeg Options Override**.
> [!TIPS]
> För den snabbaste strömanslutningen och maximal stabilitet över RTSP är de rekommenderade parametrarna:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Layout- och rutnätsverktyg (skjutreglageikon)
Avancerade anpassningsalternativ för skärmrutnät:
* Snabbväxling för helskärmsläge.
* **Asymmetrisk cellsammanfogning (sammanfoga markerade celler)**: En mycket avancerad layoutredigerare. Håll ned **Ctrl** eller **Skift** och klicka för att välja flera intilliggande brickor på rutnätet, eller använd ditt tangentbord genom att hålla ned **Skift** och navigera med **piltangenterna**, klicka sedan på "Sammanfoga markerade celler" för att slå ihop dem till en enda större visningsport. Detta gör att du kan skapa helt anpassade asymmetriska rutmönster (t.ex. en stor kamerapanel med mindre flöden som omger den).

### 3. Inspelare (serverikon)
Fullständig konfigurationshanterare för anslutningar till Hikvision NVR/DVR-enheter (beskrivs i detalj i avsnitt 3).

### 4. Förinställningar (stjärnikon)
Hantera dina sparade rutnätslayouter och kameratilldelningar. Tillåter att skapa tomma rutnätsmallar, ändra deras ordning, växla deras översta fältets synlighet (via "Synlig"-omkopplaren) eller aktivera dem i det aktuella fönstret.

### 5. Inställningar (kugghjulsikon)
Tillåter justering av globala appinställningar:
* **Tillåt körning av flera instanser**: Om du markerar den här rutan kan du starta flera parallella kopior av KVision-processen (som standard begränsar den körningar till en enda aktiv instans).
* **Inställningar för automatisk komprimering**: Anpassar skjutanimeringstid för den översta raden och statistikpanelen.
* **Tillåt byte av visningsportar**: Kryssrutan *"Tillåt byta visningsportplatser"* låter dig omorganisera kamerapositioner på rutnätet i farten (högerklicka på källrutan -> Välj "Byt vyportar" -> Vänsterklicka på målbrickan).
* **Högerklicksbehörigheter**: Växlar till att låsa/låsa upp interaktiva kontroller i högerklickskontextmenyn (Aktivera snabbmeny, Tillåt byte av visningsportar, Aktivera alternativet "Ta bort kamera", Tillåt att ändra visningsportinställningar, Aktivera val av strömmen Huvud/Subkvalitet).
* **Automatisk avstängning**: Slår automatiskt på ljudströmmen för den aktiva visningsporten när du går in i helskärmsläge.
* **Dölj markör i helskärmsläge**: Kryssrutan *"Dölj markör i helskärmsläge"* döljer automatiskt muspekaren efter en kort inaktivitetsperiod under helskärmsvisning för att säkerställa en fri vy.
* **Språkval**: Byter omedelbart gränssnittsöversättning (Systemstandard, polska, engelska).
* **Användargränssnittsinställningar**: Dölj/visa statusetiketter för visningsport eller kontrollmärken (som att automatiskt dölja kontrollöverläggen i det nedre högra hörnet av brickor om de inte svävar).
* **Standardalternativ för FFmpeg och massuppdatering**: Gör det möjligt att konfigurera globala FFmpeg-alternativ som tillämpas på nya visningsportar (rekommenderas: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[REKOMMENDATION]** Om du migrerar från en äldre version av KVision (före v2.4.5), rekommenderas det starkt att ändra `-analyzeduration 0` till `-analyzeduration 100000` i de globala inställningarna och klicka på "Uppdatera alla kameror". Att ställa in `0` på strömmar utan ljudspår orsakar förseningar i bytet eftersom FFmpeg blockerar för en hårdkodad 5-sekunders timeout i väntan på ljudpaket. Att ställa in ett mycket lågt värde (t.ex. 100 000 mikrosekunder = 0,1s) löser detta problem fullständigt samtidigt som omedelbar växling bibehålls.
  * **Knappen Uppdatera alla kameror**: Knappen *„Zaktualizuj wszystkie kamery”* tillämpar dessa globala alternativ på alla konfigurerade visningsportar.
  * **Flaggor med låg latens (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` inaktiverar intern demuxer-paketbuffring för att eliminera strömningsfördröjning över tid, men kan orsaka stamning om din nätverksanslutning till kameran är instabil.
    * `-flags low_delay` säger åt avkodaren att mata ut ramar omedelbart, men kan orsaka korta artefakter/smeta i strömmar som använder B-ramar under snabba rörelser.
  * **Åsidosätt kryssrutan**: Du kan utesluta specifika vyportar från globala uppdateringar eller dynamiska standardinställningar genom att markera **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** i den individuella dialogrutan för visningsportinställningar. Användbar för att felsöka kameror som stammar.


### 6. Ändringslogg (klocka/dokumentikon)
Presenterar en interaktiv tidslinje som visar hela utgivningshistoriken, uppdateringar, buggfixar och funktionstillägg för KVision, vilket säkerställer att du har direkt tillgång till programuppdateringsdetaljer.

---

## 10. Kortkommandon och muskontroller

### Kortkommandon:
| Tangent / Genväg | Åtgärd |
|---|---|
| **F** / **F11** | Växla helskärmsläge. |
| **M** | Stänga av / slå på ljudet (fungerar för den aktiva kameran med ljud). |
| **Utrymme** | Spela upp / Pausa uppspelning i fönstret Playback Archive. |
| **Alt + 1** till **Alt + 9** | Snabbväxling till en förinställning/layout vid index 1 till 9. |
| **Alt + vänsterpil** | Snabbväxling till föregående förinställning/layout i samlingen. |
| **Alt + högerpil** | Snabbväxling till nästa förinställning/layout i samlingen. |
| **Piltangenter (Upp/Ner/Vänster/Höger)** | Navigera och flytta det aktiva fokuset/valet mellan kamerans visningsportar. |
| **Skift + piltangenter** | Välj flera intilliggande kameravyportar samtidigt (används för cellsammanfogning, etc.). |
| **Ctrl + N** | Öppna ett nytt, oberoende extra fönster. |
| **+** / **-** | Zooma in / Zooma ut (PTZ-kompatibla Hikvision-kameror). |
| **Esc** | Avsluta helskärmsläge / avbryt aktivt val av visningsport. |

### Musinteraktion:
* **Vänster musknapp**:
  * **Dubbelklicka** på en kameravy i rutnätet maximerar den till helskärm. Ytterligare ett dubbelklick återställer rutnätsvyn.
  * Dra tidslinjen i uppspelningsfönstret för att navigera.
* **Höger musknapp (sammanhangsmeny)**:
  * Öppnar en snabbinställningsmeny för den valda visningsporten (gör det möjligt att ta bort kameran från rutnätet, växla mellan huvud-/underströmmar eller komma åt individuella visningsparametrar).
* **Rullhjul för mus**:
  * Justerar skalan (Zoom) för tidslinjen i uppspelningsarkivspelaren.

---

## 11. Ta ögonblicksbilder och sökvägskonfiguration

Applikationen låter dig snabbt ta högkvalitativa ögonblicksbilder från valfri kameravy i både Live View och Playback Archive-läge.

### Ta ögonblicksbilder:
1. En kameraikonöverlagringsknapp finns i det nedre högra hörnet av varje visningsport (detaljerad information i avsnitt 4).
2. Genom att klicka på kameraikonen fångar ramen och sparar den som en JPEG-bild (kvalitet 98 - praktiskt taget förlustfri).
3. En lyckad tagning bekräftas av att kameraikonen blinkar orange (`#ff7a00`) i exakt 1 sekund.
4. **Full upplösning**: I läget Playback Archive sparas ögonblicksbilder med strömmens fullständiga källupplösning direkt från avkodarens rambuffert, oavsett den aktiva visningsportens storlek på skärmen eller skärmskalning.

### Spara sökvägskonfigurationer:
1. Gå till fliken **Inställningar** (kugghjulsikonen i alternativfönstret).
2. Under avsnittet **Spara** ("Zapis") kan du konfigurera standardsökvägarna:
   * **Standardsökväg för ögonblicksbilder**: Mapp där ögonblicksbilder kommer att sparas (standard är `~/Obrazy/CCTV`).
   * **Standardinspelningssökväg**: Mapp där nedladdade MP4-videor kommer att sparas (standard är `~/Wideo/CCTV`).
3. Om du klickar på webbläsarknappen `...` öppnas ditt operativsystems ursprungliga mappväljare (Breeze i KDE).
4. **Webbläsarknappbeteende**: Katalogväljaren öppnas exakt vid den sökväg som anges i textfältet (om den finns). Om fältet är tomt, ogiltigt eller pekar på en mapp som du inte har tillgång till, faller dialogrutan tillbaka och öppnas i din hemkatalog (`~/`).

### Användargränssnittsinställningar (UI):
1. Gå till fliken **Inställningar** (kugghjulsikonen i alternativfönstret) eller öppna fönstret **Alternativ** ("Opcje").
2. I avsnittet **Användargränssnittsinställningar** kan du anpassa synligheten för element överlagrade på kamerakafelki/viewports:
   * **Visa kanalstatus i det övre vänstra hörnet av visningsporten** (standard aktiverat) — Visar information om strömladdning, uppspelning och anslutningsstatus.
   * **Visa kamerainformation i det nedre vänstra hörnet av visningsporten** (standard aktiverad) — Visar kameranamnet som hämtats från Hikvision-inspelaren.
   * **Visa kontrollikoner i det nedre högra hörnet av visningsporten endast när du håller muspekaren** (standard aktiverad) — Döljer automatiskt kontrollknappspanelen (ögonblicksbild, arkiv, 1:1 pixel-till-pixel, regionzoom) när muspekaren är utanför den specifika kameravisningsporten. Ikonerna visas direkt så fort du flyttar musen över visningsporten (inget klick krävs) och försvinner när du lämnar, vilket maximerar synligheten för dina kameraströmmar.
   * **Visa informationsfält endast när du svävar** (standard inaktiverat) — Analogt alternativ som döljer statusen längst upp till vänster och namnet längst ner till vänster i visningsportarna, och visar en helt ren kameraström om inte markören flyttas över den specifika kamerarutan.
