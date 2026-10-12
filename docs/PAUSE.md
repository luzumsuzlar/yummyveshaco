# Mola ve telefon yaşam döngüsü

Mola düğmesi (II) oyun içinde alt sağdaki ses düğmesinin yanındadır. Canlı top, süre, pati uyarısı, oyuncak fare ve hedef dağıtma aynı durumda tutulur; aktif sesler durur. DEVAM ET kaldığı durumdan sürdürür. Yeniden başlatma ve bölüm seçimi ayrı düğmelerdir.

Telefon arka plana geçtiğinde veya uygulama odağını kaybettiğinde otomatik mola verilir. Geri dönünce oyuncu DEVAM ET ile hazır olduğunda başlar. Android geri tuşu oyun/kutlama sırasında mola açar, molada devam eder; sonuç ekranında menüye döner. Varsayılan geri-tuşu uygulamadan çıkışı kapatıldı. Menüde geri tuşu uygulamayı kapatmaz.

Bilgisayarda P veya Esc mola açar; moladayken aynı tuşlar devam eder. Fare yeri seçerken ilk Esc önce seçimi iptal eder. Sol üst bölüm düğmesi mevcut denemeyi kapatma davranışını korur.

Mola eski dokunma kimliğini temizler; telefona dönünce bırakılan eski parmak top atamaz. Otomatik ön plana dönüş oyunu kendiliğinden sürdürmez. Henüz uygulama tamamen kapatılırsa yarım kalmış denemeyi geri yükleme yoktur.

tests/pause_smoke.gd canlı top, zaman, uyarı, dokunma, hedef dağıtma, kutlama, geri tuşu ve yeniden başlatmayı kontrol eder. Bildirimler testte taklit edilmiştir; Android fiziksel arka-plan denemesi henüz yapılmadı. Görsel kontrol: exports/pause-preview/paused.png. Telefon yüklemesi yapılmadı.

12 Ekim 2026: tests/input_lifecycle_smoke.gd dört bölümde Viewport giriş yoluyla gerçek dokunma/sürükleme/tuş olaylarını gönderir. Mola sonrası eski parmak bırakmanın atış/nişan değişimi yapmaması, yeni sürüklemenin korunmuş açıdan devam etmesi, R ile temiz yeniden başlatma, basılı tuş tekrarıyla atış veya moladan çıkış olmaması ve atış başına tek havlama sınırı doğrulandı. Fare seçimi molada korunurken yerleştirme dokunuşu iptal edilir; eski bırakma hak tüketmez, yeni dokunuş tek yerleştirme yapar. Yerleştirilmiş farenin süresi molada değişmez. Bunlar sentetik giriş kontrolleridir; fiziksel dokunmatik ergonomisini kanıtlamaz. Bu incelemede ek oyun hatası bulunmadı veya oyun davranışı değiştirilmedi.
