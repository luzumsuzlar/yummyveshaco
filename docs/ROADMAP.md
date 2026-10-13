# Yumi & Şako — ilerleme planı

12 Ekim 2026. İlk hedef: dört bölümlük, anlaşılır ve telefonda güvenilir bir test sürümü. Bu plan takvim sözü değildir; her aşama aşağıdaki kanıtla tamamlanır.

Son kullanıcı kararı: ilk dört bölümün temposu normal bulundu; süreyi artırmak için değer değiştirme. Kullanıcı kendisi dur diyene kadar mantıklı yerel geliştirmeye yeniden yetki verdi. Ayrıntılı oyuncu verisi hâlâ kısmi; bunu kesin denge doğrulaması olarak sunmadan, mevcut bölümleri koruyan altyapı/Yumi cilası ve tek fikirli beşinci bölüm hazırlığına ilerlenebilir.

13 Ekim güncel yönlendirme: kullanıcı yeni bölümler yerine görsel güçlendirmeyi seçti ve özellikle Yumi'nin pati yalama gibi hareketlerini istedi. Yalama, yüz temizleme, göz kırpma/kulak tepkisi, Şako tepkileri ve fareyle pati oyunu 0.1.14 ile telefona alındı; kullanıcı “hepsi tamam devamet” diyerek olumlu geri bildirim verdi. Bu, bütün yaşam döngüsü kontrollerinin tamamlandığı anlamına gelmez. Kullanıcının sonraki telefon bağlı isteğiyle ortak kutlama, son pati sonrası poz temizliği ve mola rolü düzeltmesi 0.1.15/kod16 ile kuruldu; bu sürüme henüz oyuncu geri bildirimi gelmedi. Pati çarpma parıltısı ve delik titreşimini molada koruyan sonraki düzeltme yalnız yerel kaynakta. Öncelik bu hareketlerin geçişleri ve mevcut karakterlerin görsel ifadesidir; aşağıdaki eski aşama sırası bu yeni yönlendirmeyi geçersiz kılmaz. Beşinci bölümün Kapak Oyunu önerisi henüz uygulanmadı.

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

Yerel kaynakta fareye gidiş ve fareyle oyun ayrı gösteriliyor; yakaladıktan sonra gerçek kalan süre ve tükenen halka var. Süre/iki kullanım hakkı değişmedi. Otomatik ve portre görsel kontrol geçti; oyuncunun açıklamasız anlayıp anlamadığı fiziksel denemede bekliyor.

Hazırlık, pati, dönüş ve sakinleşme okunabilir olsun. Üçüncü bölümde fareye verilen tepki oyuncunun bilinçli olarak yararlanabildiği bir davranış olsun. Önce mevcut oyalama davranışını dene; işe yaramadığı nokta görülürse değiştir. HAV şimdilik genişletilmeyecek. Oyuncu ne olduğunu açıklama almadan anlatabiliyorsa bu aşama başarılıdır.

## 4. Görsel/ses tutarlılığı

Hareketli/karışmış deliklerde ve Yumi'nin sektirdiği toplarda düşüş kontrolü; yönlere uygun yürüyüş; pati ve ses geçişleri. Kullanıcı tarafından onaylanmış görünümü gerekçesiz değiştirme. Yeni ses veya efekt aynı anda eklenip eski sorunu gizlememeli. Her değişiklik kaynak testleri + görsel kontrol, ardından kullanıcı istediğinde cihaz denemesi görmeli.

## 5. Beşinci bölüm — yerel hafıza prototipi

Kayıt ve portre menü altyapısı hazır: bölüm sayısı dinamik, dört kartlık sayfalar ek kartları taşır. Gizli Şifre 0.1.13-test/kod 14 ile telefona alındı. Tek yeni kural, hazır atışta 2,5 saniye görünen sembolün gizlenmesi. Delikler sabit, Yumi topa müdahale etmiyor. Kullanıcı beşinci bölüme kadar sorun görmediğini, sembol gizlendikten sonra atmasına rağmen belirgin fark hissetmediğini söyledi. Erken atışla kuralı atlama varsayımı bu denemeyi açıklamıyor. LEVEL_5_DESIGN.md ve FIVE_LEVEL_GAME_SCENARIO_TR.md mevcut davranışı tanımlar; deneyim farkı için yeni tasarım gerekçesi değerlendirilmeli. Tek gözlemden bütün oyuncular için zorluk/fayda sonucu çıkarma.

İlk dört bölümün önemli giriş/tempo sorunları çözülmeden uygulanmayacak. Tek bir büyük Yumi yaramazlığı etrafında tasarla; iki top, yeni top türü ve hareketli delik kurallarını aynı anda ekleme. Önce kısa tasarım ve mevcut kurallardan farkı netleştir, ardından prototip/test.

## 6. Arkadaş testi

Temiz, sürümü belli APK ve kısa geri bildirim listesi hazırlanır. Kullanıcı paylaşır; otomatik olarak kimseye gönderilmez. Oyuncuya kontrolleri önceden anlatmadan neyi anladığını gözle; müdahaleyi not et. Anlaşılmayan kural, kontrol sorunu ve tekrar oynama isteğini ayır. Küçük grubun görüşlerini kesin pazar talebi gibi yorumlama.

## Çalışma sınırı

12 Ekim'deki yenilenen yetki kullanıcı dur diyene kadar geçerli; sadece sohbete dönmesi yetkiyi bitirmez, yeni yönlendirmesine uyulur. GitHub gönderimi, dış mesaj/paylaşım, telefon yüklemesi, yeni servis/kurulum ve mağaza yayını ayrı kullanıcı isteği gerektirir. Kullanım izinli değilse kredi/sıfırlama tüketmeden sonraki saatlik kontrol beklenir. Bilgisayar/uygulama açık olmalıdır; kesintisiz çalışma veya otomatik limit yenileme garantisi yok. İlişkisiz Excel/JPG, referans video ve sources/ referansları korunur. Fiziksel deneme sonuçları elde edilmeden cihaz kontrolünü tamamlandı diye işaretleme.
