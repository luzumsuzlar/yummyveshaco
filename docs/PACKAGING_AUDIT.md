# APK paylaşım kontrolü — 12 Ekim 2026

Mevcut `exports/android/yumi-sako-test.apk` salt okunur incelendi. Boyut: 38.988.928 bayt; SHA256: `DF9E65EC90830F4026AFC984A2D2C12E155908DD9D46E4C5599F5CEF0920BFC5`.

132 ZIP girdisi arasında oyunun güncel kaynak kodunda kullanılmayan üç görsel bulundu: `sleep.jpg`, `Generated Image October 07, 2026 - 9_31PM.jpg` ve eski `yumi-sleep-v1.png`. Her biri ithal edilmiş doku ve import tanımı olarak paketlenmiş (toplam altı girdi). Güncel oyun uyku görseli `yumi-sleep-v2.png` kullanıyor.

Excel/CSV/TSV dosyaları, tests/docs/exports/sources yolları APK girdilerinde bulunmadı. Görsellerin veya Excel dosyalarının içeriği açılmadı; bu inceleme özel içerik bulunduğu iddiası veya tam gizlilik garantisi değildir. Kaynakların Git'te izlenmiyor olması APK dışında kaldıkları anlamına gelmez: mevcut export ayarı all_resources, istisnalar yalnız tests/*,docs/*.

## Paylaşımdan önce

Eski APK'yı yeni gönderimlerde kullanmayın; referansları hariç tutan yeni paket hazırlanıp doğrulanmalı. Mevcut APK korunuyor, yeni paket bu tur üretilmedi ve telefona yüklenmedi.

PowerShell kontrolü: `& .\tests\audit_apk.ps1 -ApkPath 'yeni-paketin-tam-yolu.apk'`. Yasak girdilerde hata verir. `-AuditOnly` sadece listelemeye yarar; temiz paket onayı değildir. Kontrol ZIP girdilerini okur, dosya çıkartmaz veya değiştirmez; gömülü .pck ya da bilinmeyen kaynak yerleşiminde sonuç belirsiz olarak hata verir. Bilinen yasak yollar/uzantılar için dar bir korumadır, bütün olası özel dosyaları tanımaz. Her yeni APK'da gerçek içerik tekrar incelenmeli.

Sonraki yerel dilim: kaynak dosyaları silmeden export kapsamını daralt; yeni APK'yı farklı adla üret, bu kontrolle paket içeriğini doğrula. Ardından oyun kaynaklarının eksiksiz yüklenmesini yerel olarak kontrol et. Sürüm kodu/adı ve fiziksel Android denemesi ayrı ele alınmalı; GitHub gönderimi veya telefona kurulum kullanıcı dönene kadar yok.

## Temiz yerel paket — 12 Ekim 2026, 06:35 Türkiye

Yukarıdaki ilk incelemenin takip işi tamamlandı. Yeni dosya `exports/android/yumi-sako-0.1.9-test.apk`, sürüm 0.1.9-test/kod 10, 36.723.292 bayt; SHA256 `83F180E6B9D669B05A8FE6033CF5448D4E545BA04B4D72831E340765BFD05E40`. Android araçları imzalama/doğrulama işlemini tamamladı, manifest com.yumisako.prototype ve arm64-v8a olarak kontrol edildi. Mağaza/release paketi değildir.

128 ZIP girdisi kontrol edildi: bilinen yasak girdiler yok; üç derlenmiş oyun betiği ve yedi gerekli doku var. Export dışlama filtresine kaynakları silmeden referans görselleri, eski uyku görseli, tablo uzantıları ve çıktı/referans yolları eklendi. all_resources korundu: yalnız ana sahne/bağımlılıkları seçilen ilk denemede betiğin preload kaynakları gelmedi; guard bu eksik denemeyi reddetti, ayar geri alınıp APK yeniden üretildi. Bu olay nedeniyle kontrol yalnız yasak dosyaları değil gerekli kaynakların varlığını da doğruluyor.

Aynı export ayarıyla ayrı PCK üretildi. tests/package_preview.gd dış betik olarak, kaynak proje yerine exports dizininden --main-pack ile çalıştırıldı; source-only test dosyasının görünmemesi ve gerçek profil/tercih erişiminin kapalı olması doğrulandı. Dört bölüm, mola ve menü paket kaynaklarıyla açıldı; ekranlar exports/package-preview içine üretildi. İlk bölüm, mola ve menü görsel olarak kontrol edildi. Bu masaüstü PCK kontrolüdür; APK'nin Android'de açıldığını veya gerçek dokunmayı doğrulamaz. 19 kaynak oyun testi de geçti.

Eski APK'nın SHA256 değeri aynı kaldı. Kullanıcı Excel/JPG dosyaları, telefon ve GitHub değişmedi. Yeni APK telefon testi bekliyor; paketin kapsam kontrolü tam gizlilik garantisi değildir.

## Beş bölümlük kaynak bağımlılığı kontrolü — 12 Ekim 2026

Yerel kaynak ec5f8e2 ile yeni ve ayrı `exports/android/yumi-sako-five-level-ec5f8e2.pck` üretildi (Android export filtresiyle yalnız kaynak paketi; APK değildir). Boyut 8.324.572 bayt; SHA256 `AD78530F556B3ABE9A9A7233B7E8E902B40E50368082795B6219FD16CE72F4FA`. Önceki PCK ve APK dosyaları korunuyor. Son Android APK 0.1.12 hash'i `C875C0CF5E24F0B9EED59FB8B9AFDED48DA71544DD264FFB476F30267364368E` olarak aynı.

Geliştirme klasörü yerine exports çalışma dizininden `--main-pack` ve dış `tests/package_preview.gd` ile açıldı. Kontrol `--expected-levels=5 --output=D:/Works/kedikopek/exports/package-preview-ec5f8e2` aldı; source-only test kaynağının görünmediğini ve gerçek profil/ses tercih erişiminin kapalı olduğunu doğruladı. 28 görünür paket kaynak yolu bilinen tests/docs/exports/sources, tablo/JPG ve eski uyku referanslarına karşı tarandı; yasak yol bulunmadı. Bu dar kapsam kontrolüdür, bütün olası özel kaynakları tanıma garantisi değil.

Beş bölüm, gizli sembolün atışı kilitlememesi, mola, ikinci menü sayfası ve fare geri bildirimi paket kaynaklarıyla açıldı; 0 hata. İlk bölüm, gizli şifre, menü ve fare ekranları görsel incelendi. Bu masaüstü Godot/OpenGL testidir; Android yükleme, manifest/imza veya fiziksel dokunma/ses testi yapılmadı. Android APK üretilmedi. Bir sonraki kullanıcı telefon güncellemesinde yeni sürüm kodu ve ayrı APK gerekir; bu PCK'yi telefona kurulabilir paket diye sunma.
