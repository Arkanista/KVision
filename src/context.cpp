#include <algorithm>
#include <QRandomGenerator>
#include <QFile>
#include <QDir>
#include <QSettings>
#include <QFileInfo>
#include <QCoreApplication>
#include <QLocale>
#include <QFileDialog>
#include <QStandardPaths>
#include <QApplication>
#include <QWidget>
#include "context.h"

Context::Context(QObject *parent) : QObject(parent)
{
    m_instances.append(this);
}

Context::~Context()
{
    m_instances.removeOne(this);
    if (m_instances.isEmpty()) {
        for (QProcess *process : m_childProcesses) {
            if (process->state() != QProcess::NotRunning) {
                process->terminate();
                process->waitForFinished(1000);
            }
        }
        delete m_config;
        m_config = nullptr;

        if (m_watcher) {
            delete m_watcher;
            m_watcher = nullptr;
        }
    }
}

void Context::init()
{
    QCommandLineOption configOption({{"c", "config"}, "Path to the configuration file.", "config"});
    QCommandLineOption presetOption({{"p", "preset"}, "Index of the current layout.", "preset"});
    QCommandLineOption fullScreenOption({{"f", "full-screen"}, "Force full-screen mode."});
    QCommandLineOption kioskModeOption({{"k", "kiosk"}, "Enable kiosk mode functionality."});
    QCommandLineOption logOption({{"l", "log"}, QString("Logging level [%1...%2].").arg(Config::LogBeginRange).arg(Config::LogEndRange), "level"});
    QCommandLineOption auxiliaryOption(QStringList("auxiliary"), "Run as an auxiliary window.");
    QCommandLineOption auxiliaryIdOption("auxiliary-id", "Auxiliary window ID.", "id");
    QCommandLineOption verboseOption("verbose", "Show detailed logs in the console (verbose logging).");
    QCommandLineOption debugMemoryOption("debug-memory", "Enable object tracking in logs for memory leak debugging.");
    QCommandLineOption firstRunOption("first-run", "Force first-run assistant to launch.");
    QCommandLineOption simulateErrorOption("simulate-error", "Simulate an error for testing purposes.");
    QCommandLineOption mockNewVersionOption("mock-new-version", "Simulate a new version for testing purposes.");

    parseCommandLineOptions({configOption,
                             presetOption,
                             fullScreenOption,
                             kioskModeOption,
                             logOption,
                             auxiliaryOption,
                             auxiliaryIdOption,
                             verboseOption,
                             debugMemoryOption,
                             firstRunOption,
                             simulateErrorOption,
                             mockNewVersionOption});

    m_isAuxiliary = m_commandLineParser.isSet(auxiliaryOption);
    m_enableLogs = m_commandLineParser.isSet(verboseOption);
    m_mockNewVersion = m_commandLineParser.isSet(mockNewVersionOption);

    if (m_isAuxiliary && m_commandLineParser.isSet(auxiliaryIdOption)) {
        m_auxiliaryId = m_commandLineParser.value(auxiliaryIdOption).toInt();
    } else {
        m_auxiliaryId = 0;
    }

    bool firstRunDetected = false;
    if (m_commandLineParser.isSet(firstRunOption)) {
        firstRunDetected = true;
    } else {
        QString configPathToCheck;
        if (m_commandLineParser.isSet(configOption)) {
            configPathToCheck = m_commandLineParser.value(configOption);
        } else {
            configPathToCheck = QSettings().fileName();
        }

        if (!QFile::exists(configPathToCheck)) {
            if (!m_commandLineParser.isSet(configOption)) {
                QSettings oldSettings(QStringLiteral("CCTV Viewer"), QStringLiteral("CCTV Viewer"));
                if (!QFile::exists(oldSettings.fileName())) {
                    firstRunDetected = true;
                }
            } else {
                firstRunDetected = true;
            }
        }
    }
    m_isFirstRun = firstRunDetected;

    if (m_commandLineParser.isSet(configOption)) {
        m_config = new Config(m_commandLineParser.value(configOption));
    } else {
        // Auto-migration logic from old "CCTV Viewer" settings to "KVision" settings
        QString newConfigPath = QSettings().fileName();
        QSettings oldSettings(QStringLiteral("CCTV Viewer"), QStringLiteral("CCTV Viewer"));
        QString oldConfigPath = oldSettings.fileName();

        if (!QFile::exists(newConfigPath) && QFile::exists(oldConfigPath)) {
            QFileInfo newFileInfo(newConfigPath);
            QDir().mkpath(newFileInfo.absolutePath());
            if (QFile::copy(oldConfigPath, newConfigPath)) {
                qInfo() << "Migrated configuration file from" << oldConfigPath << "to" << newConfigPath;
                // Copy thumbnails subdirectory if it exists
                QFileInfo oldFileInfo(oldConfigPath);
                QDir oldDir(oldFileInfo.absolutePath());
                if (oldDir.exists("thumbnails")) {
                    QDir oldThumbnailsDir(oldDir.filePath("thumbnails"));
                    QDir newDir(newFileInfo.absolutePath());
                    newDir.mkdir("thumbnails");
                    QDir newThumbnailsDir(newDir.filePath("thumbnails"));
                    QStringList thumbnails = oldThumbnailsDir.entryList(QDir::Files);
                    for (const QString &thumb : thumbnails) {
                        QFile::copy(oldThumbnailsDir.filePath(thumb), newThumbnailsDir.filePath(thumb));
                    }
                    qInfo() << "Migrated" << thumbnails.size() << "camera thumbnails to new location.";
                }
            } else {
                qWarning() << "Failed to migrate configuration file from" << oldConfigPath << "to" << newConfigPath;
            }
        }
#ifdef _WIN32
        if (!QFile::exists(newConfigPath)) {
            QFileInfo newFileInfo(newConfigPath);
            QString siblingConf = newFileInfo.absolutePath() + QStringLiteral("/KVision.conf");
            QString legacyWinFile = QStringLiteral("\\HKEY_CURRENT_USER\\Software\\KVision\\KVision");
            if (QFile::exists(siblingConf)) {
                QDir().mkpath(newFileInfo.absolutePath());
                if (QFile::copy(siblingConf, newConfigPath)) {
                    qInfo() << "Migrated sibling KVision.conf to" << newConfigPath;
                    m_isFirstRun = false;
                }
            } else if (QFile::exists(legacyWinFile)) {
                QDir().mkpath(newFileInfo.absolutePath());
                if (QFile::copy(legacyWinFile, newConfigPath)) {
                    qInfo() << "Migrated legacy Windows configuration file to" << newConfigPath;
                    m_isFirstRun = false;
                }
            }
        }
#endif
        m_config = new Config();
    }

    // Ensure the config file exists so we can watch it
    QString configPath = m_config->fileName();
    QFile file(configPath);
    if (!file.exists()) {
        QFileInfo fileInfo(configPath);
        QDir().mkpath(fileInfo.absolutePath());
        if (file.open(QIODevice::WriteOnly)) {
            file.close();
        }
    }

    // Configure the File Watcher
    if (!m_watcher) {
        m_watcher = new QFileSystemWatcher();
        m_watcher->addPath(configPath);
        QObject::connect(m_watcher, &QFileSystemWatcher::fileChanged, [](const QString &path) {
            // Force reload settings file cache
            QSettings settings;
            settings.sync();

            // Re-add to watcher in case the file was recreated/replaced
            if (m_watcher && !m_watcher->files().contains(path)) {
                m_watcher->addPath(path);
            }

            // Emit signal on all active Context instances
            for (Context *instance : m_instances) {
                emit instance->configFileChanged();
            }
        });
    }

    if (m_commandLineParser.isSet(presetOption)) {
        m_config->setCurrentIndex(m_commandLineParser.value(presetOption).toInt());
    }
    m_config->setFullScreen(m_commandLineParser.isSet(fullScreenOption));
    m_config->setKioskMode(m_commandLineParser.isSet(kioskModeOption));
    if (m_commandLineParser.isSet(logOption)) {
        auto level = std::clamp(m_commandLineParser.value(logOption).toInt(),
                                static_cast<int>(Config::LogBeginRange),
                                static_cast<int>(Config::LogEndRange));
        m_config->setLogLevel(static_cast<Config::LogLevel>(level));
    }
}

void Context::parseCommandLineOptions(const QList<QCommandLineOption> &options)
{
    m_commandLineParser.setApplicationDescription(tr("LNG_00476"));
    m_commandLineParser.addHelpOption();
    m_commandLineParser.addVersionOption();

    m_commandLineParser.addOptions(options);

    QCoreApplication *app = QCoreApplication::instance();
    if (app) {
        m_commandLineParser.process(*app);
    }
}

void Context::startAuxiliaryProcess()
{
    QString exePath = QCoreApplication::applicationFilePath();
    QString mainConfigPath = m_config ? m_config->fileName() : QSettings().fileName();

    int nextId = 1;
    while (m_childIds.values().contains(nextId)) {
        nextId++;
    }

    QProcess *process = new QProcess();
    QStringList arguments;
    arguments << "-c" << mainConfigPath << "--auxiliary" << "--auxiliary-id" << QString::number(nextId);

    connect(process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), 
            [process](int exitCode, QProcess::ExitStatus exitStatus) {
        Q_UNUSED(exitCode);
        Q_UNUSED(exitStatus);
        m_childIds.remove(process);
        m_childProcesses.removeOne(process);
        process->deleteLater();
    });

    m_childIds[process] = nextId;
    m_childProcesses.append(process);
    process->setProcessChannelMode(QProcess::ForwardedChannels);
    process->start(exePath, arguments);
}

void Context::writeSetting(const QString &category, const QString &key, const QVariant &value)
{
    QString path = m_config ? m_config->fileName() : QSettings().fileName();
    QSettings settings(path, QSettings::IniFormat);
    if (!category.isEmpty()) {
        settings.beginGroup(category);
    }
    settings.setValue(key, value);
    if (!category.isEmpty()) {
        settings.endGroup();
    }
}

QVariant Context::readSetting(const QString &category, const QString &key, const QVariant &defaultValue) const
{
    QString path = m_config ? m_config->fileName() : QSettings().fileName();
    QSettings settings(path, QSettings::IniFormat);
    if (!category.isEmpty()) {
        settings.beginGroup(category);
    }
    QVariant val = settings.value(key, defaultValue);
    if (!category.isEmpty()) {
        settings.endGroup();
    }
    
    // Coerce the returned QVariant to the same type as defaultValue
    // to prevent QML from receiving strings (e.g. "false") which are truthy in JavaScript.
    if (defaultValue.type() == QVariant::Bool) {
        return val.toBool();
    } else if (defaultValue.type() == QVariant::Int) {
        return val.toInt();
    } else if (defaultValue.type() == QVariant::Double) {
        return val.toDouble();
    }
    return val;
}

static QString getTransFileForLang(const QString &lang)
{
    static const QHash<QString, QString> langMap = {
        {"pl", "kvision_pl_PL"},
        {"en", "kvision_en_US"},
        {"es", "kvision_es_ES"},
        {"ar", "kvision_ar_AR"},
        {"bg", "kvision_bg_BG"},
        {"cs", "kvision_cs_CZ"},
        {"da", "kvision_da_DK"},
        {"de", "kvision_de_DE"},
        {"el", "kvision_el_GR"},
        {"fi", "kvision_fi_FI"},
        {"fr", "kvision_fr_FR"},
        {"hu", "kvision_hu_HU"},
        {"it", "kvision_it_IT"},
        {"nl", "kvision_nl_NL"},
        {"no", "kvision_nb_NO"},
        {"pt", "kvision_pt_PT"},
        {"ro", "kvision_ro_RO"},
        {"sk", "kvision_sk_SK"},
        {"sv", "kvision_sv_SE"},
        {"tr", "kvision_tr_TR"},
        {"uk", "kvision_uk_UA"},
        {"zh", "kvision_zh_CN"}
    };

    if (lang == "system") {
        QString locale = QLocale::system().name();
        for (auto it = langMap.constBegin(); it != langMap.constEnd(); ++it) {
            if (locale.startsWith(it.key(), Qt::CaseInsensitive)) {
                return it.value();
            }
        }
        return "kvision_en_US";
    }

    return langMap.value(lang, "kvision_en_US");
}

void Context::initLanguage()
{
    QSettings settings(m_config ? m_config->fileName() : QSettings().fileName(), QSettings::IniFormat);
    QString lang = settings.value("language", "system").toString();
    m_language = lang;
    
    if (m_translator) {
        QCoreApplication::removeTranslator(m_translator);
    }
    
    QString transFile = getTransFileForLang(lang);
    
    if (!transFile.isEmpty()) {
        if (!m_translator) {
            m_translator = new QTranslator(QCoreApplication::instance());
        }
        if (m_translator->load(transFile, ":/translations/")) {
            QCoreApplication::installTranslator(m_translator);
        }
    }
}

void Context::setLanguage(const QString &lang)
{
    m_language = lang;
    
    if (m_translator) {
        QCoreApplication::removeTranslator(m_translator);
    }
    
    QString transFile = getTransFileForLang(lang);
    
    if (!transFile.isEmpty()) {
        if (!m_translator) {
            m_translator = new QTranslator(QCoreApplication::instance());
        }
        if (m_translator->load(transFile, ":/translations/")) {
            QCoreApplication::installTranslator(m_translator);
        }
    }
    
    QSettings settings(m_config ? m_config->fileName() : QSettings().fileName(), QSettings::IniFormat);
    settings.setValue("language", lang);
    
    if (m_engine) {
        m_engine->retranslate();
    }
    emit languageChanged();
}

QString Context::getLanguage() const
{
    return m_language.isEmpty() ? "system" : m_language;
}

bool Context::mkpath(const QString &dirPath) const
{
    return QDir().mkpath(dirPath);
}

bool Context::dirExists(const QString &dirPath) const
{
    if (dirPath.isEmpty())
        return false;
    QFileInfo info(dirPath);
    return info.exists() && info.isDir() && info.isReadable();
}

QString Context::homePath() const
{
    return QDir::homePath();
}

QUrl Context::pathToUrl(const QString &path) const
{
    QFileInfo info(path);
    if (info.exists() && info.isDir()) {
        QString p = path;
        if (!p.endsWith('/') && !p.endsWith('\\')) {
            p += '/';
        }
        return QUrl::fromLocalFile(p);
    }
    return QUrl::fromLocalFile(path);
}

QString Context::urlToLocalFile(const QString &urlOrPath) const
{
    if (urlOrPath.isEmpty())
        return QString();

    QString p = urlOrPath.trimmed();
    if (p.startsWith(QStringLiteral("file://"), Qt::CaseInsensitive)) {
        QUrl url(p);
        if (url.isLocalFile()) {
            p = url.toLocalFile();
        } else {
            p = p.mid(7);
        }
    }
#ifdef _WIN32
    // Strip leading slash before Windows drive letter (e.g. "/C:/Users/..." -> "C:/Users/...")
    if (p.length() >= 3 && (p[0] == '/' || p[0] == '\\') && p[1].isLetter() && p[2] == ':') {
        p = p.mid(1);
    }
#endif
    return QDir::fromNativeSeparators(p);
}

bool Context::isValidPlatformPath(const QString &path) const
{
    if (path.trimmed().isEmpty())
        return false;
#ifdef _WIN32
    // Reject Unix-style paths or broken "/C:/..." paths on Windows
    if (path.startsWith('/') || path.startsWith('\\'))
        return false;
    if (path.length() < 2 || !path[0].isLetter() || path[1] != ':')
        return false;
#else
    // Reject Windows drive-letter paths (e.g. "C:/Users/...") on Linux/Unix
    if (path.length() >= 2 && path[0].isLetter() && path[1] == ':')
        return false;
    if (!path.startsWith('/'))
        return false;
#endif
    return true;
}

QString Context::sanitizePlatformPath(const QString &path, const QString &fallbackPath) const
{
    QString cleaned = urlToLocalFile(path);
    if (isValidPlatformPath(cleaned)) {
        return cleaned;
    }
    return fallbackPath;
}

QString Context::defaultPicturesPath() const
{
    QString base = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    if (base.isEmpty()) {
        base = QDir::homePath() + QStringLiteral("/Pictures");
    }
    return QDir::fromNativeSeparators(base) + QStringLiteral("/CCTV");
}

QString Context::defaultMoviesPath() const
{
    QString base = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
    if (base.isEmpty()) {
        base = QDir::homePath() + QStringLiteral("/Videos");
    }
    return QDir::fromNativeSeparators(base) + QStringLiteral("/CCTV");
}

QString Context::configDirPath() const
{
    QString path = m_config ? m_config->fileName() : QSettings().fileName();
    return QDir::fromNativeSeparators(QFileInfo(path).absolutePath());
}

QString Context::selectFolder(const QString &title, const QString &initialPath) const
{
    QWidget *parent = QApplication::activeWindow();
    QString dir = QFileDialog::getExistingDirectory(
        parent,
        title,
        initialPath,
        QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks
    );
    return QDir::fromNativeSeparators(dir);
}

QString Context::selectExportConfigFile(const QString &title, const QString &initialDir) const
{
    QWidget *parent = QApplication::activeWindow();
    QString startDir = initialDir.isEmpty() ? QDir::homePath() : initialDir;
    QString defaultFile = QDir(startDir).filePath(QStringLiteral("KVision.conf"));
    QString selected = QFileDialog::getSaveFileName(
        parent,
        title,
        defaultFile,
        QStringLiteral("KVision Configuration (*.conf *.ini);;All Files (*)")
    );
    if (!selected.isEmpty()) {
        QFileInfo fi(selected);
        if (fi.suffix().isEmpty()) {
            selected += QStringLiteral(".conf");
        }
    }
    return QDir::fromNativeSeparators(selected);
}

QString Context::selectImportConfigFile(const QString &title, const QString &initialDir) const
{
    QWidget *parent = QApplication::activeWindow();
    QString startDir = initialDir.isEmpty() ? QDir::homePath() : initialDir;
    QString selected = QFileDialog::getOpenFileName(
        parent,
        title,
        startDir,
        QStringLiteral("KVision Configuration (*.conf *.ini);;All Files (*)")
    );
    return QDir::fromNativeSeparators(selected);
}

bool Context::exportSettings(const QString &targetFilePath)
{
    QString dstPath = urlToLocalFile(targetFilePath);
    if (dstPath.isEmpty())
        return false;

    QString srcPath = m_config ? m_config->fileName() : QSettings().fileName();
    QFileInfo srcInfo(srcPath);
    QFileInfo dstInfo(dstPath);

    if (srcInfo.exists() && dstInfo.exists() && srcInfo.canonicalFilePath() == dstInfo.canonicalFilePath()) {
        // Exporting to the active config file itself: just sync it
        QSettings src(srcPath, QSettings::IniFormat);
        src.sync();
        return src.status() == QSettings::NoError;
    }

    QDir().mkpath(dstInfo.absolutePath());
    if (QFile::exists(dstPath)) {
        QFile::remove(dstPath);
    }

    QSettings src(srcPath, QSettings::IniFormat);
    src.sync();

    QSettings dst(dstPath, QSettings::IniFormat);
    dst.clear();

    const QStringList keys = src.allKeys();
    for (const QString &key : keys) {
        dst.setValue(key, src.value(key));
    }
    dst.sync();

    return (dst.status() == QSettings::NoError) && QFileInfo::exists(dstPath);
}

bool Context::importSettings(const QString &sourceFilePath)
{
    QString srcPath = urlToLocalFile(sourceFilePath);
    if (srcPath.isEmpty() || !QFileInfo::exists(srcPath))
        return false;

    QSettings src(srcPath, QSettings::IniFormat);
    src.sync();
    if (src.status() != QSettings::NoError)
        return false;

    const QStringList keys = src.allKeys();
    if (keys.isEmpty())
        return false;

    QString dstPath = m_config ? m_config->fileName() : QSettings().fileName();
    QFileInfo dstInfo(dstPath);
    QDir().mkpath(dstInfo.absolutePath());

    // Create a safety backup of the current settings file before importing
    if (QFile::exists(dstPath)) {
        QString backupPath = dstPath + QStringLiteral(".bak");
        QFile::remove(backupPath);
        QFile::copy(dstPath, backupPath);
    }

    QSettings dst(dstPath, QSettings::IniFormat);
    for (const QString &key : keys) {
        // Preserve the currently open SidebarWindow geometry/visibility
        if (key.startsWith(QStringLiteral("SidebarWindow/"))) {
            continue;
        }
        QVariant val = src.value(key);
        if (key == QStringLiteral("snapshotPath")) {
            QString sanitized = sanitizePlatformPath(val.toString(), defaultPicturesPath());
            QDir().mkpath(sanitized);
            val = sanitized;
        } else if (key == QStringLiteral("videoPath")) {
            QString sanitized = sanitizePlatformPath(val.toString(), defaultMoviesPath());
            QDir().mkpath(sanitized);
            val = sanitized;
        }
        dst.setValue(key, val);
    }
    dst.sync();

    if (dst.status() != QSettings::NoError)
        return false;

    if (m_watcher && !m_watcher->files().contains(dstPath)) {
        m_watcher->addPath(dstPath);
    }

    for (Context *instance : m_instances) {
        emit instance->configFileChanged();
    }

    return true;
}

QString Context::readLocalFile(const QString &filePath) const
{
    QString path = filePath;
    if (path.startsWith("qrc:/")) {
        path = path.mid(3); // convert "qrc:/..." to ":/..."
    }
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString();
    }
    return QString::fromUtf8(file.readAll());
}

#ifdef __linux__
#include <malloc.h>

static qint64 getCurrentRSS()
{
    QFile file(QStringLiteral("/proc/self/status"));
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray content = file.readAll();
        file.close();
        int idx = content.indexOf("VmRSS:");
        if (idx != -1) {
            int endIdx = content.indexOf('\n', idx);
            if (endIdx != -1) {
                QByteArray line = content.mid(idx, endIdx - idx);
                int colonIdx = line.indexOf(':');
                if (colonIdx != -1) {
                    QByteArray valStr = line.mid(colonIdx + 1).trimmed();
                    int spaceIdx = valStr.indexOf(' ');
                    if (spaceIdx != -1) {
                        valStr = valStr.left(spaceIdx);
                    }
                    return valStr.toLongLong() * 1024; // convert kB to bytes
                }
            }
        }
    }
    return 0;
}
#endif

void Context::trimMemory()
{
    qint64 rssBefore = 0;
#ifdef __linux__
    rssBefore = getCurrentRSS();
#endif

    if (m_engine) {
        qDebug() << "[Context] Aggressively trimming QML component cache, singletons, and collecting JS garbage...";
        m_engine->collectGarbage();
        m_engine->trimComponentCache();
    }
#ifdef __linux__
    malloc_trim(0);
    qint64 rssAfter = getCurrentRSS();
    qint64 freedBytes = rssBefore - rssAfter;
    if (freedBytes > 0) {
        fprintf(stderr, "[Memory] GC & Manual memory trim released %.2f MB to the operating system kernel.\n",
                static_cast<double>(freedBytes) / (1024.0 * 1024.0));
        fflush(stderr);
    } else {
        fprintf(stderr, "[Memory] GC & Manual memory trim executed. Memory usage did not change significantly.\n");
        fflush(stderr);
    }
#endif
}


