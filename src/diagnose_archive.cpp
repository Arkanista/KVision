#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>
#include <iostream>
#include <thread>
#include <chrono>
#include <cstring>
#include <vector>
#include <mutex>
#include <atomic>
#include "hcnetsdk_compat.h"

// PlayM4 definitions
typedef struct {
    int32_t nWidth;
    int32_t nHeight;
    int32_t nStamp;
    int32_t nType;
    int32_t nFrameRate;
    uint32_t dwFrameNum;
} FRAME_INFO_32;

#define T_YV12 3

// Globals for coordination
std::atomic<bool> g_sysHeadReceived{false};
std::atomic<long> g_audioCallbackCount{0};
std::atomic<long> g_lastAudioStamp{0};
std::atomic<long> g_videoCallbackCount{0};
std::atomic<long> g_decVideoCount{0};
std::atomic<long> g_decAudio8Count{0};
std::atomic<long> g_decAudio16Count{0};
std::atomic<long> g_decOtherCount{0};
LONG g_nPort = -1;
std::atomic<bool> g_setupFailed{false};
std::atomic<bool> g_audioCallBackRegistered{false};

void CALLBACK AudioCallBack(long nPort, char * pAudioBuf, long nSize, long nStamp, long nType, long nUser)
{
    Q_UNUSED(nPort); Q_UNUSED(nUser);
    long count = ++g_audioCallbackCount;
    
    // Obliczamy delta stamp
    long last = g_lastAudioStamp.exchange(nStamp);
    long delta = (last > 0) ? (nStamp - last) : 0;
    double estSampleRate = 0.0;
    if (delta > 0) {
        estSampleRate = static_cast<double>(nSize) * 500.0 / delta;
    }

    if (count <= 10 || count % 50 == 0) {
        std::cout << "[DIAGNOSE-AUDIO] Callback #" << count 
                  << " rozmiar=" << nSize 
                  << " stamp=" << nStamp 
                  << " delta=" << delta 
                  << " typ=" << std::hex << "0x" << nType << std::dec;
        if (delta > 0) {
            std::cout << " szacowany_sample_rate=" << estSampleRate << " Hz";
        }
        
        // Analiza zawartości bufora (czy to nie jest sama cisza - np. same bajty 0x00 lub 0x55/0xff dla G.711)
        if (nSize > 4) {
            const int16_t* samples = reinterpret_cast<const int16_t*>(pAudioBuf);
            int sampleCount = nSize / 2;
            double sumAbs = 0;
            for (int i = 0; i < std::min(100, sampleCount); ++i) {
                sumAbs += std::abs(samples[i]);
            }
            double avgAbs = sumAbs / std::min(100, sampleCount);
            std::cout << " śr_amplituda=" << avgAbs;
        }
        std::cout << std::endl;
    }
}

void CALLBACK PlayDataCallBack(LONG lPlayHandle, DWORD dwDataType, BYTE *pBuffer, DWORD dwBufSize, void *pUser)
{
    Q_UNUSED(lPlayHandle);
    Q_UNUSED(pUser);

    if (dwDataType == NET_DVR_SYSHEAD) {
        g_sysHeadReceived = true;
        std::cout << "[DIAGNOSE] NET_DVR_SYSHEAD (Stream Header) otrzymany, rozmiar=" << dwBufSize << std::endl;
        
        if (g_nPort < 0) {
            std::cerr << "[DIAGNOSE] Błąd: g_nPort < 0!" << std::endl;
            return;
        }

        if (!PlayM4_OpenStream(g_nPort, pBuffer, dwBufSize, 4 * 1024 * 1024)) {
            std::cerr << "[DIAGNOSE] PlayM4_OpenStream nie powiodło się! Błąd:" << PlayM4_GetLastError(g_nPort) << std::endl;
            return;
        }
        std::cout << "[DIAGNOSE] PlayM4_OpenStream OK" << std::endl;

        // Rejestracja callbacku wideo (DecCallBack)
        auto decCallback = [](long nPort, char *pBuf, long nSize, FRAME_INFO *pFrameInfo, long nReserved1, long nReserved2) {
            Q_UNUSED(nPort); Q_UNUSED(pBuf); Q_UNUSED(nSize); Q_UNUSED(nReserved1); Q_UNUSED(nReserved2);
            if (pFrameInfo) {
                FRAME_INFO_32* info = reinterpret_cast<FRAME_INFO_32*>(pFrameInfo);
                if (info->nType == 3) { // T_YV12
                    long c = ++g_decVideoCount;
                    g_videoCallbackCount = c;
                    if (c % 50 == 1) {
                        std::cout << "[DEC-VIDEO] Klatka #" << c << " szerokość=" << info->nWidth << " wysokość=" << info->nHeight << " stamp=" << info->nStamp << std::endl;
                    }
                } else if (info->nType == 100) { // T_AUDIO8
                    long c = ++g_decAudio8Count;
                    std::cout << "[DEC-AUDIO8] Callback #" << c << " rozmiar=" << nSize << " stamp=" << info->nStamp << std::endl;
                } else if (info->nType == 101) { // T_AUDIO16
                    long c = ++g_decAudio16Count;
                    std::cout << "[DEC-AUDIO16] Callback #" << c << " rozmiar=" << nSize << " stamp=" << info->nStamp << std::endl;
                } else {
                    long c = ++g_decOtherCount;
                    std::cout << "[DEC-OTHER] Typ=" << info->nType << " #" << c << " rozmiar=" << nSize << " stamp=" << info->nStamp << std::endl;
                }
            }
        };

        if (!PlayM4_SetDecCallBack(g_nPort, decCallback)) {
            std::cerr << "[DIAGNOSE] PlayM4_SetDecCallBack nie powiodło się! Błąd:" << PlayM4_GetLastError(g_nPort) << std::endl;
        }

        if (!PlayM4_Play(g_nPort, 0)) {
            std::cerr << "[DIAGNOSE] PlayM4_Play nie powiodło się! Błąd:" << PlayM4_GetLastError(g_nPort) << std::endl;
        } else {
            std::cout << "[DIAGNOSE] PlayM4 decoder uruchomiony" << std::endl;
            
            bool playSoundOk = PlayM4_PlaySound(g_nPort);
            if (!playSoundOk) {
                std::cout << "[DIAGNOSE] PlayM4_PlaySound nie powiodło się w SYSHEAD! Błąd: " << PlayM4_GetLastError(g_nPort) << ". Próbujemy PlaySoundShare..." << std::endl;
                playSoundOk = PlayM4_PlaySoundShare(g_nPort);
            }
            if (playSoundOk) {
                std::cout << "[DIAGNOSE] Sukces: Dźwięk uruchomiony w SYSHEAD przed callbackiem!" << std::endl;
            } else {
                std::cerr << "[DIAGNOSE] Błąd: Nie udało się uruchomić dźwięku w SYSHEAD (ani PlaySound, ani PlaySoundShare). Błąd: " << PlayM4_GetLastError(g_nPort) << std::endl;
            }

            if (PlayM4_SetAudioCallBack(g_nPort, AudioCallBack, 0)) {
                std::cout << "[DIAGNOSE] PlayM4_SetAudioCallBack zarejestrowany pomyślnie w SYSHEAD" << std::endl;
                PlayM4_SetVolume(g_nPort, 0); // wyciszamy bezpośrednie wyjście ALSA SDK
                g_audioCallBackRegistered = true;
            } else {
                std::cout << "[DIAGNOSE] PlayM4_SetAudioCallBack nieudany w SYSHEAD. Błąd: " << PlayM4_GetLastError(g_nPort) << ". Spróbujemy ponownie przy napływie strumienia..." << std::endl;
            }
        }

    } else if (dwDataType == NET_DVR_STREAMDATA) {
        if (!g_sysHeadReceived) return;
        if (g_nPort >= 0) {
            PlayM4_InputData(g_nPort, pBuffer, dwBufSize);

            if (!g_audioCallBackRegistered) {
                bool playSoundOk = PlayM4_PlaySound(g_nPort);
                if (!playSoundOk) {
                    playSoundOk = PlayM4_PlaySoundShare(g_nPort);
                }
                if (PlayM4_SetAudioCallBack(g_nPort, AudioCallBack, 0)) {
                    std::cout << "[DIAGNOSE] Sukces: PlayM4_SetAudioCallBack zarejestrowany pomyślnie podczas STREAMDATA!" << std::endl;
                    PlayM4_SetVolume(g_nPort, 0);
                    g_audioCallBackRegistered = true;
                } else {
                    static int failCount = 0;
                    if (++failCount % 100 == 1) {
                        std::cout << "[DIAGNOSE] Ponowna próba PlayM4_SetAudioCallBack nie powiodła się. Błąd: " << PlayM4_GetLastError(g_nPort) << std::endl;
                    }
                }
            }
        }
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    std::cout << "=== DIAGNOSTYKA AUDIO REJESTRATORA HIKVISION ===" << std::endl;

    std::string ip = "172.16.1.214";
    int testChannel = 1;
    std::string user = "admin";
    std::string pass = "copernicus.33224";

    if (argc > 1) {
        ip = argv[1];
    }
    if (argc > 2) {
        testChannel = std::atoi(argv[2]);
    }
    if (argc > 3) {
        user = argv[3];
    }
    if (argc > 4) {
        pass = argv[4];
    }

    std::cout << "[DIAGNOSE] Rejestrator IP: " << ip << std::endl;
    std::cout << "[DIAGNOSE] Testowany kanał logiczny: " << testChannel << std::endl;

    NET_DVR_Init();

    NET_DVR_DEVICEINFO_V40 deviceInfo;
    std::memset(&deviceInfo, 0, sizeof(NET_DVR_DEVICEINFO_V40));

    NET_DVR_USER_LOGIN_INFO loginInfo;
    std::memset(&loginInfo, 0, sizeof(NET_DVR_USER_LOGIN_INFO));
    std::strncpy(loginInfo.sDeviceAddress, ip.c_str(), sizeof(loginInfo.sDeviceAddress) - 1);
    loginInfo.wPort = 8000;
    std::strncpy(loginInfo.sUserName, user.c_str(), sizeof(loginInfo.sUserName) - 1);
    std::strncpy(loginInfo.sPassword, pass.c_str(), sizeof(loginInfo.sPassword) - 1);
    loginInfo.bUseAsynLogin = FALSE;

    LONG userId = NET_DVR_Login_V40(&loginInfo, &deviceInfo);
    if (userId < 0) {
        std::cerr << "[DIAGNOSE] Błąd logowania! Kod błędu:" << NET_DVR_GetLastError() << std::endl;
        return -1;
    }

    std::cout << "[DIAGNOSE] Zalogowano pomyślnie. UserID: " << userId << std::endl;
    std::cout << "[DIAGNOSE] Parametry NVR:" << std::endl;
    std::cout << "  StartChan (analogowe): " << (int)deviceInfo.struDeviceV30.byStartChan << std::endl;
    std::cout << "  ChanNum (analogowe): " << (int)deviceInfo.struDeviceV30.byChanNum << std::endl;
    std::cout << "  StartDChan (cyfrowe IP): " << (int)deviceInfo.struDeviceV30.byStartDChan << std::endl;
    std::cout << "  IPChanNum (cyfrowe IP): " << (int)deviceInfo.struDeviceV30.byIPChanNum << std::endl;

    // Obliczamy SDK channel
    int sdkChannel = testChannel;
    if (deviceInfo.struDeviceV30.byChanNum == 0 && deviceInfo.struDeviceV30.byIPChanNum > 0) {
        sdkChannel = testChannel + deviceInfo.struDeviceV30.byStartDChan - 1;
    } else if (deviceInfo.struDeviceV30.byChanNum > 0 && testChannel > deviceInfo.struDeviceV30.byChanNum) {
        sdkChannel = deviceInfo.struDeviceV30.byStartDChan + (testChannel - deviceInfo.struDeviceV30.byChanNum) - 1;
    } else if (deviceInfo.struDeviceV30.byChanNum > 0 && testChannel <= deviceInfo.struDeviceV30.byChanNum) {
        sdkChannel = testChannel + deviceInfo.struDeviceV30.byStartChan - 1;
    }
    std::cout << "[DIAGNOSE] SDK Channel: " << sdkChannel << std::endl;

    // Pobierzmy czas - sprawdzimy ostatnie 30 minut
    QDateTime testTime = QDateTime::currentDateTime().addSecs(-1800);
    QDateTime endTime = QDateTime::currentDateTime();
    std::cout << "[DIAGNOSE] Odtwarzanie od: " << testTime.toString("yyyy-MM-dd hh:mm:ss").toStdString() 
              << " do: " << endTime.toString("yyyy-MM-dd hh:mm:ss").toStdString() << std::endl;

    NET_DVR_TIME startTime;
    startTime.dwYear = testTime.date().year();
    startTime.dwMonth = testTime.date().month();
    startTime.dwDay = testTime.date().day();
    startTime.dwHour = testTime.time().hour();
    startTime.dwMinute = testTime.time().minute();
    startTime.dwSecond = testTime.time().second();

    NET_DVR_TIME stopTime;
    stopTime.dwYear = endTime.date().year();
    stopTime.dwMonth = endTime.date().month();
    stopTime.dwDay = endTime.date().day();
    stopTime.dwHour = endTime.time().hour();
    stopTime.dwMinute = endTime.time().minute();
    stopTime.dwSecond = endTime.time().second();

    LONG playHandle = NET_DVR_PlayBackByTime(userId, sdkChannel, &startTime, &stopTime, 0);
    if (playHandle < 0) {
        std::cerr << "[DIAGNOSE] NET_DVR_PlayBackByTime nie powiodło się! Kod błędu:" << NET_DVR_GetLastError() << std::endl;
        NET_DVR_Logout(userId);
        return -1;
    }
    std::cout << "[DIAGNOSE] Odtwarzanie zainicjowane, handle: " << playHandle << std::endl;

    if (!PlayM4_GetPort(&g_nPort)) {
        std::cerr << "[DIAGNOSE] PlayM4_GetPort nie powiodło się!" << std::endl;
        NET_DVR_StopPlayBack(playHandle);
        NET_DVR_Logout(userId);
        return -1;
    }
    std::cout << "[DIAGNOSE] Port PlayM4 przydzielony: " << g_nPort << std::endl;

    PlayM4_SetStreamOpenMode(g_nPort, STREAME_FILE);

    if (!NET_DVR_SetPlayDataCallBack_V40(playHandle, PlayDataCallBack, nullptr)) {
        std::cerr << "[DIAGNOSE] NET_DVR_SetPlayDataCallBack_V40 nie powiodło się! Błąd:" << NET_DVR_GetLastError() << std::endl;
        NET_DVR_StopPlayBack(playHandle);
        NET_DVR_Logout(userId);
        return -1;
    }

    if (!NET_DVR_PlayBackControl_V40(playHandle, NET_DVR_PLAYSTART, nullptr, 0, nullptr, nullptr)) {
        std::cerr << "[DIAGNOSE] NET_DVR_PLAYSTART nie powiodło się! Błąd:" << NET_DVR_GetLastError() << std::endl;
        NET_DVR_StopPlayBack(playHandle);
        NET_DVR_Logout(userId);
        return -1;
    }
    std::cout << "[DIAGNOSE] NET_DVR_PLAYSTART uruchomiony" << std::endl;

    if (!NET_DVR_PlayBackControl_V40(playHandle, NET_DVR_PLAYSTARTAUDIO, nullptr, 0, nullptr, nullptr)) {
        std::cerr << "[DIAGNOSE] NET_DVR_PLAYSTARTAUDIO nie powiodło się! Błąd:" << NET_DVR_GetLastError() << std::endl;
    } else {
        std::cout << "[DIAGNOSE] NET_DVR_PLAYSTARTAUDIO uruchomiony" << std::endl;
    }

    // Odczekajmy na napływ klatek i callbacków audio
    std::cout << "[DIAGNOSE] Rozpoczynam zbieranie danych diagnostycznych..." << std::endl;
    for (int i = 0; i < 50; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        if (g_setupFailed) {
            std::cout << "[DIAGNOSE] Wykryto niepowodzenie rejestracji callbacku audio (g_setupFailed=true), przerywam." << std::endl;
            break;
        }
        if (g_audioCallbackCount > 0) {
            std::cout << "[DIAGNOSE] Sukces: Otrzymano pakiety audio!" << std::endl;
            break;
        }
        if (g_videoCallbackCount > 50 && i > 20) {
            std::cout << "[DIAGNOSE] Otrzymano klatki wideo (" << g_videoCallbackCount << "), ale brak audio po 2 sekundach. Przerywam." << std::endl;
            break;
        }
    }

    // Sprzątanie
    std::cout << "[DIAGNOSE] Kończenie zbierania danych..." << std::endl;
    NET_DVR_StopPlayBack(playHandle);
    if (g_nPort >= 0) {
        PlayM4_StopSound();
        PlayM4_Stop(g_nPort);
        PlayM4_CloseStream(g_nPort);
        PlayM4_FreePort(g_nPort);
    }
    NET_DVR_Logout(userId);
    NET_DVR_Cleanup();

    std::cout << "=== PODSUMOWANIE DIAGNOSTYKI ===" << std::endl;
    std::cout << "Odebranych klatek wideo (AudioCallBack check): " << g_videoCallbackCount << std::endl;
    std::cout << "Odebranych pakietów audio (AudioCallBack): " << g_audioCallbackCount << std::endl;
    std::cout << "DecCallBack counts:" << std::endl;
    std::cout << "  Video (T_YV12): " << g_decVideoCount << std::endl;
    std::cout << "  Audio8 (T_AUDIO8): " << g_decAudio8Count << std::endl;
    std::cout << "  Audio16 (T_AUDIO16): " << g_decAudio16Count << std::endl;
    std::cout << "  Other: " << g_decOtherCount << std::endl;
    if (g_audioCallbackCount > 0) {
        std::cout << "SUKCES: Rejestrator wysyła pakiety audio do AudioCallBack!" << std::endl;
    } else if (g_decAudio8Count > 0 || g_decAudio16Count > 0) {
        std::cout << "SUKCES: Rejestrator wysyła pakiety audio do DecCallBack!" << std::endl;
    } else {
        std::cout << "OSTRZEŻENIE: Brak jakichkolwiek pakietów audio w callbacku. Czy kamera na pewno nagrywa dźwięk dla tego okresu?" << std::endl;
    }

    return 0;
}
