# APK paylaşım kontrolü — 12 Ekim 2026

Mevcut `exports/android/yumi-sako-test.apk` salt okunur incelendi. Boyut: 38.988.928 bayt; SHA256: `DF9E65EC90830F4026AFC984A2D2C12E155908DD9D46E4C5599F5CEF0920BFC5`.

132 ZIP girdisi arasında oyunun güncel kaynak kodunda kullanılmayan üç görsel bulundu: `sleep.jpg`, `Generated Image October 07, 2026 - 9_31PM.jpg` ve eski `yumi-sleep-v1.png`. Her biri ithal edilmiş doku ve import tanımı olarak paketlenmiş (toplam altı girdi). Güncel oyun uyku görseli `yumi-sleep-v2.png` kullanıyor.

Excel/CSV/TSV dosyaları, tests/docs/exports/sources yolları APK girdilerinde bulunmadı. Görsellerin veya Excel dosyalarının içeriği açılmadı; bu inceleme özel içerik bulunduğu iddiası veya tam gizlilik garantisi değildir. Kaynakların Git'te izlenmiyor olması APK dışında kaldıkları anlamına gelmez: mevcut export ayarı all_resources, istisnalar yalnız tests/*,docs/*.

## Paylaşımdan önce

Eski APK'yı yeni gönderimlerde kullanmayın; referansları hariç tutan yeni paket hazırlanıp doğrulanmalı. Mevcut APK korunuyor, yeni paket bu tur üretilmedi ve telefona yüklenmedi.

PowerShell kontrolü: `& .\tests\audit_apk.ps1 -ApkPath 'yeni-paketin-tam-yolu.apk'`. Yasak girdilerde hata verir. `-AuditOnly` sadece listelemeye yarar; temiz paket onayı değildir. Kontrol ZIP girdilerini okur, dosya çıkartmaz veya değiştirmez; gömülü .pck ya da bilinmeyen kaynak yerleşiminde sonuç belirsiz olarak hata verir. Bilinen yasak yollar/uzantılar için dar bir korumadır, bütün olası özel dosyaları tanımaz. Her yeni APK'da gerçek içerik tekrar incelenmeli.

Sonraki yerel dilim: kaynak dosyaları silmeden export kapsamını daralt; yeni APK'yı farklı adla üret, bu kontrolle paket içeriğini doğrula. Ardından oyun kaynaklarının eksiksiz yüklenmesini yerel olarak kontrol et. Sürüm kodu/adı ve fiziksel Android denemesi ayrı ele alınmalı; GitHub gönderimi veya telefona kurulum kullanıcı dönene kadar yok.
