# Brukerhåndbok for KVision

> [!MERK]
> Denne bruksanvisningen er automatisk oversatt og formatert ved hjelp av kunstig intelligens (AI).

**KVision** er en avansert VMS (Video Management System) klasse skrivebordsapplikasjon designet for samtidig visning av live videostrømmer (RTSP/ONVIF) og integrasjon med Hikvision NVR/DVR-opptakere (både i Live-modus og Playback-arkivmodus).

Programmet er optimalisert for stabilitet, jevn drift (60 FPS) og minimalt systemressursforbruk.

---

## Innholdsfortegnelse
1. [Beskrivelse av knappehandlinger](#1-description-of-button-actions)
2. [Installasjon og lansering](#2-installation-and-launching)
3. [Administrere NVR/DVR-opptakere](#3-managing-nvrdvr-recorders)
4. [Live View og Viewport Overlays](#4-live-view-and-viewport-overlays)
5. [Skjermoppsett, forhåndsinnstillinger og verktøylinje](#5-screen-layouts-presets-and-toolbar)
6. [Systemstatistikkpanel (systemstatistikk)](#6-system-statistics-panel-system-stats)
7. [Playback Archive Player](#7-playback-archive-player)
8. [Laster ned opptak (nedlaster)](#8-downloading-recordings-downloader)
9. [Avanserte innstillinger og tilpasning i alternativvinduet](#9-advanced-settings-and-customization-in-options-window)
10. [Tastatursnarveier og musekontroller](#10-keyboard-shortcuts-and-mouse-controls)
11. [Ta øyeblikksbilder og banekonfigurasjon](#11-taking-snapshots-and-path-configuration)

---

## 1. Beskrivelse av knappehandlinger

Denne delen beskriver betydningen av alle grafiske ikoner og knapper som brukes i applikasjonen.

### Øverste verktøylinje
* {ICON:quit} **Lukk vindu**: Ber om bekreftelse og lukker det aktive vinduet eller programmet.
* {ICON:pin} **Pinbar**: Låser topplinjen i utvidet tilstand eller aktiverer automatisk sammenbrudd.
* {ICON:fullscreen} **Fullskjerm**: Bytter det aktive vinduet til fullskjermmodus.
* {ICON:minimize} **Minimer**: Minimerer programvinduet til systemets oppgavelinje.
* {ICON:options} **Alternativer**: Åpner eller lukker vinduet for konfigurasjonsalternativer (innstillinger og opptakere).
* {ICON:new_window} **Nytt vindu**: Åpner et nytt, uavhengig tilleggsvindu for kamerastrømmer.
* {ICON:archive} **Arkiv**: Åpner arkivvinduet for avspillingsopptak (tidslinje og kalender).
* {ICON:instructions} **Instruksjoner**: Åpner denne brukerhåndboken og vinduet for teknisk assistanse.
* {ICON:stats} **Stats**: Veksler på det glidende systemstatistikkpanelet (CPU, RAM, GPU, Nett).
* {ICON:lock} **Grid Lock**: Deaktiverer rutenettinndelingsjusteringer for å beskytte din aktive layout.
* {ICON:hamburger} **Flere alternativer**: Åpner skyveverktøykassen for avanserte divisjonsstørrelser, forhold og cellesammenslåing.

### Viewport-overlegg (kameraer)
* {ICON:snapshot} **Øyeblikksbilde**: Tar et tapsfritt bilde i full oppløsning og lagrer det som en JPEG-fil.
* {ICON:play} **Kameraarkiv**: Starter tidslinjeavspillingsvinduet for dette kameraet (15 minutter bakover).
* {ICON:quick_play} **Hurtigavspilling (minispiller)**: Starter en arkivavspilling i visningsporten av de siste 30 minuttene, slik at du raskt kan se nylige opptak direkte i kameraflisen uten å forlate Live view.
* {ICON:grid_1x1} **Prøv 1:1**: Viser videostrømmen i sin opprinnelige, opprinnelige oppløsning uten å strekke seg.
* {ICON:zoom_in} **Interaktiv zoom**: Bytter klikk-og-dra-forstørrelse for et valgt markeringsfelt.
* {ICON:zoom_out} **Tilbakestill zoom**: Tilbakestiller den digitale forstørrelsen og gjenoppretter hele kameraets synsfelt.
* {ICON:speaker_unmute} **Demp lyd**: Representerer en udempet lydstrøm; Hvis du klikker på den, dempes strømmen.
* {ICON:speaker_mute} **Slå på lyd**: Representerer en dempet lydstrøm; Hvis du klikker på den, slås lyden på strømmen på.

### Avspillingsvindukontroller

**Topplinjekontroller:**
* {ICON:close} **Lukk**: Lukker spillervinduet for avspillingsarkiv.
* {ICON:pin} **Pinbar**: Låser topplinjen i utvidet tilstand eller aktiverer automatisk sammenbrudd.
* {ICON:fullscreen} **Fullskjerm**: Bytter avspillingsvinduet til fullskjermmodus.
* {ICON:sidebar} **Vis/skjul sidefelt**: Veksler på synligheten til venstre sidefelt som inneholder kameraer og opptakere.
* {ICON:timeline_show} / {ICON:timeline_hide} **Vis/skjul tidslinje**: Viser eller skjuler bunnpanelet som inneholder tidslinjen og avspillingskontrollene.
* {ICON:video_folder} **Videomappe**: Åpner den lokale systemmappen som inneholder nedlastede videoklipp.
* {ICON:photo_folder} **Snapshot-mappe**: Åpner den lokale systemmappen som inneholder fangede øyeblikksbilder.
* rutenettknapper `1x1`, `1x2`, `2x1`, `2x2`: Bytter kameravisningsoppsettet til avspillingsvinduet til 1, 2 (vertikal/horisontal) eller 4 samtidige visninger.

** Nederste linje og tidslinjekontroller:**
* {ICON:prev_day} **Forrige dag**: Navigerer til opptak fra forrige kalenderdag.
* {ICON:calendar_select} **Datovelger**: Åpner en kalenderdialog for å velge en bestemt dato for avspilling.
* {ICON:next_day} **Neste dag**: Navigerer til opptak av neste kalenderdag.
* {ICON:today} **I dag**: Skifter øyeblikkelig avspillingsfokuset til gjeldende kalenderdag.
* {ICON:refresh_recordings} **Oppdater opptak**: Oppdaterer og forespør tilgjengelige opptakssegmenter fra enheten på nytt.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Forhåndsinnstillinger for tidslinjezoom**: Skalerer det synlige vinduet på tidslinjen (til 1 time, 8 timer eller 24 timer) for navigering med høy presisjon.
* {ICON:timeline_center} **Sentral tidslinje**: Sentrerer tidslinjevisningen nøyaktig rundt gjeldende avspillingstidsstempel.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Avspillingshastighet**: Justerer videoavspillingsmultiplikatoren (standard 1x hastighet, 2x akselerert eller 4x rask avspilling).
* {ICON:download} **Last ned**: Åpner nedlastingsverktøyet for å eksportere et definert videosegment fra enheten.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Hopp bakover**: Spoler tilbake avspillingstidsstempelet med 60, 45 eller 15 sekunder.
* {ICON:play} / {ICON:pause} **Spill av / Pause**: Starter eller setter arkivvideostrømmen på pause.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Hopp fremover**: Fremover avspillingstidsstemplet med 15, 45 eller 60 sekunder.

**Andre diagnostiske og generelle ikoner:**
* {ICON:calendar} **Kalender**: Representerer kalender-/planleggingskonfigurasjoner.
* {ICON:clock} **Tid**: Representerer klokke- eller tidsstatusindikatorer.
* {ICON:zoom} **Zoom**: Representerer skalering eller digital zoomkonfigurasjoner.
* {ICON:timeline_toggle} **Tidslinjeveksling**: Representerer veksling eller oppdatering av kronologiske visninger.
* {ICON:trash} **Slett**: Fjerner trygt konfigurerte opptakere eller oppsett med bekreftelse.
* {ICON:warning} **Advarsel**: Vises i dialogbokser for irreversible handlinger eller sletteadvarsler.

---

## 2. Installasjon og lansering

### Installere på Arch Linux (Pacman)
For å installere programmet fra den forberedte binære pakken, gå til katalogen `packaging/arch/` og kjør:
```bash
sudo pacman -U kvision-2.6.0-1-x86_64.pkg.tar.zst
```
Pakken vil automatisk installere programmet, aktiveringsfilen `.desktop` og de nødvendige Hikvision SDK-bibliotekene til systembanen `/usr/lib/kvision`.

### Manuell kompilering (fra kildekode)
Hvis du ønsker å kompilere programmet manuelt (f.eks. på en annen Linux-distribusjon) i stedet for å bruke den ferdige pakken:

1. Installer de nødvendige bygge- og kjøretidsavhengighetene ved å bruke pakkebehandleren. For Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Konfigurer prosjektet med CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Kompiler koden:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installer applikasjonen i systemet:
   ```bash
   sudo cmake --install build
   ```

### Lansering
Programmet kan startes fra systemmenyen eller ved å skrive inn terminalen:
```bash
kvision
```

### Feilsøking av systemskalering (KDE Plasma)

Fra og med versjon 2.4.4, oppdager KVision automatisk og bruker brøkdelt skrivebordsskalering (f.eks. 125 %, 145 %, 150 %) konfigurert i KDE Plasma-innstillinger ved å håndheve innfødte High DPI pass-through-policyer i Qt. Brukergrensesnittet skal nå skaleres riktig ut av esken uten manuell inngripen.

#### Native Wayland-støtte

For å sikre den beste skaleringsopplevelsen og ytelsen under Wayland, sørg for at du har den valgfrie `qt5-wayland`-pakken installert på systemet ditt. Dette gjør at KVision kan kjøre naturlig på Wayland i stedet for å falle tilbake til XWayland.

For Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

For Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Manuell skaleringsoverstyring (eldre/reservering)

Hvis du kjører en eldre versjon, en uvanlig konfigurasjon, eller bare ønsker å manuelt fremtvinge en annen skaleringsfaktor enn resten av systemet, kan du fortsatt overstyre applikasjonsskaleringen ved å bruke miljøvariabler.

For for eksempel å tvinge frem **150 %** skalering, start applikasjonen fra terminalen med:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Du kan bruke dette permanent ved å redigere programstarteren `kvision.desktop` i KDE-menyredigering og legge til disse variablene i feltet "Miljøvariabler").*

---

## 3. Administrere NVR/DVR-opptakere

Slik konfigurerer du tilkoblingen til en Hikvision-opptaker:
1. Åpne alternativvinduet og gå til kategorien **Opptakere** (serverikon).
2. Skriv inn enhetens tilgangsdetaljer:
   * **IP-adresse**: Nettverksadressen til opptakeren.
   * **Port**: SDK-nettverksporten (standard er `8000`).
   * **Brukernavn**: Brukernavn (f.eks. `admin`).
   * **Passord**: Passord for å få tilgang til opptakeren.
3. Klikk **Koble til og oppdag** (eller **Lagre og oppdater**).
4. Ved vellykket tilkobling vil applikasjonen automatisk oppdage alle aktive kameraer (kanaler) koblet til NVR/DVR og legge dem til i listen.
5. Ved å klikke på **Generer rutenett**-knappen opprettes automatisk et visningsportoppsett (forhåndsinnstilt) som inneholder alle aktive kameraer fra den NVR-en i en optimal rutenettoppsett.
6. **Visning av kameralister (NvrCamerasWindow)**: Ved å klikke på ikonet for datamaskinskjermikonet på et opptakerkort åpnes et eget vindu som viser alle oppdagede kamerakanaler som interaktive fliser.
7. **Generer miniatyrbilder (Generer miniatyrbilder)**: I NVR-kameralistevinduet er en *"Generer miniatyrbilder"*-knapp tilgjengelig. Ved å klikke på den får applikasjonen kommandoen til å trekke enkeltbilder fra hver kanals understrøm i bakgrunnen, og angi dem som miniatyrbilder av bakgrunnen. Dette gir en rask visuell forhåndsvisning av hvert kamera uten å starte hele live-feeder.
8. **Klikk-og-legg til-funksjon**: Programmet støtter ikke å dra fliser (dra og slipp) fra kameralistevinduet til hovednettet. Kameratilordning gjøres på en enkel og pålitelig måte: først venstreklikk på en hvilken som helst visningsportflis i hovedskjermrutenettet for å velge den (den vil markeres med en lys kant), klikk deretter på den grønne **"+" (Tilordne til aktiv visningsport)**-knappen på ønsket kameraflis i NVR-kameralistevinduet. Strømmen vil umiddelbart lastes inn i det sporet.
9. **SDK-øktstatus (punktindikator)**: Ved siden av hver opptakers IP på listen er det en farget statusprikk:
   * **Grønn (LOGG PÅ)**: Representerer en aktiv Hikvision SDK-sesjon, som kreves for PTZ-kontroll, tidslinjearkivforespørsler og nedlasting.
   * **Rød (IKKE PÅLOGGGET)**: Ingen aktiv SDK-økt er for øyeblikket etablert (f.eks. før den første SDK-forespørselen eller etter manuell/automatisk utlogging). Vær oppmerksom på at kameraets RTSP-livestrømmer vil fortsette å spille uavhengig av SDK-øktstatusen.
10. **Endring av navn på lokalt kamera**: Klikk på **Rediger** (blyant)-ikonet på en kameraflis i NVR-kameralisten. Dette åpner en dialogboks som lar deg angi et egendefinert navn for kameraet. Dette navnet lagres lokalt og oppdateres umiddelbart på tvers av live-spillere, tidslinje- og flisvisninger uten å endre den fysiske NVR-enheten. Du kan tilbakestille den til standardnavnet når som helst.
11. **Fjerne en opptaker fra listen**: Ved siden av hver konfigurerte opptaker på listen er det en rød søppelbøtteknapp. Ved å klikke på den starter en to-trinns sikkerhetsprotokoll designet for å forhindre utilsiktet sletting:
    * **Trinn 1 (Bekreftelse)**: En dialogboks med tittelen *“Bekreft NVR-sletting”* vises, og spør om du er sikker på at du vil slette opptakeren.
    * **Trinn 2 (advarsel)**: En andre advarselsdialogboks med tittelen *“Advarsel!”* vises, og spør om du er helt sikker og klar over hva du gjør.
    * **Effekt av sletting**: Ved å godta den andre advarselen, logger programmet ut fra den NVR-en i bakgrunnen, sletter oppføringen fra applikasjonskonfigurasjonen og **sveiper automatisk listen over forhåndsinnstilte layouter**, og fjerner alle dynamiske rutenett generert for denne NVR-enheten.

---

## 4. Live View og Viewport Overlays

Hovedvinduet til programmet viser live-feeden:
* **Camera Grid**: Viser RTSP-strømmer eller feeder direkte fra Hikvision SDK.
* **Stream Quality Selection**: Ved å høyreklikke på en kameravisningsport, kan du velge **Hovedstrøm** for høyeste oppløsning, eller **Sub Stream** for å redusere nettverks- og grafikkortbelastningen.
* **Dobbeltklikk på fullskjerm**: Dobbeltklikk med venstre museknapp på en hvilken som helst kameravisningsport maksimerer den umiddelbart til å fylle hele det aktive vinduet (fullskjerm med én visningsport). Dobbeltklikk på nytt gjenoppretter den originale rutenettoppsettet for flere kameraer.
* **Automatisk skjul topplinje**: Den øverste alternativverktøylinjen (topToolBar) kan automatisk kollapse til øverste kant av skjermen når musepekeren forlater området sitt (dette alternativet kan konfigureres i Innstillinger -> *"Skjul automatisk topplinjen"* eller direkte ved å bruke nålikonet på topplinjen).
* **Flerskjerm- og tilleggsvinduer**: Du kan åpne uavhengige tilleggsvinduer for å kjøre forskjellige rutenettoppsett samtidig på flere skjermer eller skjermer. For å åpne et nytt vindu, bruk `Ctrl+N` tastatursnarveien, eller klikk på **"Nytt vindu"**-knappen på den øverste verktøylinjen. Hvert vindu kan konfigureres med sin egen rutenettstørrelse og valgt forhåndsinnstilt layout. For å sikre maksimal stabilitet på konfigurasjoner med flere skjermer, starter alle vinduer strengt tatt sentrert på primærskjermen med 90 % av oppløsningen.

### Viewport Overlay-knapper
I nedre høyre hjørne av hver kameraflis/visningsport vises et kontrollpanel med fem funksjonelle ikoner når du holder musepekeren over den (avhengig av UI-preferanser):
1. **Kameraikon (øyeblikksbilde)**: Lar deg ta et skjermbilde fra kamerafeeden. Øyeblikksbildet lagres i den fulle, opprinnelige oppløsningen til strømmen direkte fra dekoderrammebufferen, og unngår tap på grunn av gjeldende størrelse på visningsportflisen eller skjermoppløsningsskalering. Vellykket lagring av øyeblikksbilder bekreftes ved at kameraikonet blinker oransje (`#ff7a00`) i nøyaktig 1 sekund.
2. **Spill-ikon (arkiv)**: Brukes for å raskt åpne opptaksarkivet. Ved å klikke på denne knappen startes automatisk tidslinjen `PlaybackWindow` for dette spesifikke kameraet, og starter avspillingen **nøyaktig 15 minutter før gjeldende systemtid** (en praktisk rask forskyvning bakover).
3. **Sirkulært pilikon (hurtigavspilling / minispiller)**: Aktiverer en rask avspilling i visningsporten av kameraarkivopptak fra de siste 30 minuttene direkte inne i kameraflisen uten å forlate live-nettet eller starte hele arkivvinduet.
   * **Kontrollpanel**: Når det er aktivt, vises et glidende kontrollpanel nederst i visningsporten som inneholder:
     * **Spill av/pause**: Pauser eller gjenopptar avspillingsstrømmen.
     * **Tids- og forskyvningsvisning**: Viser gjeldende avspillingstidsstempel og dets relative alder sammenlignet med sanntid (f.eks. `-12:34` representerer 12 minutter og 34 sekunder siden).
     * **Interaktiv tidslinjeglidebryter**: Gjør det mulig å klikke eller dra for å søke hvor som helst innenfor bufferen på 30 minutter. Tilgjengelige opptakssegmenter er uthevet med blågrønn bakgrunn, og et rødt spillehode markerer gjeldende posisjon.
     * **Hastighetsmultiplikator**: Går gjennom avspillingshastigheter (`1x`, `2x` og `4x`) for å skanne opptak raskt.
     * **Lukk (✕)**: Lukker minispilleren og returnerer øyeblikkelig visningsporten til live-feeden.
   * **Støtte for panorerbar zoom**: Akkurat som i Live view, kan du bruke forstørrelsesglassverktøyet til å zoome inn på en del av minispilleren, eller holde den midterste museknappen og dra for å panorere rundt.
4. **1:1-ikon (native skala)**: Veksler piksel-til-piksel videovisningsmodus. Når aktivert, blir ikke videoen strukket eller forvrengt for å fylle flisgrensene, men i stedet sentrert og vist i sin opprinnelige oppløsning. Når denne modusen er aktiv, er knappebakgrunnen og "1:1"-teksten uthevet i lys neonlys-turkis.
5. **Forstørrelsesglass-ikon (interaktiv zoom)**: Lar deg forstørre et bestemt område av videostrømmen:
   * **Aktivering**: Ved å klikke på ikonet skifter det til en aktiv tilstand (turkis utheving). Markøren endrer form, og et verktøytips instruerer: *"Klikk og dra på kamerafeeden for å zoome"*.
   * **Operasjon**: Venstreklikk og dra et rektangulært markeringsfelt over den levende feeden. Viewporten vil automatisk beskjære og skalere det valgte området for å fylle hele flisen.
     * **Proportional zoom**: Hold nede **Shift**-tasten mens du tegner zoomrektangelet for å tvinge valget til å låse seg til et sideforhold på 16:9, strengt begrenset til visningsportens grenser.
     * **Panorere det zoomede bildet (panoreringszoom)**: Når du har zoomet inn, kan du holde nede **midtmuseknappen (rullehjul)** og dra markøren for å fritt panorere den forstørrede visningen rundt videoens synsfelt. Dette fungerer i Live View, Playback Archive og Mini-spilleren.
   * **Tilbakestill**: Når du zoomer inn, endrer forstørrelsesglassikonet sitt ikon (rød kant med et minustegn). Ved å klikke på den tilbakestilles zoomen umiddelbart, og går tilbake til hele kamerafeeden.

---

## 5. Skjermoppsett, forhåndsinnstillinger og verktøylinje

Layouts lar deg organisere arrangementet av kameraer på skjermen. Fra **Forhåndsinnstillinger**-fanen (stjerneikon) kan du:
* **Opprett nye forhåndsinnstillinger**: Legg til ditt eget oppsett med hvilken som helst konfigurasjon av kolonner og rader (f.eks. 2x2, 3x3, 4x4).
* **Tildel kameraer**: Klikk på en visningsport i rutenettoppsettet for å velge den, åpne deretter NVR-kameravinduet og klikk **"+" (Legg til)**-knappen på ønsket kameraflis. Du kan også bytte visningsportposisjoner ved å bruke høyreklikk-kontekstmenyen (*„Zamień miejscami”* / *„Swap viewports”*) til kildevisningsporten og deretter klikke på målvisningsporten.

### Topplinjeknapper (øverste verktøylinje)
Den øverste skyveverktøylinjen gir et omfattende sett med navigasjons- og programkontrollknapper:
1. **Lukk vindu (rød ✕ knapp)**: Lukker det aktive vinduet. For å forhindre utilsiktede klikk, avskjærer den avslutningshendelsen og ber deg med en dialogboks for å bekrefte å avslutte programmet.
2. **Festknapp**: Kontrollerer automatisk skjuloppførsel til den øverste verktøylinjen. Når pinnen peker vertikalt (pinned state), er stangen låst på plass og forblir permanent synlig. Når pinnen er rotert med -45 grader (ufestet tilstand), glir stangen automatisk oppover og ut av syne når musen forlater området.
3. **Fullskjerm (grønne piler-ikon)**: Bytter øyeblikkelig det aktive vinduet til fullskjermmodus og tilbake. I fullskjermmodus peker pilene innover (kollaps), og i vindusmodus peker de utover (utvid).
4. **Minimer (cyan minimeringsikon)**: Minimerer programvinduet til oppgavelinjen. Gjenoppretting returnerer vinduet til dets eksakte forrige tilstand (f.eks. maksimert eller fullskjerm).
5. **⚙️ ALTERNATIVER (OPCJE)**: Veksler på vinduet med konfigurasjonsalternativer. Hvis vinduet allerede er åpent, lukkes det ved å klikke på denne knappen.
6. **📺 NYTT VINDU (NOWE OKNO)**: Åpner en ny, uavhengig og fullt konfigurerbar `Auxiliary Window`, perfekt for å utvide kameraoppsettet på tvers av flere skjermoppsett.
7. **ARKIV**: Åpner en tom `PlaybackWindow` (opptaksspiller) med aktiv tidslinje og kalender, som tillater manuell strømming og kamerakanalvalg fra enhver konfigurert NVR via sidefeltlisten.
8. **INSTRUKSJONER (INSTRUKCJA)**: Åpner dette manualvinduet, og laster inn hele brukerdokumentasjonen på engelsk eller polsk, avhengig av din aktive lokalitet.
9. **📊 STATS (STATYSTYKI)-bryter**: Vekslebryter for å skyve ut overvåkingspanelet for systemstatistikk fra venstre skjermkant.
10. **Bryter for rutenettlås (hengelås)**: Slå den PÅ (uthevet i lys oransje), deaktiverer handlinger for å endre størrelse på rutenettet på de tilstøtende rutenettknappene, og beskytter det aktive kameraoppsettet ditt mot tilfeldige endringer.
11. **Velgere av rutenettstørrelse (fra 1x1 til 9x9)**: En rad med ni knapper som lar deg umiddelbart definere rad- og kolonnestrukturen til visningsporten din (fra ett enkelt kamera 1x1-visning opp til 81 samtidige kamerafeeder i et 9x9-oppsett). Den aktive størrelsen fremheves i lys oransje.
12. **Flere alternativer (Hamburgermeny med tre linjer)**: Knapp som åpner den glidende `Layout & Grid Tools`-verktøykassen for avansert rutenettinnstilling, geometrijusteringer og feilsøkingsalternativer (detaljert nedenfor).
13. **Forhåndsinnstilte/Vis-knapper**: Dynamisk gjengitte knapper på høyre side av verktøylinjen som representerer de konfigurerte og synlige forhåndsinnstilte layoutene dine (f.eks. *📹 NVR*, *View 1* osv.). Ved å klikke på en knapp bytter du umiddelbart rutenettet. Den aktive visningen fremhever i sterkt lys-turkis.

### Avansert rutenetttilpasning og -forhold (oppsett og rutenettverktøy)
Åpne Hamburger (Flere alternativer)-menyen får opp en spesialisert layoutverktøykasse. Slik aktiverer du kontrollene:
1. **Lås opp verktøyrute**: Slå på «Lås opp verktøyrute»-bryteren helt øverst. Dette er et eksplisitt sikkerhetstiltak for å forhindre utilsiktede endringer i komplekse oppsett.
2. **Egendefinert vindusinndeling (F2 eller trykk-og-hold)**: Verktøykassen viser rutenettinndelingsknapper fra 1x1 til 9x9. En ekstremt avansert funksjon er muligheten til å **overstyre og redigere divisjonsstørrelser**. Hvis du klikker og holder en rutenettknapp med venstre museknapp (eller fokuserer den og trykker **F2**), vises en tekstboks. Du kan skrive hvilken som helst egendefinert eller asymmetrisk inndeling (som `2x3`, `1x4` osv.) og trykke på Enter. Knappen omprogrammeres umiddelbart, og hvis du klikker på den, brukes din egendefinerte layout til hovedvisningsporten.
3. **Geometriforhold**: Gjør det mulig å tvinge rutenettvisningen til bestemte sideforhold:
   * **16:9 Aspektforhold**: Låser og skalerer rutenettbeholderen til widescreen 16:9-format (standard for moderne IP-kameraer).
   * **4:3-sideforhold**: Tilpasser rutenettbeholderen til det tradisjonelle 4:3-forholdet (vanlig i eldre analoge/IP-kameraer).
4. **Gridoperasjoner (Slå sammen uthevede celler)**: Få tilgang til funksjonen for asymmetrisk cellesammenslåing (detaljert i avsnitt 9.2).

---

## 6. Systemstatistikkpanel (systemstatistikk)

Dette panelet glir ut fra venstre kant av Live View-skjermen og overvåker datamaskinens helse og belastningen som genereres av applikasjonen:
* **Overvåkede parametere**:
  * **CPU / RAM**: Bruk av hovedprosessoren (i % av alle kjerner) og RAM-en som brukes direkte av `kvision`-prosessen og dens relaterte nedlastningsunderprosesser.
  * **GPU / VRAM**: Kjerneutnyttelse av grafikkort (i %) og mengden VRAM-grafisk minne okkupert av gjengivelse og maskinvaredekoding (støtter full liste over GPU-prosesser ved bruk av XML-parseren fra `nvidia-smi`).
  * **NETTVERK (nettverk)**: Faktisk nedlastingsoverføringshastighet for applikasjonen fra alle aktive live-spillere, arkivspillere og nedlastingsprosesser for opptak.
* **Multithreading (Stutter-Free)**: Prosess- og GPU-datainnsamling kjøres på en egen systemtråd (`StatsWorker`). Dette forhindrer mikrostamming i videogjengivelse (ingen rammefall).
* **Pin-funksjon**: Ved å klikke på **"Pin"**-knappen (pin-ikon) låses panelet i utvidet tilstand.
* **Estetikk**: Kartene har lyse, neongrønne kanter, en gradientfylling under kartkurven og en balansert 35 % bakgrunnsgjennomsiktighet for å sikre tekstlesbarhet.

---

## 7. Avspillingsarkivspiller

Tilgjengelig ved å klikke på klokke/spill-ikonet ved siden av et spesifikt kamera eller opptaker. Det gir mulighet for samtidig visning av arkiverte opptak fra flere Hikvision-kameraer i fulltidssynkronisering.

### Tidslinje og kontroller:
* **Hurtigstart (15 minutter tilbake)**: Når du åpner arkivet fra live-visningen, starter spilleren automatisk fra et øyeblikk som faller **nøyaktig 15 minutter før gjeldende systemtid** (i stedet for å starte ved midnatt). Dette gir mulighet for umiddelbar visning av en hendelse som nettopp har skjedd.
* **Navigering**: Tidslinjen kan rulles til venstre og høyre ved å dra den med venstre museknapp.
* **Zoom (Skalering)**: Du kan jevnt endre tidslinjeskalaen med musens rullehjul (eller zoomknappene) – fra å se hele dagen ned til en nøyaktig 10-minutters presisjonsvisning.
* **Hurtig zoom-snarveier**: Den nederste kontrolllinjen har dedikerte sirkulære ikonknapper for å umiddelbart skalere tidslinjevisningen:
  * **"1h"-ikon**: Zoomer inn tidslinjen for detaljert inspeksjon over et tidsrom på 1 time.
  * **«8h»-ikon**: Zoomer tidslinjen for å vise et 8-timers spenn.
  * **«24h»-ikon**: Tilbakestiller zoom slik at den passer hele 24-timersdagen på en enkelt skjerm.
  * **Senter (Mål)-ikon**: Sentrerer tidslinjen umiddelbart slik at den røde avspillingsindikatoren er nøyaktig midt på skjermen (erstatter den gamle tekstknappen).
* **Datonavigering (kalender og dager)**: Kontroller ved siden av den viste datoen tillater raske hopp:
  * **„<” (Forrige dag)** og **„>” (Neste dag)**-knapper: Lar deg hoppe 24 timer tilbake eller fremover umiddelbart uten å åpne kalenderdialogen.
  * **Kalenderikon**: Åpner kalenderens popup for å velge en bestemt dato.
  * **Oppdateringsikon**: Tvinger frem et nytt søk etter opptak. Ved å klikke på den sveiper den lokale hurtigbufferen for opptak av tilgjengelighetssegmenter for alle aktive kanaler og sender nye forespørsler til NVR, noe som er svært nyttig for å laste inn filer som ble tatt opp for bare noen få øyeblikk siden (erstatter den gamle tekstknappen).
  * **I dag (dagens dato/nummer)-ikon**: hopper umiddelbart tilbake til gjeldende dag (erstatter den gamle tekstknappen).
* **Snarveier for avspillingshastighet**:
  * **"1x", "2x" og "4x"-ikoner**: Endre multiplikatoren for avspillingshastighet umiddelbart.
* **VCR-hoppeknapper**:
  * **«15», «45» og «60»-ikoner med sirkulære piler**: Lar deg hoppe raskt bakover eller fremover med det angitte antallet sekunder.
* **Søyler for opptakstilgjengelighet**: Fargede søyler som representerer videosegmentene som er funnet på opptakerens disk, gjengis under tidslinjen. Et hurtigbuffersystem hindrer dem i å flimre mens de drar.
* **Auto-følge (Indikatorsporing)**: Avspillingsindikatoren (vertikal rød linje) overvåkes konstant. Hvis indikatoren går utenfor det synlige området til tidslinjen, vil visningen automatisk rulle for å sentrere den. Dette alternativet er intelligent låst under manuell indikatordraging av brukeren.

### Kameraets sidepanel i avspillingsvinduet
En vertikal sideliste på høyre kant av spilleren viser alle konfigurerte NVR-er og deres kamerakanaler:
* **Veksle kanaler**: Ved å klikke på en kamerakanal på listen legges den til som en aktiv avspillingsplass på tidslinjen (skaper en videospiller). Hvis du klikker på den igjen, fjernes kanalen.
* **Kanalkontekstmeny**: Høyreklikk på et aktivt videospor i avspillingsrutenettet åpner en meny for:
  * Veksle mellom videokvalitet (Hovedstrøm / Understrøm).
  * Lukk/fjern den aktive spilleren fra arkivavspillingen.

---

## 8. Laste ned opptak (nedlaster)

Fra Playback Archive-vinduet kan du laste ned utvalgte segmenter av opptak direkte til datamaskinens stasjon som MP4-filer:
1. Klikk på nedlastingsikonet (pil ned) ved siden av det valgte kameraet.
2. Velg tidsintervall (start og slutt på opptaket).
3. Velg destinasjonsfilens lagringssted.
4. Klikk **Last ned**.

### Avanserte nedlastingsfunksjoner:
* **Sekventiell segmentnedlasting (1 GB-deler)**: Programmet deler automatisk tidsintervallspørsmålet ditt i fysiske filsegmenter (omtrent 1 GB hver på NVR-stasjonen) og laster ned og konverterer dem én etter én (ved hjelp av midlertidige `.pspart`-filer som konverteres direkte til `.mp4`-format). Dette sikrer svært stabile nedlastinger med lang varighet uten minneoverflyt eller FFmpeg-konvertering henger.
* **Visualisering av total fremdrift**: Fremdriftslinjen (lys blågrønn farge) viser den generelle nedlastingsfremdriften for kameraet på tvers av alle segmenter. Statusteksten på fremdriftslinjen viser gjeldende del og prosenter, f.eks. `Downloading part 1 of 3... 45% (Overall: 15%)`, med en konturstil for å garantere lesbarhet på enhver bakgrunn.
* **Rensing av IP-filnavn**: Videofilnavn (og øyeblikksbilder av live/arkiv) fjernes automatisk for NVR/DVR IP-adresser for å holde dem rene og lesbare (f.eks. `4_Wejscie_glowne_2026-06-15.mp4` i stedet for `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Avanserte innstillinger og tilpasning i Options-vinduet

Alternativer og konfigurasjonsvinduet (`SideBar`) består av seks dedikerte faner:

### 1. Viewport-detaljer (skjermikon)
Viser avanserte parametere for den valgte rutenettflisen. Lar deg:
* Skriv inn en egendefinert **primær strøm-URL** (RTSP/ONVIF) og en **sekundær sikkerhetskopi-URL** for manuelle konfigurasjoner.
* Slå på/av demping av lydkanalen til den valgte kamerafeeden.
* Skriv inn avanserte dekoderoverstyringer i tekstboksen **FFmpeg Options Override**.
> [!TIPS]
> For den raskeste strømtilkoblingen og maksimal stabilitet over RTSP, er de anbefalte parameterne:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Oppsett- og rutenettverktøy (glidebryterikon)
Avanserte skjermrutetilpasningsalternativer:
* Rask veksling for fullskjermmodus.
* **Asymmetrisk cellesammenslåing (slå sammen uthevede celler)**: En svært avansert layoutredigerer. Hold **Ctrl** eller **Shift** og klikk for å velge flere tilstøtende fliser på rutenettet, eller bruk tastaturet ved å holde **Shift** og naviger med **piltastene**, klikk deretter på "Slå sammen uthevede celler" for å slå dem sammen til en enkelt større visningsport. Dette lar deg lage helt tilpassede asymmetriske rutenettdesign (f.eks. ett stort kamerapanel med mindre feeder rundt det).

### 3. Opptakere (serverikon)
Full konfigurasjonsbehandling for tilkoblinger til Hikvision NVR/DVR-enheter (beskrevet i detalj i avsnitt 3).

### 4. Forhåndsinnstillinger (stjerneikon)
Behandler for dine lagrede rutenettoppsett og kameraoppgaver. Gjør det mulig å lage tomme rutenettmaler, endre rekkefølgen deres, veksle synligheten i topplinjen (via «Synlig»-bryteren), eller aktivere dem i det gjeldende vinduet.

### 5. Innstillinger (tannhjulikon)
Tillater justering av globale appinnstillinger:
* **Tillat kjøring av flere forekomster**: Ved å merke av i denne boksen kan du starte flere parallelle kopier av KVision-prosessen (som standard begrenser den kjøringer til en enkelt aktiv forekomst).
* **Innstillinger for autokollaps**: Tilpasser skyveanimasjonstidspunktet for topplinjen og statistikkpanelet.
* **Tillat bytte av visningsporter**: Avmerkingsboksen *"Tillat å bytte visningsportplasser"* lar deg omorganisere kameraposisjoner på rutenettet med en gang (Høyreklikk på kildebrikken -> Velg "Bytt visningsfelt" -> Venstreklikkmålbrikke).
* **Høyreklikktillatelser**: Bytter til å låse/låse opp interaktive kontroller i høyreklikk-kontekstmenyen (Aktiver kontekstmeny, Tillat bytte av visningsporter, Aktiver alternativet "Fjern kamera", Tillat endring av visningsportinnstillinger, Aktiver valg av hoved-/underkvalitet for strøm).
* **Automatisk demping**: Slår automatisk på lydstrømmen til den aktive visningsporten når du går inn i fullskjermmodus.
* **Skjul markør i fullskjerm**: Avmerkingsboksen *"Skjul markør i fullskjermmodus"* skjuler automatisk musepekeren etter en kort periode med inaktivitet under fullskjermvisning for å sikre uhindret visning.
* **Språkvalg**: Bytter øyeblikkelig grensesnittoversettelse (systemstandard, polsk, engelsk).
* **UI-innstillinger**: Skjul/vis visningsportstatusetiketter eller kontrollmerker (for eksempel automatisk skjul av kontrolloverleggene nederst i høyre hjørne av fliser med mindre du holder pekeren).
* **Standard FFmpeg-alternativer og masseoppdatering**: Gjør det mulig å konfigurere globale FFmpeg-alternativer som brukes på nye visningsporter (anbefalt: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[ANBEFALING]** Hvis du migrerer fra en eldre versjon av KVision (før v2.4.5), anbefales det sterkt å endre `-analyzeduration 0` til `-analyzeduration 100000` i de globale innstillingene og klikke på "Oppdater alle kameraer". Innstilling av `0` på strømmer uten lydspor forårsaker forsinkelser i bytte fordi FFmpeg vil blokkere for en hardkodet 5-sekunders timeout mens du venter på lydpakker. Innstilling av en veldig lav verdi (f.eks. 100 000 mikrosekunder = 0,1 s) løser dette problemet fullstendig samtidig som øyeblikkelig veksling opprettholdes.
  * **Oppdater alle kameraer-knappen**: Knappen *„Zaktualizuj wszystkie kamery”* bruker disse globale alternativene på alle konfigurerte visningsporter.
  * **Flagg med lav latens (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` deaktiverer intern demuxer-pakkebuffring for å eliminere strømmeforsinkelse over tid, men kan forårsake stamming hvis nettverkstilkoblingen til kameraet er ustabil.
    * `-flags low_delay` forteller dekoderen å sende ut rammer umiddelbart, men kan forårsake korte artefakter/utsmøring i bekker som bruker B-rammer under raske bevegelser.
  * **Overstyr avmerkingsboks**: Du kan ekskludere spesifikke visningsporter fra globale oppdateringer eller dynamiske standardinnstillinger ved å merke av for **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** i den individuelle dialogboksen for visningsportinnstillinger. Nyttig for feilsøking av hakkende kameraer.


### 6. Endringslogg (klokke-/dokumentikon)
Presenterer en interaktiv tidslinje som viser hele utgivelseshistorikken, oppdateringer, feilrettinger og funksjonstillegg for KVision, og sikrer at du har direkte tilgang til programoppdateringsdetaljer.

---

## 10. Tastatursnarveier og musekontroller

### Tastatursnarveier:
| Tast / snarvei | Handling |
|---|---|
| **F** / **F11** | Veksle fullskjermmodus. |
| **M** | Demp / slå på lyd (fungerer for det aktive kameraet med lyd). |
| **Space** | Spill av / Pause avspilling i vinduet Playback Archive. |
| **Alt + 1** til **Alt + 9** | Rask bytte til en forhåndsinnstilling/layout ved indeksene 1 til 9. |
| **Alt + venstrepil** | Rask bytte til forrige forhåndsinnstilling/layout i samlingen. |
| **Alt + høyrepil** | Rask bytte til neste forhåndsinnstilling/layout i samlingen. |
| **Piltaster (opp/ned/venstre/høyre)** | Naviger og flytt aktivt fokus/valg mellom kameravisningsporter. |
| **Shift + piltastene** | Velg flere tilstøtende kameravisningsporter samtidig (brukes til cellesammenslåing osv.). |
| **Ctrl + N** | Åpne et nytt, uavhengig tilleggsvindu. |
| **+** / **-** | Zoom inn / Zoom ut (PTZ-kompatible Hikvision-kameraer). |
| **Shift** (dra markeringsramme) | Tving markeringsvalg til å låse i et 16:9 sideforhold under interaktiv zoom. |
| **Esc** | Avslutt fullskjermmodus / avbryt aktivt valg av visningsport. |

### Museinteraksjon:
* **Venstre museknapp**:
  * **Dobbeltklikk** på en kameravisningsport i rutenettet maksimerer den til fullskjerm. Et annet dobbeltklikk gjenoppretter rutenettvisningen.
  * Dra tidslinjen i avspillingsvinduet for å navigere.
* **Middle museknapp (klikk og dra rullehjul)**:
  * Dra for å panorere og flytte det digitalt zoomede/forstørrede bildet rundt i synsfeltet (fungerer i Live, Archive og Mini-player).
* **Høyre museknapp (kontekstmeny)**:
  * Åpner en hurtiginnstillingsmeny for den valgte visningsporten (gjør fjerning av kameraet fra rutenettet, bytte mellom hoved-/understrømmer eller tilgang til individuelle visningsparametere).
* **Rullehjul for mus**:
  * Justerer skalaen (zoom) for tidslinjen i avspillingsarkivspilleren.

---

## 11. Ta øyeblikksbilder og banekonfigurasjon

Applikasjonen lar deg raskt ta høykvalitets stillbilder fra en hvilken som helst kameravisningsport i både Live View og Playback Archive-modus.

### Ta øyeblikksbilder:
1. En kameraikonoverleggsknapp er tilgjengelig nederst til høyre i hver visningsport (detaljert i del 4).
2. Ved å klikke på kameraikonet fanges rammen og lagres som et JPEG-bilde (kvalitet 98 - praktisk talt tapsfri).
3. En vellykket opptak bekreftes ved at kameraikonet blinker oransje (`#ff7a00`) i nøyaktig 1 sekund.
4. **Full oppløsning**: I avspillingsarkivmodus lagres øyeblikksbilder med strømmens fulle opprinnelige kildeoppløsning direkte fra dekoderens rammebuffer, uavhengig av den aktive visningsportens størrelse på skjermen eller skjermskalering.

### Lagre banekonfigurasjoner:
1. Gå til kategorien **Innstillinger** (tannhjulikonet i alternativvinduet).
2. Under **Lagre** ("Zapis")-delen kan du konfigurere standardbanene:
   * **Standard bane for øyeblikksbilder**: Mappe der øyeblikksbilder vil bli lagret (standard er `~/Obrazy/CCTV`).
   * **Standard opptaksbane**: Mappe der nedlastede MP4-videoer vil bli lagret (standard er `~/Wideo/CCTV`).
3. Ved å klikke på nettleserknappen `...` åpnes operativsystemets opprinnelige mappevelger (Breeze i KDE).
4. **Nettleserknappatferd**: Katalogvelgeren åpnes nøyaktig på banen som er skrevet inn i tekstfeltet (hvis den finnes). Hvis feltet er tomt, ugyldig eller peker til en mappe du ikke har tilgang til, faller dialogen tilbake og åpnes i hjemmekatalogen din (`~/`).

### Innstillinger for brukergrensesnitt (UI):
1. Gå til kategorien **Innstillinger** (tannhjulikonet i alternativvinduet) eller åpne vinduet **Alternativer** ("Opcje").
2. I delen **Brukergrensesnittinnstillinger** kan du tilpasse synligheten til elementer som er lagt over kameraets kafelki/visningsporter:
   * **Vis kanalstatus øverst til venstre i visningsporten** (standard aktivert) — Viser informasjon om strømlasting, avspilling og tilkoblingsstatus.
   * **Vis kamerainformasjon i nedre venstre hjørne av visningsporten** (standard aktivert) — Viser kameranavnet hentet fra Hikvision-opptakeren.
   * **Vis kontrollikoner i nedre høyre hjørne av visningsporten bare når du holder pekeren** (standard aktivert) — Skjuler automatisk kontrollknapppanelet (øyeblikksbilde, arkiv, 1:1 piksel-til-piksel, regionzoom) når musepekeren er utenfor den spesifikke kameravisningsporten. Ikonene vises umiddelbart så snart du beveger musen over visningsporten (ingen klikk kreves) og forsvinner når du forlater, og maksimerer synligheten til kamerastrømmene dine.
   * **Vis informasjonsfelt kun når du svever** (standard deaktivert) – Analogt alternativ som skjuler statusen øverst til venstre og navnet nederst til venstre i visningsportene, og viser en helt ren kamerastrøm med mindre markøren flyttes over den spesifikke kameraflisen.
