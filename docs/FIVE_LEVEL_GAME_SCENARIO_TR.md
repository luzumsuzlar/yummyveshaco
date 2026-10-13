# Yumi & Şako — İlk beş bölümün uygulama senaryosu

13 Ekim 2026 · Mevcut uygulama: 0.1.13-test / Android sürüm kodu 14.

Bu belge mevcut çalışan prototipi başka bir yazılımcıya devretmek için hazırlanmıştır. Oyuncunun gördüğü akış, oyun kuralları, durum geçişleri ve doğrulama ölçütlerini tanımlar. Henüz yapılmamış fikirler mevcut özellik gibi anlatılmaz. Sayısal değerler mevcut kaynak kodundan alınmıştır; nihai denge hedefi değildir.

## 1. Oyun fikri ve karakterler

Şako köpek, mama dolabını açmak ister. Dolabın kilidi balık, pati ve yumak sembollerinden oluşur. Şako her atışta sıradaki sembolü taşıyan bir top gönderir; oyuncu topu aynı sembollü deliğe yönlendirir. Kilit dizisi tamamlanınca dolap açılır ve karakterler mamaya koşar.

Yumi kedi, bu işi bir oyuna çevirir. Bazen uyur, bazen yumağın peşine düşer, bazen topa pati atar, bazen delikleri karıştırır. Yumi'nin rastgele sektirdiği top doğru deliğe girerse bu yardım olarak sayılır. Kedi her durumda yalnızca zarar veren bir engel değildir.

Mevcut beş bölümün hepsi aynı mutfak/mama dolabı sahnesini kullanır. Farklı odalar, balkon veya buzdolabı hedefleri henüz uygulanmadı. Bölümler yeni mekânla değil, oyun kuralıyla ayrılır.

## 2. Ortak sahne ve oyuncu kontrolü

- Dikey telefon düzeni, mantıksal çözünürlük 540 × 960. Masaüstü pencere 432 × 768. Farklı ekranlarda oran korunur.
- Başlangıçta üç delik soldan sağa BALIK, PATİ, YUMAK. Renkleri sırasıyla mavi, mercan/kırmızı ve mor. Semboller renk dışında da ayırt edilebilir.
- Başlangıç delik merkezleri `(116,250)`, `(270,250)`, `(424,250)`; görsel yarıçap 48. Normal yakalama toleransı merkezden 44 birimdir. Top yarıçapı 18.
- Şako/fırlatıcı altta `(270,790)`; Yumi'nin ev konumu `(180,510)`.
- Üstte bölüm, süre, şifre sırası ve ilerleme; altta sıradaki hedef, durum mesajı ve eylem düğmeleri bulunur.
- Telefonda dokunmak nişanı o noktaya sıçratmaz. Yatay sürükleme, mevcut açıyı piksel başına 0,0045 radyan değiştirir; dikey hareket açıyı değiştirmez. Geçerli bırakma tek top atar.
- Nişan alındıktan sonra AT! düğmesi de kullanılabilir. Masaüstünde fareyle nişan ve tık; A/D veya oklarla açı; Boşluk/Enter ile atış vardır.
- İkinci parmak nişanı/atışı devralamaz. İptal edilen, dışarıda veya başka eylem düğmesi üzerinde biten hareket atış yapmaz.
- Atışın kapalı olduğu anda başlayan hareket, kilit kalkınca bırakıldığı için geçerli hale gelmez. Yeni bir dokunuş gerekir. Şifreyi gizlemek ise atış kilidi değildir.

### Ortak atış ve sonuç kuralları

1. Atışa izin varsa topun türünü şifre dizisinin mevcut elemanından al. Oyuncu top türünü seçmez.
2. Topu nişan doğrultusunda gönder; aynı anda yalnız bir uçan top olabilir.
3. Doğru sembollü deliğe giriş ve varsa sekme şartının sağlanması ilerlemeyi bir artırır. Yanlış delik, ıskalama veya izin verilmeyen duvar teması hata sayılır.
4. İlk iki hatada aynı hedef tekrar denenir; üçüncü hatada KİLİT SIKIŞTI ekranı açılır. Hatalar aşama değişiminde sıfırlanmaz.
5. Başlangıçta 0,35 sn hazırlık, doğru girişten sonra 0,45 sn, hatadan sonra 0,55 sn atış aralığı vardır. Özel geçişler daha uzun kilit uygulayabilir.
6. Deliğe girişte puanlama hemen yapılır. Görsel düşüş 0,44 sn sürer: top merkeze yerleşir, hızlanarak aşağı iner ve ön kenarın arkasında örtülür. Yaklaşık %16 küçülür; doğrudan silinme veya tamamen kararma hissi verilmez. Görsel efekt çarpışma/puan kuralını değiştirmez.
7. Dizinin tamamlanması başarıdır. Yaklaşık 2,2 sn kutlama akışında dolap açılır, karakterler mamaya gider; ardından sonuç ekranı görünür. Kutlama süresi tamamlanma kaydına eklenmez.

### HAV ve Yumi'nin topa müdahalesi

Her bölümde üç HAV hakkı, her uçuşta en fazla bir kullanım vardır. HAV yalnız uçan top üzerinde kullanılabilir; hem topun yatay yönünü düzeltir hem de sürmekte olan pati uyarısını iptal eder. Hedef, son nişan doğrultusudur; HAV düğmesinin ekran konumu değildir. İkinci bölümde yön düzeltmesi kalan zorunlu sekmeleri korumaya çalışır.

Aktif Yumi top 178 birim yakınına geldiğinde ünlem/pati hazırlığı gösterir. Uyarı bittiğinde top hâlâ 155 birim yakındaysa pati atar; uzaklaştıysa ıskalar. Aynı uçuşta ikinci pati saldırısı yapılmaz. Pati topu sınırlı, rastgele yukarı yönlü bir doğrultuya saptırır. Yeni doğrultu mevcut hızın yaklaşık 0,92–1,08 katını kullanır, hız 420–620 aralığına sınırlandırılır. Doğru deliğe tesadüfi giriş normal başarıdır, ayrıca Yumi yardımı sayılır.

HAV şu an mevcut bir özelliktir; kullanıcının talebiyle yeni HAV çeşitleri veya ek HAV zorlukları geliştirilmiyor.

## 3. Bölümlerin özeti

| Bölüm | Ana fikir | Doğru atış | Yapı | Top hızı | Yumi |
|---|---|---:|---|---:|---|
| 1 — Mama Dolabı | Nişan, kilit ve pati uyarısı | 12 | 3 × 4 eşleşme | 420 | İlk 4 uyur, sonra yavaş/yatay |
| 2 — Duvar Oyunu | Zorunlu bilardo sekmesi | 12 | 3 × 4 eşleşme | 460 | İlk 8 uyur, son 4 aktif |
| 3 — Kayan Kilit | Hareketli hedef ve fareyle oyalama | 5 | Tek dizi | 520 | Hızlı, sekiz yönlü |
| 4 — Yumi'nin Yaramazlığı | Delikleri dağıtıp yeni düzene nişan | 8 | 2. ve 5. başarıda karışma | 520 | Dört yönlü, iki karıştırma |
| 5 — Gizli Şifre | Sembol gizlenince hatırlama | 8 | Her hedefte kısa gösterim | 460 | Uyanık görünür, topa saldırmaz |

Hızlar mantıksal birim/sn, zamanlar saniyedir. Bölüm numaraları oyuncuya 1–5, kodda indeksler 0–4'tür. Sembol indeksleri `0=BALIK`, `1=PATİ`, `2=YUMAK`.

## 4. Bölüm 1 — Mama Dolabı

**Açılış:** Şako dolabın önündedir; Yumi kıvrılıp uyuklar. “İlk 4 atışta Yumi uyukluyor” mesajı ve nişan öğreticisi görünür.

**Şifre:** `BALIK, PATİ, YUMAK, BALIK | YUMAK, BALIK, PATİ, YUMAK | PATİ, YUMAK, BALIK, PATİ`.

**Aşama 1 — dört eşleşme:** Oyuncu sabit deliklere nişan alır. Yumi hareket etmez ve saldırmaz. Dördüncü başarıda kasa geçişi başlar: delikler 1,2 sn animasyonla bir sonraki konuma taşınır, sembol kimlikleri değişmez. Bu sırada atış kapalıdır.

**Aşama 2 — dört eşleşme:** Yumi uyanır. Yalnız yatay hareket eder; hız 72, yön değiştirme aralığı 2,4–3,6 sn. Yumak topuna yaklaşabilir. Pati öncesinde 0,42 sn uyarı verir. Oyuncu nişan ve HAV müdahalesini birleştirir. Sekizinci toplam başarıda ikinci kasa geçişi yapılır.

**Aşama 3 — dört eşleşme:** Aynı kurallar, aynı denemenin kalan hata/HAV haklarıyla devam eder. Ayrı bir yeni mekanik eklenmez. On ikinci başarı dolabı açar.

**Doğrulama:** İlk dört atışta saldırı olmamalı; dördüncüden sonra uyanmalı; hedef kimliği yer değişiminde korunmalı; geçişte başlayan eski dokunuş geçiş sonrası top atmamalı.

## 5. Bölüm 2 — Duvar Oyunu

**Açılış:** Nişan çizgisi yan duvarlardan yansıyan yolu gösterir. Yumi uyur. Doğrudan doğru deliğe göndermek tek başına yeterli değildir.

**Şifre:** `BALIK, YUMAK, PATİ, BALIK | PATİ, YUMAK, BALIK, YUMAK | YUMAK, BALIK, PATİ, YUMAK`.

- Aşama 1: Her hedef için en az bir yan duvar sekmesi gerekir; iki sekmeyle doğru giriş de kabul edilir.
- Aşama 2: Her hedef için iki yan duvar sekmesi gerekir.
- Aşama 3: Yeniden en az bir sekme gerekir; Yumi artık aktiftir. Dört yönde dolaşır, hız 100, yön değiştirme 0,9–1,8 sn, dikey hareket aralığı ev konumunun ±42 birimidir. Pati uyarısı 0,40 sn.

Her dört başarıda birinci bölümdeki 1,2 sn kasa yer değişimi vardır. Üçüncü duvar teması atışı hatayla bitirir. Yansıma yatay hızın işaretini değiştirir, toplam hızı korur. Duvarlar top yarıçapı dikkate alınarak hesaplanır; sonsuz pinball sekmesi yoktur. Diğer dört bölümde yan duvar teması sektirmez, hata oluşturur.

**Örnek:** Aşama 2'de top bir kez sekip doğru deliğe girerse ilerleme artmaz; “doğru delik, ama en az 2 sekme gerekiyor” hatası gösterilir.

**Doğrulama:** Asgari sekme sayısı her aşamada doğru olmalı; Yumi ilk sekiz başarıda uyumalı; HAV kullanımı sekme şartını kaldırmamalı.

## 6. Bölüm 3 — Kayan Kilit

**Açılış:** Delikler yavaşça yatay kayar, Yumi aktiftir. Oyuncuya FARE düğmesiyle oyalama öğretilir.

**Şifre:** `BALIK, YUMAK, PATİ, BALIK, YUMAK`.

Her delik kendi fazıyla yatay salınır: `x = başlangıç_x + sin(oyun_süresi × 1,18 + sembol_indeksi × 1,65) × 22`. Dikey delik konumu sabittir. Oyuncu yalnız mevcut konuma değil, top varana kadar kayacağı yere nişan alır.

Yumi sekiz yönde hareket eder; hız 162, yön değiştirme 0,45–1,15 sn, dikey aralık ±62. Kısa durma olasılığı 0,14, atılma olasılığı 0,16; atılma yaklaşık 1,48 hız çarpanı ve 0,20–0,34 sn sürer. Pati uyarısı varsayılan 0,24 sn'dir.

**Oyuncak fare alt senaryosu:**

1. Bölüm başlangıcında iki fare hakkı vardır. FARE'ye basınca mor yerleştirme alanı açılır: `(100,498)` başlangıçlı `340×124` dikdörtgen.
2. Aynı düğmeye tekrar basmak iptaldir; hak harcanmaz. Geçersiz yer veya iptal edilen dokunuş da ücretsizdir.
3. Geçerli bırakmada bir hak harcanır, fare seçilen yerde görünür. Bu bırakma top atmaz.
4. Yumi'nin hedefi farenin 50 birim üstündeki karakter konumudur. Normal dolaşma/yumak takibi yerine oraya gider. Fare aktif olduğu sürece topa saldırmaz.
5. Toplam oyalama üst sınırı yerleştirmeden itibaren 6 sn; hedefe ulaştıktan sonra oyun süresi en fazla 2,5 sn. Önce biten zamanlayıcı oyalamayı sonlandırır. Dolayısıyla “her kullanım tam 6 sn” garantisi yoktur.
6. Gidiş, yakalama ve bırakma farklı geri bildirim verir. Yakalama sonrası gerçek kalan süre ve azalan halka görünür; son saniye rengi değişir. Aktifken düğme FARE AKTİF yazar ve tekrar kullanım kapalıdır.
7. Süre bitince fare kaybolur; Yumi yeniden dolaşıp topa müdahale edebilir. Yeniden başlatmada iki hak geri gelir.

**Doğrulama:** Fare saldırıyı engellemeli ama deliklerin kaymasını durdurmamalı; ikinci parmak fare yerleştirmemeli; mola fare zamanlayıcılarını dondurmalı.

## 7. Bölüm 4 — Yumi'nin Yaramazlığı

**Açılış:** Hedefler sabittir, Yumi dört yönde dolaşır. Hız 115, yön değiştirme 1,0–1,8 sn, dikey aralık ±42. Normal pati uyarısı 0,24 sn. Fare yoktur.

**Şifre:** `BALIK, PATİ, YUMAK, BALIK, YUMAK, PATİ, BALIK, YUMAK`.

İkinci ve beşinci toplam başarıdan sonra Yumi deliklere pati atarak düzeni dağıtır. Bu normal uçuş patisinden ayrı, bölümün zorunlu ara olayıdır; HAV ile iptal edilmez.

**Karıştırma durum zinciri:** `yaklaşma → uyarı → hareket → gerekiyorsa güvenli yerleşme → Yumi'nin dönüşü → kısa hazırlık → atış hazır`.

1. Yaklaşma: Yumi rastgele bir deliğin altına 300 birim/sn hızla gider. Atış kapalı, eski nişan dokunuşu temizlenir.
2. Uyarı: Ünlem ve pati hazırlığı 0,65 sn gösterilir.
3. Hareket: Delikler rastgele yönlerde 340–460 başlangıç hızıyla 2,2 sn hareket eder. Sınır ve birbirleriyle temaslarda seker, sürtünmeyle yavaşlar. Hareket alanı delik merkezleri için x=82–458, y=242–412; en az 112 birim merkez aralığı korunur.
4. Yerleşme: Hedefler durur; hiçbir delik başka bir deliğin doğrudan atış yolunu kapatmamalıdır. Yol kapalıysa x konumları güvenli yuvalara kısa yerleşme hareketiyle düzeltilir; sembol kimlikleri korunur.
5. Dönüş: Yumi ev konumuna döner. Delikler durmuş olsa bile bu aşamada atış hâlâ kapalıdır; mesaj “Yumi geri dönüyor” der.
6. Hazırlık: Dönüş tamamlanınca 0,25 sn bekleme kalır. Ancak sonra yeşil ATIŞ HAZIR görünür; yeni dokunuşla atılabilir.

Karışma şifreyi veya mevcut hedefi değiştirmez. Oyuncu sıradaki sembolün yeni yerini bulur. Delikler farklı yüksekliklerde kaldığı için çarpışma eski sabit hedef çizgisine göre değil, gerçek delik konumlarına süpürülmüş hareket hesabıyla yapılır.

**Doğrulama:** İki karışma olmalı; dönüş sırasında hazır mesajı çıkmamalı; bütün delikler erişilebilir kalmalı; top yeni delik konumlarında yakalanmalı; yanlış sembol hata olmaya devam etmeli.

## 8. Bölüm 5 — Gizli Şifre

**Açılış:** Sabit delikler, uyanık ama topa müdahale etmeyen Yumi. Oyuncu yeni hafıza kuralını tek başına öğrenir; fare/karıştırma/zorunlu sekme yoktur.

**Şifre:** `BALIK, YUMAK, PATİ, PATİ, BALIK, YUMAK, BALIK, PATİ`.

1. Her hedef başlangıçta 2,5 sn görünür. Sayaç yalnız oyuncunun atış yapabilecek durumda olduğu zaman azalır; hazırlık, uçuş, mola ve menü süreyi tüketmez.
2. Süre dolunca üstte mevcut sembol `[?]` olur, gelecekteki semboller kapalı kalır. Hedef kutusu nötr renkte HATIRLA yazar. Bekleyen top da nötr/soru işaretlidir; rengi cevabı ele vermez.
3. Yumi pati pozunda “ŞİFRE BENİM!” der. Bu bilgi gizleme olayıdır; atış veya nişan kilidi değildir. O anda başlamış sürükleme bozulmaz.
4. Oyuncu hatırladığı deliğe atar. Atıştan sonra uçan top normal sembol/rengiyle görünür; karar sonrası geri bildirim gizlenmez. Sembol henüz görünürken erken atış da serbesttir.
5. Doğru girişte sonraki hedef 2,5 sn yeniden gösterilir. Yanlış delik/ıskalamada aynı hedef tekrar gösterilir; hata sayısı artar. Üç hatada kayıp, sekiz başarıda dolap açılır.

**Doğrulama:** Gizlenince nişan/atış çalışmalı; üst sıra, metin ve bekleyen top cevabı sızdırmamalı; mola sayacı dondurmalı; hata sonraki sembole geçmemeli.

**Mevcut tasarım değerlendirmesi:** Kullanıcı beşinci bölümde sembol gizlendikten sonra atış yaptığını, buna rağmen “çok da bir şey fark etmedi”ğini söyledi. Bu, erken atışla kuralı atlamaktan farklıdır: hafıza kuralı kullanılmış ama bu oyuncuya belirgin deneyim farkı vermemiştir. Mekanik çalışıyor; eğlence/özgünlük bakımından başarı kanıtlanmış değildir. Bu bölüm yeniden tasarım adayıdır. Bu belgede yeni bir kural uygulanmış gibi gösterilmez, gösterim süresi kendiliğinden kısaltılmaz.

## 9. Menü, mola, kayıt ve ses

- Bütün bölümler test için açıktır; kilit açma/ilerlemeye bağlı erişim yoktur. Menü sayfa başına dört kart gösterir: ilk sayfa 1–4, ikinci sayfa 5. Gizli kartlar tıklanamaz. Bölümden menüye dönüş o bölümün sayfasını açar.
- Başarı ekranında 1–4 için Sonraki Bölüm, 5 için Başa Dön vardır. Kayıpta Tekrar Dene aynı bölümü sıfırlar. Bölümler düğmesi menüye götürür.
- Mola düğmesi/P/Esc veya telefonda arka plana geçiş oyun hareketini ve zamanlayıcıları dondurur. Ön plana dönüş kendiliğinden devam ettirmez; oyuncu devam eder. Önceki dokunuş bırakması atış yapmaz.
- Android geri: oyun/kutlamada mola; molada devam; başarı/kayıpta menü.
- Başarıda bölümün en iyi süresi ve tamamlanma sayısı saklanır; mola/kutlama süreleri sonucu şişirmez. Kayıp başarı kaydı oluşturmaz. Yarım deneme uygulama tamamen kapanınca devam etmez.
- Yazma başarısızlığında sonuç oturum belleğinde kalır; sonuç ve menü “kayıt yazılamadı” uyarısı gösterir. Diskte kayıt varmış gibi davranılmaz. Yedekten kurtarma da bildirilir.
- Ses açık/kapalı tercihi saklanır. Atış, sekme, pati, kilit açma ve uyuyan Yumi'nin mırlaması vardır. Mola, menü ve sonuç geçişleri eski sesleri temizler. Beşinci bölümde Yumi uyanık olduğundan mırlama başlamaz.

## 10. Yazılımcı için kaynak ve doğrulama rehberi

- Ana sahne: [main.tscn](D:/Works/kedikopek/scenes/main.tscn).
- Bölüm verileri, durum makinesi, giriş/fizik ve çizimler: [main.gd](D:/Works/kedikopek/scripts/main.gd). Mevcut çizim Node2D içinde yapılır; her bölüm ayrı sahne değildir.
- Kayıt: [game_progress.gd](D:/Works/kedikopek/scripts/game_progress.gd). Ses: [game_audio.gd](D:/Works/kedikopek/scripts/game_audio.gd).
- Toplu test: [run_checks.ps1](D:/Works/kedikopek/tests/run_checks.ps1), şu anda 23 test. Özellikle `portrait_smoke`, `wall_smoke`, `toy_smoke`, `scatter_smoke`, `memory_smoke`, `menu_smoke`, kayıt ve ses testleri bölüm kurallarını kontrol eder.
- Testte ilerlemeyi elle başarıya taşımak menü/kayıt akışını sınar, oynanabilirliği kanıtlamaz. Gerçek top uçuş testleri ayrıca vardır. Hiçbiri insanın hatırlama başarısı veya telefon ergonomisi yerine geçmez.
- Mevcut kaynak paket dışından beş bölüm olarak da açılarak kontrol edildi. Android 0.1.13-test telefona veri silmeden yüklendi. Kullanıcı beşinci bölüme kadar oynayıp sorun olmadığını bildirdi; bütün cihaz kenar durumlarının geçtiği iddia edilmez.
- İlk dört bölümün temposu kullanıcı tarafından normal bulundu; korunmalıdır. Eski 47,5 sn bildiriminin tek bölüm/toplam kapsamı belirsizdir; bölüm bazlı ölçüm uydurulmaz.
- Bu belge mevcut davranışı devreder. Yeni odalar, iki top, yeni top türleri, zorunlu oyuncak fare veya geliştirilmiş hafıza/boss kuralı ayrı tasarım ve onay gerektirir.
