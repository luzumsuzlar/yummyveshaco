# Yumi ve Şako — karakter görselleri v1

## Kapsam

Yerleşik image_gen ile hazırlanmış, şeffaf arka planlı ilk karakter pozları. CLI/API yedeği kullanılmadı. Dört hazır poz artık oyunun çizim koduna bağlandı; ayrı pozlar akıcı animasyon anlamına gelmez. Android 0.1.2-test paketi bu görselleri içerir; telefon bağlı olmadığı için kurulum yapılmadı. GitHub bu aşamada güncellenmedi.

Yumi: turuncu tekir, krem ağız/göğüs, amber gözler ve kıvrık kuyruk. Şako: karamel kahverengi, koyu sarkık kulaklar, krem ağız/göğüs. Yuvarlak siluet ve büyük yüzler küçük ekranda ifadeyi korumak için seçildi. Işık üst-soldan gelir; zemin gölgesi oyun tarafından çizilmelidir.

## Dosyalar

- `assets/art/characters/yumi-idle-v1.png`: uyanık temel poz.
- `assets/art/characters/yumi-sleep-v1.png`: aynı pozda kapalı gözler.
- `assets/art/characters/yumi-paw-v1.png`: sağa uzanan pati.
- `assets/art/characters/shako-idle-v1.png`: temel köpek pozu.

Eksik: Şako'nun havlama pozu. İki yerleşik üretim denemesi aracın çıktı güvenlik denetiminde `moderation_blocked / other` hatasıyla reddedildi. Hata mesajı çizimin hangi unsurunu reddettiğini belirtmedi. Bu pozun dosyası yok; başka pozla doldurulmadı. CLI/API alternatifine kullanıcı açıkça onay vermeden geçilmedi.

## Kullanım sınırları

7 Ekim 2026: dört PNG'nin alfa/çözünürlük testi geçti ve büyük/100 piksel boydaki Godot önizlemesi gözden geçirildi. Uyku pozunda kimlik tutarlı; pati pozunda kuyruk tarafı ve gövde açısı değiştiğinden bu çıktı otomatik hizalanmış animasyon karesi değildir. Dosyalar 1254 × 1254 kaynak boyutunda korunur.

Oyunda Yumi'nin uyanık/uyku/pati pozları mevcut durumlara bağlanır. Pati uyarısı veya darbe flaşı bittiğinde normal poza döner; sola pati için yalnız çizim yatay aynalanır. Her pozun normalleştirilmiş görsel merkezi ayrı hizalanır, fizik konumu değişmez. Şako normal ve başarı sırasında aynı temel görseli kullanır. Eksik havlama pozu yerine mevcut HAV yazısı ve halka efekti korunur. Fırlatıcı ve nişan ayrı katmanlardır. Tam yürüyüş/başarı animasyonları henüz yoktur.

PNG kaynakları kırpılmadan ve alfa kanalı korunarak saklanır. Oyuna bağlarken boş kenarları, ayak hizasını, pati yönünü ve boyutları her poz için denetlemek gerekir. Pati görselinin genişlemesi vurulabilir alanı genişletmemelidir. Şako'nun fırlatıcısı, nişan çizgisi ve uyarı ünlemi ayrı oyun katmanları olarak korunmalıdır.

Oyuncak fare gelecekteki dikkat dağıtma fikri olarak bekliyor: Yumi top yerine farenin atıldığı yere yönelip kısa süre oyalanabilir. Bu görsel çalışmasında mekanik eklenmedi.

`res://tests/character_art_smoke.gd` hazır dört dosyanın çözünürlüğünü, şeffaf köşelerini ve dolu karakter piksellerini kontrol eder. `res://tests/character_preview.gd` büyük ve 100 piksel boyda dört pozu gerçek Godot çıktısında gösterir ve `exports/character-preview.png` kaydeder. Bu test gerçek telefonda okunabilirlik veya animasyon kalitesini kanıtlamaz.

## Üretim yönergeleri

### Şako — havlama (reddedilen son istek, çıktı yok)

Edit this cartoon dog image into a second game pose. Keep the same dog, colors, body, ears, paws, illustration style and transparent background. Change only its expression: a friendly open-mouth bark, with cheerful attentive eyes. Keep the full character visible. No writing, props or scenery.

### shakoIdle

Use case: stylized-concept. Create one isolated friendly cartoon dog sprite for a cozy 2D mobile game. A small caramel brown dog with chocolate brown floppy ears, cream muzzle and chest, round dark nose, large expressive brown eyes and a cheerful closed-mouth smile. Seated upright, both front paws together, entire body and ears visible. Front view slightly from above. Soft hand-painted cartoon game illustration, rounded shapes, warm light from upper left, clear silhouette readable at small size. Square composition with transparent padding. Genuinely transparent background. No scene, text, clothing, collar, props or cast shadow.

### yumiPaw

Use case: precise-object-edit. Edit target: supplied orange cat sprite. Preserve character identity, cream muzzle/chest, orange tabby stripes, large amber eyes, tail, body proportions, painted finish, camera and upper-left light. Change pose only: one front paw extends clearly toward screen-right as a playful gentle reaching gesture, the other front paw remains planted. Knowing mischievous smile, no claws. Full ears, paw and tail visible with transparent padding. One isolated character, genuine transparent background. No ball, floor, cast shadow, action streaks, text or UI. A single pose, not a sprite sheet.

### yumiSleep

Use case: precise-object-edit. Edit target: the supplied orange cat sprite. Keep exactly the same orange tabby character, cream chest and muzzle, forehead stripes, proportions, curled tail, painting style, camera, framing and upper-left light. Change only the eyes and expression: both eyes peacefully closed, relaxed sleepy smile, head barely lowered. Keep seated upright body and paws in same position. One complete character only on genuinely transparent background. No text, sleep symbols, props, floor or cast shadow. This is the sleeping pose for the same mobile game character.

Nihai İngilizce yönergeler aşağıda kayıtlıdır. Yumi'nin uyku/pati pozları temel Yumi çıktısını kimlik referansı olarak kullanır. Reddedilen havlama isteği temel Şako çıktısını referans aldı. Yumi'nin temel karakter isteğinde mutfak ekranı yalnız stil referansıydı; mevcut geçici çizimler kopyalanmadı. Şako'nun başarılı temel isteği görsel referans olmadan üretildi.

### Yumi — temel poz

Use case: stylized-concept. Asset type: production-ready isolated 2D character sprite for a portrait mobile game. Input image is STYLE REFERENCE ONLY for cozy warm illustrated kitchen, honey wood and soft afternoon lighting; do NOT copy its placeholder characters or UI. Premium hand-painted 2.5D cartoon finish, rounded clean silhouette, restrained fur detail readable at 100px tall, large expressive face, warm upper-left light and gentle form shading. One character only, entire body, feet, ears and tail visible, front-facing slightly elevated game view, centered on square canvas with 12% transparent margins. Genuinely transparent background, no floor, no cast shadow (engine supplies shadow), no scenery, no text, letters, UI, watermark, props or accessories. Subject: Yumi, a small mischievous orange ginger tabby cat with a cream muzzle and chest, subtle darker orange forehead stripes, triangular ears, curled tail on its right, amber eyes, compact chunky proportions and a knowing playful smile. Pose: alert idle, seated upright with both forepaws together, face directed at viewer. Not threatening, not realistic.
