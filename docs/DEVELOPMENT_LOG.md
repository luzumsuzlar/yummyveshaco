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

1. Sonraki dilimde yerel kayıt dayanıklılığını (yarıda yazma/bozuk dosya) ve menü-sonuç-oyuncak geçişlerini incele. 3. ve 4. bölümde aşağıdaki gerçek atış kontrolleri tamamlandı. Yeni bölüm eklemeden önce gerçek oyuncu verisi olmadan zorluk değerlerini gelişigüzel değiştirme.
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

## Saatlik devam — 11 Ekim 2026, 23:35 Türkiye

Kullanım izinli olarak doğrulandı; kredi/sıfırlama kullanılmadı. Yeni kullanıcı yönlendirmesi yoktu.

3. bölüm hareketli hedefleri 30/60/144 FPS'de, sekiz hareket fazı ve üç sembolle sınandı: 72 gerçek tahminli atışın hepsi hedefe ulaştı. Yumi bu uçuşlarda izole edildi; ayrı kontrollerde pati öncesi uyarı, tepki zamanı, havlamanın gerçekten patiyi iptal etmesi, bir topa ikinci pati olmaması, menzil dışına çıkınca ıskalama, yardım ve yanlış delik ayrımı doğrulandı. Bu sonuçlar gerçek oyuncunun başarısını/süresini ölçmez.

Yanlış delik geri bildirimi artık gerçek ve beklenen sembolü adlandırıyor. Yumi sebep olduysa metin bunu açıkça söylüyor. Kayıp ekranında son hatanın nedeni korunuyor; yeniden başlatmada eski neden temizleniyor. Zorluk, süre, atış veya ses kuralları değiştirilmedi.

interaction_smoke.gd toplu kontrol listesine eklendi; 15 kontrolün tamamı geçti. interaction_preview.gd ile normal/Yumi kaynaklı kayıp ekranları üretildi; daha uzun Yumi metninin sığdığı görsel olarak kontrol edildi. Bu değişiklikler kaynakta ve yerel Git kaydında; mevcut APK, telefon ve GitHub değişmedi. Kullanıcı dosyaları korundu.
