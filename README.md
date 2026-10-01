# Yumi & Şako

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
- Kilit dizisini tamamlayınca bölüm kazanılır.
- Üç hata kilidi sıkıştırır; tek tuşla yeniden denenebilir.

## Prototip bölümleri

1. **Mama Dolabı:** Üç aşamada dörder eşleşme, toplam 12 doğru atış. İlk dört eşleşmede Yumi uyuklar; sonra uyanır ve yavaş, yatay hareketlerle yumak topuna yaklaşır. Son aşama öğrenilen nişan ve havlama kurallarını birleştirir. İlk iki aşama sonunda kasa dönüşüyle hedefler yer değiştirir; atış sırasında sabit kalır. İlk bölümde top daha yavaş, pati uyarısı daha uzundur.
2. **Duvar Oyunu:** Üç aşamada dörder eşleşme, toplam 12 doğru atış. İlk dört hedef en az bir, sonraki dört hedef iki duvar sekmesi ister; bu iki aşamada Yumi uyur. Son dört hedefte Yumi dört yönde dolaşır ve en az bir sekme gerekir. Yan duvarlar geliş açısına göre yansıtır; hız korunur, üçüncü duvar teması atışı bitirir. Nişan çizgisi sekme yolunu gösterir. Havlama, kalan zorunlu sekmeleri koruyarak yön düzeltir. Aşama geçişlerinde hedefler yer değiştirir; uçuşta sabit kalır.
3. **Kayan Kilit:** Yumi sekiz yönde daha sık yön değiştirip kısa atılmalar yapar. Delikler de yatay hareket eder.

Sınırsız pinball sekmesi yoktur. Yalnız ikinci bölümde yan duvarlardan en fazla iki sekme kullanılabilir; ilk ve üçüncü bölümün duvar kuralları değişmedi. Alt taraftan kaçan top atışı bitirir. Oyun puan toplamaya değil, kilidi doğru sırayla çözmeye odaklanır.

İlk bölümde geçen süre ve toplam ilerleme ekranda, tamamlanma süresi sonuç ekranında gösterilir. Yanlış atış önceki doğru eşleşmeleri silmez. Üç hata sınırı bölüm boyunca geçerlidir. Başarıda Şako ve Yumi birlikte mamaya koşar; 2,2 saniyelik kutlama tamamlanma süresine eklenmez. Sonuç ekranında kalan havlamalar ve Yumi'nin yardımları da gösterilir. İlk bölüm için 60–90 saniye bir oyuncu testi hedefidir; yeni sürümün gerçek oynama süresi henüz ölçülmedi. Önceki sürümün kusursuz otomatik testindeki 15,1 saniye bu sürüme ait değildir.

## Çalıştırma

Projeyi Godot 4.7 veya daha yeni bir Godot 4 sürümünde açıp `F6`/`F5` ile çalıştırın.

Komut satırından:

```powershell
& "D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64.exe" --path "D:\Works\kedikopek" --editor
```

## Prototip kapsamı

Sıcak mutfak arka planı ve ahşap dolap görseli artık oyuna yerleştirildi. Krem renkli paneller ve düğmeler, koyu okunabilir yazılar, balık/pati/yumak simgeleri ve belirgin nişan çizgileri aynı görsel dili izler. Delikler ve düğmeler arka planın parçası değildir; oyun tarafından ayrı çizilir ve hareket ettirilir. Karakterler hâlâ basit geçici çizimlerdir; konseptteki profesyonel karakter görünümü ve animasyonları bu sürümde hazır değildir. Android test paketi bağlı ARM64 telefona kuruldu ve ilk açılışı doğrulandı; dokunmatik oynanışın rahatlığı henüz oyuncuyla değerlendirilmedi. Sesler, iOS paketi ve mağaza sürümü hazır değildir. Android deneme yönergeleri `docs/ANDROID_TEST.md`, görsel kaynaklar `docs/ART_DIRECTION.md` içindedir.

## Kontrol testi

Godot konsol sürümüyle `--headless --path "D:\Works\kedikopek" --script res://tests/portrait_smoke.gd` çalıştırılabilir. Test; ilk dört gerçek top uçuşunu, dokunma/sürükleme/bırakmayı, ikinci parmağı, GUI atış ve havlama düğmelerini, hakların tükenmesini, hareketli deliklerin sınırlarını ve başarı/yeniden deneme akışını kontrol eder. Sentetik dokunma testi gerçek cihaz testinin yerine geçmez.

İkinci bölümü doğrudan denemek için Godot çalıştırma komutuna `-- --level=2` eklenebilir. `res://tests/wall_smoke.gd` testi yansıma açısını, hızın korunmasını, sekme sınırını, nişan çizgisini ve 12 gerçek atışlık bölüm akışını doğrular. Otomatik testteki süre gerçek oyuncu süresi değildir.

`res://tests/art_smoke.gd` testi görsellerin yüklenmesini, dolabın alfa kanalını, arayüz sınırlarını ve okunabilir metin renklerini kontrol eder. Görsel QA ayrıca üç bölümün ve sonuç ekranının gerçek Godot çıktılarında yapılır. Yeni bir proje kopyasında önce Godot editörünün görselleri içe aktarması gerekir.
