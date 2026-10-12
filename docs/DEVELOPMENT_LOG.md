# Bağımsız geliştirme günlüğü

## Yetki ve sınırlar — 11 Ekim 2026

Kullanıcı kendisi dönene kadar kararları asistana bıraktı; kullanım limiti yenilenince devam edilmesini ve ardından istediği düzeltmeleri bildireceğini söyledi. Açık başla onayı verildi. Bu kapsamda yerel uygulama/test/dokümantasyon ve geri alınabilir Git kayıtları yapılabilir. GitHub'a gönderme, telefona yükleme, yeni ücretli servis veya kurulum yok. İlişkisiz Excel/JPG dosyaları ve sources/ referansları korunacak.

Saatlik aynı-sohbet devam takibi: yumi-ako-geli-tirmeye-devam, aktif. Kullanım müsait değilse kredi/sıfırlama hakkı kullanmadan sonraki zamanlanmış çalışmayı bekle. Kullanıcı geri döndüğünde yeni talimatına uy. Sırf limit tüketmek için iş uydurma. Yerel zamanlanmış iş için makine ve uygulama açık olmalı.

## Güvenli başlangıç

- e88d37f: önceki fare, 4. bölüm, menü, pati hareketi, ses, mırlama ve öğretici değişiklikleri yerel kayda alındı. GitHub'a gönderilmedi.
- Telefonda son yüklenen sürüm 0.1.8-test/kod 9; mırlamanın duyulduğu kullanıcı tarafından doğrulandı.
- Öğretici bu APK'da yok. Henüz yeni paket veya telefon kurulumu yapılmadı.

## Tamamlanan dilimler

Duraklatma ve telefon yaşam döngüsü tamamlandı: mola düğmesi, arka plana/fokus dışına geçişte mola, Android geri tuşu, canlı top/uyarı/kasa/oyuncak/kutlama durumunu bozmadan devam. 13 test geçti, pause_preview.gd çıktısı kontrol edildi. Fiziksel Android yaşam döngüsü denemesi yapılmadı.

Yerel tamamlanma/en iyi süre kaydı tamamlandı. Menüde tamamlanan bölüm ve en iyi süre görünür; bölümler test amacıyla açık kaldı. Test/önizleme çalışmaları gerçek oyuncu kaydını değiştirmez. Başarı süresi kutlama ve mola süresini içermez; kayıplar başarı olarak kaydedilmez. Menü önizlemesi görsel olarak kontrol edildi.

tests/run_checks.ps1 ile 14 kontrol birlikte çalıştırıldı ve hepsi geçti. Her kontrol için süre sınırı ve ayrı çıktı kaydı var. README ve Android test belgesi güncellendi. Bu yeni özellikler mevcut 0.1.8-test APK'sında yok; henüz paketlenmedi veya telefona kurulmadı.

Dokunmatik kenar durumunda hata doğrulandı ve düzeltildi: atış beklemesi, kasa dönüşü veya hedef karışması sırasında başlayan dokunuş, engel bittiğinde bırakılarak gecikmiş atış yapabiliyordu. Yeni dokunuş yalnız atıcı hazırken kurulabilir. Üç hatayı önce kırmızı testle doğruladık; düzeltmeden sonra yeni kontroller dahil 14 testin tamamı geçti. Atış hazır olma kuralı düğme, dokunma ve fırlatma için ortaklaştırıldı.

## Sıradaki işler

1. Sonraki dilimde mola/yeniden başlatma sonrası klavye ve dokunmatik nişanın temiz durumdan sürdüğünü kontrol et. Ses tercihi/test izolasyonu ve ses geçişleri aşağıda tamamlandı. Yeni bölüm eklemeden önce gerçek oyuncu verisi olmadan zorluk değerlerini gelişigüzel değiştirme.
2. Fiziksel Android mola/geri tuşu ve uygulamayı yeniden açınca başarı kaydının korunması, kullanıcı döndüğünde yeni APK ile denenecek.

## Saatlik devam — 11 Ekim 2026, 22:30 Türkiye

Kullanım izinli olarak doğrulandı; sıfırlama hakkı/kredi kullanılmadı. Kullanıcının yeni yönlendirmesi yoktu.

Nişan alanının içinde yer alan ses ve mola düğmelerinin üstüne parmağı bırakmak, alan atışı olarak işlenebiliyordu. Her iki düğmede hatayı önce başarısız testle doğruladık. Görünür eylem düğmelerinin alanı artık dokunmatik atıştan hariç; bu alanlara bırakılan hareket iptal edilir ve sonraki temiz dokunuş normal çalışır. Düzen veya ses tercihi değiştirilmedi.

4. bölüm kontrolü genişletildi: 30/60/144 FPS ve her biri 20 rastgele tohumla 60 karışma düzeni; her düzende üç duran hedefe gerçek süpürülmüş top atışı (toplam 180). Yumi sabotajı ayrı kontrollerde sınandığından burada izole edildi. Üç hedefin de yasal nişan açısında ve başka hedefe takılmadan erişilebilirliği geçti. Bu ölçüm gerçek oyuncunun başarı oranı veya bölüm süresi iddiası değildir.

14 toplu kontrolün tamamı geçti. scatter_preview.gd ile uyarı ve durmuş düzen ekranları üretildi, görsel olarak kontrol edildi. Telefon/GitHub/APK'ya dokunulmadı; ilişkisiz kullanıcı dosyaları korunuyor.

## Yerel kayıtlar

- e88d37f: başlangıç güvenli kaydı.
- 5f4f28e: mola/arka plan/geri tuşu, 13 test ve ekran kontrolü.
- 1277569: yerel bölüm başarısı/en iyi süre, 14 kontrol çalıştırıcısı ve güncel belgeler.
- 7b042e5: atıcı kapalıyken başlayan dokunuştan gecikmiş atışı önleme.
- 07bed02: HUD düğmelerine bırakılan sürüklemeden atışı önleme ve 180 gerçek karışmış hedef atışı.
- ed617ac: hata nedenini sonuç ekranında koruma, hareketli hedef/Yumi kontrolleri (15 test).
- d2da9d3: geçici yazma/bütünlük kontrolü/yedekten dönüş (16 test).
- ddfeb0a: görünür kayıt hatası/oturum uyarısı ve sonuçta oyuncak temizliği (17 test).
- b619cd8: menü kartı metin aralıkları ve dört bölüm sonuç düğmesi geçişleri.

## Saatlik devam — 11 Ekim 2026, 23:35 Türkiye

Kullanım izinli olarak doğrulandı; kredi/sıfırlama kullanılmadı. Yeni kullanıcı yönlendirmesi yoktu.

3. bölüm hareketli hedefleri 30/60/144 FPS'de, sekiz hareket fazı ve üç sembolle sınandı: 72 gerçek tahminli atışın hepsi hedefe ulaştı. Yumi bu uçuşlarda izole edildi; ayrı kontrollerde pati öncesi uyarı, tepki zamanı, havlamanın gerçekten patiyi iptal etmesi, bir topa ikinci pati olmaması, menzil dışına çıkınca ıskalama, yardım ve yanlış delik ayrımı doğrulandı. Bu sonuçlar gerçek oyuncunun başarısını/süresini ölçmez.

Yanlış delik geri bildirimi artık gerçek ve beklenen sembolü adlandırıyor. Yumi sebep olduysa metin bunu açıkça söylüyor. Kayıp ekranında son hatanın nedeni korunuyor; yeniden başlatmada eski neden temizleniyor. Zorluk, süre, atış veya ses kuralları değiştirilmedi.

interaction_smoke.gd toplu kontrol listesine eklendi; 15 kontrolün tamamı geçti. interaction_preview.gd ile normal/Yumi kaynaklı kayıp ekranları üretildi; daha uzun Yumi metninin sığdığı görsel olarak kontrol edildi. Bu değişiklikler kaynakta ve yerel Git kaydında; mevcut APK, telefon ve GitHub değişmedi. Kullanıcı dosyaları korundu.

## Saatlik devam — 12 Ekim 2026, 00:34 Türkiye

Kullanım izinli; yeni kullanıcı yönlendirmesi yok. Yerel profil doğrudan tek dosyaya yazıldığı için yazma kesintisi önceki veriyi riske atıyordu. Kayıt artık geçici dosyaya hazırlanıp okunarak doğrulanıyor, önceki sağlam dosya yedekleniyor ve hazır dosya ana kayıt olarak taşınıyor. Bozuk/eksik/boş ana dosyada sağlam yedeğe dönülüyor. Eski biçim korunuyor; tamamlanmamış geçici dosya okunmuyor. Bütünlük kontrolü veri hasarını yakalamak içindir, güvenlik/şifreleme iddiası değildir.

save_recovery_smoke.gd ile gerçek oyuncu profilinden ayrı dosyalarda bozuk değer/checksum, eksik dosya, geçici dosya, yeniden kaydetme, eski biçimden geçiş ve yazılamayan konum sınandı. Bunlar dosya durumu simülasyonlarıdır; gerçek cihazda güç kesintisi testi yapılmadı, eksiksiz kurtarma garantisi yok. Sağlam yedek önceki yazmayı temsil ettiğinden son sonuç geri alınabilir.

16 toplu kontrol geçti. Menü önizlemesi yeniden üretildi ve rekor gösteriminin korunduğu görsel olarak kontrol edildi. Telefon/APK/GitHub değişmedi; kullanıcı dosyaları korundu. Açık kalan iş: oyuncuya görünür kayıt hatası bildirimi.

## Saatlik devam — 12 Ekim 2026, 01:34 Türkiye

Kullanım izinli; kredi/sıfırlama kullanılmadı, yeni kullanıcı yönlendirmesi yoktu. Kayıt yazılamadığında sonuç ekranı ve menüde görünür oturum uyarısı eklendi; yeni rekor kalıcı gibi sunulmuyor. Sonraki başarılı yazma uyarıyı temizler; yedekten dönüş menüde belirtilir. Oturum bilgileri korunur, oyun başarısı kayıt hatası yüzünden engellenmez.

Bölüm sonucu fare seçimi, aktif oyalama ve fareye ait parmak kimliğini kapatır. Başarı/kayıp sonrasında eski parmak bırakmasının işlem yapmadığı ve yeni denemede iki fare hakkının döndüğü test edildi. Mola sırasında oyuncak durumu korunmaya devam eder.

save_notice_smoke.gd ile gerçek dosyaya dokunmayan yazma hatası simülasyonu eklendi. Çıktıdaki bir disk-yazma uyarısı bu testin beklenen sonucudur; gerçek kullanıcı disk hatası değildir. 17 toplu kontrolün tamamı geçti. save_notice_preview.gd çıktılarında uzun son bölüm başarı metniyle sonuç uyarısı ve menü uyarısı görsel olarak kontrol edildi. Telefon/APK/GitHub ve ilişkisiz kullanıcı dosyaları değişmedi.

## Saatlik devam — 12 Ekim 2026, 02:32 Türkiye

Kullanım izinli; beş saatlik pencere yenilenmiş olarak görünüyor, sıfırlama kredisi tüketilmedi. Yeni kullanıcı yönlendirmesi yoktu.

Bölüm kartlarında başlık, açıklama ve tamamlanma satırlarının boşlukları ayrıldı. Dördüncü bölüm açıklaması iki kısa satırla netleştirildi. Godot yazı tipinde iki satırın gerçek yüksekliği 49 piksel olduğundan yerleşim buna göre ayarlandı; rekor satırına en az 8 piksel ara bırakıldı. Menü testine gerçek metin yükseklikleri ve alanların ayrılığı kontrolleri eklendi. Tamamlanmış dördüncü kart dahil önizleme yeniden üretildi ve görsel olarak kontrol edildi.

Dört bölümün sonuç düğmeleri GUI tıklama yoluyla sınandı: doğru sonraki bölüm, son bölümden birinciye dönüş, eski panelin kapanması, tıklamanın atışa dönüşmemesi, ilerleme/hata/havlama/fare haklarının yeni bölüm kuralıyla sıfırlanması. Bu gezinme testlerinde başarı durumu bilerek kuruldu; gerçek bölüm oynanabilirliği iddiası değil, geçiş izolasyonudur.

17 toplu kontrol geçti. Telefon/APK/GitHub ve kullanıcı dosyaları değişmedi; değişiklikler yerel kaydedildi.

## Saatlik devam — 12 Ekim 2026, 03:39 Türkiye

Kullanım izinli; yeni kullanıcı yönlendirmesi yok. Ses testleri başlangıçta gerçek muted tercihini okuyabildiğinden testler oyuncu seçimine bağımlıydı. --script modunda gerçek tercih okuma/yazma varsayılan olarak kapatıldı; ayar testleri kendi dosyasını ve açık persistence_enabled iznini kullanır. Yanlış tipli muted alanı bool'a zorla çevrilmez.

Sonuç geçişinde eski efekt kanalları tamamen kesilmiyordu. Önce iki başarısız testle eksik stop_all geçişi doğrulandı; kayıp ve başarı önce bütün kanalları kesiyor, başarı ardından unlock efektini oynatıyor. Mola sırasında susma ve moladan sonra mırlama gecikmesi de doğrulandı. Telefonun onaylanan ses tonları/seviyeleri değiştirilmedi.

18 toplu kontrol geçti. audio_state_preview.gd gerçek masaüstü oynatıcı bayraklarıyla mırlama başlama/mola durma ve kayıpta efekt durmayı doğruladı; test kanalları sessize yakın -80 dB kullanıldı, sistem sesi/kayıtlı tercih değişmedi. SES açık/kapalı ekranları üretildi, kapalı düğmesi görsel olarak kontrol edildi. Bu insanın duyulabilirlik ölçümü veya telefon testi değildir. SOUND_EFFECTS.md içindeki eski duyulabilirlik bekliyor notu kullanıcı onayıyla güncellendi. Telefon/APK/GitHub ve kullanıcı dosyaları değişmedi.
