# Yumi & Şako — Mutfak görsel katmanı v1

Bu aşama bitmiş oyun değildir. Çevre ve arayüz, seçilen dikey mutfak konseptine yaklaştırıldı. Yumi ve Şako'nun karakter çizimleri ve animasyonları henüz yenilenmedi. Oynanış koordinatları, delik hit alanları, bölüm kuralları ve düğme işlevleri değiştirilmedi.

## Dosyalar ve kullanım

- `assets/art/kitchen-background-v1.png`: 9:16 sıcak mutfak arka planı. Ekrana 540 × 960 mantıksal alanda çizilir. Üzerinde karakter, top, hedef, düğme veya metin bulunmaz.
- `assets/art/cupboard-v1.png`: alfa kanallı, üç kapaklı ahşap dolap. Ayrı katman olarak çizilir. Delikler bu dosyaya gömülmez; oyun bunları gerçek hedef konumlarında çizer.
- HUD, hedef çerçeveleri, simgeler, durum panelleri ve düğmeler Godot içinde çizilir. Bu sayede atış sırasında hareket eden delikler arka planda sabit hayalet delikler bırakmaz.

## Üretim yöntemi

İki raster görsel yerleşik image_gen aracıyla üretildi; CLI/API yedeği kullanılmadı. Referans, bu konuşmada seçilen dikey mutfak konseptidir. Referansın kendisi oyun arka planı olarak kullanılmadı. Kaynak çıktılar korunarak seçilen PNG'ler proje klasörüne kopyalandı. Dolap çevresindeki şeffaflık gerçek Godot yüklemesinde kontrol edildi.

## Kullanılan nihai promptlar

### Mutfak arka planı

Use case: stylized-concept. Asset type: production-ready portrait 9:16 background layer for a 2D mobile game, not a screenshot or mockup. Reference image is STYLE REFERENCE ONLY for warm cozy sunlit kitchen, honey wood, soft painterly 2.5D cartoon finish. Create a NEW EMPTY KITCHEN BACKGROUND with no pets, no balls, no icons, no text, no HUD, no buttons, no holes, no aim lines. Layout critical: the upper 35% shows a cozy kitchen wall with a sunlit window and a trailing plant at the far left, soft out-of-focus jars on a shallow shelf along the top edge, teal kitchen cabinetry confined to the far right edge. Leave the center of the upper third quiet and unobstructed, pale warm wall: a separate gameplay cupboard will be placed there by the engine. From 35% of image height down to the bottom, a broad continuous honey-colored wooden floor is the playfield; keep the middle 88% of its width completely empty. Furniture, a little rug and the plant may occur ONLY in the outermost 6% edge strips and should be subdued. Slight elevated front-down game camera with gentle perspective and floorboards, smooth low-contrast light pooling, no distracting high contrast light stripes across the central floor. Warm comfortable afternoon feel and premium illustrated casual game quality. Must be a usable background layer: large quiet open floor, no focal characters, no central furniture, no cabinet with holes baked in, no frames, no logos, no watermark. Portrait 9:16 full bleed.

### Dolap

Use case: stylized-concept. Asset type: isolated production 2D game cupboard sprite on a genuinely TRANSPARENT background. Reference image is style reference only. Create one warm honey oak LOW WIDE CUPBOARD FRONT, front-facing orthographic, approximately 3:1 width:height, fills frame with small transparent margin. Three equal square-ish CLOSED wooden door panels side by side, beveled caramel wood frame, fine softly painted wood grain, delicate brass hinges at outside edges and tiny knobs at door seams, a shallow top trim and lower plinth. Premium cozy cartoon 2.5D illustrated rendering, afternoon light from upper left, same warm handmade kitchen style as reference. Important: all three door faces completely blank/unbroken wood. NO holes, NO circular cutouts, NO symbols, NO fish, NO paws, NO yarn, NO food, NO UI, NO labels, NO writing. Round target holes will be drawn by the game on top of this asset. No surrounding scene, no floor, no room, no cast shadow beyond the sprite, no pets. Keep front flat and rectangular, not isometric or angled. A compact wide three-door game cabinet sprite, actual alpha transparency around the silhouette.

## Kontrol ve kalan işler

- Gerçek Godot ekranlarında üç bölüm, sekme çizgisi, hareketli delik, pati uyarısı ve sonuç ekranı gözden geçirildi.
- Dokunmatik ve sekme regresyon testleri korunur; bu değişiklikler fizik hesabını değiştirmez.
- Başarıdaki dolap açılışı hâlâ basit çizim animasyonudur. Yeni çizimlerle uyumlu başarı animasyonu, karakter sprite'ları ve sesler ayrı aşamada hazırlanmalıdır.
- Fiziksel telefon testi yapılmadı. Görsel konsept, bitmiş ürün veya mağazaya hazır sürüm olarak sunulmaz.
