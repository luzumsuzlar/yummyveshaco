# Belirgin pati hareketi

9 Ekim 2026: Mevcut pati görseline oyun içinde ön bacak esnetmesi ve gövde hamlesi eklendi. Yeni raster görsel üretilmedi; görsel dosyaları değiştirilmedi.

- Uyarı süresince pati geriye/yukarı çekilerek hazırlanır.
- Topa vururken ön bacak uzanır, gövde hafif öne eğilir; 0,34 saniyede eski poza döner.
- 4. bölümün hedef dağıtma vuruşu daha büyük gövde hamlesiyle 0,48 saniye sürer.
- Gerçek temas noktasında kısa halkalı/parçalı efekt ve hareket çizgileri çizilir. Hedefe vurulduğunda yalnızca görüntüde kısa sarsılma olur.
- Büyük vuruşta isim etiketi yüzü kapatmaması için kısa süre gizlenir.

Tüm hamle ve sarsıntı çizim katmanındadır: Yumi'nin çarpışma konumu, uyarı süresi, top hızı, hedef fiziği ve başarı kuralları değişmedi. Yeni test: tests/paw_smoke.gd. Sağ/sol top vuruşu, hazırlık, hedef vuruşu ve geri çekilme ekran kontrolü: tests/paw_preview.gd.

9 Ekim 2026: Bu değişiklik bölüm menüsüyle birlikte 0.1.6-test (kod 7) Android paketine alındı, bağlı telefona yüklendi ve oyun açıldı. Kurulum ve sürüm doğrulandı; fiziksel oynanış denemesi kullanıcı tarafından yapılacak.
