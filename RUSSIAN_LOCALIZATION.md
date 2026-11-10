# Russian UI localization (local build)

This branch adds Russian (AI-assisted, reviewed) to the native Qt language selector and system-locale detection. It includes 596 active translations, covering all 594 keys extracted from source, plus two upstream catalog entries. The upstream English catalog omits the downloader weekday labels and diagnostic-logging checkbox; the Russian catalog includes them.

Validation: `python3 tools/check_russian_translation.py`. This checks active keys, extracts current QML/C++ keys with Qt lupdate, and verifies placeholders, newlines, tags, and resource registration. The English user manual and English-only command-line help are not translated.

Local updates: `bash tools/update-local-russian.sh`. Run in a visible terminal. Requires the `local/russian` branch and a clean tracked working tree. The updater fetches origin and rebases this localization onto origin/master, then validates and builds the pacman package. Conflicts are aborted without overwriting local commits or removing the installed package. Newly introduced untranslated source keys stop installation until translated. This is a guarded local customization, not an upstream-supported translation.

No camera addresses, credentials, private settings or test logs are tracked. User configuration stays in its original location. Packaging uses pacman, with the local package release suffix `.1` distinguishing this build from upstream.
