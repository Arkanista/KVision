# Používateľská príručka pre KVision

> [!POZNÁMKA]
> Tento návod na použitie bol automaticky preložený a naformátovaný s pomocou umelej inteligencie (AI).

**KVision** je pokročilá desktopová aplikácia triedy VMS (Video Management System) určená na súčasné sledovanie živých video streamov (RTSP/ONVIF) a integráciu s rekordérmi Hikvision NVR/DVR (v režime Live aj v režime archívu prehrávania).

Program bol optimalizovaný pre stabilitu, plynulú prevádzku (60 FPS) a minimálnu spotrebu systémových zdrojov.

---

## Obsah
1. [Popis akcií tlačidiel](#1-description-of-button-actions)
2. [Inštalácia a spustenie](#2-installation-and-launching)
3. [Správa rekordérov NVR/DVR](#3-managing-nvrdvr-recorders)
4. [Živé zobrazenie a prekryvná oblasť zobrazenia](#4-live-view-and-viewport-overlays)
5. [Rozloženia obrazovky, predvoľby a panel s nástrojmi](#5-screen-layouts-presets-and-toolbar)
6. [Panel systémových štatistík (Systémové štatistiky)](#6-system-statistics-panel-system-stats)
7. [Playback Archive Player](#7-playback-archive-player)
8. [Sťahovanie nahrávok (sťahovanie)](#8-downloading-recordings-downloader)
9. [Rozšírené nastavenia a prispôsobenie v okne Možnosti](#9-advanced-settings-and-customization-in-options-window)
10. [Klávesové skratky a ovládanie myšou](#10-keyboard-shortcuts-and-mouse-controls)
11. [Snímanie snímok a konfigurácia cesty](#11-taking-snapshots-and-path-configuration)

---

## 1. Popis akcií tlačidiel

Táto časť popisuje význam všetkých grafických ikon a tlačidiel používaných v aplikácii.

### Horná lišta nástrojov
* {ICON:quit} **Zatvoriť okno**: Vyzve na potvrdenie a zatvorí aktívne okno alebo aplikáciu.
* {ICON:pin} **Pripnúť panel**: Uzamyká horný panel v rozbalenom stave alebo umožňuje automatické zbalenie.
* {ICON:fullscreen} **Celá obrazovka**: Prepne aktívne okno do režimu celej obrazovky.
* {ICON:minimize} **Minimalizovať**: Minimalizuje okno aplikácie na systémový panel úloh.
* {ICON:options} **Možnosti**: Otvára alebo zatvára okno možností konfigurácie (nastavenia a záznamníky).
* {ICON:new_window} **Nové okno**: Otvorí nové, nezávislé pomocné okno pre streamy kamier.
* {ICON:archive} **Archivovať**: Otvorí okno archívu prehrávaných nahrávok (časová os a kalendár).
* {ICON:instructions} **Pokyny**: Otvorí túto používateľskú príručku a okno technickej pomoci.
* {ICON:stats} **Štatistiky**: Prepína posuvný panel systémových štatistík (CPU, RAM, GPU, Net).
* {ICON:lock} **Zámok mriežky**: Zakáže úpravy rozdelenia mriežky na ochranu vášho aktívneho rozloženia.
* {ICON:hamburger} **Viac možností**: Otvorí posuvný panel nástrojov pre pokročilé veľkosti delenia, pomery a zlučovanie buniek.

### Prekrytia výrezov (fotoaparáty)
* {ICON:snapshot} **Snímka**: Zachytí bezstratový obrázok v plnom rozlíšení a uloží ho ako súbor JPEG.
* {ICON:play} **Archív kamery**: Spustí okno prehrávania na časovej osi pre túto kameru (15 minút dozadu).
* {ICON:quick_play} **Rýchle prehrávanie (miniprehrávač)**: Spustí prehrávanie archívu posledných 30 minút vo výreze, čo vám umožní rýchlo si prezrieť nedávny záznam priamo v dlaždici kamery bez opustenia živého náhľadu.
* {ICON:grid_1x1} **Vyskúšať 1:1**: Zobrazuje tok videa v pôvodnom natívnom rozlíšení bez roztiahnutia.
* {ICON:zoom_in} **Interaktívne priblíženie**: Prepína zväčšenie kliknutím a potiahnutím pre vybratú oblasť výberu.
* {ICON:zoom_out} **Obnoviť priblíženie**: Vynuluje digitálne zväčšenie a obnoví celé zorné pole kamery.
* {ICON:speaker_unmute} **Stlmiť zvuk**: predstavuje nestlmený zvukový prúd; kliknutím naň stlmíte stream.
* {ICON:speaker_mute} **Zapnúť zvuk**: Predstavuje stlmený zvukový prúd; kliknutím naň zrušíte stlmenie streamu.

### Ovládanie okna prehrávania

**Ovládacie prvky v hornej lište:**
* {ICON:close} **Zavrieť**: Zatvorí okno prehrávača archívu prehrávania.
* {ICON:pin} **Pripnúť panel**: Uzamyká horný panel v rozbalenom stave alebo umožňuje automatické zbalenie.
* {ICON:fullscreen} **Celá obrazovka**: Prepne okno prehrávania do režimu celej obrazovky.
* {ICON:sidebar} **Zobraziť/skryť bočný panel**: Prepína viditeľnosť ľavého bočného panela obsahujúceho kamery a rekordéry.
* {ICON:timeline_show} / {ICON:timeline_hide} **Zobraziť/skryť časovú os**: Zobrazí alebo skryje spodný panel obsahujúci časovú os a ovládacie prvky prehrávania.
* {ICON:video_folder} **Priečinok videa**: Otvorí lokálny systémový priečinok obsahujúci stiahnuté videoklipy.
* {ICON:photo_folder} **Priečinok snímok**: Otvorí lokálny systémový priečinok obsahujúci zachytené snímky.
* mriežkové tlačidlá `1x1`, `1x2`, `2x1`, `2x2`: Prepne rozloženie zobrazenia kamery v okne prehrávania na 1, 2 (vertikálne/horizontálne) alebo 4 súbežné zobrazenia.

**Spodná lišta a ovládacie prvky časovej osi:**
* {ICON:prev_day} **Predchádzajúci deň**: Prejde na nahrávky z predchádzajúceho kalendárneho dňa.
* {ICON:calendar_select} **Výber dátumu**: Otvorí dialógové okno kalendára na výber konkrétneho dátumu na prehrávanie.
* {ICON:next_day} **Ďalší deň**: Prejde na nahrávky nasledujúceho kalendárneho dňa.
* {ICON:today} **Dnes**: Okamžite presunie zameranie prehrávania na aktuálny kalendárny deň.
* {ICON:refresh_recordings} **Obnoviť nahrávky**: Obnoví a znova požiada o dostupné segmenty záznamu zo zariadenia.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Predvoľby priblíženia na časovej osi**: Prispôsobí viditeľné okno časovej osi (na 1 hodinu, 8 hodín alebo 24 hodín) pre veľmi presnú navigáciu.
* {ICON:timeline_center} **Vycentrovať časovú os**: Vycentruje zobrazenie časovej osi presne okolo aktuálnej časovej pečiatky prehrávania.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Rýchlosť prehrávania**: Upravuje násobiteľ prehrávania videa (štandardná 1x rýchlosť, 2x zrýchlené alebo 4x rýchle prehrávanie).
* {ICON:download} **Prevziať**: Otvorí nástroj na sťahovanie a exportuje definovaný segment videa zo zariadenia.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Preskočiť dozadu**: Previnie časovú pečiatku prehrávania o 60, 45 alebo 15 sekúnd.
* {ICON:play} / {ICON:pause} **Prehrať / Pozastaviť**: Spustí alebo pozastaví prehrávanie archívneho streamu videa.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Preskočiť vpred**: Posunie časovú pečiatku prehrávania o 15, 45 alebo 60 sekúnd.

**Ďalšie diagnostické a všeobecné ikony:**
* {ICON:calendar} **Kalendár**: Predstavuje konfigurácie kalendára/plánovania.
* {ICON:clock} **Čas**: Predstavuje indikátory hodín alebo časového stavu.
* {ICON:zoom} **Zoom**: Predstavuje konfiguráciu mierky alebo digitálneho priblíženia.
* {ICON:timeline_toggle} **Prepínanie časovej osi**: Predstavuje prepínanie alebo obnovenie chronologických zobrazení.
* {ICON:trash} **Odstrániť**: Bezpečne odstráni nakonfigurované rekordéry alebo rozloženia s potvrdením.
* {ICON:warning} **Upozornenie**: Zobrazuje sa v dialógových oknách pre nevratné akcie alebo vymazanie upozornení.

---

## 2. Inštalácia a spustenie

### Inštalácia na Arch Linux (Pacman)
Ak chcete nainštalovať program z pripraveného binárneho balíka, prejdite do adresára `packaging/arch/` a spustite:
```bash
sudo pacman -U kvision-2.6.3-1-x86_64.pkg.tar.zst
```
Balík automaticky nainštaluje program, aktivačný súbor `.desktop` a požadované knižnice Hikvision SDK do systémovej cesty `/usr/lib/kvision`.

### Manuálna kompilácia (zo zdrojového kódu)
Ak chcete program skompilovať manuálne (napr. v inej distribúcii Linuxu) namiesto použitia hotového balíka:

1. Nainštalujte požadované závislosti zostavy a runtime pomocou správcu balíkov. Pre Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Nakonfigurujte projekt pomocou CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Zostavte kód:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Nainštalujte aplikáciu do systému:
   ```bash
   sudo cmake --install build
   ```

### Spustenie
Program je možné spustiť zo systémovej ponuky alebo zadaním do terminálu:
```bash
kvision
```

### Riešenie problémov so škálovaním systému (KDE Plasma)

Počnúc verziou 2.4.4 KVision automaticky detekuje a správne aplikuje zlomkové škálovanie pracovnej plochy (napr. 125 %, 145 %, 150 %) nakonfigurované v nastaveniach KDE Plasma vynútením natívnych politík prenosu vysokého DPI v Qt. Používateľské rozhranie by sa teraz malo správne škálovať hneď po vybalení bez akéhokoľvek manuálneho zásahu.

#### Natívna podpora Wayland

Aby ste zaistili najlepší zážitok zo škálovania a výkon v rámci Wayland, uistite sa, že máte na svojom systéme nainštalovaný voliteľný balík `qt5-wayland`. To umožňuje KVision bežať natívne na Wayland namiesto toho, aby sa vrátil k XWayland.

Pre Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Pre Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Manuálne prepísanie škálovania (staré/záložné)

Ak používate staršiu verziu, neobvyklú konfiguráciu alebo jednoducho chcete manuálne vynútiť iný škálovací faktor ako zvyšok systému, stále môžete prepísať škálovanie aplikácie pomocou premenných prostredia.

Ak chcete napríklad vynútiť škálovanie **150 %**, spustite aplikáciu z terminálu pomocou:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Môžete to natrvalo použiť úpravou spúšťača aplikácií `kvision.desktop` v editore ponuky KDE a pridaním týchto premenných do poľa "Premenné prostredia").*

---

## 3. Správa rekordérov NVR/DVR

Ak chcete nakonfigurovať pripojenie k rekordéru Hikvision:
1. Otvorte okno možností a prejdite na kartu **Rekordéry** (ikona servera).
2. Zadajte prístupové údaje zariadenia:
   * **IP adresa**: Sieťová adresa rekordéra.
   * **Port**: Sieťový port súpravy SDK (predvolený je `8000`).
   * **Používateľské meno**: Používateľské meno (napr. `admin`).
   * **Heslo**: Heslo na prístup k rekordéru.
3. Kliknite na **Pripojiť a objaviť** (alebo **Uložiť a aktualizovať**).
4. Po úspešnom pripojení aplikácia automaticky zistí všetky aktívne kamery (kanály) pripojené k NVR/DVR a pridá ich do zoznamu.
5. Kliknutím na tlačidlo **Generovať mriežku** sa automaticky vytvorí rozloženie výrezu (prednastavené) obsahujúce všetky aktívne kamery z daného NVR v optimálnom rozložení mriežky.
6. **Zobrazenie zoznamov kamier (NvrCamerasWindow)**: Kliknutím na tlačidlo s ikonou počítačového monitora na ľubovoľnej karte rekordéra sa otvorí špeciálne okno zobrazujúce všetky rozpoznané kanály kamier ako interaktívne dlaždice.
7. **Generovanie miniatúr (Generovať miniatúry)**: V okne zoznamu kamier NVR je k dispozícii tlačidlo *„Generovať miniatúry“*. Kliknutím naň prikážete aplikácii vytiahnuť jednotlivé snímky z podstreamu každého kanála na pozadí a nastaviť ich ako miniatúry pozadia dlaždice. To poskytuje rýchly vizuálny náhľad každej kamery bez spustenia úplných živých kanálov.
8. **Funkcia Click-and-Add**: Aplikácia nepodporuje presúvanie dlaždíc (presúvanie) z okna so zoznamom kamery do hlavnej mriežky. Priradenie kamery sa vykonáva jednoduchým a spoľahlivým spôsobom: najprv kliknite ľavým tlačidlom myši na ľubovoľnú dlaždicu výrezu v mriežke hlavnej obrazovky a vyberte ju (zvýrazní sa jasným okrajom), potom kliknite na zelené tlačidlo **"+" (Priradiť k aktívnemu výrezu)** na želanej dlaždici kamery v okne so zoznamom kamier NVR. Stream sa v danom slote okamžite načíta.
9. **Stav relácie SDK (indikátor bodky)**: Vedľa adresy IP každého rekordéra v zozname je farebná bodka stavu:
   * **Zelená (PRIHLÁŠENÉ)**: Predstavuje aktívnu reláciu Hikvision SDK, ktorá je potrebná na ovládanie PTZ, požiadavky na archiváciu časovej osi a sťahovanie.
   * **Červená (NEPRIHLÁSENÉ)**: Momentálne nie je vytvorená žiadna aktívna relácia súpravy SDK (napr. pred prvou požiadavkou súpravy SDK alebo po manuálnom/automatickom odhlásení). Upozorňujeme, že živé kanály RTSP z kamery sa budú naďalej prehrávať nezávisle od stavu relácie súpravy SDK.
10. **Premenovanie miestnej kamery**: Na ľubovoľnej dlaždici kamery v zozname kamier NVR kliknite na ikonu **Upraviť** (ceruzka). Otvorí sa dialógové okno, ktoré vám umožní nastaviť vlastný názov kamery. Tento názov sa ukladá lokálne a okamžite sa aktualizuje v rámci živých hráčov, časovej osi a zobrazenia dlaždíc bez úpravy fyzického zariadenia NVR. Kedykoľvek ho môžete obnoviť na predvolený názov.
11. **Odstránenie rekordéra zo zoznamu**: Vedľa každého nakonfigurovaného rekordéra v zozname je červené tlačidlo odpadkového koša. Kliknutím naň spustíte dvojstupňový bezpečnostný protokol navrhnutý tak, aby zabránil náhodnému vymazaniu:
    * **Krok 1 (Potvrdenie)**: Zobrazí sa dialógové okno s názvom *“Confirm NVR Deletion”* s otázkou, či naozaj chcete vymazať rekordér.
    * **Krok 2 (Upozornenie)**: Zobrazí sa druhé dialógové okno s upozornením s názvom *„Upozornenie!“* s otázkou, či ste si absolútne istí a uvedomujete si, čo robíte.
    * **Účinok odstránenia**: Po prijatí druhého varovania sa program na pozadí odhlási z daného NVR, vymaže svoj záznam z konfigurácie aplikácie a **automaticky vyčistí zoznam prednastavených rozložení**, čím odstráni všetky dynamické mriežky vygenerované pre toto zariadenie NVR.

---

## 4. Live View a Viewport Overlay

Hlavné okno programu zobrazuje živý kanál:
* **Mriežka kamery**: Zobrazuje streamy RTSP alebo informačné kanály priamo zo súpravy Hikvision SDK.
* **Výber kvality streamu**: Kliknutím pravým tlačidlom myši na výrez kamery môžete vybrať **Hlavný stream** pre najvyššie rozlíšenie alebo **Vedľajší stream** na zníženie zaťaženia siete a grafickej karty.
* **Prepínanie dvojitým kliknutím na celú obrazovku**: Dvojité kliknutie ľavým tlačidlom myši na ľubovoľný výrez kamery ho okamžite maximalizuje, aby vyplnil celú oblasť aktívneho okna (celá obrazovka s jedným výrezom). Opätovným dvojitým kliknutím obnovíte pôvodné rozloženie mriežky s viacerými kamerami.
* **Automaticky skryť horný panel**: Horný panel s nástrojmi (topToolBar) sa môže automaticky zbaliť k hornému okraju obrazovky, keď kurzor myši opustí svoju oblasť (táto možnosť je konfigurovateľná v časti Nastavenia -> *„Automaticky zbaliť horný panel“* alebo priamo pomocou ikony špendlíka na hornom paneli).
* **Viac monitorov a pomocné okná**: Môžete otvoriť nezávislé dodatočné (pomocné) okná na spustenie rôznych rozložení mriežky súčasne na viacerých obrazovkách alebo monitoroch. Ak chcete otvoriť nové okno, použite klávesovú skratku `Ctrl+N` alebo kliknite na tlačidlo **"Nové okno"** na hornom paneli s nástrojmi, ktorý sa nachádza po umiestnení kurzora myši. Každé okno je možné nakonfigurovať s vlastnou veľkosťou mriežky a prednastaveným rozložením. Na zaistenie maximálnej stability v konfiguráciách s viacerými monitormi sa všetky okná spúšťajú striktne v strede primárneho displeja s 90 % jeho rozlíšenia.

### Tlačidlá prekrytia výrezu
V pravom dolnom rohu každej dlaždice/výrezu kamery sa po umiestnení kurzora myši na ňu zobrazí ovládací panel s piatimi funkčnými ikonami (v závislosti od preferencií používateľského rozhrania):
1. **Ikona fotoaparátu (snímka)**: Umožňuje vám urobiť snímku obrazovky z informačného kanála fotoaparátu. Snímka sa uloží v plnom natívnom rozlíšení streamu priamo z vyrovnávacej pamäte snímok dekodéra, čím sa zabráni akýmkoľvek stratám v dôsledku aktuálnej veľkosti dlaždice výrezu alebo zmeny rozlíšenia obrazovky. Úspešné uloženie snímky je potvrdené blikaním ikony fotoaparátu na oranžovo (`#ff7a00`) presne na 1 sekundu.
2. **Ikona prehrávania (archív)**: Používa sa na rýchle otvorenie archívu nahrávok. Kliknutím na toto tlačidlo sa automaticky spustí časová os `PlaybackWindow` pre túto konkrétnu kameru a spustí sa prehrávanie **presne 15 minút pred aktuálnym systémovým časom** (pohodlný rýchly posun dozadu).
3. **Ikona kruhovej šípky (Rýchle prehrávanie / Miniprehrávač)**: Aktivuje rýchle prehrávanie záznamov archívu kamery za posledných 30 minút priamo vo vnútri dlaždice kamery bez opustenia mriežky naživo alebo spustenia celého okna archívu.
   * **Ovládací panel**: Keď je aktívny, v spodnej časti výrezu sa zobrazí posuvný ovládací panel obsahujúci:
     * **Prehrať/pozastaviť**: Pozastaví alebo obnoví prehrávanie.
     * **Zobrazenie času a posunu**: Zobrazuje aktuálnu časovú pečiatku prehrávania a jej relatívny vek v porovnaní s reálnym časom (napr. `-12:34` predstavuje pred 12 minútami a 34 sekundami).
     * **Interaktívny posúvač časovej osi**: Umožňuje klikaním alebo ťahaním hľadať kdekoľvek v rámci 30-minútovej vyrovnávacej pamäte. Dostupné segmenty záznamu sú zvýraznené modrozeleným pozadím a červená prehrávacia hlava označuje aktuálnu pozíciu.
     * **Násobiteľ rýchlosti**: Cyklicky prepína medzi rýchlosťami prehrávania (`1x`, `2x` a `4x`) na rýchle skenovanie záznamu.
     * **Zavrieť (✕)**: Zatvorí miniprehrávač a okamžite vráti výrez do živého kanála.
   * **Podpora posúvateľného priblíženia**: Rovnako ako v živom zobrazení môžete použiť nástroj zväčšovacieho skla na priblíženie oblasti miniprehrávača alebo podržaním stredného tlačidla myši a ťahaním môžete posúvať.
4. **Ikona 1:1 (natívna mierka)**: Prepína režim zobrazenia videa po jednotlivých pixeloch. Keď je táto možnosť povolená, video nie je roztiahnuté ani zdeformované, aby vyplnilo hranice dlaždíc, ale namiesto toho sa vycentruje a zobrazí v pôvodnom natívnom rozlíšení. Keď je tento režim aktívny, pozadie tlačidla a text „1:1“ sú zvýraznené jasnou neónovou svetlo-tyrkysovou farbou.
5. **Ikona lupy (interaktívne priblíženie)**: Umožňuje zväčšiť akúkoľvek konkrétnu oblasť zdroja videa:
   * **Aktivácia**: Kliknutím na ikonu ju prepnete do aktívneho stavu (tyrkysové zvýraznenie). Kurzor zmení tvar a nápoveda povie: *„Kliknutím a potiahnutím na feed fotoaparátu priblížite“*.
   * **Operácia**: Kliknite ľavým tlačidlom myši a presuňte obdĺžnikovú oblasť ohraničenia cez živý informačný kanál. Výrez automaticky oreže a zmení veľkosť vybranej oblasti, aby vyplnil celú dlaždicu.
     * **Proporcionálne priblíženie**: Počas kreslenia obdĺžnika priblíženia podržte stlačený kláves **Shift**, aby sa výber uzamkol v pomere strán 16:9, ktorý je striktne obmedzený na hranice výrezu.
     * **Posúvanie zväčšeného obrazu (Pan Zoom)**: Po priblížení môžete podržať **stredné tlačidlo myši (rolovacie koliesko)** a ťahaním kurzora voľne posúvať zväčšené zobrazenie okolo zorného poľa videa. Funguje to v živom zobrazení, archíve prehrávania a miniprehrávači.
   * **Resetovať**: Pri priblížení ikona lupy zmení svoju ikonu (červený okraj so znamienkom mínus). Kliknutím naň okamžite resetujete priblíženie a vrátite sa k plnému záberu fotoaparátu.

---

## 5. Rozloženia obrazovky, Predvoľby a Panel s nástrojmi

Rozloženia vám umožňujú organizovať usporiadanie kamier na obrazovke. Na karte **Predvoľby** (ikona hviezdičky) môžete:
* **Vytvoriť nové predvoľby**: Pridajte svoje vlastné rozloženie s ľubovoľnou konfiguráciou stĺpcov a riadkov (napr. 2x2, 3x3, 4x4).
* **Priradiť kamery**: Kliknutím na výrez v rozložení mriežky ho vyberte, potom otvorte okno kamier NVR a kliknite na tlačidlo **"+" (Pridať)** na dlaždici požadovanej kamery. Pozíciu výrezu môžete zameniť aj pomocou kontextového menu (*„Zamień miejscami”* / *„Zameniť výrezy”*) zdrojového výrezu a potom kliknutím na cieľový výrez.

### Tlačidlá hornej lišty (horná lišta nástrojov)
Horný posuvný panel nástrojov poskytuje komplexnú sadu navigačných tlačidiel a tlačidiel na ovládanie aplikácií:
1. **Zavrieť okno (červené ✕ tlačidlo)**: Zatvorí aktívne okno. Aby sa predišlo náhodným kliknutiam, zachytí udalosť zatvorenia a zobrazí dialógové okno s výzvou na potvrdenie ukončenia aplikácie.
2. **Tlačidlo Pripnúť**: Ovláda automatické skrytie horného panela s nástrojmi. Keď kolík smeruje vertikálne (pripnutý stav), lišta je zaistená na mieste a zostáva trvalo viditeľná. Keď sa špendlík otočí o -45 stupňov (nepripnutý stav), lišta sa automaticky vysunie nahor mimo dohľadu, keď myš opustí jej oblasť.
3. **Celá obrazovka (ikona so zelenými šípkami)**: Okamžite prepne aktívne okno do režimu celej obrazovky a späť. V režime celej obrazovky smerujú šípky dovnútra (zbalia sa) a v režime okna smerujú von (rozbalia).
4. **Minimalizovať (azúrová ikona minimalizácie)**: Minimalizuje okno aplikácie na panel úloh. Jeho obnovením sa okno vráti do presne predchádzajúceho stavu (napr. maximalizované alebo na celú obrazovku).
5. **⚙️ MOŽNOSTI (OPCJE)**: Prepína okno s možnosťami konfigurácie. Ak je už okno otvorené, kliknutím na toto tlačidlo ho zatvoríte.
6. **📺 NOVÉ OKNO (TERAZ OKNO)**: Otvára nové, nezávislé a plne konfigurovateľné `Auxiliary Window`, ideálne na rozšírenie rozloženia kamier na viacero nastavení monitorov.
7. **ARCHÍV**: Otvorí prázdny `PlaybackWindow` (prehrávač nahrávok) s aktívnou časovou osou a kalendárom, čo umožňuje manuálny výber kanálov streamu a kamery z ľubovoľného nakonfigurovaného NVR prostredníctvom zoznamu na bočnom paneli.
8. **POKYNY (INSTRUKCJA)**: Otvorí okno tejto príručky a načíta kompletnú používateľskú dokumentáciu v angličtine alebo poľštine v závislosti od vášho aktívneho miestneho nastavenia.
9. **📊 Prepínač ŠTATISTIKY (STATYSTYKI)**: Prepínačom vysuniete monitorovací panel systémových štatistík z ľavého okraja obrazovky.
10. **Prepínač uzamknutia mriežky (visiaci zámok)**: Prepínač, ktorý po zapnutí (zvýraznený jasnou oranžovou farbou) deaktivuje akcie zmeny veľkosti mriežky na susedných tlačidlách mriežky, čím chráni rozloženie aktívnej kamery pred náhodnými zmenami.
11. **Výbery veľkosti mriežky (od 1x1 do 9x9)**: Rad deviatich tlačidiel, ktoré vám umožňujú okamžite definovať štruktúru riadkov a stĺpcov vášho výrezu (od zobrazenia jednej kamery 1x1 až po 81 simultánnych vstupov z kamery v rozložení 9x9). Aktuálne aktívna veľkosť sa zvýrazní jasnou oranžovou farbou.
12. **Viac možností (Hamburger Menu s tromi riadkami)**: Tlačidlo otvárajúce posuvný panel nástrojov `Layout & Grid Tools` pre pokročilé ladenie mriežky, úpravy geometrie a možnosti ladenia (podrobnosti nižšie).
13. **Tlačidlá predvoľby/zobrazenia**: Dynamicky vykreslené tlačidlá na pravej strane panela s nástrojmi predstavujúce vaše nakonfigurované a viditeľné prednastavené rozloženia (napr. *📹 NVR*, *Zobraziť 1* atď.). Kliknutím na tlačidlo sa mriežka okamžite prepne. Aktívny pohľad sa zvýrazňuje jasnou svetlo-tyrkysovou farbou.

### Pokročilé prispôsobenie a pomery mriežky (nástroje rozloženia a mriežky)
Otvorením ponuky Hamburger (Viac možností) sa zobrazí špecializovaný panel nástrojov na rozloženie. Ak chcete aktivovať jeho ovládacie prvky:
1. **Odomknúť tablu nástrojov**: Prepnite prepínač „Odomknúť tablu nástrojov“ úplne hore. Toto je explicitné bezpečnostné opatrenie, ktoré má zabrániť náhodným zmenám zložitých rozložení.
2. **Vlastné delenie okien (F2 alebo stlačenie a podržanie)**: Panel nástrojov zobrazuje tlačidlá delenia mriežky od 1x1 do 9x9. Mimoriadne pokročilou funkciou je možnosť **prepisovať a upravovať veľkosti divízií**. Ak kliknete a podržíte ľubovoľné tlačidlo mriežky ľavým tlačidlom myši (alebo ho zaostríte a stlačíte **F2**), zobrazí sa textové pole. Môžete zadať ľubovoľné vlastné alebo asymetrické delenie (napríklad `2x3`, `1x4` atď.) a stlačiť Enter. Tlačidlo sa okamžite preprogramuje a kliknutím naň sa v hlavnom výreze použije vlastné rozloženie.
3. **Pomery geometrie**: Umožňuje vynútiť zobrazenie mriežky na konkrétne pomery strán:
   * **Pomer strán 16:9**: Uzamkne a upraví mriežkový kontajner na širokouhlý formát 16:9 (štandard pre moderné IP kamery).
   * **Pomer strán 4:3**: Prispôsobí mriežkový kontajner na tradičný pomer 4:3 (bežný v starších analógových/IP kamerách).
4. **Operácie mriežky (Zlúčiť zvýraznené bunky)**: Prístup k funkcii asymetrického zlučovania buniek (podrobne v časti 9.2).

---

## 6. Panel systémových štatistík (Systémové štatistiky)

Tento panel, ktorý sa vysunie z ľavého okraja obrazovky živého náhľadu, monitoruje stav počítača a záťaž generovanú aplikáciou:
* **Monitorované parametre**:
  * **CPU / RAM**: Využitie hlavného procesora (v % všetkých jadier) a pamäte RAM využívanej priamo procesom `kvision` a súvisiacimi podprocesmi sťahovania.
  * **GPU / VRAM**: Využitie jadra grafickej karty (v %) a množstvo grafickej pamäte VRAM obsadenej vykresľovaním a hardvérovým dekódovaním (podporuje úplný zoznam procesov GPU pomocou analyzátora XML z `nvidia-smi`).
  * **NETWORK (Net)**: Aktuálna prenosová rýchlosť sťahovania aplikácie zo všetkých aktívnych živých prehrávačov, archívnych prehrávačov a procesov sťahovania záznamov.
* **Viacvláknové spracovanie (bez zaseknutia)**: Zhromažďovanie údajov o procese a GPU prebieha v samostatnom systémovom vlákne (`StatsWorker`). To zabraňuje akémukoľvek malému zaseknutiu pri vykresľovaní videa (žiadne poklesy snímok).
* **Funkcia pripnúť**: Kliknutím na tlačidlo **Pripnúť** (ikona pripnúť) uzamknete panel v rozbalenom stave.
* **Estetika**: Grafy sa vyznačujú jasnými, neónovo zelenými okrajmi, prechodovou výplňou pod krivkou grafu a vyváženou 35 % priehľadnosťou pozadia na zabezpečenie čitateľnosti textu.

---

## 7. Prehrávanie archívov

Dostupné po kliknutí na ikonu hodín/prehrávania vedľa konkrétnej kamery alebo rekordéra. Umožňuje súčasné prezeranie archivovaných záznamov z viacerých kamier Hikvision v plnej časovej synchronizácii.

### Časová os a ovládacie prvky:
* **Rýchly štart (15 minút dozadu)**: Pri otvorení archívu zo živého zobrazenia sa prehrávač automaticky spustí od okamihu, ktorý spadá **presne 15 minút pred aktuálny systémový čas** (namiesto spustenia o polnoci). To umožňuje okamžité zobrazenie udalosti, ktorá sa práve stala.
* **Navigácia**: Časovú os možno posúvať doľava a doprava potiahnutím ľavým tlačidlom myši.
* **Zoom (zmena mierky)**: Mierku časovej osi môžete plynulo meniť pomocou rolovacieho kolieska myši (alebo tlačidiel priblíženia) – od zobrazenia celého dňa až po presné 10-minútové zobrazenie.
* **Skratky rýchleho priblíženia**: Spodný ovládací panel obsahuje špeciálne kruhové tlačidlá s ikonami na okamžité prispôsobenie zobrazenia časovej osi:
  * **Ikona „1h“**: Približuje časovú os pre podrobnú kontrolu počas 1 hodiny.
  * **Ikona „8h“**: Priblíži časovú os tak, aby sa zobrazilo 8-hodinové rozpätie.
  * **Ikona „24h“**: Resetuje priblíženie, aby sa celý 24-hodinový deň zmestil na jednu obrazovku.
  * **Ikona na stred (cieľ)**: Okamžite vycentruje časovú os tak, že červený indikátor prehrávania je presne v strede obrazovky (nahrádza staré textové tlačidlo).
* **Navigácia podľa dátumu (kalendár a dni)**: Ovládacie prvky vedľa zobrazeného dátumu umožňujú rýchle skoky:
  * Tlačidlá **„<“ (Predchádzajúci deň)** a **„>“ (Ďalší deň)**: Umožňujú vám okamžitý skok o 24 hodín dozadu alebo dopredu bez otvorenia dialógového okna kalendára.
  * **Ikona kalendára**: otvorí kontextové okno kalendára na výber konkrétneho dátumu.
  * **Ikona obnovenia**: Vynúti nové vyhľadávanie nahrávok. Kliknutím naň vymažete lokálnu vyrovnávaciu pamäť segmentov dostupnosti záznamu pre všetky aktívne kanály a odošlete nové dopyty do NVR, čo je veľmi užitočné na načítanie súborov zaznamenaných len pred niekoľkými okamihmi (nahradením starého textového tlačidla).
  * **Ikona Dnes (dnešný dátum/číslo)**: Okamžitý skok späť na aktuálny deň (nahradením starého textového tlačidla).
* **Skratky rýchlosti prehrávania**:
  * **Ikony „1x“, „2x“ a „4x“**: Okamžite zmeňte násobiteľ rýchlosti prehrávania.
* **Tlačidlá skokov na videorekordéri**:
  * **Ikony „15“, „45“ a „60“ s kruhovými šípkami**: Umožňujú vám rýchlo preskočiť dozadu alebo dopredu o určený počet sekúnd.
* **Pruhy dostupnosti nahrávania**: Farebné pruhy predstavujúce nájdené segmenty videa na disku rekordéra sa vykreslia pod časovou osou. Systém ukladania do vyrovnávacej pamäte zabraňuje ich blikaniu pri presúvaní.
* **Automatické sledovanie (sledovanie indikátora)**: Indikátor prehrávania (vertikálna červená čiara) je neustále monitorovaný. Ak sa indikátor dostane mimo viditeľný rozsah časovej osi, zobrazenie sa automaticky posunie do stredu. Táto možnosť je inteligentne uzamknutá počas manuálneho ťahania indikátora používateľom.

### Bočný panel fotoaparátu v okne prehrávania
Vertikálny bočný zoznam na pravom okraji prehrávača obsahuje zoznam všetkých nakonfigurovaných NVR a ich kamerových kanálov:
* **Prepínanie kanálov**: Kliknutím na ľubovoľný kanál kamery v zozname sa kanál pridá ako aktívny priestor prehrávania na časovej osi (vytvorí prehrávač videa). Opätovným kliknutím naň kanál odstránite.
* **Kontextová ponuka kanála**: Kliknutím pravým tlačidlom myši na aktívny video slot v mriežke prehrávania sa otvorí ponuka na:
  * Prepnúť kvalitu videa (hlavný tok / vedľajší tok).
  * Zatvorte/odstráňte aktívny prehrávač z prehrávania archívu.

---

## 8. Sťahovanie nahrávok (Downloader)

Z okna Archív prehrávania si môžete stiahnuť vybrané segmenty nahrávok priamo na disk vášho počítača ako súbory MP4:
1. Kliknite na ikonu sťahovania (šípka nadol) vedľa vybratej kamery.
2. Vyberte časový rozsah (začiatok a koniec nahrávania).
3. Vyberte umiestnenie na uloženie cieľového súboru.
4. Kliknite na položku **Stiahnuť**.

### Pokročilé funkcie sťahovania:
* **Sekvenčné sťahovanie segmentov (časti 1 GB)**: Program automaticky rozdelí dotaz na časové obdobie na segmenty fyzických súborov (každý približne 1 GB na jednotke NVR) a stiahne a konvertuje ich jeden po druhom (pomocou dočasných súborov `.pspart`, ktoré sa konvertujú priamo do formátu `.mp4`). To zaisťuje vysoko stabilné sťahovanie dlhých rozsahov bez pretečenia pamäte alebo zablokovania konverzie FFmpeg.
* **Vizualizácia celkového priebehu**: Ukazovateľ priebehu (jasná modrozelená farba) zobrazuje celkový priebeh sťahovania pre kameru vo všetkých segmentoch. Stavový text prekrytý na indikátore priebehu zobrazuje aktuálnu časť a percentá, napr. `Downloading part 1 of 3... 45% (Overall: 15%)`, s obrysovým štýlom, ktorý zaručuje čitateľnosť na akomkoľvek pozadí.
* **Čistenie IP názvu súboru**: Názvy súborov videa (a živé/archívne snímky) sa automaticky odstránia z IP adries NVR/DVR, aby zostali čisté a čitateľné (napr. `4_Wejscie_glowne_2026-06-15.mp4` namiesto `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Rozšírené nastavenia a prispôsobenie v okne Možnosti

Okno možností a konfigurácie (`SideBar`) pozostáva zo šiestich vyhradených kariet:

### 1. Podrobnosti výrezu (ikona monitora)
Zobrazuje pokročilé parametre aktuálne vybratej dlaždice mriežky. Umožňuje:
* Zadajte vlastnú **Adresu URL primárneho streamu** (RTSP/ONVIF) a **Adresu URL sekundárnej zálohy** pre manuálne konfigurácie.
* Prepína stlmenie/zrušenie stlmenia zvukového kanálu zvoleného zdroja kamery.
* Do textového poľa **Prepísanie možností FFmpeg** zadajte rozšírené prepísania dekodéra.
> [!TIP]
> Pre najrýchlejšie streamové pripojenie a maximálnu stabilitu cez RTSP sú odporúčané parametre:
> ```ini
> -dĺžka analýzy 0 -veľkosť sondy 500 000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Nástroje rozloženia a mriežky (ikona posúvača)
Pokročilé možnosti prispôsobenia mriežky obrazovky:
* Rýchle prepnutie do režimu celej obrazovky.
* **Asymetrické zlučovanie buniek (zlúčenie zvýraznených buniek)**: Veľmi pokročilý editor rozloženia. Podržte kláves **Ctrl** alebo **Shift** a kliknutím vyberte viacero susediacich dlaždíc na mriežke, alebo použite klávesnicu tak, že podržíte kláves **Shift** a navigujete pomocou **kláves so šípkami**, potom kliknete na položku „Zlúčiť zvýraznené bunky“, čím ich spojíte do jedného väčšieho výrezu. To vám umožní vytvárať úplne vlastné asymetrické mriežkové návrhy (napr. jeden obrovský panel kamery s menšími kanálmi, ktoré ho obklopujú).

### 3. Záznamníky (ikona servera)
Úplný konfiguračný manažér pre pripojenia k Hikvision NVR/DVR zariadeniam (podrobne popísané v časti 3).

### 4. Predvoľby (ikona hviezdičky)
Správca pre vaše uložené rozloženia mriežky a priradenia kamier. Umožňuje vytvárať prázdne šablóny mriežky, meniť ich poradie, prepínať ich viditeľnosť v hornej lište (pomocou prepínača "Viditeľné") alebo ich aktivovať v aktuálnom okne.

### 5. Nastavenia (ikona ozubeného kolieska)
Umožňuje upraviť globálne nastavenia aplikácie:
* **Povoliť spustenie viacerých inštancií**: Začiarknutím tohto políčka povolíte spustenie viacerých paralelných kópií procesu KVision (v predvolenom nastavení obmedzuje spustenie na jednu aktívnu inštanciu).
* **Nastavenia automatického zbalenia**: Prispôsobí časovanie posuvnej animácie pre horný panel a panel so štatistikami.
* **Povoliť výmenu výrezov**: Začiarkavacie políčko *„Povoliť zámenu miest výrezov“* vám umožňuje za chodu zmeniť usporiadanie pozícií kamery na mriežke (Kliknite pravým tlačidlom myši na zdrojovú dlaždicu -> Vyberte „Zameniť výrezy“ -> Kliknite ľavým tlačidlom myši na cieľovú dlaždicu).
* **Povolenia na kliknutie pravým tlačidlom**: Prepne na uzamknutie/odomknutie interaktívnych ovládacích prvkov v kontextovej ponuke po kliknutí pravým tlačidlom myši (Povoliť kontextovú ponuku, Povoliť výmenu zobrazovaných oblastí, Povoliť možnosť „Odstrániť kameru“, Povoliť zmenu nastavení zobrazovanej oblasti, Povoliť výber kvality hlavného/vedľajšieho streamu).
* **Automatické zapnutie**: Automaticky zruší stlmenie zvukového prúdu aktívneho výrezu pri prechode do režimu celej obrazovky.
* **Skryť kurzor v režime celej obrazovky**: Začiarkavacie políčko *„Skryť kurzor v režime celej obrazovky“* automaticky skryje kurzor myši po krátkej nečinnosti počas zobrazenia na celú obrazovku, aby sa zabezpečilo neobmedzené zobrazenie.
* **Výber jazyka**: Okamžite prepína preklad rozhrania (predvolené nastavenie systému, poľština, angličtina).
* **Predvoľby používateľského rozhrania**: Skrytie/zobrazenie štítkov stavu výrezu alebo odznakov ovládacích prvkov (napríklad automatické skrytie prekrytí ovládacích prvkov v pravom dolnom rohu dlaždíc, pokiaľ neumiestníte kurzor myši).
* **Predvolené možnosti FFmpeg a hromadná aktualizácia**: Umožňuje konfigurovať globálne možnosti FFmpeg aplikované na nové výrezy (odporúčané: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[ODPORUČENIE]** Ak migrujete zo staršej verzie KVision (pred verziou 2.4.5), dôrazne sa odporúča zmeniť `-analyzeduration 0` na `-analyzeduration 100000` v globálnych nastaveniach a kliknúť na „Aktualizovať všetky kamery“. Nastavenie `0` na streamoch bez zvukovej stopy spôsobuje oneskorenie prepínania, pretože FFmpeg zablokuje napevno zakódovaný 5-sekundový časový limit čakania na zvukové pakety. Nastavenie veľmi nízkej hodnoty (napr. 100 000 mikrosekúnd = 0,1 s) tento problém úplne vyrieši pri zachovaní okamžitého prepínania.
  * **Tlačidlo Aktualizovať všetky kamery**: Tlačidlo *„Zaktualizuj wszystkie kamery“* aplikuje tieto globálne možnosti na všetky nakonfigurované výrezy.
  * **Príznaky nízkej latencie (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` deaktivuje interné ukladanie paketov demuxera, aby sa eliminovalo oneskorenie streamovania v priebehu času, ale môže spôsobiť zasekávanie, ak je vaše sieťové pripojenie ku kamere nestabilné.
    * `-flags low_delay` povie dekodéru, aby okamžite vydal snímky, ale môže spôsobiť krátke artefakty/rozmazanie v tokoch, ktoré používajú B-snímky pri rýchlych pohyboch.
  * **Prepísať začiarkavacie políčko**: Môžete vylúčiť konkrétne výrezy z globálnych aktualizácií alebo dynamických predvolených nastavení začiarknutím možnosti **"Nie je možné zmeniť globálne ustawieniach FFMpeg"** v dialógovom okne Nastavenia jednotlivých výrezov. Užitočné pri riešení problémov so zadrhávajúcimi sa fotoaparátmi.


### 6. Denník zmien (ikona hodín/dokumentu)
Predstavuje interaktívnu časovú os zobrazujúcu kompletnú históriu vydaní, aktualizácie, opravy chýb a pridané funkcie KVision, vďaka čomu máte priamy prístup k podrobnostiam o aktualizáciách programu.

---

## 10. Klávesové skratky a ovládanie myšou

### Klávesové skratky:
| Kláves / skratka | Akcia |
|---|---|
| **F** / **F11** | Prepnúť režim celej obrazovky. |
| **M** | Stlmiť / zapnúť zvuk (funguje pre aktívnu kameru so zvukom). |
| **Vesmír** | Prehrať / Pozastaviť prehrávanie v okne Archív prehrávania. |
| **Alt + 1** až **Alt + 9** | Rýchle prepnutie na predvoľbu/rozloženie pri indexoch 1 až 9. |
| **Alt + šípka doľava** | Rýchle prepnutie na predchádzajúcu predvoľbu/rozloženie v kolekcii. |
| **Alt + šípka doprava** | Rýchle prepnutie na ďalšiu predvoľbu/rozloženie v kolekcii. |
| **Klávesy so šípkami (nahor/nadol/doľava/doprava)** | Navigujte a presúvajte aktívne zaostrenie/výber medzi výrezmi kamery. |
| **Shift + šípky** | Vyberte viacero susedných výrezov kamery súčasne (používané na zlúčenie buniek atď.). |
| **Ctrl + N** | Otvorte nové, nezávislé pomocné okno. |
| **+** / **-** | Priblíženie / oddialenie (kamery Hikvision s podporou PTZ). |
| **Shift** (presunúť okraj) | Vynútiť uzamknutie výberu ohraničenia v pomere strán 16:9 počas interaktívneho priblíženia. |
| **Esc** | Ukončite režim celej obrazovky / zrušte aktívny výber výrezu. |

### Interakcia myši:
* **Ľavé tlačidlo myši**:
  * **Dvojitým kliknutím** na výrez kamery v mriežke ho maximalizujete na celú obrazovku. Ďalším dvojitým kliknutím obnovíte zobrazenie mriežky.
  * Ak chcete navigovať, potiahnite časovú os v okne prehrávania.
* **Stredné tlačidlo myši (kliknutie a potiahnutie rolovacím kolieskom)**:
  * Ťahaním posúvajte a posúvajte digitálne priblížený/zväčšený obrázok po zornom poli výrezu (funguje v režime Live, Archive a Mini-player).
* **Pravé tlačidlo myši (kontextová ponuka)**:
  * Otvorí ponuku rýchlych nastavení pre vybratý výrez (umožňuje odstrániť kameru z mriežky, prepínať medzi hlavnými a vedľajšími prúdmi alebo pristupovať k jednotlivým parametrom zobrazenia).
* **Rolovacie koliesko myši**:
  * Upravuje mierku (lupu) časovej osi v prehrávači archívu prehrávania.

---

## 11. Vytváranie snímok a konfigurácia cesty

Aplikácia umožňuje rýchlo zachytiť vysokokvalitné snímky z ľubovoľného výrezu fotoaparátu v režime Live View aj v režime Playback Archive.

### Vytváranie snímok:
1. V pravom dolnom rohu každého výrezu je k dispozícii tlačidlo prekrytia ikony fotoaparátu (podrobnosti v časti 4).
2. Kliknutím na ikonu fotoaparátu sa snímka zachytí a uloží ako obrázok vo formáte JPEG (kvalita 98 ​​– prakticky bezstratová).
3. Úspešné zachytenie je potvrdené blikaním ikony fotoaparátu na oranžovo (`#ff7a00`) presne na 1 sekundu.
4. **Plné rozlíšenie**: V režime archívu prehrávania sa snímky ukladajú v plnom natívnom zdrojovom rozlíšení streamu priamo z vyrovnávacej pamäte snímok dekodéra, bez ohľadu na veľkosť aktívneho výrezu na obrazovke alebo mierku zobrazenia.

### Ukladanie konfigurácií cesty:
1. Prejdite na kartu **Nastavenia** (ikona ozubeného kolieska v okne možností).
2. V časti **Ukladanie** ("Zapis") môžete nakonfigurovať predvolené cesty:
   * **Predvolená cesta k snímkam**: Priečinok, do ktorého sa budú ukladať snímky (predvolená hodnota je `~/Obrazy/CCTV`).
   * **Predvolená cesta k nahrávkam**: Priečinok, do ktorého sa uložia stiahnuté videá MP4 (predvolená hodnota je `~/Wideo/CCTV`).
3. Kliknutím na tlačidlo prehliadača `...` sa otvorí natívny výber priečinkov vášho operačného systému (Breeze v KDE).
4. **Správanie tlačidla prehliadača**: Nástroj na výber adresára sa otvorí presne na ceste zadanej do textového poľa (ak existuje). Ak je pole prázdne, neplatné alebo ukazuje na priečinok, ku ktorému nemáte prístup, dialógové okno sa vráti späť a otvorí sa vo vašom domovskom adresári (`~/`).

### Nastavenia používateľského rozhrania (UI):
1. Prejdite na kartu **Nastavenia** (ikona ozubeného kolieska v okne možností) alebo otvorte okno **Možnosti** ("Opcje").
2. V sekcii **Nastavenia používateľského rozhrania** môžete prispôsobiť viditeľnosť prvkov prekrytých na kafelki/výrezoch fotoaparátu:
   * **Zobraziť stav kanála v ľavom hornom rohu zobrazovanej oblasti** (predvolene povolené) – zobrazuje načítavanie, prehrávanie a informácie o stave pripojenia.
   * **Zobraziť informácie o kamere v ľavom dolnom rohu výrezu** (predvolene povolené) – Zobrazuje názov kamery získaný z rekordéra Hikvision.
   * **Zobraziť ovládacie ikony v pravom dolnom rohu výrezu iba pri umiestnení kurzora myši** (predvolene povolené) – Automaticky skryje panel ovládacích tlačidiel (snímka, archív, pomer pixelov k pixelom 1:1, priblíženie oblasti), keď je kurzor myši mimo konkrétneho výrezu kamery. Ikony sa objavia okamžite, akonáhle prejdete myšou na výrez (nevyžaduje sa žiadne kliknutie) a pri odchode zmiznú, čím sa maximalizuje viditeľnosť streamov z vašej kamery.
   * **Zobraziť informačné polia iba pri umiestnení kurzora myši** (predvolene vypnuté) – Analogická možnosť, ktorá skryje stav v ľavom hornom rohu a názov v ľavom dolnom rohu výrezov, čím sa zobrazí úplne čistý prúd kamery, pokiaľ sa kurzor nepresunie nad konkrétnu dlaždicu kamery.
