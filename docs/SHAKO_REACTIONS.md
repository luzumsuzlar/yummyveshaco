# Şako'nun tepkileri — 13 Ekim 2026

0.1.14 telefon hareketleri kullanıcıdan “hepsi tamam” geri bildirimi aldı. Sonraki yerel dilimde ortak kutlama eklendi: mevcut 2,2 saniyenin son kısmında küçük karşılıklı eğilme, PAYLAŞALIM/BİRLİKTE yazıları ve mama kabında parıltı. Dolap açılışı yumuşatıldı; kutlama molasında açık dolap ve tepkiler donmuş kalır. Bu son dilim henüz telefona yüklenmedi; yeni raster varlık gerektirmedi. 25 test ve yedi Godot görüntüsüyle doğrulandı.

Kullanıcının onayladığı üç tepki yerel oyuna bağlandı:

- Atış hazırken iki dikkat pozu: topa yukarı bakış ve küçük baş/kulak değişimi. Atış, fare seçimi ve karışma sırasında bu pozlar kullanılmaz.
- Gerçek Yumi top sektirmesi 0,65 saniyelik şaşkınlık başlatır. İki poz kullanılır; kedinin bulunduğu tarafa göre yalnız çizim aynalanır. HAV'ın top yönlendirmesi bu tepkiyi başlatmaz.
- Doğru hedefe, gerekli sekme şartıyla giren top 0,45 saniyelik sevinç başlatır: gülümseme, pati kaldırma, kuyruk poz değişimi ve en fazla 4 piksel görsel yükseliş. Mevcut atış aralığının içine sığar. Bölüm sonundaki 2,2 saniyelik kutlamada aynı sevinç sürer.

Yanlış delikte sevinç yok. Doğru atış şaşkınlığı keser. Mola sayaçları ve pozları dondurur, menü ve yeniden başlatma temizler. Kutlama sırasında mola verildiğinde Şako ve gölgesi kutlama konumunda kalır; eskiden karakter başlangıç konumuna çiziliyordu. Tepkiler oyun rastgeleliğini, nişanı, top fiziğini, atış sayısını veya bölüm süresini değiştirmez.

## Dosya ve doğrulama

`assets/art/characters/shako-reactions-v1.png`: mevcut shako-idle-v1.png kimlik referansıyla yerleşik imagegen üretimi. 1536x1024, gerçek alfa, üç sütun/iki satır. Kaynak korunur; Godot altı atlas bölgesini ayrı çizer. Her kareye ayak hizası verilir. Bu ilk altı pozluk tepkidir; ayrı eklem animasyonu/elle temizlenmiş tam yürüyüş değildir.

`tests/shako_reaction_smoke.gd` gerçek atış/sektirme/doğru-yanlış delik tetiklerini, bakış yönünü, mola/kutlama/menü/sıfırlamayı, görsel çağrının oyun rastgeleliği ve nişanı değiştirmediğini sınar. Yeni test dahil 25 kontrol geçti. Son ortak karakter/gölge konumu düzeltmesinden sonra ilgili Şako testi yeniden geçti.

`tests/shako_reaction_preview.gd` altı Godot ekranı üretir: dikkat, iki yönde şaşkınlık, sevinç, kutlama, moladaki kutlama. Dikkat/şaşkınlık/kutlama ve mola görünümü kontrol edildi. `exports/shako-reaction-preview/` altındaki sahneler sentetiktir; başarı ekranının 0/5 göstergesi gerçek oyuncu sonucu değildir. Fiziksel telefon değerlendirmesi bekliyor; APK üretilmedi veya kurulmadı. Gelecek pakette hem Yumi grooming hem Şako reaction dokuları denetlenmeli.

## Son üretim yönergesi

Yerleşik imagegen; referans `shako-idle-v1.png`; `transparent_background: true`.

Use case: stylized-concept. Game sprite animation atlas of exactly the SAME caramel brown puppy Shako from reference image, cream muzzle chest paws and forehead stripe, dark brown floppy long ears, brown eyes. Reference is identity and painted style. SIX full-body small seated puppies in strict THREE columns TWO rows, landscape3:2 sheet1536x1024. Actual transparent background. Each dog occupies only CENTRAL 65 percent of its own square cell: huge transparent gutters, no touching adjacent cells. Same camera, same body scale and identical foot baseline in all cells. Row major poses: 1 attentive leaning head forward slightly eyes looking upward toward ball, ear roots lifted but ears remain floppy; 2 attentive head tilted a little, eyes still upward, ears slightly relaxed; 3 surprised glancing to upper SCREEN LEFT with widened eyes, slightly open mouth; 4 same surprised glance head turned a little farther upper screen left and ears lifted by surprise; 5 delighted small smile mouth open eyes smiling, tail pointing toward screen right; 6 same delighted expression with tail swung closer inward, tiny forepaw lift. Coherent anatomy four paws only. Warm hand-painted softly shaded 2.5D mobile game look matching reference exactly, NOT photoreal. No props, ball, floor, cast shadows, glow, backdrop, text, grid, labels. All ears tail paws fully contained per cell with large transparent margins. These are animation poses of one consistent character.
