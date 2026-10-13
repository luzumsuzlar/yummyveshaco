# Yumi & Şako

Yazılımcıya devir için ilk beş bölümün Türkçe uygulama senaryosu: [FIVE_LEVEL_GAME_SCENARIO_TR.md](docs/FIVE_LEVEL_GAME_SCENARIO_TR.md). Mevcut davranışı, durum geçişlerini ve tasarım değerlendirmesini ayrı tanımlar.

Godot 4 ile geliştirilen hızlı, neşeli bir refleks-bulmaca oyununun ilk oynanabilir prototipi.

## Oynanış

Şako'nun fırlatıcısını yönlendirerek sıradaki sembol topunu aynı sembolü taşıyan deliğe gönder ve mama dolabını aç. Bölüm başına üç havlama hakkın var; aynı atışta yalnızca birini kullanabilirsin. Havlama topun yönünü düzeltir ve pati uyarısı sırasında Yumi'yi irkiltir. Yumi yumak topunu sahiplenip takip eder; patisi topu kontrollü-rastgele bir açıyla saptırır. Şanslı bir sekme doğru deliğe girerse Yumi'nin yardımı olarak sayılır.

- Dikey düzen: 540 × 960 (9:16). Masaüstünde 432 × 768 pencereyle açılır; farklı ekranlarda oranı korunur.
- Dokunmatik nişan/atış: dokununca nişan yerinde kalır; parmağını sağa–sola sürükleyerek mevcut açıyı değiştir, bırakınca at. Dikey sürükleme nişanı değiştirmez. İkinci parmak ve iptal edilen hareket atış yapmaz.
- Alternatif atış: nişan aldıktan sonra alttaki `AT!` düğmesi.
- Havlama: top uçarken `HAV!` düğmesi. Düğme son nişan/hedef konumunu kullanır; kendi ekran konumuna topu çekmez.
- Bilgisayarda nişan: fare veya `A` / `D` / `←` / `→`. Atış: sol tık, `Boşluk` veya `Enter`.
- Bilgisayarda havlama: top uçarken oyun alanına tekrar tık, `Boşluk` veya `E`.
- Yeniden başlatma: sağ üstteki `↻` düğmesi veya `R`.
- Bölüm seçimi: açılış menüsü ve sol üst `≡` düğmesi; tüm bölümler test için açık.
- Mola: `II` düğmesi, `P` veya `Esc`. Telefonda arka plana geçiş mola verir; hazır olduğunda devam et. Mola süresi sonuca eklenmez.
- Ses: menü/oyundaki `SES: AÇIK/KAPALI` düğmesi. Ses tercihi saklanır; uyuyan Yumi aralıklı mırlar.
- İlk atış, Yumi'nin uyanması ve fare yerleştirmesi sırasında kısa öğretici ipuçları gösterilir.
- Kilit dizisini tamamlayınca bölüm kazanılır.
- Üç hata kilidi sıkıştırır; tek tuşla yeniden denenebilir.

## Prototip bölümleri

1. **Mama Dolabı:** Üç aşamada dörder eşleşme, toplam 12 doğru atış. İlk dört eşleşmede Yumi uyuklar; sonra uyanır ve yavaş, yatay hareketlerle yumak topuna yaklaşır. Son aşama öğrenilen nişan ve havlama kurallarını birleştirir. İlk iki aşama sonunda kasa dönüşüyle hedefler yer değiştirir; atış sırasında sabit kalır. İlk bölümde top daha yavaş, pati uyarısı daha uzundur.
2. **Duvar Oyunu:** Üç aşamada dörder eşleşme, toplam 12 doğru atış. İlk dört hedef en az bir, sonraki dört hedef iki duvar sekmesi ister; bu iki aşamada Yumi uyur. Son dört hedefte Yumi dört yönde dolaşır ve en az bir sekme gerekir. Yan duvarlar geliş açısına göre yansıtır; hız korunur, üçüncü duvar teması atışı bitirir. Nişan çizgisi sekme yolunu gösterir. Havlama, kalan zorunlu sekmeleri koruyarak yön düzeltir. Aşama geçişlerinde hedefler yer değiştirir; uçuşta sabit kalır.
3. **Kayan Kilit:** Yumi sekiz yönde daha sık yön değiştirip kısa atılmalar yapar. Delikler de yatay hareket eder. İki oyuncak fare hakkıyla mor alanda yer seçip Yumi'yi kısa süre oyalayabilirsin.
4. **Yumi'nin Yaramazlığı:** Sekiz doğru eşleşme. 2. ve 5. başarıdan sonra Yumi hedeflere gider, ünlemle uyarıp pati atar. Hedefler duvarlardan/birbirlerinden sekip farklı yerlerde durur. Karışma sırasında atış kapalıdır; sembol kimlikleri korunur. Yerleşmiş her hedef için açık atış yolu kontrol edilir.
5. **Gizli Şifre (prototip):** Sekiz eşleşme. Sıradaki sembol atış hazır olduktan sonra 2,5 saniye görünür; Yumi kapatınca hatırladığın deliği hedefle. Bekleyen top da gizlenir, uçuşta normal görünür. Başarıda yeni sembol, hatada aynı sembol yeniden gösterilir. Mola süreyi dondurur. Sabit delikler ve müdahale etmeyen Yumi, yeni hafıza kuralını tek başına tanıtır. 0.1.13 ile telefona yüklendi; kullanıcı gizlendikten sonra attığını, buna rağmen belirgin deneyim farkı hissetmediğini söyledi. Mekanik çalışıyor, tasarım etkisi yeniden değerlendirme adayıdır.

Sınırsız pinball sekmesi yoktur. Yalnız ikinci bölümde yan duvarlardan en fazla iki sekme kullanılabilir; ilk ve üçüncü bölümün duvar kuralları değişmedi. Alt taraftan kaçan top atışı bitirir. Oyun puan toplamaya değil, kilidi doğru sırayla çözmeye odaklanır.

İlk bölümde geçen süre ve toplam ilerleme ekranda, tamamlanma süresi sonuç ekranında gösterilir. Yanlış atış önceki doğru eşleşmeleri silmez. Üç hata sınırı bölüm boyunca geçerlidir. Başarıda Şako ve Yumi birlikte mamaya koşar; 2,2 saniyelik kutlama tamamlanma süresine eklenmez. Sonuç ekranında kalan havlamalar ve Yumi'nin yardımları da gösterilir. İlk bölüm için 60–90 saniye bir oyuncu testi hedefidir; yeni sürümün gerçek oynama süresi henüz ölçülmedi. Önceki sürümün kusursuz otomatik testindeki 15,1 saniye bu sürüme ait değildir.

## Çalıştırma

Projeyi Godot 4.7 veya daha yeni bir Godot 4 sürümünde açıp `F6`/`F5` ile çalıştırın.

Komut satırından:

```powershell
& "D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64.exe" --path "D:\Works\kedikopek" --editor
```

## Prototip kapsamı

Sıcak mutfak, ahşap dolap, krem paneller ve ayrı hedef simgeleri kullanılır. Temas gölgeleri sığ derinlik verir. Yumi'nin normal, kıvrılmış uyku ve pati pozları ile Şako'nun temel görseli oyuna bağlıdır. Yürüyüş altı kareden oluşur; sola aynalanır, dikey/çapraz yönlere özel kareler henüz yoktur. Pati hazırlığı, gövde hamlesi ve temas efekti çizim katmanındadır. Atış, sekme, pati, kilit açma ve mırlama sesleri vardır; müzik ve gerçek hayvan kaydı yoktur.

Tamamlanan bölümler ve en iyi süreler yerel kaydedilir; yıldız/kilit sistemi yoktur. Henüz yarım denemeyi uygulama tamamen kapandıktan sonra sürdürme yoktur. Telefonda son yüklenen sürüm 0.1.15-test (kod 16), beş bölümlüdür; Yumi temizlenmesi, Şako tepkileri, fareyle pati oyunu ve ortak kutlama bu pakettedir. Kullanıcı 0.1.14'te karakter hareketlerini olumlu değerlendirdi; 0.1.15 için henüz oyuncu geri bildirimi gelmedi. Sonraki pati parıltısı/delik titreşimi mola düzeltmesi ve fare seçiminin temizlenmeyi anında kesmesi yalnız kaynakta; mevcut APK bu değişiklikleri içermez. Mırlamanın duyulduğuna ilişkin önceki kullanıcı onayı 0.1.8 sürümüne aittir. Android yönergeleri `docs/ANDROID_TEST.md`, görsel kaynaklar `docs/ART_DIRECTION.md` ve `docs/CHARACTER_ART.md` içindedir. Bağımsız geliştirme günlüğü: `docs/DEVELOPMENT_LOG.md`.

## Kontrol testi

İlerleme planı `docs/ROADMAP.md`, gerçek deneme kayıt şablonu `docs/PLAYTEST_NOTES.md` içinde. Tempo/zorluk ve beşinci bölüm için gerçek oyuncu verisi beklenir.

4. bölümün Yumi dönüşü, kısa hazırlık ve gerçekten hazır atış mesajları 0.1.12-test/kod 13 ile telefona yüklendi. Bekleme süreleri değişmedi. Gerçek cihaz deneme listesi henüz tamamlanmış sayılmaz.

Deliklerin içi katmanlı gölgeyle derinleştirildi. Kullanıcının video referansına göre top 0,44 saniyede boyutunu büyük ölçüde koruyup aşağı düşüyor ve ön kenarın arkasında alttan başlayarak örtülüyor. Bu efekt 0.1.11-test/kod 12 ile telefona yüklendi; gerçek görünüm değerlendirmesi kullanıcı denemesini bekliyor. Hedef yarıçapı, puanlama ve atış aralıkları değişmedi.

Yerel paket hazırlama: `& .\tests\prepare_android.ps1` mevcut APK'yı değiştirmeden içerik/sürüm/mimari/imza kontrolü yapar; APK'nın güncel kaynakla birebir aynı olduğunu kanıtlamaz. `-Build -ApkPath 'exports/android/yeni-dosya.apk'` 25 oyun testinden sonra yeni bir dosyaya paket üretir ve kontrol eder; mevcut APK üstüne yazmaz, telefona kurmaz. Farklı kaynak için önce sürüm kodu/adını artırın. Fiziksel cihaz kontrolü ayrı adımdır.

Son telefon APK'sı: `exports/android/yumi-sako-0.1.15-test.apk` (kod 16). 13 Ekim'de kullanıcı yönlendirmesiyle mevcut uygulama kaldırılmadan telefona güncellendi; başlatma isteği başarılı ve sürüm doğrulandı. Eski APK'lar korunuyor; `yumi-sako-test.apk` kullanılmayan referans görselleri içerdiğinden yeni paylaşımlarda kullanılmamalı.

APK paylaşım kontrolü: `& .\tests\audit_apk.ps1 -ApkPath 'exports/android/yumi-sako-0.1.15-test.apk'`. Varsayılan Current kümesi dokuz dokuyu gerektirir; eski 0.1.13 yalnız `-ResourceSet Legacy013` ile tarihsel olarak incelenir. Yeni üretim Legacy013 kabul etmez. İlk eski paket yasak referanslar nedeniyle reddedilir. İnceleme ve sınırlar `docs/PACKAGING_AUDIT.md` içinde. Bu kontrol aşağıdaki 25 oyun testinden ayrıdır.

Tüm 25 otomatik kontrol: PowerShell'de `& .\tests\run_checks.ps1`. Başka Godot konumu için `-GodotPath` parametresi kullanılabilir. Bu testler gerçek oyuncu ilerleme ve ses tercihlerini okumaz/yazmaz; kayıt testleri yalnız açıkça seçilmiş test dosyalarına yazabilir. Fiziksel telefon testinin yerine geçmez. Kayıt sistemi bölüm sayısını LEVELS listesinden alır. Menü dört kartlık sayfaları destekler. Yerel kaynak ve 0.1.15 APK beş bölüm içerir. Hafıza uçuş testi otomatik nişan kullanır, insanın hatırlama başarısını ölçmez.

Beş bölümlük ec5f8e2 kaynağı ayrıca masaüstü PCK içinden kaynak klasörüne dönmeden açılarak kontrol edildi. Sonuç ve sınırlar `docs/PACKAGING_AUDIT.md` içinde. PCK Android APK değildir; telefon kurulumu ayrı 0.1.13 APK ile yapıldı.

Yanlış deliğe girince gerçek ve beklenen sembol belirtilir; kayıp ekranı son hatanın nedenini korur. `res://tests/interaction_smoke.gd` hareketli hedefe tahminli gerçek atışları, Yumi'nin önceden uyarı vermesini, tek atışta bir pati sınırını, havlamayla iptali ve yardım/hata ayrımını kontrol eder.

Godot konsol sürümüyle `--headless --path "D:\Works\kedikopek" --script res://tests/portrait_smoke.gd` çalıştırılabilir. Test; ilk dört gerçek top uçuşunu, dokunma/sürükleme/bırakmayı, ikinci parmağı, GUI atış ve havlama düğmelerini, hakların tükenmesini, hareketli deliklerin sınırlarını ve başarı/yeniden deneme akışını kontrol eder. Sentetik dokunma testi gerçek cihaz testinin yerine geçmez.

İkinci bölümü doğrudan denemek için Godot çalıştırma komutuna `-- --level=2` eklenebilir. `res://tests/wall_smoke.gd` testi yansıma açısını, hızın korunmasını, sekme sınırını, nişan çizgisini ve 12 gerçek atışlık bölüm akışını doğrular. Otomatik testteki süre gerçek oyuncu süresi değildir.

`res://tests/art_smoke.gd` testi görsellerin yüklenmesini, dolabın alfa kanalını, arayüz sınırlarını ve okunabilir metin renklerini kontrol eder. Görsel QA ayrıca üç bölümün ve sonuç ekranının gerçek Godot çıktılarında yapılır. Yeni bir proje kopyasında önce Godot editörünün görselleri içe aktarması gerekir.
