# Android telefon denemesi

11 Ekim 2026 güncel durum: 0.1.8-test (kod 9) bağlı Samsung telefona güncelleme olarak yüklendi ve açıldı; mırlamanın duyulduğu kullanıcı tarafından doğrulandı. Fare, 4. bölüm, bölüm menüsü, belirgin pati ve sesler bu pakette var. Yeni bağlamsal öğretici, mola/arka plan kontrolü ve en iyi süre kaydı yalnız yerel kaynakta; henüz APK'ya alınmadı veya telefona yüklenmedi. Aşağıdaki eski tarihli notlar geçmiş denemelerin kaydıdır.

7 Ekim 2026: kıvrılmış uyku görseli v2, karakterler ve sahne derinliğini içeren 0.1.3-test paketi hazırlandı. Bağlı Samsung telefona mevcut uygulama kaldırılmadan yüklendi; sürüm kodu 4 doğrulandı, oyun açıldı ve başlangıç kayıtlarında hata görülmedi. Görsel yerleşimin telefondaki son değerlendirmesi kullanıcı denemesini bekliyor.

1 Ekim 2026: test paketi bağlı Samsung SM-S938B telefona başarıyla kuruldu ve açıldı. Uygulama süreci çalışır durumda, Godot başlangıç kayıtlarında hata görülmedi. Bu kontrol dokunmatik oynanışın veya tüm bölüm akışının gerçek cihazda doğrulandığı anlamına gelmez.

Aynı gün 0.1.1-test güncellemesi mevcut uygulama kaldırılmadan yüklendi; telefondaki sürüm kodu 2 olarak doğrulandı ve oyun yeniden açıldı. Kullanıcının dokununca nişanın sıçraması geri bildirimi üzerine mutlak parmak hedeflemesi yerine göreli yatay sürükleme uygulandı. Otomatik dokunmatik, duvar ve görsel testleri geçti; yeni kontrolün ergonomisi kullanıcı denemesini bekliyor.

## Paket

- Uygulama adı: Yumi & Şako Test
- Kimlik: `com.yumisako.prototype`
- Hazırlanan ve son yüklenen sürüm: `0.1.8-test`, kod `9`. Mırlama telefonda duyuldu olarak doğrulandı.
- Yeni yerel özellikler henüz bu pakette değildir; kaynak yeniden paketlenirse sürüm kodunu artırın.
- Mimari: ARM64; eski 32-bit telefonlar bu paketin kapsamında değildir.
- APK: `exports/android/yumi-sako-test.apk` (yaklaşık 39 MB)
- Debug imzalı yerel deneme; mağaza sürümü değildir. İnternet veya titreşim izni içermez.

Mevcut Godot 4.7.2 export şablonları, Android SDK ve Java ortamı kullanıldı; yeni kurulum veya global ayar değişikliği yapılmadı. Android için ETC2/ASTC doku içe aktarımı proje ayarında açıldı. APK, Git tarafından yok sayılan `exports/` altında tutulur.

## Yeniden üretme

Godot kullanıcı ayarlarında mevcut Android SDK, Java ve debug keystore yolları tanımlı olmalıdır. Depodaki export ayarı keystore parolası içermez.

```powershell
& "D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path "D:\Works\kedikopek" --export-debug "Android Test" "D:\Works\kedikopek\exports\android\yumi-sako-test.apk"
```

USB hata ayıklama için telefonun kullanıcı tarafından yetkilendirilmiş olması gerekir. Bağlı cihaz kimliğini `adb devices -l` ile seçin; birden çok cihaz varsa hedefi açıkça belirtin. Sonraki güncellemelerde aynı imzayla `adb -s <telefon-kimliği> install -r <apk-yolu>` uygulama verilerini koruyarak yükler. İmza uyuşmazlığında uygulamayı kendiliğinden kaldırmayın; önce verilerin korunmasını değerlendirin.

Başlatma bileşeni: `com.yumisako.prototype/com.godot.game.GodotAppLauncher`.

## Oyuncu kontrol listesi

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
