# Tamamlanan bölümler ve en iyi süre

Bölüm başarıyla tamamlanınca tamamlanma sayısı ve en iyi süre user://progress.cfg dosyasında yerel olarak saklanır. Daha yavaş sonuç rekoru değiştirmez. Menü kartında tamamlanmış/henüz tamamlanmamış bilgisi ve en iyi süre görünür; sonuç ekranında yeni rekor belirtilir. Kutlama ve mola süreleri eklenmez.

Tüm bölümler test için açık kalır. Yıldız, skor, çevrim içi kayıt veya yarım atışı sürdürme eklenmedi. Uygulama verisi silinirse kayıt da silinir; Android'de aynı paket/anahtarla güncelleme normalde mevcut uygulama verisini korur, bu sürümde fiziksel güncelleme/kayıt denemesi henüz yapılmadı.

Bozuk/yanlış tipli kayıt alanları güvenli biçimde yok sayılır. Geçersiz süre veya bölüm numarası yeni kayıt oluşturmaz. Dosya yazılamazsa oyun çökmez; kaydın diske yazılamadığı uyarılır, o oturumdaki bilgi bellekte kalır.

Godot --script ile çalışan geliştirme/testlerde gerçek oyuncu profili okunmaz/yazılmaz. tests/progress_smoke.gd kontrollü test dosyasıyla kaydet-yeniden oku, rekor, sayaç, hatalı veri, gerçek oyun sonucu ve kayıp ayrımını sınar. Menü ekranı Godot çıktısıyla kontrol edildi.

Bu geliştirme telefona yüklenmedi.
