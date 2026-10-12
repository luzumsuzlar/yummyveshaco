# Yumi & Şako — ilerleme planı

12 Ekim 2026. İlk hedef: dört bölümlük, anlaşılır ve telefonda güvenilir bir test sürümü. Bu plan takvim sözü değildir; her aşama aşağıdaki kanıtla tamamlanır.

## 1. Dört bölümlük sürümü doğrula — şu anki aşama

- Son bekleme mesajları, kullanıcı tarafından beğenilen düşüş ve mevcut dört bölüm aynı APK'da olsun.
- Otomatik giriş/fizik/kayıt/ses kontrolleri, paket kapsamı, manifest ve imza geçsin.
- Gerçek telefonda dört bölüme giriş, sürükle/bırak, ikinci parmak, mola/geri dönüş, başarı kaydı ve ses kontrol edilsin.
- Dördüncü bölümde delikler durmuşken Yumi'nin dönüşü ile gerçek atış hazır durumu ayırt edilsin.

Masaüstü testinin geçmesi telefon ergonomisini kanıtlamaz. Telefon test listesi ANDROID_TEST.md, deneme notları PLAYTEST_NOTES.md içinde. Kullanıcının düşüşü beğenmesi doğrulanmış geri bildirimdir; dört bölümün bütün cihaz kontrolleri yapılmış sayılmaz.

## 2. Tempo ve zorluğu ölç — gerçek deneme bekliyor

Her bölümü önce bir kez tanı; ardından aynı sürümde iki denemeyi kaydet. Süre, hata, sonuç, sıkıcı/zor an ve sebebi yeterli. Kayıp denemeleri başarı sürelerine karıştırma; en iyi süreyi bütün oyuncuların tipik süresi diye sunma. Mola süresi oyun süresine dahil değildir.

İlk bölüm için 60–90 saniye yalnız tasarım hedefidir, ölçülmüş sonuç değil. Öğretici anlaşılıyorsa daha kısa olması tek başına kusur sayılmaz. Süreyi uzatmak gerekiyorsa anlamlı nişan/karar ekle; boş bekleme ekleme. Hareket/hitbox/zamanlama değerlerini tek tek değiştir ve aynı testle karşılaştır.

Tamamlanma: dört bölümün deneme kayıtları var; en belirgin sorun seçildi ve yapılan değişiklik yeniden denendi. İki deneme bilimsel denge kanıtı değil, ilk yön bulma verisidir.

## 3. Yumi ve oyuncak fare — ikinci aşamanın ardından

Hazırlık, pati, dönüş ve sakinleşme okunabilir olsun. Üçüncü bölümde fareye verilen tepki oyuncunun bilinçli olarak yararlanabildiği bir davranış olsun. Önce mevcut oyalama davranışını dene; işe yaramadığı nokta görülürse değiştir. HAV şimdilik genişletilmeyecek. Oyuncu ne olduğunu açıklama almadan anlatabiliyorsa bu aşama başarılıdır.

## 4. Görsel/ses tutarlılığı

Hareketli/karışmış deliklerde ve Yumi'nin sektirdiği toplarda düşüş kontrolü; yönlere uygun yürüyüş; pati ve ses geçişleri. Kullanıcı tarafından onaylanmış görünümü gerekçesiz değiştirme. Yeni ses veya efekt aynı anda eklenip eski sorunu gizlememeli. Her değişiklik kaynak testleri + görsel kontrol, ardından kullanıcı istediğinde cihaz denemesi görmeli.

## 5. Beşinci bölüm — henüz başlanmadı

İlk dört bölümün önemli giriş/tempo sorunları çözülmeden uygulanmayacak. Tek bir büyük Yumi yaramazlığı etrafında tasarla; iki top, yeni top türü ve hareketli delik kurallarını aynı anda ekleme. Önce kısa tasarım ve mevcut kurallardan farkı netleştir, ardından prototip/test.

## 6. Arkadaş testi

Temiz, sürümü belli APK ve kısa geri bildirim listesi hazırlanır. Kullanıcı paylaşır; otomatik olarak kimseye gönderilmez. Oyuncuya kontrolleri önceden anlatmadan neyi anladığını gözle; müdahaleyi not et. Anlaşılmayan kural, kontrol sorunu ve tekrar oynama isteğini ayır. Küçük grubun görüşlerini kesin pazar talebi gibi yorumlama.

## Çalışma sınırı

GitHub gönderimi, dış mesaj/paylaşım, yeni servis/kurulum ve mağaza yayını ayrı kullanıcı isteği gerektirir. Kullanıcı dönmüş durumda; eski saatlik bağımsız çalışma talimatı yeni yönlendirmelerin yerine geçmez. İlişkisiz Excel/JPG ve sources/ referansları korunur. Fiziksel deneme sonuçları elde edilmeden sonraki aşamayı tamamlandı diye işaretleme.
