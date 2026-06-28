#include <QCoreApplication>
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

// Globals
std::atomic<bool> g_sysHeadReceived{false};
std::atomic<long> g_audioCallbackCount{0};
std::atomic<long> g_lastAudioStamp{0};
std::atomic<long> g_videoCallbackCount{0};
LONG g_nPort = -1;
std::atomic<bool> g_setupFailed{false};
std::atomic<bool> g_audioCallBackRegistered{false};

void CALLBACK AudioCallBack(long nPort, char * pAudioBuf, long nSize, long nStamp, long nType, long nUser)
{
    Q_UNUSED(nPort); Q_UNUSED(nUser);
    long count = ++g_audioCallbackCount;
    long last = g_lastAudioStamp.exchange(nStamp);
    long delta = (last > 0) ? (nStamp - last) : 0;

    if (count <= 10 || count % 50 == 0) {
        std::cout << "[LIVE-AUDIO] Callback #" << count 
                  << " rozmiar=" << nSize 
                  << " stamp=" << nStamp 
                  << " delta=" << delta 
                  << " typ=0x" << std::hex << nType << std::dec << std::endl;
    }
}

void CALLBACK LiveDataCallBack(LONG lPlayHandle, DWORD dwDataType, BYTE *pBuffer, DWORD dwBufSize, void *pUser)
{
    Q_UNUSED(lPlayHandle);
    Q_UNUSED(pUser);

    if (dwDataType == NET_DVR_SYSHEAD) {
        g_sysHeadReceived = true;
        std::cout << "[LIVE] NET_DVR_SYSHEAD (Stream Header) otrzymany, rozmiar=" << dwBufSize << std::endl;
        
        if (g_nPort < 0) {
            std::cerr << "[LIVE] Błąd: g_nPort < 0!" << std::endl;
            return;
        }

        if (!PlayM4_OpenStream(g_nPort, pBuffer, dwBufSize, 4 * 1024 * 1024)) {
            std::cerr << "[LIVE] PlayM4_OpenStream nie powiodło się! Błąd:" << PlayM4_GetLastError(g_nPort) << std::endl;
            return;
        }
        std::cout << "[LIVE] PlayM4_OpenStream OK" << std::endl;

        // DecCallBack for video
        auto decCallback = [](long nPort, char *pBuf, long nSize, FRAME_INFO *pFrameInfo, long nReserved1, long nReserved2) {
            Q_UNUSED(nPort); Q_UNUSED(pBuf); Q_UNUSED(nSize); Q_UNUSED(nReserved1); Q_UNUSED(nReserved2);
            g_videoCallbackCount++;
            if (pFrameInfo) {
                FRAME_INFO_32* info = reinterpret_cast<FRAME_INFO_32*>(pFrameInfo);
                if (g_videoCallbackCount % 50 == 1) {
                    std::cout << "[LIVE-VIDEO] Klatka #" << g_videoCallbackCount 
                              << " typ=" << info->nType << " szerokość=" << info->nWidth 
                              << " wysokość=" << info->nHeight << " stamp=" << info->nStamp << std::endl;
                }
            }
        };

        if (!PlayM4_SetDecCallBack(g_nPort, decCallback)) {
            std::cerr << "[LIVE] PlayM4_SetDecCallBack nie powiodło się! Błąd:" << PlayM4_GetLastError(g_nPort) << std::endl;
        }

        if (!PlayM4_Play(g_nPort, 0)) {
            std::cerr << "[LIVE] PlayM4_Play nie powiodło się! Błąd:" << PlayM4_GetLastError(g_nPort) << std::endl;
        } else {
            std::cout << "[LIVE] PlayM4 decoder uruchomiony" << std::endl;
            if (PlayM4_SetAudioCallBack(g_nPort, AudioCallBack, 0)) {
                std::cout << "[LIVE] PlayM4_SetAudioCallBack zarejestrowany pomyślnie w SYSHEAD" << std::endl;
                PlayM4_SetVolume(g_nPort, 0);
                if (PlayM4_PlaySound(g_nPort)) {
                    std::cout << "[LIVE] PlayM4_PlaySound uruchomiony w SYSHEAD" << std::endl;
                }
                g_audioCallBackRegistered = true;
            } else {
                std::cout << "[LIVE] PlayM4_SetAudioCallBack nieudany w SYSHEAD. Błąd: " << PlayM4_GetLastError(g_nPort) << ". Spróbujemy ponownie przy napływie strumienia..." << std::endl;
            }
        }

    } else if (dwDataType == NET_DVR_STREAMDATA) {
        if (!g_sysHeadReceived) return;
        if (g_nPort >= 0) {
            PlayM4_InputData(g_nPort, pBuffer, dwBufSize);

            if (!g_audioCallBackRegistered) {
                if (PlayM4_SetAudioCallBack(g_nPort, AudioCallBack, 0)) {
                    std::cout << "[LIVE] Sukces: PlayM4_SetAudioCallBack zarejestrowany pomyślnie podczas STREAMDATA!" << std::endl;
                    PlayM4_SetVolume(g_nPort, 0);
                    if (PlayM4_PlaySound(g_nPort)) {
                        std::cout << "[LIVE] PlayM4_PlaySound uruchomiony pomyślnie podczas STREAMDATA" << std::endl;
                    } else {
                        std::cerr << "[LIVE] PlayM4_PlaySound nie powiodło się podczas STREAMDATA! Błąd: " << PlayM4_GetLastError(g_nPort) << std::endl;
                    }
                    g_audioCallBackRegistered = true;
                } else {
                    static int failCount = 0;
                    if (++failCount % 100 == 1) {
                        std::cout << "[LIVE] Ponowna próba PlayM4_SetAudioCallBack nie powiodła się. Błąd: " << PlayM4_GetLastError(g_nPort) << std::endl;
                    }
                }
            }
        }
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    std::cout << "=== DIAGNOSTYKA AUDIO LIVE VIEW ===" << std::endl;

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

    std::cout << "[LIVE] Rejestrator IP: " << ip << std::endl;
    std::cout << "[LIVE] Testowany kanał logiczny: " << testChannel << std::endl;

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
        std::cerr << "[LIVE] Błąd logowania! Kod błędu:" << NET_DVR_GetLastError() << std::endl;
        return -1;
    }

    // Obliczamy SDK channel
    int sdkChannel = testChannel;
    if (deviceInfo.struDeviceV30.byChanNum == 0 && deviceInfo.struDeviceV30.byIPChanNum > 0) {
        sdkChannel = testChannel + deviceInfo.struDeviceV30.byStartDChan - 1;
    } else if (deviceInfo.struDeviceV30.byChanNum > 0 && testChannel > deviceInfo.struDeviceV30.byChanNum) {
        sdkChannel = deviceInfo.struDeviceV30.byStartDChan + (testChannel - deviceInfo.struDeviceV30.byChanNum) - 1;
    } else if (deviceInfo.struDeviceV30.byChanNum > 0 && testChannel <= deviceInfo.struDeviceV30.byChanNum) {
        sdkChannel = testChannel + deviceInfo.struDeviceV30.byStartChan - 1;
    }
    std::cout << "[LIVE] SDK Channel: " << sdkChannel << std::endl;

    NET_DVR_PREVIEWINFO previewInfo;
    std::memset(&previewInfo, 0, sizeof(NET_DVR_PREVIEWINFO));
    previewInfo.lChannel = sdkChannel;
    previewInfo.dwStreamType = 0; // Main stream
    previewInfo.dwLinkMode = 0;   // TCP
    previewInfo.bBlocked = FALSE;

    LONG realPlayHandle = NET_DVR_RealPlay_V40(userId, &previewInfo, LiveDataCallBack, nullptr);
    if (realPlayHandle < 0) {
        std::cerr << "[LIVE] NET_DVR_RealPlay_V40 nie powiodło się! Kod błędu:" << NET_DVR_GetLastError() << std::endl;
        NET_DVR_Logout(userId);
        return -1;
    }
    std::cout << "[LIVE] Podgląd na żywo zainicjowany, handle: " << realPlayHandle << std::endl;

    if (!PlayM4_GetPort(&g_nPort)) {
        std::cerr << "[LIVE] PlayM4_GetPort nie powiodło się!" << std::endl;
        NET_DVR_StopRealPlay(realPlayHandle);
        NET_DVR_Logout(userId);
        return -1;
    }
    std::cout << "[LIVE] Port PlayM4 przydzielony: " << g_nPort << std::endl;

    PlayM4_SetStreamOpenMode(g_nPort, STREAME_REALTIME);

    // Czekamy chwilę i sprawdzamy
    std::cout << "[LIVE] Rozpoczynam zbieranie danych na żywo..." << std::endl;
    for (int i = 0; i < 30; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        if (g_setupFailed) {
            std::cout << "[LIVE] Wykryto niepowodzenie rejestracji callbacku audio (g_setupFailed=true), przerywam." << std::endl;
            break;
        }
        if (g_audioCallbackCount > 0) {
            std::cout << "[LIVE] Sukces: Otrzymano pakiety audio na żywo!" << std::endl;
            break;
        }
        if (g_videoCallbackCount > 50 && i > 15) {
            std::cout << "[LIVE] Otrzymano klatki wideo na żywo, ale brak audio po 1.5 sekundy. Przerywam." << std::endl;
            break;
        }
    }

    // Sprzątanie
    NET_DVR_StopRealPlay(realPlayHandle);
    if (g_nPort >= 0) {
        PlayM4_Stop(g_nPort);
        PlayM4_CloseStream(g_nPort);
        PlayM4_FreePort(g_nPort);
    }
    NET_DVR_Logout(userId);
    NET_DVR_Cleanup();

    std::cout << "=== PODSUMOWANIE LIVE VIEW ===" << std::endl;
    std::cout << "Odebranych klatek wideo: " << g_videoCallbackCount << std::endl;
    std::cout << "Odebranych pakietów audio: " << g_audioCallbackCount << std::endl;
    return 0;
}
