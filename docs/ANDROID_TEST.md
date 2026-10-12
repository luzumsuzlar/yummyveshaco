# Android telefon denemesi

Son durum — 12 Ekim 2026: video referansına göre aşağı düşme/ön kenar örtülmesi içeren 0.1.11-test/kod 12 Samsung SM-S938B'ye install -r ile başarıyla güncellendi. Önceki sürüm 0.1.10/kod 11 idi. 20 oyun testi ve yeni paket içerik/manifest/imza kontrolleri geçti. Başlatma Status ok ve oyun süreci mevcut; incelenen başlangıç loglarında script/fatal/kaynak yükleme hatası görülmedi, ancak bu denemede Godot Engine render başlangıcı logu görülmedi. Kilit policy showing=true; gerçek ekran/efekt değerlendirmesi kullanıcı kilidi açıp denediğinde yapılacak. Uygulama kaldırılmadı veya verileri temizlenmedi. En yeni APK: exports/android/yumi-sako-0.1.11-test.apk. Aşağıdaki sürüm notları geçmiş denemelerdir.

12 Ekim 2026 son güncelleme: kullanıcı telefon bağlı/başla dediğinde düşme efektini içeren 0.1.10-test/kod 11 hazırlandı ve Samsung SM-S938B'ye install -r ile başarıyla kuruldu. Önceki telefondaki sürüm 0.1.9/kod 10 idi. Başlatma Status ok/LaunchState COLD döndü; oyun süreci ve Godot Engine başlangıcı doğrulandı. İncelenen başlangıç kayıtlarında script/fatal/kaynak yükleme hatası görülmedi. 20 oyun testi, paket içerik/manifest/imza kontrolleri geçti. Uygulama kaldırılmadı, veri temizlenmedi; kayıt içeriği ayrıca incelenmedi. Gerçek düşme hissi/dokunma/mola/ses değerlendirmesi kullanıcı denemesini bekliyor. Aşağıdaki 0.1.9 notu bir önceki denemedir.

12 Ekim 2026 güncel durum: kullanıcı telefon bağlı ve başla dedi; temiz 0.1.9-test (kod 10) APK Samsung SM-S938B telefona install -r ile başarıyla güncellendi. Öncesinde 0.1.8-test/kod 9, sonrasında 0.1.9-test/kod 10 doğrulandı. Uygulama kaldırılmadı veya verileri temizlenmedi. Başlatma isteği başarılı ve oyun süreci mevcut; ekran kilidi/AOD açık olduğu için gerçek oyun görüntüsü ve oynanış henüz doğrulanmadı. İncelenen sürece ait başlangıç kayıtlarında SCRIPT ERROR/FATAL EXCEPTION/kaynak yükleme hatası görülmedi; bu tam cihaz testinin yerine geçmez. Mırlamanın kullanıcı tarafından duyulduğu önceki onay 0.1.8 sürümüne aittir. Aşağıdaki eski tarihli notlar geçmiş denemelerin kaydıdır.

7 Ekim 2026: kıvrılmış uyku görseli v2, karakterler ve sahne derinliğini içeren 0.1.3-test paketi hazırlandı. Bağlı Samsung telefona mevcut uygulama kaldırılmadan yüklendi; sürüm kodu 4 doğrulandı, oyun açıldı ve başlangıç kayıtlarında hata görülmedi. Görsel yerleşimin telefondaki son değerlendirmesi kullanıcı denemesini bekliyor.

1 Ekim 2026: test paketi bağlı Samsung SM-S938B telefona başarıyla kuruldu ve açıldı. Uygulama süreci çalışır durumda, Godot başlangıç kayıtlarında hata görülmedi. Bu kontrol dokunmatik oynanışın veya tüm bölüm akışının gerçek cihazda doğrulandığı anlamına gelmez.

Aynı gün 0.1.1-test güncellemesi mevcut uygulama kaldırılmadan yüklendi; telefondaki sürüm kodu 2 olarak doğrulandı ve oyun yeniden açıldı. Kullanıcının dokununca nişanın sıçraması geri bildirimi üzerine mutlak parmak hedeflemesi yerine göreli yatay sürükleme uygulandı. Otomatik dokunmatik, duvar ve görsel testleri geçti; yeni kontrolün ergonomisi kullanıcı denemesini bekliyor.

## Paket

- Uygulama adı: Yumi & Şako Test
- Kimlik: `com.yumisako.prototype`
- Hazırlanan ve son yüklenen telefon sürümü: `0.1.10-test`, kod `11`. Telefon oynanış/ergonomi kontrolü bekliyor.
- Öğretici, mola, kayıt ve giriş/ses geçiş düzeltmeleri yerel 0.1.9 pakettedir. Sonraki farklı telefon güncellemesinde sürüm kodunu artırın.
- Mimari: ARM64; eski 32-bit telefonlar bu paketin kapsamında değildir.
- APK: `exports/android/yumi-sako-0.1.10-test.apk`. Eski paketler korunuyor; ilk `yumi-sako-test.apk` referans görselleri içerdiğinden yeni paylaşım için kullanılmamalı.
- Debug imzalı yerel deneme; mağaza sürümü değildir. İnternet veya titreşim izni içermez.

Mevcut Godot 4.7.2 export şablonları, Android SDK ve Java ortamı kullanıldı; yeni kurulum veya global ayar değişikliği yapılmadı. Android için ETC2/ASTC doku içe aktarımı proje ayarında açıldı. APK, Git tarafından yok sayılan `exports/` altında tutulur.

## Yeniden üretme

Godot kullanıcı ayarlarında mevcut Android SDK, Java ve debug keystore yolları tanımlı olmalıdır. Depodaki export ayarı keystore parolası içermez.

Hazırlama betiği varsayılan olarak yalnız mevcut paketi doğrular. -Build ile önce 19 oyun testi çalışır, sonra yeni APK üretilip içerik, manifest ve imza kontrol edilir. Mevcut dosyanın üzerine yazmaz; hedef proje exports/android altında olmalıdır. GodotPath/AaptPath/JavaPath parametreleri mevcut araçların konumunu seçer, kurulum veya sistem ayarı değişikliği yapmaz. Hata/timeout sonrasında kalan kısmi dosya paylaşım için onaylı sayılmaz. Fiziksel Android testi bu adımın dışında kalır.

```powershell
& .\tests\prepare_android.ps1
# Yeni, daha önce var olmayan yerel dosyaya tekrar üretme:
& .\tests\prepare_android.ps1 -Build -ApkPath 'exports/android/yumi-sako-yeni-deneme.apk'
```

USB hata ayıklama için telefonun kullanıcı tarafından yetkilendirilmiş olması gerekir. Bağlı cihaz kimliğini `adb devices -l` ile seçin; birden çok cihaz varsa hedefi açıkça belirtin. Sonraki güncellemelerde aynı imzayla `adb -s <telefon-kimliği> install -r <apk-yolu>` uygulama verilerini koruyarak yükler. İmza uyuşmazlığında uygulamayı kendiliğinden kaldırmayın; önce verilerin korunmasını değerlendirin.

Başlatma bileşeni: `com.yumisako.prototype/com.godot.game.GodotAppLauncher`.

## Oyuncu kontrol listesi

Öncelikli kısa tur (henüz cihazda yapılmadı):

1. Kullanıcı kurulum istediğinde 0.1.9-test/kod 10 güncellemesini mevcut uygulamayı kaldırmadan kur; imza uyuşmazlığında dur. Dikey görünüm ve menüden dört bölüme giriş kontrolü yap.
2. Birinci bölümde dokunmanın nişanı sıçratmadığını, sürükleme/bırakmanın tek atış yaptığını ve ikinci parmağın ekstra atış yapmadığını dene.
3. Top uçarken uygulamayı arka plana al ve dön: top/süre mola halinde kalmalı, DEVAM ET ile sürmeli. Eski dokunuş bırakması atış yapmamalı. Aynısını ekran kilidi ve Android geri tuşuyla dene.
4. Bir bölümü bitir; uygulamayı kapatıp açınca başarı/en iyi süre görünmeli. Yarım deneme uygulama tamamen kapanınca devam etmez; bu şu an desteklenmiyor. Test için uygulama verilerini silme.
5. Ses açıkken uyuyan Yumi'nin mırlamasını dinle; mola ve kayıpta eski sesler kesilmeli. SES kapalı tercihi uygulama yeniden açılınca korunmalı.

Sonucu cihaz modeli, sürüm, adım numarası, beklenen/görülen davranış ve varsa ekran görüntüsüyle kaydet. Hiçbir adım otomatik test geçti diye cihazda geçti sayılmaz. Ardından aşağıdaki ayrıntılı turu tamamla.

- Telefon dikeyken hedefler, metinler, AT ve HAV düğmeleri rahat görünüyor mu?
- Yeni menü kartlarında, özellikle dördüncü bölüm tamamlandıktan sonra açıklama ve en iyi süre birbirinden rahat ayrılıyor mu?
- Dokununca nişan yerinde kalıyor mu; sağa–sola sürükleme rahat mı; dikey sürükleme açıyı koruyor mu?
- Parmağı bırakmak tek top fırlatıyor mu; nişan çizgisi parmağı hedefe götürmeden okunuyor mu?
- HAV düğmesi uçuş sırasında kolay erişiliyor mu; topu düğmenin kendisine yönlendirmiyor mu?
- İkinci parmak yanlışlıkla ek atış yapıyor mu?
- Yeni dokunmatik düzeltmesi yüklendikten sonra: kasa dönüşü veya hedef karışması sırasında başlayan dokunuş, bekleme bitince bırakıldığında atış yapmıyor mu; yeni dokunuş normal atış yapıyor mu?
- Nişan alanında başlayıp ses/mola düğmesi üzerinde biten sürükleme top atmadan iptal oluyor mu; ardından normal bir sürükleme çalışıyor mu? Düğmeye doğrudan basmak kendi işlevini koruyor mu?
- İkinci bölümde duvar sekmesi çizgisi ve zorunlu sekme sayısı anlaşılır mı?
- Uygulamadan çıkıp geri dönünce görüntü ve kontroller korunuyor mu?
- Yeni mola sürümü yüklendikten sonra: telefon arka plana alınınca top/süre duruyor mu; geri dönünce DEVAM ET bekleniyor mu?
- Nişan sürüklerken mola verip devam edince eski parmağı bırakmak atış yapmıyor mu; yeni sürükleme aynı açıdan rahat devam ediyor mu? Fare seçimi/yerleştirmede de eski dokunuş hak tüketmiyor mu?
- Yeni kayıt sürümü yüklendikten sonra: tamamlanan bölümün en iyi süresi uygulama yeniden açıldığında menüde duruyor mu?
- Yeni sonuç ekranında kaybın nedeni ve yanlış delik/beklenen sembol net okunuyor mu; Yumi'nin yanlış yönlendirmesi ayırt ediliyor mu?
- Fare seçimi/oyalama sürerken bölüm biterse seçim kapanıyor mu; eski parmak bırakma sonuç ekranında işlem yapmıyor mu; yeni denemede iki fare hakkı geliyor mu?

Bu sonuçlar kullanıcı denemesiyle kaydedilecek. Masaüstü sentetik dokunma testleri gerçek telefon ergonomisini kanıtlamaz.

## Yeni yerel test paketi — 12 Ekim 2026

`exports/android/yumi-sako-0.1.9-test.apk` (kod 10) hazırlandı; telefona kurulmadı. Telefonda son onaylanan sürüm hâlâ 0.1.8-test/kod 9. Yeni pakette öğretici, mola/arka plan/geri tuşu, ilerleme kaydı, dokunma kenar durumları ve sonuç ses temizliği var. Kapsam kontrolü, 19 masaüstü oyun testi ve aynı ayarlı PCK ekran kontrolü geçti. Bunlar Android'de açılış, gerçek dokunma, mırlama duyulabilirliği veya arka plan/uygulama öldürme denemesi yerine geçmez. Eski APK korunuyor; yeni paylaşımlarda referansları çıkarılmış 0.1.9 paket kullanılmalı. Kurulum yalnız kullanıcı dönüp istediğinde yapılacak.
