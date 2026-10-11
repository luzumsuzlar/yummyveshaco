# Oyuncak fare — ilk oynanabilir deneme

3. bölümde FARE düğmesiyle yer seçme açılır. Mor çerçeve içinde bir yere dokunup bırakmak fareyi tam seçilen noktaya yerleştirir. Bilgisayarda sol tıklama kullanılır; M tuşu yer seçimini açıp kapatır. FARE düğmesine yeniden basmak seçimden vazgeçer, hak harcamaz.

- Bölüm başına iki kullanım; yeniden başlatınca yenilenir.
- Seçim sırasında top atılamaz ve nişan değişmez. İkinci parmak, iptal edilen dokunuş ve alan dışı bırakma hak harcamaz.
- Yumi fareye yürür; yumak takibi ve pati saldırısı geçici olarak devre dışı kalır. Vardığında 2,5 saniye oyalanır; toplam dikkat dağılması en fazla 6 saniyedir.
- İlk iki bölüm ve havlama kuralları değişmedi. Uyuyan Yumi'yi uyandırma sonraki bölüm tasarımlarına bırakıldı: bu sürümde fare yalnızca zaten uyanık Yumi bulunan 3. bölümde var.
- Fare basit oyun içi çizimdir, nihai karakter görseli değildir. Alan ve süreler telefon denemesinden sonra ayarlanabilir.

Kontroller: tests/toy_smoke.gd (hak, iptal, dokunma, takip, saldırı engelleme, süre, yeniden başlatma), tests/toy_preview.gd (seçim ve takip ekranları). Önceki beş test de geçti.

8 Ekim 2026: Bu değişiklik 4. bölümle birlikte 0.1.5-test (kod 6) Android paketine alındı, bağlı telefona güncelleme olarak yüklendi ve uygulama açıldı. Kurulum ve sürüm doğrulandı; fiziksel oynanış denemesi kullanıcı tarafından yapılacak.
