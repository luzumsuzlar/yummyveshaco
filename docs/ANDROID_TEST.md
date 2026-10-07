# Android telefon denemesi

Yerel projedeki yeni kıvrılmış uyku görseli v2 henüz aşağıdaki APK'ye dahil edilmedi; paket yeniden üretilmeden telefon güncellemesi yapılmamalıdır.

1 Ekim 2026: test paketi bağlı Samsung SM-S938B telefona başarıyla kuruldu ve açıldı. Uygulama süreci çalışır durumda, Godot başlangıç kayıtlarında hata görülmedi. Bu kontrol dokunmatik oynanışın veya tüm bölüm akışının gerçek cihazda doğrulandığı anlamına gelmez.

Aynı gün 0.1.1-test güncellemesi mevcut uygulama kaldırılmadan yüklendi; telefondaki sürüm kodu 2 olarak doğrulandı ve oyun yeniden açıldı. Kullanıcının dokununca nişanın sıçraması geri bildirimi üzerine mutlak parmak hedeflemesi yerine göreli yatay sürükleme uygulandı. Otomatik dokunmatik, duvar ve görsel testleri geçti; yeni kontrolün ergonomisi kullanıcı denemesini bekliyor.

## Paket

- Uygulama adı: Yumi & Şako Test
- Kimlik: `com.yumisako.prototype`
- Hazırlanan güncel sürüm: `0.1.2-test`, kod `3` (karakter görselleri ve sahne derinliği).
- Son doğrulanan telefon kurulumu: `0.1.1-test`, kod `2`. 7 Ekim 2026 kontrolünde bağlı telefon algılanmadı; yeni sürüm henüz telefona yüklenmedi.
- Mimari: ARM64; eski 32-bit telefonlar bu paketin kapsamında değildir.
- APK: `exports/android/yumi-sako-test.apk` (yaklaşık 31 MB)
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
- Dokununca nişan yerinde kalıyor mu; sağa–sola sürükleme rahat mı; dikey sürükleme açıyı koruyor mu?
- Parmağı bırakmak tek top fırlatıyor mu; nişan çizgisi parmağı hedefe götürmeden okunuyor mu?
- HAV düğmesi uçuş sırasında kolay erişiliyor mu; topu düğmenin kendisine yönlendirmiyor mu?
- İkinci parmak yanlışlıkla ek atış yapıyor mu?
- İkinci bölümde duvar sekmesi çizgisi ve zorunlu sekme sayısı anlaşılır mı?
- Uygulamadan çıkıp geri dönünce görüntü ve kontroller korunuyor mu?

Bu sonuçlar kullanıcı denemesiyle kaydedilecek. Masaüstü sentetik dokunma testleri gerçek telefon ergonomisini kanıtlamaz.
