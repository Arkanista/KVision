# Manuel d'utilisation pour KVision

**KVision** est une application de bureau avancée de classe VMS (Video Management System) conçue pour la visualisation simultanée de flux vidéo en direct (RTSP/ONVIF) et l'intégration avec les enregistreurs Hikvision NVR/DVR (à la fois en mode Live et en mode d'archive de lecture).

Le programme a été optimisé pour la stabilité, le bon fonctionnement (60 FPS) et une consommation minimale de ressources système.

---

## Table des matières
1. [Description des actions des boutons](#1-description-of-button-actions)
2. [Installation et lancement](#2-installation-and-launching)
3. [Gestion des enregistreurs NVR/DVR](#3-managing-nvrdvr-recorders)
4. [Vue en direct et superpositions de fenêtres](#4-live-view-and-viewport-overlays)
5. [Dispositions d'écran, préréglages et barre d'outils](#5-screen-layouts-presets-and-toolbar)
6. [Panneau Statistiques système (Statistiques système)](#6-system-statistics-panel-system-stats)
7. [Lecteur d'archives de lecture](#7-playback-archive-player)
8. [Téléchargement d'enregistrements (téléchargeur)](#8-downloading-recordings-downloader)
9. [Paramètres avancés et personnalisation dans la fenêtre Options](#9-advanced-settings-and-customization-in-options-window)
10. [Raccourcis clavier et commandes de la souris](#10-keyboard-shortcuts-and-mouse-controls)
11. [Prise d'instantanés et configuration du chemin](#11-taking-snapshots-and-path-configuration)

---

## 1. Description des actions des boutons

Cette section décrit la signification de toutes les icônes et boutons graphiques utilisés dans l'application.

### Barre d'outils supérieure
* {ICON:quit} **Fermer la fenêtre** : demande une confirmation et ferme la fenêtre ou l'application active.
* {ICON:pin} **Pin Bar** : verrouille la barre supérieure dans un état développé ou active la réduction automatique.
* {ICON:fullscreen} **Plein écran** : bascule la fenêtre active en mode plein écran.
* {ICON:minimize} **Réduire** : réduit la fenêtre de l'application dans la barre des tâches du système.
* {ICON:options} **Options** : Ouvre ou ferme la fenêtre des options de configuration (paramètres et enregistreurs).
* {ICON:new_window} **Nouvelle fenêtre** : ouvre une nouvelle fenêtre auxiliaire indépendante pour les flux de caméra.
* {ICON:archive} **Archive** : ouvre la fenêtre d'archives des enregistrements de lecture (chronologie et calendrier).
* {ICON:instructions} **Instructions** : Ouvre ce manuel d'utilisation et la fenêtre d'assistance technique.
* {ICON:stats} **Statistiques** : bascule le panneau coulissant des statistiques du système (CPU, RAM, GPU, Net).
* {ICON:lock} **Grid Lock** : désactive les ajustements de division de grille pour protéger votre mise en page active.
* {ICON:hamburger} **Plus d'options** : ouvre la boîte à outils coulissante pour les tailles de division avancées, les ratios et la fusion de cellules.

### Superpositions de fenêtres (caméras)
* {ICON:snapshot} **Instantané** : capture une image pleine résolution sans perte et l'enregistre sous forme de fichier JPEG.
* {ICON:play} **Camera Archive** : lance la fenêtre de lecture de la chronologie pour cette caméra (15 minutes en arrière).
* {ICON:grid_1x1} **Essayer 1:1** : affiche le flux vidéo dans sa résolution native d'origine sans étirement.
* {ICON:zoom_in} **Zoom interactif** : active le grossissement par clic et glisser pour une région de sélection sélectionnée.
* {ICON:zoom_out} **Réinitialiser le zoom** : réinitialise le grossissement numérique et restaure le champ de vision complet de la caméra.
* {ICON:speaker_unmute} **Mute Audio** : représente un flux audio non mis en sourdine ; cliquer dessus coupe le flux.
* {ICON:speaker_mute} **Réactiver l'audio** : représente un flux audio mis en sourdine ; cliquer dessus réactive le flux.

### Commandes de la fenêtre de lecture

**Contrôles de la barre supérieure :**
* {ICON:close} **Fermer** : ferme la fenêtre du lecteur d'archives de lecture.
* {ICON:pin} **Pin Bar** : verrouille la barre supérieure dans un état développé ou active la réduction automatique.
* {ICON:fullscreen} **Plein écran** : bascule la fenêtre de lecture en mode plein écran.
* {ICON:sidebar} **Afficher/Masquer la barre latérale** : bascule la visibilité de la barre latérale gauche contenant les caméras et les enregistreurs.
* {ICON:timeline_show} / {ICON:timeline_hide} **Afficher/Masquer la chronologie** : affiche ou masque le panneau inférieur contenant la chronologie et les commandes de lecture.
* {ICON:video_folder} **Dossier vidéo** : ouvre le dossier système local contenant les clips vidéo téléchargés.
* {ICON:photo_folder} **Dossier d'instantanés** : ouvre le dossier système local contenant les instantanés capturés.
* boutons de grille `1x1`, `1x2`, `2x1`, `2x2` : Bascule la disposition d'affichage de la caméra de la fenêtre de lecture sur 1, 2 (verticale/horizontale) ou 4 vues simultanées.

** Contrôles de la barre inférieure et de la chronologie : **
* {ICON:prev_day} **Jour précédent** : permet d'accéder aux enregistrements du jour calendaire précédent.
* {ICON:calendar_select} **Sélecteur de date** : ouvre une boîte de dialogue de calendrier pour sélectionner une date spécifique pour la lecture.
* {ICON:next_day} **Jour suivant** : permet d'accéder aux enregistrements du jour calendaire suivant.
* {ICON:today} **Aujourd'hui** : déplace instantanément le focus de lecture sur le jour du calendrier en cours.
* {ICON:refresh_recordings} **Actualiser les enregistrements** : actualise et réinterroge les segments d'enregistrement disponibles à partir de l'appareil.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Préréglages de zoom de la chronologie** : met à l'échelle la fenêtre visible de la chronologie (à 1 heure, 8 heures ou 24 heures) pour une navigation de haute précision.
* {ICON:timeline_center} **Centrer la chronologie** : centre la vue de la chronologie précisément autour de l'horodatage de lecture en cours.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Vitesse de lecture** : ajuste le multiplicateur de lecture vidéo (vitesse standard 1x, 2x accélérée ou lecture rapide 4x).
* {ICON:download} **Télécharger** : ouvre l'outil de téléchargement pour exporter un segment vidéo défini depuis l'appareil.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Reculer** : rembobine l'horodatage de lecture de 60, 45 ou 15 secondes.
* {ICON:play} / {ICON:pause} **Lecture/Pause** : lance ou met en pause la lecture du flux vidéo d'archive.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Avancer** : avance l'horodatage de lecture de 15, 45 ou 60 secondes.

**Autres icônes de diagnostic et générales :**
* {ICON:calendar} **Calendrier** : représente les configurations de calendrier/planification.
* {ICON:clock} **Heure** : représente les indicateurs d'horloge ou d'état temporel.
* {ICON:zoom} **Zoom** : représente les configurations de mise à l'échelle ou de zoom numérique.
* {ICON:timeline_toggle} **Changement de chronologie** : représente le basculement ou l'actualisation des vues chronologiques.
* {ICON:trash} **Supprimer** : supprime en toute sécurité les enregistreurs ou les mises en page configurés avec confirmation.
* {ICON:warning} **Avertissement** : affiché dans les boîtes de dialogue pour les actions irréversibles ou pour supprimer les avertissements.

---

## 2. Installation et lancement

### Installation sur Arch Linux (Pacman)
Pour installer le programme à partir du package binaire préparé, accédez au répertoire `packaging/arch/` et exécutez :
```bash
sudo pacman -U kvision-2.4.6-2-x86_64.pkg.tar.zst
```
Le package installera automatiquement le programme, le fichier d'activation `.desktop` et les bibliothèques Hikvision SDK requises sur le chemin système `/usr/lib/kvision`.

### Compilation manuelle (à partir du code source)
Si vous souhaitez compiler le programme manuellement (par exemple sur une autre distribution Linux) au lieu d'utiliser le package prêt à l'emploi :

1. Installez les dépendances de build et d'exécution requises à l'aide de votre gestionnaire de packages. Pour Arch Linux/CachyOS :
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Configurez le projet à l'aide de CMake :
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Compilez le code :
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Installez l'application dans le système :
   ```bash
   sudo cmake --install build
   ```

### Lancement
Le programme peut être lancé depuis le menu système ou en tapant dans le terminal :
```bash
kvision
```

### Dépannage de la mise à l'échelle du système (KDE Plasma)

À partir de la version 2.4.4, KVision détecte et applique automatiquement la mise à l'échelle fractionnée du bureau (par exemple, 125 %, 145 %, 150 %) configurée dans les paramètres de KDE Plasma en appliquant des politiques natives de pass-through High DPI dans Qt. L’interface utilisateur devrait désormais évoluer correctement dès le départ, sans aucune intervention manuelle.

#### Prise en charge native de Wayland

Pour garantir la meilleure expérience de mise à l'échelle et les meilleures performances sous Wayland, assurez-vous que le package optionnel `qt5-wayland` est installé sur votre système. Cela permet à KVision de fonctionner nativement sur Wayland au lieu de recourir à XWayland.

Pour Arch Linux/Manjaro/CachyOS :
```bash
sudo pacman -S qt5-wayland
```

Pour Debian/Ubuntu/Linux Mint :
```bash
sudo apt install qtwayland5
```

#### Remplacement de la mise à l'échelle manuelle (hérité/repli)

Si vous exécutez une ancienne version, une configuration inhabituelle ou si vous souhaitez simplement forcer manuellement un facteur de mise à l'échelle différent de celui du reste du système, vous pouvez toujours remplacer la mise à l'échelle de l'application à l'aide de variables d'environnement.

Par exemple, pour forcer une mise à l'échelle **150 %**, lancez l'application depuis le terminal avec :
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Vous pouvez appliquer cela de manière permanente en éditant le lanceur d'applications `kvision.desktop` dans l'éditeur de menu KDE et en ajoutant ces variables au champ "Variables d'environnement").*

---

## 3. Gestion des enregistreurs NVR/DVR

Pour configurer la connexion à un enregistreur Hikvision :
1. Ouvrez la fenêtre des options et accédez à l'onglet **Enregistreurs** (icône du serveur).
2. Saisissez les détails d'accès à l'appareil :
   * **Adresse IP** : L'adresse réseau de l'enregistreur.
   * **Port** : le port réseau du SDK (la valeur par défaut est `8000`).
   * **Nom d'utilisateur** : nom d'utilisateur (par exemple, `admin`).
   * **Mot de passe** : Mot de passe pour accéder à l'enregistreur.
3. Cliquez sur **Connecter et découvrir** (ou **Enregistrer et mettre à jour**).
4. Une fois la connexion réussie, l'application détectera automatiquement toutes les caméras actives (canaux) connectées au NVR/DVR et les ajoutera à la liste.
5. En cliquant sur le bouton **Générer une grille**, vous créerez automatiquement une disposition de fenêtre (préréglée) contenant toutes les caméras actives de ce NVR dans une disposition de grille optimale.
6. **Affichage des listes de caméras (NvrCamerasWindow)** : cliquer sur le bouton icône du moniteur d'ordinateur sur la carte de n'importe quel enregistreur ouvre une fenêtre dédiée affichant tous les canaux de caméra détectés sous forme de vignettes interactives.
7. **Générer des vignettes (Générer des vignettes)** : Dans la fenêtre de la liste des caméras NVR, un bouton *« Générer des vignettes »* est disponible. En cliquant dessus, l'application extrait des images uniques du sous-flux de chaque canal en arrière-plan, les définissant comme vignettes d'arrière-plan des vignettes. Cela fournit un aperçu visuel rapide de chaque caméra sans lancer de flux en direct complets.
8. **Fonctionnalité Cliquer et ajouter** : l'application ne prend pas en charge le glisser-déposer de vignettes (glisser-déposer) de la fenêtre de la liste des caméras vers la grille principale. L'attribution des caméras se fait de manière simple et fiable : cliquez d'abord avec le bouton gauche sur n'importe quelle vignette de fenêtre dans la grille de l'écran principal pour la sélectionner (elle sera mise en surbrillance avec une bordure lumineuse), puis cliquez sur le bouton vert **"+" (Attribuer à la fenêtre active)** sur la vignette de caméra souhaitée dans la fenêtre de liste des caméras NVR. Le flux se chargera instantanément dans cet emplacement.
9. **État de la session SDK (indicateur de points)** : à côté de l'adresse IP de chaque enregistreur dans la liste, il y a un point d'état coloré :
   * **Vert (CONNEXION)** : représente une session Hikvision SDK active, requise pour le contrôle PTZ, les demandes d'archives chronologiques et le téléchargement.
   * **Rouge (NON CONNECTÉ)** : aucune session SDK active n'est actuellement établie (par exemple avant la première requête SDK ou après une déconnexion manuelle/automatique). Notez que les flux RTSP en direct de la caméra continueront à être lus indépendamment de l'état de la session SDK.
10. **Renommer la caméra locale** : sur n'importe quelle vignette de caméra dans la liste des caméras NVR, cliquez sur l'icône **Modifier** (crayon). Cela ouvre une boîte de dialogue vous permettant de définir un nom personnalisé pour la caméra. Ce nom est enregistré localement et est mis à jour instantanément sur les lecteurs en direct, la chronologie et les vues en mosaïque sans modifier le périphérique NVR physique. Vous pouvez à tout moment réinitialiser le nom par défaut.
11. **Supprimer un enregistreur de la liste** : à côté de chaque enregistreur configuré dans la liste, il y a un bouton de poubelle rouge. En cliquant dessus, vous lancez un protocole de sécurité en deux étapes conçu pour empêcher toute suppression accidentelle :
    * **Étape 1 (Confirmation)** : Une boîte de dialogue intitulée *« Confirmer la suppression du NVR »* apparaît, vous demandant si vous êtes sûr de vouloir supprimer l'enregistreur.
    * **Étape 2 (Avertissement)** : Une deuxième boîte de dialogue d'avertissement intitulée *« Avertissement ! »* apparaît, vous demandant si vous êtes absolument sûr et conscient de ce que vous faites.
    * **Effet de la suppression** : après avoir accepté le deuxième avertissement, le programme se déconnecte de ce NVR en arrière-plan, supprime son entrée de la configuration de l'application et **balaye automatiquement la liste des dispositions prédéfinies**, supprimant toutes les grilles dynamiques générées pour ce périphérique NVR.

---

## 4. Superpositions d'affichage en direct et de fenêtres

La fenêtre principale du programme affiche le flux en direct :
* **Grille de caméra** : affiche les flux ou flux RTSP directement à partir du SDK Hikvision.
* **Sélection de la qualité du flux** : en cliquant avec le bouton droit sur une fenêtre d'affichage de la caméra, vous pouvez sélectionner le **Flux principal** pour la résolution la plus élevée, ou le **Sous-flux** pour réduire la charge du réseau et de la carte graphique.
* **Double-clic sur bascule plein écran** : un double-clic avec le bouton gauche de la souris sur n'importe quelle fenêtre de caméra la maximise instantanément pour remplir toute la zone de la fenêtre active (plein écran avec une seule fenêtre). Un double-clic à nouveau restaure la disposition originale de la grille multi-caméras.
* **Masquage automatique de la barre supérieure** : La barre d'outils d'options supérieure (topToolBar) peut automatiquement se réduire jusqu'au bord supérieur de l'écran lorsque le curseur de la souris quitte sa zone (cette option est configurable dans Paramètres -> *"Réduire automatiquement la barre supérieure"* ou directement en utilisant l'icône en forme d'épingle sur la barre supérieure).
* **Fenêtres multi-moniteurs et auxiliaires** : vous pouvez ouvrir des fenêtres supplémentaires (auxiliaires) indépendantes pour exécuter différentes dispositions de grille simultanément sur plusieurs écrans ou moniteurs. Pour ouvrir une nouvelle fenêtre, utilisez le raccourci clavier `Ctrl+N` ou cliquez sur le bouton **"Nouvelle fenêtre"** dans la barre d'outils supérieure du curseur de survol. Chaque fenêtre peut être configurée avec sa propre taille de grille et sa propre disposition prédéfinie sélectionnée.

### Boutons de superposition de fenêtre
Dans le coin inférieur droit de chaque vignette/fenêtre de caméra, un panneau de commande avec quatre icônes fonctionnelles s'affiche lorsque vous passez le curseur de la souris dessus (en fonction des préférences de l'interface utilisateur) :
1. **Icône de caméra (instantané)** : vous permet de prendre une capture d'écran à partir du flux de la caméra. L'instantané est enregistré dans la résolution native complète du flux directement à partir du tampon d'image du décodeur, évitant ainsi toute perte due à la taille actuelle de la vignette de la fenêtre d'affichage ou à la mise à l'échelle de la résolution de l'écran. La réussite de l'enregistrement de l'instantané est confirmée par l'icône de l'appareil photo clignotant en orange (`#ff7a00`) pendant exactement 1 seconde.
2. **Icône de lecture (archives)** : utilisée pour ouvrir rapidement les archives des enregistrements. Cliquer sur ce bouton lance automatiquement la chronologie `PlaybackWindow` pour cette caméra spécifique, démarrant la lecture **exactement 15 minutes avant l'heure actuelle du système** (un décalage rapide vers l'arrière).
3. **Icône 1:1 (échelle native)** : bascule le mode d'affichage vidéo pixel à pixel. Lorsqu'elle est activée, la vidéo n'est pas étirée ou déformée pour remplir les limites des vignettes, mais est plutôt centrée et affichée dans sa résolution native d'origine. Lorsque ce mode est actif, l'arrière-plan du bouton et le texte « 1:1 » sont mis en évidence en néon turquoise vif.
4. **Icône de loupe (zoom interactif)** : vous permet d'agrandir n'importe quelle région spécifique du flux vidéo :
   * **Activation** : cliquez sur l'icône pour la faire passer à un état actif (surbrillance turquoise). Le curseur change de forme et une info-bulle indique : *« Cliquez et faites glisser sur le flux de la caméra pour zoomer »*.
   * **Opération** : cliquez avec le bouton gauche et faites glisser une zone de sélection rectangulaire sur le flux en direct. La fenêtre recadrera et mettra automatiquement à l'échelle la zone sélectionnée pour remplir la totalité de la vignette.
   * **Réinitialiser** : lors d'un zoom, l'icône en forme de loupe change d'icône (bordure rouge avec un signe moins). En cliquant dessus, vous réinitialisez immédiatement le zoom et revenez au flux complet de la caméra.

---

## 5. Dispositions d'écran, préréglages et barre d'outils

Les mises en page vous permettent d'organiser la disposition des caméras sur l'écran. Depuis l'onglet **Préréglages** (icône étoile), vous pouvez :
* **Créer de nouveaux préréglages** : ajoutez votre propre mise en page avec n'importe quelle configuration de colonnes et de lignes (par exemple, 2x2, 3x3, 4x4).
* **Attribuer des caméras** : cliquez sur une fenêtre dans la disposition en grille pour la sélectionner, puis ouvrez la fenêtre des caméras NVR et cliquez sur le bouton **"+" (Ajouter)** sur la vignette de caméra souhaitée. Vous pouvez également permuter les positions des fenêtres en utilisant le menu contextuel du clic droit (*„Zamień miejscami”* / *„Permuter les fenêtres”*) de la fenêtre source, puis en cliquant sur la fenêtre cible.

### Boutons de la barre supérieure (barre d'outils supérieure)
La barre d'outils coulissante supérieure fournit un ensemble complet de boutons de navigation et de contrôle des applications :
1. **Fermer la fenêtre (bouton ✕ rouge)** : ferme la fenêtre active. Pour éviter les clics accidentels, il intercepte l'événement de fermeture et vous invite avec une boîte de dialogue pour confirmer la sortie de l'application.
2. **Bouton Épingler** : contrôle le comportement de masquage automatique de la barre d'outils supérieure. Lorsque la goupille pointe verticalement (état épinglé), la barre est verrouillée et reste visible en permanence. Lorsque l'épingle pivote de -45 degrés (état non épinglé), la barre glisse automatiquement vers le haut hors de vue lorsque la souris quitte sa zone.
3. **Plein écran (icône de flèches vertes)** : bascule instantanément la fenêtre active en mode plein écran et inversement. En mode plein écran, les flèches pointent vers l'intérieur (réduire) et en mode fenêtré, elles pointent vers l'extérieur (développer).
4. **Réduire (icône de réduction cyan)** : réduit la fenêtre de l'application dans la barre des tâches. La restaurer ramène la fenêtre à son état précédent exact (par exemple agrandie ou plein écran).
5. **⚙️ OPTIONS (OPCJE)** : bascule la fenêtre des options de configuration. Si la fenêtre est déjà ouverte, cliquer sur ce bouton la ferme.
6. **📺 NOUVELLE FENÊTRE (NOWE OKNO)** : ouvre un nouveau `Auxiliary Window` indépendant et entièrement configurable, parfait pour étendre la disposition de vos caméras sur plusieurs configurations de moniteur.
7. **ARCHIVE** : ouvre un `PlaybackWindow` vide (lecteur d'enregistrements) avec une chronologie et un calendrier actifs, permettant des sélections manuelles de flux et de canaux de caméra à partir de n'importe quel NVR configuré via la liste de la barre latérale.
8. **INSTRUCTIONS (INSTRUKCJA)** : ouvre cette fenêtre de manuel, chargeant la documentation utilisateur complète en anglais ou en polonais en fonction de vos paramètres régionaux actifs.
9. **📊Commutateur STATS (STATYSTYKI)** : commutateur à bascule pour faire glisser le panneau de surveillance des statistiques du système depuis le bord gauche de l'écran.
10. **Commutateur de verrouillage de grille (cadenas)** : commutateur qui, lorsqu'il est activé (surligné en orange vif), désactive les actions de redimensionnement de la grille sur les boutons de grille adjacents, protégeant ainsi la disposition de votre caméra active contre les modifications accidentelles.
11. **Sélecteurs de taille de grille (de 1 x 1 à 9 x 9)** : une rangée de neuf boutons qui vous permet de définir instantanément la structure des lignes et des colonnes de votre fenêtre d'affichage (d'une seule vue de caméra 1 x 1 jusqu'à 81 flux de caméra simultanés dans une disposition 9 x 9). La taille actuellement active est surlignée en orange vif.
12. **Plus d'options (menu Hamburger avec trois lignes)** : bouton ouvrant la boîte à outils coulissante `Layout & Grid Tools` pour un réglage avancé de la grille, des ajustements de géométrie et des options de débogage (détaillées ci-dessous).
13. **Boutons prédéfinis/Affichage** : boutons rendus dynamiquement sur le côté droit de la barre d'outils représentant vos dispositions prédéfinies configurées et visibles (par exemple *📹 NVR*, *View 1*, etc.). Cliquer sur un bouton change immédiatement la grille. La vue active se met en valeur dans une lumière turquoise vive.

### Personnalisation avancée de la grille et ratios (outils de mise en page et de grille)
L'ouverture du menu Hamburger (Plus d'options) fait apparaître une boîte à outils de mise en page spécialisée. Pour activer ses commandes :
1. **Déverrouiller le volet Outils** : activez le bouton "Déverrouiller le volet Outils" tout en haut. Il s'agit d'une mesure de sécurité explicite visant à empêcher toute modification accidentelle de mises en page complexes.
2. **Division de fenêtre personnalisée (F2 ou appuyer et maintenir)** : la boîte à outils affiche les boutons de division de grille de 1 x 1 à 9 x 9. Une fonctionnalité extrêmement avancée est la possibilité de **remplacer et modifier les tailles de division**. Si vous cliquez et maintenez n'importe quel bouton de la grille avec le bouton gauche de la souris (ou si vous le concentrez et appuyez sur **F2**), une zone de texte apparaît. Vous pouvez saisir n'importe quelle division personnalisée ou asymétrique (telle que `2x3`, `1x4`, etc.) et appuyer sur Entrée. Le bouton est instantanément reprogrammé et cliquer dessus applique votre mise en page personnalisée à la fenêtre principale.
3. **Rapports de géométrie** : permet de forcer l'affichage de la grille à des rapports d'aspect spécifiques :
   * **Rapport d'aspect 16:9** : verrouille et redimensionne le conteneur de grille au format grand écran 16:9 (standard pour les caméras IP modernes).
   * **Rapport d'aspect 4:3** : adapte le conteneur de grille au rapport 4:3 traditionnel (courant dans les anciennes caméras analogiques/IP).
4. **Opérations de grille (fusionner les cellules en surbrillance)** : accédez à la fonctionnalité de fusion asymétrique de cellules (détaillée dans la section 9.2).

---

## 6. Panneau de statistiques du système (Statistiques du système)

Coulissant depuis le bord gauche de l'écran Live View, ce panneau surveille la santé de l'ordinateur et la charge générée par l'application :
* **Paramètres surveillés** :
  * **CPU/RAM** : utilisation du processeur principal (en % de tous les cœurs) et de la RAM utilisée directement par le processus `kvision` et ses sous-processus de téléchargement associés.
  * **GPU / VRAM** : utilisation du cœur de la carte graphique (en %) et quantité de mémoire graphique VRAM occupée par le rendu et le décodage matériel (prend en charge la liste complète des processus GPU à l'aide de l'analyseur XML de `nvidia-smi`).
  * **RÉSEAU (Net)** : vitesse de transfert de téléchargement réelle de l'application à partir de tous les lecteurs en direct actifs, lecteurs d'archives et processus de téléchargement d'enregistrement.
* **Multithreading (Stutter-Free)** : la collecte de données de processus et GPU s'exécute sur un thread système distinct (`StatsWorker`). Cela évite tout micro-bégaiement dans le rendu vidéo (pas de perte d'image).
* **Fonctionnalité d'épinglage** : cliquer sur le bouton **"Épingler"** (icône d'épingle) verrouille le panneau dans son état développé.
* **Esthétique** : les graphiques présentent des bordures vert fluo lumineuses, un remplissage dégradé sous la courbe du graphique et une transparence d'arrière-plan équilibrée de 35 % pour garantir la lisibilité du texte.

---

## 7. Lecteur d'archives de lecture

Disponible en cliquant sur l’icône horloge/lecture à côté d’une caméra ou d’un enregistreur spécifique. Il permet la visualisation simultanée des enregistrements archivés de plusieurs caméras Hikvision en synchronisation permanente.

### Chronologie et contrôles :
* **Démarrage rapide (15 minutes en arrière)** : lors de l'ouverture de l'archive à partir de la vue en direct, le lecteur démarre automatiquement à partir d'un moment tombant **exactement 15 minutes avant l'heure actuelle du système** (au lieu de démarrer à minuit). Cela permet une visualisation immédiate d'un événement qui vient de se produire.
* **Navigation** : la timeline peut défiler vers la gauche et la droite en la faisant glisser avec le bouton gauche de la souris.
* **Zoom (mise à l'échelle)** : vous pouvez modifier en douceur l'échelle de la chronologie avec la molette de défilement de la souris (ou les boutons de zoom) – de l'affichage de la journée entière à une vue précise de 10 minutes.
* **Raccourcis de zoom rapide** : la barre de contrôle inférieure comporte des boutons d'icônes circulaires dédiés pour redimensionner instantanément la vue de la chronologie :
  * **Icône « 1 heure »** : permet d'effectuer un zoom avant sur la chronologie pour une inspection détaillée sur une période d'une heure.
  * **Icône « 8 heures »** : agrandit la chronologie pour afficher une période de 8 heures.
  * **Icône « 24 heures »** : réinitialise le zoom pour afficher la journée complète de 24 heures sur un seul écran.
  * **Icône Centre (Cible)** : centre immédiatement la chronologie de sorte que l'indicateur de lecture rouge soit exactement au milieu de l'écran (en remplacement de l'ancien bouton de texte).
* **Navigation par date (calendrier et jours)** : les commandes à côté de la date affichée permettent des sauts rapides :
  * Boutons **„<” (Jour précédent)** et **„>” (Jour suivant)** : vous permettent de reculer ou d'avancer instantanément de 24 heures sans ouvrir la boîte de dialogue du calendrier.
  * **Icône de calendrier** : ouvre la fenêtre contextuelle du calendrier pour sélectionner une date spécifique.
  * **Icône Actualiser** : force une nouvelle recherche d'enregistrements. En cliquant dessus, le cache local des segments de disponibilité d'enregistrement est balayé pour tous les canaux actifs et soumet de nouvelles requêtes au NVR, ce qui est très utile pour charger des fichiers enregistrés il y a quelques instants (en remplacement de l'ancien bouton de texte).
  * **Icône Aujourd'hui (date/numéro d'aujourd'hui)** : revient instantanément au jour actuel (en remplaçant l'ancien bouton de texte).
* **Raccourcis de vitesse de lecture** :
  * **Icônes « 1x », « 2x » et « 4x »** : modifiez instantanément le multiplicateur de vitesse de lecture.
* **Boutons de saut du magnétoscope** :
  * **Icônes « 15 », « 45 » et « 60 » avec flèches circulaires** : vous permettent d'avancer ou de reculer rapidement du nombre de secondes spécifié.
* **Barres de disponibilité de l'enregistrement** : des barres colorées représentant les segments vidéo trouvés sur le disque de l'enregistreur sont affichées sous la chronologie. Un système de mise en cache les empêche de scintiller lors du déplacement.
* **Suivi automatique (suivi de l'indicateur)** : l'indicateur de lecture (ligne rouge verticale) est surveillé en permanence. Si l’indicateur sort de la plage visible de la chronologie, la vue défilera automatiquement pour le centrer. Cette option est intelligemment verrouillée lors du déplacement manuel de l'indicateur par l'utilisateur.

### Panneau latéral de la caméra dans la fenêtre de lecture
Une liste latérale verticale sur le bord droit du lecteur répertorie tous les NVR configurés et leurs canaux de caméra :
* **Basculer les chaînes** : cliquer sur n'importe quelle chaîne de caméra de la liste l'ajoute en tant qu'emplacement de lecture actif sur la timeline (générant ainsi un lecteur vidéo). Cliquez à nouveau dessus pour supprimer la chaîne.
* **Menu contextuel de la chaîne** : un clic droit sur une machine à sous vidéo active dans la grille de lecture ouvre un menu pour :
  * Basculer la qualité vidéo (flux principal / flux secondaire).
  * Fermez/supprimez le lecteur actif de la lecture des archives.

---

## 8. Téléchargement d'enregistrements (téléchargeur)

À partir de la fenêtre Playback Archive, vous pouvez télécharger des segments sélectionnés d'enregistrements directement sur le lecteur de votre ordinateur sous forme de fichiers MP4 :
1. Cliquez sur l'icône de téléchargement (flèche vers le bas) à côté de la caméra sélectionnée.
2. Sélectionnez la plage horaire (début et fin de l'enregistrement).
3. Sélectionnez l'emplacement d'enregistrement du fichier de destination.
4. Cliquez sur **Télécharger**.

### Fonctionnalités de téléchargement avancées :
* **Téléchargement séquentiel de segments (parties de 1 Go)** : le programme divise automatiquement votre requête de plage temporelle en segments de fichiers physiques (environ 1 Go chacun sur le lecteur NVR) et les télécharge et les convertit un par un (en utilisant des fichiers temporaires `.pspart` qui sont convertis directement au format `.mp4`). Cela garantit des téléchargements très stables sur des plages de longue durée sans débordement de mémoire ni blocage de la conversion FFmpeg.
* **Visualisation de la progression globale** : la barre de progression (couleur bleu sarcelle vif) affiche la progression globale du téléchargement de la caméra sur tous les segments. Le texte d'état superposé sur la barre de progression affiche la partie actuelle et les pourcentages, par exemple `Downloading part 1 of 3... 45% (Overall: 15%)`, avec un style de contour pour garantir la lisibilité sur n'importe quel arrière-plan.
* **Nettoyage IP des noms de fichiers** : les noms de fichiers vidéo (et les instantanés en direct/d'archives) sont automatiquement supprimés des adresses IP du NVR/DVR pour les garder propres et lisibles par l'homme (par exemple `4_Wejscie_glowne_2026-06-15.mp4` au lieu de `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Paramètres avancés et personnalisation dans la fenêtre Options

La fenêtre d'options et de configuration (`SideBar`) est composée de six onglets dédiés :

### 1. Détails de la fenêtre (icône du moniteur)
Affiche les paramètres avancés de la tuile de grille actuellement sélectionnée. Vous permet de :
* Saisissez une **URL de flux principal** personnalisée (RTSP/ONVIF) et une **URL de sauvegarde secondaire** pour les configurations manuelles.
* Activer/désactiver le canal audio du flux de caméra sélectionné.
* Saisissez les remplacements avancés du décodeur dans la zone de texte **Remplacement des options FFmpeg**.
> [!ASTUCE]
> Pour une connexion de flux la plus rapide et une stabilité maximale sur RTSP, les paramètres recommandés sont :
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Outils de mise en page et de grille (icône de curseurs)
Options avancées de personnalisation de la grille d'écran :
* Basculement rapide pour le mode plein écran.
* **Fusion de cellules asymétriques (fusionner les cellules en surbrillance)** : un éditeur de mise en page très avancé. Maintenez **Ctrl** ou **Maj** et cliquez pour sélectionner plusieurs vignettes adjacentes sur la grille, ou utilisez votre clavier en maintenant **Maj** et en naviguant avec les **Touches fléchées**, puis cliquez sur "Fusionner les cellules en surbrillance" pour les fusionner dans une seule fenêtre plus grande. Cela vous permet de créer des conceptions de grille asymétriques entièrement personnalisées (par exemple, un énorme panneau de caméra entouré de flux plus petits).

### 3. Enregistreurs (icône du serveur)
Gestionnaire de configuration complet pour les connexions aux appareils Hikvision NVR/DVR (décrit en détail dans la section 3).

### 4. Préréglages (icône étoile)
Gestionnaire de vos dispositions de grille enregistrées et des affectations de caméras. Permet de créer des modèles de grille vides, de modifier leur ordre, de basculer leur visibilité dans la barre supérieure (via le commutateur "Visible") ou de les activer dans la fenêtre actuelle.

### 5. Paramètres (icône d'engrenage)
Permet d'ajuster les paramètres globaux de l'application :
* **Autoriser l'exécution de plusieurs instances** : Cocher cette case permet de lancer plusieurs copies parallèles du processus KVision (par défaut, elle limite les exécutions à une seule instance active).
* **Paramètres de réduction automatique** : personnalise le timing de l'animation coulissante pour la barre supérieure et le panneau de statistiques.
* **Autoriser l'échange de fenêtres** : La case à cocher *"Autoriser l'échange de fenêtres"* vous permet de réorganiser les positions de la caméra sur la grille à la volée (clic droit sur la vignette source -> Choisissez "Échanger les fenêtres" -> Cliquez gauche sur la vignette cible).
* **Autorisations par clic droit** : permet de verrouiller/déverrouiller les commandes interactives dans le menu contextuel du clic droit (Activer le menu contextuel, Autoriser l'échange de fenêtres, Activer l'option "Supprimer la caméra", Autoriser la modification des paramètres de la fenêtre, Activer la sélection de la qualité principale/secondaire du flux).
* **Activation automatique** : réactive automatiquement le flux audio de la fenêtre active lors du passage en mode plein écran.
* **Masquer le curseur en plein écran** : la case à cocher *« Masquer le curseur en mode plein écran »* masque automatiquement le curseur de la souris après une brève période d'inactivité pendant l'affichage en plein écran pour garantir une vue dégagée.
* **Sélection de la langue** : change instantanément la traduction de l'interface (par défaut du système, polonais, anglais).
* **Préférences de l'interface utilisateur** : masquer/afficher les étiquettes d'état de la fenêtre ou les badges de contrôle (par exemple, masquer automatiquement les superpositions de contrôle dans le coin inférieur droit des vignettes, sauf en cas de survol).
* **Options FFmpeg par défaut et mise à jour groupée** : permet de configurer les options FFmpeg globales appliquées aux nouvelles fenêtres (recommandé : `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[RECOMMANDATION]** Si vous migrez depuis une ancienne version de KVision (antérieure à la v2.4.5), il est fortement recommandé de remplacer `-analyzeduration 0` par `-analyzeduration 100000` dans les paramètres globaux et de cliquer sur « Mettre à jour toutes les caméras ». La définition de `0` sur des flux sans piste audio entraîne des retards de commutation car FFmpeg se bloquera pendant un délai d'attente codé en dur de 5 secondes en attente des paquets audio. La définition d'une valeur très faible (par exemple, 100 000 microsecondes = 0,1 s) résout complètement ce problème tout en conservant une commutation instantanée.
  * **Bouton Mettre à jour toutes les caméras** : Le bouton *„Zaktualizuj wszystkie kamery”* applique ces options globales à toutes les fenêtres configurées.
  * **Indicateurs de faible latence (`nobuffer`, `low_delay`)** :
    * `-fflags nobuffer` désactive la mise en mémoire tampon interne des paquets du démultiplexeur pour éliminer le décalage de diffusion au fil du temps, mais peut provoquer un bégaiement si votre connexion réseau à la caméra est instable.
    * `-flags low_delay` indique au décodeur de produire des images immédiatement, mais peut provoquer de brefs artefacts/maculages dans les flux qui utilisent des images B lors de mouvements rapides.
  * **case à cocher Remplacer** : vous pouvez exclure des fenêtres spécifiques des mises à jour globales ou des valeurs par défaut dynamiques en cochant **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** dans la boîte de dialogue Paramètres de fenêtre individuelle. Utile pour dépanner les caméras saccadées.


### 6. Journal des modifications (icône horloge/document)
Présente une chronologie interactive montrant l'historique complet des versions, les mises à jour, les corrections de bugs et les ajouts de fonctionnalités de KVision, vous garantissant ainsi un accès direct aux détails des mises à jour du programme.

---

## 10. Raccourcis clavier et commandes de la souris

### Raccourcis clavier :
| Clé / Raccourci | Actions |
|---|---|
| **F** / **F11** | Basculez en mode plein écran. |
| **M** | Couper/activer le son (fonctionne pour la caméra active avec audio). |
| **Espace** | Lire/mettre en pause la lecture dans la fenêtre Playback Archive. |
| **Alt + 1** à **Alt + 9** | Passage rapide à un préréglage/mise en page aux indices 1 à 9. |
| **Alt + Flèche gauche** | Passage rapide au préréglage/mise en page précédent dans la collection. |
| **Alt + Flèche droite** | Passage rapide au préréglage/mise en page suivant de la collection. |
| **Touches fléchées (Haut/Bas/Gauche/Droite)** | Naviguez et déplacez la mise au point/sélection active entre les fenêtres de caméra. |
| **Maj + Flèches** | Sélectionnez simultanément plusieurs fenêtres de caméra adjacentes (utilisées pour la fusion de cellules, etc.). |
| **Ctrl + N** | Ouvrez une nouvelle fenêtre auxiliaire indépendante. |
| **+** / **-** | Zoom avant/Zoom arrière (caméras Hikvision compatibles PTZ). |
| **Échap** | Quittez le mode Plein écran / annulez la sélection de fenêtre active. |

### Interaction avec la souris :
* **Bouton gauche de la souris** :
  * **Double-cliquez** sur une fenêtre d'affichage de caméra dans la grille pour la maximiser en plein écran. Un autre double-clic restaure la vue grille.
  * Faites glisser la chronologie dans la fenêtre Lecture pour naviguer.
* **Bouton droit de la souris (Menu contextuel)** :
  * Ouvre un menu de paramètres rapides pour la fenêtre sélectionnée (permet de supprimer la caméra de la grille, de passer d'un flux principal à un flux secondaire ou d'accéder à des paramètres d'affichage individuels).
* **Molette de défilement de la souris** :
  * Ajuste l'échelle (Zoom) de la chronologie dans le lecteur d'archives de lecture.

---

## 11. Prise d'instantanés et configuration du chemin

L'application vous permet de capturer rapidement des instantanés de haute qualité à partir de n'importe quelle fenêtre d'affichage de la caméra en mode Live View et Playback Archive.

### Prendre des instantanés :
1. Un bouton de superposition d'icône de caméra est disponible dans le coin inférieur droit de chaque fenêtre (détaillé dans la section 4).
2. Cliquer sur l'icône de l'appareil photo capture l'image et l'enregistre sous forme d'image JPEG (qualité 98 - pratiquement sans perte).
3. Une capture réussie est confirmée par l'icône de l'appareil photo clignotant en orange (`#ff7a00`) pendant exactement 1 seconde.
4. **Pleine résolution** : en mode Playback Archive, les instantanés sont enregistrés dans la pleine résolution source native du flux directement à partir du tampon d'image du décodeur, quelle que soit la taille de la fenêtre d'affichage active à l'écran ou la mise à l'échelle de l'affichage.

### Enregistrement des configurations de chemin :
1. Accédez à l'onglet **Paramètres** (icône d'engrenage dans la fenêtre des options).
2. Sous la section **Sauvegarde** ("Zapis"), vous pouvez configurer les chemins par défaut :
   * **Chemin des instantanés par défaut** : dossier dans lequel les instantanés seront enregistrés (par défaut `~/Obrazy/CCTV`).
   * **Chemin des enregistrements par défaut** : dossier dans lequel les vidéos MP4 téléchargées seront enregistrées (par défaut `~/Wideo/CCTV`).
3. Cliquer sur le bouton du navigateur `...` ouvre le sélecteur de dossier natif de votre système d'exploitation (Breeze dans KDE).
4. **Comportement du bouton du navigateur** : le sélecteur de répertoire s'ouvre précisément au chemin saisi dans le champ de texte (s'il existe). Si le champ est vide, invalide ou pointe vers un dossier auquel vous n'avez pas accès, la boîte de dialogue revient et s'ouvre dans votre répertoire personnel (`~/`).

### Paramètres de l'interface utilisateur (UI) :
1. Accédez à l'onglet **Paramètres** (icône d'engrenage dans la fenêtre des options) ou ouvrez la fenêtre **Options** ("Opcje").
2. Dans la section **Paramètres de l'interface utilisateur**, vous pouvez personnaliser la visibilité des éléments superposés sur les kafelki/viewports de la caméra :
   * **Afficher l'état de la chaîne dans le coin supérieur gauche de la fenêtre** (activé par défaut) : affiche les informations sur le chargement, la lecture et l'état de la connexion du flux.
   * **Afficher les informations sur la caméra dans le coin inférieur gauche de la fenêtre** (activé par défaut) : affiche le nom de la caméra récupéré de l'enregistreur Hikvision.
   * **Afficher les icônes de contrôle dans le coin inférieur droit de la fenêtre uniquement lors du survol** (activé par défaut) : masque automatiquement le panneau des boutons de commande (instantané, archive, pixel à pixel 1:1, zoom régional) lorsque le curseur de la souris se trouve en dehors de la fenêtre d'affichage de la caméra spécifique. Les icônes apparaissent instantanément dès que vous déplacez votre souris sur la fenêtre (aucun clic requis) et disparaissent en quittant, maximisant la visibilité des flux de votre caméra.
   * **Afficher les champs d'informations uniquement en survol** (désactivé par défaut) : option analogue qui masque l'état en haut à gauche et le nom en bas à gauche des fenêtres, affichant un flux de caméra complètement propre à moins que le curseur ne soit déplacé sur cette vignette de caméra spécifique.
