#include "systemstats.h"
#include "qmlav/src/qmlavdemuxer.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QProcess>
#include <QFileInfo>
#include <QRegularExpression>
#include <QLibrary>
#include <cstring>
#ifdef _WIN32
  #include <windows.h>
  #include <tlhelp32.h>
  #include <psapi.h>
  #include <process.h>
  typedef unsigned long uid_t;
  #define getpid _getpid
  #define getuid() 0UL
#else
  #include <unistd.h>
#endif
#include <sys/types.h>

// NVML Types
typedef void* nvmlDevice_t;
typedef enum nvmlReturn_enum {
    NVML_SUCCESS = 0,
    NVML_ERROR_NOT_SUPPORTED = 3,
} nvmlReturn_t;

typedef struct nvmlUtilization_st {
    unsigned int gpu;
    unsigned int memory;
} nvmlUtilization_t;

typedef struct nvmlProcessInfo_st {
    unsigned int pid;
    unsigned long long usedGpuMemory;
} nvmlProcessInfo_t;

typedef struct nvmlProcessUtilizationSample_st {
    unsigned int pid;
    unsigned long long timeStamp;
    unsigned int smUtil;
    unsigned int memUtil;
    unsigned int encUtil;
    unsigned int decUtil;
} nvmlProcessUtilizationSample_t;

typedef nvmlReturn_t (*fn_nvmlInit)(void);
typedef nvmlReturn_t (*fn_nvmlShutdown)(void);
typedef nvmlReturn_t (*fn_nvmlDeviceGetCount)(unsigned int *deviceCount);
typedef nvmlReturn_t (*fn_nvmlDeviceGetHandleByIndex)(unsigned int index, nvmlDevice_t *device);
typedef nvmlReturn_t (*fn_nvmlDeviceGetUtilizationRates)(nvmlDevice_t device, nvmlUtilization_t *rates);
typedef nvmlReturn_t (*fn_nvmlDeviceGetGraphicsRunningProcesses)(nvmlDevice_t device, unsigned int *infoCount, nvmlProcessInfo_t *infos);
typedef nvmlReturn_t (*fn_nvmlDeviceGetComputeRunningProcesses)(nvmlDevice_t device, unsigned int *infoCount, nvmlProcessInfo_t *infos);
typedef nvmlReturn_t (*fn_nvmlDeviceGetProcessUtilization)(nvmlDevice_t device, nvmlProcessUtilizationSample_t *utilization, unsigned int *processSamplesCount, unsigned long long lastSeenTimeStamp);

struct StatsWorker::NvmlContext {
    QLibrary lib;
    bool initialized = false;
    bool loadFailed = false;

    fn_nvmlInit nvmlInit = nullptr;
    fn_nvmlShutdown nvmlShutdown = nullptr;
    fn_nvmlDeviceGetCount nvmlDeviceGetCount = nullptr;
    fn_nvmlDeviceGetHandleByIndex nvmlDeviceGetHandleByIndex = nullptr;
    fn_nvmlDeviceGetUtilizationRates nvmlDeviceGetUtilizationRates = nullptr;
    fn_nvmlDeviceGetGraphicsRunningProcesses nvmlDeviceGetGraphicsRunningProcesses = nullptr;
    fn_nvmlDeviceGetComputeRunningProcesses nvmlDeviceGetComputeRunningProcesses = nullptr;
    fn_nvmlDeviceGetProcessUtilization nvmlDeviceGetProcessUtilization = nullptr;

    ~NvmlContext() {
        if (initialized && nvmlShutdown) {
            nvmlShutdown();
        }
        if (lib.isLoaded()) {
            lib.unload();
        }
    }

    bool ensureInitialized() {
        if (initialized) return true;
        if (loadFailed) return false;

#ifdef _WIN32
        const QStringList candidates = {
            "nvml",
            "C:/Windows/System32/nvml.dll",
            "C:/Program Files/NVIDIA Corporation/NVSMI/nvml.dll",
            "nvidia-ml"
        };
#else
        const QStringList candidates = {
            "nvidia-ml",
            "libnvidia-ml.so.1"
        };
#endif
        bool loaded = false;
        for (const QString &name : candidates) {
            lib.setFileName(name);
            if (lib.load()) {
                loaded = true;
                break;
            }
        }
        if (!loaded) {
            loadFailed = true;
            return false;
        }

        nvmlInit = (fn_nvmlInit)lib.resolve("nvmlInit_v2");
        if (!nvmlInit) nvmlInit = (fn_nvmlInit)lib.resolve("nvmlInit");

        nvmlShutdown = (fn_nvmlShutdown)lib.resolve("nvmlShutdown");

        nvmlDeviceGetCount = (fn_nvmlDeviceGetCount)lib.resolve("nvmlDeviceGetCount_v2");
        if (!nvmlDeviceGetCount) nvmlDeviceGetCount = (fn_nvmlDeviceGetCount)lib.resolve("nvmlDeviceGetCount");

        nvmlDeviceGetHandleByIndex = (fn_nvmlDeviceGetHandleByIndex)lib.resolve("nvmlDeviceGetHandleByIndex_v2");
        if (!nvmlDeviceGetHandleByIndex) nvmlDeviceGetHandleByIndex = (fn_nvmlDeviceGetHandleByIndex)lib.resolve("nvmlDeviceGetHandleByIndex");

        nvmlDeviceGetUtilizationRates = (fn_nvmlDeviceGetUtilizationRates)lib.resolve("nvmlDeviceGetUtilizationRates");

        nvmlDeviceGetGraphicsRunningProcesses = (fn_nvmlDeviceGetGraphicsRunningProcesses)lib.resolve("nvmlDeviceGetGraphicsRunningProcesses");
        if (!nvmlDeviceGetGraphicsRunningProcesses) nvmlDeviceGetGraphicsRunningProcesses = (fn_nvmlDeviceGetGraphicsRunningProcesses)lib.resolve("nvmlDeviceGetGraphicsRunningProcesses_v2");

        nvmlDeviceGetComputeRunningProcesses = (fn_nvmlDeviceGetComputeRunningProcesses)lib.resolve("nvmlDeviceGetComputeRunningProcesses");
        if (!nvmlDeviceGetComputeRunningProcesses) nvmlDeviceGetComputeRunningProcesses = (fn_nvmlDeviceGetComputeRunningProcesses)lib.resolve("nvmlDeviceGetComputeRunningProcesses_v2");

        nvmlDeviceGetProcessUtilization = (fn_nvmlDeviceGetProcessUtilization)lib.resolve("nvmlDeviceGetProcessUtilization");

        if (!nvmlInit || !nvmlShutdown || !nvmlDeviceGetCount || !nvmlDeviceGetHandleByIndex ||
            !nvmlDeviceGetUtilizationRates || !nvmlDeviceGetGraphicsRunningProcesses || !nvmlDeviceGetComputeRunningProcesses) {
            lib.unload();
            loadFailed = true;
            return false;
        }

        if (nvmlInit() != NVML_SUCCESS) {
            lib.unload();
            loadFailed = true;
            return false;
        }

        initialized = true;
        return true;
    }
};

#ifdef _WIN32
typedef HANDLE PDH_HQUERY_T;
typedef HANDLE PDH_HCOUNTER_T;
typedef LONG PDH_STATUS_T;

#define KV_PDH_FMT_DOUBLE  ((DWORD)0x00000200)
#define KV_PDH_FMT_LARGE   ((DWORD)0x00000400)
#define KV_PDH_MORE_DATA   ((PDH_STATUS_T)0x800007D2L)

struct KvPdhFmtCounterValue {
    DWORD CStatus;
    union {
        LONG longValue;
        double doubleValue;
        LONGLONG largeValue;
        LPCSTR AnsiStringValue;
        LPCWSTR WideStringValue;
    };
};

struct KvPdhFmtCounterValueItemW {
    LPWSTR szName;
    KvPdhFmtCounterValue FmtValue;
};

typedef PDH_STATUS_T (WINAPI *fn_PdhOpenQueryW)(LPCWSTR, DWORD_PTR, PDH_HQUERY_T *);
typedef PDH_STATUS_T (WINAPI *fn_PdhAddEnglishCounterW)(PDH_HQUERY_T, LPCWSTR, DWORD_PTR, PDH_HCOUNTER_T *);
typedef PDH_STATUS_T (WINAPI *fn_PdhCollectQueryData)(PDH_HQUERY_T);
typedef PDH_STATUS_T (WINAPI *fn_PdhGetFormattedCounterArrayW)(PDH_HCOUNTER_T, DWORD, LPDWORD, LPDWORD, KvPdhFmtCounterValueItemW *);
typedef PDH_STATUS_T (WINAPI *fn_PdhCloseQuery)(PDH_HQUERY_T);

struct StatsWorker::WinPdhContext {
    QLibrary lib;
    bool initialized = false;
    bool initFailed = false;
    PDH_HQUERY_T query = nullptr;
    PDH_HCOUNTER_T gpuEngineCounter = nullptr;
    PDH_HCOUNTER_T gpuDedMemCounter = nullptr;
    PDH_HCOUNTER_T gpuLocalMemCounter = nullptr;

    fn_PdhOpenQueryW PdhOpenQueryW = nullptr;
    fn_PdhAddEnglishCounterW PdhAddEnglishCounterW = nullptr;
    fn_PdhCollectQueryData PdhCollectQueryData = nullptr;
    fn_PdhGetFormattedCounterArrayW PdhGetFormattedCounterArrayW = nullptr;
    fn_PdhCloseQuery PdhCloseQuery = nullptr;

    ~WinPdhContext() {
        if (query && PdhCloseQuery) {
            PdhCloseQuery(query);
        }
        if (lib.isLoaded()) {
            lib.unload();
        }
    }

    bool ensureInitialized() {
        if (initialized) return true;
        if (initFailed) return false;

        lib.setFileName("pdh");
        if (!lib.load()) {
            initFailed = true;
            return false;
        }

        PdhOpenQueryW = (fn_PdhOpenQueryW)lib.resolve("PdhOpenQueryW");
        PdhAddEnglishCounterW = (fn_PdhAddEnglishCounterW)lib.resolve("PdhAddEnglishCounterW");
        PdhCollectQueryData = (fn_PdhCollectQueryData)lib.resolve("PdhCollectQueryData");
        PdhGetFormattedCounterArrayW = (fn_PdhGetFormattedCounterArrayW)lib.resolve("PdhGetFormattedCounterArrayW");
        PdhCloseQuery = (fn_PdhCloseQuery)lib.resolve("PdhCloseQuery");

        if (!PdhOpenQueryW || !PdhAddEnglishCounterW || !PdhCollectQueryData ||
            !PdhGetFormattedCounterArrayW || !PdhCloseQuery) {
            lib.unload();
            initFailed = true;
            return false;
        }

        if (PdhOpenQueryW(nullptr, 0, &query) != 0 || !query) {
            lib.unload();
            initFailed = true;
            return false;
        }

        PdhAddEnglishCounterW(query, L"\\GPU Engine(*)\\Utilization Percentage", 0, &gpuEngineCounter);
        PdhAddEnglishCounterW(query, L"\\GPU Process Memory(*)\\Dedicated Usage", 0, &gpuDedMemCounter);
        PdhAddEnglishCounterW(query, L"\\GPU Process Memory(*)\\Local Usage", 0, &gpuLocalMemCounter);

        if (!gpuEngineCounter && !gpuDedMemCounter && !gpuLocalMemCounter) {
            PdhCloseQuery(query);
            query = nullptr;
            lib.unload();
            initFailed = true;
            return false;
        }

        PdhCollectQueryData(query);
        initialized = true;
        return true;
    }

    bool queryProcessGpuAndVram(qint64 targetPid, double &gpuOut, double &vramOut) {
        if (!ensureInitialized()) return false;
        if (PdhCollectQueryData(query) != 0) return false;

        QString pidPrefix = QString("pid_%1_").arg(targetPid);
        bool gotAny = false;

        if (gpuEngineCounter) {
            DWORD bufSize = 0;
            DWORD itemCount = 0;
            PDH_STATUS_T st = PdhGetFormattedCounterArrayW(gpuEngineCounter, KV_PDH_FMT_DOUBLE, &bufSize, &itemCount, nullptr);
            if ((st == KV_PDH_MORE_DATA || st == 0) && bufSize > 0) {
                QByteArray buf(static_cast<int>(bufSize), 0);
                auto *items = reinterpret_cast<KvPdhFmtCounterValueItemW *>(buf.data());
                if (PdhGetFormattedCounterArrayW(gpuEngineCounter, KV_PDH_FMT_DOUBLE, &bufSize, &itemCount, items) == 0) {
                    double sumGpu = 0.0;
                    for (DWORD i = 0; i < itemCount; ++i) {
                        if (items[i].szName && items[i].FmtValue.CStatus == 0) {
                            QString name = QString::fromWCharArray(items[i].szName);
                            if (name.contains(pidPrefix, Qt::CaseInsensitive)) {
                                sumGpu += items[i].FmtValue.doubleValue;
                                gotAny = true;
                            }
                        }
                    }
                    if (sumGpu > 100.0) sumGpu = 100.0;
                    gpuOut = sumGpu;
                }
            }
        }

        auto sumMemCounter = [&](PDH_HCOUNTER_T counter) -> double {
            if (!counter) return 0.0;
            DWORD bufSize = 0;
            DWORD itemCount = 0;
            PDH_STATUS_T st = PdhGetFormattedCounterArrayW(counter, KV_PDH_FMT_LARGE, &bufSize, &itemCount, nullptr);
            if ((st == KV_PDH_MORE_DATA || st == 0) && bufSize > 0) {
                QByteArray buf(static_cast<int>(bufSize), 0);
                auto *items = reinterpret_cast<KvPdhFmtCounterValueItemW *>(buf.data());
                if (PdhGetFormattedCounterArrayW(counter, KV_PDH_FMT_LARGE, &bufSize, &itemCount, items) == 0) {
                    double bytesSum = 0.0;
                    for (DWORD i = 0; i < itemCount; ++i) {
                        if (items[i].szName && items[i].FmtValue.CStatus == 0) {
                            QString name = QString::fromWCharArray(items[i].szName);
                            if (name.contains(pidPrefix, Qt::CaseInsensitive)) {
                                bytesSum += static_cast<double>(items[i].FmtValue.largeValue);
                                gotAny = true;
                            }
                        }
                    }
                    return bytesSum / (1024.0 * 1024.0);
                }
            }
            return 0.0;
        };

        double dedMb = sumMemCounter(gpuDedMemCounter);
        if (dedMb <= 0.0) {
            dedMb = sumMemCounter(gpuLocalMemCounter);
        }
        if (dedMb > 0.0) {
            vramOut = dedMb;
        }

        return gotAny;
    }
};
#endif

StatsWorker::StatsWorker(QObject *parent)
    : QObject(parent)
{
    m_netTimer.start();
    m_gpuTimer.start();
    m_nvml = new NvmlContext();
#ifdef _WIN32
    m_winPdh = new WinPdhContext();
#endif
}

StatsWorker::~StatsWorker()
{
    delete m_nvml;
#ifdef _WIN32
    delete m_winPdh;
#endif

    qint64 selfPid = getpid();
    uid_t myUid = getuid();
    QString shmDir = "/dev/shm";
    if (!QDir(shmDir).exists() || !QFileInfo(shmDir).isWritable()) {
        shmDir = QDir::tempPath();
    }
    QString myNetFile = QString("%1/kvision-net-%2-%3").arg(shmDir).arg(myUid).arg(selfPid);
    QString myGpuFile = QString("%1/kvision-gpu-%2-%3").arg(shmDir).arg(myUid).arg(selfPid);
    QString myVramFile = QString("%1/kvision-vram-%2-%3").arg(shmDir).arg(myUid).arg(selfPid);
    QFile::remove(myNetFile);
    QFile::remove(myGpuFile);
    QFile::remove(myVramFile);
}

void StatsWorker::doWork()
{
    if (m_pidCacheTicks <= 0) {
        m_cachedPids = getProgramPids();
        m_pidCacheTicks = 5; // Refresh PID list every 5 seconds to reduce CPU/RAM overhead
    }
    m_pidCacheTicks--;

    QVector<qint64> pids = m_cachedPids;
    qint64 selfPid = getpid();

    bool active = m_uiActive.load(std::memory_order_relaxed);
    const QVector<qint64> targetPids = active ? pids : QVector<qint64>{selfPid};

    double cpu = 0.0;
    double ram = 0.0;
    double gpu = 0.0;
    double vram = 0.0;
    double net = 0.0;

    calculateCpuAndRam(pids, cpu, ram);
    calculateGpuAndVram(targetPids, gpu, vram);
    calculateNetUsage(targetPids, net);

    m_lastCpu = cpu;
    m_lastGpu = gpu;
    m_lastRam = ram;
    m_lastVram = vram;
    m_lastNet = net;

    if (active) {
        emit workDone(cpu, gpu, ram, vram, net);
    }
}

void StatsWorker::emitLatest()
{
    emit workDone(m_lastCpu, m_lastGpu, m_lastRam, m_lastVram, m_lastNet);
}

SystemStats::SystemStats(QObject *parent)
    : QObject(parent)
{
    m_worker = new StatsWorker();
    m_workerThread = new QThread(this);
    m_worker->moveToThread(m_workerThread);

    connect(m_workerThread, &QThread::finished, m_worker, &QObject::deleteLater);

    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, m_worker, &StatsWorker::doWork);
    connect(m_worker, &StatsWorker::workDone, this, &SystemStats::onWorkDone);

    m_workerThread->start();
    m_timer->start(1000); // Always run the timer to report background stats!
}

SystemStats::~SystemStats()
{
    m_timer->stop();
    m_workerThread->quit();
    m_workerThread->wait();
}

void SystemStats::onWorkDone(double cpu, double gpu, double ram, double vram, double net)
{
    m_cpuUsage = cpu;
    m_gpuUsage = gpu;
    m_ramUsage = ram;
    m_vramUsage = vram;
    m_netUsage = net;
    emit statsChanged();
}

bool SystemStats::active() const
{
    return m_active;
}

void SystemStats::setActive(bool active)
{
    if (m_active == active) return;
    m_active = active;
    m_worker->setUiActive(active);

    if (m_active) {
        QMetaObject::invokeMethod(m_worker, "emitLatest", Qt::QueuedConnection);
    } else {
        m_cpuUsage = 0.0;
        m_gpuUsage = 0.0;
        m_ramUsage = 0.0;
        m_vramUsage = 0.0;
        m_netUsage = 0.0;
        emit statsChanged();
    }
    emit activeChanged();
}

QVector<qint64> StatsWorker::getProgramPids()
{
    QVector<qint64> pids;
    qint64 selfPid = getpid();
    pids.append(selfPid);

#ifdef _WIN32
    wchar_t selfPathBuf[MAX_PATH] = {0};
    GetModuleFileNameW(nullptr, selfPathBuf, MAX_PATH);
    QString selfExeName = QFileInfo(QString::fromWCharArray(selfPathBuf)).fileName().toLower();

    struct WinProcInfo {
        qint64 pid;
        qint64 ppid;
        QString exeName;
    };
    QVector<WinProcInfo> allProcs;

    HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snap != INVALID_HANDLE_VALUE) {
        PROCESSENTRY32W pe;
        pe.dwSize = sizeof(pe);
        if (Process32FirstW(snap, &pe)) {
            do {
                qint64 pid = static_cast<qint64>(pe.th32ProcessID);
                if (pid <= 0 || pid == selfPid) continue;
                WinProcInfo info;
                info.pid = pid;
                info.ppid = static_cast<qint64>(pe.th32ParentProcessID);
                info.exeName = QString::fromWCharArray(pe.szExeFile).toLower();
                allProcs.append(info);
            } while (Process32NextW(snap, &pe));
        }
        CloseHandle(snap);
    }

    // Pass 1: Find all direct KVision instances
    for (const WinProcInfo &info : allProcs) {
        bool matches = false;
        if (!selfExeName.isEmpty() && info.exeName == selfExeName) {
            matches = true;
        } else if (info.exeName == "kvision.exe" || info.exeName == "cctv-viewer2.exe" || info.exeName == "cctv-viewer.exe") {
            matches = true;
        }
        if (matches && !pids.contains(info.pid)) {
            pids.append(info.pid);
        }
    }

    // Pass 2: Iteratively add all child processes of any PID in our list
    bool addedAny = true;
    while (addedAny) {
        addedAny = false;
        for (const WinProcInfo &info : allProcs) {
            if (!pids.contains(info.pid) && pids.contains(info.ppid)) {
                pids.append(info.pid);
                addedAny = true;
            }
        }
    }

    return pids;
#else
    uid_t myUid = getuid();
    QString selfExe = QFile::symLinkTarget(QString("/proc/%1/exe").arg(selfPid));

    struct ProcessInfo {
        qint64 pid;
        qint64 ppid;
        uid_t uid;
        QString name;
        QString exePath;
    };
    QVector<ProcessInfo> allProcs;

    QDir procDir("/proc");
    QStringList entries = procDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString &entry : entries) {
        bool ok = false;
        qint64 pid = entry.toLongLong(&ok);
        if (!ok || pid == selfPid) continue;

        ProcessInfo info;
        info.pid = pid;
        info.ppid = -1;
        info.uid = -1;

        QFile statusFile(QString("/proc/%1/status").arg(pid));
        if (statusFile.open(QIODevice::ReadOnly)) {
            QString content = QString::fromUtf8(statusFile.readAll());
            statusFile.close();
            QStringList lines = content.split('\n');
            for (const QString &line : lines) {
                if (line.startsWith("Uid:")) {
                    int colonIdx = line.indexOf(':');
                    if (colonIdx != -1) {
                        QString valStr = line.mid(colonIdx + 1).trimmed();
                        int firstWsIdx = -1;
                        for (int i = 0; i < valStr.length(); ++i) {
                            if (valStr[i].isSpace()) {
                                firstWsIdx = i;
                                break;
                            }
                        }
                        if (firstWsIdx != -1) {
                            valStr = valStr.left(firstWsIdx);
                        }
                        info.uid = valStr.toUInt();
                    }
                } else if (line.startsWith("PPid:")) {
                    int colonIdx = line.indexOf(':');
                    if (colonIdx != -1) {
                        QString valStr = line.mid(colonIdx + 1).trimmed();
                        int firstWsIdx = -1;
                        for (int i = 0; i < valStr.length(); ++i) {
                            if (valStr[i].isSpace()) {
                                firstWsIdx = i;
                                break;
                            }
                        }
                        if (firstWsIdx != -1) {
                            valStr = valStr.left(firstWsIdx);
                        }
                        info.ppid = valStr.toLongLong();
                    }
                }
            }
        }

        if (info.uid != myUid) continue;

        // check executable name via symlink first
        QString exePath = QFile::symLinkTarget(QString("/proc/%1/exe").arg(pid));
        info.exePath = exePath;
        info.name = QFileInfo(exePath).fileName();

        // fallback to cmdline
        if (info.name.isEmpty()) {
            QFile cmdFile(QString("/proc/%1/cmdline").arg(pid));
            if (cmdFile.open(QIODevice::ReadOnly)) {
                QByteArray cmdline = cmdFile.readAll();
                cmdFile.close();
                if (cmdline.contains("kvision") || cmdline.contains("cctv-viewer2") || cmdline.contains("cctv-viewer")) {
                    info.name = "kvision";
                }
            }
        }

        allProcs.append(info);
    }

    // Pass 1: Find all direct cctv-viewer processes or same executable instances
    for (const ProcessInfo &info : allProcs) {
        bool matches = false;
        if (!selfExe.isEmpty() && !info.exePath.isEmpty() && info.exePath == selfExe) {
            matches = true;
        } else if (info.name == "kvision" || info.name == "cctv-viewer2" || info.name == "cctv-viewer") {
            matches = true;
        }

        if (matches) {
            if (!pids.contains(info.pid)) {
                pids.append(info.pid);
            }
        }
    }

    // Pass 2: Iteratively add all child processes of any PID currently in our pids list
    bool addedAny = true;
    while (addedAny) {
        addedAny = false;
        for (const ProcessInfo &info : allProcs) {
            if (!pids.contains(info.pid) && pids.contains(info.ppid)) {
                pids.append(info.pid);
                addedAny = true;
            }
        }
    }

    return pids;
#endif
}

void StatsWorker::calculateCpuAndRam(const QVector<qint64> &pids, double &cpu, double &ram)
{
    qint64 totalCpuTime = 0;
    qint64 processCpuTimeSum = 0;
    double ramUsageSum = 0.0;
    QHash<qint64, qint64> currentProcessCpuTimes;

#ifdef _WIN32
    auto fileTimeToInt64 = [](const FILETIME &ft) -> qint64 {
        ULARGE_INTEGER uli;
        uli.LowPart = ft.dwLowDateTime;
        uli.HighPart = ft.dwHighDateTime;
        return static_cast<qint64>(uli.QuadPart);
    };

    FILETIME idleTime = {0, 0};
    FILETIME kernelTime = {0, 0};
    FILETIME userTime = {0, 0};
    if (GetSystemTimes(&idleTime, &kernelTime, &userTime)) {
        // On Windows, kernelTime already includes idleTime, so kernelTime + userTime = total CPU capacity across all cores
        totalCpuTime = fileTimeToInt64(kernelTime) + fileTimeToInt64(userTime);
    }

    for (qint64 pid : pids) {
        HANDLE hProc = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION | PROCESS_VM_READ, FALSE, static_cast<DWORD>(pid));
        if (!hProc) {
            hProc = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, static_cast<DWORD>(pid));
        }
        if (hProc) {
            FILETIME creationTime = {0, 0};
            FILETIME exitTime = {0, 0};
            FILETIME procKernelTime = {0, 0};
            FILETIME procUserTime = {0, 0};
            if (GetProcessTimes(hProc, &creationTime, &exitTime, &procKernelTime, &procUserTime)) {
                qint64 procTime = fileTimeToInt64(procKernelTime) + fileTimeToInt64(procUserTime);
                currentProcessCpuTimes[pid] = procTime;
                if (m_prevProcessCpuTimes.contains(pid)) {
                    qint64 delta = procTime - m_prevProcessCpuTimes[pid];
                    if (delta > 0) {
                        processCpuTimeSum += delta;
                    }
                }
            }

            PROCESS_MEMORY_COUNTERS pmc;
            std::memset(&pmc, 0, sizeof(pmc));
            pmc.cb = sizeof(pmc);
            if (K32GetProcessMemoryInfo(hProc, &pmc, sizeof(pmc))) {
                ramUsageSum += static_cast<double>(pmc.WorkingSetSize) / (1024.0 * 1024.0);
            }

            CloseHandle(hProc);
        }
    }
#else
    // 1. Read total system CPU time
    QFile statFile("/proc/stat");
    if (statFile.open(QIODevice::ReadOnly)) {
        QTextStream stream(&statFile);
        QString line = stream.readLine();
        statFile.close();
        if (line.startsWith("cpu ")) {
            QString valStr = line.mid(4).trimmed();
            QStringList parts = valStr.split(QChar(' '), Qt::SkipEmptyParts);
            for (int i = 0; i < parts.size() && i < 8; ++i) { // sum user to dirty/steal
                totalCpuTime += parts[i].toLongLong();
            }
        }
    }

    // 2. Read process CPU times and RSS
    for (qint64 pid : pids) {
        // Read /proc/<pid>/stat
        QFile pStatFile(QString("/proc/%1/stat").arg(pid));
        if (pStatFile.open(QIODevice::ReadOnly)) {
            QTextStream stream(&pStatFile);
            QString content = stream.readAll();
            pStatFile.close();

            QStringList parts = content.split(' ');
            if (parts.size() > 17) {
                // utime=14, stime=15, cutime=16, cstime=17 (0-based: 13, 14, 15, 16)
                qint64 utime = parts[13].toLongLong();
                qint64 stime = parts[14].toLongLong();
                qint64 cutime = parts[15].toLongLong();
                qint64 cstime = parts[16].toLongLong();
                qint64 procTime = utime + stime + cutime + cstime;
                currentProcessCpuTimes[pid] = procTime;

                if (m_prevProcessCpuTimes.contains(pid)) {
                    processCpuTimeSum += (procTime - m_prevProcessCpuTimes[pid]);
                }
            }
        }

        // Read /proc/<pid>/status for RAM (VmRSS)
        QFile pStatusFile(QString("/proc/%1/status").arg(pid));
        if (pStatusFile.open(QIODevice::ReadOnly)) {
            QString content = QString::fromUtf8(pStatusFile.readAll());
            pStatusFile.close();
            QStringList lines = content.split('\n');
            for (const QString &line : lines) {
                if (line.startsWith("VmRSS:")) {
                    int colonIdx = line.indexOf(':');
                    if (colonIdx != -1) {
                        QString valStr = line.mid(colonIdx + 1).trimmed();
                        int spaceIdx = valStr.indexOf(' ');
                        if (spaceIdx != -1) {
                            valStr = valStr.left(spaceIdx);
                        }
                        ramUsageSum += valStr.toDouble() / 1024.0; // convert kB to MB
                    }
                }
            }
        }
    }
#endif

    // Calculate CPU %
    if (m_prevTotalCpuTime > 0 && totalCpuTime > m_prevTotalCpuTime) {
        qint64 sysDelta = totalCpuTime - m_prevTotalCpuTime;
        cpu = (static_cast<double>(processCpuTimeSum) / sysDelta) * 100.0;
        if (cpu < 0.0) cpu = 0.0;
        if (cpu > 100.0) cpu = 100.0;
    } else {
        cpu = 0.0;
    }

    m_prevTotalCpuTime = totalCpuTime;
    m_prevProcessCpuTimes = currentProcessCpuTimes;
    ram = ramUsageSum;
}

void StatsWorker::calculateGpuAndVram(const QVector<qint64> &pids, double &gpu, double &vram)
{
    gpu = 0.0;
    vram = 0.0;

    qint64 selfPid = getpid();
    uid_t myUid = getuid();
    QString shmDir = "/dev/shm";
    if (!QDir(shmDir).exists() || !QFileInfo(shmDir).isWritable()) {
        shmDir = QDir::tempPath();
    }

    // Step A: Calculate OWN GPU and VRAM
    double ownGpu = 0.0;
    double ownVram = 0.0;

    // 1. Try Nvidia NVML first for selfPid
    if (m_nvml && m_nvml->ensureInitialized()) {
        unsigned int devCount = 0;
        if (m_nvml->nvmlDeviceGetCount(&devCount) == NVML_SUCCESS && devCount > 0) {
            double vramSum = 0.0;
            double gpuSum = 0.0;
            bool processGpuSuccess = false;

            for (unsigned int i = 0; i < devCount; ++i) {
                nvmlDevice_t device = nullptr;
                if (m_nvml->nvmlDeviceGetHandleByIndex(i, &device) != NVML_SUCCESS) continue;

                // Sum process memory (VRAM)
                unsigned int procCount = 128;
                nvmlProcessInfo_t procInfos[128];
                
                // Graphics processes
                if (m_nvml->nvmlDeviceGetGraphicsRunningProcesses(device, &procCount, procInfos) == NVML_SUCCESS) {
                    for (unsigned int p = 0; p < procCount; ++p) {
                        if (procInfos[p].pid == static_cast<unsigned int>(selfPid) &&
                            procInfos[p].usedGpuMemory != ~0ULL &&
                            procInfos[p].usedGpuMemory < (1ULL << 44)) {
                            vramSum += procInfos[p].usedGpuMemory / (1024.0 * 1024.0); // B to MiB
                        }
                    }
                }
                
                // Compute processes
                procCount = 128;
                if (m_nvml->nvmlDeviceGetComputeRunningProcesses(device, &procCount, procInfos) == NVML_SUCCESS) {
                    for (unsigned int p = 0; p < procCount; ++p) {
                        if (procInfos[p].pid == static_cast<unsigned int>(selfPid) &&
                            procInfos[p].usedGpuMemory != ~0ULL &&
                            procInfos[p].usedGpuMemory < (1ULL << 44)) {
                            vramSum += procInfos[p].usedGpuMemory / (1024.0 * 1024.0); // B to MiB
                        }
                    }
                }

                // Process specific GPU utilization
                if (m_nvml->nvmlDeviceGetProcessUtilization) {
                    unsigned int sampleCount = 128;
                    nvmlProcessUtilizationSample_t samples[128];
                    if (m_nvml->nvmlDeviceGetProcessUtilization(device, samples, &sampleCount, 0) == NVML_SUCCESS) {
                        double devGpuSum = 0.0;
                        int selfSamplesCount = 0;
                        for (unsigned int s = 0; s < sampleCount; ++s) {
                            if (samples[s].pid == static_cast<unsigned int>(selfPid)) {
                                devGpuSum += samples[s].smUtil + samples[s].decUtil + samples[s].encUtil; // Combined GPU % (SM + Decoder + Encoder)
                                selfSamplesCount++;
                                processGpuSuccess = true;
                            }
                        }
                        if (selfSamplesCount > 0) {
                            gpuSum += (devGpuSum / selfSamplesCount);
                        }
                    }
                }
            }

            ownVram = vramSum;

            if (processGpuSuccess) {
                ownGpu = gpuSum;
                if (ownGpu > 100.0) ownGpu = 100.0;
            }
        }
    }

#ifdef _WIN32
    // 2. Try Windows PDH (GPU Engine & GPU Process Memory) for NVIDIA, AMD, and Intel on Windows
    if ((ownGpu <= 0.0 || ownVram <= 0.0) && m_winPdh) {
        double pdhGpu = 0.0;
        double pdhVram = 0.0;
        if (m_winPdh->queryProcessGpuAndVram(selfPid, pdhGpu, pdhVram)) {
            if (ownGpu <= 0.0 && pdhGpu > 0.0) {
                ownGpu = pdhGpu;
            }
            if (ownVram <= 0.0 && pdhVram > 0.0) {
                ownVram = pdhVram;
            }
        }
    }
#else
    // 2. Try DRM Client Stats (for AMD, Intel, and fallback Nvidia) for selfPid
    if (ownGpu <= 0.0) {
        double drmVramSum = 0.0;
        qint64 totalEngineDeltaNs = 0;
        QHash<QString, qint64> nextDrmEngineTimes;
        bool hasDrmClients = false;

        QString fdInfoPath = QString("/proc/%1/fdinfo").arg(selfPid);
        QDir dir(fdInfoPath);
        if (dir.exists()) {
            QStringList files = dir.entryList(QDir::Files);
            for (const QString &fdName : files) {
                QFile f(dir.absoluteFilePath(fdName));
                if (!f.open(QIODevice::ReadOnly)) continue;

                QTextStream stream(&f);
                bool isDrm = false;
                qint64 fdEngineTime = 0;

                while (!stream.atEnd()) {
                    QString line = stream.readLine().trimmed();
                    if (line.startsWith("drm-driver:")) {
                        isDrm = true;
                        hasDrmClients = true;
                    } else if (line.startsWith("drm-engine-")) {
                        int colonIdx = line.indexOf(':');
                        if (colonIdx != -1) {
                            QString valStr = line.mid(colonIdx + 1).trimmed();
                            int spaceIdx = -1;
                            for (int i = 0; i < valStr.length(); ++i) {
                                if (valStr[i].isSpace()) {
                                    spaceIdx = i;
                                    break;
                                }
                            }
                            if (spaceIdx != -1) {
                                valStr = valStr.left(spaceIdx);
                            }
                            bool ok = false;
                            qint64 val = valStr.toLongLong(&ok);
                            if (ok) {
                                fdEngineTime += val;
                            }
                        }
                    } else if (line.startsWith("drm-memory-vram:")) {
                        int colonIdx = line.indexOf(':');
                        if (colonIdx != -1) {
                            QString valStr = line.mid(colonIdx + 1).trimmed();
                            QString unit = "";
                            int spaceIdx = -1;
                            for (int i = 0; i < valStr.length(); ++i) {
                                if (valStr[i].isSpace()) {
                                    spaceIdx = i;
                                    break;
                                }
                            }
                            if (spaceIdx != -1) {
                                unit = valStr.mid(spaceIdx + 1).trimmed();
                                valStr = valStr.left(spaceIdx);
                            }
                            bool ok = false;
                            double val = valStr.toDouble(&ok);
                            if (ok) {
                                if (unit.toLower() == "kib" || unit.isEmpty()) {
                                    val /= 1024.0;
                                } else if (unit.toLower() == "gib") {
                                    val *= 1024.0;
                                } else if (unit.toLower() == "b") {
                                    val /= (1024.0 * 1024.0);
                                }
                                drmVramSum += val;
                            }
                        }
                    }
                }
                f.close();

                if (isDrm) {
                    QString key = QString("%1:%2").arg(selfPid).arg(fdName);
                    nextDrmEngineTimes[key] = fdEngineTime;
                    if (m_prevDrmEngineTimes.contains(key)) {
                        qint64 delta = fdEngineTime - m_prevDrmEngineTimes[key];
                        if (delta > 0) {
                            totalEngineDeltaNs += delta;
                        }
                    }
                }
            }
        }

        qint64 elapsedMs = m_gpuTimer.restart();
        if (elapsedMs <= 0) elapsedMs = 1000;

        m_prevDrmEngineTimes = nextDrmEngineTimes;

        if (hasDrmClients) {
            if (ownVram <= 0.0) {
                ownVram = drmVramSum;
            }

            double drmGpu = 0.0;
            if (totalEngineDeltaNs > 0) {
                drmGpu = (static_cast<double>(totalEngineDeltaNs) / (elapsedMs * 1000000.0)) * 100.0;
                if (drmGpu > 100.0) drmGpu = 100.0;
            }
            ownGpu = drmGpu;
        }
    }
#endif

    // 3. Try System-wide NVML Fallback (if we are Nvidia but have no process stats)
    if (ownGpu <= 0.0 && m_nvml && m_nvml->initialized) {
        unsigned int devCount = 0;
        if (m_nvml->nvmlDeviceGetCount(&devCount) == NVML_SUCCESS && devCount > 0) {
            nvmlDevice_t device = nullptr;
            if (m_nvml->nvmlDeviceGetHandleByIndex(0, &device) == NVML_SUCCESS) {
                nvmlUtilization_t utilization;
                if (m_nvml->nvmlDeviceGetUtilizationRates(device, &utilization) == NVML_SUCCESS) {
                    ownGpu = utilization.gpu;
                }
            }
        }
    }

#ifndef _WIN32
    // 4. Try AMD/Intel System-wide sysfs fallback
    if (ownGpu <= 0.0) {
        QFile amdGpuBusy("/sys/class/drm/card0/device/gpu_busy_percent");
        if (amdGpuBusy.exists() && amdGpuBusy.open(QIODevice::ReadOnly)) {
            QTextStream stream(&amdGpuBusy);
            ownGpu = stream.readAll().trimmed().toDouble();
            amdGpuBusy.close();

            if (ownVram <= 0.0) {
                QFile amdVram("/sys/class/drm/card0/device/mem_info_vram_used");
                if (amdVram.exists() && amdVram.open(QIODevice::ReadOnly)) {
                    QTextStream vramStream(&amdVram);
                    ownVram = vramStream.readAll().trimmed().toDouble() / (1024.0 * 1024.0); // B to MiB
                    amdVram.close();
                }
            }
        }
    }
#endif

    // Step B: Write OWN GPU and VRAM to shared memory files
    QString myGpuFile = QString("%1/kvision-gpu-%2-%3").arg(shmDir).arg(myUid).arg(selfPid);
    QFile fGpu(myGpuFile);
    if (fGpu.open(QIODevice::WriteOnly)) {
        QTextStream stream(&fGpu);
        stream << QString::number(ownGpu, 'f', 2);
        fGpu.close();
    }

    QString myVramFile = QString("%1/kvision-vram-%2-%3").arg(shmDir).arg(myUid).arg(selfPid);
    QFile fVram(myVramFile);
    if (fVram.open(QIODevice::WriteOnly)) {
        QTextStream stream(&fVram);
        stream << QString::number(ownVram, 'f', 2);
        fVram.close();
    }

    // Step C: Sum GPU and VRAM of all active PIDs
    double totalGpu = 0.0;
    double totalVram = 0.0;

    for (qint64 pid : pids) {
        if (pid == selfPid) {
            totalGpu += ownGpu;
            totalVram += ownVram;
        } else {
            QString otherGpuFile = QString("%1/kvision-gpu-%2-%3").arg(shmDir).arg(myUid).arg(pid);
            QFile fOtherGpu(otherGpuFile);
            if (fOtherGpu.open(QIODevice::ReadOnly)) {
                double otherGpu = 0.0;
                QTextStream streamOther(&fOtherGpu);
                streamOther >> otherGpu;
                totalGpu += otherGpu;
                fOtherGpu.close();
            }

            QString otherVramFile = QString("%1/kvision-vram-%2-%3").arg(shmDir).arg(myUid).arg(pid);
            QFile fOtherVram(otherVramFile);
            if (fOtherVram.open(QIODevice::ReadOnly)) {
                double otherVram = 0.0;
                QTextStream streamOther(&fOtherVram);
                streamOther >> otherVram;
                totalVram += otherVram;
                fOtherVram.close();
            }
        }
    }

    if (totalGpu > 100.0) totalGpu = 100.0;
    gpu = totalGpu;
    vram = totalVram;
}

void StatsWorker::calculateNetUsage(const QVector<qint64> &pids, double &net)
{
    qint64 diffBytes = g_networkBytesAccumulator.exchange(0, std::memory_order_relaxed);
    qint64 elapsedMs = m_netTimer.restart();
    if (elapsedMs <= 0) elapsedMs = 1000;

    // Convert to bits per second (bps)
    double bps = (static_cast<double>(diffBytes) * 8.0) / (elapsedMs / 1000.0);

    qint64 selfPid = getpid();
    uid_t myUid = getuid();

    // Determine secure shared memory directory
    QString shmDir = "/dev/shm";
    if (!QDir(shmDir).exists() || !QFileInfo(shmDir).isWritable()) {
        shmDir = QDir::tempPath();
    }

    // Write own network bps to shared file
    QString myNetFile = QString("%1/kvision-net-%2-%3").arg(shmDir).arg(myUid).arg(selfPid);
    QFile f(myNetFile);
    if (f.open(QIODevice::WriteOnly)) {
        QTextStream stream(&f);
        stream << QString::number(bps, 'f', 1);
        f.close();
    }

    // Sum network bps of all active pids
    double totalBps = 0.0;
    for (qint64 pid : pids) {
        if (pid == selfPid) {
            totalBps += bps;
        } else {
            QString otherNetFile = QString("%1/kvision-net-%2-%3").arg(shmDir).arg(myUid).arg(pid);
            QFile fOther(otherNetFile);
            if (fOther.open(QIODevice::ReadOnly)) {
                double otherBps = 0.0;
                QTextStream streamOther(&fOther);
                streamOther >> otherBps;
                totalBps += otherBps;
                fOther.close();
            }
        }
    }

    // Convert to Megabits per second (Mbps)
    net = totalBps / 1000000.0;

    // Clean up stale shared files of processes that are no longer running
    static int cleanTicks = 0;
    if (++cleanTicks >= 10) {
        cleanTicks = 0;
        QDir dir(shmDir);
        QString prefixNet = QString("kvision-net-%1-").arg(myUid);
        QString prefixGpu = QString("kvision-gpu-%1-").arg(myUid);
        QString prefixVram = QString("kvision-vram-%1-").arg(myUid);
        
        QStringList netFiles = dir.entryList(QStringList() << prefixNet + "*", QDir::Files);
        for (const QString &fileName : netFiles) {
            QString pidPart = fileName.mid(prefixNet.length());
            bool ok = false;
            qint64 pid = pidPart.toLongLong(&ok);
            if (ok && !pids.contains(pid) && pid != selfPid) {
                dir.remove(fileName);
            }
        }
        
        QStringList gpuFiles = dir.entryList(QStringList() << prefixGpu + "*", QDir::Files);
        for (const QString &fileName : gpuFiles) {
            QString pidPart = fileName.mid(prefixGpu.length());
            bool ok = false;
            qint64 pid = pidPart.toLongLong(&ok);
            if (ok && !pids.contains(pid) && pid != selfPid) {
                dir.remove(fileName);
            }
        }

        QStringList vramFiles = dir.entryList(QStringList() << prefixVram + "*", QDir::Files);
        for (const QString &fileName : vramFiles) {
            QString pidPart = fileName.mid(prefixVram.length());
            bool ok = false;
            qint64 pid = pidPart.toLongLong(&ok);
            if (ok && !pids.contains(pid) && pid != selfPid) {
                dir.remove(fileName);
            }
        }
    }
}
