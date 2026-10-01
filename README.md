# Yumi & Şako

Godot 4 ile geliştirilen hızlı, neşeli bir refleks-bulmaca oyununun ilk oynanabilir prototipi.

## Oynanış

Şako'nun fırlatıcısını yönlendirerek sıradaki sembol topunu aynı sembolü taşıyan deliğe gönder. Her atışta top havadayken bir kez havlayarak yönünü düzeltebilirsin. Yumi pati atmadan önce uyarı verir; doğru anda havlamak Yumi'yi irkiltir. Top Yumi'ye çarparsa temas yönü ve bölüm zorluğuna göre rastgele bir açıyla yukarı seker; şanslı bir sekme doğru deliğe de girebilir.

- Nişan: fare veya `A` / `D` / `←` / `→`
- Atış: `Boşluk`, `Enter` veya sol tık
- Havlama: top uçarken tekrar sol tık, `Boşluk` veya `E`
- Yeniden başlatma: `R`
- Kilit dizisini tamamlayınca bölüm kazanılır.
- Üç hata kilidi sıkıştırır; tek tuşla yeniden denenebilir.

## Prototip bölümleri

1. **İlk Atış:** Üç aşamada dörder eşleşme, toplam 12 doğru atış. Her aşama sonunda kasa dönüşüyle hedefler yer değiştirir; atış sırasında sabit kalır. Yumi yalnızca izler.
2. **Yumi Sahada:** Yumi dört yönde kontrollü-rastgele dolaşır ve pati öncesi ünlem işaretiyle uyarır. Havlama karşı hamle olarak kullanılır.
3. **Kayan Kilit:** Yumi sekiz yönde daha sık yön değiştirip kısa atılmalar yapar. Delikler de yatay hareket eder.

Duvarlardan pinball tarzı sekme yoktur. Oyun puan toplamaya değil, kilidi doğru sırayla çözmeye odaklanır.

İlk bölümde geçen süre ve toplam ilerleme ekranda, tamamlanma süresi sonuç ekranında gösterilir. Yanlış atış önceki doğru eşleşmeleri silmez. Üç hata sınırı bölüm boyunca geçerlidir. Kusursuz otomatik atış testinde bölüm yaklaşık 15,1 saniyede tamamlandı; 45–60 saniyelik oynama hedefi henüz oyuncu testiyle doğrulanmadı.

## Çalıştırma

Projeyi Godot 4.7 veya daha yeni bir Godot 4 sürümünde açıp `F6`/`F5` ile çalıştırın.

Komut satırından:

```powershell
& "D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64.exe" --path "D:\Works\kedikopek" --editor
```

## Prototip kapsamı

Bu sürüm, ana oyun döngüsünü doğrulamak için dış görsel veya ses paketi kullanmadan hazırlanmıştır. Karakterler ve oyun alanı Godot içinde çizilir. Sonraki adımlar; gerçek karakter çizimleri, sesler, daha fazla bölüm çeşidi ve mobil dokunmatik kontrollerdir.
