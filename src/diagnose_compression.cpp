#include <QCoreApplication>
#include <QDebug>
#include <iostream>
#include <cstring>
#include <vector>
#include "hcnetsdk_compat.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    std::cout << "=== DIAGNOSTYKA USTAWIEŃ ENKODOWANIA NVR ===" << std::endl;

    std::string ip = "172.16.1.214";
    std::string user = "admin";
    std::string pass = "copernicus.33224";

    if (argc > 1) {
        ip = argv[1];
    }
    if (argc > 2) {
        user = argv[2];
    }
    if (argc > 3) {
        pass = argv[3];
    }

    std::cout << "[COMP] Rejestrator IP: " << ip << std::endl;

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
        std::cerr << "[COMP] Błąd logowania! Kod błędu:" << NET_DVR_GetLastError() << std::endl;
        return -1;
    }

    std::cout << "[COMP] Zalogowano pomyślnie." << std::endl;

    int analogStart = deviceInfo.struDeviceV30.byStartChan;
    int analogCount = deviceInfo.struDeviceV30.byChanNum;
    int ipStart = deviceInfo.struDeviceV30.byStartDChan;
    int ipCount = deviceInfo.struDeviceV30.byIPChanNum;

    std::cout << "Kanały analogowe: " << analogStart << " - " << (analogStart + analogCount - 1) << " (Ilość: " << analogCount << ")" << std::endl;
    std::cout << "Kanały IP: " << ipStart << " - " << (ipStart + ipCount - 1) << " (Ilość: " << ipCount << ")" << std::endl;

    std::vector<int> channelsToTest;
    for (int i = 0; i < analogCount; ++i) {
        channelsToTest.push_back(analogStart + i);
    }
    for (int i = 0; i < ipCount; ++i) {
        channelsToTest.push_back(ipStart + i);
    }

    for (int chan : channelsToTest) {
        NET_DVR_COMPRESSIONCFG_V30 compCfg;
        std::memset(&compCfg, 0, sizeof(NET_DVR_COMPRESSIONCFG_V30));
        DWORD returnedBytes = 0;

        if (NET_DVR_GetDVRConfig(userId, NET_DVR_GET_COMPRESSCFG_V30, chan, &compCfg, sizeof(NET_DVR_COMPRESSIONCFG_V30), &returnedBytes)) {
            std::cout << "Kanał SDK " << chan << ":" << std::endl;
            
            // byStreamType highest bit is a flag, we mask it out to get the actual stream type: 0 - video, 1 - video&audio
            int mainStreamType = compCfg.struNormHighRecordPara.byStreamType & 0x7F;
            int mainAudioEnc = compCfg.struNormHighRecordPara.byAudioEncType;
            
            std::cout << "  [NormHighRecord - Główny Strumień] Typ strumienia: " 
                      << mainStreamType << " (" 
                      << (mainStreamType == 0 ? "TYLKO WIDEO (Brak Audio!)" : (mainStreamType == 1 ? "WIDEO I AUDIO" : "NIEZNANY")) 
                      << ")" << std::endl;
            std::cout << "  [NormHighRecord - Główny Strumień] Typ kodowania audio: " << mainAudioEnc << std::endl;

            int netStreamType = compCfg.struNetPara.byStreamType & 0x7F;
            int netAudioEnc = compCfg.struNetPara.byAudioEncType;
            std::cout << "  [NetPara - Podstrumień sieciowy] Typ strumienia: " 
                      << netStreamType << " (" 
                      << (netStreamType == 0 ? "TYLKO WIDEO (Brak Audio!)" : (netStreamType == 1 ? "WIDEO I AUDIO" : "NIEZNANY")) 
                      << ")" << std::endl;
        } else {
            DWORD err = NET_DVR_GetLastError();
            if (err != 9 && err != 23) { 
                std::cout << "Kanał SDK " << chan << ": Błąd pobierania konfiguracji: " << err << std::endl;
            }
        }
    }

    NET_DVR_Logout(userId);
    NET_DVR_Cleanup();
    return 0;
}
