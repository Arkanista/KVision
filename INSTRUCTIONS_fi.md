# KVisionin käyttöopas

> [!HUOM]
> Tämä käyttöohje on käännetty ja muotoiltu automaattisesti tekoälyn (AI) avulla.

**KVision** on edistynyt VMS (Video Management System) -luokan työpöytäsovellus, joka on suunniteltu live-videostriimien (RTSP/ONVIF) samanaikaiseen katseluun ja integrointiin Hikvision NVR/DVR -tallentimien kanssa (sekä live-tilassa että toisto-arkistotilassa).

Ohjelma on optimoitu vakautta, sujuvaa toimintaa (60 FPS) ja minimaalista järjestelmäresurssien kulutusta varten.

---

## Sisällysluettelo
1. [Painikkeiden toimintojen kuvaus](#1-description-of-button-actions)
2. [Asennus ja julkaisu](#2-installation-and-launching)
3. [NVR/DVR-tallentimien hallinta](#3-managing-nvrdvr-recorders)
4. [Live-näkymän ja näkymän peittokuvat](#4-live-view-and-viewport-overlays)
5. [Näytön asettelut, esiasetukset ja työkalupalkki](#5-screen-layouts-presets-and-toolbar)
6. [Järjestelmätilastot-paneeli (Järjestelmätilastot)](#6-system-statistics-panel-system-stats)
7. [Toisto-arkistosoitin](#7-playback-archive-player)
8. [Ladataan tallenteita (latausohjelma)](#8-downloading-recordings-downloader)
9. [Lisäasetukset ja mukauttaminen Asetukset-ikkunassa](#9-advanced-settings-and-customization-in-options-window)
10. [Pikanäppäimet ja hiiren säätimet](#10-keyboard-shortcuts-and-mouse-controls)
11. [Otetaan tilannekuvia ja määritetään polku](#11-taking-snapshots-and-path-configuration)

---

## 1. Painikkeiden toimintojen kuvaus

Tässä osiossa kuvataan kaikkien sovelluksessa käytettyjen graafisten kuvakkeiden ja painikkeiden merkitys.

### Ylätyökalupalkki
* {ICON:quit} **Sulje ikkuna**: pyytää vahvistusta ja sulkee aktiivisen ikkunan tai sovelluksen.
* {ICON:pin} **Kiinnityspalkki**: Lukitsee yläpalkin laajennettuun tilaan tai ottaa käyttöön automaattisen tiivistyksen.
* {ICON:fullscreen} **Koko näyttö**: Vaihtaa aktiivisen ikkunan koko näytön tilaan.
* {ICON:minimize} **Pienennä**: Pienentää sovellusikkunan järjestelmän tehtäväpalkkiin.
* {ICON:options} **Asetukset**: Avaa tai sulkee asetusten ikkunan (asetukset ja tallentimet).
* {ICON:new_window} **Uusi ikkuna**: Avaa uuden, itsenäisen lisäikkunan kameravirroille.
* {ICON:archive} **Arkisto**: Avaa toistotallenteiden arkistoikkunan (aikajana ja kalenteri).
* {ICON:instructions} **Ohjeet**: Avaa tämän käyttöoppaan ja teknisen tuen ikkunan.
* {ICON:stats} **Tilastot**: Vaihtaa liukuvaa järjestelmätilastopaneelia (CPU, RAM, GPU, Net).
* {ICON:lock} **Ruudukon lukitus**: Poistaa käytöstä ruudukon jaon säädöt aktiivisen asettelun suojaamiseksi.
* {ICON:hamburger} **Lisää vaihtoehtoja**: Avaa liukuvan työkalulaatikon lisäjakokokoja, -suhteita ja solujen yhdistämistä varten.

### Näkymän peittokuvat (kamerat)
* {ICON:snapshot} **Snapshot**: ottaa häviöttömän täyden resoluution kuvan ja tallentaa sen JPEG-tiedostona.
* {ICON:play} **Kameran arkisto**: käynnistää tämän kameran aikajanan toistoikkunan (15 minuuttia taaksepäin).
* {ICON:quick_play} **Pikatoisto (minisoitin)**: Aloittaa viimeisten 30 minuutin toiston katseluportissa, jolloin voit nopeasti tarkastella viimeisintä materiaalia suoraan kameraruudusta poistumatta suoranäkymästä.
* {ICON:grid_1x1} **Kokeile 1:1**: Näyttää videovirran alkuperäisessä, alkuperäisessä resoluutiossaan ilman venytystä.
* {ICON:zoom_in} **Interaktiivinen zoomaus**: Vaihtaa klikkaa ja vedä -suurennusta valitulle valintakehysalueelle.
* {ICON:zoom_out} **Palauta zoomaus**: Nollaa digitaalisen suurennuksen ja palauttaa kameran koko näkökentän.
* {ICON:speaker_unmute} **Mykistä ääni**: Edustaa mykistettyä äänivirtaa; sen napsauttaminen mykistää streamin.
* {ICON:speaker_mute} **Poista äänen mykistys**: Edustaa mykistettyä äänivirtaa; sen napsauttaminen poistaa streamin mykistyksen.

### Toistoikkunan säätimet

**Yläpalkin säätimet:**
* {ICON:close} **Sulje**: Sulkee toistoarkistosoitinikkunan.
* {ICON:pin} **Kiinnityspalkki**: Lukitsee yläpalkin laajennettuun tilaan tai ottaa käyttöön automaattisen tiivistyksen.
* {ICON:fullscreen} **Koko näyttö**: Vaihtaa toistoikkunan koko näytön tilaan.
* {ICON:sidebar} **Näytä/piilota sivupalkki**: Vaihtaa kamerat ja tallentimet sisältävän vasemman sivupalkin näkyvyyden.
* {ICON:timeline_show} / {ICON:timeline_hide} **Näytä/piilota aikajana**: Näyttää tai piilottaa aikajanan ja toistosäätimet sisältävän alapaneelin.
* {ICON:video_folder} **Videokansio**: Avaa paikallisen järjestelmäkansion, joka sisältää ladatut videoleikkeet.
* {ICON:photo_folder} **Snapshot-kansio**: Avaa paikallisen järjestelmäkansion, joka sisältää kaapattuja tilannekuvia.
* ruudukkopainikkeet `1x1`, `1x2`, `2x1`, `2x2`: Vaihtaa toistoikkunan kameran näytön asettelun 1, 2 (pysty/vaaka) tai 4 samanaikaiseen näkymään.

**Alarivin ja aikajanan säätimet:**
* {ICON:prev_day} **Edellinen päivä**: Siirtyy edellisen kalenteripäivän tallenteisiin.
* {ICON:calendar_select} **Päivämäärän valitsin**: Avaa kalenterin valintaikkunan, jossa voit valita tietyn päivämäärän toistoa varten.
* {ICON:next_day} **Seuraava päivä**: siirtyy seuraavan kalenteripäivän tallenteisiin.
* {ICON:today} **Tänään**: Siirtää välittömästi toiston painopisteen nykyiseen kalenteripäivään.
* {ICON:refresh_recordings} **Päivitä tallenteet**: Päivittää ja kysyy uudelleen käytettävissä olevia tallennussegmenttejä laitteesta.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Aikajanan zoomauksen esiasetukset**: Skaalaa aikajanan näkyvän ikkunan (1 tuntiin, 8 tuntiin tai 24 tuntiin) erittäin tarkkaa navigointia varten.
* {ICON:timeline_center} **Keskiaikajana**: Keskittää aikajananäkymän tarkasti nykyisen toiston aikaleiman ympärille.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Toistonopeus**: Säätää videon toistokerrointa (normaali 1x nopeus, 2x kiihdytetty tai 4x nopea toisto).
* {ICON:download} **Lataa**: Avaa lataustyökalun määritetyn videosegmentin viemiseksi laitteesta.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Siirry taaksepäin**: Kelaa toiston aikaleimaa 60, 45 tai 15 sekuntia taaksepäin.
* {ICON:play} / {ICON:pause} **Toista / Keskeytä**: Aloittaa tai keskeyttää arkiston videovirran toiston.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Siirry eteenpäin**: Siirtää toiston aikaleimaa eteenpäin 15, 45 tai 60 sekuntia.

**Muut diagnostiikka- ja yleiskuvakkeet:**
* {ICON:calendar} **Kalenteri**: Edustaa kalenterin/aikataulun määrityksiä.
* {ICON:clock} **Aika**: Ilmoittaa kellon tai ajan tilailmaisimia.
* {ICON:zoom} **Zoomaus**: Edustaa skaalaus- tai digitaalizoomausasetuksia.
* {ICON:timeline_toggle} **Aikajanan vaihto**: Ilmoittaa kronologisten näkymien vaihtamista tai päivittämistä.
* {ICON:trash} **Poista**: Poistaa määritetyt tallentimet tai asettelut turvallisesti vahvistuksen kanssa.
* {ICON:warning} **Varoitus**: Näytetään valintaikkunoissa peruuttamattomien toimintojen tai poistovaroitusten varalta.

---

## 2. Asennus ja käynnistys

### Asennus Arch Linuxiin (Pacman)
Asenna ohjelma valmiista binaaripaketista siirtymällä hakemistoon `packaging/arch/` ja suorittamalla:
```bash
sudo pacman -U kvision-2.6.0-1-x86_64.pkg.tar.zst
```
Paketti asentaa automaattisesti ohjelman, aktivointitiedoston `.desktop` ja tarvittavat Hikvision SDK -kirjastot järjestelmäpolkuun `/usr/lib/kvision`.

### Manuaalinen käännös (lähdekoodista)
Jos haluat kääntää ohjelman manuaalisesti (esim. toisessa Linux-jakelussa) valmiin paketin käyttämisen sijaan:

1. Asenna tarvittavat koontiversiot ja ajonaikaiset riippuvuudet paketinhallinnan avulla. Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Määritä projekti CMakella:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Kokoa koodi:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Asenna sovellus järjestelmään:
   ```bash
   sudo cmake --install build
   ```

### Käynnistetään
Ohjelma voidaan käynnistää järjestelmävalikosta tai kirjoittamalla terminaaliin:
```bash
kvision
```

### Järjestelmän skaalauksen vianmääritys (KDE Plasma)

Versiosta 2.4.4 alkaen KVision tunnistaa automaattisesti ja käyttää oikein murto-osaa työpöydän skaalausta (esim. 125%, 145%, 150%), joka on määritetty KDE Plasma -asetuksissa pakottamalla natiivit High DPI -läpivientikäytännöt Qt:ssä. Käyttöliittymän pitäisi nyt skaalautua oikein heti käyttövalmiiksi ilman manuaalisia toimenpiteitä.

#### Native Wayland -tuki

Varmistaaksesi parhaan skaalauskokemuksen ja suorituskyvyn Waylandissa, varmista, että valinnainen `qt5-wayland`-paketti on asennettu järjestelmääsi. Tämä sallii KVisionin toimia alkuperäisesti Waylandissa sen sijaan, että se palaisi XWaylandiin.

Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Manuaalinen skaalauksen ohitus (vanha/vara)

Jos käytät vanhempaa versiota, epätavallista kokoonpanoa tai haluat yksinkertaisesti pakottaa manuaalisesti erilaisen skaalaustekijän kuin muualla järjestelmässä, voit silti ohittaa sovelluksen skaalauksen käyttämällä ympäristömuuttujia.

Esimerkiksi, jos haluat pakottaa **150 %** skaalauksen, käynnistä sovellus päätteestä seuraavasti:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Voit ottaa tämän käyttöön pysyvästi muokkaamalla sovellusten käynnistysohjelmaa `kvision.desktop` KDE-valikkoeditorissa ja lisäämällä nämä muuttujat "Ympäristömuuttujat" -kenttään).*

---

## 3. NVR/DVR-tallentimien hallinta

Yhteyden määrittäminen Hikvision-tallentimeen:
1. Avaa asetusikkuna ja siirry **Tallentimet**-välilehteen (palvelinkuvake).
2. Anna laitteen käyttöoikeustiedot:
   * **IP-osoite**: tallentimen verkko-osoite.
   * **Portti**: SDK-verkkoportti (oletus on `8000`).
   * **Käyttäjänimi**: Käyttäjänimi (esim. `admin`).
   * **Salasana**: Salasana tallentimen käyttöön.
3. Napsauta **Yhdistä ja löydä** (tai **Tallenna ja päivitä**).
4. Kun yhteys on onnistunut, sovellus tunnistaa automaattisesti kaikki aktiiviset kamerat (kanavat), jotka on liitetty NVR/DVR:ään ja lisää ne luetteloon.
5. Napsauttamalla **Luo ruudukko** -painiketta luodaan automaattisesti näkymän asettelu (esiasetus), joka sisältää kaikki kyseisen NVR:n aktiiviset kamerat optimaalisessa ruudukkoasettelussa.
6. **Kameraluetteloiden näyttäminen (NvrCamerasWindow)**: Napsauttamalla tietokoneen näyttökuvakepainiketta minkä tahansa tallentimen kortilla avaa erillinen ikkuna, jossa näkyvät kaikki havaitut kamerakanavat interaktiivisina ruutuina.
7. **Pikkukuvien luominen (Luo pikkukuvat)**: NVR-kameraluetteloikkunassa on *"Luo pikkukuvat"* -painike. Napsauttamalla sitä komento sovellus vetää yksittäisiä kehyksiä kunkin kanavan alivirrasta taustalla ja asettaa ne ruudun taustan miniatyyreiksi. Tämä tarjoaa nopean visuaalisen esikatselun jokaisesta kamerasta käynnistämättä täysiä live-syötteitä.
8. **Klikkaa ja lisää -ominaisuus**: Sovellus ei tue laattojen vetämistä (vedä ja pudota) kameraluetteloikkunasta pääruudukkoon. Kameran määrittäminen tehdään yksinkertaisella ja luotettavalla tavalla: napsauta ensin hiiren vasemmalla painikkeella mitä tahansa näyttöruudun ruutua päänäytön ruudukossa sen valitsemiseksi (se korostuu kirkkaalla reunuksella), napsauta sitten vihreää **"+" (Assign to active viewport)** -painiketta haluamasi kameraruudun kohdalla NVR-kameraluetteloikkunassa. Streami latautuu välittömästi kyseiseen paikkaan.
9. **SDK-istunnon tila (pisteilmaisin)**: jokaisen luettelossa olevan tallentimen IP-osoitteen vieressä on värillinen tilapiste:
   * **Vihreä (KIRJUNUT SISÄÄN)**: Edustaa aktiivista Hikvision SDK -istuntoa, jota tarvitaan PTZ-ohjaukseen, aikajanan arkistointipyyntöihin ja lataamiseen.
   * **Punainen (EI KIRJUNUT SISÄÄN)**: Aktiivista SDK-istuntoa ei ole tällä hetkellä muodostettu (esim. ennen ensimmäistä SDK-pyyntöä tai manuaalisen/automaattisen uloskirjautumisen jälkeen). Huomaa, että kameran RTSP-live-syötteet toistetaan edelleen SDK-istunnon tilasta riippumatta.
10. **Paikallisen kameran uudelleennimeäminen**: napsauta missä tahansa NVR-kameraluettelon kameraruudussa **Muokkaa** (kynä) -kuvaketta. Tämä avaa valintaikkunan, jossa voit määrittää mukautetun nimen kameralle. Tämä nimi tallennetaan paikallisesti, ja se päivitetään välittömästi live-soittimissa, aikajanalla ja ruutunäkymissä muuttamatta fyysistä NVR-laitetta. Voit palauttaa sen oletusnimeen milloin tahansa.
11. **Tallentimen poistaminen luettelosta**: Jokaisen luettelossa määritetyn tallentimen vieressä on punainen roskakoripainike. Sen napsauttaminen käynnistää kaksivaiheisen suojausprotokollan, joka on suunniteltu estämään tahaton poistaminen:
    * **Vaihe 1 (vahvistus)**: Näyttöön tulee valintaikkuna, jonka otsikko on *"Confirm NVR Deletion"* ja kysyy, haluatko varmasti poistaa tallentimen.
    * **Vaihe 2 (Varoitus)**: Toinen varoitusikkuna, jonka otsikko on *"Varoitus!"*, tulee näkyviin ja kysyy, oletko täysin varma ja tietoinen tekemästäsi.
    * **Poistamisen vaikutus**: Hyväksyessään toisen varoituksen ohjelma kirjautuu ulos kyseisestä NVR:stä taustalla, poistaa merkinnän sovelluksen määrityksistä ja **pyyhkäisee automaattisesti esiaseteltujen asettelujen luettelon** ja poistaa kaikki tälle NVR-laitteelle luodut dynaamiset ruudukot.

---

## 4. Live View ja Viewport Overlays

Ohjelman pääikkuna näyttää live-syötteen:
* **Kameraruudukko**: Näyttää RTSP-suorat tai syötteet suoraan Hikvision SDK:sta.
* **Virran laadun valinta**: Napsauta hiiren kakkospainikkeella kameran kuvaporttia, voit valita **Päävirran** korkeimman resoluution tai **Alivirran** vähentääksesi verkon ja näytönohjaimen kuormitusta.
* **Kaksoisnapsautuksen koko näytön vaihto**: Kaksoisnapsauttaminen hiiren vasemmalla painikkeella mitä tahansa kameran näkymää maksimoi sen välittömästi täyttämään koko aktiivisen ikkuna-alueen (yhden näkymän koko näyttö). Kaksoisnapsauttaminen uudelleen palauttaa alkuperäisen usean kameran ruudukkoasettelun.
* **Yläpalkin automaattinen piilottaminen**: Ylävalikon työkalupalkki (topToolBar) voi tiivistyä automaattisesti näytön yläreunaan, kun hiiren osoitin poistuu alueelta (tämä vaihtoehto on määritettävissä kohdassa Asetukset -> *"Supista yläpalkki automaattisesti"* tai suoraan yläpalkin nastakuvakkeella).
* **Monimonitori ja apuikkunat**: Voit avata itsenäisiä lisäikkunoita (apu)ikkunoita ajaaksesi erilaisia ​​ruudukkoasetteluja samanaikaisesti useilla näytöillä tai näytöillä. Voit avata uuden ikkunan käyttämällä `Ctrl+N`-pikanäppäintä tai napsauttamalla **Uusi ikkuna** -painiketta liukuvan ylätyökalupalkin päällä. Jokaiselle ikkunalle voidaan määrittää oma ruudukkokoko ja valittu esiasetettu asettelu. Maksimaalisen vakauden varmistamiseksi usean näytön kokoonpanoissa kaikki ikkunat käynnistyvät tiukasti ensisijaisen näytön keskellä 90 prosentin resoluutiolla.

### Näkymän peittopainikkeet
Kunkin kameraruudun/näkymäportin oikeassa alakulmassa näkyy ohjauspaneeli, jossa on viisi toiminnallista kuvaketta, kun hiiren osoitin viedään sen päälle (käyttöliittymän asetuksista riippuen):
1. **Kamerakuvake (Snapshot)**: Voit ottaa kuvakaappauksen kameran syötteestä. Tilannekuva tallennetaan virran täydellä alkuperäisellä resoluutiolla suoraan dekooderin kehyspuskurista, jolloin vältetään näkymän nykyisestä koosta tai näytön resoluution skaalauksesta johtuvat häviöt. Onnistuneen valokuvan tallennuksen vahvistaa kamerakuvake, joka vilkkuu oranssina (`#ff7a00`) tasan 1 sekunnin ajan.
2. **Toistokuvake (arkisto)**: Käytetään tallenteiden arkiston nopeaan avaamiseen. Tämän painikkeen napsauttaminen käynnistää automaattisesti aikajanan `PlaybackWindow` tälle tietylle kameralle ja aloittaa toiston **täsmälleen 15 minuuttia ennen nykyistä järjestelmäaikaa** (kätevä nopea siirtymä taaksepäin).
3. **Pyöreä nuolikuvake (pikatoisto / minisoitin)**: Aktivoi viimeisen 30 minuutin kamera-arkistotallenteiden nopean toiston näkymäportissa suoraan kameraruudun sisällä poistumatta live-ruudukosta tai käynnistämättä koko arkistoikkunaa.
   * **Ohjauspaneeli**: Kun aktiivinen, näkymän alaosaan tulee liukuva ohjauspaneeli, joka sisältää:
     * **Toista/tauko**: keskeyttää toiston tai jatkaa sitä.
     * **Aika- ja siirtymänäyttö**: Näyttää nykyisen toiston aikaleiman ja sen suhteellisen iän verrattuna reaaliaikaan (esim. `-12:34` edustaa 12 minuuttia ja 34 sekuntia sitten).
     * **Interaktiivinen aikajanan liukusäädin**: Mahdollistaa napsauttamalla tai vetämällä hakeaksesi minne tahansa 30 minuutin puskurissa. Käytettävissä olevat tallennussegmentit on korostettu sinivihreällä taustalla, ja punainen toistopaikka osoittaa nykyisen sijainnin.
     * **Nopeuskerroin**: Vaihtaa toistonopeuksia (`1x`, `2x` ja `4x`) skannatakseen materiaalia nopeasti.
     * **Sulje (✕)**: sulkee minisoittimen ja palauttaa näkymän välittömästi live-syötteeseen.
   * **Pannutettavan zoomauksen tuki**: Aivan kuten live-näkymässä, voit käyttää suurennuslasityökalua lähentääksesi minisoittimen tiettyä aluetta tai panoroidaksesi vetämällä hiiren keskipainiketta.
4. **1:1-kuvake (alkuperäinen mittakaava)**: Vaihtaa pikselien välisen videon näyttötilan. Kun tämä on käytössä, videota ei venytetä tai vääristetä täyttämään ruudun rajoja, vaan se keskitetään ja näytetään alkuperäisessä alkuperäisessä resoluutiossaan. Kun tämä tila on aktiivinen, painikkeen tausta ja "1:1"-teksti on korostettu kirkkaan neon vaalean turkoosin värisenä.
5. **Suurennuslasikuvake (interaktiivinen zoomaus)**: Voit suurentaa mitä tahansa videosyötteen aluetta:
   * **Aktivointi**: kuvakkeen napsauttaminen vaihtaa sen aktiiviseen tilaan (turkoosi korostus). Kohdistin muuttaa muotoa, ja työkaluvihje neuvoo: *"Zoomaa napsauttamalla ja vetämällä kameran syötettä"*.
   * **Toiminta**: Napsauta hiiren kakkospainikkeella ja vedä suorakaiteen muotoinen valintakehys live-syötteen päälle. Näkymä rajaa ja skaalaa valitun alueen automaattisesti täyttämään koko ruudun.
     * **Suhteellinen zoomaus**: Pidä **Vaihto**-näppäintä painettuna samalla kun piirrät zoomaussuorakulmiota pakottaaksesi valinnan lukittumaan 16:9-kuvasuhteeseen, joka on tiukasti rajoitettu kuvaportin rajoihin.
     * **Zoomatun kuvan panorointi (Pan Zoom)**: Kun olet zoomannut, voit pitää **hiiren keskipainiketta (vierityspyörää)** painettuna ja vetämällä osoitinta panoroidaksesi suurennettua näkymää vapaasti videon näkökentän ympärillä. Tämä toimii suorassa näkymässä, toistoarkistossa ja minisoittimessa.
   * **Nollaa**: Kun zoomataan, suurennuslasikuvake vaihtaa kuvaketta (punainen reunus miinusmerkillä). Sen napsauttaminen nollaa zoomauksen välittömästi ja palaa kameran täyteen syötteeseen.

---

## 5. Näytön asettelut, esiasetukset ja työkalupalkki

Asettelujen avulla voit järjestää kameroiden sijoittelun näytölle. **Esiasetukset**-välilehdellä (tähtikuvake) voit:
* **Luo uusia esiasetuksia**: Lisää oma asettelusi millä tahansa sarake- ja rivimäärityksellä (esim. 2x2, 3x3, 4x4).
* **Kameroiden määrittäminen**: Napsauta ruudukkoasettelun näkymää valitaksesi sen, avaa sitten NVR-kamerat-ikkuna ja napsauta **"+" (Lisää)** -painiketta halutussa kameraruudussa. Voit myös vaihtaa näkymän paikkoja käyttämällä lähdenäkymän hiiren kakkospainikkeen kontekstivalikkoa (*"Zamień miejscami"* / *"Vaihda näkymäportteja"*) ja napsauttamalla sitten kohdenäkymää.

### Yläpalkin painikkeet (ylätyökalupalkki)
Ylhäällä oleva liukuva työkalupalkki tarjoaa kattavan joukon navigointi- ja sovellusten ohjauspainikkeita:
1. **Sulje ikkuna (punainen ✕-painike)**: Sulkee aktiivisen ikkunan. Vahingon napsautuksen estämiseksi se sieppaa sulkemistapahtuman ja kehottaa sinua vahvistamaan sovelluksesta poistumisen valintaikkunassa.
2. **Kiinnityspainike**: Ohjaa ylätyökalupalkin automaattista piilottamista. Kun tappi osoittaa pystysuoraan (kiinnitetty tila), palkki lukittuu paikalleen ja pysyy jatkuvasti näkyvissä. Kun nastaa käännetään -45 astetta (kiinnittämätön tila), palkki liukuu automaattisesti ylöspäin pois näkyvistä, kun hiiri poistuu alueelta.
3. **Koko näyttö (vihreä nuolikuvake)**: vaihtaa aktiivisen ikkunan välittömästi koko näytön tilaan ja takaisin. Koko näytön tilassa nuolet osoittavat sisäänpäin (tiivistää), ja ikkunatilassa ne osoittavat ulospäin (laajenna).
4. **Minimoi (syaanin pienennyskuvake)**: Pienennä sovellusikkunan tehtäväpalkkiin. Sen palauttaminen palauttaa ikkunan tarkalleen edelliseen tilaan (esim. maksimoitu tai koko näyttö).
5. **⚙️ ASETUKSET (OPCJE)**: Vaihtaa asetusten ikkunan. Jos ikkuna on jo auki, tämän painikkeen napsauttaminen sulkee sen.
6. **📺 UUSI IKKUNA (NYT OKNO)**: Avaa uuden, itsenäisen ja täysin konfiguroitavan `Auxiliary Window`, joka on täydellinen kamera-asettelujen laajentamiseen useiden näyttöasetusten välillä.
7. **ARKISTO**: Avaa tyhjän `PlaybackWindow` (tallennussoittimen), jossa on aktiivinen aikajana ja kalenteri, mikä mahdollistaa manuaalisen suoratoiston ja kamerakanavan valinnan mistä tahansa määritetystä NVR:stä sivupalkkiluettelon kautta.
8. **OHJEET (INSTRUKCJA)**: Avaa tämän käsikirja-ikkunan ja lataa täydelliset käyttöoppaat englanniksi tai puolaksi aktiivisen maa-asetuksen mukaan.
9. **📊 STATS (STATYSTYKI) -kytkin**: Liu'uta System Statistics -valvontapaneeli ulos näytön vasemmasta reunasta vaihtokytkimellä.
10. **Ruudukon lukituskytkin (riippulukko)**: Kytkin, joka, kun se on PÄÄLLÄ (korostettu kirkkaan oranssilla), poistaa käytöstä viereisten ruudukon painikkeiden ruudukon koon muutostoiminnot ja suojaa aktiivisen kameran asettelua vahingossa tapahtuvilta muutoksilta.
11. **Ruudukon koon valitsimet (1x1 - 9x9)**: yhdeksän painikkeen rivi, jonka avulla voit määrittää välittömästi näkymän rivi- ja sarakerakenteen (yhdestä kameran 1x1-näkymästä 81 samanaikaiseen kameran syöttöön 9x9-asettelussa). Tällä hetkellä aktiivinen koko korostuu kirkkaan oranssilla.
12. **Lisävaihtoehtoja (Hampurilaisvalikko kolmella rivillä)**: Painike, joka avaa liukuvan `Layout & Grid Tools`-työkalulaatikon ruudukon edistyneille virityksille, geometrian säädöille ja virheenkorjausvaihtoehdoille (yksityiskohtaiset tiedot alla).
13. **Esiasetus-/Näytä-painikkeet**: Työkalupalkin oikealla puolella olevat dynaamisesti renderoidut painikkeet, jotka edustavat määritettyjä ja näkyviä esiaseteltuja asettelujasi (esim. *📹 NVR*, *Näytä 1* jne.). Painikkeen napsauttaminen vaihtaa ruudukkoa välittömästi. Aktiivinen näkymä korostuu kirkkaan vaalean turkoosin värisenä.

### Kehittynyt ruudukon mukauttaminen ja suhteet (asettelu- ja ruudukkotyökalut)
Hampurilainen (More Options) -valikon avaaminen tuo esiin erikoisen asettelutyökalulaatikon. Voit aktivoida sen säätimet seuraavasti:
1. **Työkalupaneelin lukituksen avaaminen**: Vaihda yläreunassa olevaa Avaa työkalupaneeli -kytkintä. Tämä on selkeä turvatoimenpide, jolla estetään tahattomat muutokset monimutkaisiin asetteluihin.
2. **Mukautettu ikkunan jako (F2 tai paina ja pidä)**: Työkalulaatikossa näkyy ruudukon jakopainikkeet 1x1 - 9x9. Erittäin kehittynyt ominaisuus on kyky **ohita ja muokata jakokokoja**. Jos napsautat ja pidät painettuna mitä tahansa ruudukkopainiketta hiiren vasemmalla painikkeella (tai tarkennat sitä ja painat **F2**), tekstiruutu tulee näkyviin. Voit kirjoittaa minkä tahansa mukautetun tai epäsymmetrisen jaon (kuten `2x3`, `1x4` jne.) ja paina Enter. Painike ohjelmoidaan välittömästi uudelleen, ja sen napsauttaminen ottaa mukautetun asettelun käyttöön päänäkymässä.
3. **Geometriasuhteet**: Mahdollistaa ruudukon näytön pakottamisen tiettyihin kuvasuhteisiin:
   * **16:9-kuvasuhde**: Lukitsee ja skaalaa ruudukon 16:9-laajakuvamuotoon (standardi nykyaikaisille IP-kameroille).
   * **4:3-kuvasuhde**: mukauttaa ruudukkosäiliön perinteiseen 4:3-kuvasuhteeseen (yleinen vanhoissa analogisissa/IP-kameroissa).
4. **Ruudukkotoiminnot (Yhdistä korostetut solut)**: Käytä epäsymmetristä solujen yhdistämisominaisuutta (yksityiskohtaisesti kohdassa 9.2).

---

## 6. Järjestelmätilastot-paneeli (Järjestelmätilastot)

Tämä paneeli liukuu ulos Live View -näytön vasemmasta reunasta ja valvoo tietokoneen tilaa ja sovelluksen tuottamaa kuormitusta:
* **Valvotut parametrit**:
  * **CPU / RAM**: Pääprosessorin käyttö (% kaikista ytimistä) ja `kvision`-prosessin ja siihen liittyvien latausaliprosessien suoraan käyttämän RAM-muistin käyttö.
  * **GPU / VRAM**: Näytönohjaimen ytimen käyttöaste (%) ja VRAM-grafiikkamuistin määrä, jonka renderöinti ja laitteistodekoodaus käyttävät (tukee GPU-prosessien täydellistä luetteloa käyttämällä XML-jäsennintä osoitteesta `nvidia-smi`).
  * **VERKKO (verkko)**: Sovelluksen todellinen latausnopeus kaikista aktiivisista live-soittimista, arkistosoittimista ja tallenteiden latausprosesseista.
* **Monisäikeinen (äänitön)**: Prosessin ja GPU:n tiedonkeruu suoritetaan erillisessä järjestelmäsäikeessä (`StatsWorker`). Tämä estää mikropäkimisen videon renderöinnissä (ei kehysten putoamista).
* **Kiinnitysominaisuus**: **Kiinnitä**-painikkeen (pin-kuvake) napsauttaminen lukitsee paneelin laajennettuun tilaan.
* **Estetiikka**: Kaavioissa on kirkkaat, neonvihreät reunat, kaltevuustäyttö kaaviokäyrän alla ja tasapainoinen 35 %:n taustan läpinäkyvyys tekstin luettavuuden varmistamiseksi.

---

## 7. Toisto-arkistosoitin

Saatavilla napsauttamalla kello/toistokuvaketta tietyn kameran tai tallentimen vieressä. Se mahdollistaa useiden Hikvision-kameroiden arkistoitujen tallenteiden samanaikaisen katselun täysiaikaisesti synkronoituna.

### Aikajana ja säätimet:
* **Pikakäynnistys (15 minuuttia taaksepäin)**: Kun avaat arkiston live-näkymästä, soitin aloittaa automaattisesti hetkestä, joka putoaa **täsmälleen 15 minuuttia ennen nykyistä järjestelmän aikaa** (sen sijaan, että se alkaisi keskiyöllä). Tämä mahdollistaa juuri tapahtuneen tapahtuman välittömän katselun.
* **Navigointi**: Aikajanaa voidaan vierittää vasemmalle ja oikealle vetämällä sitä hiiren vasemmalla painikkeella.
* **Zoomaus (skaalaus)**: Voit vaihtaa aikajanan skaalaa sujuvasti hiiren vierityspyörällä (tai zoomauspainikkeilla) – koko päivän katselusta aina 10 minuutin tarkkuuteen.
* **Pikazoomauksen pikanäppäimet**: Alaohjauspalkissa on omat pyöreät kuvakepainikkeet, jotka skaalaavat aikajananäkymää välittömästi:
  * **"1h"-kuvake**: Lähentää aikajanaa tarkastaakseen yksityiskohtaisesti 1 tunnin ajanjaksolla.
  * **8h-kuvake**: zoomaa aikajanaa näyttämään 8 tunnin ajanjakson.
  * **"24h"-kuvake**: Nollaa zoomauksen niin, että se mahtuu koko 24 tunnin vuorokausi yhdelle näytölle.
  * **Keski (kohde) -kuvake**: Keskittää aikajanan välittömästi siten, että punainen toiston ilmaisin on täsmälleen näytön keskellä (korvaa vanhan tekstipainikkeen).
* **Päivämäärän navigointi (kalenteri ja päivät)**: Näytetyn päivämäärän vieressä olevat säätimet mahdollistavat nopeat hypyt:
  * **„<” (Edellinen päivä)**- ja **„>” (Seuraava päivä)** -painikkeet: Voit hypätä 24 tuntia taaksepäin tai eteenpäin välittömästi avaamatta kalenterivalintaikkunaa.
  * **Kalenterikuvake**: Avaa kalenterin ponnahdusikkunan ja valitsee tietyn päivämäärän.
  * **Päivityskuvake**: Pakottaa tallenteiden uuden haun. Napsauttaminen pyyhkäisee kaikkien aktiivisten kanavien tallennussegmenttien paikallisen välimuistin ja lähettää uusia kyselyitä NVR:lle, mikä on erittäin hyödyllistä ladata vain muutama hetki sitten tallennettuja tiedostoja (korvaa vanhan tekstipainikkeen).
  * **Tänään (tämän päivän päivämäärä/numero) -kuvake**: hyppää välittömästi takaisin nykyiseen päivään (korvaa vanhan tekstipainikkeen).
* **Toistonopeuden pikanäppäimet**:
  * **1x-, 2x- ja 4x-kuvakkeet**: Muuta toistonopeuden kerrointa välittömästi.
* **VCR-hyppypainikkeet**:
  * **"15", "45" ja "60" kuvakkeet pyöreillä nuolilla**: Voit siirtyä nopeasti taaksepäin tai eteenpäin määritetyn sekuntimäärän verran.
* **Tallennuksen saatavuuspalkit**: Värilliset palkit, jotka edustavat tallentimen levyltä löydettyjä videosegmenttejä, esitetään aikajanan alapuolella. Välimuistijärjestelmä estää niitä välkkymästä vedettäessä.
* **Automaattinen seuranta (ilmaisimen seuranta)**: Toiston ilmaisinta (pystysuora punainen viiva) valvotaan jatkuvasti. Jos osoitin menee aikajanan näkyvän alueen ulkopuolelle, näkymä siirtyy automaattisesti keskelle. Tämä vaihtoehto lukitaan älykkäästi, kun käyttäjä vetää ilmaisinta manuaalisesti.

### Kameran sivupaneeli toistoikkunassa
Soittimen oikeassa reunassa oleva pystysuora sivuluettelo listaa kaikki määritetyt NVR:t ja niiden kamerakanavat:
* **Kanavien vaihtaminen**: Kun napsautat mitä tahansa luettelossa olevaa kamerakanavaa, se lisätään aktiiviseksi toistopaikaksi aikajanalle (videosoittimen synnyttäminen). Jos napsautat sitä uudelleen, kanava poistetaan.
* **Kanavan kontekstivalikko**: Aktiivisen videopaikan napsauttaminen hiiren kakkospainikkeella toistoruudukossa avaa valikon, jossa voit
  * Vaihda videon laatua (päävirta / alivirta).
  * Sulje/poista aktiivinen soitin arkiston toistosta.

---

## 8. Tallenteiden lataaminen (latausohjelma)

Toistoarkisto-ikkunasta voit ladata valitut tallenteiden segmentit suoraan tietokoneesi asemalle MP4-tiedostoina:
1. Napsauta latauskuvaketta (alaspäin osoittava nuoli) valitun kameran vieressä.
2. Valitse aikaväli (nauhoituksen alku ja loppu).
3. Valitse kohdetiedoston tallennuspaikka.
4. Napsauta **Lataa**.

### Latauksen lisäominaisuudet:
* **Jaksottainen osien lataaminen (1 Gt:n osat)**: Ohjelma jakaa aikavälikyselysi automaattisesti fyysisiin tiedostosegmentteihin (kukin noin 1 Gt NVR-asemassa) ja lataa ja muuntaa ne yksitellen (käyttäen väliaikaisia ​​`.pspart`-tiedostoja, jotka muunnetaan suoraan `.mp4`-muotoon). Tämä varmistaa erittäin vakaat lataukset pitkillä aikavälillä ilman muistin ylivuotoa tai FFmpeg-muunnosten jumiutumista.
* **Yleinen edistymisen visualisointi**: edistymispalkki (kirkas sinivihreä väri) näyttää kameran latauksen yleisen edistymisen kaikissa segmenteissä. Edistymispalkin päällä oleva tilateksti näyttää nykyisen osan ja prosenttiosuudet, esim. `Downloading part 1 of 3... 45% (Overall: 15%)`, ääriviivatyylillä, joka takaa luettavuuden millä tahansa taustalla.
* **Tiedoston IP-osoitteen puhdistus**: Videotiedostojen nimistä (ja reaaliaikaisista/arkistoiduista tilannekuvista) poistetaan automaattisesti NVR/DVR-IP-osoitteet, jotta ne pysyvät puhtaina ja luettavissa (esim. `4_Wejscie_glowne_2026-06-15.mp4` koodin `<RECORDER_IP>_4_Wejscie...` sijaan).

---

## 9. Lisäasetukset ja mukauttaminen Asetukset-ikkunassa

Vaihtoehdot ja määritysikkuna (`SideBar`) koostuu kuudesta erillisestä välilehdestä:

### 1. Näkymäikkunan tiedot (näyttökuvake)
Näyttää valitun ruudukkoruudun lisäparametrit. Mahdollistaa:
* Kirjoita mukautettu **ensisijaisen virran URL-osoite** (RTSP/ONVIF) ja **toissijainen vara-URL-osoite** manuaalisia määrityksiä varten.
* Valitse valitun kamerasyötteen äänikanavan mykistys/poista mykistys.
* Syötä edistyneet dekooderin ohitukset **FFmpeg Options Override** -tekstiruutuun.
> [!VINKKI]
> Nopeimman suoratoistoyhteyden ja RTSP:n maksimaalisen vakauden saavuttamiseksi suositellut parametrit ovat:
> ```ini
> -analyzeduration 0 -koetin 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Asettelu- ja ruudukkotyökalut (liukusäädinkuvake)
Lisäasetukset näytön ruudukon mukauttamiseen:
* Pikavalinta koko näytön tilaan.
* **Epäsymmetrinen solujen yhdistäminen (yhdistä korostetut solut)**: erittäin kehittynyt asettelueditori. Pidä **Ctrl** tai **Vaihto** painettuna ja napsauta valitaksesi useita vierekkäisiä ruutuja ruudukosta tai käytä näppäimistöä pitämällä **Vaihto** painettuna ja navigoimalla **nuolinäppäimillä**. Napsauta sitten "Yhdistä korostetut solut" yhdistääksesi ne yhdeksi suuremmaksi näkymäksi. Tämän avulla voit luoda täysin mukautettuja epäsymmetrisiä ruudukkomalleja (esim. yksi valtava kamerapaneeli, jonka ympärillä on pienempiä syötteitä).

### 3. Tallentimet (palvelinkuvake)
Täydellinen konfigurointihallinta Hikvision NVR/DVR -laitteiden yhteyksiä varten (kuvattu yksityiskohtaisesti osiossa 3).

### 4. Esiasetukset (tähtikuvake)
Tallennettujen ruudukkoasettelujen ja kameratehtävien hallinta. Mahdollistaa tyhjien ruudukkomallien luomisen, niiden järjestyksen muuttamisen, yläpalkin näkyvyyden vaihtamisen ("Näkyvä"-kytkimen kautta) tai niiden aktivoimisen nykyisessä ikkunassa.

### 5. Asetukset (rataskuvake)
Mahdollistaa yleisten sovellusasetusten säätämisen:
* **Salli useiden ilmentymien suorittaminen**: Tämän valintaruudun valitseminen sallii useiden rinnakkaisten kopioiden käynnistämisen KVision-prosessista (oletusarvoisesti se rajoittaa suoritukset yhteen aktiiviseen ilmentymään).
* **Automaattisen tiivistyksen asetukset**: Muokkaa yläpalkin ja tilastopaneelin liukuvan animaation ajoitusta.
* **Salli kuvaporttien vaihtaminen**: valintaruudun *"Salli näkymän paikkojen vaihtaminen"* avulla voit järjestää uudelleen kameran paikkoja ruudukossa lennossa (napsauta lähderuutua hiiren kakkospainikkeella -> Valitse "Vaihda kuvaportteja" -> napsauta hiiren vasemmalla painikkeella kohderuutua).
* **Kakkospainikkeen käyttöoikeudet**: Vaihtaa interaktiivisten ohjainten lukitsemiseen/aukaisemiseen hiiren kakkospainikkeen kontekstivalikossa (Ota käyttöön kontekstivalikko, Salli kuvaporttien vaihtaminen, Ota käyttöön Poista kamera -vaihtoehto, Salli näkymän asetusten muuttaminen, Ota käyttöön streamin pää-/alilaadun valinta).
* **Automaattinen mykistyksen poistaminen**: Poistaa automaattisesti aktiivisen näkymän äänivirran mykistyksen siirtyessään koko näytön tilaan.
* **Piilota kohdistin koko näytössä**: Valintaruutu *"Piilota kohdistin koko näytön tilassa"* piilottaa hiiren kohdistimen automaattisesti hetken käyttämättömyyden jälkeen koko näytön katselun aikana esteettömän näkymän varmistamiseksi.
* **Kielen valinta**: vaihtaa välittömästi käyttöliittymäkäännöksen (järjestelmän oletusarvo, puola, englanti).
* **Käyttöliittymän asetukset**: Piilota/näytä näkymän tilatunnisteet tai ohjausmerkit (kuten piilottaa automaattisesti ohjauspeittokuvat laattojen oikeasta alakulmasta, ellei osoita vie hiiren osoitinta).
* **FFmpeg-oletusasetukset ja joukkopäivitys**: Mahdollistaa uusiin näkymäportteihin sovellettavien yleisten FFmpeg-asetusten määrittämisen (suositus: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[SUOSITUS]** Jos olet siirtymässä KVisionin vanhemmasta versiosta (ennen versiota 2.4.5), on erittäin suositeltavaa muuttaa `-analyzeduration 0` arvoksi `-analyzeduration 100000` yleisissä asetuksissa ja klikata "Päivitä kaikki kamerat". Koodin `0` asettaminen virroille ilman ääniraitaa aiheuttaa viiveitä vaihdossa, koska FFmpeg estää kovakoodatun 5 sekunnin aikakatkaisun, joka odottaa äänipaketteja. Erittäin alhaisen arvon asettaminen (esim. 100 000 mikrosekuntia = 0,1 s) ratkaisee tämän ongelman kokonaan ja säilyttää välittömän vaihdon.
  * **Päivitä kaikki kamerat -painike**: painike *"Zaktualizuj wszystkie kamery"* käyttää näitä yleisiä asetuksia kaikkiin määritettyihin näyttöportteihin.
  * **Matalan viiveen liput (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` poistaa käytöstä sisäisen demuxer-pakettien puskuroinnin poistaakseen suoratoistoviiveen ajan myötä, mutta saattaa aiheuttaa pätkimistä, jos verkkoyhteytesi kameraan on epävakaa.
    * `-flags low_delay` käskee dekooderia tulostamaan kehykset välittömästi, mutta voi aiheuttaa lyhyitä artefakteja/tahroja virroissa, jotka käyttävät B-kehyksiä nopeiden liikkeiden aikana.
  * **Ohita valintaruutu**: Voit sulkea tiettyjä näkymäportteja pois yleisistä päivityksistä tai dynaamisista oletusasetuksista valitsemalla **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** yksittäisen näkymän asetukset -valintaikkunassa. Hyödyllinen pätkivien kameroiden vianmäärityksessä.


### 6. Muutosloki (kello/asiakirjakuvake)
Esittelee interaktiivisen aikajanan, joka näyttää KVisionin täydellisen julkaisuhistorian, päivitykset, virheenkorjaukset ja ominaisuuksien lisäykset, mikä varmistaa, että sinulla on suora pääsy ohjelmapäivitystietoihin.

---

## 10. Pikanäppäimet ja hiiren säätimet

### Pikanäppäimet:
| Näppäin / pikanäppäin | Toiminta |
|---|---|
| **F** / **F11** | Vaihda koko näyttötilaa. |
| **M** | Mykistä / poista mykistys (toimii aktiiviselle kameralle äänen kanssa). |
| **Avaruus** | Toista / Keskeytä toisto Playback Archive -ikkunassa. |
| **Alt + 1** - **Alt + 9** | Pikavaihto esiasetukseen/asetteluun indekseissä 1 - 9. |
| **Alt + vasen nuoli** | Vaihda nopeasti kokoelman edelliseen esiasetukseen/asetteluun. |
| **Alt + oikea nuoli** | Vaihda nopeasti kokoelman seuraavaan esiasetukseen/asetteluun. |
| **Nuolinäppäimet (ylös/alas/vasen/oikea)** | Navigoi ja siirrä aktiivista tarkennusta/valintaa kameran kuvaporttien välillä. |
| **Vaihto + nuolinäppäimet** | Valitse useita vierekkäisiä kameran kuvaportteja samanaikaisesti (käytetään solujen yhdistämiseen jne.). |
| **Ctrl + N** | Avaa uusi, itsenäinen apuikkuna. |
| **+** / **-** | Lähennä / loitonna (PTZ-yhteensopivat Hikvision-kamerat). |
| **Vaihto** (vedä valintakehys) | Pakota valintakehys lukittumaan 16:9-kuvasuhteeseen interaktiivisen zoomauksen aikana. |
| **Esc** | Poistu koko näytön tilasta / peruuta aktiivisen näkymän valinta. |

### Hiiren vuorovaikutus:
* **Hiiren vasen painike**:
  * **Kaksoisnapsauttamalla** kameran kuvaportti ruudukossa maksimoi sen koko näytön kokoiseksi. Toinen kaksoisnapsautus palauttaa ruudukkonäkymän.
  * Vedä aikajanaa Toisto-ikkunassa navigoidaksesi.
* **Hiiren keskipainike (vierityspyörän napsautus ja vetäminen)**:
  * Panoroi vetämällä ja siirrä digitaalisesti zoomattua/suurennettua kuvaa kuvaportin näkökentän ympäri (toimii Live-, Archive- ja Mini-soittimessa).
* **Hiiren oikea painike (kontekstivalikko)**:
  * Avaa pika-asetusvalikon valitulle näkymälle (sallii kameran poistamisen ruudukosta, vaihtamisen pää-/alivirtojen välillä tai pääsyn yksittäisiin näyttöparametreihin).
* **Hiiren vierityspyörä**:
  * Säätää aikajanan mittakaavaa (Zoom) toistoarkistosoittimessa.

---

## 11. Tilannekuvien ottaminen ja polun määrittäminen

Sovelluksen avulla voit nopeasti kaapata korkealaatuisia tilannekuvia mistä tahansa kameran katseluportista sekä Live View- että Playback Archive -tilassa.

### Tilannekuvien ottaminen:
1. Kamerakuvakkeen peittopainike on käytettävissä kunkin kuvaportin oikeassa alakulmassa (yksityiskohtaiset tiedot osiossa 4).
2. Kamerakuvakkeen napsauttaminen kaappaa kehyksen ja tallentaa sen JPEG-kuvana (laatu 98 - käytännössä häviötön).
3. Onnistuneen kaappauksen vahvistaa kamerakuvake, joka vilkkuu oranssina (`#ff7a00`) tasan 1 sekunnin ajan.
4. **Täysi resoluutio**: Toistoarkistotilassa tilannekuvat tallennetaan virran täydellä alkuperäisen lähteen resoluutiolla suoraan dekooderin kehyspuskurista riippumatta aktiivisen näkymän koosta näytöllä tai näytön skaalauksesta.

### Polkuasetusten tallentaminen:
1. Siirry **Asetukset**-välilehteen (rataskuvake asetusikkunassa).
2. **Tallenna** ("Zapis") -osiossa voit määrittää oletuspolut:
   * **Oletuskuvien polku**: Kansio, johon tilannekuvat tallennetaan (oletus on `~/Obrazy/CCTV`).
   * **Tallennusten oletuspolku**: Kansio, johon ladatut MP4-videot tallennetaan (oletus on `~/Wideo/CCTV`).
3. Selainpainikkeen `...` napsauttaminen avaa käyttöjärjestelmäsi alkuperäisen kansion valitsimen (Breeze KDE:ssä).
4. **Selainpainikkeen toiminta**: Hakemistovalitsin avautuu tarkasti tekstikenttään kirjoitetussa polussa (jos sellainen on). Jos kenttä on tyhjä, virheellinen tai osoittaa kansioon, johon sinulla ei ole pääsyä, valintaikkuna palautuu ja avautuu kotihakemistoosi (`~/`).

### Käyttöliittymäasetukset (UI):
1. Siirry **Asetukset**-välilehteen (rataskuvake asetusikkunassa) tai avaa **Asetukset** ("Opcje") -ikkuna.
2. **Käyttöliittymäasetukset**-osiossa voit mukauttaa kameran kafelkien/näkymäporttien päällä olevien elementtien näkyvyyttä:
   * **Näytä kanavan tila näkymän vasemmassa yläkulmassa** (oletus käytössä) – Näyttää streamin lataus-, toisto- ja yhteyden tilatiedot.
   * **Näytä kameran tiedot kuvaportin vasemmassa alakulmassa** (oletus käytössä) – Näyttää Hikvision-tallentimesta haetun kameran nimen.
   * **Näytä ohjauskuvakkeet kuvaportin oikeassa alakulmassa vain, kun osoitin liikkuu** (oletus käytössä) – Piilottaa automaattisesti ohjauspainikepaneelin (tilannekuva, arkisto, 1:1 pikselistä pikseliin, alueen zoomaus), kun hiiren osoitin on kyseisen kameran näkymän ulkopuolella. Kuvakkeet ilmestyvät heti, kun siirrät hiiren näkymän päälle (klikkausta ei vaadita), ja katoavat poistuessasi, mikä maksimoi kamerasi virtausten näkyvyyden.
   * **Näytä tietokentät vain vietäessä hiiren osoitinta** (oletuksena pois käytöstä) – Analoginen vaihtoehto, joka piilottaa tilan näkymän vasemmassa yläkulmassa ja nimen vasemmassa alakulmassa ja näyttää täysin puhtaan kameravirran, ellei kohdistinta siirretä kyseisen kameraruudun päälle.
