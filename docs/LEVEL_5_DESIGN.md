# 5 · Yumi'nin gizli şifresi — yerel prototip

Tek yeni kural: sıradaki sembol atış hazır olduktan sonra 2,5 saniye görünür, ardından Yumi kapatır. Oyuncu aynı nişan/sürükle-bırak kontrolüyle hatırladığı deliği hedefler. Doğru atışta yeni sembol, yanlış/ıskalamada aynı sembol yeniden gösterilir. Üç hata kuralı değişmez. Mola sayacı dondurur; menüye dönüş ve yeniden başlatma temiz bir deneme açar.

Delikler sabit; tek normal top; duvar sekmesi şartı, delik karıştırma, yeni top türü ve oyuncak fare yok. Yumi bu bölümde topa müdahale etmez: yeni hafıza kuralını tek başına öğrenmek için. İlk dört bölümün değerleri değişmez. Sekiz doğru atışlık sıra yalnız prototip başlangıcıdır, gerçek oyuncu süre dengesi iddiası değildir.

Şifre yalnız küçük kutuda gizlenirse topun rengi ve üst sıra cevabı ele verir. Bu nedenle bekleyen top nötr ve soru işaretli, gelecekteki semboller kapalı, tüm metinler aynı görünürlük kuralını kullanır. Atıştan sonra uçan top normal görünür; karar verildikten sonra geri bildirim gizlenmez. Gizlemek atış düğmesini kapatmaz, zaman baskısıyla zorunlu atış yoktur.

Doğrulama: görünür/gizli ekran, cevabı ele veren yazı/top, mola, hata sonrası tekrar gösterme, yeni hedef, sekiz gerçek uçuş, kayıt ve beşinci karttan giriş/sonuç dönüşü. Otomatik uçuşlar insanın hatırlama başarısını veya telefon ergonomisini ölçmez. Kullanıcı denemeden süreyi/zorluğu nihai kabul etme.

12 Ekim kaynak kontrolleri: gizlenme sınırında viewport üzerinden sürükle/bırak 30/60/144 FPS, ikinci parmak, iptal/dışarı bırakma, arka plan/ön plan ve eski/yeni dokunuş, erken atış ve hazırlıkta başlayan hareket sınandı. Yeni bir kilitlenme doğrulanmadı; bunlar gerçek cihaz sonucu değildir. Bir oyuncu her atışı 2,5 saniyeden önce yaparsa hafıza kuralı az hissedilebilir: açık/hatırlayarak atış sayısını kullanıcı denemesinde ayrı kaydet. Otomatik olarak gösterim süresini kısaltıp bunu çözülmüş sayma.
