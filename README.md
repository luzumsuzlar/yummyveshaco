# Yumi & Şako

Godot 4 ile geliştirilen hızlı, neşeli bir refleks-bulmaca oyununun ilk oynanabilir prototipi.

## Oynanış

Şako'nun fırlatıcısını yönlendirerek sıradaki sembol topunu aynı sembolü taşıyan deliğe gönder. Yumi oyun alanında dolaşır ve yakaladığı topa pati atarak yönünü değiştirir.

- Nişan: fare veya `A` / `D` / `←` / `→`
- Atış: `Boşluk`, `Enter` veya sol tık
- Yeniden başlatma: `R`
- Beş parçalık kilit dizisini tamamlayınca bölüm kazanılır.
- Üç hata kilidi sıkıştırır; tek tuşla yeniden denenebilir.

## Çalıştırma

Projeyi Godot 4.7 veya daha yeni bir Godot 4 sürümünde açıp `F6`/`F5` ile çalıştırın.

Komut satırından:

```powershell
& "D:\Works\Tetris\Godot\Godot_v4.7.2-stable_win64.exe" --path "D:\Works\kedikopek" --editor
```

## Prototip kapsamı

Bu sürüm, ana oyun döngüsünü doğrulamak için dış görsel veya ses paketi kullanmadan hazırlanmıştır. Karakterler ve oyun alanı Godot içinde çizilir. Sonraki adımlar; gerçek karakter çizimleri, sesler, bölüm çeşitleri ve mobil dokunmatik kontrollerdir.

