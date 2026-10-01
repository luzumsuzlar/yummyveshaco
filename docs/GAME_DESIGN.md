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

- Oyun klasik pinball değildir; duvarlardan sürekli sekme ve yüksek puan kovalamaca döngüsü kullanılmaz.
- Şako topu doğrudan hedefe fırlatır.
- Oyuncunun bölüm başına üç havlama hakkı vardır; bir atışta en fazla bir kez kullanılabilir. Uçuş sırasında kullanılan havlama topun yönünü düzeltir. Yeni atış hakları doldurmaz; yeniden deneme veya yeni bölüm doldurur.
- Yumi pati atmadan önce kısa ve okunabilir bir uyarı verir. Uyarı sırasında havlamak Yumi'yi irkiltir ve müdahaleyi engeller.
- İlk bölümün ilk dört eşleşmesinde Yumi uyur, sonraki aşamalarda yavaş ve okunabilir biçimde müdahale eder. İkinci bölüm dört yönlü Yumi hareketini, üçüncü bölüm hareketli delikleri tanıtır.
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
