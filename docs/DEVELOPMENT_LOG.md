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

1. Temiz yerel 0.1.9-test/kod 10 APK, hazırlama/doğrulama betiği ve fiziksel test listesi tamamlandı. Kullanıcı dönene kadar telefon kurulumu/GitHub gönderimi yok. Aynı paketi sırf devam ediyor görünmek için yeniden üretme. Sonraki öncelik gerçek Android açılış/dokunma/mola/kayıt/ses denemesi; yeni somut hata bulgusu veya kullanıcı geri bildirimi olmadan zorluk ve mekanik değiştirme.
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
- 661a7a2: ses tercihini testten ayırma ve sonuçta eski ses kanallarını kesme (18 test).

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

## Saatlik devam — 12 Ekim 2026, 04:39 Türkiye

Kullanım izinli; yeni kullanıcı yönlendirmesi yok. input_lifecycle_smoke.gd ile dört bölümde gerçek Viewport giriş yolu üzerinden P/Esc/Space/R/E ve dokunma/sürükleme/bırakma olayları sınandı. Mola sonrası eski bırakma, temiz yeni sürükleme, yeniden başlatma, tuş tekrarları, tek havlama sınırı ve fare seçimi/yerleştirme/süre korunması geçti. Yeni oyun hatası bulunmadı; davranış değişmeden regresyon güvencesi eklendi.

19 toplu kontrol geçti. Mola önizlemesi yeniden üretildi ve okunabilir düğmeler/durum metni görsel olarak kontrol edildi. Telefon/APK/GitHub ve kullanıcı dosyaları değişmedi. Fiziksel Android mola/dokunma denemesi hâlâ kullanıcı döndüğünde yapılmalı.

## Saatlik devam — 12 Ekim 2026, 05:38 Türkiye

Kullanım izinli; kredi/sıfırlama kullanılmadı, yeni kullanıcı yönlendirmesi yoktu. Mevcut APK'nin 132 ZIP girdisi salt okunur incelendi. sleep.jpg, Generated Image JPG ve eski yumi-sleep-v1.png toplam altı import/doku girdisiyle pakette; güncel oyun bunları kullanmıyor. Excel ve test/belge/çıktı yolları girdiler arasında bulunmadı. Özel dosya içerikleri açılmadı. all_resources seçimi ve dar dışlama filtresi kaynakları gereksiz dahil ediyor; Git'te izlenmemek paket dışında kalma güvencesi değil.

tests/audit_apk.ps1 salt okunur dağıtım kontrolü eklendi: bilinen referanslar, kişisel tablo uzantıları ve test/belge yolları varsa paket reddedilir; bilinmeyen ZIP/PCK düzeninde temiz diye onay verilmez. Eski APK'da altı girdinin listelenmesi ve varsayılan kontrolün paketi reddetmesi doğrulandı. SHA256 önce/sonra aynı; APK değiştirilmedi. Tam gizlilik taraması veya oynanabilirlik testi değildir.

Bu dilimde oyun/export ayarı değiştirilmedi, yeni APK üretilmedi. 19 oyun testi tekrar çalıştırılmadı, yeni ekran olmadığından görsel test yapılmadı. Telefon/GitHub ve kullanıcı dosyaları korundu. Sonraki iş temiz export kapsamı ve ayrı yerel APK doğrulaması; eski paket yeni paylaşımlar için önerilmiyor.

## Saatlik devam — 12 Ekim 2026, 06:35 Türkiye

Kullanım izinli; kredi/sıfırlama kullanılmadı, yeni kullanıcı yönlendirmesi yok. Kaynak kullanıcı görselleri ve tabloları silmeden export filtresi daraltıldı. İlk seçili-sahne denemesi preload görsellerini/betiklerini eksik bıraktı; paket kontrolü reddetti. all_resources geri korunup açık dışlamalarla yeni 0.1.9-test/kod 10 APK farklı adla üretildi; mevcut 0.1.8 APK aynı SHA256 ile korundu.

Yeni APK 128 ZIP girdisiyle geçti: yasak referanslar/tablo/test/çıktı yolları yok, üç oyun betiği ve yedi gerekli doku var. APK imzalama doğrulaması tamamlandı; sürüm/package/arm64 manifestten okundu. Audit koruması gerekli kaynak kontrolleriyle genişletildi. Aynı ayarlı PCK kaynak projesinden ayrı açıldı; dört bölüm, mola ve menü üretildi, ilk bölüm/mola/menü görsel olarak kontrol edildi. 19 oyun testi geçti. PCK masaüstü kontrolü Android APK çalıştırma iddiası değildir.

Yeni dosya exports/android/yumi-sako-0.1.9-test.apk; boyut/hash PACKAGING_AUDIT.md içinde. Telefon/GitHub değişmedi. Godot'un bu taramada ürettiği oyun/test .gd.uid yan dosyaları yerel kaynak kaydına dahil edildi; kullanıcı dosyaları korunuyor. Fiziksel Android denemesi hâlâ kullanıcı dönünce yapılmalı.

## Saatlik devam — 12 Ekim 2026, 07:39 Türkiye

Kullanım izinli; pencere kendiliğinden yenilenmiş, sıfırlama/kredi kullanılmadı. Yeni kullanıcı yönlendirmesi yok. tests/prepare_android.ps1 eklendi: varsayılan salt okunur APK içerik/manifest/imza kontrolü; açık -Build seçeneğiyle 19 oyun testi sonrası yeni bir dosyaya yerel export. Mevcut APK üstüne yazma ve exports/android dışına hedef seçme reddedildiği test edildi. Hatalı/kısmi paket onaylı sayılmaz; betik kurulum, upload, uygulama silme veya preset değişikliği yapmaz.

Akış exports/android/yumi-sako-0.1.9-rebuild-check.apk adlı ayrı test çıktısıyla uçtan uca sınandı: 19 oyun testi, export, 128 girdi/üç betik/yedi doku ve sürüm/kod/ARM64 kontrolleri geçti. İlk ayrı apksigner.bat denemesi terminal Java ortamı bulunmadığından çalışamadı; Godot'un mevcut Android Studio jbr/java.exe yolu kullanılarak imza doğrulaması geçti, global/oturum JAVA_HOME/PATH değiştirilmedi. Aynı doğrudan Java çağrısı hazırlama betiğine eklendi; hem asıl 0.1.9 hem rebuild paketi son betikle doğrulandı. Bu yeniden üretilebilir işlem adımıdır, bit düzeyinde deterministik build iddiası değildir.

Asıl 0.1.9 APK SHA256 83F180E6B9D669B05A8FE6033CF5448D4E545BA04B4D72831E340765BFD05E40 ve eski APK SHA256 DF9E65EC90830F4026AFC984A2D2C12E155908DD9D46E4C5599F5CEF0920BFC5 aynı kaldı. Rebuild deneme çıktısı ayrı tutuldu, yeni önerilen telefon paketi hâlâ yumi-sako-0.1.9-test.apk.

ANDROID_TEST.md içindeki eskimiş güncel sürüm/yeniden üretme notları düzeltildi; beş öncelikli fiziksel kontrol ve raporlama bilgileri eklendi. Önceki paket PCK'sinin dördüncü bölüm ekranı görsel olarak kontrol edildi; yeni oyun/görsel davranış olmadığından tekrar ekran üretimi yapılmadı. package_preview.gd.uid Godot tarafından üretilip yerel kayda dahil edildi. Telefon/GitHub ve kullanıcı dosyaları değişmedi. Yerel hazırlık tamamlandı; cihaz ergonomisi ve gerçek yaşam döngüsü hâlâ kullanıcı denemesi bekliyor.

## Kullanıcı döndü — 12 Ekim 2026, telefon güncellemesi

Kullanıcı telefon bağlı ardından açık başla dedi; önceki bağımsız çalışma yerine telefon yükleme isteği uygulandı. Tek yetkili bağlı Samsung SM-S938B seçildi. Asıl 0.1.9-test APK içerik/manifest/imza kontrolünden tekrar geçti, install -r Success döndü. Önceki kod 9/sürüm 0.1.8, güncellemeden sonra kod 10/sürüm 0.1.9 doğrulandı. Uninstall/clear yapılmadı; kayıtların içerikleri okunmadı veya tek tek doğrulanmadı.

Başlatma isteği Status ok, oyun süreci mevcut. Sürece ait incelenen başlangıç loglarında script/fatal/kaynak yükleme hatası görülmedi. Telefon KeyguardShowing=true/AodShowing=true olduğundan gerçek render/oynanış doğrulanmadı; ekran kilidi değiştirilmedi, kullanıcıya kilidi açıp denemesi söylendi. Sonraki adım kullanıcı denemesi/geri bildirimi; kullanıcı dönmüş olduğundan yeni bağımsız geliştirmeye otomatik devam etme. GitHub gönderimi yok, kaynak kullanıcı dosyaları korunuyor.

## Kullanıcı isteği — 12 Ekim 2026, delik derinliği ve düşme

Kullanıcı deliklere biraz derinlik/düşme efekti istedi ve başla dedi. Kod tabanlı çizimde iç boşluk yedi gölge katmanıyla derinleştirildi; mevcut kenar ışığı/ön dudak korunuyor. Doğru veya yanlış deliğe giren top 0,32 saniyede iç merkeze çekilip küçülüyor, hafif dönüyor ve kararıyor. Efekt hedefin güncel çizim merkezini izler; ön dudak efektin önünde çizilir. Yeni raster varlık veya kurulum yok.

Puanlama anı, çarpışma yarıçapı 48, hedef konumları, bölüm kuralları ve mevcut 0,45/0,55 saniyelik atış aralıkları değişmedi. Mola efekti dondurur; son doğru atış kutlamayla birlikte tamamlanır. Menü/yeni bölüm eski efekti temizler, ıskalama düşme üretmez. Yanlış delikte hata puanı normal işlenir; efekt ceza beklemesi eklemez.

Mevcut 19 oyun testi ve yeni hole_drop_smoke.gd geçti (20 toplam; yeni kontrol çalıştırıcıya eklendi). Yeni test doğru/yanlış/son giriş, puan/atış aralığı/yarıçap korunması, mola/devam, menü/yeniden başlatma ve ıskalamayı doğruluyor. hole_drop_preview.gd ile derinlik ve üç düşme anı üretildi; normal görünüm ile ilk/orta düşme kareleri görsel olarak kontrol edildi. Kullanıcı dosyaları, APK'lar, telefon ve GitHub değişmedi. Bu değişiklik yerel kaynakta; kullanıcı telefon güncellemesi isterse yeni sürüm kodlu APK hazırlanmalı.

## Kullanıcı isteği — 12 Ekim 2026, düşme efektini telefona yükleme

Kullanıcı telefon bağlı ardından başla dedi. Sürüm 0.1.10-test/kod 11 olarak artırıldı, yeni dosya exports/android/yumi-sako-0.1.10-test.apk üretildi; eski APK'lar üstüne yazılmadı. Hazırlama akışında 20 toplu oyun testi, 128 ZIP girdisi/üç betik/yedi doku, manifest ve imza kontrolü geçti. APK SHA256 E20B121D74B9653B7BFCB7AA5168B4E27F000A5104B87924AE307AE664C212DC.

Tek yetkili bağlı Samsung SM-S938B'ye açık seri hedefiyle install -r Success döndü. Öncesinde 0.1.9/kod 10, sonrasında 0.1.10/kod 11 doğrulandı. Başlatma Status ok/LaunchState COLD, süreç ve Godot Engine başlangıcı mevcut. İncelenen sürece ait kayıtlarda script/fatal/kaynak yükleme hatası görülmedi. Uninstall/clear veya kullanıcı profili okuma yapılmadı; veri koruyan güncelleme yolu kullanıldı ama kayıt içeriği tek tek doğrulanmadı. Kullanıcı gerçek düşme hissini deneyecek. GitHub ve ilişkisiz kullanıcı dosyaları değişmedi.

## Kullanıcı video referansı — 12 Ekim 2026

Kullanıcı Mobile_game_ball_falling_hole_20261012091913.mp4 referansındaki düşüşü inceleyip kaybolma hissini düzeltmemizi istedi ve başla dedi. Video değiştirilmedi; Windows MediaPlayer/DrawVideo üzerinden 4 saniyelik 1280x720 videodan 16 yaklaşık zamanlı kare salt okunur çözülerek exports/video-reference içine alındı. Yeni yazılım kurulmadı. Windows PowerShell script ilk çağrıda mevcut yürütme politikası yüzünden açılmadı; politika değiştirilmeden mevcut pwsh STA ile çalıştı. Örnekleme tam kare hassasiyetli zaman ölçümü değildir. İncelenen karelerde top boyutunu koruyarak aşağı düşüyor, ön kenar topun altını örtüyor; önceki efektteki %94 küçülme/%95 kararma bu mekânsal hareketi göstermiyordu.

Yerel düşme 0,44 saniyeye çıkarıldı: ilk girişte merkeze yerleşme, ardından hızlanan 86 piksel aşağı hareket, yalnız %16 küçülme ve en fazla hafif %22 kararma. Küre katmanları ön açıklık sınırında kesiliyor; alt bölüm fiziksel kenarın arkasına giriyor. Puanlama, mevcut 0,45 saniyelik atış aralığı, hedef/çarpışma alanı korunuyor. ball_drop_pose yordamıyla görünümün hareketi test edilebilir hale getirildi.

20 toplu oyun testi geçti. Düşme testi topun büyük kalmasını, aşağı hareketini ve sonunda ön kenarın tamamen altında kalmasını da doğruluyor. Yeni önizlemede giriş/orta/örtülme kareleri görsel olarak incelendi. Kaynak video, kullanıcı dosyaları, APK'lar, telefon ve GitHub değişmedi; telefonda hâlâ eski efektli 0.1.10 sürümü var. Kullanıcı telefon güncellemesi isterse yeni sürüm koduyla paketle. Video çözümleme yardımcı betiği tests/extract_video_reference.ps1 yerel kaynak kaydına alındı, APK dışlama kapsamındadır.

## Kullanıcı isteği — 12 Ekim 2026, video referanslı efekti telefona yükleme

Kullanıcı telefon bağlı başla dedi. Yeni 0.1.11-test/kod 12 APK ayrı dosyada üretildi; 20 toplu oyun testi, paket içerik/manifest/imza kontrolleri geçti. SHA256 BB06F6B7EF0B89DA6F3783E3FD794C6CE1EC3298CD7D65B7A734445D1E207319. Mevcut 0.1.10/kod 11 üzerine seri hedefli install -r Success döndü; telefonda 0.1.11/kod 12 doğrulandı. Uygulama kaldırılmadı, veri temizlenmedi; gerçek profil içeriği ayrıca okunmadı.

Başlatma Status ok ve oyun süreci mevcut, incelenen başlangıç loglarında script/fatal/kaynak yükleme hatası görülmedi. Ancak bu denemede Godot Engine render başlangıcı satırı yok ve kilit policy showing=true; gerçek görüntü/oynanış doğrulandı diye sunulmadı. Kullanıcı kilidi açıp yeni düşüşü deneyecek. Eski APK'lar, kullanıcı dosyaları ve GitHub korundu. En yeni paket exports/android/yumi-sako-0.1.11-test.apk.

## Kullanıcı isteği — 12 Ekim 2026, dördüncü bölüm bekleme mesajları

Kullanıcı video referanslı düşüşü daha iyi olarak onayladı. Ardından dördüncü bölüm karışması sonrası girişin çalışmadığını bildirdi; kaynak teşhisinde karışma/dönüş testleri geçti, Yumi dönüşü ve geçiş sırasında başlayan dokunuşun geçersiz kalması açıklandı. Kullanıcı sorunun çözüldüğünü söyledi; kalıcı kilitlenme doğrulanmış bir hata olarak kaydedilmedi. Bekleme mesajını netleştirme önerisinden sonra başla dedi.

Karışma fiziği ve giriş kuralları değişmeden durum mesajları ayrıldı. Hedefler durunca durum satırı Yumi geri dönüyor der; dönüş/kısa 0,25 saniye hazırlık sırasında kapalı atış hazır gibi sunulmaz. Gerçek can_launch_ball izni açıldığında sağ kutu yeşil ATIŞ HAZIR / Sürükle, bırak gösterir. Normal uçuşta havlama bilgisi korunur. Dar sağ kutuda dönüş başlığı YUMI DÖNÜYOR olarak kısaltıldı.

20 toplu oyun testi geçti; scatter_smoke.gd içine dönüş/kısa hazırlık/hazır mesajı ile düğme durumu uyumu ve dönüş sonrası yeni dokunmayla nişan/atış kontrolleri eklendi. Son metin kısaltmasından sonra scatter testi tekrar sınandı. scatter_preview.gd dönüş ve hazır kareleriyle genişletildi, metin ve etkin düğme görsel olarak kontrol edildi. Telefon, APK'lar, GitHub ve kullanıcı dosyaları değişmedi; yeni mesajlar yalnız kaynakta. Kullanıcı yeni telefon güncellemesi isterse sürüm kodunu artırarak paketle.
