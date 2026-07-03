# Uživatelský manuál pro KVision

> [!POZNÁMKA]
> Tento návod k použití byl automaticky přeložen a zformátován za pomoci umělé inteligence (AI).

**KVision** je pokročilá desktopová aplikace třídy VMS (Video Management System) navržená pro současné sledování živých video streamů (RTSP/ONVIF) a integraci s rekordéry Hikvision NVR/DVR (jak v režimu Live, tak v režimu archivu přehrávání).

Program byl optimalizován pro stabilitu, plynulý provoz (60 FPS) a minimální spotřebu systémových zdrojů.

---

## Obsah
1. [Popis akcí tlačítka](#1-description-of-button-actions)
2. [Instalace a spuštění](#2-installation-and-launching)
3. [Správa NVR/DVR rekordérů](#3-managing-nvrdvr-recorders)
4. [Živé zobrazení a překryvná oblast zobrazení](#4-live-view-and-viewport-overlays)
5. [Rozvržení obrazovky, předvolby a lišta Toolbar](#5-screen-layouts-presets-and-toolbar)
6. [Panel statistiky systému (Statistika systému)](#6-system-statistics-panel-system-stats)
7. [Playback Archive Player](#7-playback-archive-player)
8. [Stahování nahrávek (Downloader)](#8-downloading-recordings-downloader)
9. [Pokročilá nastavení a přizpůsobení v okně Možnosti](#9-advanced-settings-and-customization-in-options-window)
10. [Klávesové zkratky a ovládání myší](#10-keyboard-shortcuts-and-mouse-controls)
11. [Pořizování snímků a konfigurace cesty](#11-taking-snapshots-and-path-configuration)

---

## 1. Popis akcí tlačítek

Tato část popisuje význam všech grafických ikon a tlačítek používaných v aplikaci.

### Horní lišta nástrojů
* {ICON:quit} **Zavřít okno**: Vyzve k potvrzení a zavře aktivní okno nebo aplikaci.
* {ICON:pin} **Připínáček**: Uzamyká horní panel v rozbaleném stavu nebo umožňuje automatické sbalení.
* {ICON:fullscreen} **Celá obrazovka**: Přepne aktivní okno do režimu celé obrazovky.
* {ICON:minimize} **Minimalizovat**: Minimalizuje okno aplikace na systémovou lištu.
* {ICON:options} **Možnosti**: Otevře nebo zavře okno možností konfigurace (nastavení a záznamníky).
* {ICON:new_window} **Nové okno**: Otevře nové, nezávislé pomocné okno pro toky kamer.
* {ICON:archive} **Archivovat**: Otevře okno archivu přehrávaných nahrávek (časová osa a kalendář).
* {ICON:instructions} **Pokyny**: Otevře tuto uživatelskou příručku a okno technické pomoci.
* {ICON:stats} **Statistiky**: Přepíná posuvný panel statistik systému (CPU, RAM, GPU, Net).
* {ICON:lock} **Zámek mřížky**: Deaktivuje úpravy rozdělení mřížky pro ochranu vašeho aktivního rozvržení.
* {ICON:hamburger} **Další možnosti**: Otevře posuvný panel nástrojů pro pokročilé velikosti dělení, poměry a slučování buněk.

### Překryvná pole zobrazení (fotoaparáty)
* {ICON:snapshot} **Snímek**: Zachytí bezeztrátový obrázek v plném rozlišení a uloží jej jako soubor JPEG.
* {ICON:play} **Archiv kamery**: Spustí okno přehrávání na časové ose pro tuto kameru (15 minut zpět).
* {ICON:grid_1x1} **Vyzkoušet 1:1**: Zobrazuje stream videa v původním nativním rozlišení bez roztahování.
* {ICON:zoom_in} **Interaktivní přiblížení**: Přepíná zvětšení klepnutím a přetažením pro vybranou oblast výběru.
* {ICON:zoom_out} **Resetovat zoom**: Resetuje digitální zvětšení a obnovuje celé zorné pole kamery.
* {ICON:speaker_unmute} **Vypnout zvuk**: Představuje neztlumený zvukový proud; kliknutím na něj ztlumíte stream.
* {ICON:speaker_mute} **Zapnout zvuk**: Představuje ztlumený zvukový proud; kliknutím na něj vypnete zvuk streamu.

### Ovládací prvky okna přehrávání

**Ovládací prvky na horní liště:**
* {ICON:close} **Zavřít**: Zavře okno přehrávače archivu přehrávání.
* {ICON:pin} **Připínáček**: Uzamyká horní panel v rozbaleném stavu nebo umožňuje automatické sbalení.
* {ICON:fullscreen} **Celá obrazovka**: Přepne okno přehrávání do režimu celé obrazovky.
* {ICON:sidebar} **Zobrazit/Skrýt postranní panel**: Přepíná viditelnost levého postranního panelu obsahujícího kamery a rekordéry.
* {ICON:timeline_show} / {ICON:timeline_hide} **Zobrazit/skrýt časovou osu**: Zobrazí nebo skryje spodní panel obsahující časovou osu a ovládací prvky přehrávání.
* {ICON:video_folder} **Video Folder**: Otevře místní systémovou složku obsahující stažené videoklipy.
* {ICON:photo_folder} **Složka snímků**: Otevře místní systémovou složku obsahující zachycené snímky.
* tlačítka mřížky `1x1`, `1x2`, `2x1`, `2x2`: Přepne rozložení zobrazení kamery v okně přehrávání na 1, 2 (vertikální/horizontální) nebo 4 souběžné pohledy.

**Ovládací prvky spodní lišty a časové osy:**
* {ICON:prev_day} **Předchozí den**: Přejde na záznamy z předchozího kalendářního dne.
* {ICON:calendar_select} **Výběr data**: Otevře dialogové okno kalendáře pro výběr konkrétního data pro přehrávání.
* {ICON:next_day} **Další den**: Přejde na nahrávky následujícího kalendářního dne.
* {ICON:today} **Dnes**: Okamžitě přesune zaměření přehrávání na aktuální kalendářní den.
* {ICON:refresh_recordings} **Obnovit nahrávky**: Obnoví a znovu odešle dotaz na dostupné segmenty záznamu ze zařízení.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Předvolby přiblížení časové osy**: Změní měřítko viditelného okna časové osy (na 1 hodinu, 8 hodin nebo 24 hodin) pro vysoce přesnou navigaci.
* {ICON:timeline_center} **Vystředit časovou osu**: Vycentruje zobrazení časové osy přesně kolem aktuálního časového razítka přehrávání.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Rychlost přehrávání**: Upravuje násobitel přehrávání videa (standardní 1x rychlost, 2x zrychlené nebo 4x rychlé přehrávání).
* {ICON:download} **Stáhnout**: Otevře nástroj pro stahování a exportuje definovaný segment videa ze zařízení.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Přeskočit vzad**: Přetočí časové razítko zpět o 60, 45 nebo 15 sekund.
* {ICON:play} / {ICON:pause} **Přehrát / Pozastavit**: Spustí nebo pozastaví přehrávání archivního video streamu.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Přeskočit vpřed**: Posune časové razítko přehrávání o 15, 45 nebo 60 sekund.

**Další diagnostické a obecné ikony:**
* {ICON:calendar} **Kalendář**: Představuje konfiguraci kalendáře/plánování.
* {ICON:clock} **Čas**: Představuje indikátory hodin nebo časového stavu.
* {ICON:zoom} **Zoom**: Představuje konfiguraci měřítka nebo digitálního zoomu.
* {ICON:timeline_toggle} **Přepínání časové osy**: Představuje přepínání nebo obnovení chronologických zobrazení.
* {ICON:trash} **Smazat**: Bezpečně odstraní nakonfigurované vypalovačky nebo rozvržení s potvrzením.
* {ICON:warning} **Varování**: Zobrazuje se v dialogových oknech pro nevratné akce nebo odstranění varování.

---

## 2. Instalace a spuštění

### Instalace na Arch Linux (Pacman)
Chcete-li nainstalovat program z připraveného binárního balíčku, přejděte do adresáře `packaging/arch/` a spusťte:
```bash
sudo pacman -U kvision-2.4.6-2-x86_64.pkg.tar.zst
```
Balíček automaticky nainstaluje program, aktivační soubor `.desktop` a požadované knihovny Hikvision SDK do systémové cesty `/usr/lib/kvision`.

### Ruční kompilace (ze zdrojového kódu)
Pokud chcete program zkompilovat ručně (např. v jiné distribuci Linuxu) namísto použití hotového balíčku:

1. Nainstalujte požadované závislosti sestavení a běhu pomocí správce balíčků. Pro Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Nakonfigurujte projekt pomocí CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Zkompilujte kód:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Nainstalujte aplikaci do systému:
   ```bash
   sudo cmake --install build
   ```

### Spouštění
Program lze spustit ze systémové nabídky nebo zadáním do terminálu:
```bash
kvision
```

### Odstraňování problémů se změnou měřítka systému (KDE Plasma)

Počínaje verzí 2.4.4 KVision automaticky detekuje a správně aplikuje dílčí škálování plochy (např. 125 %, 145 %, 150 %) nakonfigurované v nastavení KDE Plasma vynucením nativních zásad High DPI pass-through v Qt. Uživatelské rozhraní by se nyní mělo správně škálovat ihned po vybalení bez jakéhokoli ručního zásahu.

#### Nativní podpora Wayland

Abyste zajistili co nejlepší škálování a výkon pod Wayland, ujistěte se, že máte na svém systému nainstalovaný volitelný balíček `qt5-wayland`. To umožňuje KVision běžet nativně na Wayland místo toho, aby se vrátil k XWayland.

Pro Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Pro Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Ruční přepsání měřítka (starší/záložní)

Pokud používáte starší verzi, neobvyklou konfiguraci nebo jednoduše chcete ručně vynutit jiný faktor měřítka než zbytek systému, stále můžete přepsat měřítko aplikace pomocí proměnných prostředí.

Chcete-li například vynutit škálování **150 %**, spusťte aplikaci z terminálu pomocí:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Můžete to trvale použít úpravou spouštěče aplikací `kvision.desktop` v editoru nabídky KDE a přidáním těchto proměnných do pole "Proměnné prostředí").*

---

## 3. Správa rekordérů NVR/DVR

Konfigurace připojení k rekordéru Hikvision:
1. Otevřete okno možností a přejděte na kartu **Rekordéry** (ikona serveru).
2. Zadejte přístupové údaje zařízení:
   * **IP adresa**: Síťová adresa rekordéru.
   * **Port**: Síťový port sady SDK (výchozí je `8000`).
   * **Uživatelské jméno**: Uživatelské jméno (např. `admin`).
   * **Heslo**: Heslo pro přístup k diktafonu.
3. Klikněte na **Připojit a objevit** (nebo **Uložit a aktualizovat**).
4. Po úspěšném připojení aplikace automaticky detekuje všechny aktivní kamery (kanály) připojené k NVR/DVR a přidá je do seznamu.
5. Kliknutím na tlačítko **Generate Grid** se automaticky vytvoří rozvržení výřezu (přednastavené) obsahující všechny aktivní kamery z daného NVR v optimálním rozložení mřížky.
6. **Zobrazení seznamů kamer (NvrCamerasWindow)**: Kliknutím na tlačítko ikony monitoru počítače na libovolné kartě rekordéru se otevře vyhrazené okno zobrazující všechny detekované kanály kamer jako interaktivní dlaždice.
7. **Generování náhledů (Generovat náhledy)**: V okně seznamu kamer NVR je k dispozici tlačítko *„Generovat náhledy“*. Klepnutím na něj přikážete aplikaci vytáhnout jednotlivé snímky z dílčího proudu každého kanálu na pozadí a nastavit je jako miniatury pozadí dlaždic. To poskytuje rychlý vizuální náhled každé kamery bez spouštění plného živého vysílání.
8. **Funkce Click-and-Add**: Aplikace nepodporuje přetahování dlaždic (drag and drop) z okna seznamu kamer do hlavní mřížky. Přiřazení kamery se provádí jednoduchým a spolehlivým způsobem: nejprve klikněte levým tlačítkem myši na libovolnou dlaždici výřezu v mřížce hlavní obrazovky a vyberte ji (zvýrazní se jasným okrajem), poté klikněte na zelené tlačítko **"+" (Přiřadit k aktivnímu výřezu)** na dlaždici požadované kamery v okně seznamu kamer NVR. Stream se do tohoto slotu okamžitě načte.
9. **Stav relace SDK (indikátor tečky)**: Vedle IP adresy každého rekordéru v seznamu je barevný stavový bod:
   * **Zelená (PŘIHLÁŠENO)**: Představuje aktivní relaci Hikvision SDK, která je vyžadována pro ovládání PTZ, požadavky na archivaci časové osy a stahování.
   * **Červená (NEPŘIHLÁŠENO)**: Momentálně není vytvořena žádná aktivní relace SDK (např. před prvním požadavkem SDK nebo po ručním/automatickém odhlášení). Upozorňujeme, že živé kanály RTSP z kamery se budou nadále přehrávat nezávisle na stavu relace SDK.
10. **Přejmenování místní kamery**: Na libovolné dlaždici kamery v seznamu kamer NVR klikněte na ikonu **Upravit** (tužka). Otevře se dialogové okno, které vám umožní nastavit vlastní název kamery. Tento název je uložen lokálně a okamžitě se aktualizuje napříč živými hráči, časovou osou a zobrazením dlaždic bez úpravy fyzického zařízení NVR. Kdykoli jej můžete obnovit na výchozí název.
11. **Odebrání rekordéru ze seznamu**: Vedle každého nakonfigurovaného vypalovače v seznamu je červené tlačítko koše. Kliknutím na něj spustíte dvoufázový bezpečnostní protokol navržený tak, aby zabránil náhodnému smazání:
    * **Krok 1 (Potvrzení)**: Zobrazí se dialogové okno s názvem *“Confirm NVR Deletion”* s dotazem, zda jste si jisti, že chcete vymazat rekordér.
    * **Krok 2 (Upozornění)**: Zobrazí se druhý varovný dialog s názvem *„Varování!“* s dotazem, zda jste si absolutně jisti a uvědomujete si, co děláte.
    * **Účinek smazání**: Po přijetí druhého varování se program na pozadí odhlásí z daného NVR, smaže jeho záznam z konfigurace aplikace a **automaticky smaže seznam přednastavených rozvržení**, čímž odstraní všechny dynamické mřížky generované pro toto zařízení NVR.

---

## 4. Živé zobrazení a překrytí výřezů

Hlavní okno programu zobrazuje živý přenos:
* **Mřížka kamery**: Zobrazuje streamy RTSP nebo kanály přímo ze sady Hikvision SDK.
* **Výběr kvality streamu**: Kliknutím pravým tlačítkem na výřez kamery můžete vybrat **Hlavní stream** pro nejvyšší rozlišení nebo **Vedlejší stream** pro snížení zatížení sítě a grafické karty.
* **Přepnutí dvojitého kliknutí na celou obrazovku**: Dvojité kliknutí levým tlačítkem myši na jakýkoli výřez kamery jej okamžitě maximalizuje tak, aby vyplnil celou oblast aktivního okna (celá obrazovka s jedním výřezem). Opětovné poklepání obnoví původní rozložení mřížky s více kamerami.
* **Automatické skrytí horní lišty**: Horní lišta možností (topToolBar) se může automaticky sbalit k hornímu okraji obrazovky, když kurzor myši opustí její oblast (tuto možnost lze konfigurovat v Nastavení -> *„Automaticky sbalit horní lištu“* nebo přímo pomocí ikony špendlíku na horní liště).
* **Více monitorů a pomocná okna**: Můžete otevřít nezávislá přídavná (pomocná) okna pro spouštění různých rozložení mřížky současně na více obrazovkách nebo monitorech. Chcete-li otevřít nové okno, použijte klávesovou zkratku `Ctrl+N` nebo klikněte na tlačítko **"Nové okno"** na horním panelu nástrojů po najetí kurzorem myši. Každé okno lze nakonfigurovat s vlastní velikostí mřížky a vybraným přednastaveným rozložením. Aby byla zajištěna maximální stabilita v konfiguracích s více monitory, všechna okna se spouštějí striktně se středem na primárním displeji v 90 % jeho rozlišení.

### Tlačítka překrytí výřezu
V pravém dolním rohu každé dlaždice/výřezu kamery se po najetí kurzorem myši zobrazí ovládací panel se čtyřmi funkčními ikonami (v závislosti na preferencích uživatelského rozhraní):
1. **Ikona fotoaparátu (snímek)**: Umožňuje pořídit snímek obrazovky ze zdroje fotoaparátu. Snímek se uloží v plném nativním rozlišení streamu přímo z vyrovnávací paměti snímků dekodéru, čímž se zabrání ztrátám v důsledku aktuální velikosti dlaždice výřezu nebo změny rozlišení obrazovky. Úspěšné uložení snímku je potvrzeno blikáním ikony fotoaparátu oranžově (`#ff7a00`) přesně na 1 sekundu.
2. **Ikona Přehrát (Archiv)**: Slouží k rychlému otevření archivu nahrávek. Kliknutím na toto tlačítko automaticky spustíte časovou osu `PlaybackWindow` pro tuto konkrétní kameru a spustíte přehrávání **přesně 15 minut před aktuálním systémovým časem** (pohodlný rychlý posun zpět).
3. **Ikona 1:1 (nativní měřítko)**: Přepíná režim zobrazení videa pixel na pixel. Když je tato možnost povolena, video se neroztáhne ani nezdeformuje, aby vyplnilo hranice dlaždic, ale místo toho se vystředí a zobrazí ve svém původním nativním rozlišení. Když je tento režim aktivní, pozadí tlačítka a text „1:1“ jsou zvýrazněny jasně neonově tyrkysově.
4. **Ikona lupy (interaktivní zoom)**: Umožňuje zvětšit jakoukoli konkrétní oblast kanálu videa:
   * **Aktivace**: Kliknutím na ikonu ji přepnete do aktivního stavu (tyrkysové zvýraznění). Kurzor změní tvar a nápověda říká: *„Kliknutím a přetažením na zdroj fotoaparátu přiblížíte“*.
   * **Operace**: Klikněte levým tlačítkem myši a přetáhněte obdélníkovou oblast výřezu přes živý kanál. Výřez automaticky ořízne a změní velikost vybrané oblasti tak, aby vyplnila celou dlaždici.
     * **Proporcionální zoom**: Při kreslení obdélníku zoomu podržte klávesu **Shift**, aby se výběr uzamkl v poměru stran 16:9, přísně omezený na hranice výřezu.
     * **Posouvání zvětšeného obrazu (Pan Zoom)**: Po přiblížení můžete podržet **prostřední tlačítko myši (rolovací kolečko)** a tažením kurzoru volně posouvat zvětšený pohled kolem zorného pole videa. Funguje to v živém zobrazení, v archivu přehrávání a v minipřehrávači.
   * **Resetovat**: Při přiblížení změní ikona lupy svou ikonu (červený okraj se znaménkem mínus). Kliknutím na něj okamžitě resetujete přiblížení a vrátíte se k plnému zobrazení kamery.

---

## 5. Rozvržení obrazovky, Předvolby a Panel nástrojů

Rozvržení vám umožní uspořádat uspořádání kamer na obrazovce. Na kartě **Předvolby** (ikona hvězdičky) můžete:
* **Vytvořit nové předvolby**: Přidejte své vlastní rozvržení s libovolnou konfigurací sloupců a řádků (např. 2x2, 3x3, 4x4).
* **Přiřadit kamery**: Kliknutím na výřez v rozložení mřížky jej vyberte, poté otevřete okno NVR kamer a klikněte na tlačítko **"+" (Přidat)** na dlaždici požadované kamery. Pozice výřezu můžete také zaměnit pomocí kontextového menu (*„Zamień miejscami”* / *„Zaměnit výřezy”*) ve zdrojovém výřezu a poté kliknutím na cílový výřez.

### Tlačítka horní lišty (horní lišta nástrojů)
Horní posuvný panel nástrojů poskytuje komplexní sadu navigačních a ovládacích tlačítek aplikací:
1. **Zavřít okno (červené tlačítko ✕)**: Zavře aktivní okno. Aby se zabránilo náhodným kliknutím, zachytí událost uzavření a vyzve vás dialogovým oknem k potvrzení ukončení aplikace.
2. **Tlačítko Připnout**: Řídí chování automatického skrývání horního panelu nástrojů. Když kolík směřuje svisle (připnutý stav), lišta je zajištěna na místě a zůstává trvale viditelná. Když se špendlík otočí o -45 stupňů (nepřipnutý stav), lišta se automaticky vysune nahoru, když myš opustí její oblast.
3. **Celá obrazovka (ikona se zelenými šipkami)**: Okamžitě přepne aktivní okno do režimu celé obrazovky a zpět. V režimu celé obrazovky šipky směřují dovnitř (sbalí se) a v režimu okna směřují ven (rozbalí).
4. **Minimalizovat (Ikona minimalizace azurové)**: Minimalizuje okno aplikace na hlavní panel. Jeho obnovením se okno vrátí do jeho přesného předchozího stavu (např. maximalizované nebo celá obrazovka).
5. **⚙️ MOŽNOSTI (OPCJE)**: Přepíná okno možností konfigurace. Pokud je okno již otevřené, kliknutím na toto tlačítko jej zavřete.
6. **📺 NOVÉ OKNO (NYNÍ OKNO)**: Otevírá nové, nezávislé a plně konfigurovatelné `Auxiliary Window`, které je ideální pro rozšíření rozvržení vašich kamer na více monitorů.
7. **ARCHIV**: Otevře prázdný `PlaybackWindow` (přehrávač nahrávek) s aktivní časovou osou a kalendářem, což umožňuje ruční výběr kanálů streamu a kamery z libovolného nakonfigurovaného NVR prostřednictvím seznamu na postranním panelu.
8. **NÁVOD (INSTRUKCJA)**: Otevře okno této příručky a načte kompletní uživatelskou dokumentaci v angličtině nebo polštině v závislosti na vašem aktivním národním prostředí.
9. **📊 Přepínač STATS (STATYSTYKI)**: Přepínačem vysunete monitorovací panel Statistiky systému z levého okraje obrazovky.
10. **Přepínač uzamčení mřížky (zámek)**: Přepínač, který po zapnutí (zvýrazněný jasně oranžovou barvou) deaktivuje akce změny velikosti mřížky na sousedních tlačítkách mřížky a chrání tak rozložení aktivní kamery před náhodnými změnami.
11. **Výběry velikosti mřížky (od 1x1 do 9x9)**: Řada devíti tlačítek, která vám umožní okamžitě definovat řádkovou a sloupcovou strukturu vašeho výřezu (od pohledu jedné kamery 1x1 až po 81 současných kamer v rozložení 9x9). Aktuálně aktivní velikost se zvýrazní jasně oranžovou barvou.
12. **Další možnosti (Hamburger Menu se třemi řádky)**: Tlačítko otevírající posuvný panel nástrojů `Layout & Grid Tools` pro pokročilé ladění mřížky, úpravy geometrie a možnosti ladění (podrobnosti níže).
13. **Tlačítka předvolby/zobrazení**: Dynamicky vykreslená tlačítka na pravé straně panelu nástrojů představující vaše nakonfigurovaná a viditelná přednastavená rozvržení (např. *📹 NVR*, *Zobrazení 1* atd.). Klepnutím na tlačítko okamžitě přepnete mřížku. Aktivní pohled se zvýrazňuje jasně světle tyrkysovou barvou.

### Pokročilé přizpůsobení a poměry mřížky (nástroje rozvržení a mřížky)
Otevřením nabídky Hamburger (Další možnosti) se zobrazí specializovaný panel nástrojů pro rozvržení. Chcete-li aktivovat jeho ovládací prvky:
1. **Odemknout panel nástrojů**: Přepněte přepínač "Odemknout panel nástrojů" úplně nahoře. Jedná se o explicitní bezpečnostní opatření, které má zabránit náhodným změnám složitých rozvržení.
2. **Vlastní rozdělení oken (F2 nebo stisknutí a podržení)**: Panel nástrojů zobrazuje tlačítka pro rozdělení mřížky od 1x1 do 9x9. Mimořádně pokročilou funkcí je možnost **přepisovat a upravovat velikosti oddílů**. Pokud klepnete a podržíte libovolné tlačítko mřížky levým tlačítkem myši (nebo jej zaostříte a stisknete **F2**), zobrazí se textové pole. Můžete zadat libovolné vlastní nebo asymetrické dělení (například `2x3`, `1x4` atd.) a stisknout Enter. Tlačítko je okamžitě přeprogramováno a kliknutím na něj použijete vlastní rozvržení na hlavní výřez.
3. **Poměry geometrie**: Umožňuje vynutit zobrazení mřížky na konkrétní poměry stran:
   * **Poměr stran 16:9**: Uzamyká a mění velikost kontejneru mřížky na širokoúhlý formát 16:9 (standard pro moderní IP kamery).
   * **Poměr stran 4:3**: Přizpůsobí mřížku na tradiční poměr stran 4:3 (běžné u starších analogových/IP kamer).
4. **Operace mřížky (Sloučit zvýrazněné buňky)**: Přístup k funkci asymetrického slučování buněk (podrobnosti v části 9.2).

---

## 6. Panel statistiky systému (Statistika systému)

Tento panel, který se vysune z levého okraje obrazovky živého náhledu, sleduje stav počítače a zátěž generovanou aplikací:
* **Monitorované parametry**:
  * **CPU / RAM**: Využití hlavního procesoru (v % všech jader) a paměti RAM používané přímo procesem `kvision` a souvisejícími podprocesy stahování.
  * **GPU / VRAM**: Využití jádra grafické karty (v %) a množství grafické paměti VRAM obsazené vykreslováním a hardwarovým dekódováním (podporuje úplný seznam procesů GPU pomocí analyzátoru XML z `nvidia-smi`).
  * **NETWORK (Net)**: Skutečná přenosová rychlost stahování aplikace ze všech aktivních živých přehrávačů, archivních přehrávačů a procesů stahování záznamů.
* **Multithreading (bez zasekávání)**: Shromažďování dat o procesech a GPU běží na samostatném systémovém vláknu (`StatsWorker`). To zabraňuje jakémukoli malému zadrhávání při vykreslování videa (žádné poklesy snímků).
* **Funkce připnutí**: Kliknutím na tlačítko **"Připnout"** (ikona špendlíku) uzamknete panel v rozbaleném stavu.
* **Estetika**: Grafy mají jasné, neonově zelené okraje, přechodovou výplň pod křivkou grafu a vyváženou 35% průhlednost pozadí pro zajištění čitelnosti textu.

---

## 7. Přehrávání Archiv Player

Dostupné po kliknutí na ikonu hodin/přehrávání vedle konkrétní kamery nebo rekordéru. Umožňuje současné prohlížení archivovaných záznamů z více kamer Hikvision v plné časové synchronizaci.

### Časová osa a ovládací prvky:
* **Rychlý start (15 minut zpět)**: Při otevření archivu z živého zobrazení se přehrávač automaticky spustí od okamžiku, který nastane **přesně 15 minut před aktuálním systémovým časem** (místo spuštění o půlnoci). To umožňuje okamžité zobrazení události, která se právě stala.
* **Navigace**: Časovou osu lze posouvat doleva a doprava přetažením levého tlačítka myši.
* **Zvětšení (změna měřítka)**: Měřítko časové osy můžete plynule měnit pomocí rolovacího kolečka myši (nebo tlačítek přiblížení) – od zobrazení celého dne až po přesné zobrazení s přesností 10 minut.
* **Zkratky rychlého přiblížení**: Spodní ovládací panel obsahuje vyhrazená tlačítka s kruhovými ikonami pro okamžité přizpůsobení zobrazení časové osy:
  * **Ikona „1h“**: Přiblíží časovou osu pro podrobnou kontrolu v rozpětí 1 hodiny.
  * **Ikona „8h“**: Přiblíží časovou osu tak, aby se zobrazilo 8hodinové rozpětí.
  * **Ikona „24h“**: Obnoví přiblížení, aby se na jednu obrazovku vešel celý 24hodinový den.
  * **Ikona Střed (cíl)**: Okamžitě vycentruje časovou osu tak, aby byl červený indikátor přehrávání přesně uprostřed obrazovky (nahrazuje staré textové tlačítko).
* **Navigace podle data (kalendář a dny)**: Ovládací prvky vedle zobrazeného data umožňují rychlé skoky:
  * Tlačítka **„<“ (Předchozí den)** a **„>“ (Další den)**: Umožňují okamžitý skok o 24 hodin zpět nebo vpřed, aniž byste museli otevírat dialogové okno kalendáře.
  * **Ikona kalendáře**: Otevře vyskakovací okno kalendáře pro výběr konkrétního data.
  * **Ikona Obnovit**: Vynutí nové vyhledávání nahrávek. Kliknutím na něj vymažete místní mezipaměť segmentů dostupnosti záznamu pro všechny aktivní kanály a odešlete nové dotazy do NVR, což je velmi užitečné pro načtení souborů zaznamenaných jen před několika okamžiky (nahrazením starého textového tlačítka).
  * **Ikona Dnes (dnešní datum/číslo)**: Okamžitý skok zpět na aktuální den (nahrazuje staré textové tlačítko).
* **Zkratky rychlosti přehrávání**:
  * **Ikony „1x“, „2x“ a „4x“**: Okamžitě změňte multiplikátor rychlosti přehrávání.
* **Tlačítka skoků na videorekordéru**:
  * **Ikony „15“, „45“ a „60“ s kruhovými šipkami**: Umožňují rychlé přeskakování vzad nebo vpřed o zadaný počet sekund.
* **Proužky dostupnosti záznamu**: Barevné pruhy představující nalezené segmenty videa na disku rekordéru jsou vykresleny pod časovou osou. Systém ukládání do mezipaměti zabraňuje jejich blikání při přetahování.
* **Automatické sledování (sledování indikátoru)**: Indikátor přehrávání (svislá červená čára) je neustále monitorován. Pokud se indikátor dostane mimo viditelný rozsah časové osy, zobrazení se automaticky posune do středu. Tato možnost je inteligentně uzamčena během ručního přetažení indikátoru uživatelem.

### Boční panel fotoaparátu v okně přehrávání
Svislý postranní seznam na pravém okraji přehrávače uvádí všechny nakonfigurované NVR a jejich kanály kamer:
* **Přepínání kanálů**: Kliknutím na libovolný kanál kamery v seznamu se kanál přidá jako aktivní slot pro přehrávání na časové ose (vytvoří přehrávač videa). Dalším kliknutím kanál odstraníte.
* **Kontextová nabídka kanálu**: Kliknutím pravým tlačítkem na aktivní video slot v mřížce přehrávání se otevře nabídka:
  * Přepnout kvalitu videa (Hlavní tok / Vedlejší tok).
  * Zavřete/odeberte aktivní přehrávač z přehrávání archivu.

---

## 8. Stahování nahrávek (Downloader)

Z okna Playback Archive si můžete stáhnout vybrané segmenty nahrávek přímo na disk vašeho počítače jako soubory MP4:
1. Klikněte na ikonu stahování (šipka dolů) vedle vybrané kamery.
2. Vyberte časový rozsah (začátek a konec záznamu).
3. Vyberte umístění pro uložení cílového souboru.
4. Klikněte na **Stáhnout**.

### Pokročilé funkce stahování:
* **Sekvenční stahování segmentů (části 1 GB)**: Program automaticky rozdělí váš dotaz na časové období na segmenty fyzických souborů (zhruba 1 GB každý na jednotce NVR) a stáhne a převede je jeden po druhém (pomocí dočasných souborů `.pspart`, které jsou převedeny přímo do formátu `.mp4`). To zajišťuje vysoce stabilní stahování dlouhých rozsahů bez přetečení paměti nebo zablokování převodu FFmpeg.
* **Vizualizace celkového průběhu**: Ukazatel průběhu (jasná modrozelená barva) zobrazuje celkový průběh stahování kamery ve všech segmentech. Stavový text překrývající indikátor průběhu zobrazuje aktuální část a procenta, např. `Downloading part 1 of 3... 45% (Overall: 15%)`, s obrysovým stylem, který zaručuje čitelnost na jakémkoli pozadí.
* **Čištění IP názvu souboru**: Názvy souborů videa (a živé/archivované snímky) jsou automaticky odstraněny z IP adres NVR/DVR, aby byly čisté a čitelné pro člověka (např. `4_Wejscie_glowne_2026-06-15.mp4` namísto `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Pokročilá nastavení a přizpůsobení v okně Možnosti

Okno možností a konfigurace (`SideBar`) se skládá ze šesti vyhrazených záložek:

### 1. Podrobnosti výřezu (ikona monitoru)
Zobrazí pokročilé parametry aktuálně vybrané dlaždice mřížky. Umožňuje:
* Zadejte vlastní **adresu URL primárního streamu** (RTSP/ONVIF) a **adresu URL sekundární zálohy** pro ruční konfigurace.
* Přepnout ztlumení/zrušení ztlumení zvukového kanálu vybraného zdroje kamery.
* Do textového pole **Přepsání možností FFmpeg** zadejte pokročilé přepisy dekodéru.
> [!TIP]
> Pro nejrychlejší připojení streamu a maximální stabilitu přes RTSP jsou doporučené parametry:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Nástroje rozvržení a mřížky (ikona posuvníků)
Pokročilé možnosti přizpůsobení mřížky obrazovky:
* Rychlé přepnutí do režimu celé obrazovky.
* **Asymetrické slučování buněk (sloučit zvýrazněné buňky)**: Vysoce pokročilý editor rozvržení. Podržte klávesu **Ctrl** nebo **Shift** a kliknutím vyberte více sousedních dlaždic na mřížce, nebo použijte klávesnici tak, že podržíte klávesu **Shift** a procházejte pomocí **kláves se šipkami** a poté kliknutím na "Sloučit zvýrazněné buňky" je spojíte do jednoho většího výřezu. To vám umožňuje vytvářet plně vlastní návrhy asymetrických mřížek (např. jeden obrovský panel kamery s menšími kanály, které jej obklopují).

### 3. Záznamníky (ikona serveru)
Kompletní konfigurační manažer pro připojení k Hikvision NVR/DVR zařízením (podrobně popsáno v části 3).

### 4. Předvolby (ikona hvězdičky)
Správce pro vaše uložená rozvržení mřížky a přiřazení kamer. Umožňuje vytvářet prázdné šablony mřížky, měnit jejich pořadí, přepínat jejich viditelnost v horní liště (přes přepínač "Viditelné") nebo je aktivovat v aktuálním okně.

### 5. Nastavení (ikona ozubeného kola)
Umožňuje upravit globální nastavení aplikace:
* **Povolit spuštění více instancí**: Zaškrtnutím tohoto políčka umožníte spouštění více paralelních kopií procesu KVision (ve výchozím nastavení omezuje spuštění na jednu aktivní instanci).
* **Nastavení automatického sbalení**: Přizpůsobí časování posuvné animace pro horní panel a panel statistik.
* **Povolit záměnu výřezů**: Zaškrtávací políčko *„Povolit záměnu výřezů“* umožňuje za běhu měnit uspořádání pozic kamer na mřížce (Klikněte pravým tlačítkem na zdrojovou dlaždici -> Zvolte „Zaměnit výřezy“ -> Klikněte levým tlačítkem na cílovou dlaždici).
* **Oprávnění po kliknutí pravým tlačítkem**: Přepne na zamknutí/odemknutí interaktivních ovládacích prvků v kontextové nabídce po kliknutí pravým tlačítkem (Povolit kontextovou nabídku, Povolit výměnu výřezů, Povolit možnost „Odebrat kameru“, Povolit změnu nastavení výřezu, Povolit výběr kvality hlavního/podřízeného streamu).
* **Automatické ztlumení**: Automaticky zruší ztlumení zvukového proudu aktivního výřezu při přechodu do režimu celé obrazovky.
* **Skrýt kurzor v režimu celé obrazovky**: Zaškrtávací políčko *„Skrýt kurzor v režimu celé obrazovky“* automaticky skryje kurzor myši po krátké nečinnosti během zobrazení na celou obrazovku, aby bylo zajištěno zobrazení bez překážek.
* **Výběr jazyka**: Okamžitě přepíná překlad rozhraní (výchozí nastavení systému, polština, angličtina).
* **Předvolby uživatelského rozhraní**: Skrytí/zobrazení štítků stavu výřezu nebo odznaků ovládacích prvků (jako je automatické skrytí překryvných prvků v pravém dolním rohu dlaždic, pokud nenajdete kurzor).
* **Výchozí možnosti FFmpeg & Hromadná aktualizace**: Umožňuje konfiguraci globálních možností FFmpeg aplikovaných na nové výřezy (doporučeno: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[DOPORUČENÍ]** Pokud migrujete ze starší verze KVision (před verzí 2.4.5), důrazně se doporučuje změnit `-analyzeduration 0` na `-analyzeduration 100000` v globálním nastavení a kliknout na „Aktualizovat všechny kamery“. Nastavení `0` na streamech bez zvukové stopy způsobí zpoždění při přepínání, protože FFmpeg zablokuje napevno zakódovaný 5sekundový časový limit čekání na zvukové pakety. Nastavení velmi nízké hodnoty (např. 100 000 mikrosekund = 0,1 s) tento problém zcela vyřeší při zachování okamžitého přepínání.
  * **Tlačítko Aktualizovat všechny kamery**: Tlačítko *„Zaktualizuj wszystkie kamery“* aplikuje tyto globální možnosti na všechny nakonfigurované výřezy.
  * **Příznaky nízké latence (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` deaktivuje ukládání paketů interního demuxeru, aby se eliminovalo zpoždění streamování v průběhu času, ale může způsobit zasekávání, pokud je vaše síťové připojení ke kameře nestabilní.
    * `-flags low_delay` říká dekodéru, aby vydal snímky okamžitě, ale může způsobit krátké artefakty/rozmazání v tocích, které používají B-snímky při rychlých pohybech.
  * **Přepsat zaškrtávací políčko**: Konkrétní výřezy můžete vyloučit z globálních aktualizací nebo dynamických výchozích hodnot zaškrtnutím možnosti **"Není uwzględniaj zmian w globalnych ustawieniach FFMpeg"** v jednotlivém dialogu Nastavení výřezu. Užitečné pro řešení problémů se zasekáváním fotoaparátů.


### 6. Protokol změn (ikona hodin/dokumentu)
Představuje interaktivní časovou osu zobrazující kompletní historii vydání, aktualizace, opravy chyb a přidané funkce KVision, což zajišťuje přímý přístup k podrobnostem o aktualizacích programu.

---

## 10. Klávesové zkratky a ovládání myší

### Klávesové zkratky:
| Klávesa / zkratka | Akce |
|---|---|
| **F** / **F11** | Přepnout režim celé obrazovky. |
| **M** | Ztlumit / zapnout zvuk (funguje pro aktivní kameru se zvukem). |
| **Vesmír** | Přehrát / Pozastavit přehrávání v okně Archiv přehrávání. |
| **Alt + 1** až **Alt + 9** | Rychlé přepnutí na předvolbu/rozvržení na indexech 1 až 9. |
| **Alt + šipka doleva** | Rychlé přepnutí na předchozí předvolbu/rozvržení v kolekci. |
| **Alt + šipka vpravo** | Rychlé přepnutí na další předvolbu/rozvržení v kolekci. |
| **Šipky (nahoru/dolů/vlevo/vpravo)** | Procházejte a přesouvejte aktivní zaostření/výběr mezi výřezy kamery. |
| **Shift + Šipky** | Vyberte více sousedních výřezů kamery současně (používá se pro slučování buněk atd.). |
| **Ctrl + N** | Otevřete nové, nezávislé pomocné okno. |
| **+** / **-** | Přiblížit / Oddálit (kamery Hikvision s podporou PTZ). |
| **Shift** (přetáhněte rámeček) | Vynutit uzamčení výběru výřezu v poměru stran 16:9 během interaktivního přiblížení. |
| **Esc** | Ukončení režimu celé obrazovky / zrušení aktivního výběru výřezu. |

### Interakce s myší:
* **Levé tlačítko myši**:
  * **Dvojitým kliknutím** na výřez kamery v mřížce jej maximalizujete na celou obrazovku. Dalším dvojitým kliknutím obnovíte zobrazení mřížky.
  * Přetažením časové osy v okně Přehrávání procházejte.
* **Střední tlačítko myši (kliknutí a přetažení rolovacího kolečka)**:
  * Přetažením můžete posouvat a posouvat digitálně přiblížený/zvětšený obraz po zorném poli výřezu (funguje v živém, archivním a minipřehrávači).
* **Pravé tlačítko myši (kontextová nabídka)**:
  * Otevře nabídku rychlého nastavení pro vybraný výřez (umožňuje odstranění kamery z mřížky, přepínání mezi hlavními/vedlejšími proudy nebo přístup k jednotlivým parametrům zobrazení).
* **Rolovací kolečko myši**:
  * Upraví měřítko (přiblížení) časové osy v přehrávači archivu přehrávání.

---

## 11. Pořizování snímků a konfigurace cesty

Aplikace umožňuje rychle pořizovat vysoce kvalitní snímky z libovolného výřezu kamery v režimu živého náhledu i režimu přehrávání archivu.

### Pořizování snímků:
1. V pravém dolním rohu každého výřezu je k dispozici překryvné tlačítko ikony kamery (podrobnosti v části 4).
2. Klepnutím na ikonu fotoaparátu snímek zachytíte a uložíte jako obrázek JPEG (kvalita 98 ​​– prakticky bezeztrátová).
3. Úspěšné zachycení je potvrzeno blikající ikonou fotoaparátu oranžově (`#ff7a00`) přesně na 1 sekundu.
4. **Plné rozlišení**: V režimu Playback Archive se snímky ukládají v plném nativním rozlišení zdroje přímo z vyrovnávací paměti snímků dekodéru, bez ohledu na velikost aktivního výřezu na obrazovce nebo měřítko zobrazení.

### Ukládání konfigurací cest:
1. Přejděte na kartu **Nastavení** (ikona ozubeného kola v okně možností).
2. V části **Ukládání** ("Zapis") můžete nakonfigurovat výchozí cesty:
   * **Výchozí cesta ke snímkům**: Složka, do které budou snímky uloženy (výchozí hodnota je `~/Obrazy/CCTV`).
   * **Výchozí cesta k nahrávkám**: Složka, do které se budou ukládat stažená videa MP4 (výchozí hodnota je `~/Wideo/CCTV`).
3. Kliknutím na tlačítko prohlížeče `...` otevřete nativní výběr složek vašeho operačního systému (Breeze v KDE).
4. **Chování tlačítka prohlížeče**: Nástroj pro výběr adresáře se otevře přesně na cestě zadané do textového pole (pokud existuje). Pokud je pole prázdné, neplatné nebo ukazuje na složku, ke které nemáte přístup, dialogové okno se vrátí zpět a otevře se ve vašem domovském adresáři (`~/`).

### Nastavení uživatelského rozhraní (UI):
1. Přejděte na kartu **Nastavení** (ikona ozubeného kola v okně možností) nebo otevřete okno **Možnosti** ("Opcje").
2. V sekci **Nastavení uživatelského rozhraní** si můžete přizpůsobit viditelnost prvků překrývajících se na kafelki/viewportech kamery:
   * **Zobrazit stav kanálu v levém horním rohu výřezu** (výchozí povoleno) – Zobrazuje informace o načítání streamu, přehrávání a stavu připojení.
   * **Zobrazit informace o kameře v levém dolním rohu výřezu** (výchozí povoleno) – Zobrazí název kamery získaný z rekordéru Hikvision.
   * **Zobrazit ovládací ikony v pravém dolním rohu výřezu pouze při najetí myší** (výchozí povoleno) – Automaticky skryje panel ovládacích tlačítek (snímek, archiv, 1:1 pixel-to-pixel, oblast zoom), když je kurzor myši mimo daný výřez kamery. Ikony se objeví okamžitě, jakmile najedete myší na výřez (není nutné klikat) a zmizí při odchodu, čímž se maximalizuje viditelnost toků z vašich kamer.
   * **Zobrazit informační pole pouze při najetí myší** (výchozí vypnuto) – Analogická možnost, která skryje stav vlevo nahoře a název v levém dolním rohu výřezů a zobrazí zcela čistý proud kamery, pokud kurzor nepřejedete na konkrétní dlaždici kamery.
