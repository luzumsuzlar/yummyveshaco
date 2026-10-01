# Yumi & Şako — Prototip Tasarım Özeti

## Temel fikir

Oyuncu bir şifreyi ezberleyip yazmaz. Kilidin gösterdiği sıradaki sembol topunu doğru deliğe göndererek şifreyi fiziksel olarak tamamlar. Yumi'nin topu saptıran patisi, refleks ve zamanlama katmanıdır.

## İlk prototip döngüsü

1. Beş sembollük rastgele bir kilit dizisi üretilir.
2. Sıradaki top Şako'nun fırlatıcısına yüklenir.
3. Oyuncu nişan alır ve topu doğru sembol deliğine yollar.
4. Yumi orta alanda dolaşır; temas ettiği topu yana savurur.
5. Doğru atış diziyi ilerletir. Iska veya yanlış delik bir hata oluşturur.
6. Üç hata kilidi sıkıştırır. Tam dizi kilidi açar.

## İkinci prototip kararı

- Oyun klasik pinball değildir; duvarlardan sürekli sekme ve yüksek puan kovalamaca döngüsü kullanılmaz.
- Şako topu doğrudan hedefe fırlatır.
- Oyuncunun her atışta tek bir havlama hakkı vardır. Uçuş sırasında kullanılan havlama topun yönünü düzeltir.
- Yumi pati atmadan önce kısa ve okunabilir bir uyarı verir. Uyarı sırasında havlamak Yumi'yi irkiltir ve müdahaleyi engeller.
- İlk bölüm sabit hedeflerle öğretir, ikinci bölüm Yumi'yi etkinleştirir, üçüncü bölüm hareketli delikleri tanıtır.
- Yumi'nin hareket karmaşıklığı bölümle artar: önce yatay, sonra dört yönlü, daha sonra çapraz yönler, duraklamalar ve kısa atılmalar.
- Top Yumi'ye temas ettiğinde çarpışma tarafı ve bölüm zorluğuna göre kontrollü-rastgele bir yöne seker. Ortaya çıkan açı doğru deliğe denk gelirse atış geçerli sayılır ve Yumi'nin yanlışlıkla yardım ettiği vurgulanır.

## Korunan tasarım kararları

İlk bölüm artık üç aşamadan oluşur. Her aşamada dört doğru eşleşme gerekir (toplam 12). Dördüncü ve sekizinci eşleşmelerden sonra hedefler 1,2 saniyelik kasa dönüşüyle yeni yuvalarına geçer; geçiş sırasında atış kapalıdır. Yanlış atış ilerlemeyi silmez; üç hata sınırı tüm bölüm için korunur. Geçen süre ölçülür, süre dolması başarısızlık nedeni değildir. Kusursuz otomatik test süresi 15,1 saniyedir; 45–60 saniyelik oyuncu süresi henüz doğrulanmamıştır.

- İlk 20–30 bölümde zorunlu süre baskısı yoktur.
- Başarısızlık klasik can sisteminden ziyade kilit dayanıklılığıyla anlatılır.
- Kaybetme ile yeniden deneme arasındaki süre olabildiğince kısadır.
- Yumi'nin sabotajı eğlenceli ve okunabilir olmalıdır; oyuncuya haksız görünmemelidir.

## Sonraki küçük hedefler

- Gerçek Yumi ve Şako karakter görselleri
- Pati, çarpma, kilit ve başarı sesleri
- Dokunmatik nişan ve titreşim geri bildirimi
- Sabit öğretici bölüm ve ardından bölüm seçimi
- Güvenli geçit ve bomba topu gibi yeni oyun öğeleri

## İlerleyen bölümler: hareketli delikler

- Başlangıç bölümlerinde delikler sabit kalır; oyuncu önce temel nişan ve zamanlamayı öğrenir.
- İlerleyen bölümlerde delikler yatay, dikey veya önceden okunabilen kısa rotalarda hareket edebilir.
- Hareket düzenleri adil ve tahmin edilebilir olmalı; zorluk sürprizden değil doğru anı seçmekten gelmelidir.
- Yumi'nin sabotajı ile hareketli delikler aynı anda devreye girdiğinde hızları dengelenerek oyuncuya tepki süresi bırakılmalıdır.
