# Yumi & Şako — İlk Beş Bölümün Uygulama ve Tasarım Senaryosu

**Sürüm:** 0.1.13-test / Android Sürüm Kodu 14  
**Tarih:** 13 Ekim 2026  
**Hedef Kitle:** Projeyi devralacak oyun yazılımcısı, oyun tasarımcısı (Game Designer) ve test mühendisi.

Bu belge, çalışan Godot 4 prototipinin teknik mimarisini, oyun kurallarını, durum makinelerini, kullanıcı geri bildirimleriyle şekillenen tasarım kararlarını ve 5. bölüm için planlanan geliştirme alternatiflerini eksiksiz tanımlar. Belgede **mevcut çalışan mekanikler** ile **önerilen geliştirme alternatifleri** açık bir şekilde birbirinden ayrılmıştır.

---

## 1. Oyun Fikri, Karakterler ve Tema

* **Şako (Köpek):** Mama dolabını açmak için dolap kilidine doğru sembol taşıyan topları fırlatır. Sabırlı, hedef odaklı ancak refleksleri oyuncunun nişan hassasiyetine bağlıdır.
* **Yumi (Kedi):** Kendi kurallarıyla oynayan, meraklı bir sabotajcı ve fırsatçı yardımcıdır. Uyur, topun peşine düşer, pati atarak yönünü saptırır veya hedefleri dağıtır. Yumi'nin sektirdiği top doğru deliğe girerse bu bir "kaza eseri yardım" sayılır; Yumi salt kötü niyetli bir düşman değil, yaşayan bir kedi karakteridir.
* **Mama Dolabı Kilidi:** Üç temel sembolden oluşur:
  * `0 = BALIK` (Mavi - `#57d9ff`, sembol: `◆`)
  * `1 = PATİ` (Mercan/Kırmızı - `#ff8b74`, sembol: `●`)
  * `2 = YUMAK` (Mor - `#b98cff`, sembol: `✦`)
* **Mekân Bütünlüğü:** İlk beş bölüm mutfak/mama dolabı sahnesinde (`kitchen-background-v1.png`, `cupboard-v1.png`) geçer. Bölümler arası fark oda değişimiyle değil; fizik kuralları, hedef dinamikleri ve Yumi'nin davranış katmanlarıyla sağlanır.

---

## 2. Ortak Sahne, Koordinat Sistemi ve Girdi Yaşam Döngüsü

### 2.1 Ekran ve Koordinat Düzeni
* **Mantıksal Çözünürlük:** Dikey (Portrait) `540 × 960`. Masaüstü test penceresi `432 × 768`. Farklı ekran en-boy oranlarında dikey eksen ve oranlar korunur (`keep_width` / `viewport` ölçekleme).
* **Fırlatıcı (Şako):** Ekranın alt-orta noktasında: `(270, 790)`.
* **Delikler (Hedefler):** Başlangıç konumu `HOLE_Y = 250.0`. Merkezler:
  * Balık: `(116, 250)`
  * Pati: `(270, 250)`
  * Yumak: `(424, 250)`
  * Görsel yarıçap: `48.0` px, Yakalama toleransı: Merkezden `44.0` px, Hedef aralığı sınırı: en az `112.0` px.
* **Top:** Yarıçapı `18.0` px.
* **Yumi Ev Konumu:** `(180, 510)`, Gezinme yatay sınırları: `X = 100.0` ile `440.0` arası.
* **Yan Duvarlar:** Sol sınır `X = 24.0 + 18.0 = 42.0`, Sağ sınır `X = 540.0 - 24.0 - 18.0 = 498.0`.

### 2.2 Nişan Alma ve Dokunmatik Girdi (Touch & Drag)
1. **Piksel Başına Radyan Oranı:** Yatay parmak hareketi açıyı `0.0045 rad/px` hassasiyetle değiştirir. Dikey parmak hareketi açıyı etkilemez.
2. **Sıçrama Koruması:** Ekrana dokunmak nişangâhı anında dokunulan noktaya sıçratmaz (absolute değil, relative/delta takip).
3. **Tek Dokunuş Kuralı:** İkinci parmak veya çoklu dokunuş nişanı devralamaz, ek atış tetikleyemez.
4. **İptal Alanları:** Üst menü, mola ve ses düğmeleri (`AIM_AREA` dışı veya HUD elemanları) üzerine bırakılan hareket atış yapmaz; iptal sayılır.
5. **Gecikmiş Dokunuş Koruması:** Fırlatıcının kapalı olduğu (hazırlık, hedef karışması, kasa dönüşü) anda başlayan dokunma hareketi, kilit açılsa dahi geçerli atışa dönüşemez; oyuncunun temiz, yeni bir dokunuş yapması zorunludur.

### 2.3 HAV (Bark) Mekaniği
* Bölüm başına **3 HAV hakkı** bulunur.
* **Tek Uçuş / Tek Kullanım:** Havada top varken en fazla bir kez basılabilir.
* **İşlevi:** Topun yönünü fırlatıldığı son nişan doğrultusuna anında hizalar ve eğer Yumi o anda pati uyarısı veriyorsa Yumi'yi irkilterek atağı iptal eder.
* Bölüm 2'de (Duvar Oyunu) HAV, kalan zorunlu sekme yörüngesini bozmadan yatay doğrultuyu korumaya çalışır.

### 2.4 Yumi'nin Pati Saldırı Döngüsü
```
Top Yaklaşımı (Mesafe ≤ 178 px) 
       ↓
Telegraph / Uyarı (0.24s – 0.42s ünlem + pati hazırlığı)
       ↓
Mesafe Kontrolü (Süre bittiğinde top hâlâ ≤ 155 px mi?)
   ├── EVET → Pati Darbesi (Hız: 420–620 aralığında, 0.92–1.08x çarpan, yukarı yönlü sapma)
   └── HAYIR → Iskalama (Pati boşa savrulur, toparlanma durumuna geçer)
```
* Aynı uçuşta ikinci bir pati saldırısı yapılamaz.
* Yumi'nin saptırdığı top doğru deliğe girerse bu hata değil, "Yumi Yardımı" (Help counter) olarak kaydedilir.

---

## 3. Merkezi Durum Makinesi (Game State Machine)

Yazılımcının `main.gd` içerisindeki durum geçişlerini doğru yönetebilmesi için tanımlı durum akışı:

```
[INIT / BÖLÜM YÜKLE]
       ↓
[STATE_PREPARING] (0.35s hazırlık, atış kapalı)
       ↓
[STATE_AIMING_READY] (Atış açık, HUD: "ATIŞ HAZIR")
       ├── Dokunma + Bırakma / "AT!" düğmesi
       ↓
[STATE_BALL_FLYING] (Top fizik hareketi, tek uçan top kuralı)
       ├── Yumi Etki Alanına Giriş → [STATE_YUMI_WARNING] → [STATE_YUMI_ATTACK]
       ├── HAV Butonu Kullanımı → Top açısı düzeltilir + Yumi saldırısı iptal edilir
       ├── Yanlış Delik / Iska / Duvar Hatası → [STATE_FAIL_COOLDOWN] (0.55s)
       │         └── 3. Hata → [STATE_GAME_OVER] ("KİLİT SIKIŞTI")
       └── Doğru Delik → [STATE_HOLE_DROP] (0.44s video referanslı düşüş)
                 ├── Ara Aşama Sonu → [STATE_STAGE_TRANSITION] (1.2s delik kayması)
                 ├── Özel Aşama (Bölüm 4) → [STATE_SCATTER_SEQUENCE] (2.2s dağılma + dönüş)
                 └── Şifre Tamamlandı → [STATE_CELEBRATION] (2.2s dolap açılma + mamaya koşu)
                           ↓
                 [STATE_LEVEL_VICTORY] (Sonuç ekranı, süre ve başarı kaydı)
```

---

## 4. Beş Bölümün Karşılaştırmalı Parametre Matrisi

| Parametre | Bölüm 1: Mama Dolabı | Bölüm 2: Duvar Oyunu | Bölüm 3: Kayan Kilit | Bölüm 4: Yumi'nin Yaramazlığı | Bölüm 5: Gizli Şifre |
|---|---|---|---|---|---|
| **Ana Mekanik** | Temel nişan ve pati uyarısı | Bilardo duvar sekmesi | Salınan delikler + Fare | Hedeflerin dağıtılması | Hafıza / Sembol gizleme |
| **Toplam Başarı Hedefi** | 12 (3 × 4 aşama) | 12 (3 × 4 aşama) | 5 (Tek dizi) | 8 (2. ve 5. başarıda karışma) | 8 (Tek dizi) |
| **Top Hızı (px/s)** | 420.0 | 460.0 | 520.0 | 520.0 | 460.0 |
| **Yumi Hızı (px/s)** | 72.0 | 100.0 | 162.0 | 115.0 | 72.0 (Pasif) |
| **Yumi Hareket Serbestliği** | 2 Yön (Yatay) | 4 Yön | 8 Yön + Kısa Atılma | 4 Yön | 2 Yön (Saldırmaz) |
| **Pati Uyarı Süresi (s)** | 0.42 | 0.40 | 0.24 | 0.24 | Saldırı yok |
| **Özel Donanım / Kural** | Kasa değişimi (1.2s) | Min/Max sekme koşulu | Oyuncak Fare (2 hak) | Dağılma alanı + Dönüş kilidi | 2.5s sonra sembol gizleme |
| **HAV Bütçesi** | 3 | 3 | 3 | 3 | 3 |

---

## 5. Bölüm 1 — Mama Dolabı (Temel Eğitim ve Kasa Döngüsü)

* **Öğretici Akışı:**
  * **Aşama 1 (1–4. Atışlar):** Yumi `(180, 510)` noktasında uyur, mırlama sesi aktiftir. Topa asla dokunmaz. Sabit deliklere temel nişan öğretilir.
  * **Kasa Geçişi 1:** 4. başarıda delikler `1.2 sn` yumuşak animasyonla yer değiştirir. Atış kilitlidir.
  * **Aşama 2 (5–8. Atışlar):** Yumi uyanır. Sadece yatay eksende (`Hız = 72.0`, `Dönüş = 2.4–3.6s`) hareket eder. Pati öncesi `0.42 sn` ünlem gösterir. HAV ile kurtarma öğretilir.
  * **Kasa Geçişi 2:** 8. başarıda ikinci `1.2 sn` geçiş.
  * **Aşama 3 (9–12. Atışlar):** Yumi uyanık kalır; 12. başarıda dolap kilidi açılır.
* **Şifre Dizisi:** `0, 1, 2, 0 | 2, 0, 1, 2 | 1, 2, 0, 1` (Balık, Pati, Yumak kombinasyonları).
* **Doğrulama Ölçütleri:**
  * İlk 4 atışta Yumi kesinlikle uyanmamalıdır.
  * Geçiş animasyonunda bırakılan dokunuşlar atış tetiklememelidir.

---

## 6. Bölüm 2 — Duvar Oyunu (Zorunlu Sekme Fiziği)

* **Temel Kural:** Doğrudan deliğe giden atışlar doğru sembol olsa bile **hata** sayılır.
  * **Aşama 1 (1–4. Hedef):** En az 1 yan duvar sekmesi zorunludur. (2 sekme de geçerlidir).
  * **Aşama 2 (5–8. Hedef):** Tam olarak 2 yan duvar sekmesi zorunludur.
  * **Aşama 3 (9–12. Hedef):** En az 1 sekme zorunludur; Yumi uyanır (4 yönlü, `Hız = 100.0`, `Dikey Aralık = ±42 px`).
* **Sekme Fiziği:** Yan duvara çarpan topun yatay hız vektörü ters çevrilir (`vx = -vx`), dikey hız ve skaler hız korunur. 3. duvar teması ıskalama/hata sayılır.
* **Şifre Dizisi:** `0, 2, 1, 0 | 1, 2, 0, 2 | 2, 0, 1, 2`.
* **Hata Mesajı Ayrımı:** Sekme şartı sağlanmadan giren topta oyuncuya net geri bildirim verilir: *"Doğru delik, ama en az 2 sekme gerekiyor!"*

---

## 7. Bölüm 3 — Kayan Kilit (Sinüzoidal Salınım ve Oyuncak Fare)

* **Hedef Hareketi:** Her delik kendi fazında yatay olarak salınır:
  $$\Delta x = \sin(\text{süre} \times 1.18 + \text{sembol\_indeksi} \times 1.65) \times 22.0$$
* **Yumi Dinamiği:** 8 yönlü hareket, yüksek hız (`162.0 px/s`), `%16` olasılıkla `1.48x` hızda kısa atılma (`0.20–0.34s`), reaksiyon süresi daralmış (`0.24s`).
* **Oyuncak Fare Alt Sistemi:**
  * Bölüm başında **2 fare hakkı** verilir.
  * `FARE` düğmesine basılınca mor yerleştirme alanı (`X: 100–440, Y: 498–622`) belirir.
  * Geçerli alana bırakıldığında Yumi farenin `50 px` üstüne yönelir ve topu tamamen görmezden gelir.
  * **Çift Zamanlayıcı Güvencesi:** Fare yerleştirildikten sonra toplam maksimum süre `6.0 sn`, Yumi fareye ulaştıktan sonraki oyalama süresi maksimum `2.5 sn`'dir. Hangisi önce biterse fare kaybolur.
  * HUD üzerinde farenin kalan süresi azalan radyal halka ile gösterilir; son 1 saniyede halka rengi kırmızıya döner.

---

## 8. Bölüm 4 — Yumi'nin Yaramazlığı (Kaotik Dağılma)

* **Olay Tetikleyicisi:** 2. ve 5. doğru atıştan hemen sonra zorunlu ara sahne (Scatter Event) başlar. Bu olay HAV ile engellenemez.
* **Dağılma Durum Zinciri:**
  1. **Yaklaşma:** Yumi `300 px/s` hızla rastgele bir deliğin altına koşar. Girdi kilitlenir.
  2. **Telegraph:** `0.65 sn` ünlem ve pati kaldırma animasyonu.
  3. **Dağılma (Fizik):** Delikler `340–460 px/s` başlangıç hızıyla `2.2 sn` boyunca birbirlerinden ve sınırlardan (`X: 82–458, Y: 242–412`) sekerek savrulur. Sürtünmeyle yavaşlarlar.
  4. **Güvenli Yuvalanma (Anti-Blocking):** Hiçbir delik bir diğerinin arkasında kalarak doğrudan atış yolunu kapatamaz. Merkez mesafesi en az `112 px` olacak şekilde hafifçe düzeltilir.
  5. **Yumi'nin Dönüşü:** Delikler dursa dahi Yumi ev konumuna dönene kadar atış kapalıdır (HUD: `YUMI DÖNÜYOR`).
  6. **Hazır Olma:** Yumi oturduktan sonra `0.25 sn` hazırlık payı verilir, ardından yeşil `ATIŞ HAZIR` yanar.
* **Şifre Dizisi:** `0, 1, 2, 0, 2, 1, 0, 2`.

---

## 9. Bölüm 5 — Gizli Şifre: İnceleme, Eleştiri ve Geliştirme Tasarımı

### 9.1 Mevcut Prototip Kuralı
* Sembol fırlatıcı hazır olduktan sonra `2.5 sn` gösterilir.
* Süre bitince üst şifre satırında sembol `[?]` olur, sol hedef kutusu nötr renkte `HATIRLA` yazar, bekleyen top nötr gri ve soru işaretli olur (bilgi sızıntısı önleme).
* Atış yapıldıktan sonra top gerçek rengini ve sembolünü geri kazanır.
* Yumi bu bölümde topa müdahale etmez; delikler sabittir.

### 9.2 Kullanıcı Geri Bildirimi Analizi: Neden "Fark Hissedilmedi"?
0.1.13-test APK denemesinde oyuncu: *"Beşinci bölüme kadar sorunsuz geldim, sembol gizlendikten sonra attım ama oyunda pek bir fark hissetmedim"* geri bildirimini vermiştir. Yapılan oyun tasarımı incelemesinde bu durumun kök nedenleri şunlardır:

1. **Gereksiz Uzun Gösterim Süresi (2.5 sn):** Mobil ekranda tek bir sembolü (ör. Mavi Balık) hafızaya almak insan beyni için `0.4 - 0.6 sn` sürer. Oyuncu nişan alırken zaten sembolü çoktan zihnine kazımış olur; gizlenmesi bilişsel bir yük veya gerilim oluşturmaz.
2. **Yumi'nin Sıfırlanan Tehdidi:** İlk 4 bölümde kademeli olarak canavarlaşan ve hızlanan Yumi, 5. bölümde tamamen etkisizleştirilmiştir. Bu durum oyunun zirve (final) noktasında tansiyonun aniden düşmesine neden olur.
3. **Mekânsal Sabitlik:** Delikler sabit olduğu için oyuncu sembol gizlenmeden önce parmağını doğru deliğin hizasına koyup bekleyebilmektedir.

### 9.3 Bölüm 5 İçin Geliştirme Seçenekleri (Tasarım Önerileri)

Mevcut çalışan kod tabanını (`main.gd`) bozmadan uygulanabilecek 3 farklı geliştirme modeli:

#### Seçenek A (Tavsiye Edilen): "Fincan Oyunu / Üç Kâğıt" (Hafıza + Mekânsal Takip)
* **Kural:** Semboller 1.5 sn boyunca deliklerin üzerinde açıkça görünür. Ardından deliklerin kapakları kapanır (üçü de soru işareti olur).
* **Yumi'nin Hareketi:** Yumi deliklerin önüne gelir ve iki deliğin yerini patiyle hızlıca kaydırarak değiştirir (klasik fincan oyunu mekaniği).
* **Görev:** Oyuncu sadece "Balık" sembolünü değil, "Balık deliğinin nereye kaydığını" gözleriyle takip etmek zorundadır.
* **Avantajı:** Hem hafıza hem dikkat unsuru birleşir; Yumi pasif bir heykel olmaktan çıkıp bölümün ana hilesi haline gelir.

#### Seçenek B: Çift Sembol Kombinasyonu (Bellek Yükü Artırımı)
* **Kural:** Şako fırlatıcıya ardışık iki top yükler (ör. önce `BALIK`, hemen ardından `PATİ`).
* **Uygulama:** Her iki sembol 2.0 sn gösterilip aynı anda gizlenir. Oyuncu birinciyi attıktan hemen sonra beklemeden ikinciyi doğru deliğe atmak zorundadır.
* **Avantajı:** Tekil sembol ezberini kırar, gerçek kısa süreli çalışma belleğini (working memory) zorlar.

#### Seçenek C: Yumi'nin Dikkat Dağıtması (Sahte İpucu)
* **Kural:** Gerçek sembol 1.8 sn sonra gizlenir. Yumi gizleme anında elinde sahte bir sembol tabelası kaldırır (örneğin hedef `PATİ` iken Yumi sevimli bir ifadeyle `BALIK` tabelası sallar).
* **Avantajı:** Oyuncunun hafızasıyla algısal çeldirici (Stroop etkisi) arasında eğlenceli bir psikolojik çatışma yaratır.

### 9.4 Doğrulama ve Geçiş Stratejisi
* Mevcut 0.1.13 APK'daki temel kod korunmalı; Seçenek A prototipi önce ayrı bir test fonksiyonuyla (`memory_shuffle_preview.gd`) doğrulanmalı, ardından kullanıcı onayına sunulmalıdır.

---

## 10. Görsel Efektler, Ses Mimarisi ve Haptik (Game Feel)

### 10.1 Video Referanslı Delik Derinliği ve Düşüş Dinamiği
`Mobile_game_ball_falling_hole` referansına göre uygulanan düşüş parametreleri:
* **Düşüş Süresi:** `0.44 sn`.
* **Mekânsal Hareket:** Top merkeze çekildikten sonra hızlanarak `86 px` aşağı iner.
* **Örtülme (Maskeleme):** Top deliğe girerken deliğin ön kenarı (`lip`) topun altını örter.
* **Ölçek ve Kararma:** Top aniden yok olmaz; sadece `%16` küçülür ve maksimum `%22` kararır.

### 10.2 Ses Efektleri Tetikleme Matrisi (`game_audio.gd`)

| Olay / Durum | Ses Efekti | Karakter / Davranış | Notlar |
|---|---|---|---|
| Atış Bırakma | `launch` (Fırlatma) | Şako fırlatır | Temiz, tok tıkırtı sesi |
| Duvar Teması | `bounce` (Sekme) | Top duvardan seker | Yalnız Bölüm 2'de aktif |
| Yumi Pati Uyarısı | `growl / alert` | Yumi ünlem çıkarır | Kısa ikaz |
| Yumi Pati Vuruşu | `paw` (Pati darbesi) | Yumi topa vurur | Boğuk tokat efekti |
| Uyuyan Yumi | `purr` (Mırlama döngüsü) | Yumi uyurken | Bölüm 1 ve Bölüm 2 (Aşama 1-2); mola durdurur |
| Delik Girişi | `drop / catch` | Top deliğe düşer | Video referanslı tok düşüş sesi |
| Kilit Açılma | `unlock` (Başarı) | Dolap açılır | Şık kilit sesi |
| Hata / Kilit Sıkışma | `fail` (Hata) | Yanlış delik veya 3. hata | Kırılma / kilitlenme sesi |

### 10.3 Dokunsal Geri Bildirim (Haptics Blueprint)
*Mobil cihaz ergonomisi için önerilen titreşim haritası:*
* **Nişan Başlangıcı:** Hafif tık (Light tick - `10ms`).
* **Atış Bırakma:** Orta darbe (Medium impact - `25ms`).
* **Pati Darbesi:** Çift sert titreşim (Heavy impact - `40ms + 40ms`).
* **Doğru Delik:** Başarılı onay titreşimi (Success haptic).
* **Hata / Iska:** İki kısa hata titreşimi (Error haptic).

---

## 11. Menü, Kayıt Sistemi ve Güvenilirlik

* **Dinamik Sayfalı Menü:** Sayfa başına 4 kart gösterilir (`MENU_CARDS_PER_PAGE = 4`). Sayfa 1: Bölüm 1–4; Sayfa 2: Bölüm 5 (ve gelecekteki 6–8). Sayfa geçişleri alt kısımdaki `Önceki / Sonraki` düğmeleriyle yapılır.
* **Atomik Kayıt Güvenliği (`game_progress.gd`):**
  * Veri önce `.tmp` geçici dosyasına yazılır ve doğrulanır.
  * Mevcut sağlam dosya `.bak` olarak yedeklenir.
  * `.tmp` dosyası ana kayıt dosyasına taşınır.
  * Bozuk veya eksik veri durumunda otomatik olarak `.bak` yedeğinden dönülür.
* **Mola (Pause) Yönetimi:** `P`, `Esc` veya Android arka plana geçiş (`MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT`) oyunu ve tüm zamanlayıcıları dondurur. Ön plana dönüldüğünde oyun otomatik başlamaz; oyuncunun `DEVAM` düğmesine basması gerekir.

---

## 12. Yeni Bölüm Ekleme Rehberi (Veri Odaklı Mimari)

Yeni bir yazılımcı sisteme 6. veya 7. bölümü eklemek istediğinde `main.gd` içindeki `LEVELS` dizisine aşağıdaki şemaya uygun bir veri sözlüğü eklemelidir:

```gdscript
{
    "name": "6 · BALKON MACERASI",               # Menü ve başlık adı
    "menu_description": "Açıklama metni.\nİkinci satır.",
    "sequence": [0, 1, 2, 0, 1, 2],             # Kilit sembol sırası (0: Balık, 1: Pati, 2: Yumak)
    "stage_size": 3,                             # Kasa dönüşü gerekiyorsa aşama büyüklüğü
    "ball_speed": 480.0,                         # Top fırlatma hızı (px/s)
    "yumi_active": true,                         # Yumi devrede mi?
    "yumi_speed": 120.0,                         # Yumi dolaşma hızı
    "move_directions": 4,                        # 2, 4 veya 8 yönlü hareket
    "turn_min": 1.0, "turn_max": 2.0,            # Yön değiştirme süre aralığı (s)
    "vertical_range": 40.0,                      # Ev konumundan dikey sapma payı (px)
    "warning_time": 0.30,                        # Pati uyarı süresi (s)
    "bark_budget": 3,                            # HAV hakkı
    "toy_budget": 0,                             # Varsa oyuncak fare hakkı
    "moving_holes": false,                       # Kayan delik kuralı açık mı?
    "scatter_targets": false,                    # Delik dağılma kuralı açık mı?
    "max_wall_bounces": 0,                       # 0: Duvar yasak, >0: Duvar zorunlu
    "memory_preview": 0.0,                       # >0: Gösterim süresi sonrası gizleme kuralı
    "intro": "Bölüm açılış alt bilgi mesajı."
}
```

---

## 13. Test, Doğrulama ve Devir Kontrol Listesi

Projeyi devralan yazılımcının her değişiklikte çalıştırması gereken kontroller:

1. **Toplu Regresyon Testi:** Terminalde `pwsh tests/run_checks.ps1` komutunu çalıştırın. Mevcut 23 kontrolün (fizik, dokunmatik girdi, kayıt kurtarma, menü sayfalaması, ses durumu vb.) tamamı **yeşil (PASS)** olmalıdır.
2. **Android Paket Bütünlüğü:** `pwsh tests/prepare_android.ps1` ile export alınırken:
   * APK içinde yasaklı kaynak/tablo/çıktı kalıntısı olmamalı (Audit kontrolü).
   * Manifest sürüm kodu ve arm64 mimarisi eksiksiz doğrulanmalıdır.
3. **Fiziksel Cihaz Doğrulama Protokolü:**
   * Telefon ekranında çoklu dokunma kilitleri test edilmeli.
   * Delik düşüş animasyonunda topun ön kenarın arkasında kaybolduğu gözlemlenmeli.
   * 4. Bölümde Yumi yerine dönmeden önce atış yapılamadığı doğrulanmalı.
   * 5. Bölüm için yeni tasarım kararı uygulanmadan önce kullanıcıyla Seçenek A/B/C üzerinde mutabık kalınmalıdır.
