# Yumi & Şako

Godot 4 ile geliştirilen hızlı, neşeli bir refleks-bulmaca oyununun ilk oynanabilir prototipi.

## Oynanış

Şako'nun fırlatıcısını yönlendirerek sıradaki sembol topunu aynı sembolü taşıyan deliğe gönder ve mama dolabını aç. Bölüm başına üç havlama hakkın var; aynı atışta yalnızca birini kullanabilirsin. Havlama topun yönünü düzeltir ve pati uyarısı sırasında Yumi'yi irkiltir. Yumi yumak topunu sahiplenip takip eder; patisi topu kontrollü-rastgele bir açıyla saptırır. Şanslı bir sekme doğru deliğe girerse Yumi'nin yardımı olarak sayılır.

- Nişan: fare veya `A` / `D` / `←` / `→`
- Atış: `Boşluk`, `Enter` veya sol tık
- Havlama: top uçarken tekrar sol tık, `Boşluk` veya `E`
- Yeniden başlatma: `R`
- Kilit dizisini tamamlayınca bölüm kazanılır.
- Üç hata kilidi sıkıştırır; tek tuşla yeniden denenebilir.

## Prototip bölümleri

1. **Mama Dolabı:** Üç aşamada dörder eşleşme, toplam 12 doğru atış. İlk dört eşleşmede Yumi uyuklar; sonra uyanır ve yavaş, yatay hareketlerle yumak topuna yaklaşır. Son aşama öğrenilen nişan ve havlama kurallarını birleştirir. İlk iki aşama sonunda kasa dönüşüyle hedefler yer değiştirir; atış sırasında sabit kalır. İlk bölümde top daha yavaş, pati uyarısı daha uzundur.
2. **Yumi Sahada:** Yumi dört yönde kontrollü-rastgele dolaşır ve pati öncesi ünlem işaretiyle uyarır. Havlama karşı hamle olarak kullanılır.
3. **Kayan Kilit:** Yumi sekiz yönde daha sık yön değiştirip kısa atılmalar yapar. Delikler de yatay hareket eder.

Duvarlardan pinball tarzı sekme yoktur. Oyun puan toplamaya değil, kilidi doğru sırayla çözmeye odaklanır.

İlk bölümde geçen süre ve toplam ilerleme ekranda, tamamlanma süresi sonuç ekranında gösterilir. Yanlış atış önceki doğru eşleşmeleri silmez. Üç hata sınırı bölüm boyunca geçerlidir. Başarıda Şako ve Yumi birlikte mamaya koşar; 2,2 saniyelik kutlama tamamlanma süresine eklenmez. Sonuç ekranında kalan havlamalar ve Yumi'nin yardımları da gösterilir. İlk bölüm için 60–90 saniye bir oyuncu testi hedefidir; yeni sürümün gerçek oynama süresi henüz ölçülmedi. Önceki sürümün kusursuz otomatik testindeki 15,1 saniye bu sürüme ait değildir.

## Çalıştırma

Projeyi Godot 4.7 veya daha yeni bir Godot 4 sürümünde açıp `F6`/`F5` ile çalıştırın.

Komut satırından:

```powershell
& "D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64.exe" --path "D:\Works\kedikopek" --editor
```

## Prototip kapsamı

Bu sürüm, ana oyun döngüsünü doğrulamak için dış görsel veya ses paketi kullanmadan hazırlanmıştır. Karakterler ve oyun alanı Godot içinde çizilir. Sonraki adımlar; gerçek karakter çizimleri, sesler, daha fazla bölüm çeşidi ve mobil dokunmatik kontrollerdir.
