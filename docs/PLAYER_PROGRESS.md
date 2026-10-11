# Tamamlanan bölümler ve en iyi süre

Bölüm başarıyla tamamlanınca tamamlanma sayısı ve en iyi süre user://progress.cfg dosyasında yerel olarak saklanır. Daha yavaş sonuç rekoru değiştirmez. Menü kartında tamamlanmış/henüz tamamlanmamış bilgisi ve en iyi süre görünür; sonuç ekranında yeni rekor belirtilir. Kutlama ve mola süreleri eklenmez.

Tüm bölümler test için açık kalır. Yıldız, skor, çevrim içi kayıt veya yarım atışı sürdürme eklenmedi. Uygulama verisi silinirse kayıt da silinir; Android'de aynı paket/anahtarla güncelleme normalde mevcut uygulama verisini korur, bu sürümde fiziksel güncelleme/kayıt denemesi henüz yapılmadı.

Yeni kayıt önce aynı klasörde progress.cfg.tmp dosyasına hazırlanır, yeniden okunarak doğrulanır; ardından ana dosyanın yerine taşınır. Önceki sağlam ana dosya progress.cfg.bak yedeğine alınır. Ana dosya kayıp, boş veya bütünlük kontrolü başarısızsa sağlam yedek okunur. Yedek önceki başarılı yazmayı temsil ettiğinden en son sonuç kaybolabilir. Bu yöntem her güç kesintisinde kurtarma garantisi değildir; gerçek Android ani kapanma/güç kesme testi henüz yapılmadı.

Yeni biçim SHA-256 bütünlük kontrolü taşır; bu şifreleme veya hile önleme sistemi değildir. Eski prototip kayıtları hâlâ okunur ve sonraki başarıda yeni biçime geçer. Bozuk/yanlış tipli eski kayıt alanları güvenli biçimde yok sayılır. Geçersiz süre veya bölüm numarası yeni kayıt oluşturmaz. Dosya yazılamazsa oyun çökmez; kaydın diske yazılamadığı geliştirme kayıtlarında uyarılır, o oturumdaki bilgi bellekte kalır. Oyuncuya ayrı kayıt hatası mesajı henüz eklenmedi.

Godot --script ile çalışan geliştirme/testlerde gerçek oyuncu profili okunmaz/yazılmaz. tests/progress_smoke.gd kontrollü test dosyasıyla kaydet-yeniden oku, rekor, sayaç, hatalı veri, gerçek oyun sonucu ve kayıp ayrımını sınar. tests/save_recovery_smoke.gd bozulmuş/eksik ana dosyadan yedeğe dönüş, geçici dosyanın yok sayılması, yeniden sağlam kaydetme, eski biçim ve yazma hatasını ayrı test dosyalarında sınar. Menü ekranı Godot çıktısıyla kontrol edildi.

Bu geliştirme telefona yüklenmedi.
