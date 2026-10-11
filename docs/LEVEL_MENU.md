# Bölüm seçme ekranı

9 Ekim 2026: Normal açılış artık bölüm seçme ekranına gider. Dört kartın her biri bölüm adı, kısa kural açıklaması ve küçük oyun içi çizim önizlemesi içerir. Bütün bölümler test için açık; yıldız, kilit veya kalıcı ilerleme kaydı eklenmedi.

Kartın tamamı düğmedir. Oyun içinde sol üstteki ≡ düğmesi seçim ekranına döner. Kazanma/kaybetme ekranında ayrıca BÖLÜMLER düğmesi vardır. Bilgisayarda Esc menüye döner; oyuncak fare yeri seçerken ilk Esc yalnızca seçimi iptal eder.

Menüye dönmek mevcut denemeyi kapatır; bir kart seçmek yeni deneme başlatır. Eski top, dokunma, oyuncak fare ve hedef dağıtma durumları taşınmaz. Menüde süre ve fizik ilerlemez. Sonuç ekranındaki tekrar deneme ve sonraki bölüm akışı korunur.

Geliştirme/test için --level=1..4 seçeneği doğrudan belirtilen bölümü açmaya devam eder. Önceki öğretici testleri artık ilk bölümü açıkça seçer; normal açılış ve menü akışı tests/menu_smoke.gd ile ayrıca sınanır. Ekran kontrolleri tests/menu_preview.gd ile üretilir.

9 Ekim 2026: Bölüm menüsü ve belirgin pati hareketi 0.1.6-test (kod 7) Android paketine alındı, bağlı telefona güncelleme olarak yüklendi ve oyun açıldı. Kurulum ve sürüm doğrulandı; fiziksel oynanış denemesi kullanıcı tarafından yapılacak.
