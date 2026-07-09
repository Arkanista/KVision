# KVision Kullanım Kılavuzu

> [!NOT]
> Bu kullanım kılavuzu Yapay Zeka (AI) yardımıyla otomatik olarak tercüme edilmiş ve formatlanmıştır.

**KVision**, canlı video akışlarının (RTSP/ONVIF) eşzamanlı olarak görüntülenmesi ve Hikvision NVR/DVR kayıt cihazlarıyla (hem Canlı modda hem de Oynatma arşiv modunda) entegrasyon için tasarlanmış gelişmiş bir VMS (Video Yönetim Sistemi) sınıfı masaüstü uygulamasıdır.

Program kararlılık, sorunsuz çalışma (60 FPS) ve minimum sistem kaynağı tüketimi için optimize edilmiştir.

---

## İçindekiler
1. [Düğme Eylemlerinin Açıklaması](#1-description-of-button-actions)
2. [Kurulum ve Başlatma](#2-installation-and-launching)
3. [NVR/DVR Kayıt Cihazlarını Yönetme](#3-managing-nvrdvr-recorders)
4. [Canlı Görüntü ve Görüntü Alanı Yer Paylaşımları](#4-live-view-and-viewport-overlays)
5. [Ekran Düzenleri, Ön Ayarlar ve Araç Çubuğu](#5-screen-layouts-presets-and-toolbar)
6. [Sistem İstatistikleri Paneli (Sistem İstatistikleri)](#6-system-statistics-panel-system-stats)
7. [Oynatma Arşiv Oynatıcısı](#7-playback-archive-player)
8. [Kayıtları İndirme (İndirici)](#8-downloading-recordings-downloader)
9. [Seçenekler Penceresinde Gelişmiş Ayarlar ve Özelleştirme](#9-advanced-settings-and-customization-in-options-window)
10. [Klavye Kısayolları ve Fare Kontrolleri](#10-keyboard-shortcuts-and-mouse-controls)
11. [Anlık Görüntü Alma ve Yol Yapılandırması](#11-taking-snapshots-and-path-configuration)

---

## 1. Düğme Eylemlerinin Açıklaması

Bu bölümde uygulamada kullanılan tüm grafik simgelerin ve düğmelerin anlamları açıklanmaktadır.

### Üst Araç Çubuğu
* {ICON:quit} **Pencereyi Kapat**: Onay ister ve etkin pencereyi veya uygulamayı kapatır.
* {ICON:pin} **Sabitleme Çubuğu**: Üst çubuğu genişletilmiş durumda kilitler veya otomatik daraltmayı etkinleştirir.
* {ICON:fullscreen} **Tam Ekran**: Etkin pencereyi tam ekran moduna geçirir.
* {ICON:minimize} **Küçült**: Uygulama penceresini sistem görev çubuğuna küçültür.
* {ICON:options} **Seçenekler**: Yapılandırma seçenekleri penceresini (ayarlar ve kaydediciler) açar veya kapatır.
* {ICON:new_window} **Yeni Pencere**: Kamera akışları için yeni, bağımsız bir yardımcı pencere açar.
* {ICON:archive} **Arşiv**: Oynatma kayıtları arşiv penceresini (zaman çizelgesi ve takvim) açar.
* {ICON:instructions} **Talimatlar**: Bu kullanım kılavuzunu ve teknik yardım penceresini açar.
* {ICON:stats} **İstatistikler**: Kayan sistem istatistik panelini (CPU, RAM, GPU, Net) değiştirir.
* {ICON:lock} **Izgara Kilidi**: Etkin düzeninizi korumak için ızgara bölümü ayarlarını devre dışı bırakır.
* {ICON:hamburger} **Diğer Seçenekler**: Gelişmiş bölme boyutları, oranları ve hücre birleştirme için kayan araç kutusunu açar.

### Görüntü Alanı Kaplamaları (Kameralar)
* {ICON:snapshot} **Anlık Görüntü**: Kayıpsız, tam çözünürlüklü bir görüntü yakalar ve onu JPEG dosyası olarak kaydeder.
* {ICON:play} **Kamera Arşivi**: Bu kamera için zaman çizelgesi oynatma penceresini başlatır (15 dakika geriye doğru).
* {ICON:quick_play} **Hızlı Oynatma (Mini Oynatıcı)**: Son 30 dakikanın görünüm içi arşiv oynatmasını başlatarak, Canlı görünümden ayrılmadan en son görüntüleri doğrudan kamera döşemesinde hızlı bir şekilde incelemenize olanak tanır.
* {ICON:grid_1x1} **1:1'i deneyin**: Video akışını uzatmadan orijinal, doğal çözünürlüğünde görüntüler.
* {ICON:zoom_in} **Etkileşimli Yakınlaştırma**: Seçilen bir seçim çerçevesi bölgesi için tıklayıp sürükleyerek büyütmeyi açar veya kapatır.
* {ICON:zoom_out} **Yakınlaştırmayı Sıfırla**: Dijital büyütmeyi sıfırlar ve kameranın tam görüş alanını geri yükler.
* {ICON:speaker_unmute} **Sesi Kapat**: Sesi kapatılmamış bir ses akışını temsil eder; tıklandığında akışın sesi kapatılır.
* {ICON:speaker_mute} **Sesin Sesini Aç**: Sessize alınmış bir ses akışını temsil eder; tıklandığında akışın sesi açılır.

### Oynatma Penceresi Kontrolleri

**Üst Çubuk Kontrolleri:**
* {ICON:close} **Kapat**: Kayıttan yürütme arşiv oynatıcısı penceresini kapatır.
* {ICON:pin} **Sabitleme Çubuğu**: Üst çubuğu genişletilmiş durumda kilitler veya otomatik daraltmayı etkinleştirir.
* {ICON:fullscreen} **Tam Ekran**: Oynatma penceresini tam ekran moduna geçirir.
* {ICON:sidebar} **Kenar Çubuğunu Göster/Gizle**: Kameraları ve kaydedicileri içeren sol kenar çubuğunun görünürlüğünü değiştirir.
* {ICON:timeline_show} / {ICON:timeline_hide} **Zaman Çizelgesini Göster/Gizle**: Zaman çizelgesini ve oynatma kontrollerini içeren alt paneli gösterir veya gizler.
* {ICON:video_folder} **Video Klasörü**: İndirilen video klipleri içeren yerel sistem klasörünü açar.
* {ICON:photo_folder} **Anlık Görüntü Klasörü**: Yakalanan anlık görüntüleri içeren yerel sistem klasörünü açar.
* ızgara düğmeleri `1x1`, `1x2`, `2x1`, `2x2`: Oynatma penceresinin kamera ekranı düzenini 1, 2 (dikey/yatay) veya 4 eşzamanlı görünüme değiştirir.

**Alt Çubuk ve Zaman Çizelgesi Kontrolleri:**
* {ICON:prev_day} **Önceki Gün**: Önceki takvim gününün kayıtlarına gider.
* {ICON:calendar_select} **Tarih Seçici**: Oynatma için belirli bir tarihi seçmek üzere bir takvim iletişim kutusu açar.
* {ICON:next_day} **Sonraki Gün**: Bir sonraki takvim gününün kayıtlarına gider.
* {ICON:today} **Bugün**: Oynatma odağını anında geçerli takvim gününe kaydırır.
* {ICON:refresh_recordings} **Kayıtları yenile**: Cihazdaki mevcut kayıt bölümlerini yeniler ve yeniden sorgular.
* {ICON:zoom_1h} / {ICON:zoom_8h} / {ICON:zoom_24h} **Zaman Çizelgesi Yakınlaştırma Ön Ayarları**: Yüksek hassasiyetli gezinme için zaman çizelgesinin görünür penceresini (1 saat, 8 saat veya 24 saate) ölçeklendirir.
* {ICON:timeline_center} **Zaman Çizelgesini Ortala**: Zaman çizelgesi görünümünü tam olarak mevcut oynatma zaman damgasının etrafında ortalar.
* {ICON:speed_1x} / {ICON:speed_2x} / {ICON:speed_4x} **Oynatma Hızı**: Video oynatma çarpanını ayarlar (standart 1x hız, 2x hızlandırılmış veya 4x hızlı oynatma).
* {ICON:download} **İndir**: Tanımlı bir video segmentini cihazdan dışa aktarmak için indirme aracını açar.
* {ICON:jump_back_60} / {ICON:jump_back_45} / {ICON:jump_back_15} **Geri Atla**: Oynatma zaman damgasını 60, 45 veya 15 saniye geri sarar.
* {ICON:play} / {ICON:pause} **Oynat / Duraklat**: Arşiv video akışı oynatımını başlatır veya duraklatır.
* {ICON:jump_forward_15} / {ICON:jump_forward_45} / {ICON:jump_forward_60} **İleriye Atla**: Oynatma zaman damgasını 15, 45 veya 60 saniye ilerletir.

**Diğer Teşhis ve Genel Simgeler:**
* {ICON:calendar} **Takvim**: Takvim/zamanlama yapılandırmalarını temsil eder.
* {ICON:clock} **Zaman**: Saati veya zamansal durum göstergelerini temsil eder.
* {ICON:zoom} **Yakınlaştırma**: Ölçeklendirmeyi veya dijital yakınlaştırma yapılandırmalarını temsil eder.
* {ICON:timeline_toggle} **Zaman Çizelgesi Geçişi**: Kronolojik görünümlerin değiştirilmesini veya yenilenmesini temsil eder.
* {ICON:trash} **Sil**: Yapılandırılmış kaydedicileri veya düzenleri onayla güvenli bir şekilde kaldırır.
* {ICON:warning} **Uyarı**: Geri dönüşü olmayan eylemler veya silme uyarıları için iletişim kutularında görüntülenir.

---

## 2. Kurulum ve Başlatma

### Arch Linux'a (Pacman) Kurulum
Programı hazırlanan ikili paketten kurmak için `packaging/arch/` dizinine gidin ve şunu çalıştırın:
```bash
sudo pacman -U kvision-2.6.3-1-x86_64.pkg.tar.zst
```
Paket, programı, `.desktop` etkinleştirme dosyasını ve gerekli Hikvision SDK kitaplıklarını `/usr/lib/kvision` sistem yoluna otomatik olarak yükleyecektir.

### Manuel Derleme (kaynak kodundan)
Programı hazır paketi kullanmak yerine manuel olarak (örneğin başka bir Linux dağıtımında) derlemek istiyorsanız:

1. Paket yöneticinizi kullanarak gerekli derleme ve çalışma zamanı bağımlılıklarını yükleyin. Arch Linux / CachyOS için:
   ```bash
   sudo pacman -S base-devel cmake qt5-declarative qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-svg qt5-graphicaleffects qt5-tools ffmpeg git qt5-wayland
   ```
2. Projeyi CMake kullanarak yapılandırın:
   ```bash
   cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
   ```
3. Kodu derleyin:
   ```bash
   cmake --build build -j$(nproc)
   ```
4. Uygulamayı sisteme yükleyin:
   ```bash
   sudo cmake --install build
   ```

### Başlatılıyor
Program sistem menüsünden veya terminale yazılarak başlatılabilir:
```bash
kvision
```

### Sistem Ölçeklendirme Sorunlarını Giderme (KDE Plazma)

Sürüm 2.4.4'ten itibaren KVision, Qt'de yerel Yüksek DPI geçiş politikalarını zorlayarak KDE Plazma ayarlarında yapılandırılmış kesirli masaüstü ölçeklendirmesini (örneğin %125, %145, %150) otomatik olarak algılar ve doğru şekilde uygular. Kullanıcı arayüzü artık herhangi bir manuel müdahaleye gerek kalmadan, kullanıma hazır olarak doğru bir şekilde ölçeklendirilmelidir.

#### Yerel Wayland Desteği

Wayland altında en iyi ölçeklendirme deneyimini ve performansını sağlamak için sisteminizde isteğe bağlı `qt5-wayland` paketinin kurulu olduğundan emin olun. Bu, KVision'ın XWayland'e geri dönmek yerine Wayland'de yerel olarak çalışmasına olanak tanır.

Arch Linux/Manjaro/CachyOS için:
```bash
sudo pacman -S qt5-wayland
```

Debian / Ubuntu / Linux Mint için:
```bash
sudo apt install qtwayland5
```

#### Manuel Ölçeklendirmeyi Geçersiz Kılma (Eski/Geri Dönüş)

Daha eski bir sürümü, alışılmadık bir yapılandırmayı çalıştırıyorsanız veya yalnızca sistemin geri kalanından farklı bir ölçeklendirme faktörünü manuel olarak zorlamak istiyorsanız, ortam değişkenlerini kullanarak uygulama ölçeklendirmesini yine de geçersiz kılabilirsiniz.

Örneğin, **%150** ölçeklendirmeyi zorlamak için uygulamayı terminalden şununla başlatın:
```bash
env QT_FONT_DPI=96 QT_SCALE_FACTOR=1.5 kvision
```

*(KDE menü düzenleyicisinde `kvision.desktop` uygulama başlatıcısını düzenleyerek ve bu değişkenleri "Ortam değişkenleri" alanına ekleyerek bunu kalıcı olarak uygulayabilirsiniz).*

---

## 3. NVR/DVR Kayıt Cihazlarını Yönetme

Hikvision kayıt cihazına bağlantıyı yapılandırmak için:
1. Seçenekler penceresini açın ve **Kayıt Cihazları** sekmesine (sunucu simgesi) gidin.
2. Cihaz erişim ayrıntılarını girin:
   * **IP Adresi**: Kaydedicinin ağ adresi.
   * **Bağlantı Noktası**: SDK ağ bağlantı noktası (varsayılan: `8000`).
   * **Kullanıcı adı**: Kullanıcı adı (ör. `admin`).
   * **Şifre**: Kaydediciye erişim şifresi.
3. **Bağlan ve Keşfet**'i (veya **Kaydet ve Güncelle**) tıklayın.
4. Başarılı bağlantı sonrasında uygulama, NVR/DVR'ye bağlı tüm aktif kameraları (kanalları) otomatik olarak algılayacak ve bunları listeye ekleyecektir.
5. **Izgara Oluştur** düğmesini tıklattığınızda, otomatik olarak o NVR'deki tüm aktif kameraları optimum ızgara düzeninde içeren bir görünüm düzeni (ön ayar) oluşturulur.
6. **Kamera Listelerini Görüntüleme (NvrCamerasWindow)**: Herhangi bir kayıt cihazının kartındaki bilgisayar monitörü simgesi düğmesine tıklamak, algılanan tüm kamera kanallarını etkileşimli döşemeler halinde gösteren özel bir pencere açar.
7. **Küçük Resimler Oluşturma (Küçük resimler oluştur)**: NVR kameralar listesi penceresinde bir *"Küçük resimler oluştur"* düğmesi mevcuttur. Buna tıklandığında, uygulamaya arka planda her kanalın Alt Akışından tek kareler çekmesi ve bunları döşeme arka planı küçük resimleri olarak ayarlaması komutu verilir. Bu, tam canlı yayınları başlatmadan her kameranın hızlı bir görsel önizlemesini sağlar.
8. **Tıkla ve Ekle Özelliği**: Uygulama, döşemelerin kamera listesi penceresinden ana ızgaraya sürüklenmesini (sürükle ve bırak) desteklemez. Kamera ataması basit ve güvenilir bir şekilde gerçekleştirilir: önce ana ekran ızgarasındaki herhangi bir görüntü alanı döşemesine sol tıklayarak seçin (parlak bir kenarlıkla vurgulanacaktır), ardından NVR kamera listesi penceresinde istediğiniz kamera döşemesindeki yeşil **"+" (Aktif görüntüleme alanına ata)** düğmesine tıklayın. Akış anında bu yuvaya yüklenecektir.
9. **SDK Oturum Durumu (Nokta göstergesi)**: Listedeki her kaydedicinin IP'sinin yanında renkli bir durum noktası vardır:
   * **Yeşil (OTURUM AÇIK)**: PTZ kontrolü, zaman çizelgesi arşiv istekleri ve indirme için gerekli olan aktif bir Hikvision SDK oturumunu temsil eder.
   * **Kırmızı (OTURUM AÇILMADI)**: Şu anda etkin bir SDK oturumu kurulmadı (örneğin, ilk SDK talebinden önce veya manuel/otomatik oturum kapatma sonrasında). Kamera RTSP canlı yayınlarının, SDK oturum durumundan bağımsız olarak oynatılmaya devam edeceğini unutmayın.
10. **Yerel Kamerayı Yeniden Adlandırma**: NVR kameralar listesindeki herhangi bir kamera döşemesinde **Düzenle** (kalem) simgesini tıklayın. Bu, kamera için özel bir ad ayarlamanıza olanak tanıyan bir iletişim kutusu açar. Bu ad yerel olarak kaydedilir ve fiziksel NVR cihazında değişiklik yapılmadan canlı oynatıcılar, zaman çizelgesi ve döşeme görünümleri genelinde anında güncellenir. İstediğiniz zaman varsayılan isme sıfırlayabilirsiniz.
11. **Listeden Kaydediciyi Kaldırma**: Listedeki yapılandırılmış her kaydedicinin yanında kırmızı bir çöp kutusu düğmesi bulunur. Tıklandığında, yanlışlıkla silinmeyi önlemek için tasarlanmış iki aşamalı bir güvenlik protokolü başlatılır:
    * **1. Adım (Onay)**: *“NVR Silmeyi Onayla”* başlıklı bir iletişim kutusu görünür ve kaydediciyi silmek istediğinizden emin olup olmadığınızı sorar.
    * **2. Adım (Uyarı)**: *“Uyarı!”* başlıklı ikinci bir uyarı iletişim kutusu görünür ve ne yaptığınızdan kesinlikle emin olup olmadığınızı ve ne yaptığınızın farkında olup olmadığınızı sorar.
    * **Silme Etkisi**: İkinci uyarının kabul edilmesi üzerine, program arka planda söz konusu NVR'deki oturumu kapatır, uygulama konfigürasyonundaki girişini siler ve bu NVR cihazı için oluşturulan tüm dinamik ızgaraları kaldırarak **önceden ayarlanmış düzen listesini otomatik olarak tarar**.

---

## 4. Canlı Görünüm ve Görünüm Penceresi Kaplamaları

Programın ana penceresi canlı yayını görüntüler:
* **Kamera Izgarası**: RTSP akışlarını veya akışlarını doğrudan Hikvision SDK'dan görüntüler.
* **Akış Kalitesi Seçimi**: Bir kamera görüntü portuna sağ tıklayarak, en yüksek çözünürlük için **Ana Akış**'ı veya ağ ve grafik kartı yükünü azaltmak için **Alt Akış**'ı seçebilirsiniz.
* **Çift Tıklamayla Tam Ekran Geçişi**: Herhangi bir kamera görüntü portu üzerinde farenin sol düğmesiyle çift tıklamak, onu tüm aktif pencere alanını dolduracak şekilde anında büyütür (tek görüntü portlu tam ekran). Tekrar çift tıklamak, orijinal çoklu kamera ızgara düzenini geri yükler.
* **Üst Çubuğu Otomatik Gizleme**: Üst seçenekler araç çubuğu (topToolBar), fare imleci alanından çıktığında otomatik olarak ekranın üst kenarına daraltılabilir (bu seçenek Ayarlar -> *"Üst çubuğu otomatik olarak daralt"* bölümünden veya doğrudan üst çubuktaki raptiye simgesi kullanılarak yapılandırılabilir).
* **Çoklu Monitör ve Yardımcı Pencereler**: Farklı ızgara düzenlerini birden fazla ekran veya monitörde aynı anda çalıştırmak için bağımsız ek (yardımcı) pencereler açabilirsiniz. Yeni bir pencere açmak için `Ctrl+N` klavye kısayolunu kullanın veya fareyle üzerine gelindiğinde kayan üst araç çubuğundaki **"Yeni Pencere"** düğmesini tıklayın. Her pencere kendi ızgara boyutu ve seçilmiş ön ayar düzeniyle yapılandırılabilir. Çoklu monitör yapılandırmalarında maksimum kararlılığı sağlamak için, tüm pencereler kesinlikle birincil ekranın %90 çözünürlüğünde ortalanmış olarak başlatılır.

### Görünüm Penceresi Yer Paylaşımı Düğmeleri
Her kamera döşemesinin/görüntü alanının sağ alt köşesinde, fare imleci üzerine getirildiğinde beş işlevsel simge içeren bir kontrol paneli görüntülenir (kullanıcı arayüzü tercihlerine bağlı olarak):
1. **Kamera Simgesi (Anlık Görüntü)**: Kamera akışından ekran görüntüsü almanızı sağlar. Anlık görüntü, doğrudan kod çözücü çerçeve arabelleğinden akışın tam, doğal çözünürlüğünde kaydedilir; böylece görüntü alanı döşemesinin mevcut boyutundan veya ekran çözünürlüğü ölçeklendirmesinden kaynaklanan herhangi bir kayıp önlenir. Anlık görüntünün başarıyla kaydedildiği, kamera simgesinin tam olarak 1 saniye boyunca turuncu renkte (`#ff7a00`) yanıp sönmesiyle onaylanır.
2. **Oynat Simgesi (Arşiv)**: Kayıt arşivini hızlı bir şekilde açmak için kullanılır. Bu düğmeye tıklamak, bu belirli kamera için otomatik olarak `PlaybackWindow` zaman çizelgesini başlatır ve oynatmayı **geçerli sistem saatinden tam olarak 15 dakika önce** başlatır (kullanışlı, hızlı bir geriye doğru kaydırma).
3. **Dairesel Ok Simgesi (Hızlı Oynatma / Mini Oynatıcı)**: Son 30 dakikadaki kamera arşiv kayıtlarının, canlı ızgaradan ayrılmadan veya tam arşiv penceresini başlatmadan, doğrudan kamera döşemesinin içinde hızlı bir şekilde görüntüleme alanında oynatılmasını etkinleştirir.
   * **Kontrol Paneli**: Etkin olduğunda, görünümün alt kısmında aşağıdakileri içeren kayan bir kontrol paneli görünür:
     * **Oynat/Duraklat**: Oynatma akışını duraklatır veya devam ettirir.
     * **Zaman ve Ofset Gösterimi**: Geçerli oynatma zaman damgasını ve gerçek zamana göre göreceli yaşını görüntüler (örneğin, `-12:34` 12 dakika 34 saniye öncesini temsil eder).
     * **Etkileşimli Zaman Çizelgesi Kaydırıcısı**: 30 dakikalık arabellek içinde herhangi bir yeri aramak için tıklamaya veya sürüklemeye olanak tanır. Mevcut kayıt bölümleri deniz mavisi bir arka planla vurgulanır ve kırmızı oynatma kafası geçerli konumu işaretler.
     * **Hız Çarpanı**: Görüntüyü hızla taramak için oynatma hızları (`1x`, `2x` ve `4x`) arasında geçiş yapar.
     * **Kapat (✕)**: Mini oynatıcıyı kapatır ve görüntü penceresini anında canlı yayına geri döndürür.
   * **Kaydırılabilir Yakınlaştırma desteği**: Canlı görünümde olduğu gibi, mini oynatıcının bir bölgesini yakınlaştırmak için büyüteç aracını kullanabilir veya orta fare düğmesini basılı tutup sürükleyerek etrafta gezinebilirsiniz.
4. **1:1 Simgesi (Yerel Ölçek)**: Pikselden piksele video görüntüleme modunu değiştirir. Etkinleştirildiğinde video, döşeme sınırlarını dolduracak şekilde uzatılmaz veya deforme edilmez; bunun yerine ortalanır ve orijinal doğal çözünürlüğünde gösterilir. Bu mod etkin olduğunda, düğme arka planı ve "1:1" metni parlak neon ışık-turkuaz renkte vurgulanır.
5. **Büyüteç Simgesi (Etkileşimli Yakınlaştırma)**: Video akışının belirli herhangi bir bölgesini büyütmenize olanak tanır:
   * **Etkinleştirme**: Simgeyi tıklamak onu etkin duruma (turkuaz vurgu) geçirir. İmlecin şekli değişir ve bir araç ipucu şu talimatı verir: *“Yakınlaştırmak için kamera akışına tıklayın ve sürükleyin”*.
   * **İşlem**: Sol tıklayın ve dikdörtgen bir seçim çerçevesi bölgesini canlı yayının üzerine sürükleyin. Görünüm penceresi, tüm döşemeyi dolduracak şekilde seçilen alanı otomatik olarak kırpacak ve ölçeklendirecektir.
     * **Orantılı Yakınlaştırma**: Yakınlaştırma dikdörtgenini çizerken **Shift** tuşunu basılı tutarak seçimi, görünüm alanı sınırlarıyla sıkı bir şekilde sınırlandırılmış 16:9 en boy oranına kilitlemeye zorlayın.
     * **Yakınlaştırılmış Görüntüyü Kaydırma (Pan Zoom)**: Yakınlaştırdıktan sonra, **orta fare düğmesini (kaydırma tekerleği)** basılı tutabilir ve büyütülmüş görünümü video görüş alanı çevresinde serbestçe kaydırmak için imleci sürükleyebilirsiniz. Bu, Canlı görünümde, Oynatma Arşivinde ve Mini oynatıcıda çalışır.
   * **Sıfırla**: Büyüteç simgesi yakınlaştırıldığında simgesini değiştirir (eksi işaretli kırmızı kenarlık). Tıklandığında yakınlaştırma hemen sıfırlanır ve tam kamera yayınına geri dönülür.

---

## 5. Ekran Düzenleri, Ön Ayarlar ve Araç Çubuğu

Düzenler, ekrandaki kameraların düzenini düzenlemenize olanak tanır. **Ön Ayarlar** sekmesinden (yıldız simgesi) şunları yapabilirsiniz:
* **Yeni Ön Ayarlar Oluşturun**: İstediğiniz sütun ve satır yapılandırmasıyla (ör. 2x2, 3x3, 4x4) kendi düzeninizi ekleyin.
* **Kameraları Ata**: Izgara düzeninde bir görünüm portuna tıklayarak seçin, ardından NVR kameralar penceresini açın ve istediğiniz kamera döşemesindeki **"+" (Ekle)** düğmesini tıklayın. Ayrıca, kaynak görünüm alanının sağ tıklama bağlam menüsünü (*"Zamień miejscami"* / *"Görünüm pencerelerini değiştir") kullanarak ve ardından hedef görünüm alanına tıklayarak görüntü alanı konumlarını değiştirebilirsiniz.

### Üst Çubuk Düğmeleri (Üst Araç Çubuğu)
Üstteki kayan araç çubuğu kapsamlı bir gezinme ve uygulama kontrol düğmeleri seti sağlar:
1. **Pencereyi Kapat (Kırmızı ✕ Düğmesi)**: Etkin pencereyi kapatır. Yanlışlıkla yapılan tıklamaları önlemek için kapanış olayını durdurur ve uygulamadan çıkmayı onaylamanız için bir iletişim kutusu görüntüler.
2. **Sabitleme Düğmesi**: Üst araç çubuğunun otomatik gizleme davranışını kontrol eder. Pim dikey olarak işaretlendiğinde (sabitlenmiş durum), çubuk yerine kilitlenir ve kalıcı olarak görünür kalır. Pim -45 derece döndürüldüğünde (sabitlenmemiş durum), fare alanı terk ettiğinde çubuk otomatik olarak yukarı doğru kayar ve görüş alanının dışına çıkar.
3. **Tam Ekran (Yeşil Ok Simgesi)**: Etkin pencereyi anında tam ekran moduna geçirir ve geri döndürür. Tam ekran modunda oklar içe doğru işaret eder (daralır), pencereli modda ise dışarı doğru işaret eder (genişler).
4. **Küçült (Cyan Minimizasyon Simgesi)**: Uygulama penceresini görev çubuğuna küçültür. Geri yüklemek, pencereyi tam olarak önceki durumuna döndürür (ör. büyütülmüş veya tam ekran).
5. **⚙️ SEÇENEKLER (OPCJE)**: Yapılandırma seçenekleri penceresini açar/kapatır. Pencere zaten açıksa bu düğmeye basıldığında pencere kapanır.
6. **📺 YENİ PENCERE (ŞİMDİ OKNO)**: Kamera düzenlerinizi birden fazla monitör kurulumuna genişletmek için mükemmel olan yeni, bağımsız ve tamamen yapılandırılabilir bir `Auxiliary Window` açar.
7. **ARŞİV**: Etkin zaman çizelgesi ve takvime sahip boş bir `PlaybackWindow` (kayıt oynatıcısı) açar ve kenar çubuğu listesi aracılığıyla herhangi bir yapılandırılmış NVR'den manuel akış ve kamera kanalı seçimlerine olanak tanır.
8. **TALİMATLAR (INSTRUKCJA)**: Etkin yerel ayarınıza bağlı olarak tüm kullanıcı dokümantasyonunu İngilizce veya Lehçe olarak yükleyen bu kılavuz penceresini açar.
9. **📊 STATS (STATYSTYKI) Anahtarı**: Sistem İstatistikleri izleme panelini ekranın sol kenarından dışarı kaydırmak için geçiş anahtarı.
10. **Izgara Kilit Anahtarı (Asma Kilit)**: AÇIK konuma getirildiğinde (parlak turuncu renkle vurgulanır), bitişik ızgara düğmelerinde ızgarayı yeniden boyutlandırma işlemlerini devre dışı bırakarak aktif kamera düzeninizi kazara yapılan değişikliklerden korur.
11. **Izgara Boyutu Seçicileri (1x1'den 9x9'a kadar)**: Görüntü alanınızın satır ve sütun yapısını anında tanımlamanıza olanak tanıyan dokuz düğmeden oluşan bir satır (tek bir kamera 1x1 görünümünden 9x9 düzeninde 81 eşzamanlı kamera beslemesine kadar). Şu anda aktif olan boyut parlak turuncu renkte vurgulanır.
12. **Daha Fazla Seçenek (Üç satırlı Hamburger Menüsü)**: Gelişmiş ızgara ayarı, geometri ayarları ve hata ayıklama seçenekleri için kayan `Layout & Grid Tools` araç kutusunu açan düğme (aşağıda ayrıntılı olarak açıklanmıştır).
13. **Ön Ayar/Görüntüleme Düğmeleri**: Araç çubuğunun sağ tarafında, yapılandırılmış ve görünür ön ayar düzenlerinizi temsil eden dinamik olarak oluşturulmuş düğmeler (ör. *📹 NVR*, *Görüntüleme 1*, vb.). Bir düğmeye tıklamak hemen ızgarayı değiştirir. Aktif görünüm parlak ışık-turkuaz renkte vurgulanır.

### Gelişmiş Izgara Özelleştirmesi ve Oranları (Yerleşim ve Izgara Araçları)
Hamburger (Daha Fazla Seçenek) menüsünü açmak, özel bir düzen araç kutusunu getirir. Kontrollerini etkinleştirmek için:
1. **Araçlar bölmesinin kilidini aç**: En üstteki "Araçlar bölmesinin kilidini aç" anahtarını açın. Bu, karmaşık düzenlerde kazara değişiklik yapılmasını önlemeye yönelik açık bir güvenlik önlemidir.
2. **Özel Pencere Bölme (F2 veya Basılı Tut)**: Araç kutusu, 1x1'den 9x9'a kadar ızgara bölme düğmelerini görüntüler. Son derece gelişmiş bir özellik, **bölüm boyutlarını geçersiz kılma ve düzenleme** yeteneğidir. Farenin sol tuşuyla herhangi bir ızgara düğmesini tıklayıp basılı tutarsanız (veya odaklanıp **F2**'ye basarsanız), bir metin kutusu görünür. Herhangi bir özel veya asimetrik bölümü (`2x3`, `1x4` vb. gibi) yazıp Enter tuşuna basabilirsiniz. Düğme anında yeniden programlanır ve tıklandığında özel düzeniniz ana görünüm penceresine uygulanır.
3. **Geometri Oranları**: Izgara görüntüsünün belirli en boy oranlarına zorlanmasına olanak tanır:
   * **16:9 En Boy Oranı**: Izgara kapsayıcısını geniş ekran 16:9 formatına (modern IP kameralar için standart) kilitler ve ölçeklendirir.
   * **4:3 En Boy Oranı**: Izgara kabını geleneksel 4:3 oranına (eski analog/IP kameralarda yaygındır) uyarlar.
4. **Izgara İşlemleri (Vurgulanan Hücreleri Birleştir)**: Asimetrik hücre birleştirme özelliğine erişin (Bölüm 9.2'de ayrıntılı olarak açıklanmıştır).

---

## 6. Sistem İstatistikleri Paneli (Sistem İstatistikleri)

Canlı Görünüm ekranının sol kenarından dışarı doğru kayan bu panel, bilgisayarın durumunu ve uygulama tarafından oluşturulan yükü izler:
* **İzlenen Parametreler**:
  * **CPU / RAM**: Ana işlemcinin kullanımı (tüm çekirdeklerin %'si olarak) ve doğrudan `kvision` işlemi ve ilgili indirici alt işlemleri tarafından kullanılan RAM.
  * **GPU / VRAM**: Grafik kartı çekirdek kullanımı (% olarak) ve oluşturma ve donanım kod çözme tarafından kullanılan VRAM grafik belleği miktarı (`nvidia-smi`'daki XML ayrıştırıcısını kullanan GPU işlemlerinin tam listesini destekler).
  * **AĞ (Net)**: Uygulamanın tüm aktif canlı oynatıcılardan, arşiv oynatıcılardan ve kayıt indirme işlemlerinden gerçek indirme aktarım hızı.
* **Çoklu iş parçacığı (Kekiksiz)**: İşlem ve GPU veri toplama, ayrı bir sistem iş parçacığında (`StatsWorker`) çalışır. Bu, video oluşturmada mikro takılmaları önler (kare düşüşü olmaz).
* **Sabitleme Özelliği**: **"Sabitle"** düğmesinin (pin simgesi) tıklatılması, paneli genişletilmiş durumunda kilitler.
* **Estetik**: Grafiklerde parlak, neon yeşili kenarlıklar, grafik eğrisinin altında degrade dolgu ve metnin okunabilirliğini sağlamak için dengeli %35 arka plan şeffaflığı bulunur.

---

## 7. Kayıttan Yürütme Arşiv Oynatıcısı

Belirli bir kamera veya kaydedicinin yanındaki saat/oynat simgesine tıklanarak kullanılabilir. Birden fazla Hikvision kameradan gelen arşivlenmiş kayıtların tam zamanlı senkronizasyonla eşzamanlı olarak görüntülenmesine olanak tanır.

### Zaman Çizelgesi ve Kontroller:
* **Hızlı Başlangıç ​​(15 dakika geri)**: Arşivi canlı görüntüden açarken, oynatıcı otomatik olarak **mevcut sistem saatinden tam olarak 15 dakika önce** bir andan itibaren başlar (gece yarısı başlamak yerine). Bu, henüz meydana gelen bir olayın anında görüntülenmesine olanak tanır.
* **Gezinme**: Zaman çizelgesi, farenin sol tuşuyla sürüklenerek sola ve sağa kaydırılabilir.
* **Yakınlaştırma (Ölçeklendirme)**: Fare kaydırma tekerleğini (veya Yakınlaştırma düğmelerini) kullanarak zaman çizelgesi ölçeğini, tüm günü görüntülemekten 10 dakikalık hassas bir görünüme kadar sorunsuz bir şekilde değiştirebilirsiniz.
* **Hızlı Yakınlaştırma Kısayolları**: Alttaki kontrol çubuğu, zaman çizelgesi görünümünü anında ölçeklendirmek için özel dairesel simge düğmelerine sahiptir:
  * **"1sa" simgesi**: 1 saatlik bir aralıkta ayrıntılı inceleme için zaman çizelgesini yakınlaştırır.
  * **"8sa" simgesi**: 8 saatlik bir aralığı görüntülemek için zaman çizelgesini yakınlaştırır.
  * **"24h" simgesi**: Yakınlaştırmayı 24 saatlik günün tamamını tek bir ekrana sığdıracak şekilde sıfırlar.
  * **Orta (Hedef) simgesi**: Kırmızı oynatma göstergesi ekranın tam ortasında olacak şekilde zaman çizelgesini hemen ortalar (eski metin düğmesinin yerini alır).
* **Tarihte Gezinme (Takvim ve Günler)**: Görüntülenen tarihin yanındaki kontroller hızlı atlamalara izin verir:
  * **"<" (Önceki Gün)** ve **">" (Sonraki Gün)** düğmeleri: Takvim iletişim kutusunu açmadan anında 24 saat geri veya ileri atlamanıza olanak tanır.
  * **Takvim simgesi**: Belirli bir tarihi seçmek için takvim açılır penceresini açar.
  * **Yenileme simgesi**: Kayıtların yeni bir şekilde aranmasını sağlar. Buna tıklamak, tüm aktif kanallar için kayıt kullanılabilirliği bölümlerinin yerel önbelleğini tarar ve NVR'ye yeni sorgular gönderir; bu, yalnızca birkaç dakika önce kaydedilen dosyaları yüklemek için son derece faydalıdır (eski metin düğmesinin yerini alır).
  * **Bugün (Bugünün tarihi/numarası) simgesi**: Anında geçerli güne geri döner (eski metin düğmesinin yerini alır).
* **Oynatma Hızı Kısayolları**:
  * **"1x", "2x" ve "4x" simgeleri**: Oynatma hızı çarpanını anında değiştirin.
* **VCR Atlama Düğmeleri**:
  * **"15", "45" ve "60" simgeleri ile dairesel oklar**: Belirtilen saniye sayısı kadar hızla geri veya ileri atlamanızı sağlar.
* **Kayıt Kullanılabilirlik Çubukları**: Kaydedici diskinde bulunan video bölümlerini temsil eden renkli çubuklar, zaman çizelgesinin altında oluşturulur. Önbellekleme sistemi, sürükleme sırasında bunların titremesini önler.
* **Otomatik takip (Gösterge izleme)**: Oynatma göstergesi (dikey kırmızı çizgi) sürekli olarak izlenir. Gösterge zaman çizelgesinin görünür aralığının dışına çıkarsa görünüm otomatik olarak göstergeyi ortalayacak şekilde kaydırılacaktır. Bu seçenek, göstergenin kullanıcı tarafından manuel olarak sürüklenmesi sırasında akıllıca kilitlenir.

### İzleme Penceresindeki Kamera Yan Paneli
Oynatıcının sağ kenarındaki dikey bir yan liste, yapılandırılmış tüm NVR'leri ve bunların kamera kanallarını listeler:
* **Kanalları Değiştirme**: Listedeki herhangi bir kamera kanalı tıklatıldığında, bu kanal zaman çizelgesinde etkin bir oynatma alanı olarak eklenir (bir video oynatıcı oluşturulur). Tekrar tıklamak kanalı kaldırır.
* **Kanal İçeriği Menüsü**: Oynatma kılavuzunda etkin bir video yuvasını sağ tıklattığınızda aşağıdakileri sağlayan bir menü açılır:
  * Video kalitesini değiştirin (Ana Akış / Alt Akış).
  * Aktif oynatıcıyı arşiv oynatmadan kapatın/kaldırın.

---

## 8. Kayıtların İndirilmesi (İndirici)

Kayıttan Yürütme Arşivi penceresinden, kayıtların seçilen bölümlerini doğrudan bilgisayarınızın sürücüsüne MP4 dosyaları olarak indirebilirsiniz:
1. Seçilen kameranın yanındaki indirme simgesine (aşağı ok) tıklayın.
2. Zaman aralığını seçin (kaydın başlangıcı ve bitişi).
3. Hedef dosya kaydetme konumunu seçin.
4. **İndir**'i tıklayın.

### Gelişmiş İndirme Özellikleri:
* **Sıralı Segment İndirme (1 GB'lık parçalar)**: Program, zaman aralığı sorgunuzu otomatik olarak fiziksel dosya segmentlerine (NVR sürücüsünde her biri yaklaşık 1 GB) böler ve bunları tek tek indirip dönüştürür (doğrudan `.mp4` biçimine dönüştürülen geçici `.pspart` dosyaları kullanarak). Bu, bellek taşması veya FFmpeg dönüşümünde takılmalar olmadan, uzun süreli aralıklarda son derece kararlı indirmeler sağlar.
* **Genel İlerleme Görselleştirmesi**: İlerleme çubuğu (parlak deniz mavisi renk), tüm segmentlerde kameranın genel indirme ilerlemesini görüntüler. İlerleme çubuğunun üzerine yerleştirilen durum metni, herhangi bir arka planda okunabilirliği garanti etmek için bir taslak stiliyle birlikte geçerli kısmı ve yüzdeleri gösterir; örneğin `Downloading part 1 of 3... 45% (Overall: 15%)`.
* **Dosya Adı IP Temizleme**: Video dosya adları (ve canlı/arşiv anlık görüntüleri), temiz ve insanlar tarafından okunabilir durumda kalmaları için NVR/DVR IP adreslerinden otomatik olarak çıkarılır (ör. `<RECORDER_IP>_4_Wejscie...` yerine `4_Wejscie_glowne_2026-06-15.mp4`).

---

## 9. Seçenekler Penceresinde Gelişmiş Ayarlar ve Özelleştirme

Seçenekler ve yapılandırma penceresi (`SideBar`) altı özel sekmeden oluşur:

### 1. Görünüm Ayrıntıları (Monitör Simgesi)
Şu anda seçili ızgara döşemesinin gelişmiş parametrelerini görüntüler. Şunları yapmanızı sağlar:
* Manuel yapılandırmalar için özel bir **Birincil Akış URL'si** (RTSP/ONVIF) ve **İkincil Yedekleme URL'si** yazın.
* Seçilen kamera akışının ses kanalını sessize alma/sesi açma arasında geçiş yapın.
* **FFmpeg Seçenekleri Geçersiz Kılma** metin kutusuna gelişmiş kod çözücü geçersiz kılmalarını girin.
> [!İPUCU]
> RTSP üzerinden en hızlı akış bağlantısı ve maksimum kararlılık için önerilen parametreler şunlardır:
> ```ini
> -analiz süresi 0 -probesize 500000 -fflags nobuffer -flags low_delay -rtsp_transport tcp
> ```

### 2. Düzen ve Izgara Araçları (Kaydırıcı Simgesi)
Gelişmiş ekran ızgarası özelleştirme seçenekleri:
* Tam Ekran modu için hızlı geçiş.
* **Asimetrik Hücre Birleştirme (Vurgulanan Hücreleri Birleştir)**: Son derece gelişmiş bir düzen düzenleyici. **Ctrl** veya **Shift** tuşunu basılı tutun ve ızgaradaki birden fazla bitişik döşemeyi seçmek için tıklayın veya **Shift** tuşunu basılı tutarak ve **Ok tuşları** ile gezinerek klavyenizi kullanın, ardından bunları daha büyük tek bir görünüm portunda birleştirmek için "Vurgulanan Hücreleri Birleştir" seçeneğini tıklayın. Bu, tamamen özel asimetrik ızgara tasarımları oluşturmanıza olanak tanır (örneğin, etrafını saran daha küçük yayınlara sahip devasa bir kamera paneli).

### 3. Kayıt Cihazları (Sunucu Simgesi)
Hikvision NVR/DVR cihazlarına bağlantılar için tam konfigürasyon yöneticisi (Bölüm 3'te ayrıntılı olarak açıklanmıştır).

### 4. Ön Ayarlar (Yıldız Simgesi)
Kaydedilmiş ızgara düzenleriniz ve kamera atamalarınız için yönetici. Boş ızgara şablonları oluşturmaya, sıralarını değiştirmeye, üst çubuk görünürlüğünü değiştirmeye ("Görünür" anahtarı aracılığıyla) veya bunları geçerli pencerede etkinleştirmeye olanak tanır.

### 5. Ayarlar (Dişli Simgesi)
Genel uygulama ayarlarının yapılmasına izin verir:
* **Birden çok örneğin çalıştırılmasına izin ver**: Bu kutunun işaretlenmesi, KVision işleminin birden çok paralel kopyasının başlatılmasına izin verir (varsayılan olarak, çalıştırmaları tek bir etkin örnekle sınırlandırır).
* **Otomatik daraltma ayarları**: Üst çubuk ve istatistik paneli için kayan animasyon zamanlamasını özelleştirir.
* **Görünüm pencerelerinin değiştirilmesine izin ver**: *"Görünüm alanı yerlerinin değiştirilmesine izin ver"* onay kutusu, ızgaradaki kamera konumlarını anında yeniden düzenlemenizi sağlar (Kaynak döşemesine sağ tıklayın -> "Görünüm pencerelerini değiştir" seçeneğini seçin -> Hedef döşemesine sol tıklayın).
* **Sağ tıklama izinleri**: Sağ tıklama bağlam menüsündeki etkileşimli kontrolleri kilitlemek/kilidini açmak için geçiş yapar (Bağlam menüsünü etkinleştir, Görünüm pencerelerinin değiştirilmesine izin ver, 'Kamerayı kaldır' seçeneğini etkinleştir, Görüntü alanı ayarlarını değiştirmeye izin ver, Akış Ana/Alt kalite seçimini etkinleştir).
* **Otomatik Sesi Aç**: Tam Ekran moduna girildiğinde aktif görüntüleme alanının ses akışının sesini otomatik olarak açar.
* **İmleci Tam Ekranda Gizle**: *"İmleci tam ekran modunda gizle"* onay kutusu, engelsiz bir görünüm sağlamak için tam ekran görüntüleme sırasında kısa bir hareketsizlik süresinden sonra fare imlecini otomatik olarak gizler.
* **Dil seçimi**: Arayüz çevirisini anında değiştirir (Sistem varsayılanı, Lehçe, İngilizce).
* **Kullanıcı Arayüzü Tercihleri**: Görüntü alanı durum etiketlerini veya kontrol rozetlerini gizleyin/gösterin (üzerine gelmedikçe döşemelerin sağ alt köşesindeki kontrol katmanlarının otomatik olarak gizlenmesi gibi).
* **Varsayılan FFmpeg Seçenekleri ve Toplu Güncelleme**: Yeni görünüm pencerelerine uygulanan genel FFmpeg seçeneklerinin yapılandırılmasına izin verir (önerilen: `-analyzeduration 100000 -probesize 500000 -fflags nobuffer -flags low_delay`).
  * > **[ÖNERİ]** KVision'ın eski bir sürümünden (v2.4.5 öncesi) geçiş yapıyorsanız, genel ayarlarda `-analyzeduration 0`'ı `-analyzeduration 100000` olarak değiştirmeniz ve "Tüm kameraları güncelle"ye tıklamanız önemle tavsiye edilir. Ses parçası olmayan akışlarda `0` ayarının yapılması, geçişte gecikmelere neden olur çünkü FFmpeg, ses paketlerini bekleyen sabit kodlu 5 saniyelik zaman aşımını engelleyecektir. Çok düşük bir değer ayarlamak (örneğin, 100000 mikrosaniye = 0,1s), anında geçişi korurken bu sorunu tamamen çözer.
  * **Tüm kameraları güncelle düğmesi**: *"Zaktualizuj wszystkie kamery"* düğmesi bu genel seçenekleri yapılandırılmış tüm görünüm pencerelerine uygular.
  * **Düşük gecikmeli işaretler (`nobuffer`, `low_delay`)**:
    * `-fflags nobuffer` zaman içinde akış gecikmesini ortadan kaldırmak için dahili demuxer paket arabelleğe almayı devre dışı bırakır, ancak kameraya olan ağ bağlantınız kararsızsa kekemeliğe neden olabilir.
    * `-flags low_delay` kod çözücüye kareleri hemen çıkarmasını söyler ancak hızlı hareketler altında B kareleri kullanan akışlarda kısa süreli bozulmalara/bulaşmalara neden olabilir.
  * **Geçersiz kıl onay kutusu**: Bireysel Görünüm Penceresi Ayarları iletişim kutusunda **"Nie uwzględniaj zmian w globalnych ustawieniach FFMpeg"** seçeneğini işaretleyerek belirli görünüm pencerelerini genel güncellemelerden veya dinamik varsayılanlardan hariç tutabilirsiniz. Kekemelik kameralarının sorunlarını gidermek için kullanışlıdır.


### 6. Değişiklik Günlüğü (Saat/Belge Simgesi)
KVision'ın tam sürüm geçmişini, güncellemelerini, hata düzeltmelerini ve özellik eklemelerini gösteren etkileşimli bir zaman çizelgesi sunarak program güncelleme ayrıntılarına doğrudan erişmenizi sağlar.

---

## 10. Klavye Kısayolları ve Fare Kontrolleri

### Klavye kısayolları:
| Tuş / Kısayol | Eylem |
|---|---|
| **F** / **F11** | Tam Ekran moduna geçiş yapın. |
| **M** | Sesi kapat / aç (sesli aktif kamera için çalışır). |
| **Uzay** | Oynatma Arşivi penceresinde oynatmayı Oynat / Duraklat. |
| **Alt + 1** - **Alt + 9** | 1'den 9'a kadar olan indekslerde bir ön ayara/düzene hızlı geçiş. |
| **Alt + Sol Ok** | Koleksiyondaki önceki ön ayara/düzene hızlı geçiş yapın. |
| **Alt + Sağ Ok** | Koleksiyondaki bir sonraki ön ayara/düzene hızlı geçiş yapın. |
| **Ok tuşları (Yukarı/Aşağı/Sol/Sağ)** | Etkin odağı/seçimi kamera görünüm pencereleri arasında gezinin ve taşıyın. |
| **Üst Karakter + Ok tuşları** | Birden fazla bitişik kamera görüntü portunu aynı anda seçin (hücre birleştirme vb. için kullanılır). |
| **Ctrl + N** | Yeni, bağımsız bir yardımcı pencere açın. |
| **+** / **-** | Yakınlaştır / Uzaklaştır (PTZ özellikli Hikvision kameralar). |
| **Shift** (işaret çerçevesini sürükleyin) | Etkileşimli yakınlaştırma sırasında kayan yazı seçimini 16:9 en boy oranında kilitlemeye zorlayın. |
| **Esc** | Tam Ekran modundan çıkın / aktif görünüm alanı seçimini iptal edin. |

### Fare etkileşimi:
* **Sol fare düğmesi**:
  * Izgaradaki bir kamera görüntüleme alanına **çift tıklamak** onu tam ekrana büyütür. Başka bir çift tıklama ızgara görünümünü geri yükler.
  * Gezinmek için Oynatma penceresindeki zaman çizelgesini sürükleyin.
* **Orta Fare Düğmesi (Kaydırma tekerleği tıklayıp sürükleyin)**:
  * Dijital olarak yakınlaştırılmış/büyütülmüş görüntüyü görünüm alanı çevresinde kaydırmak ve taşımak için sürükleyin (Canlı, Arşiv ve Mini oynatıcıda çalışır).
* **Sağ fare düğmesi (İçerik Menüsü)**:
  * Seçilen görünüm portu için hızlı ayarlar menüsünü açar (kameranın ızgaradan çıkarılmasına, Ana/Alt akışlar arasında geçiş yapılmasına veya ayrı ekran parametrelerine erişilmesine olanak sağlar).
* **Fare Kaydırma Tekerleği**:
  * Oynatma arşiv oynatıcısındaki zaman çizelgesinin ölçeğini (Yakınlaştırma) ayarlar.

---

## 11. Anlık Görüntü Alma ve Yol Yapılandırması

Uygulama, hem Canlı Görünüm hem de Oynatma Arşivi modunda herhangi bir kamera görüntüleme noktasından hızlı bir şekilde yüksek kaliteli anlık görüntüler yakalamanıza olanak tanır.

### Anlık Görüntü Alma:
1. Her görünümün sağ alt köşesinde bir kamera simgesi yer paylaşımı düğmesi bulunur (Bölüm 4'te ayrıntılı olarak açıklanmıştır).
2. Kamera simgesine tıklandığında çerçeve yakalanır ve JPEG görüntüsü olarak kaydedilir (kalite 98 - neredeyse kayıpsız).
3. Başarılı bir yakalama, kamera simgesinin tam olarak 1 saniye boyunca turuncu renkte (`#ff7a00`) yanıp sönmesiyle onaylanır.
4. **Tam Çözünürlük**: Oynatma Arşivi modunda anlık görüntüler, ekrandaki aktif görünüm alanı boyutuna veya ekran ölçeklendirmesine bakılmaksızın doğrudan kod çözücünün çerçeve arabelleğinden akışın tam yerel kaynak çözünürlüğünde kaydedilir.

### Yol Yapılandırmalarını Kaydetme:
1. **Ayarlar** sekmesine gidin (seçenekler penceresindeki dişli simgesi).
2. **Kaydetme** ("Zapis") bölümünün altında varsayılan yolları yapılandırabilirsiniz:
   * **Varsayılan anlık görüntü yolu**: Anlık görüntülerin kaydedileceği klasör (varsayılan olarak `~/Obrazy/CCTV`'dır).
   * **Varsayılan kayıt yolu**: İndirilen MP4 videoların kaydedileceği klasör (varsayılan olarak `~/Wideo/CCTV`'dır).
3. `...` tarayıcı düğmesine tıklamak, işletim sisteminizin yerel klasör seçicisini (KDE'de Breeze) açar.
4. **Tarayıcı Düğmesi Davranışı**: Dizin seçici, tam olarak metin alanına yazılan yolda (varsa) açılır. Alan boşsa, geçersizse veya erişiminiz olmayan bir klasörü işaret ediyorsa iletişim kutusu geri döner ve ana dizininizde (`~/`) açılır.

### Kullanıcı Arayüzü Ayarları (UI):
1. **Ayarlar** sekmesine gidin (seçenekler penceresindeki dişli simgesi) veya **Seçenekler** ("Opcje") penceresini açın.
2. **Kullanıcı Arayüzü Ayarları** bölümünde, kamera kafelki/viewport'larına yerleştirilen öğelerin görünürlüğünü özelleştirebilirsiniz:
   * **Görünüm alanının sol üst köşesinde kanal durumunu göster** (varsayılan olarak etkindir) — Akış yükleme, oynatma ve bağlantı durumu bilgilerini görüntüler.
   * **Görünüm alanının sol alt köşesinde kamera bilgilerini göster** (varsayılan olarak etkindir) — Hikvision kaydediciden alınan kamera adını görüntüler.
   * **Kontrol simgelerini yalnızca fareyle üzerine gelindiğinde görünüm alanının sağ alt köşesinde göster** (varsayılan olarak etkin) — Fare imleci ilgili kamera görünüm alanının dışındayken kontrol düğmesi panelini (anlık görüntü, arşiv, 1:1 pikselden piksele, bölge yakınlaştırma) otomatik olarak gizler. Simgeler, farenizi görüntü alanının üzerine getirdiğinizde anında görünür (tıklamaya gerek yoktur) ve ayrılırken kaybolarak kamera akışlarınızın görünürlüğünü en üst düzeye çıkarır.
   * **Bilgi alanlarını yalnızca fareyle üzerine gelindiğinde göster** (varsayılan olarak devre dışı) — Görünüm pencerelerinin sol üst kısmındaki durumu ve sol alt kısmındaki adı gizleyen ve imleç ilgili kamera döşemesi üzerine getirilmediği sürece tamamen temiz bir kamera akışı görüntüleyen benzer seçenek.
