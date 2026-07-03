# Manuale utente per KVision

> [!NOTA]
> Questo manuale di istruzioni è stato tradotto e formattato automaticamente con l'assistenza dell'Intelligenza Artificiale (AI).

**KVision** è un'applicazione desktop avanzata di classe VMS (Video Management System) progettata per la visualizzazione simultanea di flussi video live (RTSP/ONVIF) e l'integrazione con registratori NVR/DVR Hikvision (sia in modalità Live che in modalità archivio di riproduzione).

Il programma è stato ottimizzato per stabilità, funzionamento regolare (60 FPS) e consumo minimo di risorse di sistema.

---

## Sommario
1. [Descrizione delle azioni dei pulsanti](#1-description-of-button-actions)
2. [Installazione e avvio](#2-installation-and-launching)
3. [Gestione dei registratori NVR/DVR](#3-managing-nvrdvr-recorders)
4. [Sovrapposizioni visualizzazione live e viewport](#4-live-view-and-viewport-overlays)
5. [Layout dello schermo, preimpostazioni e barra degli strumenti](#5-screen-layouts-presets-and-toolbar)
6. [Pannello Statistiche di sistema (Statistiche di sistema)](#6-system-statistics-panel-system-stats)
7. [Lettore archivio riproduzione](#7-playback-archive-player)
8. [Download delle registrazioni (Downloader)](#8-downloading-recordings-downloader)
9. [Impostazioni avanzate e personalizzazione nella finestra Opzioni](#9-advanced-settings-and-customization-in-options-window)
10. [Scorciatoie da tastiera e controlli del mouse](#10-keyboard-shortcuts-and-mouse-controls)
11. [Scattare istantanee e configurare il percorso](#11-taking-snapshots-and-path-configuration)

---

## 1. Descrizione delle azioni dei pulsanti

Questa sezione descrive il significato di tutte le icone grafiche e i pulsanti utilizzati nell'applicazione.

### Barra degli strumenti superiore
* {ICON:quit} **Chiudi finestra**: richiede conferma e chiude la finestra o l'applicazione attiva.
* {ICON:pin} **Barra bloccata**: blocca la barra superiore in uno stato espanso o abilita la compressione automatica.
* {ICON:fullscreen} **Schermo intero**: attiva la modalità a schermo intero della finestra attiva.
* {ICON:minimize} **Riduci a icona**: riduce a icona la finestra dell'applicazione sulla barra delle applicazioni del sistema.
* {ICON:options} **Opzioni**: Apre o chiude la finestra delle opzioni di configurazione (impostazioni e registratori).
* {ICON:new_window} **Nuova finestra**: apre una nuova finestra ausiliaria indipendente per i flussi della telecamera.
* {ICON:archive} **Archivio**: apre la finestra di archivio delle registrazioni di riproduzione (timeline e calendario).
* {ICON:instructions} **Istruzioni**: apre il manuale utente e la finestra di assistenza tecnica.
* {ICON:stats} **Statistiche**: attiva/disattiva il pannello scorrevole delle statistiche del sistema (CPU, RAM, GPU, Rete).
* {ICON:lock} **Blocco griglia**: disabilita le regolazioni della divisione della griglia per proteggere il layout attivo.
* {ICON:hamburger} **Altre opzioni**: apre la casella degli strumenti scorrevole per dimensioni di divisione, rapporti e unione di celle avanzati.

### Sovrapposizioni viewport (telecamere)
* {ICON:snapshot} **Istantanea**: cattura un'immagine senza perdita di dati a piena risoluzione e la salva come file JPEG.
* {ICON:play} **Archivio fotocamera**: avvia la finestra di riproduzione della sequenza temporale per questa fotocamera (15 minuti indietro).
* {ICON:quick_play} **Riproduzione rapida (miniplayer)**: avvia una riproduzione dell'archivio nel viewport degli ultimi 30 minuti, consentendoti di rivedere rapidamente i filmati recenti direttamente nel riquadro della fotocamera senza uscire dalla visualizzazione Live.
* {ICON:grid_1x1} **Prova 1:1**: visualizza il flusso video nella sua risoluzione nativa originale senza allungamento.
* {ICON:zoom_in} **Zoom interattivo**: attiva/disattiva l'ingrandimento facendo clic e trascinando per una regione di selezione selezionata.
* {ICON:zoom_out} **Reimposta zoom**: reimposta l'ingrandimento digitale e ripristina l'intero campo visivo della fotocamera.
* {ICON:speaker_unmute} **Disattiva audio**: rappresenta un flusso audio non disattivato; facendo clic su di esso si disattiva lo streaming.
* {ICON:speaker_mute} **Riattiva audio**: rappresenta un flusso audio disattivato; facendo clic su di esso si riattiva l'audio dello streaming.

### Controlli della finestra di riproduzione

**Controlli della barra superiore:**
* {ICON:close} **Chiudi**: Chiude la finestra del player dell'archivio di riproduzione.
* {ICON:pin} **Barra bloccata**: blocca la barra superiore in uno stato espanso o abilita la compressione automatica.
* {ICON:fullscreen} **Schermo intero**: attiva la finestra di riproduzione in modalità a schermo intero.
* {ICON:sidebar} **Mostra/Nascondi barra laterale**: attiva/disattiva la visibilità della barra laterale sinistra contenente telecamere e registratori.
* {ICON:timeline_show} / {ICON:timeline_hide} **Mostra/Nascondi timeline**: mostra o nasconde il pannello inferiore contenente la timeline e i controlli di riproduzione.
* {ICON:video_folder} **Cartella video**: apre la cartella di sistema locale contenente i video clip scaricati.
* {ICON:photo_folder} **Cartella istantanee**: apre la cartella di sistema locale contenente le istantanee acquisite.
* pulsanti della griglia `1x1`, `1x2`, `2x1`, `2x2`: cambia il layout di visualizzazione della telecamera della finestra di riproduzione su 1, 2 (verticale/orizzontale) o 4 visualizzazioni simultanee.

**Controlli della barra inferiore e della sequenza temporale:**
* {ICON:prev_day} **Giorno precedente**: passa alle registrazioni del giorno di calendario precedente.
* {ICON:calendar_select} **Selettore data**: apre una finestra di dialogo del calendario per selezionare una data specifica per la riproduzione.
* {ICON:next_day} **Giorno successivo**: passa alle registrazioni del giorno di calendario successivo.
* {ICON:today} **Oggi**: sposta immediatamente il focus della riproduzione sul giorno di calendario corrente.
* {ICON:refresh_recordings} **Aggiorna registrazioni**: aggiorna e richiede nuovamente i segmenti di registrazione disponibili dal dispositivo.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Preimpostazioni zoom timeline**: ridimensiona la finestra visibile della timeline (a 1 ora, 8 ore o 24 ore) per una navigazione ad alta precisione.
* {ICON:timeline_center} **Centra timeline**: centra la visualizzazione della timeline esattamente attorno al timestamp di riproduzione corrente.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Velocità di riproduzione**: regola il moltiplicatore di riproduzione video (velocità standard 1x, 2x accelerata o riproduzione rapida 4x).
* {ICON:download} **Download**: apre lo strumento di download per esportare un segmento video definito dal dispositivo.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Salta indietro**: riavvolge il timestamp di riproduzione di 60, 45 o 15 secondi.
* {ICON:play} / {ICON:pause} **Riproduci/Pausa**: avvia o mette in pausa la riproduzione del flusso video in archivio.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Salta avanti**: fa avanzare il timestamp della riproduzione di 15, 45 o 60 secondi.

**Altre icone diagnostiche e generali:**
* {ICON:calendar} **Calendario**: rappresenta le configurazioni di calendario/pianificazione.
* {ICON:clock} **Ora**: rappresenta l'orologio o gli indicatori di stato temporale.
* {ICON:zoom} **Zoom**: rappresenta le configurazioni di ridimensionamento o zoom digitale.
* {ICON:timeline_toggle} **Attiva/disattiva sequenza temporale**: rappresenta la commutazione o l'aggiornamento delle visualizzazioni cronologiche.
* {ICON:trash} **Elimina**: rimuove in modo sicuro i registratori o i layout configurati con conferma.
* {ICON:warning} **Avviso**: visualizzato nelle finestre di dialogo per azioni irreversibili o eliminazione di avvisi.

---

## 2. Installazione e avvio

### Installazione su Arch Linux (Pacman)
Per installare il programma dal pacchetto binario preparato, vai alla directory `packaging/arch/` ed esegui:
```bash
sudo pacman -U kvision-2.4.6-2-x86_64.pkg.tar.zst
```
Il pacchetto installerà automaticamente il programma, il file di attivazione `.desktop` e le librerie Hikvision SDK richieste nel percorso di sistema `/usr/lib/kvision`.

### Compilazione manuale (dal codice sorgente)
Se desideri compilare il programma manualmente (ad esempio su un'altra distribuzione Linux) invece di utilizzare il pacchetto già pronto:

1. Installa le dipendenze di build e runtime richieste utilizzando il gestore pacchetti. Per Arch Linux/CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Configura il progetto utilizzando CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Compila il codice:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installa l'applicazione nel sistema:
   ```bash
   sudo cmake --install build
   ```

### Lancio
Il programma può essere lanciato dal menù di sistema oppure digitando da terminale:
```bash
kvision
```

### Risoluzione dei problemi di ridimensionamento del sistema (KDE Plasma)

A partire dalla versione 2.4.4, KVision rileva automaticamente e applica correttamente il ridimensionamento frazionario del desktop (ad esempio, 125%, 145%, 150%) configurato nelle impostazioni di KDE Plasma applicando politiche pass-through native ad alto DPI in Qt. L'interfaccia utente dovrebbe ora essere ridimensionata correttamente senza alcun intervento manuale.

#### Supporto nativo Wayland

Per garantire la migliore esperienza di ridimensionamento e prestazioni con Wayland, assicurati di avere il pacchetto `qt5-wayland` opzionale installato sul tuo sistema. Ciò consente a KVision di funzionare in modo nativo su Wayland invece di ricorrere a XWayland.

Per Arch Linux/Manjaro/CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Per Debian/Ubuntu/Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Override del ridimensionamento manuale (legacy/fallback)

Se stai utilizzando una versione precedente, una configurazione insolita o semplicemente desideri forzare manualmente un fattore di scala diverso rispetto al resto del sistema, puoi comunque sovrascrivere il ridimensionamento dell'applicazione utilizzando le variabili di ambiente.

Ad esempio, per forzare il ridimensionamento del **150%**, avvia l'applicazione dal terminale con:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Puoi applicarlo in modo permanente modificando il `kvision.desktop` di avvio dell'applicazione nell'editor del menu KDE e aggiungendo queste variabili al campo "Variabili d'ambiente").*

---

## 3. Gestione dei registratori NVR/DVR

Per configurare la connessione a un registratore Hikvision:
1. Apri la finestra delle opzioni e vai alla scheda **Registratori** (icona del server).
2. Inserisci i dati di accesso del dispositivo:
   * **Indirizzo IP**: l'indirizzo di rete del registratore.
   * **Porta**: la porta di rete dell'SDK (l'impostazione predefinita è `8000`).
   * **Nome utente**: nome utente (ad esempio, `admin`).
   * **Password**: password per accedere al registratore.
3. Fai clic su **Connetti e scopri** (o **Salva e aggiorna**).
4. Una volta stabilita la connessione, l'applicazione rileverà automaticamente tutte le telecamere attive (canali) collegate all'NVR/DVR e le aggiungerà all'elenco.
5. Facendo clic sul pulsante **Genera griglia** verrà creato automaticamente un layout di visualizzazione (preimpostazione) contenente tutte le telecamere attive da quell'NVR in un layout di griglia ottimale.
6. **Visualizzazione degli elenchi delle telecamere (NvrCamerasWindow)**: facendo clic sul pulsante dell'icona del monitor del computer sulla scheda di qualsiasi registratore si apre una finestra dedicata che mostra tutti i canali delle telecamere rilevati come riquadri interattivi.
7. **Generazione di miniature (Genera miniature)**: nella finestra di elenco delle telecamere NVR, è disponibile un pulsante *"Genera miniature"*. Facendo clic su di esso si comanda all'applicazione di estrarre singoli fotogrammi dal flusso secondario di ciascun canale in background, impostandoli come miniature dello sfondo del riquadro. Ciò fornisce una rapida anteprima visiva di ciascuna telecamera senza avviare feed live completi.
8. **Funzione clicca e aggiungi**: l'applicazione non supporta il trascinamento dei riquadri (trascina e rilascia) dalla finestra dell'elenco delle telecamere alla griglia principale. L'assegnazione della telecamera viene eseguita in modo semplice e affidabile: prima fare clic con il pulsante sinistro del mouse su qualsiasi riquadro della vista nella griglia della schermata principale per selezionarla (verrà evidenziato con un bordo luminoso), quindi fare clic sul pulsante verde **"+" (Assegna alla vista attiva)** sul riquadro della telecamera desiderata nella finestra dell'elenco delle telecamere dell'NVR. Lo streaming verrà caricato immediatamente in quello slot.
9. **Stato sessione SDK (indicatore punto)**: accanto all'IP di ciascun registratore nell'elenco, è presente un punto di stato colorato:
   * **Verde (ACCESSO)**: rappresenta una sessione SDK Hikvision attiva, necessaria per il controllo PTZ, le richieste di archivio della timeline e il download.
   * **Rosso (NON ACCESSO)**: non è attualmente stabilita alcuna sessione SDK attiva (ad esempio prima della prima richiesta SDK o dopo il logout manuale/automatico). Tieni presente che i feed live RTSP della telecamera continueranno a essere riprodotti indipendentemente dallo stato della sessione dell'SDK.
10. **Rinomina telecamera locale**: su qualsiasi riquadro della telecamera nell'elenco delle telecamere NVR, fare clic sull'icona **Modifica** (matita). Si apre una finestra di dialogo che consente di impostare un nome personalizzato per la fotocamera. Questo nome viene salvato localmente e si aggiorna istantaneamente sui lettori live, sulla sequenza temporale e sulle visualizzazioni dei riquadri senza modificare il dispositivo NVR fisico. Puoi reimpostarlo al nome predefinito in qualsiasi momento.
11. **Rimuovere un registratore dall'elenco**: accanto a ciascun registratore configurato nell'elenco, è presente un pulsante rosso con il cestino. Facendo clic su di esso si avvia un protocollo di sicurezza a due fasi progettato per impedire la cancellazione accidentale:
    * **Passaggio 1 (Conferma)**: viene visualizzata una finestra di dialogo intitolata *"Conferma eliminazione NVR"*, che ti chiede se sei sicuro di voler eliminare il registratore.
    * **Passaggio 2 (Avviso)**: viene visualizzata una seconda finestra di dialogo di avviso intitolata *"Avviso!"*, che ti chiede se sei assolutamente sicuro e consapevole di ciò che stai facendo.
    * **Effetto dell'eliminazione**: dopo aver accettato il secondo avviso, il programma si disconnette da quell'NVR in background, elimina la sua voce dalla configurazione dell'applicazione e **spazza automaticamente l'elenco dei layout preimpostati**, rimuovendo tutte le griglie dinamiche generate per questo dispositivo NVR.

---

## 4. Sovrapposizioni di visualizzazione live e viewport

La finestra principale del programma mostra il feed live:
* **Griglia fotocamera**: visualizza flussi o feed RTSP direttamente dall'SDK Hikvision.
* **Selezione della qualità del flusso**: facendo clic con il pulsante destro del mouse su una finestra della telecamera, è possibile selezionare il **flusso principale** per la risoluzione più alta o il **flusso secondario** per ridurre il carico della rete e della scheda grafica.
* **Fare doppio clic per attivare/disattivare lo schermo intero**: facendo doppio clic con il pulsante sinistro del mouse su qualsiasi finestra della telecamera, questa viene ingrandita immediatamente per riempire l'intera area della finestra attiva (schermo intero con vista singola). Facendo nuovamente doppio clic si ripristina il layout originale della griglia multi-camera.
* **Barra superiore nascosta automaticamente**: la barra degli strumenti delle opzioni superiore (topToolBar) può comprimersi automaticamente sul bordo superiore dello schermo quando il cursore del mouse lascia la sua area (questa opzione è configurabile in Impostazioni -> *"Comprimi automaticamente la barra superiore"* o direttamente utilizzando l'icona della puntina sulla barra superiore).
* **Finestre multi-monitor e ausiliarie**: puoi aprire finestre aggiuntive (ausiliarie) indipendenti per eseguire diversi layout di griglia contemporaneamente su più schermi o monitor. Per aprire una nuova finestra, utilizza la scorciatoia da tastiera `Ctrl+N` oppure fai clic sul pulsante **"Nuova finestra"** sulla barra degli strumenti in alto a scorrimento. Ogni finestra può essere configurata con la propria dimensione della griglia e il layout preimpostato selezionato. Per garantire la massima stabilità nelle configurazioni multi-monitor, tutte le finestre vengono avviate rigorosamente centrate sul display principale al 90% della sua risoluzione.

### Pulsanti di sovrapposizione della vista
Nell'angolo in basso a destra di ogni riquadro/visualizzazione della telecamera, quando si passa il cursore del mouse su di esso viene visualizzato un pannello di controllo con cinque icone funzionali (a seconda delle preferenze dell'interfaccia utente):
1. **Icona della fotocamera (istantanea)**: consente di acquisire uno screenshot dal feed della fotocamera. Lo snapshot viene salvato con la risoluzione nativa completa del flusso direttamente dal frame buffer del decodificatore, evitando eventuali perdite dovute alla dimensione corrente del riquadro del viewport o al ridimensionamento della risoluzione dello schermo. Il salvataggio dell'istantanea riuscito è confermato dall'icona della fotocamera che lampeggia in arancione (`#ff7a00`) per esattamente 1 secondo.
2. **Icona Riproduci (Archivio)**: utilizzata per aprire rapidamente l'archivio delle registrazioni. Facendo clic su questo pulsante si avvia automaticamente la sequenza temporale `PlaybackWindow` per questa telecamera specifica, avviando la riproduzione **esattamente 15 minuti prima dell'ora di sistema corrente** (un comodo e rapido spostamento indietro).
3. **Icona freccia circolare (riproduzione rapida/miniplayer)**: attiva una rapida riproduzione nel viewport delle registrazioni dell'archivio della telecamera degli ultimi 30 minuti direttamente all'interno del riquadro della telecamera senza lasciare la griglia live o avviare la finestra dell'archivio completo.
   * **Pannello di controllo**: quando attivo, nella parte inferiore della finestra viene visualizzato un pannello di controllo scorrevole contenente:
     * **Riproduci/Pausa**: mette in pausa o riprende il flusso di riproduzione.
     * **Visualizzazione ora e offset**: mostra il timestamp della riproduzione corrente e la sua età relativa rispetto al tempo reale (ad esempio, `-12:34` rappresenta 12 minuti e 34 secondi fa).
     * **Slider interattivo della sequenza temporale**: consente di fare clic o trascinare per cercare ovunque all'interno del buffer di 30 minuti. I segmenti di registrazione disponibili sono evidenziati con uno sfondo verde acqua e una testina di riproduzione rossa contrassegna la posizione corrente.
     * **Moltiplicatore di velocità**: scorre le velocità di riproduzione (`1x`, `2x` e `4x`) per scansionare rapidamente il filmato.
     * **Chiudi (✕)**: chiude il mini player e riporta immediatamente la visualizzazione al feed live.
   * **Supporto zoom orizzontale**: proprio come nella visualizzazione Live, puoi utilizzare lo strumento lente di ingrandimento per ingrandire una regione del mini player oppure tenere premuto il pulsante centrale del mouse e trascinare per eseguire la panoramica.
4. **Icona 1:1 (scala nativa)**: attiva/disattiva la modalità di visualizzazione video pixel-pixel. Quando abilitato, il video non viene allungato o distorto per riempire i bordi del riquadro, ma viene invece centrato e mostrato nella sua risoluzione nativa originale. Quando questa modalità è attiva, lo sfondo del pulsante e il testo "1:1" sono evidenziati in turchese chiaro al neon.
5. **Icona lente di ingrandimento (Zoom interattivo)**: consente di ingrandire qualsiasi regione specifica del feed video:
   * **Attivazione**: facendo clic sull'icona si passa allo stato attivo (evidenziazione turchese). Il cursore cambia forma e una descrizione comando indica: *"Fare clic e trascinare sul feed della telecamera per ingrandire"*.
   * **Operazione**: fai clic con il pulsante sinistro del mouse e trascina un'area di selezione rettangolare sul feed live. La finestra ritaglierà e ridimensionerà automaticamente l'area selezionata per riempire l'intero riquadro.
     * **Zoom proporzionale**: tieni premuto il tasto **Maiusc** mentre disegna il rettangolo di zoom per forzare la selezione a bloccarsi su proporzioni 16:9, strettamente vincolate ai limiti della finestra.
     * **Panoramica dell'immagine ingrandita (Pan Zoom)**: una volta ingrandita, è possibile tenere premuto il **pulsante centrale del mouse (rotella di scorrimento)** e trascinare il cursore per eseguire liberamente la panoramica della vista ingrandita attorno al campo visivo del video. Funziona nella vista Live, nell'archivio di riproduzione e nel mini player.
   * **Ripristina**: quando viene ingrandita, l'icona della lente di ingrandimento cambia icona (bordo rosso con un segno meno). Facendo clic su di esso si reimposta immediatamente lo zoom, tornando al feed completo della fotocamera.

---

## 5. Layout dello schermo, preimpostazioni e barra degli strumenti

I layout consentono di organizzare la disposizione delle telecamere sullo schermo. Dalla scheda **Preimpostazioni** (icona a forma di stella) puoi:
* **Crea nuove preimpostazioni**: aggiungi il tuo layout con qualsiasi configurazione di colonne e righe (ad esempio, 2x2, 3x3, 4x4).
* **Assegna telecamere**: fare clic su una finestra nel layout della griglia per selezionarla, quindi aprire la finestra delle telecamere NVR e fare clic sul pulsante **"+" (Aggiungi)** sul riquadro della telecamera desiderata. Puoi anche scambiare le posizioni della vista utilizzando il menu contestuale del tasto destro del mouse (*„Zamień miejscami”* / *„Scambia finestre”*) della vista di origine e quindi facendo clic sulla vista di destinazione.

### Pulsanti della barra superiore (barra degli strumenti superiore)
La barra degli strumenti scorrevole superiore fornisce un set completo di pulsanti di navigazione e di controllo delle applicazioni:
1. **Chiudi finestra (pulsante rosso ✕)**: chiude la finestra attiva. Per evitare clic accidentali, intercetta l'evento di chiusura e richiede una finestra di dialogo per confermare l'uscita dall'applicazione.
2. **Pulsante Aggiungi**: controlla il comportamento di occultamento automatico della barra degli strumenti superiore. Quando il perno è rivolto verticalmente (stato bloccato), la barra è bloccata in posizione e rimane permanentemente visibile. Quando il perno viene ruotato di -45 gradi (stato non bloccato), la barra scorre automaticamente verso l'alto fuori dalla vista quando il mouse lascia la sua area.
3. **Schermo intero (icona delle frecce verdi)**: passa istantaneamente la finestra attiva alla modalità a schermo intero e viceversa. In modalità a schermo intero, le frecce puntano verso l'interno (comprimi), mentre in modalità finestra puntano verso l'esterno (espandi).
4. **Riduci a icona (icona di minimizzazione ciano)**: riduce a icona la finestra dell'applicazione sulla barra delle applicazioni. Il ripristino riporta la finestra al suo esatto stato precedente (ad esempio ingrandita o a schermo intero).
5. **⚙️ OPZIONI (OPCJE)**: attiva/disattiva la finestra delle opzioni di configurazione. Se la finestra è già aperta, facendo clic su questo pulsante la si chiude.
6. **📺 NUOVA FINESTRA (ORA OKNO)**: apre un nuovo `Auxiliary Window` indipendente e completamente configurabile, perfetto per espandere i layout della fotocamera su più configurazioni di monitor.
7. **ARCHIVIO**: apre un `PlaybackWindow` vuoto (lettore di registrazioni) con timeline e calendario attivi, consentendo la selezione manuale del canale dello streaming e della telecamera da qualsiasi NVR configurato tramite l'elenco della barra laterale.
8. **ISTRUZIONI (INSTRUKCJA)**: apre questa finestra del manuale, caricando la documentazione utente completa in inglese o polacco a seconda della locale attiva.
9. **📊 Interruttore STATS (STATYSTYKI)**: attiva/disattiva l'interruttore per far scorrere fuori il pannello di monitoraggio delle statistiche di sistema dal bordo sinistro dello schermo.
10. **Interruttore di blocco della griglia (lucchetto)**: interruttore che, quando attivato (evidenziato in arancione brillante), disabilita le azioni di ridimensionamento della griglia sui pulsanti della griglia adiacenti, proteggendo il layout della telecamera attiva da modifiche accidentali.
11. **Selettori delle dimensioni della griglia (da 1x1 a 9x9)**: una fila di nove pulsanti che ti consente di definire istantaneamente la struttura di righe e colonne del tuo viewport (da una visualizzazione 1x1 di una singola telecamera fino a 81 feed di telecamere simultanei in un layout 9x9). La dimensione attualmente attiva viene evidenziata in arancione brillante.
12. **Altre opzioni (menu Hamburger con tre righe)**: pulsante che apre la casella degli strumenti `Layout & Grid Tools` scorrevole per la regolazione avanzata della griglia, le regolazioni della geometria e le opzioni di debug (dettagliate di seguito).
13. **Pulsanti di preimpostazione/visualizzazione**: pulsanti visualizzati dinamicamente sul lato destro della barra degli strumenti che rappresentano i layout preimpostati configurati e visibili (ad esempio *📹 NVR*, *Visualizzazione 1*, ecc.). Facendo clic su un pulsante si cambia immediatamente la griglia. La vista attiva viene evidenziata in turchese chiaro brillante.

### Personalizzazione e rapporti avanzati della griglia (strumenti di layout e griglia)
L'apertura del menu Hamburger (Altre opzioni) fa apparire una casella degli strumenti di layout specializzata. Per attivare i suoi controlli:
1. **Sblocca riquadro strumenti**: attiva l'interruttore "Sblocca riquadro strumenti" nella parte superiore. Si tratta di una misura di sicurezza esplicita per prevenire modifiche accidentali a layout complessi.
2. **Divisione personalizzata della finestra (F2 o pressione prolungata)**: la casella degli strumenti visualizza i pulsanti di divisione della griglia da 1x1 a 9x9. Una funzionalità estremamente avanzata è la possibilità di **sostituire e modificare le dimensioni delle divisioni**. Se fai clic e tieni premuto un pulsante della griglia con il pulsante sinistro del mouse (o lo focalizzi e premi **F2**), viene visualizzata una casella di testo. Puoi digitare qualsiasi divisione personalizzata o asimmetrica (come `2x3`, `1x4` e così via) e premere Invio. Il pulsante viene immediatamente riprogrammato e facendo clic su di esso si applica il layout personalizzato alla finestra principale.
3. **Rapporti geometrici**: consente di forzare la visualizzazione della griglia a proporzioni specifiche:
   * **Proporzioni 16:9**: blocca e ridimensiona il contenitore della griglia nel formato widescreen 16:9 (standard per le moderne telecamere IP).
   * **Proporzioni 4:3**: adatta il contenitore della griglia al tradizionale rapporto 4:3 (comune nelle telecamere analogiche/IP di vecchia generazione).
4. **Operazioni sulla griglia (Unisci celle evidenziate)**: accedi alla funzione di unione asimmetrica delle celle (dettagliata nella Sezione 9.2).

---

## 6. Pannello Statistiche di sistema (Statistiche di sistema)

Scorrendo dal bordo sinistro della schermata Live View, questo pannello monitora lo stato del computer e il carico generato dall'applicazione:
* **Parametri monitorati**:
  * **CPU/RAM**: utilizzo del processore principale (in % di tutti i core) e della RAM utilizzata direttamente dal processo `kvision` e dai relativi sottoprocessi downloader.
  * **GPU/VRAM**: utilizzo del core della scheda grafica (in %) e quantità di memoria grafica VRAM occupata dal rendering e dalla decodifica hardware (supporta l'elenco completo dei processi GPU utilizzando il parser XML di `nvidia-smi`).
  * **RETE (Rete)**: velocità di trasferimento download effettiva dell'applicazione da tutti i lettori live attivi, lettori di archivio e processi di download di registrazione.
* **Multithreading (senza stuttering)**: la raccolta dei dati di processo e GPU viene eseguita su un thread di sistema separato (`StatsWorker`). Ciò impedisce qualsiasi micro-stuttering nel rendering video (nessuna caduta di fotogrammi).
* **Funzione Blocca**: facendo clic sul pulsante **"Fissa"** (icona a forma di puntina) si blocca il pannello nel suo stato espanso.
* **Estetica**: i grafici presentano bordi luminosi verde neon, un riempimento sfumato sotto la curva del grafico e una trasparenza dello sfondo bilanciata del 35% per garantire la leggibilità del testo.

---

## 7. Lettore archivio di riproduzione

Disponibile facendo clic sull'icona orologio/riproduzione accanto a una telecamera o un registratore specifico. Consente la visualizzazione simultanea delle registrazioni archiviate da più telecamere Hikvision in sincronizzazione a tempo pieno.

### Cronologia e controlli:
* **Avvio rapido (15 minuti indietro)**: quando si apre l'archivio dalla visualizzazione live, il lettore si avvia automaticamente da un momento che cade **esattamente 15 minuti prima dell'ora di sistema corrente** (invece di iniziare a mezzanotte). Ciò consente la visualizzazione immediata di un evento appena accaduto.
* **Navigazione**: è possibile scorrere la sequenza temporale verso sinistra e verso destra trascinandola con il pulsante sinistro del mouse.
* **Zoom (ridimensionamento)**: puoi modificare facilmente la scala della sequenza temporale con la rotella di scorrimento del mouse (o i pulsanti Zoom), dalla visualizzazione dell'intera giornata fino a una visualizzazione precisa di 10 minuti.
* **Scorciatoie per lo zoom rapido**: la barra di controllo inferiore presenta pulsanti icona circolari dedicati per ridimensionare istantaneamente la visualizzazione della timeline:
  * **Icona "1 ora"**: ingrandisce la sequenza temporale per un'ispezione dettagliata nell'arco di 1 ora.
  * **Icona "8 ore"**: ingrandisce la sequenza temporale per visualizzare un intervallo di 8 ore.
  * **Icona "24 ore"**: reimposta lo zoom per adattare l'intera giornata di 24 ore su un unico schermo.
  * **Icona centrale (destinazione)**: centra immediatamente la timeline in modo che l'indicatore di riproduzione rosso si trovi esattamente al centro dello schermo (in sostituzione del vecchio pulsante di testo).
* **Navigazione data (calendario e giorni)**: i controlli accanto alla data visualizzata consentono salti rapidi:
  * Pulsanti **„<” (Giorno precedente)** e **„>” (Giorno successivo)**: ti consentono di saltare indietro o avanti di 24 ore istantaneamente senza aprire la finestra di dialogo del calendario.
  * **Icona calendario**: apre il popup del calendario per selezionare una data specifica.
  * **Icona Aggiorna**: forza una nuova ricerca delle registrazioni. Facendo clic su di esso si pulisce la cache locale dei segmenti di disponibilità di registrazione per tutti i canali attivi e si inviano nuove query all'NVR, il che è molto utile per caricare file registrati solo pochi istanti prima (in sostituzione del vecchio pulsante di testo).
  * **Icona Oggi (data/numero di oggi)**: torna immediatamente al giorno corrente (in sostituzione del vecchio pulsante di testo).
* **Scorciatoie per la velocità di riproduzione**:
  * **Icone "1x", "2x" e "4x"**: modifica istantaneamente il moltiplicatore della velocità di riproduzione.
* **Pulsanti di salto del videoregistratore**:
  * **Icone "15", "45" e "60" con frecce circolari**: consentono di saltare rapidamente indietro o avanti in base al numero di secondi specificato.
* **Barre di disponibilità della registrazione**: sotto la sequenza temporale vengono visualizzate le barre colorate che rappresentano i segmenti video trovati sul disco del registratore. Un sistema di memorizzazione nella cache impedisce loro di sfarfallare durante il trascinamento.
* **Segui automaticamente (tracciamento dell'indicatore)**: l'indicatore di riproduzione (linea rossa verticale) viene costantemente monitorato. Se l'indicatore esce dall'intervallo visibile della timeline, la vista scorrerà automaticamente per centrarlo. Questa opzione viene bloccata in modo intelligente durante il trascinamento manuale dell'indicatore da parte dell'utente.

### Pannello laterale della fotocamera nella finestra di riproduzione
Un elenco laterale verticale sul bordo destro del lettore elenca tutti gli NVR configurati e i relativi canali delle telecamere:
* **Attivazione/disattivazione dei canali**: facendo clic su qualsiasi canale della telecamera nell'elenco lo si aggiunge come slot di riproduzione attivo sulla timeline (generando un lettore video). Facendo nuovamente clic si rimuove il canale.
* **Menu contestuale canale**: facendo clic con il pulsante destro del mouse su uno slot video attivo nella griglia di riproduzione si apre un menu per:
  * Attiva/disattiva la qualità video (Stream principale/Stream secondario).
  * Chiudi/rimuovi il player attivo dalla riproduzione dell'archivio.

---

## 8. Download delle registrazioni (Downloader)

Dalla finestra Archivio di riproduzione, puoi scaricare segmenti selezionati di registrazioni direttamente sull'unità del tuo computer come file MP4:
1. Fare clic sull'icona di download (freccia verso il basso) accanto alla telecamera selezionata.
2. Selezionare l'intervallo di tempo (inizio e fine della registrazione).
3. Seleziona la posizione di salvataggio del file di destinazione.
4. Fai clic su **Scarica**.

### Funzionalità di download avanzate:
* **Download sequenziale di segmenti (parti da 1 GB)**: il programma divide automaticamente la query dell'intervallo di tempo in segmenti di file fisici (circa 1 GB ciascuno sull'unità NVR) e li scarica e li converte uno per uno (utilizzando file temporanei `.pspart` convertiti direttamente nel formato `.mp4`). Ciò garantisce download altamente stabili di intervalli di lunga durata senza overflow di memoria o blocchi della conversione FFmpeg.
* **Visualizzazione dell'avanzamento generale**: la barra di avanzamento (colore verde acqua brillante) mostra l'avanzamento generale del download per la fotocamera in tutti i segmenti. Il testo di stato sovrapposto alla barra di avanzamento mostra la parte corrente e le percentuali, ad esempio `Downloading part 1 of 3... 45% (Overall: 15%)`, con uno stile di contorno per garantire la leggibilità su qualsiasi sfondo.
* **Pulizia IP dei nomi file**: i nomi dei file video (e le istantanee live/di archivio) vengono automaticamente rimossi dagli indirizzi IP NVR/DVR per mantenerli puliti e leggibili (ad esempio `4_Wejscie_glowne_2026-06-15.mp4` invece di `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Impostazioni avanzate e personalizzazione nella finestra Opzioni

La finestra delle opzioni e della configurazione (`SideBar`) è composta da sei schede dedicate:

### 1. Dettagli della vista (icona Monitor)
Visualizza i parametri avanzati del riquadro della griglia attualmente selezionato. Ti consente di:
* Digita un **URL del flusso primario** personalizzato (RTSP/ONVIF) e un **URL del backup secondario** per le configurazioni manuali.
* Attiva/disattiva l'audio del canale audio del feed della telecamera selezionata.
* Inserisci le sostituzioni avanzate del decodificatore nella casella di testo **FFmpeg Options Override**.
> [!CONSIGLIO]
> Per la connessione streaming più veloce e la massima stabilità su RTSP, i parametri consigliati sono:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Strumenti di layout e griglia (icona cursori)
Opzioni avanzate di personalizzazione della griglia dello schermo:
* Commutazione rapida per la modalità a schermo intero.
* **Unione asimmetrica delle celle (unisci celle evidenziate)**: un editor di layout altamente avanzato. Tieni premuto **Ctrl** o **Maiusc** e fai clic per selezionare più riquadri adiacenti sulla griglia oppure utilizza la tastiera tenendo premuto **Maiusc** e navigando con i **tasti freccia**, quindi fai clic su "Unisci celle evidenziate" per fonderle in un'unica finestra più grande. Ciò ti consente di creare progetti di griglia asimmetrica completamente personalizzati (ad esempio, un enorme pannello della fotocamera con feed più piccoli che lo circondano).

### 3. Registratori (icona del server)
Gestore di configurazione completo per le connessioni ai dispositivi Hikvision NVR/DVR (descritto in dettaglio nella Sezione 3).

### 4. Preimpostazioni (Icona Stella)
Gestore per i layout della griglia salvati e le assegnazioni delle telecamere. Consente di creare modelli di griglia vuoti, modificarne l'ordine, attivarne la visibilità nella barra superiore (tramite l'interruttore "Visibile") o attivarli nella finestra corrente.

### 5. Impostazioni (icona dell'ingranaggio)
Consente di regolare le impostazioni globali dell'applicazione:
* **Consenti l'esecuzione di più istanze**: selezionando questa casella è possibile avviare più copie parallele del processo KVision (per impostazione predefinita, limita le esecuzioni a una singola istanza attiva).
* **Impostazioni di compressione automatica**: personalizza i tempi di animazione scorrevole per la barra superiore e il pannello delle statistiche.
* **Consenti lo scambio delle finestre**: la casella di controllo *"Consenti lo scambio delle posizioni delle viste"* consente di riorganizzare al volo le posizioni della telecamera sulla griglia (fare clic con il pulsante destro del mouse sul riquadro di origine -> Scegli "Scambia finestre" -> Fare clic con il pulsante sinistro del mouse sul riquadro di destinazione).
* **Autorizzazioni tasto destro**: consente di bloccare/sbloccare i controlli interattivi nel menu contestuale del tasto destro (Abilita menu contestuale, Consenti scambio finestre, Abilita opzione "Rimuovi telecamera", Consenti modifica impostazioni finestra, Abilita selezione qualità flusso principale/secondario).
* **Riattivazione automatica**: riattiva automaticamente il flusso audio della finestra attiva quando si accede alla modalità a schermo intero.
* **Nascondi cursore a schermo intero**: la casella di controllo *"Nascondi cursore in modalità schermo intero"* nasconde automaticamente il cursore del mouse dopo un breve periodo di inattività durante la visualizzazione a schermo intero per garantire una visione senza ostacoli.
* **Selezione della lingua**: cambia istantaneamente la traduzione dell'interfaccia (impostazione predefinita del sistema, polacco, inglese).
* **Preferenze interfaccia utente**: nascondi/mostra le etichette di stato della finestra o i badge di controllo (come nascondere automaticamente le sovrapposizioni di controllo nell'angolo in basso a destra dei riquadri a meno che non si passi il mouse).
* **Opzioni FFmpeg predefinite e aggiornamento in blocco**: consente di configurare le opzioni FFmpeg globali applicate alle nuove finestre (consigliato: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[RACCOMANDAZIONE]** Se stai eseguendo la migrazione da una versione precedente di KVision (precedente alla v2.4.5), si consiglia vivamente di modificare `-analyzeduration 0` in `-analyzeduration 100000` nelle impostazioni globali e fare clic su "Aggiorna tutte le telecamere". L'impostazione di `0` su flussi senza traccia audio provoca ritardi nella commutazione poiché FFmpeg si bloccherà per un timeout di 5 secondi codificato in attesa di pacchetti audio. L'impostazione di un valore molto basso (ad esempio, 100000 microsecondi = 0,1 s) risolve completamente questo problema mantenendo la commutazione istantanea.
  * **Pulsante Aggiorna tutte le telecamere**: il pulsante *„Zaktualizuj wszystkie kamery”* applica queste opzioni globali a tutte le finestre configurate.
  * **Flag a bassa latenza (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` disabilita il buffering dei pacchetti del demuxer interno per eliminare il ritardo dello streaming nel tempo, ma potrebbe causare balbettii se la connessione di rete alla telecamera è instabile.
    * `-flags low_delay` indica al decodificatore di emettere immediatamente i fotogrammi, ma può causare brevi artefatti/distorsioni nei flussi che utilizzano fotogrammi B in caso di movimenti rapidi.
  * **Casella di controllo Ignora**: puoi escludere finestre specifiche dagli aggiornamenti globali o dalle impostazioni predefinite dinamiche selezionando **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** nella finestra di dialogo Impostazioni finestra individuale. Utile per la risoluzione dei problemi delle fotocamere che balbettano.


### 6. Registro modifiche (icona orologio/documento)
Presenta una sequenza temporale interattiva che mostra la cronologia completa delle versioni, gli aggiornamenti, le correzioni di bug e le aggiunte di funzionalità di KVision, garantendoti l'accesso diretto ai dettagli degli aggiornamenti del programma.

---

## 10. Scorciatoie da tastiera e controlli del mouse

### Scorciatoie da tastiera:
| Tasto/Scorciatoia | Azione |
|---|---|
| **F** / **F11** | Attiva/disattiva la modalità a schermo intero. |
| **M** | Disattiva/attiva audio (funziona per la telecamera attiva con audio). |
| **Spazio** | Riproduci/Metti in pausa la riproduzione nella finestra Archivio riproduzione. |
| Da **Alt + 1** a **Alt + 9** | Passaggio rapido a un preset/layout negli indici da 1 a 9. |
| **Alt + Freccia sinistra** | Passa rapidamente al preset/layout precedente nella raccolta. |
| **Alt + Freccia destra** | Passa rapidamente al preset/layout successivo nella raccolta. |
| **Tasti freccia (su/giù/sinistra/destra)** | Naviga e sposta la messa a fuoco/selezione attiva tra le finestre della telecamera. |
| **Maiusc + tasti freccia** | Seleziona più finestre di telecamera adiacenti contemporaneamente (utilizzate per l'unione di celle, ecc.). |
| **Ctrl + N** | Apri una nuova finestra ausiliaria indipendente. |
| **+** / **-** | Zoom avanti/Zoom indietro (telecamere Hikvision con funzionalità PTZ). |
| **Maiusc** (trascina selezione) | Forza la selezione del riquadro di selezione per bloccare le proporzioni 16:9 durante lo zoom interattivo. |
| **Esc** | Esce dalla modalità a schermo intero/annulla la selezione della vista attiva. |

### Interazione con il mouse:
* **Pulsante sinistro del mouse**:
  * **Fai doppio clic** sulla visualizzazione di una telecamera nella griglia per ingrandirla a schermo intero. Un altro doppio clic ripristina la visualizzazione a griglia.
  * Trascina la timeline nella finestra di riproduzione per navigare.
* **Pulsante centrale del mouse (clic e trascinamento con la rotellina di scorrimento)**:
  * Trascinare per eseguire la panoramica e spostare l'immagine ingrandita/ingrandita digitalmente nel campo visivo del viewport (funziona in Live, Archivio e Mini-player).
* **Pulsante destro del mouse (menu contestuale)**:
  * Apre un menu di impostazioni rapide per il viewport selezionato (consente di rimuovere la telecamera dalla griglia, cambiare tra i flussi Principale/Secondario o accedere ai singoli parametri di visualizzazione).
* **Rotella di scorrimento del mouse**:
  * Regola la scala (Zoom) della timeline nel riproduttore dell'archivio di riproduzione.

---

## 11. Acquisizione di istantanee e configurazione del percorso

L'applicazione consente di acquisire rapidamente istantanee di alta qualità da qualsiasi viewport della fotocamera sia in modalità Live View che in modalità Archivio riproduzione.

### Scattare istantanee:
1. Un pulsante in sovrapposizione con l'icona della fotocamera è disponibile nell'angolo in basso a destra di ciascuna finestra (dettagliato nella Sezione 4).
2. Facendo clic sull'icona della fotocamera si cattura il fotogramma e lo si salva come immagine JPEG (qualità 98 - praticamente senza perdita di dati).
3. L'acquisizione riuscita è confermata dall'icona della fotocamera che lampeggia in arancione (`#ff7a00`) per esattamente 1 secondo.
4. **Risoluzione completa**: nella modalità Archivio di riproduzione, le istantanee vengono salvate alla risoluzione originale nativa completa dello streaming direttamente dal frame buffer del decoder, indipendentemente dalle dimensioni del viewport attivo sullo schermo o dal ridimensionamento del display.

### Salvataggio delle configurazioni del percorso:
1. Vai alla scheda **Impostazioni** (icona a forma di ingranaggio nella finestra delle opzioni).
2. Nella sezione **Salvataggio** ("Zapis"), puoi configurare i percorsi predefiniti:
   * **Percorso istantanee predefinito**: cartella in cui verranno salvate le istantanee (il valore predefinito è `~/Obrazy/CCTV`).
   * **Percorso di registrazione predefinito**: cartella in cui verranno salvati i video MP4 scaricati (il valore predefinito è `~/Wideo/CCTV`).
3. Facendo clic sul pulsante del browser `...` si apre il selettore di cartelle native del tuo sistema operativo (Breeze in KDE).
4. **Comportamento del pulsante del browser**: il selettore di directory si apre esattamente nel percorso digitato nel campo di testo (se esiste). Se il campo è vuoto, non valido o punta a una cartella a cui non hai accesso, la finestra di dialogo torna indietro e si apre nella tua directory home (`~/`).

### Impostazioni dell'interfaccia utente (UI):
1. Vai alla scheda **Impostazioni** (icona a forma di ingranaggio nella finestra delle opzioni) o apri la finestra **Opzioni** ("Opcje").
2. Nella sezione **Impostazioni interfaccia utente**, puoi personalizzare la visibilità degli elementi sovrapposti ai kafelki/viewport della fotocamera:
   * **Mostra lo stato del canale nell'angolo in alto a sinistra della finestra** (abilitato per impostazione predefinita): visualizza le informazioni sul caricamento dello streaming, sulla riproduzione e sullo stato della connessione.
   * **Mostra informazioni sulla telecamera nell'angolo in basso a sinistra della finestra** (abilitato per impostazione predefinita): mostra il nome della telecamera recuperato dal registratore Hikvision.
   * **Mostra le icone di controllo nell'angolo in basso a destra della finestra solo al passaggio del mouse** (abilitato per impostazione predefinita): nasconde automaticamente il pannello dei pulsanti di controllo (istantanea, archivio, 1:1 pixel per pixel, zoom regione) quando il cursore del mouse si trova all'esterno della finestra specifica della telecamera. Le icone appaiono immediatamente non appena si sposta il mouse sull'area visibile (non è richiesto alcun clic) e scompaiono quando si esce, massimizzando la visibilità dei flussi della videocamera.
   * **Mostra campi informazioni solo al passaggio del mouse** (disabilitato per impostazione predefinita): opzione analoga che nasconde lo stato in alto a sinistra e il nome in basso a sinistra delle finestre, visualizzando un flusso della telecamera completamente pulito a meno che il cursore non venga spostato su quello specifico riquadro della telecamera.
