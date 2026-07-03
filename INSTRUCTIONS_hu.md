# KVision felhasználói kézikönyv

*A *KVision** egy fejlett VMS (Video Management System) osztályú asztali alkalmazás, amelyet az élő videofolyamok (RTSP/ONVIF) egyidejű megtekintésére és a Hikvision NVR/DVR-felvevőkkel való integrációra terveztek (élő módban és lejátszási archívum módban egyaránt).

A program stabilitásra, zökkenőmentes működésre (60 FPS) és minimális rendszererőforrás-felhasználásra lett optimalizálva.

---

## Tartalomjegyzék
1. [A gombműveletek leírása](#1-description-of-button-actions)
2. [Telepítés és indítás](#2-installation-and-launching)
3. [NVR/DVR-felvevők kezelése](#3-managing-nvrdvr-recorders)
4. [Élő nézet és nézetablak fedvények](#4-live-view-and-viewport-overlays)
5. [Képernyőelrendezések, előbeállítások és eszköztár](#5-screen-layouts-presets-and-toolbar)
6. [Rendszerstatisztikai panel (Rendszerstatisztikák)](#6-system-statistics-panel-system-stats)
7. [Lejátszási archívumlejátszó](#7-playback-archive-player)
8. [Felvételek letöltése (letöltő)](#8-downloading-recordings-downloader)
9. [Speciális beállítások és testreszabás a Beállítások ablakban](#9-advanced-settings-and-customization-in-options-window)
10. [Billentyűparancsok és egérvezérlők](#10-keyboard-shortcuts-and-mouse-controls)
11. [Pillanatképek készítése és az útvonal konfigurálása](#11-taking-snapshots-and-path-configuration)

---

## 1. A gombműveletek leírása

Ez a rész az alkalmazásban használt összes grafikus ikon és gomb jelentését írja le.

### Felső eszköztár
* {ICON:quit} **Ablak bezárása**: Megerősítést kér, és bezárja az aktív ablakot vagy alkalmazást.
* {ICON:pin} **Rögzítősáv**: Kibontott állapotban zárolja a felső sávot, vagy engedélyezi az automatikus összecsukást.
* {ICON:fullscreen} **Teljes képernyő**: Az aktív ablakot teljes képernyős módba kapcsolja.
* {ICON:minimize} **Kis kicsinyítés**: Lekicsinyíti az alkalmazás ablakát a rendszertálcára.
* {ICON:options} **Opciók**: Megnyitja vagy bezárja a konfigurációs beállítások ablakát (beállítások és rögzítők).
* {ICON:new_window} **Új ablak**: Új, független segédablakot nyit meg a kamerafolyamokhoz.
* {ICON:archive} **Archívum**: Megnyitja a lejátszási felvételek archívumát (idővonal és naptár).
* {ICON:instructions} **Utasítások**: Megnyitja ezt a felhasználói kézikönyvet és a technikai segítségnyújtási ablakot.
* {ICON:stats} **Statisztika**: Bekapcsolja a csúszó rendszerstatisztikai panelt (CPU, RAM, GPU, Net).
* {ICON:lock} **Rácszár**: Letiltja a rácsfelosztási beállításokat az aktív elrendezés védelme érdekében.
* {ICON:hamburger} **További lehetőségek**: Megnyitja a csúszó eszköztárat a speciális osztási méretekhez, arányokhoz és cellaegyesítéshez.

### Nézetablakok (kamerák)
* {ICON:snapshot} **Pillanatfelvétel**: veszteségmentes, teljes felbontású képet rögzít, és JPEG fájlként menti.
* {ICON:play} **Kamera archívum**: Elindítja az idővonal lejátszási ablakát ehhez a kamerához (15 perc visszafelé).
* {ICON:grid_1x1} **Próbáld ki 1:1 arányban**: A videofolyamot eredeti, natív felbontásban jeleníti meg, nyújtás nélkül.
* {ICON:zoom_in} **Interaktív nagyítás**: Bekapcsolja a kattintással és húzással történő nagyítást a kiválasztott kijelölő területhez.
* {ICON:zoom_out} **Nagyítás visszaállítása**: Visszaállítja a digitális nagyítást, és visszaállítja a kamera teljes látóterét.
* {ICON:speaker_unmute} **Hang némítása**: Nem némított hangfolyamot jelent; a rákattintás elnémítja az adatfolyamot.
* {ICON:speaker_mute} **Hang némításának feloldása**: Elnémított hangfolyamot jelöl; rákattintással feloldja a stream némítását.

### Lejátszási ablak vezérlői

**A felső sáv vezérlői:**
* {ICON:close} **Bezárás**: Bezárja a lejátszási archívum lejátszó ablakát.
* {ICON:pin} **Rögzítősáv**: Kibontott állapotban zárolja a felső sávot, vagy engedélyezi az automatikus összecsukást.
* {ICON:fullscreen} **Teljes képernyő**: A lejátszási ablakot teljes képernyős módba kapcsolja.
* {ICON:sidebar} **Oldalsáv megjelenítése/elrejtése**: Bekapcsolja a kamerákat és felvevőket tartalmazó bal oldalsáv láthatóságát.
* {ICON:timeline_show} / {ICON:timeline_hide} **Idővonal megjelenítése/elrejtése**: Megjeleníti vagy elrejti az idővonalat és a lejátszásvezérlőket tartalmazó alsó panelt.
* {ICON:video_folder} **Videó mappa**: Megnyitja a letöltött videoklipeket tartalmazó helyi rendszermappát.
* {ICON:photo_folder} **Pillanatkép mappa**: Megnyitja a rögzített pillanatképeket tartalmazó helyi rendszermappát.
* rácsgombok `1x1`, `1x2`, `2x1`, `2x2`: A lejátszóablak kamera megjelenítési elrendezését 1, 2 (függőleges/vízszintes) vagy 4 egyidejű nézetre váltja.

**Alsó sáv és idővonal vezérlők:**
* {ICON:prev_day} **Előző nap**: az előző naptári nap felvételeihez navigál.
* {ICON:calendar_select} **Dátumválasztó**: Megnyit egy naptári párbeszédpanelt, ahol kiválaszthat egy adott dátumot a lejátszáshoz.
* {ICON:next_day} **Következő nap**: A következő naptári nap felvételeihez navigál.
* {ICON:today} **Ma**: Azonnal áthelyezi a lejátszás fókuszát az aktuális naptári napra.
* {ICON:refresh_recordings} **Felvételek frissítése**: Frissíti és újra lekérdezi a rendelkezésre álló felvételi szegmenseket az eszközről.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Idővonal nagyítási előbeállításai**: Az idővonal látható ablakát méretezi (1 órára, 8 órára vagy 24 órára) a nagy pontosságú navigáció érdekében.
* {ICON:timeline_center} **Középső idővonal**: Az idővonal nézetet pontosan az aktuális lejátszási időbélyeg köré állítja középre.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Lejátszási sebesség**: Beállítja a videolejátszási szorzót (normál 1x sebesség, 2x gyorsított vagy 4x gyors lejátszás).
* {ICON:download} **Letöltés**: Megnyitja a letöltő eszközt egy meghatározott videószegmens exportálásához az eszközről.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Ugrás hátra**: 60, 45 vagy 15 másodperccel visszatekeri a lejátszási időbélyeget.
* {ICON:play} / {ICON:pause} **Lejátszás / Szünet**: Elindítja vagy szünetelteti az archív videofolyam lejátszását.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Előreugrás**: 15, 45 vagy 60 másodperccel előrelépteti a lejátszási időbélyeget.

**Egyéb diagnosztikai és általános ikonok:**
* {ICON:calendar} **Naptár**: Naptári/ütemezési konfigurációkat jelöl.
* {ICON:clock} **Idő**: az órát vagy az időbeli állapotjelzőket jelöli.
* {ICON:zoom} **Nagyítás**: Méretezési vagy digitális zoom konfigurációkat jelöl.
* {ICON:timeline_toggle} **Idővonal váltása**: Az időrendi nézetek váltását vagy frissítését jelöli.
* {ICON:trash} **Törlés**: Biztonságosan eltávolítja a konfigurált rögzítőket vagy elrendezéseket megerősítéssel.
* {ICON:warning} **Figyelmeztetés**: Megjelenik a visszafordíthatatlan műveletek vagy törlési figyelmeztetések párbeszédpaneleiben.

---

## 2. Telepítés és indítás

### Telepítés Arch Linuxra (Pacman)
A program elkészített bináris csomagból történő telepítéséhez lépjen a `packaging/arch/` könyvtárba, és futtassa:
```bash
sudo pacman -U kvision-2.4.6-2-x86_64.pkg.tar.zst
```
A csomag automatikusan telepíti a programot, a `.desktop` aktiválási fájlt és a szükséges Hikvision SDK könyvtárakat a `/usr/lib/kvision` rendszerútvonalra.

### Kézi fordítás (forráskódból)
Ha manuálisan szeretné lefordítani a programot (például egy másik Linux disztribúción) a kész csomag használata helyett:

1. Telepítse a szükséges build- és futásidejű függőségeket a csomagkezelő segítségével. Arch Linux / CachyOS esetén:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Konfigurálja a projektet a CMake segítségével:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Állítsd össze a kódot:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Telepítse az alkalmazást a rendszerbe:
   ```bash
   sudo cmake --install build
   ```

### Indítás
A program elindítható a rendszermenüből vagy a terminálba begépelve:
```bash
kvision
```

### Rendszerméretezési hibaelhárítás (KDE plazma)

A 2.4.4-es verziótól kezdődően a KVision automatikusan felismeri és megfelelően alkalmazza a KDE Plasma beállításaiban konfigurált töredékes asztali skálázást (pl. 125%, 145%, 150%) a natív High DPI áthárítási szabályzatok Qt-ben való érvényesítésével. A felhasználói felületnek most már a dobozból megfelelően méreteznie kell, manuális beavatkozás nélkül.

#### Natív Wayland támogatás

A Wayland alatti legjobb skálázási élmény és teljesítmény biztosítása érdekében győződjön meg arról, hogy az opcionális `qt5-wayland` csomag telepítve van a rendszeren. Ez lehetővé teszi, hogy a KVision natív módon futhasson a Waylanden, ahelyett, hogy visszakerülne az XWayland-re.

Arch Linux / Manjaro / CachyOS esetén:
```bash
sudo pacman -S qt5-wayland
```

Debian / Ubuntu / Linux Mint esetén:
```bash
sudo apt install qtwayland5
```

#### Kézi méretezés felülbírálása (örökölt/tartalék)

Ha régebbi verziót, szokatlan konfigurációt használ, vagy egyszerűen csak manuálisan szeretne más skálázási tényezőt kényszeríteni, mint a rendszer többi része, akkor is felülírhatja az alkalmazás méretezését környezeti változókkal.

Például a **150%-os** méretezés kikényszerítéséhez indítsa el az alkalmazást a terminálról a következővel:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Ezt véglegesen alkalmazhatja, ha szerkeszti a `kvision.desktop` alkalmazásindítót a KDE menüszerkesztőjében, és hozzáadja ezeket a változókat a "Környezeti változók" mezőhöz.)*

---

## 3. NVR/DVR-felvevők kezelése

A Hikvision felvevőhöz való csatlakozás konfigurálása:
1. Nyissa meg a beállítások ablakot, és lépjen a **Rögzítők** fülre (szerver ikon).
2. Adja meg az eszköz hozzáférési adatait:
   * **IP-cím**: A rögzítő hálózati címe.
   * **Port**: Az SDK hálózati portja (alapértelmezett: `8000`).
   * **Felhasználónév**: Felhasználónév (pl. `admin`).
   * **Jelszó**: Jelszó a felvevő eléréséhez.
3. Kattintson a **Csatlakozás és felfedezés** (vagy a **Mentés és frissítés**) lehetőségre.
4. Sikeres csatlakozás esetén az alkalmazás automatikusan felismeri az összes aktív kamerát (csatornát), amely az NVR/DVR-hez csatlakozik, és hozzáadja azokat a listához.
5. A **Generate Grid** (Rács létrehozása) gombra kattintva automatikusan létrehoz egy nézetablak-elrendezést (előre beállított), amely tartalmazza az adott NVR összes aktív kameráját optimális rácselrendezésben.
6. **Kameráslisták megjelenítése (NvrCamerasWindow)**: A számítógép-monitor ikonjára kattintva bármely felvevő kártyáján megnyílik egy külön ablak, amely az összes észlelt kameracsatornát interaktív csempékként mutatja.
7. **Miniatűrök generálása (bélyegképek generálása)**: Az NVR-kamerák listaablakban elérhető egy *„Bélyegképek generálása”* gomb. Ha rákattint, az alkalmazás arra utasítja az alkalmazást, hogy húzzon le egyetlen képkockát az egyes csatornák alfolyamából a háttérben, és állítsa be őket háttérbélyegképként. Ez gyors vizuális előnézetet biztosít az egyes kamerákról anélkül, hogy teljes élő adást indítana el.
8. **Kattintás és hozzáadása funkció**: Az alkalmazás nem támogatja a csempék húzását (húzással) a kameralista ablakából a fő rácsra. A kamera hozzárendelése egyszerű és megbízható módon történik: először kattintson a bal gombbal a főképernyő rácsának bármelyik nézetablak-csempére a kijelöléséhez (világos kerettel lesz kiemelve), majd kattintson a zöld **"+" (Hozzárendelés aktív nézetablakhoz)** gombra a kívánt kameracsempén az NVR kameralista ablakában. Az adatfolyam azonnal betöltődik abban a nyílásban.
9. **SDK-munkamenet állapota (pontjelző)**: a listában minden rögzítő IP-címe mellett egy színes állapotpont található:
   * **Zöld (BEJELENTKEZVE)**: Egy aktív Hikvision SDK-munkamenetet jelöl, amely szükséges a PTZ-vezérléshez, az idővonal-archiválási kérésekhez és a letöltéshez.
   * **Piros (NINCS BEJELENTKEZVE)**: Jelenleg nincs aktív SDK-munkamenet (például az első SDK-kérés előtt vagy kézi/automatikus kijelentkezés után). Vegye figyelembe, hogy a kamera RTSP élő hírcsatornái az SDK-munkamenet állapotától függetlenül továbbra is lejátszanak.
10. **Helyi kamera átnevezése**: Az NVR-kamerák listájának bármelyik kameracsempén kattintson a **Szerkesztés** (ceruza) ikonra. Ezzel megnyílik egy párbeszédpanel, ahol megadhatja a kamera egyéni nevét. Ezt a nevet a rendszer helyileg menti, és azonnal frissül az élő lejátszókon, az idővonalon és a csempe nézeteken a fizikai NVR-eszköz módosítása nélkül. Bármikor visszaállíthatja az alapértelmezett nevet.
11. **Rögzítő eltávolítása a listáról**: A listán szereplő minden egyes konfigurált felvevő mellett található egy piros kuka gomb. Ha rákattint, elindít egy kétlépcsős biztonsági protokollt, amely megakadályozza a véletlen törlést:
    * **1. lépés (Megerősítés)**: Megjelenik a *„Confirm NVR Deletion”* (NVR törlésének megerősítése)* című párbeszédpanel, amely megkérdezi, hogy biztosan törölni kívánja-e a felvevőt.
    * **2. lépés (Figyelmeztetés)**: Megjelenik egy második figyelmeztető párbeszédpanel *„Figyelem!”* címmel, és megkérdezi, hogy teljesen biztos-e benne, és tisztában van-e azzal, amit csinál.
    * **Törlés hatása**: A második figyelmeztetés elfogadásakor a program a háttérben kijelentkezik az NVR-ből, törli bejegyzését az alkalmazás konfigurációjából, és **automatikusan besöpör az előre beállított elrendezések listájába**, eltávolítva az ehhez az NVR-eszközhöz generált összes dinamikus rácsot.

---

## 4. Élő nézet és nézetablak átfedések

A program főablakában az élő hírfolyam látható:
* **Camera Grid**: RTSP adatfolyamokat vagy feedeket jelenít meg közvetlenül a Hikvision SDK-ból.
* **Streamminőség kiválasztása**: Ha jobb gombbal kattint a kamera nézetablakára, kiválaszthatja a **Fő adatfolyamot** a legnagyobb felbontáshoz, vagy az **Aladatfolyamot** a hálózat és a grafikus kártya terhelésének csökkentéséhez.
* **Dupla kattintás teljes képernyős váltása**: Ha duplán kattint a bal egérgombbal bármelyik kamera nézetablakra, azonnal maximalizálja azt, hogy kitöltse a teljes aktív ablakterületet (egy nézetablakos teljes képernyő). Az ismételt dupla kattintás visszaállítja az eredeti többkamerás rács elrendezést.
* **Felső sáv automatikus elrejtése**: A felső beállítási eszköztár (topToolBar) automatikusan összecsukható a képernyő felső széléig, amikor az egérkurzor elhagyja a területet (ez a lehetőség a Beállítások -> *„A felső sáv automatikus összecsukása”* menüpontban konfigurálható, vagy közvetlenül a felső sáv gombostűje ikonjával).
* **Többmonitoros és kiegészítő ablakok**: Megnyithat független további (kiegészítő) ablakokat, hogy különböző rácselrendezéseket futtasson egyszerre több képernyőn vagy monitoron. Új ablak megnyitásához használja a `Ctrl+N` billentyűparancsot, vagy kattintson az **"Új ablak"** gombra a csúsztatható felső eszköztáron. Minden ablak konfigurálható saját rácsmérettel és kiválasztott előre beállított elrendezéssel.

### Nézetablak átfedő gombjai
Az egyes kameracsempék/nézetablak jobb alsó sarkában egy négy funkcionális ikonnal rendelkező vezérlőpult jelenik meg, amikor az egérmutatót fölé viszi (a felhasználói felület beállításaitól függően):
1. **Kamera ikon (pillanatfelvétel)**: Lehetővé teszi képernyőkép készítését a kamera feedből. A pillanatfelvétel az adatfolyam teljes, natív felbontásában kerül mentésre közvetlenül a dekódoló keretpufferéből, elkerülve a nézetablak csempe aktuális méretéből vagy a képernyőfelbontás skálázásából eredő veszteségeket. A pillanatfelvételek sikeres mentését a kamera ikon pontosan 1 másodpercig narancssárgán (`#ff7a00`) villogó igazolja.
2. **Lejátszási ikon (Archívum)**: A felvételek archívumának gyors megnyitására szolgál. A gombra kattintva automatikusan elindítja a `PlaybackWindow` idővonalat ehhez a kamerához, és a lejátszást **pontosan 15 perccel az aktuális rendszeridő előtt** indítja el (kényelmes gyors visszafelé eltolás).
3. **1:1 ikon (Natív méretarány)**: Képpontok közötti videomegjelenítési mód váltása. Ha engedélyezve van, a videó nem nyúlik meg vagy torzul, hogy kitöltse a csempe határait, hanem középre kerül, és az eredeti natív felbontásban jelenik meg. Ha ez a mód aktív, a gomb háttere és az „1:1” szöveg világos neon világos-türkiz színnel kiemelve.
4. **Nagyítóikon (Interaktív zoom)**: Lehetővé teszi a videó feed bármely meghatározott részének nagyítását:
   * **Aktiválás**: Az ikonra kattintva az aktív állapotba kapcsol (türkizkék kiemelés). A kurzor alakja megváltozik, és egy eszköztipp utasítja: *"Kattintson és húzza a kamera hírcsatornáját a nagyításhoz"*.
   * **Művelet**: Kattintson a bal gombbal, és húzzon egy téglalap alakú kijelölő területet az élő hírfolyam fölé. A nézetablak automatikusan levágja és átméretezi a kiválasztott területet, hogy kitöltse a teljes csempét.
   * **Visszaállítás**: Nagyításkor a nagyító ikon megváltoztatja az ikonját (piros keret mínuszjellel). Ha rákattint, azonnal visszaállítja a nagyítást, és visszatér a teljes kamera feedhez.

---

## 5. Képernyőelrendezések, Előbeállítások és Eszköztár

Az elrendezések lehetővé teszik a kamerák elrendezésének megszervezését a képernyőn. Az **Előbeállítások** lapon (csillag ikon) a következőket teheti:
* **Új előbeállítások létrehozása**: Adja hozzá saját elrendezését az oszlopok és sorok tetszőleges konfigurációjával (pl. 2x2, 3x3, 4x4).
* **Kamerák hozzárendelése**: Kattintson egy nézetablakra a rácselrendezésben a kiválasztásához, majd nyissa meg az NVR-kamerák ablakot, és kattintson a **"+" (Hozzáadás)** gombra a kívánt kameracsempén. A nézetablak pozícióit felcserélheti a forrás nézetablak jobb gombbal történő helyi menüjével (*„Zamień miejscami”* / *„Swap viewports”*), majd a cél nézetablakra kattintva.

### Felső sáv gombjai (felső eszköztár)
A felső csúszó eszköztár a navigációs és alkalmazásvezérlő gombok átfogó készletét kínálja:
1. **Ablak bezárása (Piros ✕ gomb)**: Bezárja az aktív ablakot. A véletlen kattintások elkerülése érdekében elfogja a záró eseményt, és egy párbeszédpanelen kéri, hogy erősítse meg az alkalmazásból való kilépést.
2. **Rögzítő gomb**: A felső eszköztár automatikus elrejtésének viselkedését szabályozza. Amikor a csap függőlegesen mutat (tűzött állapot), a rúd a helyén rögzül, és folyamatosan látható marad. Ha a tűt -45 fokkal elforgatják (nem rögzített állapot), a sáv automatikusan felfelé csúszik, ha az egér elhagyja a területet.
3. **Teljes képernyő (zöld nyilak ikon)**: Azonnal átváltja az aktív ablakot teljes képernyős módba, majd vissza. Teljes képernyős módban a nyilak befelé mutatnak (összecsukása), ablakos módban pedig kifelé (kibontás).
4. **Kis kicsinyítés (ciánkék kicsinyítési ikon)**: Az alkalmazás ablakát a tálcára kicsinyíti. Visszaállításával az ablak pontosan az előző állapotába kerül (pl. maximalizált vagy teljes képernyő).
5. **⚙️ OPCIÓK (OPCJE)**: Bekapcsolja a konfigurációs beállítások ablakát. Ha az ablak már nyitva van, erre a gombra kattintva bezárja.
6. **📺 ÚJ ABLAK (MOST OKNO)**: Megnyílik egy új, független és teljesen konfigurálható `Auxiliary Window`, amely tökéletes a kameraelrendezések több monitorbeállításra való kiterjesztéséhez.
7. **ARCHÍVÁS**: Megnyit egy üres `PlaybackWindow`-t (felvétellejátszó) aktív idővonallal és naptárral, lehetővé téve a manuális adatfolyam- és kameracsatorna-választást bármely konfigurált NVR-ről az oldalsávlistán keresztül.
8. **UTASÍTÁSOK (INSTRUKCJA)**: Megnyitja ezt a kézikönyv ablakot, és betölti a teljes felhasználói dokumentációt angol vagy lengyel nyelven, az aktív területtől függően.
9. **📊 STATS (STATYSTYKI) kapcsoló**: A váltó kapcsolóval kicsúsztathatja a Rendszerstatisztika figyelőpanelt a képernyő bal széléről.
10. **Rácszár kapcsoló (lakat)**: Bekapcsolt kapcsoló (világos narancssárgával kiemelve) letiltja a rács átméretezési műveleteit a szomszédos rácsgombokon, megvédve az aktív kameraelrendezést a véletlen változtatásoktól.
11. **Rácsméret-választók (1x1-től 9x9-ig)**: Kilenc gombból álló sor, amely lehetővé teszi a nézetablak sor- és oszlopszerkezetének azonnali meghatározását (egyetlen kamera 1x1-es nézetétől 81 egyidejű kamerabehúzásig 9x9-es elrendezésben). A jelenleg aktív méret élénk narancssárgával kiemelve.
12. **További lehetőségek (Hamburger menü három sorral)**: gomb, amely megnyitja a csúszó `Layout & Grid Tools` eszköztárat a speciális rácshangoláshoz, a geometria beállításához és a hibakeresési lehetőségekhez (részletek lent).
13. **Előre beállított/nézet gombok**: dinamikusan megjelenített gombok az eszköztár jobb oldalán, amelyek az Ön konfigurált és látható előre beállított elrendezéseit képviselik (pl. *📹 NVR*, *View 1* stb.). Egy gombra kattintva azonnal átvált a rácsra. Az aktív nézet élénk világos-türkiz színnel kiemeli.

### Speciális rács testreszabás és arányok (elrendezés és rács eszközök)
A Hamburger (További beállítások) menü megnyitása egy speciális elrendezési eszköztárat jelenít meg. A vezérlők aktiválásához:
1. **Eszközök ablaktábla feloldása**: Kapcsolja be a legfelső "Eszközök ablaktábla feloldása" kapcsolót. Ez egy kifejezetten biztonsági intézkedés, amely megakadályozza az összetett elrendezések véletlenszerű megváltoztatását.
2. **Egyéni ablakfelosztás (F2 vagy nyomva tartva)**: Az eszköztár 1x1-től 9x9-ig jeleníti meg a rácsfelosztás gombjait. Rendkívül fejlett funkció a **felosztási méretek felülbírálása és szerkesztése**. Ha lenyomva tartja valamelyik rácsgombot a bal egérgombbal (vagy fókuszba állítja és lenyomja az **F2**-t), megjelenik egy szövegmező. Beírhat bármilyen egyéni vagy aszimmetrikus felosztást (például `2x3`, `1x4` stb.), majd nyomja meg az Enter billentyűt. A gomb azonnal újraprogramozható, és rákattintva alkalmazza az egyéni elrendezést a fő nézetablakban.
3. **Geometriai arányok**: Lehetővé teszi a rács megjelenítésének kényszerítését meghatározott képarányokra:
   * **16:9-es képarány**: Zárolja és méretezi a rácstárolót szélesvásznú 16:9-es formátumra (a modern IP-kamerák szabványa).
   * **4:3-as képarány**: A rácstárolót a hagyományos 4:3-as képarányhoz igazítja (a régi analóg/IP-kamerákban gyakori).
4. **Rácsműveletek (Kiemelt cellák egyesítése)**: Az aszimmetrikus cellaegyesítés funkció elérése (részletek a 9.2. szakaszban).

---

## 6. Rendszerstatisztikai panel (Rendszerstatisztikák)

Az Élő nézet képernyő bal széléből kicsúszva ez a panel figyeli a számítógép állapotát és az alkalmazás által generált terhelést:
* **Figyelt paraméterek**:
  * **CPU / RAM**: A fő processzor (az összes mag %-ában), valamint a `kvision` folyamat és a kapcsolódó letöltő alfolyamatok által közvetlenül használt RAM használata.
  * **GPU/VRAM**: A grafikus kártya magjának kihasználtsága (%-ban), valamint a VRAM grafikus memória mennyisége, amelyet a renderelés és a hardveres dekódolás foglal el (támogatja a GPU-folyamatok teljes listáját a `nvidia-smi` XML-elemzőjével).
  * **HÁLÓZAT (Net)**: Az alkalmazás tényleges letöltési átviteli sebessége az összes aktív élő lejátszótól, archív lejátszótól és a felvétel letöltési folyamatától.
* **Többszálú (akadozásmentes)**: A folyamat- és GPU-adatgyűjtés egy külön rendszerszálon (`StatsWorker`) fut. Ez megakadályozza a mikro-akadozást a videomegjelenítés során (nincs képkocka leesés).
* **Rögzítés funkció**: A **"Rögzítés"** gombra (tűs ikon) kattintva a panel a kibontott állapotában zárolható.
* **Esztétika**: A diagramok világos, neonzöld szegélyekkel, a diagramgörbe alatti színátmenetes kitöltéssel és a szöveg olvashatóságát biztosító kiegyensúlyozott, 35%-os háttérátlátszósággal rendelkeznek.

---

## 7. Playback Archive Player

Egy adott kamera vagy felvevő melletti óra/lejátszás ikonra kattintva érhető el. Lehetővé teszi több Hikvision kamera archivált felvételeinek egyidejű megtekintését teljes idejű szinkronban.

### Idővonal és vezérlők:
* **Gyors indítás (15 perccel vissza)**: Amikor megnyitja az archívumot élő nézetből, a lejátszó automatikusan egy olyan pillanattól indul, amely **pontosan 15 perccel az aktuális rendszeridő előtt** esik (ahelyett, hogy éjfélkor kezdené). Ez lehetővé teszi az éppen megtörtént esemény azonnali megtekintését.
* **Navigáció**: Az idővonal balra és jobbra görgethető a bal egérgombbal húzva.
* **Nagyítás (méretezés)**: Az idővonal léptékét az egér görgőjével (vagy a Zoom gombokkal) simán módosíthatja – az egész nap megtekintésétől a precíz, 10 perces precíziós nézetig.
* **Gyors zoom billentyűparancsok**: Az alsó vezérlősáv dedikált kör alakú ikongombokkal rendelkezik az idővonal nézet azonnali méretezéséhez:
  * **„1 óra” ikon**: Kinagyítja az idővonalat, hogy 1 órán keresztül részletesen megvizsgálhassa.
  * **„8 óra” ikon**: Kinagyítja az idővonalat, hogy 8 órás időtartamot jelenítsen meg.
  * **„24 órás” ikon**: Visszaállítja a nagyítást, hogy a nap teljes 24 órás megjelenítése egyetlen képernyőre illeszkedjen.
  * **Középső (Cél) ikon**: Azonnal középre állítja az idővonalat úgy, hogy a piros lejátszásjelző pontosan a képernyő közepén legyen (a régi szöveggomb helyére).
* **Dátumnavigáció (naptár és napok)**: A megjelenített dátum melletti vezérlők gyors ugrásokat tesznek lehetővé:
  * **„<” (Előző nap)** és **„>” (Következő nap)** gombok: 24 órával előre vagy hátra ugorhat azonnal a naptár párbeszédpanel megnyitása nélkül.
  * **Naptár ikon**: Megnyitja a naptár előugró ablakát egy adott dátum kiválasztásához.
  * **Frissítés ikon**: A felvételek újbóli keresését kényszeríti ki. Ha rákattint, az összes aktív csatorna rögzítési elérhetőségi szegmenseinek helyi gyorsítótárát besöpri, és új lekérdezéseket küld az NVR-nek, ami nagyon hasznos a néhány pillanattal ezelőtt rögzített fájlok betöltéséhez (a régi szöveggomb helyére).
  * **Ma (a mai dátum/szám) ikon**: Azonnal visszaugrik az aktuális napra (a régi szöveggomb helyére).
* **Lejátszási sebesség parancsikonok**:
  * **„1x”, „2x” és „4x” ikonok**: Azonnal módosíthatja a lejátszási sebesség szorzóját.
* **VCR ugrógombok**:
  * **„15”, „45” és „60” ikonok kör alakú nyilakkal**: Gyorsan előre vagy hátra ugorhat a megadott számú másodpercig.
* **Rögzítési elérhetőségi sávok**: A felvevő lemezén talált videorészleteket jelző színes sávok az idővonal alatt jelennek meg. A gyorsítótárazási rendszer megakadályozza, hogy húzás közben villogjanak.
* **Automatikus követés (jelzőkövetés)**: A lejátszásjelzőt (függőleges piros vonal) folyamatosan figyeli. Ha az indikátor az idővonal látható tartományán kívülre esik, a nézet automatikusan gördül középre. Ez az opció intelligensen zárolva van, amikor a felhasználó manuálisan húzza az indikátort.

### Kamera oldalsó panel a lejátszási ablakban
A lejátszó jobb szélén található függőleges oldalsó lista felsorolja az összes konfigurált NVR-t és azok kameracsatornáit:
* **Csatornák váltása**: Ha a listában bármelyik kameracsatornára kattint, az aktív lejátszási helyként kerül hozzáadásra az idővonalon (videolejátszót hoz létre). Ha ismét rákattint, eltávolítja a csatornát.
* **Csatorna helyi menü**: Ha jobb gombbal kattint egy aktív videohelyre a lejátszási rácsban, megnyílik egy menü a következőkhöz:
  * Videó minőségének váltása (fő stream / alfolyam).
  * Az aktív lejátszó bezárása/eltávolítása az archív lejátszásból.

---

## 8. Felvételek letöltése (letöltő)

A Playback Archive ablakból letöltheti a felvételek kiválasztott szegmenseit közvetlenül a számítógép meghajtójára MP4 fájlként:
1. Kattintson a letöltés ikonra (lefelé mutató nyíl) a kiválasztott kamera mellett.
2. Válassza ki az időtartományt (a felvétel kezdete és vége).
3. Válassza ki a célfájl mentési helyét.
4. Kattintson a **Letöltés** gombra.

### Speciális letöltési funkciók:
* **Szekvenciális szegmensletöltés (1 GB-os részek)**: A program automatikusan felosztja az időtartomány lekérdezését fizikai fájlszegmensekre (egyenként nagyjából 1 GB az NVR-meghajtón), majd egyesével letölti és konvertálja azokat (ideiglenes `.pspart` fájlok használatával, amelyeket közvetlenül `.mp4` formátumba konvertál). Ez biztosítja a rendkívül stabil letöltéseket hosszú időtartamú tartományokban, memóriatúlcsordulás vagy az FFmpeg konverzió lefagyása nélkül.
* **Általános előrehaladás vizualizálása**: A folyamatjelző sáv (világos kékeszöld színű) megjeleníti a kamera letöltésének általános előrehaladását az összes szegmensben. A folyamatjelző sávra ráfedő állapotszöveg az aktuális részt és százalékokat, például `Downloading part 1 of 3... 45% (Overall: 15%)` mutatja, egy körvonal-stílussal, amely garantálja az olvashatóságot bármilyen háttéren.
* **Fájlnév IP-tisztítása**: A videofájlnevek (és az élő/archív pillanatképek) automatikusan megfosztják az NVR/DVR IP-címeit, hogy tiszták és ember által olvashatóak maradjanak (pl. `4_Wejscie_glowne_2026-06-15.mp4` a `<RECORDER_IP>_4_Wejscie...` helyett).

---

## 9. Speciális beállítások és testreszabás a Beállítások ablakban

A beállítások és a konfigurációs ablak (`SideBar`) hat dedikált lapból áll:

### 1. A nézetablak részletei (monitor ikon)
Megjeleníti az aktuálisan kiválasztott rácscsempének speciális paramétereit. Lehetővé teszi, hogy:
* Írjon be egy egyéni **Elsődleges adatfolyam URL-t** (RTSP/ONVIF) és egy **Másodlagos tartalék URL-t** a kézi konfigurációkhoz.
* A kiválasztott kameracsatorna hangcsatornájának némítása/némításának feloldása.
* Adja meg a speciális dekódoló felülírásait az **FFmpeg Options Override** szövegmezőben.
> [!TIPP]
> A leggyorsabb adatfolyam-kapcsolat és az RTSP-n keresztüli maximális stabilitás érdekében a javasolt paraméterek a következők:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Elrendezés és rács eszközök (csúszka ikon)
Speciális képernyőrács testreszabási lehetőségek:
* Gyors váltás a teljes képernyős módhoz.
* **Aszimmetrikus cellaegyesítés (Kiemelt cellák egyesítése)**: rendkívül fejlett elrendezésszerkesztő. Tartsa lenyomva a **Ctrl** vagy **Shift** billentyűt, és kattintson a rácson lévő több szomszédos csempe kiválasztásához, vagy használja a billentyűzetet a **Shift** billentyű lenyomva tartása és a **nyilakkal** történő navigálással, majd kattintson a "Kiemelt cellák egyesítése" gombra, hogy egyetlen nagyobb nézetablakban egyesítse őket. Ez lehetővé teszi teljesen egyedi aszimmetrikus rács kialakítások létrehozását (például egy hatalmas kamerapanel, amely körülveszi a kisebb feedeket).

### 3. Felvevők (szerver ikon)
Teljes konfigurációkezelő a Hikvision NVR/DVR eszközökhöz való csatlakozásokhoz (részletesen a 3. részben).

### 4. Előbeállítások (csillag ikon)
A mentett rácselrendezések és kamera-hozzárendelések kezelője. Lehetővé teszi üres rácssablonok létrehozását, sorrendjük megváltoztatását, a felső sáv láthatóságának átkapcsolását (a "Látható" kapcsolón keresztül), vagy aktiválását az aktuális ablakban.

### 5. Beállítások (fogaskerék ikon)
Lehetővé teszi a globális alkalmazásbeállítások módosítását:
* **Több példány futtatásának engedélyezése**: A jelölőnégyzet bejelölése lehetővé teszi a KVision folyamat több párhuzamos másolatának elindítását (alapértelmezés szerint egyetlen aktív példányra korlátozza a futtatást).
* **Automatikus összecsukási beállítások**: testreszabja a csúszó animáció időzítését a felső sávon és a statisztikai panelen.
* **Nézetablakok cseréjének engedélyezése**: A *„Nézetablak helyek felcserélésének engedélyezése”* jelölőnégyzet lehetővé teszi, hogy menet közben átrendezze a kamera pozícióit a rácson (jobb gombbal kattintson a forráscsempére -> Válassza a "Nézetablak cseréje" -> Bal kattintás a célcsempét).
* **Jobb gombbal történő kattintás engedélyei**: Váltás az interaktív vezérlők zárolására/feloldására a jobb gombbal megjelenő helyi menüben (Helyi menü engedélyezése, Nézetablakok cseréjének engedélyezése, „Kamera eltávolítása” opció engedélyezése, Nézetablakok beállításainak módosításának engedélyezése, Az adatfolyam fő/al minőségének kiválasztásának engedélyezése).
* **Automatikus némítás feloldása**: Teljes képernyő módba lépéskor automatikusan feloldja az aktív nézetablak hangfolyamát.
* **Kurzor elrejtése teljes képernyőn**: A *„Kurzor elrejtése teljes képernyős módban”* jelölőnégyzet automatikusan elrejti az egérkurzort egy rövid tétlenség után a teljes képernyős megtekintés során, így biztosítva a zavartalan nézetet.
* **Nyelvválasztás**: Azonnal átvált a felület fordítására (alapértelmezett rendszer, lengyel, angol).
* **Felhasználói beállítások**: A nézetablak állapotcímkéinek vagy vezérlőjelvényeinek elrejtése/megjelenítése (például a vezérlőfedvények automatikus elrejtése a csempék jobb alsó sarkában, hacsak nem lebeg).
* **Alapértelmezett FFmpeg-beállítások és tömeges frissítés**: Lehetővé teszi az új nézetablakra alkalmazott globális FFmpeg-beállítások konfigurálását (ajánlott: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[AJÁNLÁS]** Ha a KVision régebbi verziójáról (v2.4.5 előtti) költözik át, erősen ajánlott a `-analyzeduration 0` értéke `-analyzeduration 100000` módosítása a globális beállításokban, és kattintson az "Összes kamera frissítése" gombra. A `0` beállítása a hangsáv nélküli adatfolyamokon késleltetést okoz a váltásban, mivel az FFmpeg blokkolja a merev kódolt 5 másodperces időtúllépést, amely az audiocsomagokra vár. Nagyon alacsony érték beállítása (pl. 100 000 mikroszekundum = 0,1 s) teljesen megoldja ezt a problémát, miközben fenntartja az azonnali váltást.
  * **Összes kamera frissítése gomb**: A *„Zaktualizuj wszystkie kamery”* gomb minden konfigurált nézetablakra alkalmazza ezeket a globális beállításokat.
  * **Alacsony késleltetésű jelzők (`nobuffer`, `low_delay`)**:
    * A `-fflags nobuffer` letiltja a belső demuxer csomagpufferelést, hogy kiküszöbölje a streamelési késést, de akadozást okozhat, ha a hálózati kapcsolat a kamerával instabil.
    * A `-flags low_delay` utasítja a dekódert, hogy azonnal adja ki a képkockákat, de rövid műtermékeket/elkenődést okozhat azokban a folyamokban, amelyek B-kockákat használnak gyors mozgások esetén.
  * **Felülbírálás jelölőnégyzet**: Kizárhat bizonyos nézetablakokat a globális frissítésekből vagy a dinamikus alapértelmezésekből, ha bejelöli a **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** lehetőséget az egyes Nézetablakok beállításai párbeszédpanelen. Hasznos az akadozó kamerák hibaelhárításához.


### 6. Változásnapló (óra/dokumentum ikon)
Interaktív idővonalat mutat be, amely megmutatja a KVision teljes kiadási előzményeit, frissítéseit, hibajavításait és kiegészítéseit, így biztosítva a közvetlen hozzáférést a programfrissítések részleteihez.

---

## 10. Billentyűparancsok és egérvezérlők

### Billentyűparancsok:
| Billentyű/parancsikon | Akció |
|---|---|
| **F** / **F11** | Teljes képernyős mód váltása. |
| **M** | Hang némítása / némítás feloldása (az aktív kamerához hanggal működik). |
| **Space** | Lejátszás / Lejátszás szüneteltetése a Playback Archive ablakban. |
| **Alt + 1** - **Alt + 9** | Gyors váltás egy előre beállított/elrendezésre az 1-9 indexeknél. |
| **Alt + balra nyíl** | Gyors váltás a gyűjtemény előző beállítására/elrendezésére. |
| **Alt + jobbra nyíl** | Gyors váltás a következő előre beállított/elrendezésre a gyűjteményben. |
| **Nyíl billentyűk (Fel/Le/Balra/Jobbra)** | Navigáljon és mozgassa az aktív fókuszt/kiválasztást a kameranézeti ablakok között. |
| **Shift + nyílbillentyűk** | Válasszon ki egyszerre több szomszédos kameranézeti ablakot (cellaegyesítéshez stb.). |
| **Ctrl + N** | Nyisson meg egy új, független segédablakot. |
| **+** / **-** | Nagyítás / Kicsinyítés (PTZ-képes Hikvision kamerák). |
| **Esc** | Lépjen ki a teljes képernyős módból / törölje az aktív nézetablak kiválasztását. |

### Egér interakció:
* **Bal egérgomb**:
  * **Kattintson duplán** a kamera nézetablakára a rácsban, és teljes képernyőre maximalizálja. Egy másik dupla kattintás visszaállítja a rácsnézetet.
  * A navigációhoz húzza az idővonalat a Lejátszás ablakban.
* **Jobb egérgomb (helyi menü)**:
  * Megnyitja a kiválasztott nézetablak gyorsbeállítási menüjét (lehetővé teszi a kamera eltávolítását a rácsból, a fő/aladatfolyamok közötti váltást vagy az egyes megjelenítési paraméterek elérését).
* **Egérgörgő**:
  * Beállítja az idővonal léptékét (Zoom) a lejátszási archív lejátszóban.

---

## 11. Pillanatképek készítése és az útvonal konfigurálása

Az alkalmazás lehetővé teszi, hogy gyorsan készítsen kiváló minőségű pillanatfelvételeket bármely kameranézetből élő nézetben és visszajátszási archívum módban is.

### Pillanatfelvételek készítése:
1. Az egyes nézetablakok jobb alsó sarkában található egy kameraikon átfedő gomb (részletek a 4. részben).
2. A kamera ikonra kattintva rögzíti a keretet, és elmenti JPEG képként (98-as minőség – gyakorlatilag veszteségmentes).
3. A sikeres rögzítést a kamera ikon pontosan 1 másodpercig narancssárgán villogó (`#ff7a00`) igazolja.
4. **Teljes felbontás**: Lejátszási archív módban a pillanatfelvételek az adatfolyam teljes natív forrásfelbontásában kerülnek mentésre közvetlenül a dekóder keretpufferéből, függetlenül a képernyőn lévő aktív nézetablak méretétől vagy a kijelző méretétől.

### Útvonal konfigurációk mentése:
1. Lépjen a **Beállítások** lapra (fogaskerék ikon a beállítások ablakban).
2. A **Mentés** ("Zapis") részben konfigurálhatja az alapértelmezett útvonalakat:
   * **Alapértelmezett pillanatképek elérési útja**: Mappa, ahová a pillanatképek mentésre kerülnek (alapértelmezett: `~/Obrazy/CCTV`).
   * **Alapértelmezett felvételi útvonal**: Mappa, ahová a letöltött MP4-videókat menti (alapértelmezett: `~/Wideo/CCTV`).
3. A `...` böngészőgombra kattintva megnyílik az operációs rendszer natív mappaválasztója (Breeze a KDE-ben).
4. **Böngészőgomb viselkedése**: A címtárválasztó pontosan a szövegmezőbe beírt elérési úton nyílik meg (ha van ilyen). Ha a mező üres, érvénytelen, vagy olyan mappára mutat, amelyhez nincs hozzáférése, a párbeszédablak visszaesik, és megnyílik a saját könyvtárában (`~/`).

### Felhasználói felület beállításai (UI):
1. Lépjen a **Beállítások** fülre (fogaskerék ikon a beállítások ablakban), vagy nyissa meg az **Opciók** ("Opcje") ablakot.
2. A **Felhasználói felület beállításai** részben személyre szabhatja a kamera kafelki/nézeti ablakaira borított elemek láthatóságát:
   * **Csatorna állapotának megjelenítése a nézetablak bal felső sarkában** (alapértelmezett engedélyezve) – Megjeleníti az adatfolyam betöltését, lejátszását és a kapcsolat állapotát.
   * **Kamerainformációk megjelenítése a nézetablak bal alsó sarkában** (alapértelmezett engedélyezve) – A Hikvision-felvevőből leolvasott kameranevet jeleníti meg.
   * **A vezérlőikonok megjelenítése a nézetablak jobb alsó sarkában csak lebegtetéskor** (alapértelmezett engedélyezve) – Automatikusan elrejti a vezérlőgomb panelt (pillanatfelvétel, archívum, 1:1 pixel-pixel, régiónagyítás), ha az egérkurzor az adott kamera nézetablakon kívül van. Az ikonok azonnal megjelennek, amint az egeret a nézetablak fölé viszi (kattintásra nincs szükség), és eltűnnek, amikor kilép, maximalizálva a kameraadatfolyamok láthatóságát.
   * **Információs mezők megjelenítése csak lebegtetéskor** (alapértelmezett kikapcsolva) – Analóg lehetőség, amely elrejti az állapotot a nézetablak bal felső sarkában és a nevet a bal alsó sarokban, és teljesen tiszta kamerafolyamot jelenít meg, kivéve, ha a kurzort az adott kameracsempére viszi.
