# 4. bölüm — Yumi'nin yaramazlığı

Sekiz doğru eşleşmeli bölümde, 2. ve 5. başarıdan sonra Yumi hedeflere gider. 0,65 saniyelik ünlem uyarısının ardından pati atar: üç hedef kendi sembollerini koruyarak yatay/dikey hareket eder, sınır duvarlarından ve birbirlerinden seker. Hareket 2,2 saniyede sönümlenir; hedefler yeni yerlerinde kalır. Yumi döndüğünde atış açılır.

Yaramazlık top havadayken başlamaz. Yaklaşma, uyarı, sekme ve dönüş boyunca tüm atış yolları kilitlidir. Bu bölümde oyuncak fare yok: önceki bölümün yeni kuralıyla birleştirilmeden, yeniden nişan alma fikri öğretilir. Önceki üç bölüm korunmuştur.

Hedef merkezleri x=82–458, y=242–412 alanında kalır; aralarında en az 112 piksel korunur. Fizik küçük alt adımlarla ilerler. Nadir bir dizilim başka hedefin atış yolunu kapatırsa hedefler kısa bir yerleşme hareketiyle açık yatay aralıklara ayrılır; yükseklik ve sembol kimliği korunur. Hiçbir hedef ulaşılamaz kalmamalıdır.

4. bölümde top eski sabit hedef çizgisine değil, hedeflerin gerçek konumlarına karşı sürekli çarpışma hesabıyla değerlendirilir. Yanlış sembol hata sayılır; tüm hedefleri geçen top ıskalamadır.

Doğrulama: tests/scatter_smoke.gd, 30/60/144 kare hızında 20'şer rastgele düzen, sınır sekmesi, ayrıklık, açık atış yolu, yeni yükseklikte isabet, iki yaramazlık sınırı, yeniden başlatma ve sekiz atışlık bölüm geçişi. Son geçiş testi topa pati sabotajını ayrı tutar; insan oynanabilirlik testi yerine geçmez. tests/scatter_preview.gd uyarı/sekme/durma ekranlarını üretir.

8 Ekim 2026: Fare ve bu bölüm birlikte 0.1.5-test (kod 6) Android paketine alındı, bağlı telefona yüklendi ve oyun açıldı. Kurulum ve sürüm doğrulandı; fiziksel oynanış denemesi kullanıcı tarafından yapılacak.
