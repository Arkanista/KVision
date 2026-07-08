# Manual de usuario para KVision

> [!NOTA]
> Este manual de instrucciones ha sido traducido y formateado automáticamente con la ayuda de Inteligencia Artificial (IA).

**KVision** es una aplicación de escritorio avanzada de clase VMS (Sistema de gestión de video) diseñada para la visualización simultánea de transmisiones de video en vivo (RTSP/ONVIF) y la integración con grabadoras NVR/DVR de Hikvision (tanto en modo en vivo como en modo de archivo de reproducción).

El programa ha sido optimizado para brindar estabilidad, funcionamiento fluido (60 FPS) y consumo mínimo de recursos del sistema.

---

## Tabla de contenidos
1. [Descripción de las acciones del botón](#1-description-of-button-actions)
2. [Instalación y lanzamiento](#2-installation-and-launching)
3. [Administración de grabadoras NVR/DVR](#3-managing-nvrdvr-recorders)
4. [Vista en vivo y superposiciones de ventana gráfica](#4-live-view-and-viewport-overlays)
5. [Diseños de pantalla, ajustes preestablecidos y barra de herramientas](#5-screen-layouts-presets-and-toolbar)
6. [Panel de estadísticas del sistema (Estadísticas del sistema)](#6-system-statistics-panel-system-stats)
7. [Reproductor de archivo de reproducción](#7-playback-archive-player)
8. [Descargando grabaciones (Descargador)](#8-downloading-recordings-downloader)
9. [Configuración avanzada y personalización en la ventana de opciones](#9-advanced-settings-and-customization-in-options-window)
10. [Atajos de teclado y controles del mouse](#10-keyboard-shortcuts-and-mouse-controls)
11. [Tomar instantáneas y configurar la ruta](#11-taking-snapshots-and-path-configuration)

---

## 1. Descripción de las acciones de los botones

Esta sección describe el significado de todos los iconos gráficos y botones utilizados en la aplicación.

### Barra de herramientas superior
* {ICON:quit} **Cerrar ventana**: solicita confirmación y cierra la ventana o aplicación activa.
* {ICON:pin} **Pin Bar**: bloquea la barra superior en un estado expandido o habilita el colapso automático.
* {ICON:fullscreen} **Pantalla completa**: cambia la ventana activa al modo de pantalla completa.
* {ICON:minimize} **Minimizar**: Minimiza la ventana de la aplicación a la barra de tareas del sistema.
* {ICON:options} **Opciones**: Abre o cierra la ventana de opciones de configuración (configuraciones y grabadores).
* {ICON:new_window} **Nueva ventana**: abre una ventana auxiliar nueva e independiente para las transmisiones de la cámara.
* {ICON:archive} **Archivo**: abre la ventana de archivo de grabaciones de reproducción (línea de tiempo y calendario).
* {ICON:instructions} **Instrucciones**: Abre este manual de usuario y la ventana de asistencia técnica.
* {ICON:stats} **Estadísticas**: alterna el panel deslizante de estadísticas del sistema (CPU, RAM, GPU, Net).
* {ICON:lock} **Bloqueo de cuadrícula**: deshabilita los ajustes de división de la cuadrícula para proteger su diseño activo.
* {ICON:hamburger} **Más opciones**: abre la caja de herramientas deslizante para tamaños de división avanzados, proporciones y combinación de celdas.

### Superposiciones de ventanas gráficas (cámaras)
* {ICON:snapshot} **Instantánea**: captura una imagen de resolución completa sin pérdidas y la guarda como un archivo JPEG.
* {ICON:play} **Archivo de cámara**: inicia la ventana de reproducción de la línea de tiempo para esta cámara (15 minutos hacia atrás).
* {ICON:quick_play} **Reproducción rápida (minirreproductor)**: inicia una reproducción de archivo en la ventana gráfica de los últimos 30 minutos, lo que le permite revisar rápidamente imágenes recientes directamente en el mosaico de la cámara sin salir de la vista en vivo.
* {ICON:grid_1x1} **Pruebe 1:1**: muestra la transmisión de video en su resolución nativa original sin estirarse.
* {ICON:zoom_in} **Zoom interactivo**: alterna la ampliación al hacer clic y arrastrar para una región de marco seleccionada.
* {ICON:zoom_out} **Restablecer zoom**: restablece la ampliación digital y restaura el campo de visión completo de la cámara.
* {ICON:speaker_unmute} **Silenciar audio**: representa una transmisión de audio no silenciada; al hacer clic en él se silencia la transmisión.
* {ICON:speaker_mute} **Activar audio**: representa una transmisión de audio silenciada; al hacer clic en él se reactiva la transmisión.

### Controles de la ventana de reproducción

**Controles de la barra superior:**
* {ICON:close} **Cerrar**: cierra la ventana del reproductor de archivos de reproducción.
* {ICON:pin} **Pin Bar**: bloquea la barra superior en un estado expandido o habilita el colapso automático.
* {ICON:fullscreen} **Pantalla completa**: alterna la ventana de reproducción al modo de pantalla completa.
* {ICON:sidebar} **Mostrar/Ocultar barra lateral**: alterna la visibilidad de la barra lateral izquierda que contiene cámaras y grabadoras.
* {ICON:timeline_show} / {ICON:timeline_hide} **Mostrar/Ocultar línea de tiempo**: muestra u oculta el panel inferior que contiene la línea de tiempo y los controles de reproducción.
* {ICON:video_folder} **Carpeta de vídeos**: abre la carpeta del sistema local que contiene los clips de vídeo descargados.
* {ICON:photo_folder} **Carpeta de instantáneas**: abre la carpeta del sistema local que contiene las instantáneas capturadas.
* botones de cuadrícula `1x1`, `1x2`, `2x1`, `2x2`: cambia el diseño de visualización de la cámara de la ventana de reproducción a 1, 2 (vertical/horizontal) o 4 vistas simultáneas.

**Controles de la barra inferior y de la línea de tiempo:**
* {ICON:prev_day} **Día anterior**: navega a las grabaciones del día calendario anterior.
* {ICON:calendar_select} **Selector de fecha**: abre un cuadro de diálogo de calendario para seleccionar una fecha específica para la reproducción.
* {ICON:next_day} **Día siguiente**: navega a las grabaciones del siguiente día calendario.
* {ICON:today} **Hoy**: cambia instantáneamente el foco de reproducción al día calendario actual.
* {ICON:refresh_recordings} **Actualizar grabaciones**: actualiza y vuelve a consultar los segmentos de grabación disponibles desde el dispositivo.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Preajustes de zoom de línea de tiempo**: escala la ventana visible de la línea de tiempo (a 1 hora, 8 horas o 24 horas) para una navegación de alta precisión.
* {ICON:timeline_center} **Centrar línea de tiempo**: centra la vista de la línea de tiempo con precisión alrededor de la marca de tiempo de reproducción actual.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Velocidad de reproducción**: ajusta el multiplicador de reproducción de video (velocidad estándar 1x, reproducción acelerada 2x o reproducción rápida 4x).
* {ICON:download} **Descargar**: abre la herramienta de descarga para exportar un segmento de video definido desde el dispositivo.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Saltar hacia atrás**: rebobina la marca de tiempo de reproducción 60, 45 o 15 segundos.
* {ICON:play} / {ICON:pause} **Reproducir/Pausar**: inicia o pausa la reproducción de la secuencia de vídeo del archivo.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **Saltar hacia adelante**: avanza la marca de tiempo de reproducción en 15, 45 o 60 segundos.

**Otros íconos generales y de diagnóstico:**
* {ICON:calendar} **Calendario**: Representa configuraciones de calendario/programación.
* {ICON:clock} **Hora**: Representa indicadores de estado temporal o de reloj.
* {ICON:zoom} **Zoom**: Representa configuraciones de escala o zoom digital.
* {ICON:timeline_toggle} **Alternar línea de tiempo**: representa alternar o actualizar vistas cronológicas.
* {ICON:trash} **Eliminar**: elimina de forma segura grabadoras o diseños configurados con confirmación.
* {ICON:warning} **Advertencia**: Se muestra en cuadros de diálogo para acciones irreversibles o advertencias de eliminación.

---

## 2. Instalación y lanzamiento

### Instalación en Arch Linux (Pacman)
Para instalar el programa desde el paquete binario preparado, vaya al directorio `packaging/arch/` y ejecute:
```bash
sudo pacman -U kvision-2.6.2-1-x86_64.pkg.tar.zst
```
El paquete instalará automáticamente el programa, el archivo de activación `.desktop` y las bibliotecas SDK de Hikvision requeridas en la ruta del sistema `/usr/lib/kvision`.

### Compilación manual (desde el código fuente)
Si desea compilar el programa manualmente (por ejemplo, en otra distribución de Linux) en lugar de utilizar el paquete ya preparado:

1. Instale las dependencias de compilación y tiempo de ejecución necesarias utilizando su administrador de paquetes. Para Arch Linux/CachyOS:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Configure el proyecto usando CMake:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Compile el código:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Instale la aplicación en el sistema:
   ```bash
   sudo cmake --install build
   ```

### Lanzamiento
El programa se puede iniciar desde el menú del sistema o escribiendo en la terminal:
```bash
kvision
```

### Solución de problemas de escalado del sistema (KDE Plasma)

A partir de la versión 2.4.4, KVision detecta automáticamente y aplica correctamente el escalamiento fraccional del escritorio (por ejemplo, 125%, 145%, 150%) configurado en la configuración de KDE Plasma al aplicar políticas nativas de transferencia de alto DPI en Qt. La interfaz de usuario ahora debería escalarse correctamente desde el primer momento, sin ninguna intervención manual.

#### Soporte nativo de Wayland

Para garantizar la mejor experiencia de escalado y rendimiento en Wayland, asegúrese de tener el paquete opcional `qt5-wayland` instalado en su sistema. Esto permite que KVision se ejecute de forma nativa en Wayland en lugar de recurrir a XWayland.

Para Arch Linux/Manjaro/CachyOS:
```bash
sudo pacman -S qt5-wayland
```

Para Debian/Ubuntu/Linux Mint:
```bash
sudo apt install qtwayland5
```

#### Anulación de escalado manual (heredado/retroceso)

Si está ejecutando una versión anterior, una configuración inusual o simplemente desea forzar manualmente un factor de escala diferente al del resto del sistema, aún puede anular el escalado de la aplicación utilizando variables de entorno.

Por ejemplo, para forzar el escalado **150%**, inicie la aplicación desde la terminal con:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(Puede aplicar esto permanentemente editando el iniciador de aplicaciones `kvision.desktop` en el editor de menú de KDE y agregando estas variables al campo "Variables de entorno").*

---

## 3. Gestión de grabadoras NVR/DVR

Para configurar la conexión a una grabadora Hikvision:
1. Abra la ventana de opciones y vaya a la pestaña **Grabadoras** (icono del servidor).
2. Ingrese los detalles de acceso al dispositivo:
   * **Dirección IP**: La dirección de red de la grabadora.
   * **Puerto**: el puerto de red del SDK (el valor predeterminado es `8000`).
   * **Nombre de usuario**: nombre de usuario (por ejemplo, `admin`).
   * **Contraseña**: Contraseña para acceder al grabador.
3. Haga clic en **Conectar y descubrir** (o **Guardar y actualizar**).
4. Tras una conexión exitosa, la aplicación detectará automáticamente todas las cámaras (canales) activos conectados al NVR/DVR y las agregará a la lista.
5. Al hacer clic en el botón **Generar cuadrícula**, se creará automáticamente un diseño de ventana gráfica (preestablecido) que contiene todas las cámaras activas de ese NVR en un diseño de cuadrícula óptimo.
6. **Visualización de listas de cámaras (NvrCamerasWindow):**: al hacer clic en el botón del icono del monitor de la computadora en la tarjeta de cualquier grabadora, se abre una ventana dedicada que muestra todos los canales de cámara detectados como mosaicos interactivos.
7. **Generación de miniaturas (Generar miniaturas)**: En la ventana de lista de cámaras NVR, hay disponible un botón *«Generar miniaturas»*. Al hacer clic en él, se ordena a la aplicación que extraiga fotogramas individuales del Sub Stream de cada canal en segundo plano, configurándolos como miniaturas de fondo del mosaico. Esto proporciona una vista previa visual rápida de cada cámara sin iniciar transmisiones en vivo completas.
8. **Función de hacer clic y agregar**: la aplicación no admite arrastrar mosaicos (arrastrar y soltar) desde la ventana de la lista de cámaras a la cuadrícula principal. La asignación de cámaras se realiza de una manera simple y confiable: primero haga clic con el botón izquierdo en cualquier mosaico de la ventana gráfica en la cuadrícula de la pantalla principal para seleccionarlo (se resaltará con un borde brillante), luego haga clic en el botón verde **"+" (Asignar a la ventana gráfica activa)** en el mosaico de la cámara deseada en la ventana de lista de cámaras NVR. La transmisión se cargará instantáneamente en esa ranura.
9. **Estado de sesión del SDK (indicador de punto)**: junto a la IP de cada grabadora en la lista, hay un punto de estado de color:
   * **Verde (INICIAR SESIÓN)**: representa una sesión activa del SDK de Hikvision, que es necesaria para el control PTZ, las solicitudes de archivo de la línea de tiempo y la descarga.
   * **Rojo (NO INICIAR SESIÓN)**: actualmente no hay ninguna sesión de SDK activa establecida (por ejemplo, antes de la primera solicitud de SDK o después del cierre de sesión manual/automático). Tenga en cuenta que las transmisiones en vivo RTSP de la cámara continuarán reproduciéndose independientemente del estado de la sesión del SDK.
10. **Cambio de nombre de cámara local**: en cualquier mosaico de cámara en la lista de cámaras NVR, haga clic en el icono **Editar** (lápiz). Esto abre un cuadro de diálogo que le permite establecer un nombre personalizado para la cámara. Este nombre se guarda localmente y se actualiza instantáneamente en los reproductores en vivo, la línea de tiempo y las vistas de mosaicos sin modificar el dispositivo NVR físico. Puede restablecerlo al nombre predeterminado en cualquier momento.
11. **Eliminar una grabadora de la lista**: al lado de cada grabadora configurada en la lista, hay un botón rojo de papelera. Al hacer clic en él, se inicia un protocolo de seguridad de dos etapas diseñado para evitar la eliminación accidental:
    * **Paso 1 (Confirmación)**: Aparece un cuadro de diálogo titulado *“Confirmar eliminación de NVR”* que le pregunta si está seguro de que desea eliminar la grabadora.
    * **Paso 2 (Advertencia)**: Aparece un segundo cuadro de diálogo de advertencia titulado *“¡Advertencia!”*, que le pregunta si está absolutamente seguro y es consciente de lo que está haciendo.
    * **Efecto de eliminación**: al aceptar la segunda advertencia, el programa cierra sesión en ese NVR en segundo plano, elimina su entrada de la configuración de la aplicación y **barre automáticamente la lista de diseños preestablecidos**, eliminando todas las cuadrículas dinámicas generadas para este dispositivo NVR.

---

## 4. Vista en vivo y superposiciones de ventanas gráficas

La ventana principal del programa muestra la transmisión en vivo:
* **Camera Grid**: muestra transmisiones RTSP o feeds directamente desde el SDK de Hikvision.
* **Selección de calidad de transmisión**: al hacer clic con el botón derecho en la ventana gráfica de una cámara, puede seleccionar la **transmisión principal** para obtener la resolución más alta o la **transmisión secundaria** para reducir la carga de la red y la tarjeta gráfica.
* **Alternar pantalla completa con doble clic**: al hacer doble clic con el botón izquierdo del mouse en cualquier ventana gráfica de la cámara, se maximiza instantáneamente para llenar toda el área activa de la ventana (pantalla completa de una sola ventana gráfica). Al hacer doble clic nuevamente se restaura el diseño de cuadrícula multicámara original.
* **Ocultar automáticamente la barra superior**: la barra de herramientas de opciones superior (topToolBar) puede contraerse automáticamente al borde superior de la pantalla cuando el cursor del mouse sale de su área (esta opción se puede configurar en Configuración -> *"Colapsar automáticamente la barra superior"* o directamente usando el ícono de pin en la barra superior).
* **Ventanas auxiliares y de monitores múltiples**: puede abrir ventanas adicionales (auxiliares) independientes para ejecutar diferentes diseños de cuadrícula simultáneamente en múltiples pantallas o monitores. Para abrir una nueva ventana, utilice el método abreviado de teclado `Ctrl+N` o haga clic en el botón **"Nueva ventana"** en la barra de herramientas superior deslizable. Cada ventana se puede configurar con su propio tamaño de cuadrícula y diseño preestablecido seleccionado. Para garantizar la máxima estabilidad en configuraciones de varios monitores, todas las ventanas se inician estrictamente centradas en la pantalla principal al 90% de su resolución.

### Botones de superposición de ventana gráfica
En la esquina inferior derecha de cada mosaico/ventana gráfica de la cámara, se muestra un panel de control con cinco íconos funcionales al pasar el cursor del mouse sobre él (según las preferencias de la interfaz de usuario):
1. **Icono de cámara (instantánea):** le permite tomar una captura de pantalla de la transmisión de la cámara. La instantánea se guarda en la resolución nativa completa de la transmisión directamente desde el búfer de cuadros del decodificador, evitando pérdidas debido al tamaño actual del mosaico de la ventana gráfica o la escala de resolución de la pantalla. El guardado exitoso de la instantánea se confirma cuando el ícono de la cámara parpadea en naranja (`#ff7a00`) durante exactamente 1 segundo.
2. **Icono de reproducción (Archivo):** se utiliza para abrir rápidamente el archivo de grabaciones. Al hacer clic en este botón, se inicia automáticamente la línea de tiempo `PlaybackWindow` para esta cámara específica, iniciando la reproducción **exactamente 15 minutos antes de la hora actual del sistema** (un desplazamiento rápido y conveniente hacia atrás).
3. **Icono de flecha circular (reproducción rápida/minirreproductor):** activa una reproducción rápida en la ventana gráfica de las grabaciones del archivo de la cámara de los últimos 30 minutos directamente dentro del mosaico de la cámara sin salir de la cuadrícula en vivo ni abrir la ventana de archivo completa.
   * **Panel de control**: cuando está activo, aparece un panel de control deslizante en la parte inferior de la ventana gráfica que contiene:
     * **Reproducir/Pausar**: pausa o reanuda la transmisión de reproducción.
     * **Visualización de hora y desplazamiento**: muestra la marca de tiempo de reproducción actual y su antigüedad relativa en comparación con el tiempo real (por ejemplo, `-12:34` representa hace 12 minutos y 34 segundos).
     * **Control deslizante de línea de tiempo interactiva**: permite hacer clic o arrastrar para buscar cualquier lugar dentro del búfer de 30 minutos. Los segmentos de grabación disponibles están resaltados con un fondo verde azulado y un cabezal de reproducción rojo marca la posición actual.
     * **Multiplicador de velocidad**: alterna entre velocidades de reproducción (`1x`, `2x` y `4x`) para escanear el metraje rápidamente.
     * **Cerrar (✕)**: cierra el minirreproductor y regresa instantáneamente la ventana gráfica a la transmisión en vivo.
   * **Compatibilidad con zoom panorámico**: al igual que en la vista en vivo, puedes usar la herramienta de lupa para acercar una región del minirreproductor, o mantener presionado el botón central del mouse y arrastrar para desplazarte.
4. **Icono 1:1 (escala nativa)**: alterna el modo de visualización de vídeo de píxel a píxel. Cuando está habilitado, el vídeo no se estira ni se distorsiona para llenar los límites del mosaico, sino que se centra y se muestra en su resolución nativa original. Cuando este modo está activo, el fondo del botón y el texto "1:1" se resaltan en una brillante luz de neón color turquesa.
5. **Icono de lupa (zoom interactivo)**: le permite ampliar cualquier región específica de la transmisión de video:
   * **Activación**: Al hacer clic en el icono, éste cambia a un estado activo (resaltado en turquesa). El cursor cambia de forma y una información sobre herramientas indica: *“Haga clic y arrastre en la transmisión de la cámara para hacer zoom”*.
   * **Operación**: haga clic con el botón izquierdo y arrastre una región de marco rectangular sobre la transmisión en vivo. La ventana gráfica recortará y escalará automáticamente el área seleccionada para llenar todo el mosaico.
     * **Zoom proporcional**: mantenga presionada la tecla **Mayús** mientras dibuja el rectángulo de zoom para forzar que la selección se bloquee en una relación de aspecto de 16:9, estrictamente restringida a los límites de la ventana gráfica.
     * **Desplazamiento de la imagen ampliada (Pan Zoom)**: una vez ampliado, puede mantener presionado el **botón central del mouse (rueda de desplazamiento)** y arrastrar el cursor para desplazarse libremente por la vista ampliada alrededor del campo de visión del video. Esto funciona en la vista en vivo, el archivo de reproducción y el minirreproductor.
   * **Restablecer**: cuando se hace zoom, el ícono de la lupa cambia de ícono (borde rojo con un signo menos). Al hacer clic en él, se restablece inmediatamente el zoom y se vuelve a la transmisión completa de la cámara.

---

## 5. Diseños de pantalla, ajustes preestablecidos y barra de herramientas

Los diseños le permiten organizar la disposición de las cámaras en la pantalla. Desde la pestaña **Presets** (icono de estrella) puedes:
* **Crear nuevos ajustes preestablecidos**: agregue su propio diseño con cualquier configuración de columnas y filas (por ejemplo, 2x2, 3x3, 4x4).
* **Asignar cámaras**: haga clic en una ventana gráfica en el diseño de cuadrícula para seleccionarla, luego abra la ventana de cámaras NVR y haga clic en el botón **"+" (Agregar)** en el mosaico de la cámara deseada. También puede intercambiar posiciones de ventana gráfica usando el menú contextual del botón derecho (*„Zamień miejscami”* / *“Cambiar ventanas gráficas”*) de la ventana gráfica de origen y luego haciendo clic en la ventana gráfica de destino.

### Botones de la barra superior (barra de herramientas superior)
La barra de herramientas deslizante superior proporciona un conjunto completo de botones de navegación y control de aplicaciones:
1. **Cerrar ventana (botón rojo ✕)**: cierra la ventana activa. Para evitar clics accidentales, intercepta el evento de cierre y le solicita con un cuadro de diálogo que confirme la salida de la aplicación.
2. **Botón Fijar**: controla el comportamiento de ocultación automática de la barra de herramientas superior. Cuando el pasador apunta verticalmente (estado fijado), la barra queda bloqueada en su lugar y permanece permanentemente visible. Cuando el pin se gira -45 grados (estado sin fijar), la barra se desliza automáticamente hacia arriba fuera de la vista cuando el mouse abandona su área.
3. **Pantalla completa (icono de flechas verdes):** cambia instantáneamente la ventana activa al modo de pantalla completa y viceversa. En el modo de pantalla completa, las flechas apuntan hacia adentro (contraer) y en el modo de ventana, apuntan hacia afuera (expandir).
4. **Minimizar (icono de minimización cian)**: Minimiza la ventana de la aplicación a la barra de tareas. Restaurarla devuelve la ventana a su estado anterior exacto (por ejemplo, maximizada o en pantalla completa).
5. **⚙️ OPCIONES (OPCJE)**: alterna la ventana de opciones de configuración. Si la ventana ya está abierta, al hacer clic en este botón se cierra.
6. **📺 NUEVA VENTANA (AHORA OKNO):** abre un `Auxiliary Window` nuevo, independiente y totalmente configurable, perfecto para expandir los diseños de su cámara en múltiples configuraciones de monitor.
7. **ARCHIVO**: abre un `PlaybackWindow` (reproductor de grabaciones) vacío con una línea de tiempo y un calendario activos, lo que permite seleccionar transmisiones manuales y canales de cámara desde cualquier NVR configurado a través de la lista de la barra lateral.
8. **INSTRUCCIONES (INSTRUKCJA)**: Abre esta ventana de manual, cargando la documentación de usuario completa en inglés o polaco dependiendo de su configuración regional activa.
9. **📊 Interruptor de ESTADÍSTICAS (STATYSTYKI):**: cambie el interruptor para deslizar hacia afuera el panel de monitoreo de Estadísticas del sistema desde el borde izquierdo de la pantalla.
10. **Interruptor de bloqueo de cuadrícula (candado):**: interruptor que, cuando está activado (resaltado en naranja brillante), desactiva las acciones de cambio de tamaño de la cuadrícula en los botones de la cuadrícula adyacentes, protegiendo el diseño de su cámara activa de cambios accidentales.
11. **Selectores de tamaño de cuadrícula (de 1x1 a 9x9):**: una fila de nueve botones que le permite definir instantáneamente la estructura de filas y columnas de su ventana gráfica (desde una vista 1x1 de una sola cámara hasta 81 transmisiones de cámara simultáneas en un diseño de 9x9). El tamaño actualmente activo se resalta en naranja brillante.
12. **Más opciones (menú hamburguesa con tres líneas)**: botón que abre la caja de herramientas deslizante `Layout & Grid Tools` para ajuste avanzado de la cuadrícula, ajustes de geometría y opciones de depuración (detalladas a continuación).
13. **Botones preestablecidos/ver**: botones renderizados dinámicamente en el lado derecho de la barra de herramientas que representan sus diseños preestablecidos configurados y visibles (por ejemplo, *📹 NVR*, *Ver 1*, etc.). Al hacer clic en un botón se cambia inmediatamente la cuadrícula. La vista activa resalta con una luz brillante de color turquesa.

### Personalización y proporciones avanzadas de cuadrícula (herramientas de diseño y cuadrícula)
Al abrir el menú Hamburguesa (Más opciones), aparece una caja de herramientas de diseño especializada. Para activar sus controles:
1. **Desbloquear panel de herramientas**: active el interruptor "Desbloquear panel de herramientas" en la parte superior. Esta es una medida de seguridad explícita para evitar cambios accidentales en diseños complejos.
2. **División de ventana personalizada (F2 o mantener presionado):**: la caja de herramientas muestra botones de división de cuadrícula de 1x1 a 9x9. Una característica extremadamente avanzada es la capacidad de **anular y editar tamaños de división**. Si hace clic y mantiene presionado cualquier botón de la cuadrícula con el botón izquierdo del mouse (o lo enfoca y presiona **F2**), aparece un cuadro de texto. Puede escribir cualquier división personalizada o asimétrica (como `2x3`, `1x4`, etc.) y presionar Enter. El botón se reprograma instantáneamente y, al hacer clic en él, se aplica su diseño personalizado a la ventana principal.
3. **Proporciones de geometría**: permite forzar la visualización de la cuadrícula a proporciones de aspecto específicas:
   * **Relación de aspecto 16:9**: bloquea y escala el contenedor de cuadrícula al formato panorámico 16:9 (estándar para las cámaras IP modernas).
   * **Relación de aspecto 4:3**: adapta el contenedor de cuadrícula a la relación tradicional 4:3 (común en cámaras analógicas/IP heredadas).
4. **Operaciones de cuadrícula (fusionar celdas resaltadas)**: acceda a la función de combinación de celdas asimétricas (detallada en la Sección 9.2).

---

## 6. Panel de estadísticas del sistema (Estadísticas del sistema)

Deslizándose desde el borde izquierdo de la pantalla Live View, este panel monitorea el estado de la computadora y la carga generada por la aplicación:
* **Parámetros monitoreados**:
  * **CPU/RAM**: uso del procesador principal (en % de todos los núcleos) y la RAM utilizada directamente por el proceso `kvision` y sus subprocesos de descarga relacionados.
  * **GPU/VRAM**: utilización del núcleo de la tarjeta gráfica (en %) y cantidad de memoria gráfica VRAM ocupada por el procesamiento y la decodificación de hardware (admite una lista completa de procesos de GPU utilizando el analizador XML de `nvidia-smi`).
  * **RED (Neto)**: velocidad de transferencia de descarga real de la aplicación desde todos los reproductores en vivo activos, reproductores de archivos y procesos de descarga de grabaciones.
* **Subprocesos múltiples (sin tartamudeos)**: la recopilación de datos del proceso y de la GPU se ejecuta en un subproceso del sistema independiente (`StatsWorker`). Esto evita cualquier micro-tartamudeo en la renderización de vídeo (sin caídas de fotogramas).
* **Función de fijación**: al hacer clic en el botón **"Fijar"** (icono de fijación) se bloquea el panel en su estado expandido.
* **Estética**: los gráficos presentan bordes de color verde neón brillante, un relleno degradado debajo de la curva del gráfico y una transparencia de fondo equilibrada del 35 % para garantizar la legibilidad del texto.

---

## 7. Reproductor de archivo de reproducción

Disponible haciendo clic en el ícono de reloj/reproducción al lado de una cámara o grabadora específica. Permite la visualización simultánea de grabaciones archivadas de múltiples cámaras Hikvision en sincronización de tiempo completo.

### Línea de tiempo y controles:
* **Inicio rápido (15 minutos atrás):**: al abrir el archivo desde la vista en vivo, el reproductor comienza automáticamente desde un momento que cae **exactamente 15 minutos antes de la hora actual del sistema** (en lugar de comenzar a medianoche). Esto permite la visualización inmediata de un evento que acaba de ocurrir.
* **Navegación**: la línea de tiempo se puede desplazar hacia la izquierda y hacia la derecha arrastrándola con el botón izquierdo del ratón.
* **Zoom (escala):** puede cambiar suavemente la escala de la línea de tiempo con la rueda de desplazamiento del mouse (o los botones de Zoom), desde ver el día completo hasta una vista precisa de precisión de 10 minutos.
* **Atajos de zoom rápido**: la barra de control inferior presenta botones de iconos circulares dedicados para escalar instantáneamente la vista de la línea de tiempo:
  * **Icono "1h":** amplía la línea de tiempo para realizar una inspección detallada en un lapso de 1 hora.
  * **Icono "8h":** amplía la línea de tiempo para mostrar un lapso de 8 horas.
  * **Icono de "24 horas":** restablece el zoom para ajustar el día completo de 24 horas en una sola pantalla.
  * **Icono de centro (objetivo):** centra inmediatamente la línea de tiempo para que el indicador de reproducción rojo esté exactamente en el centro de la pantalla (reemplazando el antiguo botón de texto).
* **Navegación por fechas (calendario y días)**: los controles junto a la fecha mostrada permiten saltos rápidos:
  * Botones **"<" (día anterior)** y **">" (día siguiente)**: le permiten retroceder o avanzar 24 horas instantáneamente sin abrir el cuadro de diálogo del calendario.
  * **Icono de calendario**: abre la ventana emergente del calendario para seleccionar una fecha específica.
  * **Icono de actualización**: fuerza una nueva búsqueda de grabaciones. Al hacer clic en él, se barre el caché local de segmentos de disponibilidad de grabación para todos los canales activos y envía nuevas consultas al NVR, lo cual es muy útil para cargar archivos grabados hace apenas unos momentos (reemplazando el botón de texto anterior).
  * **Icono de hoy (fecha/número de hoy):** salta instantáneamente al día actual (reemplazando el botón de texto anterior).
* **Atajos de velocidad de reproducción**:
  * **Iconos „1x”, „2x” y „4x”**: cambia instantáneamente el multiplicador de velocidad de reproducción.
* **Botones de salto del VCR**:
  * **Iconos de "15", "45" y "60" con flechas circulares**: te permiten avanzar o retroceder rápidamente la cantidad de segundos especificada.
* **Barras de disponibilidad de grabación**: las barras de colores que representan los segmentos de vídeo encontrados en el disco de la grabadora se muestran debajo de la línea de tiempo. Un sistema de almacenamiento en caché evita que parpadeen mientras se arrastran.
* **Seguimiento automático (seguimiento del indicador):**: el indicador de reproducción (línea roja vertical) se monitorea constantemente. Si el indicador sale del rango visible de la línea de tiempo, la vista se desplazará automáticamente para centrarlo. Esta opción se bloquea de forma inteligente durante el arrastre manual del indicador por parte del usuario.

### Panel lateral de la cámara en la ventana de reproducción
Una lista lateral vertical en el borde derecho del reproductor enumera todos los NVR configurados y sus canales de cámara:
* **Alternar canales**: al hacer clic en cualquier canal de cámara en la lista, se agrega como un espacio de reproducción activo en la línea de tiempo (generando un reproductor de video). Al hacer clic nuevamente se elimina el canal.
* **Menú contextual del canal**: al hacer clic con el botón derecho en una ranura de vídeo activa en la cuadrícula de reproducción, se abre un menú para:
  * Alternar calidad de vídeo (Transmisión principal/Transmisión secundaria).
  * Cerrar/eliminar el reproductor activo de la reproducción del archivo.

---

## 8. Descarga de grabaciones (descargador)

Desde la ventana Archivo de reproducción, puede descargar segmentos seleccionados de grabaciones directamente a la unidad de su computadora como archivos MP4:
1. Haga clic en el ícono de descarga (flecha hacia abajo) al lado de la cámara seleccionada.
2. Seleccione el rango de tiempo (inicio y final de la grabación).
3. Seleccione la ubicación para guardar el archivo de destino.
4. Haga clic en **Descargar**.

### Funciones de descarga avanzadas:
* **Descarga secuencial de segmentos (partes de 1 GB)**: el programa divide automáticamente su consulta de rango de tiempo en segmentos de archivos físicos (aproximadamente 1 GB cada uno en la unidad NVR) y los descarga y convierte uno por uno (utilizando archivos temporales `.pspart` que se convierten directamente al formato `.mp4`). Esto garantiza descargas altamente estables de rangos de larga duración sin desbordamiento de memoria ni bloqueos de conversión de FFmpeg.
* **Visualización del progreso general**: la barra de progreso (color verde azulado brillante) muestra el progreso de descarga general de la cámara en todos los segmentos. El texto de estado superpuesto en la barra de progreso muestra la parte actual y los porcentajes, por ejemplo, `Downloading part 1 of 3... 45% (Overall: 15%)`, con un estilo de contorno para garantizar la legibilidad en cualquier fondo.
* **Limpieza de IP de nombre de archivo**: los nombres de archivos de vídeo (y las instantáneas en vivo/archivadas) se eliminan automáticamente de las direcciones IP de NVR/DVR para mantenerlos limpios y legibles por humanos (por ejemplo, `4_Wejscie_glowne_2026-06-15.mp4` en lugar de `<RECORDER_IP>_4_Wejscie...`).

---

## 9. Configuración avanzada y personalización en la ventana de opciones

La ventana de opciones y configuración (`SideBar`) consta de seis pestañas dedicadas:

### 1. Detalles de la ventana gráfica (icono de monitor)
Muestra los parámetros avanzados del mosaico de cuadrícula seleccionado actualmente. Le permite:
* Escriba una **URL de transmisión principal** personalizada (RTSP/ONVIF) y una **URL de copia de seguridad secundaria** para configuraciones manuales.
* Alterna silenciar/activar el canal de audio de la transmisión de la cámara seleccionada.
* Ingrese anulaciones de decodificador avanzado en el cuadro de texto **Anulación de opciones de FFmpeg**.
> [!CONSEJO]
> Para obtener la conexión de transmisión más rápida y la máxima estabilidad a través de RTSP, los parámetros recomendados son:
> ```ini
> -analyzeduration 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Herramientas de diseño y cuadrícula (icono de controles deslizantes)
Opciones avanzadas de personalización de la cuadrícula de pantalla:
* Cambio rápido para el modo de pantalla completa.
* **Fusión de celdas asimétricas (Fusionar celdas resaltadas)**: un editor de diseño muy avanzado. Mantenga presionada la tecla **Ctrl** o **Mayús** y haga clic para seleccionar varios mosaicos adyacentes en la cuadrícula, o use su teclado manteniendo presionada la tecla **Mayús** y navegando con las **teclas de flecha**, luego haga clic en "Combinar celdas resaltadas" para fusionarlas en una única ventana gráfica más grande. Esto le permite crear diseños de cuadrícula asimétrica totalmente personalizados (por ejemplo, un panel de cámara enorme con feeds más pequeños a su alrededor).

### 3. Grabadoras (icono del servidor)
Administrador de configuración completo para conexiones a dispositivos NVR/DVR de Hikvision (descrito en detalle en la Sección 3).

### 4. Presets (icono de estrella)
Administrador de sus diseños de cuadrícula guardados y asignaciones de cámara. Permite crear plantillas de cuadrícula vacías, cambiar su orden, alternar su visibilidad en la barra superior (a través del interruptor "Visible") o activarlas en la ventana actual.

### 5. Configuración (icono de engranaje)
Permite ajustar la configuración global de la aplicación:
* **Permitir ejecutar múltiples instancias**: marcar esta casilla permite lanzar múltiples copias paralelas del proceso de KVision (de manera predeterminada, restringe las ejecuciones a una única instancia activa).
* **Configuración de colapso automático**: personaliza el tiempo de la animación deslizante para la barra superior y el panel de estadísticas.
* **Permitir el intercambio de ventanas gráficas**: la casilla de verificación *"Permitir el intercambio de lugares de las ventanas gráficas"* le permite reorganizar las posiciones de la cámara en la cuadrícula sobre la marcha (haga clic con el botón derecho en el mosaico de origen -> Elija "Intercambiar ventanas gráficas" -> haga clic con el botón izquierdo en el mosaico de destino).
* **Permisos de clic derecho**: cambia para bloquear/desbloquear controles interactivos en el menú contextual del botón derecho (Habilitar el menú contextual, Permitir el intercambio de ventanas gráficas, Habilitar la opción 'Eliminar cámara', Permitir cambiar la configuración de la ventana gráfica, Habilitar la selección de calidad principal/secundaria de la transmisión).
* **Activar silencio automáticamente**: activa automáticamente la transmisión de audio de la ventana gráfica activa al ingresar al modo de pantalla completa.
* **Ocultar cursor en pantalla completa**: la casilla de verificación *"Ocultar cursor en modo de pantalla completa"* oculta automáticamente el cursor del mouse después de un breve período de inactividad durante la visualización en pantalla completa para garantizar una vista sin obstáculos.
* **Selección de idioma**: cambia instantáneamente la traducción de la interfaz (predeterminado del sistema, polaco, inglés).
* **Preferencias de UI**: Ocultar/mostrar etiquetas de estado de la ventana gráfica o insignias de control (como ocultar automáticamente las superposiciones de control en la esquina inferior derecha de los mosaicos a menos que se coloque el cursor sobre él).
* **Opciones de FFmpeg predeterminadas y actualización masiva**: permite configurar opciones globales de FFmpeg aplicadas a nuevas ventanas gráficas (recomendado: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[RECOMENDACIÓN]** Si está migrando desde una versión anterior de KVision (anterior a v2.4.5), se recomienda cambiar `-analyzeduration 0` a `-analyzeduration 100000` en la configuración global y hacer clic en "Actualizar todas las cámaras". Configurar `0` en transmisiones sin una pista de audio provoca retrasos en el cambio porque FFmpeg se bloqueará durante un tiempo de espera codificado de 5 segundos en espera de paquetes de audio. Establecer un valor muy bajo (por ejemplo, 100.000 microsegundos = 0,1 s) resuelve completamente este problema manteniendo la conmutación instantánea.
  * **Botón Actualizar todas las cámaras**: El botón *„Zaktualizuj wszystkie kamery”* aplica estas opciones globales a todas las ventanas gráficas configuradas.
  * **Indicadores de baja latencia (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` desactiva el almacenamiento en búfer interno de paquetes del demultiplexor para eliminar el retraso en la transmisión con el tiempo, pero puede provocar interrupciones si la conexión de red a la cámara es inestable.
    * `-flags low_delay` le indica al decodificador que genere fotogramas inmediatamente, pero puede provocar breves artefactos o manchas en secuencias que utilizan fotogramas B en movimientos rápidos.
  * **Anular casilla de verificación**: puede excluir ventanas gráficas específicas de actualizaciones globales o valores predeterminados dinámicos marcando **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** en el cuadro de diálogo Configuración de ventana gráfica individual. Útil para solucionar problemas de cámaras que tartamudean.


### 6. Registro de cambios (icono de reloj/documento)
Presenta una línea de tiempo interactiva que muestra el historial completo de lanzamientos, actualizaciones, correcciones de errores y funciones adicionales de KVision, lo que garantiza que tenga acceso directo a los detalles de las actualizaciones del programa.

---

## 10. Atajos de teclado y controles del mouse

### Atajos de teclado:
| Tecla/Atajo | Acción |
|---|---|
| **F** / **F11** | Alternar el modo de pantalla completa. |
| **M** | Silenciar/activar audio (funciona para la cámara activa con audio). |
| **Espacio** | Reproducir/Pausar la reproducción en la ventana Archivo de reproducción. |
| **Alt + 1** a **Alt + 9** | Cambio rápido a un preajuste/diseño en los índices 1 a 9. |
| **Alt + Flecha izquierda** | Cambio rápido al ajuste preestablecido/diseño anterior de la colección. |
| **Alt + Flecha derecha** | Cambio rápido al siguiente ajuste preestablecido/diseño de la colección. |
| **Teclas de flecha (arriba/abajo/izquierda/derecha)** | Navegue y mueva el enfoque/selección activo entre las ventanas de visualización de la cámara. |
| **Mayús + teclas de flecha** | Seleccione varias ventanas de visualización de cámaras adyacentes simultáneamente (utilizadas para fusionar celdas, etc.). |
| **Ctrl + N** | Abra una nueva ventana auxiliar independiente. |
| **+** / **-** | Acercar/alejar (cámaras Hikvision con capacidad PTZ). |
| **Mayús** (arrastrar marco) | Fuerce la selección de marco para bloquear una relación de aspecto de 16:9 durante el zoom interactivo. |
| **Esc** | Salga del modo de pantalla completa/cancele la selección de ventana gráfica activa. |

### Interacción del ratón:
* **Botón izquierdo del ratón**:
  * **Haga doble clic** en la ventana gráfica de una cámara en la cuadrícula para maximizarla a pantalla completa. Otro doble clic restaura la vista de cuadrícula.
  * Arrastra la línea de tiempo en la ventana de Reproducción para navegar.
* **Botón central del ratón (haga clic y arrastre con la rueda de desplazamiento)**:
  * Arrastre para desplazarse y mover la imagen ampliada/ampliada digitalmente alrededor del campo de visión de la ventana gráfica (funciona en Live, Archive y Mini-player).
* **Botón derecho del ratón (menú contextual)**:
  * Abre un menú de configuración rápida para la ventana gráfica seleccionada (permite eliminar la cámara de la cuadrícula, cambiar entre secuencias principal/secundaria o acceder a parámetros de visualización individuales).
* **Rueda de desplazamiento del ratón**:
  * Ajusta la escala (Zoom) de la línea de tiempo en el reproductor de archivos de reproducción.

---

## 11. Toma de instantáneas y configuración de rutas

La aplicación le permite capturar rápidamente instantáneas de alta calidad desde cualquier ventana de visualización de la cámara, tanto en el modo Vista en vivo como en el modo Archivo de reproducción.

### Tomar instantáneas:
1. Un botón de superposición de icono de cámara está disponible en la esquina inferior derecha de cada ventana gráfica (detallado en la Sección 4).
2. Al hacer clic en el icono de la cámara se captura el fotograma y se guarda como una imagen JPEG (calidad 98, prácticamente sin pérdidas).
3. Una captura exitosa se confirma cuando el ícono de la cámara parpadea en naranja (`#ff7a00`) durante exactamente 1 segundo.
4. **Resolución completa**: en el modo Archivo de reproducción, las instantáneas se guardan con la resolución de origen nativa completa de la transmisión directamente desde el búfer de fotogramas del descodificador, independientemente del tamaño de la ventana gráfica activa en la pantalla o de la escala de visualización.

### Guardar configuraciones de ruta:
1. Vaya a la pestaña **Configuración** (icono de engranaje en la ventana de opciones).
2. En la sección **Guardar** ("Zapis") puedes configurar las rutas predeterminadas:
   * **Ruta de instantáneas predeterminada**: carpeta donde se guardarán las instantáneas (el valor predeterminado es `~/Obrazy/CCTV`).
   * **Ruta de grabaciones predeterminada**: carpeta donde se guardarán los videos MP4 descargados (el valor predeterminado es `~/Wideo/CCTV`).
3. Al hacer clic en el botón del navegador `...` se abre el selector de carpetas nativas de su sistema operativo (Breeze en KDE).
4. **Comportamiento del botón del navegador**: el selector de directorio se abre precisamente en la ruta escrita en el campo de texto (si existe). Si el campo está vacío, no es válido o apunta a una carpeta a la que no tiene acceso, el cuadro de diálogo vuelve a aparecer y se abre en su directorio de inicio (`~/`).

### Configuración de la interfaz de usuario (UI):
1. Vaya a la pestaña **Configuración** (icono de engranaje en la ventana de opciones) o abra la ventana **Opciones** ("Opcje").
2. En la sección **Configuración de la interfaz de usuario**, puede personalizar la visibilidad de los elementos superpuestos en los kafelki/viewports de la cámara:
   * **Mostrar el estado del canal en la esquina superior izquierda de la ventana gráfica** (habilitado de forma predeterminada): muestra información sobre la carga, la reproducción y el estado de la conexión.
   * **Mostrar información de la cámara en la esquina inferior izquierda de la ventana gráfica** (activado de forma predeterminada): muestra el nombre de la cámara recuperado de la grabadora Hikvision.
   * **Mostrar íconos de control en la esquina inferior derecha de la ventana gráfica solo al pasar el cursor** (habilitado de manera predeterminada): oculta automáticamente el panel de botones de control (instantánea, archivo, 1:1 píxel a píxel, zoom regional) cuando el cursor del mouse está fuera de la ventana gráfica de esa cámara específica. Los íconos aparecen instantáneamente tan pronto como mueve el mouse sobre la ventana gráfica (no es necesario hacer clic) y desaparecen al salir, maximizando la visibilidad de las transmisiones de su cámara.
   * **Mostrar campos de información solo al pasar el cursor** (deshabilitado de forma predeterminada): opción análoga que oculta el estado en la parte superior izquierda y el nombre en la parte inferior izquierda de las ventanas gráficas, mostrando una secuencia de cámara completamente limpia a menos que el cursor se mueva sobre ese mosaico de cámara específico.
