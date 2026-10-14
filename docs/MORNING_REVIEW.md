# Sabah kontrol notu — Yumi & Şako

## Hangi sürüm?

14 Ekim kullanıcı telefon bağlı isteğiyle **0.1.16-test / kod 17** kuruldu ve başlatıldı. Ortak mama kutlaması, Şako tepkileri, Yumi temizlenmesi ve oyuncak fareyle pati oyunu korunuyor. Yeni paket için henüz oyuncu deneme sonucu yok.

Gece hazırlanıp **0.1.16 ile telefona da alınan** yenilikler:

- Uyuyan Yumi'nin hafif nefes alıp vermesi; zemin teması sabit.
- Pati yalama/yüz temizleme öncesi ve sonrası kısa nötr bakış; toplam hareket süreleri aynı.
- Molada pati çarpma parıltısı ve deliğin görsel titreşiminin korunması.
- FARE seçimine girince temizlenmenin anında kesilmesi; hemen mola verilince eski pozun dönmemesi.

Bu farklar artık telefonda denenebilir; gece otomatik yükleme yapılmadı, sabah kullanıcı isteği üzerine güncellendi. Eski 0.1.15 APK bu yenilikleri içermez.

## Bilgisayarda kısa kontrol

Projeyi Godot'ta açıp çalıştır. Yeni kaynak için atış/düşüş ve ilk dört bölümün kuralları değiştirilmedi.

1. Birinci bölümün başında kısa süre Yumi'yi izle. Nefes hareketi hafif olmalı; kedi zeminde kaymamalı. Mola verince aynı karede kalmalı.
2. Üçüncü bölümde top atmadan uygun sakin durumda yaklaşık 3,5 sn bekle. Yumi önce kısa bakış, sonra pati yalama yapmalı. Hareket bitince nötr poza dönmeli. Sonraki uygun sakin aralarda yüz temizleme ve göz/kulak tepkisini izle; her seferinde aynı hareket dönmemeli.
3. Yalama/yüz temizleme sırasında atış yap. Atış gecikmeden çıkmalı ve Yumi mevcut davranışına dönmeli. FARE seçip hemen mola ver; eski yalama pozu geri gelmemeli. Seçimi iptal etmek fare hakkı tüketmemeli.
4. Dördüncü bölümde Yumi deliklere vururken mola ver. Pati etkisi ve delik görünümü durduğu karede kalmalı; devam edince normal akış sürmeli.
5. Bir bölümü tamamla. Yumi ve Şako'nun mamaya koşması, PAYLAŞALIM/BİRLİKTE tepkisi okunmalı. Kutlama mola verildiğinde yerinde kalmalı.

Hareket fazla yapay/hızlı mı, kedinin boyutu veya ayağı sıçrıyor mu, nişanı kapatıyor mu? Bölüm ve gördüğün anı not et. Beğenilmeyen küçük efektler ayrı yerel Git kayıtlarıyla geri alınabilir.

## Doğrulanan ve bekleyen

Güncel kaynağın 25 otomatik testi geçti. Yedi Yumi mola durumu için karakter bölgesinde önce/sonra piksel eşitliği geçti; 14 tanı görüntüsü üretildi. Tanı görüntülerinde mola paneli sadece karakter karşılaştırması için gizlenir; normal oyunda panel vardır.

Örnek görüntüler bilgisayarda `exports/yumi-rest-preview`, `exports/groom-preview`, `exports/yumi-pause-preview` altında. Bunlar test düzenekleridir, gerçek oyuncu başarısı/süre ölçümü değil. Görsellerin incelenmesi telefon ergonomisini, gerçek ses duyulmasını veya bütün cihaz yaşam döngüsünü kanıtlamaz.

0.1.16 APK üretimi ve telefon kurulumu sabah kullanıcı isteğiyle tamamlandı. GitHub gönderimi veya yeni bölüm yok. Detaylı geçmiş: `docs/DEVELOPMENT_LOG.md`. Sonraki karar önce bu kısa turun geri bildirimine göre verilmeli; sırf içerik artsın diye yeni mekanik eklenmemeli.
