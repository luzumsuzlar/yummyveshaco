# Oynarken gösterilen kısa öğretici

11 Ekim 2026: Ayrı, uzun bir öğretici ekran yerine ilgili anlarda küçük, engellemeyen ipuçları eklendi.

- 1. bölümde ilk geçerli atışa kadar nişan alma anlatılır. Telefonda sağa-sola sürükle ve bırak; bilgisayarda fareyle nişan al ve tıkla/AT! metni kullanılır. Yerli dokunma algılandığında dokunma anlatımı seçilir. Alanda kısa yatay sürükleme hareketi çizilir.
- İlk dört doğru hedef sonrası Yumi uyanınca 9 saniyelik ünlem/HAV! ipucu gösterilir. Daha önce havlama kullanılmadıysa gerçek pati uyarısı sırasında tekrar görünür. Top havadayken kullanılabileceği belirtilir; ipucu HAV! kullanımını zorunlu kılmaz.
- 3. bölümde ilk geçerli fare yerleştirmesine kadar FARE düğmesi vurgulanır. Yer seçimi açıldığında mor alana bırakma ve ücretsiz vazgeçme anlatılır. İptal veya geçersiz yerleştirme öğrenilmiş sayılmaz.

Metin kartı ekranın sol alt boşluğundadır; fare/havlama hedefleri kısa çerçevelerle vurgulanır. Kart dokunmaları engellemez, oyun durdurulmaz, atış fiziği veya haklar değiştirilmez. Başarı/kayıp ve menü ekranlarında ipuçları gizlenir. Her yeni denemede tekrar gösterilir; kalıcı öğretici tamamlama kaydı eklenmedi.

tests/tutorial_smoke.gd bağlam, geçerli/iptal hareket, süre, sonuç ve yeniden başlatma kontrollerini yapar. tests/tutorial_preview.gd ilk atış, havlama, fare ve yer seçme ekranlarını üretir. Önceki oyun testleri de yeniden çalıştırıldı.

Telefonda mırlamanın duyulduğu kullanıcı tarafından 0.1.8-test sürümünde doğrulandı. Bu yeni öğretici henüz APK'ya alınmadı veya telefona yüklenmedi.
