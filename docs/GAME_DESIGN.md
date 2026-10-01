# Yumi & Şako — Prototip Tasarım Özeti

## Temel fikir

Oyuncu bir şifreyi ezberleyip yazmaz. Kilidin gösterdiği sıradaki sembol topunu doğru deliğe göndererek şifreyi fiziksel olarak tamamlar. Yumi'nin topu saptıran patisi, refleks ve zamanlama katmanıdır.

## İlk prototip döngüsü

1. Bölümün kilit dizisi yüklenir; ilk bölüm üç aşamalı, 12 eşleşmelik bir öğreticidir.
2. Sıradaki top Şako'nun fırlatıcısına yüklenir.
3. Oyuncu nişan alır ve topu doğru sembol deliğine yollar.
4. Etkin Yumi orta alanda dolaşır, yumak topunu takip eder; pati uyarısından sonra topu saptırmaya çalışır.
5. Doğru atış diziyi ilerletir. Iska veya yanlış delik bir hata oluşturur.
6. Üç hata kilidi sıkıştırır. Tam dizi kilidi açar.

## İkinci prototip kararı

- Oyun klasik pinball değildir; sürekli sekme ve yüksek puan kovalamaca kullanılmaz. İkinci bölümde yan duvarlardan ikiye kadar bilinçli bilardo tipi yansıma vardır.
- Şako topu doğrudan hedefe fırlatır.
- Oyuncunun bölüm başına üç havlama hakkı vardır; bir atışta en fazla bir kez kullanılabilir. Uçuş sırasında kullanılan havlama topun yönünü düzeltir. Yeni atış hakları doldurmaz; yeniden deneme veya yeni bölüm doldurur.
- Yumi pati atmadan önce kısa ve okunabilir bir uyarı verir. Uyarı sırasında havlamak Yumi'yi irkiltir ve müdahaleyi engeller.
- İlk bölümün ilk dört eşleşmesinde Yumi uyur, sonraki aşamalarda yavaş ve okunabilir biçimde müdahale eder. İkinci bölüm duvar sekmesini öğretir ve son aşamada dört yönlü Yumi hareketiyle birleştirir. Üçüncü bölüm hareketli delikleri tanıtır.
- Yumi'nin hareket karmaşıklığı bölümle artar: önce yatay, sonra dört yönlü, daha sonra çapraz yönler, duraklamalar ve kısa atılmalar.
- Top Yumi'ye temas ettiğinde çarpışma tarafı ve bölüm zorluğuna göre kontrollü-rastgele bir yöne seker. Ortaya çıkan açı doğru deliğe denk gelirse atış geçerli sayılır ve Yumi'nin yanlışlıkla yardım ettiği vurgulanır.

## Korunan tasarım kararları

İlk bölüm üç aşamadan oluşur. Her aşamada dört doğru eşleşme gerekir (toplam 12). Dördüncü ve sekizinci eşleşmelerden sonra hedefler 1,2 saniyelik kasa dönüşüyle yeni yuvalarına geçer; geçiş sırasında atış kapalıdır. Yanlış atış ilerlemeyi silmez; üç hata sınırı tüm bölüm için korunur. Geçen süre ölçülür, süre dolması başarısızlık nedeni değildir. İlk bölümde top hızı 420 piksel/saniye, pati uyarısı 0,42 saniyedir. 60–90 saniye oyuncu testi hedefidir, ölçülmüş sonuç değildir; önceki sürümün 15,1 saniyelik otomatik sonucu yeni sürümü temsil etmez.

## Karakter ve hikâye katmanı

- Kilidin amacı mama dolabını açmaktır; hedef yalnızca sayacı doldurmak değildir.
- Yumi yumak topunu sahiplenir ve takip eder. İlk bölümde yatay hareket sınırı korunur.
- Topa yakınlık uyarıyı atlayarak ani bir pati darbesine dönüşmez; müdahale önce ünlemle bildirilir.
- Yumi'nin saptırdığı top doğru deliğe girerse yardım sayacı artar. Sonuçta Şako şaşırır, Yumi yumağı istediğini söyler.
- Başarıda iki karakter mamaya koşar. 2,2 saniyelik kısa animasyon oyun süresinin dışında tutulur.
- Kısa/uzun havlama ayrımı, ruh hali, güç göstergesi, küçük hedefler ve gizlenen şifre bu sürüme eklenmedi. Önce sınırlı havlamanın dengesi ve ilk bölümün gerçek süresi oyuncu testiyle değerlendirilecek.

- İlk 20–30 bölümde zorunlu süre baskısı yoktur.
- Başarısızlık klasik can sisteminden ziyade kilit dayanıklılığıyla anlatılır.
- Kaybetme ile yeniden deneme arasındaki süre olabildiğince kısadır.
- Yumi'nin sabotajı eğlenceli ve okunabilir olmalıdır; oyuncuya haksız görünmemelidir.

## İkinci bölüm: Duvar Oyunu

- Üç aşama × dört eşleşme: önce en az bir sekme, sonra iki sekme, son aşamada Yumi + en az bir sekme. Düz atış doğru deliğe girse bile sekme koşulunu karşılamazsa hata sayılır; koşul sürekli ekranda gösterilir.
- Yalnız yan duvarlarda yansıma vardır: yatay hızın işareti değişir, dikey hız ve toplam hız korunur. Rastgele sekme açısı yoktur. Bir atışta iki sekme yapılabilir; üçüncü temas hata oluşturur. Alt tarafa kaçış atışı bitirir.
- Topun yarıçapı duvar mesafesine katılır. Çarpışmadan sonra kalan hareket devam eder; düşük kare hızında duvarın içinden geçmemesi ve pati uyarısının zamanlaması için kısa fizik adımları kullanılır.
- İlk iki aşamada Yumi uyur. Son aşamada dört yönlü hareket, yumak takibi ve 0,40 saniyelik pati uyarısı devrededir. Üç havlama hakkı bölüm genelindedir; her atışta en fazla bir kez kullanılır.
- Havlama, hedefi kalan sekme rotasına göre hesaplar; doğrudan deliğe çevirip zorunlu duvar temasını bozmaz. Çizilen yol duvarları hesaba katar; Yumi'nin gelecekteki müdahalesini tahmin etmez.
- Hedefler aşamalar arasında yer değiştirir; uçuşta sabittir. İlk ve üçüncü bölüme yeni duvar sekmesi kuralı eklenmedi.
- Deneme kısayolu: `-- --level=2`. Otomatik test, oyuncu zamanı/zorluk değerlendirmesinin yerine geçmez.

## Sonraki küçük hedefler

- Gerçek Yumi ve Şako karakter görselleri
- Pati, çarpma, kilit ve başarı sesleri
- Gerçek telefonda dokunmatik kontrol testi ve titreşim geri bildirimi
- Sabit öğretici bölüm ve ardından bölüm seçimi
- Güvenli geçit ve bomba topu gibi yeni oyun öğeleri

## Dikey mobil düzen

- Hedef yön: dikey (9:16). Oyun alanı 540 × 960 mantıksal koordinatla çizilir; ekran oranı korunur. Mobil yön ayarı dikeydir, telefonda dağıtım henüz yapılmadı.
- Hedef delikleri üstte, Yumi ortada, Şako altta bulunur. Altta ayrı `AT!` ve `HAV!` düğmeleri, üstte yeniden deneme düğmesi vardır.
- Parmak oyun alanında sürüklenirken nişan değişir; bırakılınca atış yapılır. Uçuş sırasında başlatılan bir dokunma yeni atış başlatmaz. GUI üzerine veya alan dışına bırakılan ve iptal edilen hareketler atış yapmaz.
- Havlama düğmesi son oyun alanı hedefini kullanır; düğmeye dokunmak nişanı düğmenin konumuna kaydırmaz. Dokunmanın taklit fare olayı oyun alanında ikinci kez işlenmez.
- Yumi'nin yatay sınırı 100–440; orta yüksekliği 510'dur. İleri bölümdeki delik salınımı 22 piksele daraltılarak hedefler ekranda tutulur. İlk bölümde delikler uçuş sırasında hâlâ sabittir.
- Seçilen sıcak ev/mutfak görseli çevre ve arayüzün referansıdır. Mutfak arka planı ve ahşap dolap ayrı görsel katmanlar olarak uygulandı; hedefler renkli yuvarlak çerçeve ve ayrı simge rozetleriyle çizilir. Krem paneller ve koyu metinler kullanılır. Mahjong tasarım yönü yoktur. Karakterlerin basit geçici çizimleri korunur; gerçek karakter görselleri ve animasyonları sıradaki aşamadır.

## İlerleyen bölümler: hareketli delikler

- Başlangıç bölümlerinde delikler sabit kalır; oyuncu önce temel nişan ve zamanlamayı öğrenir.
- İlerleyen bölümlerde delikler yatay, dikey veya önceden okunabilen kısa rotalarda hareket edebilir.
- Hareket düzenleri adil ve tahmin edilebilir olmalı; zorluk sürprizden değil doğru anı seçmekten gelmelidir.
- Yumi'nin sabotajı ile hareketli delikler aynı anda devreye girdiğinde hızları dengelenerek oyuncuya tepki süresi bırakılmalıdır.
