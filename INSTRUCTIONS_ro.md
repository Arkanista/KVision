# Manual de utilizare pentru KVision

> [!NOTĂ]
> Acest manual de instrucțiuni a fost tradus și formatat automat cu ajutorul Inteligenței Artificiale (AI).

**KVision** este o aplicație desktop avansată de clasă VMS (Video Management System) concepută pentru vizionarea simultană a fluxurilor video live (RTSP/ONVIF) și integrarea cu înregistratoarele Hikvision NVR/DVR (atât în ​​modul Live, cât și în modul arhivare Redare).

Programul a fost optimizat pentru stabilitate, funcționare lină (60 FPS) și consum minim de resurse de sistem.

---

## Cuprins
1. [Descrierea acțiunilor butoanelor](#1-description-of-button-actions)
2. [Instalare și lansare](#2-installation-and-launching)
3. [Gestionarea înregistratoarelor NVR/DVR](#3-managing-nvrdvr-recorders)
4. [Suprapuneri Live View și Viewport](#4-live-view-and-viewport-overlays)
5. [Aspecte de ecran, presetări și bară de instrumente](#5-screen-layouts-presets-and-toolbar)
6. [Panoul de statistici de sistem (statistici de sistem)](#6-system-statistics-panel-system-stats)
7. [Player arhivă redare](#7-playback-archive-player)
8. [Descărcare înregistrări (Descărcare)](#8-downloading-recordings-downloader)
9. [Setări avansate și personalizare în fereastra Opțiuni](#9-advanced-settings-and-customization-in-options-window)
10. [Comenzi rapide de la tastatură și comenzi ale mouse-ului](#10-keyboard-shortcuts-and-mouse-controls)
11. [Efectuarea de instantanee și configurarea căii](#11-taking-snapshots-and-path-configuration)

---

## 1. Descrierea acțiunilor butoanelor

Această secțiune descrie semnificația tuturor pictogramelor și butoanelor grafice utilizate în aplicație.

### Bara de instrumente de sus
* {ICON:quit} **Închide fereastra**: solicită confirmare și închide fereastra sau aplicația activă.
* {ICON:pin} **Bară de fixare**: blochează bara de sus într-o stare extinsă sau activează restrângerea automată.
* {ICON:fullscreen} **Ecran complet**: comută fereastra activă în modul ecran complet.
* {ICON:minimize} **Minimizează**: Minimizează fereastra aplicației în bara de activități a sistemului.
* {ICON:options} **Opțiuni**: deschide sau închide fereastra cu opțiuni de configurare (setări și recordere).
* {ICON:new_window} **Fereastră nouă**: deschide o fereastră auxiliară nouă, independentă pentru fluxurile camerei.
* {ICON:archive} **Arhivă**: Deschide fereastra de arhivă a înregistrărilor de redare (cronologie și calendar).
* {ICON:instructions} **Instrucțiuni**: deschide acest manual de utilizare și fereastra de asistență tehnică.
* {ICON:stats} **Statistici**: Comută panoul glisant cu statistici ale sistemului (CPU, RAM, GPU, Net).
* {ICON:lock} **Blocarea rețelei**: dezactivează ajustările diviziunii rețelei pentru a vă proteja aspectul activ.
* {ICON:hamburger} **Mai multe opțiuni**: deschide caseta de instrumente glisantă pentru dimensiuni avansate de diviziune, rapoarte și îmbinarea celulelor.

### Suprapuneri pentru fereastra de vizualizare (Camere)
* {ICON:snapshot} **Instantaneu**: captează o imagine cu rezoluție completă fără pierderi și o salvează ca fișier JPEG.
* {ICON:play} **Arhiva camerei**: lansează fereastra de redare cronologică pentru această cameră (15 minute înapoi).
* {ICON:quick_play} **Redare rapidă (miniplayer)**: inițiază o redare a arhivei în fereastra de vizualizare a ultimelor 30 de minute, permițându-vă să revizuiți rapid înregistrările recente direct în panoul camerei fără a părăsi vizualizarea live.
* {ICON:grid_1x1} **Încercați 1:1**: afișează fluxul video în rezoluția sa originală, nativă, fără întindere.
* {ICON:zoom_in} **Mărire interactiv**: Comută mărirea prin clic și trage pentru o regiune selectată.
* {ICON:zoom_out} **Resetează zoom**: resetează mărirea digitală și restabilește câmpul vizual complet al camerei.
* {ICON:speaker_unmute} **Dezactivați sunetul**: reprezintă un flux audio activ; făcând clic pe acesta dezactivează fluxul.
* {ICON:speaker_mute} **Activează sunetul**: reprezintă un flux audio dezactivat; făcând clic pe acesta, se activează sunetul fluxului.

### Comenzi pentru fereastra de redare

**Controale barei de sus:**
* {ICON:close} **Închidere**: închide fereastra de redare a arhivei playerului.
* {ICON:pin} **Bară de fixare**: blochează bara de sus într-o stare extinsă sau activează restrângerea automată.
* {ICON:fullscreen} **Ecran complet**: comută fereastra de redare în modul ecran complet.
* {ICON:sidebar} **Afișează/Ascunde bara laterală**: Comută vizibilitatea barei laterale din stânga care conține camere și recordere.
* {ICON:timeline_show} / {ICON:timeline_hide} **Afișează/Ascunde cronologia**: afișează sau ascunde panoul de jos care conține cronologia și comenzile de redare.
* {ICON:video_folder} **Dosar video**: Deschide folderul de sistem local care conține clipuri video descărcate.
* {ICON:photo_folder} **Snapshot Folder**: Deschide folderul de sistem local care conține instantanee capturate.
* butoane grilă `1x1`, `1x2`, `2x1`, `2x2`: Comută aspectul de afișare a camerei din fereastra de redare la 1, 2 (vertical/orizontal) sau 4 vizualizări simultane.

**Bara de jos și comenzi pentru cronologie:**
* {ICON:prev_day} **Ziua anterioară**: navighează la înregistrările din ziua calendaristică anterioară.
* {ICON:calendar_select} **Selector de dată**: deschide un dialog de calendar pentru a selecta o anumită dată pentru redare.
* {ICON:next_day} **Ziua următoare**: navighează la înregistrările din următoarea zi calendaristică.
* {ICON:today} **Astăzi**: mută instantaneu focalizarea redării către ziua calendaristică curentă.
* {ICON:refresh_recordings} **Actualizează înregistrările**: reîmprospătează și interogează din nou segmentele de înregistrare disponibile de pe dispozitiv.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Presetări pentru zoom cronologie**: Scală fereastra vizibilă a cronologiei (la 1 oră, 8 ore sau 24 de ore) pentru o navigare de înaltă precizie.
* {ICON:timeline_center} **Centrare cronologie**: centrează vizualizarea cronologiei exact în jurul marcajului de timp curent al redării.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Viteza de redare**: ajustează multiplicatorul de redare video (viteză standard de 1x, 2x accelerată sau 4x redare rapidă).
* {ICON:download} **Descărcare**: deschide instrumentul de descărcare pentru a exporta un segment video definit de pe dispozitiv.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Sări înapoi**: Derulează înapoi marcajul de timp al redării cu 60, 45 sau 15 secunde.
* {ICON:play} / {ICON:pause} **Redare/Pauză**: inițiază sau întrerupe redarea fluxului video arhivat.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Sări înainte**: avansează marcajul de timp al redării cu 15, 45 sau 60 de secunde.

**Alte pictograme de diagnostic și general:**
* {ICON:calendar} **Calendar**: reprezintă configurațiile de calendar/programare.
* {ICON:clock} **Ora**: reprezintă ceasul sau indicatorii de stare temporală.
* {ICON:zoom} **Zoom**: reprezintă configurații de scalare sau zoom digital.
* {ICON:timeline_toggle} **Comutare cronologie**: reprezintă comutarea sau reîmprospătarea vizualizărilor cronologice.
* {ICON:trash} **Șterge**: elimină în siguranță recorderele sau aspectele configurate cu confirmare.
* {ICON:warning} **Avertisment**: afișat în casetele de dialog pentru acțiuni ireversibile sau avertismente de ștergere.

---

## 2. Instalare și Lansare

### Instalare pe Arch Linux (Pacman)
Pentru a instala programul din pachetul binar pregătit, mergeți la directorul `packaging/arch/` și rulați:
```bash
sudo pacman -U kvision-2.6.0-1-x86_64.pkg.tar.zst
```
Pachetul va instala automat programul, fișierul de activare `.desktop` și bibliotecile Hikvision SDK necesare în calea de sistem `/usr/lib/kvision`.

### Compilare manuală (din codul sursă)
Dacă doriți să compilați programul manual (de exemplu, pe o altă distribuție Linux) în loc să utilizați pachetul gata făcut:

1. Instalați dependențele necesare de construcție și de rulare folosind managerul de pachete. Pentru Arch Linux / CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Configurați proiectul folosind CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Compilați codul:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Instalați aplicația în sistem:
   ```bash
   sudo cmake --install build
   ```

### Lansare
Programul poate fi lansat din meniul de sistem sau tastând în terminal:
```bash
kvision
```

### Depanarea la scalarea sistemului (KDE Plasma)

Începând cu versiunea 2.4.4, KVision detectează automat și aplică corect scalarea fracționată a desktopului (de exemplu, 125%, 145%, 150%) configurată în setările KDE Plasma prin aplicarea politicilor native de transmitere a DPI ridicate în Qt. Interfața cu utilizatorul ar trebui acum să se scaleze corect, fără nicio intervenție manuală.

#### Asistență nativă Wayland

Pentru a asigura cea mai bună experiență de scalare și performanță sub Wayland, asigurați-vă că aveți pachetul opțional `qt5-wayland` instalat pe sistemul dvs. Acest lucru permite KVision să ruleze nativ pe Wayland în loc să se întoarcă la XWayland.

Pentru Arch Linux / Manjaro / CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Pentru Debian / Ubuntu / Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Modificare manuală de scalare (moștenire/Fallback)

Dacă rulați o versiune mai veche, o configurație neobișnuită sau pur și simplu doriți să forțați manual un factor de scalare diferit de restul sistemului, puteți în continuare să suprascrieți scalarea aplicației folosind variabile de mediu.

De exemplu, pentru a forța scalarea **150%**, lansați aplicația de pe terminal cu:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Puteți aplica permanent acest lucru editând lansatorul de aplicații `kvision.desktop` în editorul de meniu KDE și adăugând aceste variabile în câmpul „Variabile de mediu”).*

---

## 3. Gestionarea înregistratoarelor NVR/DVR

Pentru a configura conexiunea la un recorder Hikvision:
1. Deschideți fereastra cu opțiuni și accesați fila **Înregistratoare** (pictograma server).
2. Introduceți detaliile de acces la dispozitiv:
   * **Adresă IP**: adresa de rețea a reportofonului.
   * **Port**: portul de rețea SDK (implicit este `8000`).
   * **Nume de utilizator**: nume de utilizator (de ex., `admin`).
   * **Parolă**: Parolă pentru accesarea înregistratorului.
3. Faceți clic pe **Conectați și descoperiți** (sau pe **Salvați și actualizați**).
4. După conectarea cu succes, aplicația va detecta automat toate camerele (canalele) active conectate la NVR/DVR și le va adăuga la listă.
5. Făcând clic pe butonul **Generează grilă**, se va crea automat un aspect al ferestrei de vizualizare (prestat) care conține toate camerele active din acel NVR într-un aspect optim al grilei.
6. **Afișarea listelor camerelor (NvrCamerasWindow)**: făcând clic pe butonul pictogramei monitorului computerului de pe cardul oricărui reportofon, se deschide o fereastră dedicată care arată toate canalele camerei detectate ca plăci interactive.
7. **Generarea miniaturilor (Generează miniaturi)**: în fereastra cu listă de camere NVR, este disponibil un buton *„Generează miniaturi”*. Făcând clic pe el, aplicația comandă să extragă cadre unice din fluxul secundar al fiecărui canal în fundal, setându-le ca miniaturi de fundal de tigla. Aceasta oferă o previzualizare vizuală rapidă a fiecărei camere fără a lansa fluxuri live complete.
8. **Funcție de clic și adăugare**: aplicația nu acceptă tragerea plăcilor (glisare și plasare) din fereastra listei camerei în grila principală. Atribuirea camerei se face într-un mod simplu și fiabil: mai întâi faceți clic stânga pe orice panou de vizualizare din grila ecranului principal pentru a o selecta (se va evidenția cu un chenar strălucitor), apoi faceți clic pe butonul verde **„+” (Atribuire ferestrei de vizualizare active)** de pe panoul dorit al camerei din fereastra cu listă de camere NVR. Fluxul se va încărca instantaneu în acel slot.
9. **Starea sesiunii SDK (indicator punct)**: lângă IP-ul fiecărui recorder din listă, există un punct colorat de stare:
   * **Verde (CONECTAT)**: reprezintă o sesiune activă Hikvision SDK, care este necesară pentru controlul PTZ, solicitările de arhivare cronologică și descărcarea.
   * **Roșu (NU CONECTAT)**: nu este stabilită nicio sesiune SDK activă în prezent (de exemplu, înainte de prima solicitare SDK sau după deconectarea manuală/automată). Rețineți că fluxurile live RTSP ale camerei vor continua să fie redate independent de starea sesiunii SDK.
10. **Redenumirea locală a camerei**: pe orice panou de cameră din lista de camere NVR, faceți clic pe pictograma **Editați** (creion). Aceasta deschide un dialog care vă permite să setați un nume personalizat pentru cameră. Acest nume este salvat local și se actualizează instantaneu în playerele live, cronologia și vizualizările din tile fără a modifica dispozitivul fizic NVR. Îl puteți reseta la numele implicit în orice moment.
11. **Eliminarea unui recorder din listă**: lângă fiecare recorder configurat din listă, există un buton roșu de coș de gunoi. Făcând clic pe acesta, inițiază un protocol de securitate în două etape, conceput pentru a preveni ștergerea accidentală:
    * **Pasul 1 (Confirmare)**: apare un dialog intitulat *„Confirmați ștergerea NVR”*, care vă întreabă dacă sunteți sigur că doriți să ștergeți reportofonul.
    * **Pasul 2 (Avertisment)**: apare un al doilea dialog de avertizare intitulat *„Avertisment!”*, care vă întreabă dacă sunteți absolut sigur și conștient de ceea ce faceți.
    * **Efectul ștergerii**: la acceptarea celui de-al doilea avertisment, programul se deconectează de la acel NVR în fundal, își șterge intrarea din configurația aplicației și **măturează automat lista de aspecte presetate**, eliminând toate grilele dinamice generate pentru acest dispozitiv NVR.

---

## 4. Live View și Viewport Overlays

Fereastra principală a programului afișează fluxul live:
* **Grilă de cameră**: afișează fluxurile sau fluxurile RTSP direct din SDK-ul Hikvision.
* **Selectarea calității fluxului**: făcând clic dreapta pe o fereastră de vizualizare a camerei, puteți selecta **Fluxul principal** pentru cea mai mare rezoluție sau **Fluxul secundar** pentru a reduce încărcarea rețelei și a plăcii grafice.
* **Comutare dublu clic pe ecran complet**: făcând dublu clic cu butonul stâng al mouse-ului pe orice fereastra de vizualizare a camerei, o maximizează instantaneu pentru a umple întreaga zonă activă a ferestrei (ecran complet cu un singur ecran). Făcând dublu clic din nou, se restabilește aspectul original al grilei cu mai multe camere.
* **Ascunderea automată a barei de sus**: bara de instrumente de sus opțiuni (topToolBar) se poate restrânge automat în marginea de sus a ecranului atunci când cursorul mouse-ului părăsește zona sa (această opțiune este configurabilă în Setări -> *„Restrânge automat bara de sus”* sau direct folosind pictograma PIN din bara de sus).
* **Multi-monitor și ferestre auxiliare**: puteți deschide ferestre suplimentare (auxiliare) independente pentru a rula diferite machete de grilă simultan pe mai multe ecrane sau monitoare. Pentru a deschide o fereastră nouă, utilizați comanda rapidă de la tastatură `Ctrl+N` sau faceți clic pe butonul **„Fereastră nouă”** din bara de instrumente de sus. Fiecare fereastră poate fi configurată cu propria dimensiune a grilei și cu aspectul presetat selectat. Pentru a asigura stabilitate maximă pe configurațiile cu mai multe monitoare, toate ferestrele se lansează strict centrate pe afișajul principal la 90% din rezoluția acestuia.

### Butoane de suprapunere Viewport
În colțul din dreapta jos al fiecărei casete/port de vizualizare a camerei, este afișat un panou de control cu cinci pictograme funcționale atunci când treceți cursorul mouse-ului peste acesta (în funcție de preferințele UI):
1. **Pictogramă cameră (instantaneu)**: vă permite să faceți o captură de ecran din fluxul camerei. Instantaneul este salvat în rezoluția completă, nativă a fluxului, direct din buffer-ul de cadru al decodorului, evitând orice pierdere din cauza dimensiunii curente a panoului de vizualizare sau a scalării rezoluției ecranului. Salvarea reușită a instantaneelor ​​este confirmată de pictograma camerei care clipește portocaliu (`#ff7a00`) timp de exact 1 secundă.
2. **Pictogramă Redare (Arhivă)**: folosită pentru a deschide rapid arhiva de înregistrări. Făcând clic pe acest buton, se lansează automat cronologia `PlaybackWindow` pentru această cameră specifică, pornind redarea **exact cu 15 minute înainte de ora curentă de sistem** (o deplasare rapidă convenabilă înapoi).
3. **pictogramă săgeată circulară (redare rapidă/miniplayer)**: activează o redare rapidă în fereastra de vizualizare a înregistrărilor din arhiva camerei din ultimele 30 de minute, direct în interiorul casetei camerei, fără a părăsi grila live sau a lansa fereastra completă a arhivei.
   * **Panou de control**: când este activ, în partea de jos a ferestrei de vizualizare apare un panou de control glisant care conține:
     * **Redare/Pauză**: întrerupe sau reia fluxul de redare.
     * **Afișare oră și compensare**: afișează marcajul de timp curent al redării și vârsta relativă a acestuia în comparație cu timpul real (de exemplu, `-12:34` reprezintă acum 12 minute și 34 de secunde).
     * **Cronologie interactivă Slider**: permite clicul sau tragerea pentru a căuta oriunde în memoria tampon de 30 de minute. Segmentele de înregistrare disponibile sunt evidențiate cu un fundal verde, iar un cap de redare roșu marchează poziția curentă.
     * **Multiplicator de viteză**: parcurge vitezele de redare (`1x`, `2x` și `4x`) pentru a scana rapid filmările.
     * **Închidere (✕)**: închide miniplayerul și readuce instantaneu fereastra la fluxul live.
   * **Compatibilitate cu zoom panorabil**: la fel ca în vizualizarea live, puteți folosi instrumentul lupă pentru a mări o regiune a miniplayerului sau puteți ține apăsat butonul din mijloc al mouse-ului și trageți pentru a deplasa.
4. **Pictogramă 1:1 (Scală nativă)**: Comută modul de afișare video pixel la pixel. Când este activat, videoclipul nu este întins sau distorsionat pentru a umple limitele plăcilor, ci este centrat și afișat în rezoluția sa originală. Când acest mod este activ, fundalul butonului și textul „1:1” sunt evidențiate în neon-turcoaz strălucitor.
5. **Pictogramă Lupă (Zoom interactiv)**: vă permite să măriți orice regiune specifică a fluxului video:
   * **Activare**: făcând clic pe pictogramă o comută într-o stare activă (evidențiere turcoaz). Cursorul își schimbă forma și un sfat explicativ indică: *„Clic și trageți pe feedul camerei pentru a mări”*.
   * **Operațiunea**: dați clic stânga și trageți o regiune de marcaj dreptunghiulară peste fluxul live. Fereastra va decupa și va scala automat zona selectată pentru a umple întreaga țiglă.
     * **Mărire proporțională**: țineți apăsată tasta **Shift** în timp ce desenați dreptunghiul de zoom pentru a forța selecția să se blocheze într-un raport de aspect de 16:9, strict limitat la limitele ferestrei de vizualizare.
     * **Deplasarea imaginii mărite (Pan Zoom)**: Odată mărit, puteți ține apăsat **butonul din mijloc al mouse-ului (rotița de defilare)** și trageți cursorul pentru a deplasa în mod liber vizualizarea mărită în jurul câmpului vizual video. Aceasta funcționează în vizualizarea Live, Arhiva de redare și Mini-player.
   * **Resetați**: când este mărită, pictograma lupă își schimbă pictograma (chenar roșu cu semnul minus). Făcând clic pe acesta, se resetează imediat zoomul, revenind la fluxul complet al camerei.

---

## 5. Aspecte de ecran, presetări și bară de instrumente

Aspectele vă permit să organizați aranjarea camerelor pe ecran. Din fila **Presetări** (pictograma stea) puteți:
* **Creați noi presetări**: adăugați propriul aspect cu orice configurație de coloane și rânduri (de exemplu, 2x2, 3x3, 4x4).
* **Atribuiți camere**: faceți clic pe o fereastră de vizualizare din aspectul grilei pentru a o selecta, apoi deschideți fereastra camerelor NVR și faceți clic pe butonul **„+” (Adăugați)** de pe panoul camerei dorite. De asemenea, puteți schimba pozițiile ferestrelor de vizualizare folosind meniul contextual cu clic dreapta (*„Zamień miejscami”* / *„Swap viewports”*) al ferestrei de vizualizare sursă și apoi făcând clic pe fereastra țintă.

### Butoane din bara de sus (Bara de instrumente de sus)
Bara de instrumente glisantă de sus oferă un set cuprinzător de butoane de navigare și control al aplicației:
1. **Închide fereastra (buton roșu ✕)**: închide fereastra activă. Pentru a preveni clicurile accidentale, acesta interceptează evenimentul de închidere și vă solicită printr-o casetă de dialog pentru a confirma părăsirea aplicației.
2. **Butonul de fixare**: controlează comportamentul de ascundere automată a barei de instrumente de sus. Când știftul este îndreptat vertical (starea fixată), bara este blocată pe loc și rămâne permanent vizibilă. Când știftul este rotit cu -45 de grade (stare fără fixare), bara alunecă automat în sus din vedere când mouse-ul părăsește zona sa.
3. **Ecran complet (pictogramă săgeți verzi)**: comută instantaneu fereastra activă în modul ecran complet și înapoi. În modul ecran complet, săgețile indică spre interior (restrânge), iar în modul fereastră, ele indică spre exterior (se extind).
4. **Minimizare (pictogramă de minimizare cyan)**: minimizează fereastra aplicației în bara de activități. Restabilirea acesteia readuce fereastra la starea anterioară exactă (de exemplu, maximizată sau ecran complet).
5. **⚙️ OPȚIUNI (OPCJE)**: Comută fereastra cu opțiuni de configurare. Dacă fereastra este deja deschisă, făcând clic pe acest buton se închide.
6. **📺 FEREASTRĂ NOUĂ (NOWE OKNO)**: deschide un `Auxiliary Window` nou, independent și complet configurabil, perfect pentru extinderea aspectului camerei dvs. pe mai multe configurații de monitor.
7. **ARHIVĂ**: Deschide un `PlaybackWindow` (player de înregistrări) gol cu ​​cronologie și calendar activ, permițând selectarea manuală a fluxului și a canalelor camerei din orice NVR configurat prin lista din bara laterală.
8. **INSTRUKȚIUNI (INSTRUKCJA)**: deschide această fereastră de manual, încărcând documentația completă a utilizatorului în engleză sau poloneză, în funcție de localitatea dvs. activă.
9. **Comutator 📊 STATS (STATYSTYKI)**: comutați comutator pentru a glisa în afara panoului de monitorizare Statistici sistem din marginea din stânga a ecranului.
10. **Comutator de blocare a rețelei (lacăt)**: comutator care, atunci când este pornit (evidențiat cu portocaliu strălucitor), dezactivează acțiunile de redimensionare a rețelei pe butoanele rețelei adiacente, protejând aspectul camerei dvs. active de modificări accidentale.
11. **Selectoare pentru dimensiunea grilei (de la 1x1 la 9x9)**: un rând de nouă butoane care vă permite să definiți instantaneu structura rândurilor și coloanei ferestrei dvs. de vizualizare (de la o singură cameră 1x1 vizualizare până la 81 de fluxuri simultane ale camerei într-un aspect 9x9). Dimensiunea activă în prezent este evidențiată în portocaliu strălucitor.
12. **Mai multe opțiuni (Meniu Hamburger cu trei linii)**: buton care deschide caseta de instrumente glisantă `Layout & Grid Tools` pentru reglarea avansată a grilei, ajustări ale geometriei și opțiuni de depanare (detaliate mai jos).
13. **Butoane presetate/Vizualizare**: butoane redate dinamic din partea dreaptă a barei de instrumente reprezentând aspectele dvs. prestabilite configurate și vizibile (de exemplu, *📹 NVR*, *Vizualizare 1* etc.). Făcând clic pe un buton, se schimbă imediat grila. Vederea activă este evidențiată în turcoaz deschis.

### Personalizare și raporturi avansate ale grilei (instrumente de aspect și grilă)
Deschiderea meniului Hamburger (Mai multe opțiuni) afișează o casetă de instrumente de aspect specializat. Pentru a-i activa comenzile:
1. **Deblocați panoul de instrumente**: comutați comutatorul „Deblocați panoul de instrumente” din partea de sus. Aceasta este o măsură de siguranță explicită pentru a preveni modificările accidentale ale layout-urilor complexe.
2. **Diviziune personalizată a ferestrei (F2 sau Apăsați și mențineți apăsat)**: caseta de instrumente afișează butoanele de divizare a grilei de la 1x1 la 9x9. O caracteristică extrem de avansată este abilitatea de a **înlocui și edita dimensiunile diviziunii**. Dacă faceți clic și țineți apăsat pe orice buton al grilei cu butonul stâng al mouse-ului (sau îl focalizați și apăsați **F2**), apare o casetă de text. Puteți introduce orice diviziune personalizată sau asimetrică (cum ar fi `2x3`, `1x4` etc.) și apăsați Enter. Butonul este reprogramat instantaneu, iar făcând clic pe el se aplică aspectul dvs. personalizat la fereastra principală.
3. **Ratio geometrie**: permite forțarea afișajului grilei la anumite rapoarte de aspect:
   * **Raport de aspect 16:9**: blochează și scalează containerul grilă în format 16:9 cu ecran lat (standard pentru camerele IP moderne).
   * **Raport de aspect 4:3**: adaptează containerul grilă la raportul tradițional de 4:3 (obișnuit în camerele analog/IP vechi).
4. **Operații cu grilă (Imbinare celule evidențiate)**: accesați caracteristica de îmbinare asimetrică a celulelor (detaliată în Secțiunea 9.2).

---

## 6. Panoul de statistici de sistem (statistici de sistem)

Alunecând din marginea stângă a ecranului Live View, acest panou monitorizează starea computerului și încărcarea generată de aplicație:
* **Parametri monitorizați**:
  * **CPU / RAM**: Utilizarea procesorului principal (în % din toate nucleele) și a memoriei RAM utilizate direct de procesul `kvision` și subprocesele de descărcare aferente acestuia.
  * **GPU / VRAM**: utilizarea nucleului plăcii grafice (în %) și cantitatea de memorie grafică VRAM ocupată de randare și decodare hardware (suportă lista completă a proceselor GPU folosind parserul XML de la `nvidia-smi`).
  * **NETWORK (Net)**: viteza reală de transfer de descărcare a aplicației de la toți jucătorii activi în direct, playerele de arhivare și procesele de descărcare de înregistrare.
* **Multithreading (fără bâlbâială)**: colectarea datelor de proces și GPU rulează pe un fir de sistem separat (`StatsWorker`). Acest lucru previne orice micro-bâlbâială în redarea video (fără scăderi de cadre).
* **Funcție de fixare**: făcând clic pe butonul **„Fixare”** (pictograma de fixare) blochează panoul în starea sa extinsă.
* **Estetică**: diagramele au chenaruri strălucitoare, verzi neon, o umplere în degrade sub curba diagramei și o transparență echilibrată a fundalului de 35% pentru a asigura lizibilitatea textului.

---

## 7. Redare Arhivă Player

Disponibil făcând clic pe pictograma ceas/redare de lângă o anumită cameră sau recorder. Permite vizualizarea simultană a înregistrărilor arhivate de la mai multe camere Hikvision în sincronizare full time.

### Cronologie și comenzi:
* **Pornire rapidă (în urmă cu 15 minute)**: la deschiderea arhivei din vizualizarea live, playerul pornește automat dintr-un moment care scade cu **exact 15 minute înainte de ora curentă de sistem** (în loc să înceapă la miezul nopții). Acest lucru permite vizualizarea imediată a unui eveniment care tocmai a avut loc.
* **Navigație**: cronologia poate fi derulată la stânga și la dreapta trăgând-o cu butonul stâng al mouse-ului.
* **Mărire (Scalare)**: puteți schimba ușor scala cronologiei cu rotița de derulare a mouse-ului (sau butoanele Zoom) - de la vizualizarea întregii zile până la o vizualizare precisă de 10 minute.
* **Comenzi rapide de mărire rapidă**: bara de control de jos include butoane circulare dedicate pentru a scala instantaneu vizualizarea cronologică:
  * **pictograma „1h”**: mărește cronologia pentru o inspecție detaliată pe o perioadă de 1 oră.
  * **pictograma „8h”**: mărește cronologia pentru a afișa un interval de 8 ore.
  * **Pictograma „24 de ore”**: Resetează zoom-ul pentru a se potrivi întregii zile de 24 de ore pe un singur ecran.
  * **Pictograma Centrare (țintă)**: centrează imediat cronologia, astfel încât indicatorul roșu de redare să se afle exact în mijlocul ecranului (înlocuind butonul de text vechi).
* **Navigarea prin dată (calendar și zile)**: comenzile de lângă data afișată permit sărituri rapide:
  * Butoanele **„<” (Ziua anterioară)** și **„>” (Ziua următoare)**: vă permit să săriți 24 de ore înapoi sau înainte instantaneu fără a deschide caseta de dialog a calendarului.
  * **Pictograma Calendar**: deschide fereastra pop-up calendar pentru a selecta o anumită dată.
  * **Pictograma de reîmprospătare**: forțează o nouă căutare a înregistrărilor. Făcând clic pe acesta, mătură memoria cache locală a segmentelor de disponibilitate a înregistrărilor pentru toate canalele active și trimite noi interogări la NVR, ceea ce este foarte util pentru a încărca fișierele înregistrate cu doar câteva momente în urmă (înlocuind vechiul buton de text).
  * **Pictograma de azi (data/numărul de azi)**: sare instantaneu înapoi la ziua curentă (înlocuind vechiul buton de text).
* **Comenzi rapide pentru viteza de redare**:
  * **pictogramele „1x”, „2x” și „4x”**: schimbați instantaneu multiplicatorul vitezei de redare.
* **Butoane de salt pentru VCR**:
  * **pictogramele „15”, „45” și „60” cu săgeți circulare**: vă permit să săriți rapid înapoi sau înainte cu numărul specificat de secunde.
* **Bare de disponibilitate a înregistrării**: barele colorate care reprezintă segmentele video găsite pe discul înregistratorului sunt redate sub cronologia. Un sistem de stocare în cache le împiedică să pâlpâie în timpul tragerii.
* **Urmărire automată (urmărire indicator)**: indicatorul de redare (linia roșie verticală) este monitorizat în mod constant. Dacă indicatorul iese în afara intervalului vizibil al cronologiei, vizualizarea se va derula automat pentru a o centra. Această opțiune este blocată inteligent în timpul tragerii manuale a indicatorului de către utilizator.

### Panoul lateral al camerei în fereastra de redare
O listă laterală verticală pe marginea dreaptă a playerului listează toate NVR-urile configurate și canalele lor de cameră:
* **Comutarea canalelor**: făcând clic pe orice canal al camerei din listă, acesta îl adaugă ca un interval de redare activ pe cronologie (care generează un player video). Făcând clic din nou, canalul va fi eliminat.
* **Meniul contextual al canalului**: făcând clic dreapta pe un slot video activ din grila de redare se deschide un meniu pentru:
  * Comutați calitatea video (flux principal/flux secundar).
  * Închideți/eliminați playerul activ din redarea arhivei.

---

## 8. Descărcarea înregistrărilor (Descărcare)

Din fereastra Arhivă de redare, puteți descărca segmentele selectate de înregistrări direct pe unitatea computerului dvs. ca fișiere MP4:
1. Faceți clic pe pictograma de descărcare (săgeata în jos) de lângă camera selectată.
2. Selectați intervalul de timp (începutul și sfârșitul înregistrării).
3. Selectați locația de salvare a fișierului de destinație.
4. Faceți clic pe **Descărcați**.

### Funcții avansate de descărcare:
* **Descărcare secvențială de segmente (părți de 1 GB)**: programul împarte automat interogarea intervalului de timp în segmente de fișiere fizice (aproximativ 1 GB fiecare pe unitatea NVR) și le descarcă și le convertește unul câte unul (folosind fișiere temporare `.pspart` care sunt convertite direct în format `.mp4`). Acest lucru asigură descărcări extrem de stabile pentru intervale de lungă durată, fără depășirea memoriei sau blocarea conversiei FFmpeg.
* **Vizualizare generală a progresului**: bara de progres (culoare galbenă strălucitoare) afișează progresul general de descărcare pentru cameră în toate segmentele. Textul de stare suprapus pe bara de progres arată partea curentă și procentele, de exemplu, `Downloading part 1 of 3... 45% (Overall: 15%)`, cu un stil de contur pentru a garanta lizibilitatea pe orice fundal.
* **Curățarea IP a numelui fișierelor**: numele fișierelor video (și instantaneele în direct/arhivă) sunt eliminate automat de adresele IP NVR/DVR pentru a le păstra curate și lizibile de către om (de exemplu, `4_Wejscie_glowne_2026-06-15.mp4` în loc de `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Setări avansate și personalizare în fereastra Opțiuni

Fereastra de opțiuni și configurare (`SideBar`) constă din șase file dedicate:

### 1. Detalii vizualizare (pictograma Monitor)
Afișează parametrii avansați ai grilei selectate în prezent. Vă permite să:
* Introdu o **Adresă URL a fluxului principal** personalizată (RTSP/ONVIF) și o **Adresă URL de rezervă secundară** pentru configurațiile manuale.
* Comutați dezactivarea/dezactivarea sunetului canalului audio al fluxului camerei selectat.
* Introduceți suprascrierile avansate ale decodorului în caseta de text **Înlocuire opțiuni FFmpeg**.
> [!SFAT]
> Pentru cea mai rapidă conexiune în flux și stabilitate maximă peste RTSP, parametrii recomandați sunt:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Instrumente de aspect și grilă (pictogramă Glisoare)
Opțiuni avansate de personalizare a grilei ecranului:
* Comutare rapidă pentru modul Ecran complet.
* **Imbinare asimetrică a celulelor (Merge Highlighted Cells)**: un editor de aspect foarte avansat. Țineți apăsat pe **Ctrl** sau **Shift** și faceți clic pentru a selecta mai multe plăci adiacente de pe grilă sau utilizați tastatura ținând apăsată pe **Shift** și navigând cu **tastele săgeți**, apoi faceți clic pe „Îmbinați celulele evidențiate” pentru a le combina într-o singură fereastră de vizualizare mai mare. Acest lucru vă permite să creați modele de grilă asimetrice complet personalizate (de exemplu, un panou uriaș al camerei cu fluxuri mai mici în jurul acestuia).

### 3. Recordere (pictogramă server)
Manager de configurare complet pentru conexiunile la dispozitivele Hikvision NVR/DVR (descris în detaliu în Secțiunea 3).

### 4. Presetări (pictograma stea)
Manager pentru aspectele de grilă salvate și alocațiile camerei. Permite crearea de șabloane de grilă goale, modificarea ordinii acestora, comutarea vizibilității barei de sus (prin comutatorul „Vizibil”) sau activarea lor în fereastra curentă.

### 5. Setări (pictograma roată)
Permite ajustarea setărilor globale ale aplicației:
* **Permite rularea mai multor instanțe**: bifarea acestei casete permite lansarea mai multor copii paralele ale procesului KVision (în mod implicit, limitează rulările la o singură instanță activă).
* **Setări de restrângere automată**: personalizează sincronizarea animației glisante pentru bara de sus și panoul de statistici.
* **Permite schimbarea ferestrelor de vizualizare**: caseta de selectare *„Permite schimbarea locurilor ferestrelor de vizualizare”* vă permite să rearanjați imediat pozițiile camerei pe grilă (dați clic dreapta sursă -> Alegeți „Schimbați ferestre de vizualizare” -> Faceți clic stânga pe tigla țintă).
* **Permisiuni pentru clic dreapta**: comută la blocarea/deblocarea comenzilor interactive din meniul contextual pentru clic dreapta (Activați meniul contextual, Permiteți schimbarea ferestrelor de vizualizare, Activați opțiunea „Eliminați camera”, Permite modificarea setărilor ferestrei de vizualizare, Activați selecția calității principale/Sub pentru flux).
* **Activare automată a sunetului**: dezactivează automat fluxul audio al ferestrei de vizualizare active când intră în modul Ecran complet.
* **Ascunde cursorul pe ecran complet**: caseta de selectare *„Ascunde cursorul în modul ecran complet”* ascunde automat cursorul mouse-ului după o scurtă perioadă de inactivitate în timpul vizualizării pe tot ecranul pentru a asigura o vizualizare neobstrucționată.
* **Selectarea limbii**: comută instantaneu traducerea interfeței (implicit de sistem, poloneză, engleză).
* **Preferințe UI**: ascunde/afișează etichetele de stare a ferestrei de vizualizare sau insignele de control (cum ar fi ascunderea automată a suprapunerilor de control în colțul din dreapta jos al plăcilor, dacă nu treci cu mouse-ul).
* **Opțiuni FFmpeg implicite și actualizare în bloc**: permite configurarea opțiunilor globale FFmpeg aplicate noilor ferestre de vizualizare (recomandat: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[RECOMANDARE]** Dacă migrați de la o versiune mai veche a KVision (înainte de v2.4.5), este foarte recomandat să schimbați `-analyzeduration 0` în `-analyzeduration 100000` în setările globale și faceți clic pe „Actualizați toate camerele”. Setarea `0` pe fluxurile fără o pistă audio provoacă întârzieri la comutare, deoarece FFmpeg se va bloca pentru un timeout codificat de 5 secunde în așteptarea pachetelor audio. Setarea unei valori foarte scăzute (de exemplu, 100000 microsecunde = 0,1 s) rezolvă complet această problemă, menținând în același timp comutarea instantanee.
  * **Butonul Actualizați toate camerele**: butonul *„Zaktualizuj wszystkie kamery”* aplică aceste opțiuni globale tuturor ferestrelor de vizualizare configurate.
  * **Semnale cu latență scăzută (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` dezactivează tamponarea internă a pachetelor de demuxer pentru a elimina întârzierea transmisiei în timp, dar poate provoca bâlbâială dacă conexiunea de rețea la cameră este instabilă.
    * `-flags low_delay` îi spune decodorului să scoată cadre imediat, dar poate provoca artefacte scurte/petele în fluxurile care utilizează cadre B în mișcări rapide.
  * **Înlocuire caseta de selectare**: puteți exclude anumite ferestre de vizualizare din actualizările globale sau din setările implicite dinamice bifând **„Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg”** în dialogul individual Setări pentru vizualizare. Util pentru depanarea camerelor care se bâlbâie.


### 6. Jurnal de modificări (pictogramă ceas/document)
Prezintă o cronologie interactivă care arată istoricul complet al lansărilor, actualizările, remedierea erorilor și adăugările de funcții ale KVision, asigurându-vă că aveți acces direct la detaliile actualizărilor programului.

---

## 10. Comenzi rapide de la tastatură și comenzi ale mouse-ului

### Comenzi rapide de la tastatură:
| Tastă / Comandă rapidă | Acțiune |
|---|---|
| **F** / **F11** | Comutați modul Ecran complet. |
| **M** | Dezactivați / dezactivați sunetul (funcționează pentru camera activă cu sunet). |
| **Spațiu** | Redare / Întrerupeți redarea în fereastra Arhiva Redare. |
| **Alt + 1** până la **Alt + 9** | Comutare rapidă la o presetare/aspect la indicii de la 1 la 9. |
| **Alt + Săgeată la stânga** | Comutare rapidă la presetarea/dispunerea anterioară din colecție. |
| **Alt + Săgeată dreapta** | Comutare rapidă la următoarea presetare/aspectare din colecție. |
| **Tastele săgeată (sus/jos/stânga/dreapta)** | Navigați și mutați focalizarea/selecția activă între ferestrele de vizualizare ale camerei. |
| **Shift + Tastele săgeți** | Selectați mai multe ferestre adiacente ale camerei simultan (utilizate pentru îmbinarea celulelor etc.). |
| **Ctrl + N** | Deschideți o nouă fereastră auxiliară independentă. |
| **+** / **-** | Măriți / Micșorați (camere Hikvision compatibile PTZ). |
| **Shift** (trageți marcajul) | Forțați selecția marcajului să se blocheze într-un raport de aspect 16:9 în timpul zoomului interactiv. |
| **Esc** | Ieșiți din modul Ecran complet / anulați selecția activă a ferestrei de vizualizare. |

### Interacțiunea cu mouse-ul:
* **Butonul stâng al mouse-ului**:
  * **Dublu clic** pe o fereastră de vizualizare a camerei din grilă o maximizează la ecran complet. Un alt dublu clic restabilește vizualizarea grilă.
  * Trageți cronologia în fereastra Redare pentru a naviga.
* **Butonul din mijloc al mouse-ului (clic și trageți cu rotița de derulare)**:
  * Trageți pentru a deplasa și mutați imaginea mărită/mărită digital în jurul câmpului vizual al ferestrei (funcționează în Live, Archive și Mini-player).
* **Butonul dreapta al mouse-ului (Meniu contextual)**:
  * Deschide un meniu rapid de setări pentru fereastra de vizualizare selectată (permite eliminarea camerei din grilă, schimbarea între fluxurile principale/Sub sau accesarea parametrilor individuali de afișare).
* **Rotița de derulare a mouse-ului**:
  * Reglează scara (Zoom) a cronologiei în playerul de arhivă de redare.

---

## 11. Realizarea de instantanee și configurarea căii

Aplicația vă permite să capturați rapid instantanee de înaltă calitate din orice fereastra de vizualizare a camerei, atât în ​​modul Live View, cât și în modul Arhivă de redare.

### Realizarea de instantanee:
1. Un buton de suprapunere a pictogramei camerei este disponibil în colțul din dreapta jos al fiecărei ferestre de vizualizare (detaliat în Secțiunea 4).
2. Făcând clic pe pictograma camerei, se captează cadrul și îl salvează ca imagine JPEG (calitate 98 - practic fără pierderi).
3. O captură reușită este confirmată de pictograma camerei care clipește portocaliu (`#ff7a00`) timp de exact 1 secundă.
4. **Rezoluție completă**: în modul Arhivă de redare, instantaneele sunt salvate la rezoluția completă a sursei native a fluxului direct din memoria tampon de cadre a decodorului, indiferent de dimensiunea ferestrei de vizualizare active pe ecran sau de scalarea afișajului.

### Salvarea configurațiilor căilor:
1. Accesați fila **Setări** (pictograma roată din fereastra cu opțiuni).
2. În secțiunea **Salvare** ("Zapis"), puteți configura căile implicite:
   * **Calea implicită pentru instantanee**: dosar în care vor fi salvate instantaneele (implicit la `~/Obrazy/CCTV`).
   * **Calea implicită pentru înregistrări**: dosarul în care vor fi salvate videoclipurile MP4 descărcate (prestabilit la `~/Wideo/CCTV`).
3. Făcând clic pe butonul de browser `...` se deschide selectorul de foldere nativ al sistemului de operare (Breeze în KDE).
4. **Comportamentul butonului browserului**: selectorul de director se deschide exact la calea introdusă în câmpul de text (dacă există). Dacă câmpul este gol, nevalid sau indică către un dosar la care nu aveți acces, dialogul revine și se deschide în directorul dvs. principal (`~/`).

### Setări interfețe cu utilizatorul (UI):
1. Accesați fila **Setări** (pictograma roată din fereastra cu opțiuni) sau deschideți fereastra **Opțiuni** ("Opcje").
2. În secțiunea **Setări interfețe cu utilizatorul**, puteți personaliza vizibilitatea elementelor suprapuse pe camera kafelki/porturile de vizualizare:
   * **Afișează starea canalului în colțul din stânga sus al ferestrei de vizualizare** (activat implicit) — Afișează informații despre încărcarea fluxului, redarea și starea conexiunii.
   * **Afișează informațiile camerei în colțul din stânga jos al ferestrei de vizualizare** (activat implicit) — Afișează numele camerei preluat de la reportofonul Hikvision.
   * **Afișați pictogramele de control în colțul din dreapta jos al ferestrei de vizualizare numai când treceți cu mouse-ul** (activat implicit) — ascunde automat panoul de butoane de control (instantaneu, arhivă, 1:1 pixel la pixel, zoom regiune) când cursorul mouse-ului se află în afara feței de vizualizare a camerei respective. Pictogramele apar instantaneu de îndată ce mutați mouse-ul peste fereastra de vizualizare (nu este necesar să faceți clic) și dispar la ieșire, maximizând vizibilitatea fluxurilor camerei dvs.
   * **Afișați câmpurile de informații numai atunci când treceți cu mouse-ul** (dezactivată implicit) — Opțiune analogă care ascunde starea în stânga sus și numele în stânga jos a ferestrelor de vizualizare, afișând un flux complet curat al camerei, cu excepția cazului în care cursorul este mutat peste dala respectivă a camerei.
