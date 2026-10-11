# İlk ses efektleri

10 Ekim 2026: Top atışı, topun duvar sekmesi, Yumi'nin topa/hedeflere pati vuruşu, başarılı kilit açılması ve uyuyan Yumi'nin mırlaması için beş özgün, kısa sentezlenmiş efekt eklendi. Müzik ve dışarıdan ses dosyası kullanılmadı. Bunlar ilk deneme efektleridir; gerçekçi hayvan kaydı değildir.

Mırlama ilk iki bölümde Yumi gerçekten uyurken başlar: ilk ses için 2 saniye beklenir; 0,9 saniyelik mırlama 7,5 saniyelik aralıklarla tekrarlanır. Ayrı, daha düşük düzeyli (-10 dB) kanalda çalar; uyanma, sesi kapama, menüye dönüş veya sonuç ekranına geçişte anında durur. Sürekli döngü değildir. tests/purr_smoke.gd bu durumları doğrular; dinleme örneği exports/audio-preview/purr.wav dosyasındadır.

0.1.7-test telefon denemesinde kullanıcı diğer efektleri duydu, mırlamayı duymadı. Tetikleme testi geçti; gerçek masaüstü oynatma tests/purr_playback.gd ile başladı/durdu olarak doğrulandı. Kesin telefon sebebi doğrulanmadı. Olası düşük bas/gain sorununa karşı yalnızca mırlama -16 dB'den -10 dB'ye yükseltildi; 180 Hz temele güçlü 360/540/720 Hz harmonikler eklendi. Diğer dört efekt değişmedi. Yeni 0.1.8-test (kod 9) paketinin telefon hoparlöründeki algılanabilirliği henüz denenmedi; telefon algılanmadığı için yüklenmedi.

Sesler scripts/game_audio.gd tarafından oyun açılışında bir kez üretilir: 22050 Hz, mono, 16-bit PCM. Altı oynatma kanalıyla aynı anda farklı olaylara ses verilebilir; sesler kırpılma sınırının altında ve -9 dB oynatma düzeyindedir. Sentez kendi sabit rastgele üretecini kullanır, oyun rastgeleliğini etkilemez.

Menüde sağ üstte ve oyun alanının sağ alt boşluğunda SES: AÇIK/KAPALI düğmesi bulunur. Kapama aktif sesleri hemen durdurur; tercih user://audio_settings.cfg dosyasında saklanır. Yeniden açınca kısa sekme sesi onay verir. Bölüme yeniden başlama veya menüye dönme önceki efektleri durdurur. Diğer uygulamaların ses ayarı değiştirilmez.

tests/audio_smoke.gd PCM verisini, süreleri, sınırlandırılmış genliği, olay bağlarını, tekrar oynatmayı engelleyen kontrolleri, sessiz oynanabilirliği ve test dosyasına tercih kaydını doğrular. Gerçek kullanıcı tercihi testte değiştirilmez. Başsız test ortamında fiziksel ses çıkışı yapılmaz; olay bağları ve ses verisi kontrol edilir. Dinleme örnekleri exports/audio-preview/ altında WAV olarak üretilir. Menü ve oyun içi düğme yerleşimi ekran görüntüleriyle kontrol edildi.

10 Ekim 2026: Ses efektleri ve mırlama 0.1.7-test (kod 8) Android paketine alındı, bağlı telefona güncelleme olarak yüklendi ve oyun açıldı. Kurulum ve sürüm doğrulandı. Paylaşım APK'sı exports/android/yumi-sako-test.apk konumunda güncellendi. Fiziksel ses yüksekliği ve algılanabilirlik kullanıcı tarafından ayrıca denenecek.
11 Ekim 2026: 0.1.8-test (kod 9) bağlı telefona güncelleme olarak başarıyla yüklendi ve oyun açıldı. Yüklü sürüm ve çalışan uygulama doğrulandı. Mırlamanın fiziksel duyulabilirliği kullanıcı denemesiyle doğrulanacak.
