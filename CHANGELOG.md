# Changelog

All notable changes to this project will be documented in this file.

## [2.6.3] - 2026-07-08

### EN: Bug Fixes
* **Console Memory Reporting:** Enhanced the periodic memory reclaiming timer to log the exact amount of RAM (in MB) successfully returned to the operating system kernel via `malloc_trim(0)`. This message is always visible in standard console output without requiring `--verbose` mode.

### PL: Poprawki Błędów
* **Logowanie odzysku pamięci:** Ulepszono mechanizm okresowego zwalniania pamięci, dodając precyzyjną informację o dokładnej ilości pamięci RAM (w MB) pomyślnie zwróconej do jądra systemu za pomocą `malloc_trim(0)`. Komunikat ten jest zawsze widoczny na konsoli, również w trybie normalnym bez konieczności uruchamiania z flagą `--verbose`.

## [2.6.2] - 2026-07-08

### EN: Bug Fixes
* **Reduced Log Spam:** Suppressed repetitive QML/JS warnings, TypeErrors, and video packet decoding errors (e.g. "Unable send packet to decoder: Invalid data found...") from default output. These diagnostic logs are now only visible when running with `--verbose`.
* **Periodic Memory Reclaiming:** Added a background timer that runs once every hour to perform garbage collection and call `malloc_trim(0)`, releasing any unused heap memory back to the Linux kernel.

### PL: Poprawki Błędów
* **Ograniczenie hałasu w logach:** Wyciszono uciążliwe i powtarzające się błędy silnika QML (np. TypeError) oraz błędy dekodowania pakietów wideo ze standardowego wyjścia. Te komunikaty diagnostyczne są teraz wypisywane tylko przy uruchomieniu z parametrem `--verbose`.
* **Okresowe zwalnianie pamięci:** Dodano działający w tle zegar, który raz na godzinę wymusza odśmiecanie pamięci oraz wywołuje `malloc_trim(0)`, zwracając wszelkie nieużywane zasoby pamięci podręcznej sterty z powrotem do jądra systemu Linux.

## [2.6.1] - 2026-07-07

### EN: Bug Fixes
* **Fixed GPU Driver Memory Leak (NVIDIA/GLX):** Resolved a critical memory leak within the graphics driver stack (primarily affecting NVIDIA) by ensuring that the previous GLX texture image binding is explicitly released via `glXReleaseTexImageEXT` before drawing the next frame onto the X11 pixmap.
* **Thread Count Optimization:** Restricted FFmpeg decoding to a single thread per stream by default (setting `thread_count = 1` instead of `0` / auto-detect), preventing CPU thread explosion (e.g., 24 threads per camera on AMD Ryzen 9 24-core CPUs) and drastically reducing overall RAM usage and system context switching overhead.

### PL: Poprawki Błędów
* **Eliminacja wycieku pamięci w dekoderze (NVIDIA/GLX):** Naprawiono krytyczny wyciek pamięci na poziomie sterownika graficznego (szczególnie NVIDIA), powodowany brakiem zwalniania powiązania tekstury GLX (`glXReleaseTexImageEXT`) przed aktualizacją pixmapy X11 nową klatką wideo.
* **Ograniczenie liczby wątków dekodowania:** Ustawiono domyślną liczbę wątków dekodera FFmpeg na `1` dla każdego strumienia (zamiast `0` czyli auto-wykrywania), zapobiegając eksplozji wątków (np. 24 wątki na kamerę na 24-rdzeniowych procesorach AMD Ryzen 9) i drastycznie zmniejszając zużycie pamięci RAM oraz narzut przełączania kontekstu.

## [2.6.0] - 2026-07-03

### EN: New Features
* **Localization Expansion:** KVision is now fully localized into 20 new AI-translated languages, bringing the total number of supported languages to 22 (English, Polish, and 20 new languages). Both the entire application interface (UI) and the complete user manuals have been translated.
  * **Supported Languages:** Arabic (ar), Bulgarian (bg), Czech (cs), Danish (da), German (de), Greek (el), Spanish (es), Finnish (fi), French (fr), Hungarian (hu), Italian (it), Dutch (nl), Norwegian (no), Portuguese (pt), Romanian (ro), Slovak (sk), Swedish (sv), Turkish (tr), Ukrainian (uk), and Chinese (zh_CN).
* **Viewport Quick Playback documentation:** Added comprehensive documentation explaining the circular arrow overlay button (Miniplayer) and its detailed features in all 22 user manuals.

### PL: Nowe Funkcje
* **Rozszerzenie Lokalizacji:** KVision został w pełni przetłumaczony na 20 nowych języków wspomaganych przez AI, co daje łącznie 22 obsługiwane języki (angielski, polski oraz 20 nowych). Przetłumaczono zarówno cały interfejs aplikacji (UI), jak i pełne pliki instrukcji użytkownika.
  * **Obsługiwane języki:** arabski (ar), bułgarski (bg), czeski (cs), duński (da), niemiecki (de), grecki (el), hiszpański (es), fiński (fi), francuski (fr), węgierski (hu), włoski (it), holenderski (nl), norweski (no), portugalski (pt), rumuński (ro), słowacki (sk), szwedzki (sv), turecki (tr), ukraiński (uk) oraz chiński uproszczony (zh_CN).
* **Dokumentacja szybkiego podglądu:** Dodano szczegółowy opis nowej ikony szybkiego podglądu wstecz (Mini-odtwarzacza) oraz jej działania we wszystkich 22 plikach instrukcji użytkownika.

---

## [2.5.0] - 2026-07-03

### EN: New Features
* **Pan Zoom:** Added the ability to freely pan the zoomed-in video (Live, Mini-player, Archive) by holding down the middle mouse button (scroll wheel) and dragging the cursor.
* **Proportional Zoom Selection:** Introduced the `Shift` shortcut. Holding down the `Shift` key while drawing a zoom rectangle forces the selection to lock into a 16:9 aspect ratio, strictly constrained to the viewport boundaries.
* **Enforced Window Positioning:** Completely replaced the legacy window geometry saving mechanisms due to unresolvable multi-monitor projection issues in Qt. The application (both the main window and auxiliary windows) now strictly enforces launching centered on the primary monitor at 90% of its resolution, ensuring stability and predictability across all setups.
* **Localization Refactoring:** Replaced all hardcoded Polish and English strings embedded in the source code (`qsTr`, `tr`). Over 500 unique strings have been refactored into `LNG_XXXXX` identifiers, securely mapped via an improved `.ts`/`.qm` file system.
* **English-only CLI:** Command-line interface options and `--help` parameters are now permanently in English to prevent issues with delayed localization engine initialization.

### EN: Bug Fixes
* **Archive Aspect Ratio:** Fixed an issue where the aspect ratio of the video was distorted in the Archive player viewport. The `HikvisionArchivePlayer` component now correctly renders the original frame preserving its natural aspect ratio (letterboxing), instead of stretching the video to fit the UI boundaries.
* **Demuxer Memory Leaks:** Improved the object cleanup logic in the `QmlAVPlayer::stop()` routine, preventing "zombie" demuxer instances from accumulating in the background.
* **writeSetting Fix:** Added the missing implementation of the `writeSetting` method in the `Context` class, eliminating `TypeError`s and QML execution interruptions during settings migrations.

---

### PL: Nowe Funkcje
* **Przesuwanie powiększenia (Pan Zoom):** Dodano możliwość swobodnego przesuwania przybliżonego obrazu (Live, Mini-odtwarzacz, Archiwum) poprzez przytrzymanie wciśniętego środkowego przycisku myszy (kółka) i przesuwanie kursorem.
* **Proporcjonalne zaznaczanie powiększenia:** Wprowadzono skrót klawiszowy `Shift`. Trzymając wciśnięty klawisz `Shift` podczas rysowania prostokąta powiększenia (Lupka), zaznaczenie wymusza zablokowanie proporcji ekranu do 16:9, ograniczając ramkę do granic viewportu.
* **Wymuszone pozycjonowanie okien:** Zrezygnowano całkowicie z zapisywania geometrii okien po napotkaniu nieodwracalnych problemów Qt z poprawnym rzutowaniem na ekrany wielomonitorowe. Zamiast tego, aplikacja (zarówno okno główne, jak i okna pomocnicze) wymusza teraz otwieranie wyśrodkowane na głównym monitorze, w proporcjach 90% jego rozdzielczości, zapewniając stabilność i przewidywalność działania na każdym stanowisku.
* **Refaktoryzacja systemu tłumaczeń (Lokalizacja):** Zlikwidowano wszystkie sztywne polskie i angielskie teksty osadzone w kodzie źródłowym (`qsTr`, `tr`). Ponad 500 unikalnych ciągów zastąpiono jednolitymi identyfikatorami w formacie `LNG_XXXXX`, które są bezpiecznie mapowane przez ulepszony system plików `.ts`/`.qm`.
* **Wymuszony angielski w wierszu poleceń (CLI):** Opcje i parametry `--help` zostały zangielszczone na stałe, by uniknąć problemów z opóźnioną inicjalizacją mechanizmów lokalizacyjnych.

### PL: Poprawki
* **Zachowanie proporcji obrazu w Archiwum:** Naprawiono błąd zniekształcania proporcji obrazu w viewporcie odtwarzacza Archiwum. Komponent `HikvisionArchivePlayer` renderuje teraz oryginalną klatkę zachowując jej naturalny aspekt (dodając czarne paski), zamiast rozciągać wideo do wielkości okienka w interfejsie.
* **Wycieki pamięci Demuxerów:** Poprawiono logikę oczyszczania obiektów (cleanup) w procesie `QmlAVPlayer::stop()`, co zapobiega tworzeniu się "zombie" instancji demuxerów w tle.
* **Naprawa błędu writeSetting:** Dodano brakującą implementację metody `writeSetting` w klasie `Context`, co eliminuje błędy `TypeError` i przerywanie wykonywania kodu w QML przy migracjach ustawień.
