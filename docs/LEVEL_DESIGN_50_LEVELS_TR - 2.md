# Yumi & Şako — 50 Bölümlük Genişletilmiş Seviye Tasarım Dokümanı (Bölüm 6 – 55)

**Tarih:** 13 Ekim 2026  
**Kapsam:** Mevcut 1–5 bölümlük mutfak prototipinin ardından oyunu tam bir mobil macera oyununa dönüştürecek 50 yeni bölümün (Bölüm 6–55) ayrıntılı oyun tasarımı, mekanikleri, tematik odaları ve Yumi davranış şemaları.

---

## Genel İlerleme ve Dünya (Oda) Mimarisi

Oyun 5 ana tematik dünyaya (oda) ve 1 büyük final dünyasına ayrılmıştır. Her dünyada temel atış ve kilit açma mekaniği korunurken, o mekâna özgü yeni bir çevresel fizik elemanı ve Yumi'nin yeni bir karakteristik davranışı tanıtılır.

* **Dünya 1: Mutfak & Kiler Maceraları (Bölüm 6 – 10)** → Odak: Hareketli engeller, zıplatıcılar ve fincan oyunu.
* **Dünya 2: Salon & Koltuk Altı Krallığı (Bölüm 11 – 20)** → Odak: Robot süpürge, minder sönümlemesi ve boru tünelleri.
* **Dünya 3: Koridor & Ayakkabılık Parkuru (Bölüm 21 – 30)** → Odak: Ayna yansımaları, lazer işaretleyici ve dar açı sekmesi.
* **Dünya 4: Yatak Odası & Gardırop Gizemi (Bölüm 31 – 40)** → Odak: Açılıp kapanan çekmeceler, rüzgâr/vantilatör ve gölge sembolleri.
* **Dünya 5: Balkon & Güneşli Bahçe (Bölüm 41 – 50)** → Odak: Rüzgâr yönü, güneş lekeleri (Yumi çekicisi) ve seyyar saksılar.
* **Dünya 6: Büyük Ziyafet / Kiler Finali (Bölüm 51 – 55)** → Odak: Çoklu kilitler, altın top mekaniği ve Büyük Final (Boss).

---

# DÜNYA 1: MUTFAK & KİLER (Bölüm 6 – 10)

### Bölüm 6 — Fincan Oyunu (Hafıza + Yer Değiştirme)
* **Mekân:** Mutfak tezgâhı ve mama dolabı.
* **Yeni Mekanik:** Delikler 1.5 sn boyunca sembollerini gösterir, ardından kapakları soru işareti `[?]` ile kapanır. Yumi koşarak gelir, iki deliğin yerini patiyle 0.8 sn içinde hızlıca kaydırır (fincan oyunu / üç kâğıt).
* **Şifre:** `0, 2, 1, 0, 2, 1` (6 hedef).
* **Yumi Davranışı:** Her 2 atışta bir iki deliğin yerini takas eder. Uçan topa saldırmaz; odak noktası delikleri karıştırmaktır.
* **Strateji:** Oyuncu hedefin hangi deliğe kaydığını gözleriyle takip edip kapalı deliğe nişan almalıdır.

### Bölüm 7 — Tost Makinesi Yaylanması (Bumper Mekaniği)
* **Mekân:** Mutfak masası yanı.
* **Yeni Mekanik:** Ekranın ortasında yaylanan bir tost makinesi bulunur. Top tost makinesine çarparsa hızını %30 artırarak zıplar (Pinball bumper etkisi).
* **Şifre:** `1, 0, 2, 1, 0, 2, 1, 0` (8 hedef).
* **Yumi Davranışı:** Yumi tost makinesinin arkasına saklanır; top tost makinesinden zıpladığında şaşkınlıkla zıplayıp pati atamaz.
* **Strateji:** Oyuncu doğrudan deliklere atış açısı bulamazsa tost makinesini açı verici zıplatıcı olarak kullanır.

### Bölüm 8 — Damlayan Musluk (Yörünge Saptırıcı)
* **Mekân:** Lavabo altı dolabı.
* **Yeni Mekanik:** Yukarıdan her 1.8 saniyede bir su damlası düşer. Su damlasına çarpan top dikeyde 30 piksel aşağı itilir ve hızı hafifçe kesilir.
* **Şifre:** `2, 1, 0, 2, 1, 0, 2` (7 hedef).
* **Yumi Davranışı:** Yumi sudan nefret eder! Su damlasının düştüğü dikey hatta asla yaklaşamaz.
* **Strateji:** Oyuncu su damlalarının zamanlamasını sayarak aralıktan atmalı veya su hattını Yumi'den korunma kalkanı olarak kullanmalıdır.

### Bölüm 9 — Kediotu (Catnip) Çılgınlığı
* **Mekân:** Baharat rafı altı.
* **Yeni Mekanik:** Yumi kediotu kokusu almıştır; hareket hızı 220 px/s'ye çıkar, ancak düzensiz değil, sekiz şeklinde (∞) sabit bir yörüngede koşar.
* **Şifre:** `0, 2, 1, 0, 1, 2, 0, 2` (8 hedef).
* **Yumi Davranışı:** Süper hızlıdır ancak yörüngesi tamamen öngörülebilirdir.
* **Strateji:** Oyuncu refleks yerine zamanlama (timing) kullanır; Yumi'nin sekiz çizdiği döngünün boşluk anında atışı bırakır.

### Bölüm 10 — Mutfak Şefi Finali (1. Boss: Dev Asma Kilit)
* **Mekân:** Mama dolabının ana kilidi (üç kademeli asma kilit).
* **Yeni Mekanik:** 3 delik dairesel bir çark üzerinde döner (açısal hız: 0.8 rad/s). Delikler döndükçe nişan çizgisi dinamik rota hesaplar.
* **Şifre:** `0, 1, 2 | 2, 0, 1 | 1, 2, 0` (9 hedef - 3 aşamalı).
* **Yumi Davranışı:** Çarkın tam ortasında oturur. Her 3 atışta bir çarkın dönüş yönünü tersine çevirir. HAV kullanıldığında Yumi 2 saniye boyunca başını eğer ve çark duraklar.
* **Strateji:** Çarkın dönüş hızını hesaplayarak topun varış anındaki delik pozisyonuna önleme atışı (lead shot) yapılmalıdır.

---

# DÜNYA 2: SALON & KOLTUK ALTI KRALLIĞI (Bölüm 11 – 20)

### Bölüm 11 — Halı Deseni (Yavaşlatıcı Zemin)
* **Mekân:** Kalın tüylü salon halısı.
* **Yeni Mekanik:** Ekranın alt yarısında sürtünmeli halı bölgesi vardır. Top bu alandan geçerken hızı %25 düşer, alandan çıkınca sabit hızına döner.
* **Şifre:** `1, 0, 2, 1, 0, 2` (6 hedef).
* **Yumi Davranışı:** Yumi halıda yuvarlanır, yön değiştirme sıklığı artar (0.3 - 0.7 sn).
* **Strateji:** Hız kaybı nedeniyle atış zamanlaması erken yapılmalıdır.

### Bölüm 12 — Robot Süpürge (Hareketli Kalkan)
* **Mekân:** Salon parkesi.
* **Yeni Mekanik:** Ekranın alt kısmında yatay gidip gelen bir robot süpürge (`80x40 px`) gezinir. Top süpürgeye çarparsa geri seker.
* **Şifre:** `0, 2, 1, 2, 0, 1, 0` (7 hedef).
* **Yumi Davranışı:** Yumi robot süpürgeden korkar ve süpürgenin olduğu X koordinatından en az 100 px uzakta durur.
* **Strateji:** Süpürge geçerken arkasından oluşan güvenli koridordan atış yapılır.

### Bölüm 13 — Koltuk Yastıkları (Sönümleyici Duvarlar)
* **Mekân:** Koltuk köşesi.
* **Yeni Mekanik:** Yan duvarların yarısı yumuşak yastıkla kaplıdır. Sert duvardan seken top yönünü korurken, yastığa çarpan topun sekme açısı yarıya iner (sönümlenir).
* **Şifre:** `2, 0, 1, 0, 2, 1, 2` (7 hedef).
* **Yumi Davranışı:** Yumi yastıkların üzerine tırmanabilir; yukarıdan aşağı doğru pati atar.
* **Strateji:** Duvar sekmesi gerektiren atışlarda yastık yerine açıkta kalan sert tahta kenarlar hedeflenmelidir.

### Bölüm 14 — TV Kumandası (Kanal Değişimi)
* **Mekân:** Sehpa üzeri.
* **Yeni Mekanik:** Ekranın ortasında bir TV kumandası bulunur. Top kumandanın tuşuna çarparsa deliklerin renkleri ve sembolleri sağa doğru bir sıra kayar (`Balık->Pati`, `Pati->Yumak`, `Yumak->Balık`).
* **Şifre:** `0, 1, 0, 2, 1, 2` (6 hedef).
* **Yumi Davranışı:** Kumanda her tetiklendiğinde TV'den çıkan sesten ürker ve 1.5 sn donar.
* **Strateji:** İstenmeyen bir hedef dizilimini kumandaya çarptırarak lehine çevirme taktiği.

### Bölüm 15 — İplik Yumağı Tüneli (Portal / Boru)
* **Mekân:** Örgü sepeti yanı.
* **Yeni Mekanik:** Sol alt köşede bir boru girişi, sağ üst köşede çıkışı vardır. Sol boruya giren top anında sağ borudan aynı açıyla çıkar.
* **Şifre:** `1, 2, 0, 1, 2, 0, 1, 2` (8 hedef).
* **Yumi Davranışı:** Yumi borunun çıkışında pusuya yatar. Borudan çıkan topa daha hızlı pati sallar.
* **Strateji:** Boru çıkışında HAV butonu hazır tutulmalı, top çıkar çıkmaz Yumi irkiltilmelidir.

### Bölüm 16 — Yastık Savaşı (Yıkılabilir Engeller)
* **Mekân:** Çocuk oyun alanı.
* **Yeni Mekanik:** Deliklerin önünde 3 adet devrilen yumuşak minder vardır. Birinci vuruşta minder eğrilir, ikinci vuruşta devrilip delik açılır.
* **Şifre:** `0, 0, 1, 1, 2, 2, 0, 1` (8 hedef).
* **Yumi Davranışı:** Devrilen minderin arkasına saklanır; oyuncuya sürpriz pati atabilir.
* **Strateji:** Şifredeki sıradaki deliğin önündeki minderi önce kırmak gerekir.

### Bölüm 17 — Kağıt Kutu (Gizli Geçit)
* **Mekân:** Boş kargo kutusu.
* **Yeni Mekanik:** Kutunun içine giren top 0.4 sn boyunca görünmez olur ve kutunun diğer tarafından çıkar.
* **Şifre:** `2, 1, 2, 0, 1, 0, 2` (7 hedef).
* **Yumi Davranışı:** Yumi kutunun içine girmeyi çok sever! Kutuya oyuncak fare atılırsa Yumi kutunun içine girer ve 4 saniye boyunca kutudan çıkmaz.
* **Strateji:** Kutuyu oyuncak fareyle doldurup Yumi'yi hapsetmek.

### Bölüm 18 — Sallanan Avize Gölgesi (Dinamik Aydınlatma)
* **Mekân:** Tavandan sarkan avize.
* **Yeni Mekanik:** Avizenin gölgesi ekranda sola-sağa sallanır. Gölge altında kalan deliğin sembolü görünmez olur.
* **Şifre:** `0, 2, 1, 1, 0, 2, 0, 1` (8 hedef).
* **Yumi Davranışı:** Yumi gölgenin peşinden koşar, aydınlık yerlere gitmek istemez.
* **Strateji:** Yumi'nin gölgede oyalanmasını fırsat bilip aydınlık deliklere rahat atış yapmak.

### Bölüm 19 — Gazete Tomarı (Rampa Mekaniği)
* **Mekân:** Gazetelik yanı.
* **Yeni Mekanik:** Ekranda açılı duran bir gazete tomarları rampası vardır. Rampadan geçen top dikey ivme kazanıp fırlar.
* **Şifre:** `1, 0, 2, 0, 1, 2, 1` (7 hedef).
* **Yumi Davranışı:** Rampanın tepesinde oturur, rampadan gelen toplara yüksekten smaç patisi basar.
* **Strateji:** HAV ile Yumi'yi rampadan düşürmek veya rampayı es geçerek duvardan sekip arkadan dolaşmak.

### Bölüm 20 — Salon Finali (2. Boss: Akıllı Robot Süpürge ve Yumi İttifakı)
* **Mekân:** Salonun ortasındaki dev şarj istasyonu kilidi.
* **Yeni Mekanik:** Yumi robot süpürgenin üzerine binmiştir! Süpürge soldan sağa gezinirken Yumi hareketli bir taret gibi sürekli pati sallamaya hazırdır.
* **Şifre:** `0, 1, 2, 0 | 2, 1, 0, 2 | 1, 0, 2, 1` (12 hedef).
* **Yumi Davranışı:** Robot süpürge üzerinde hareketli olduğu için devasa bir engelleme alanı oluşturur.
* **Strateji:** Oyuncak fare süpürgenin rotasına atılırsa Yumi süpürgenin üstünden atlar; süpürge ise fareye çarpıp yön değiştirir. İki düşman birbirinden ayrılınca kilide atış yolu açılır.

---

# DÜNYA 3: KORİDOR & AYAKKABILIK PARKURU (Bölüm 21 – 30)

### Bölüm 21 — Dar Koridor (Aşırı Sekme)
* **Mekân:** Dar hol duvarları.
* **Yeni Mekanik:** Ekranın yan duvarları birbirine yaklaşmıştır (`Genişlik: 360 px`). Top yan duvarlardan defalarca seker (maksimum 4 sekme izni).
* **Şifre:** `0, 2, 1, 0, 2, 1` (6 hedef).
* **Yumi Davranışı:** Yumi dar alanda sıkışmıştır, dikey eksende hızlıca zıplar.
* **Strateji:** Zikzak açılarını iyi hesaplamak; dar açılı atışlar çoklu sekme üretir.

### Bölüm 22 — Boy Aynası (Yansıma Nişangâhı)
* **Mekân:** Koridor aynası yanı.
* **Yeni Mekanik:** Sol duvarda kusursuz bir ayna vardır. Nişangâh aynaya çarptığında lazer çizgisi gibi keskin ve uzun bir yansıma çizgisi çizer.
* **Şifre:** `1, 0, 2, 2, 1, 0, 1` (7 hedef).
* **Yumi Davranışı:** Yumi aynadaki kendi aksine hırlar; sol tarafa doğru sürekli pati savurur.
* **Strateji:** Aynadaki yansıma çizgisini kullanarak sağdaki deliklere dolaylı atış yapmak.

### Bölüm 23 — Lazer Noktası (Kedi Yönlendirme)
* **Mekân:** Koridor halısı.
* **Yeni Mekanik:** Oyuncu ekrana ikinci parmağıyla dokunduğunda kırmızı bir lazer noktası belirir. Yumi top yerine lazer noktasını takip eder!
* **Şifre:** `2, 0, 1, 0, 2, 1, 0, 2` (8 hedef).
* **Yumi Davranışı:** Lazer neredeyse oraya koşar, topu tamamen unutur.
* **Strateji:** Sol elle lazere dokunup Yumi'yi sağ köşeye çekmek, sağ elle boş kalan sol deliğe top fırlatmak (İki el koordinasyonu).

### Bölüm 24 — Kaygan Parke (Sürtünmesiz Hızlanma)
* **Mekân:** Yeni cilalanmış koridor zemini.
* **Yeni Mekanik:** Zemin sürtünmesizdir; top sektiğinde hız kaybetmez, tam tersine hızı 540 px/s'ye fırlar.
* **Şifre:** `0, 1, 2, 1, 0, 2` (6 hedef).
* **Yumi Davranışı:** Yumi parkede kayar! Durmaya çalıştığında patileri patinaj yapar ve 40 px ileri kayar.
* **Strateji:** Yumi'nin patinaj süresini hesaba katarak arkasındaki boşluğa nişan almak.

### Bölüm 25 — Terlik Barikatı (Dönen Engel)
* **Mekân:** Ayakkabılık önü.
* **Yeni Mekanik:** İki adet terlik kendi merkezi etrafında yavaşça döner (`Açısal hız: 1.2 rad/s`).
* **Şifre:** `1, 2, 0, 2, 1, 0, 1` (7 hedef).
* **Yumi Davranışı:** Terliklerin arasına yatıp uyumayı dener; terlik döndükçe uyanır.
* **Strateji:** Dönen terliklerin açık kanat aralığından topu geçirmek.

### Bölüm 26 — Çift Zil (Sesli Çeldirici)
* **Mekân:** Kapı zili altı.
* **Yeni Mekanik:** Duvarda iki adet küçük çıngırak vardır. Top çıngırağa değerse ses çıkarır ve Yumi hemen o çıngırağa doğru hamle yapar.
* **Şifre:** `0, 2, 1, 0, 1, 2, 0` (7 hedef).
* **Yumi Davranışı:** Zil sesine aşırı duyarlıdır.
* **Strateji:** Kasıtlı olarak sağdaki zile topu hafifçe çarptırıp Yumi'yi sağa çekmek, ardından asıl deliğe yönelmek.

### Bölüm 27 — Şemsiyelik (Ters Açı Hunisi)
* **Mekân:** Giriş şemsiyeliği.
* **Yeni Mekanik:** Huni şeklinde bir sepet vardır. Top içine girerse dönerek merkezden yukarı fırlar.
* **Şifre:** `2, 1, 0, 2, 0, 1, 2` (7 hedef).
* **Yumi Davranışı:** Huninin kenarına tutunur, kafasını içeri sokar.
* **Strateji:** Huniyi kullanarak Yumi'nin pati menzilini bypass etmek.

### Bölüm 28 — Ayakkabı Bağı Kapanı (Esnek Yay)
* **Mekân:** Spor ayakkabılar yanı.
* **Yeni Mekanik:** İki nokta arasında gerilmiş lastik ayakkabı bağı vardır. Top çarparsa sapan gibi geri fırlar.
* **Şifre:** `1, 0, 2, 1, 2, 0, 1, 0` (8 hedef).
* **Yumi Davranışı:** Bağlarla oynamayı sever; lastiği gerip aniden bırakarak topu rastgele fırlatabilir.
* **Strateji:** Lastiğin fırlatma vektörünü doğru açı için avantaj olarak kullanmak.

### Bölüm 29 — Gölge Oyunu (Gizli Delikler)
* **Mekân:** Koridor aplik lambası altı.
* **Yeni Mekanik:** Delikler sabit değildir; lamba periyodik olarak söner (1.0 sn karanlık, 2.0 sn aydınlık). Karanlıkta delikler görünmez ancak çarpışma alanları aktiftir.
* **Şifre:** `0, 2, 1, 0, 2, 1` (6 hedef).
* **Yumi Davranışı:** Karanlıkta gözleri parlar (yeşil iki nokta) ve karanlıkta daha hızlı pati atar.
* **Strateji:** Aydınlıkken pozisyonları zihne kazıyıp karanlıkta Yumi'nin gözlerinin olmadığı boşluğa atmak.

### Bölüm 30 — Koridor Finali (3. Boss: Boy Aynası Çift Yumi İllüzyonu)
* **Mekân:** Boy aynasının tam karşısı.
* **Yeni Mekanik:** Ekranda iki Yumi vardır: Biri gerçek Yumi, diğeri aynadaki yansıma Yumi! Yansıma Yumi simetrik hareket eder ancak pati atamaz (illüzyondur).
* **Şifre:** `0, 1, 2, 2, 0, 1 | 1, 2, 0, 0, 2, 1` (12 hedef).
* **Yumi Davranışı:** Hangisinin gerçek olduğunu anlamak için pati uyarısındaki gölgeye bakılmalıdır; yansıma Yumi'nin gölgesi yoktur.
* **Strateji:** Gerçek Yumi'yi ayırt edip ona karşı HAV kullanmak, sahte Yumi'den korkmadan atış yapmak.

---

# DÜNYA 4: YATAK ODASI & GARDIROP GİZEMİ (Bölüm 31 – 40)

### Bölüm 31 — Açılan Çekmeceler (Kademeli Yükseklik)
* **Mekân:** Komodin çekmeceleri.
* **Yeni Mekanik:** Delikler farklı derinliklerdeki 3 çekmecenin içindedir. Çekmeceler sırayla açılıp kapanır (periyot: 2.2 sn). Kapalı çekmeceye top giremez, kapağından geri seker.
* **Şifre:** `0, 1, 2, 1, 0, 2` (6 hedef).
* **Yumi Davranışı:** Açık çekmecenin içine atlar; çekmece kapanırken dışarı fırlar.
* **Strateji:** Sıradaki sembolün çekmecesinin tam açılma anına nişan almak.

### Bölüm 32 — Vantilatör Rüzgârı (Yanal Kuvvet)
* **Mekân:** Yatak ucu vantilatörü.
* **Yeni Mekanik:** Soldan sağa doğru sabit bir rüzgâr akımı vardır. Top havada uçarken sağa doğru kavis çizer (parabolik yörünge).
* **Şifre:** `2, 0, 1, 0, 2, 1, 0` (7 hedef).
* **Yumi Davranışı:** Rüzgâr karşısında tüyleri kabarır; rüzgâra karşı yürürken hızı yarıya iner (`50 px/s`).
* **Strateji:** Rüzgâr sapmasını hesaba katarak deliğin soluna nişan almak (açı düzeltmesi).

### Bölüm 33 — Kuştüyü Yastık (Ağırlaşan Top Fiziği)
* **Mekân:** Yatak başlığı.
* **Yeni Mekanik:** Havada uçuşan tüyler vardır. Top tüye değerse tüy topa yapışır; top ağırlaşır ve yerçekimi etkisiyle hızı hızla düşer.
* **Şifre:** `1, 2, 0, 2, 1, 0, 1` (7 hedef).
* **Yumi Davranışı:** Havada uçuşan tüyleri yakalamaya çalışır, topu ikinci plana atar.
* **Strateji:** Tüylerden kaçınarak temiz koridordan atış yapmak.

### Bölüm 34 — Yatak Örtüsü Dalgalanması (Zemin Titreşimi)
* **Mekân:** Saten yatak örtüsü.
* **Yeni Mekanik:** Delikler dalgalanan örtünün üzerinde hafifçe yukarı-aşağı salınır (`Y ekseni ±35 px`).
* **Şifre:** `0, 2, 1, 0, 2, 1, 2` (7 hedef).
* **Yumi Davranışı:** Örtünün altında gizlenir! Sadece kabarıklık olarak gezinir; top yaklaşınca örtünün altından pati uzatır.
* **Strateji:** Örtüdeki kabarıklığın konumunu izleyerek gizli Yumi'den kaçmak.

### Bölüm 35 — Gece Lambası (Renk Filtresi)
* **Mekân:** Abajur yanı.
* **Yeni Mekanik:** Lamba periyodik olarak renk değiştirir (Mavi, Kırmızı, Mor). Lamba hangi renkteyse o renkteki delik parlar ve yakalama yarıçapı %30 genişler!
* **Şifre:** `0, 1, 2, 0, 1, 2, 0, 1` (8 hedef).
* **Yumi Davranışı:** Lambanın rengine göre ruh hali değişir; kırmızıda agresif, mavide sakinleşir.
* **Strateji:** Sıradaki sembolün parladığı anı yakalayarak geniş toleransla rahat atış yapmak.

### Bölüm 36 — Gardırop Aynası Labirenti
* **Mekân:** Üç kapaklı gardırop aynaları.
* **Yeni Mekanik:** 3 ayna yüzeyi farklı açılarda durur. Doğru deliğe ulaşmak için en az iki aynadan sekme yapmak şarttır.
* **Şifre:** `2, 0, 1, 1, 2, 0, 2` (7 hedef).
* **Yumi Davranışı:** Aynaların arasında dolaşır; aynadan seken topları yakalamakta zorlanır.
* **Strateji:** İkili ayna geometrisini çözüp köşeli atış yapmak.

### Bölüm 37 — Çorap Yumağı (İkiz Top Mekaniği)
* **Mekân:** Dağınık çorap çekmecesi.
* **Yeni Mekanik:** Fırlatıcı tek top yerine birbirine iple bağlı iki top fırlatır! İki top dönerken herhangi birinin doğru deliğe girmesi yeterlidir.
* **Şifre:** `1, 0, 2, 0, 1, 2` (6 hedef).
* **Yumi Davranışı:** Çift topu görünce kafası karışır; birine pati atarken diğeri kurtulabilir.
* **Strateji:** Dönen ikiz topun geniş süpürme alanından faydalanmak.

### Bölüm 38 — Uyku Vakti (Kademeli Sessizlik)
* **Mekân:** Gece yarısı sessizliği.
* **Yeni Mekanik:** Bu bölümde HAV hakkı sınırlıdır; HAV tuşuna basıldığında Şako yüksek sesle havlarsa "GÜRÜLTÜ SAYACI" artar. 2 havlamada oda lambası yanar ve bölüm sıfırlanır!
* **Şifre:** `0, 2, 1, 2, 0, 1, 0, 2` (8 hedef).
* **Yumi Davranışı:** Yumi yarı uykuludur ama havlamaya karşı aşırı duyarlıdır.
* **Strateji:** HAV mekanizmasını hiç kullanmadan saf nişan ve zamanlama ile bitirmek.

### Bölüm 39 — Yaylı Yatak Zıplaması (Dikey Sıçrama)
* **Mekân:** Yaylı yatak şiltesi.
* **Yeni Mekanik:** Ekranın alt kısmında esnek yay alanı vardır. Top aşağı düşerken bu yaylara değerse tekrar yukarı, deliklerin hizasına doğru fırlar (ikinci şans mekaniği).
* **Şifre:** `1, 2, 0, 1, 0, 2, 1` (7 hedef).
* **Yumi Davranışı:** Yayların üstünde zıplar; zıplama anında havadayken savunmasızdır.
* **Strateji:** Iska geçen topu yaylardan zıplatıp geri dönüşte hedefe sokmak.

### Bölüm 40 — Yatak Odası Finali (4. Boss: Gardırop Canavarı Yumi)
* **Mekân:** Gardırobun tepesindeki gizli mama saklama yeri.
* **Yeni Mekanik:** Gardırobun 3 kapısı vardır. Delikler kapıların arkasındadır. Yumi gardırobun tepesinden sarkar ve kapıları pati darbeleriyle sırayla açıp kapatır.
* **Şifre:** `0, 1, 2, 0 | 1, 2, 0, 1 | 2, 0, 1, 2` (12 hedef).
* **Yumi Davranışı:** Tepeden sarktığı için geniş bir dikey alanı kontrol eder.
* **Strateji:** Yumi bir kapıyı açtığı anda o kapının arkasındaki deliğe anında atış göndermek; oyuncak fare gardırobun içine atılırsa Yumi içeri dalar ve tüm kapılar 3 saniyeliğine açık kalır.

---

# DÜNYA 5: BALKON & GÜNEŞLİ BAHÇE (Bölüm 41 – 50)

### Bölüm 41 — Balkon Demirleri (Aralıklı Izgara)
* **Mekân:** Güneşli balkon korkulukları.
* **Yeni Mekanik:** Deliklerin önünde dikey balkon demirleri vardır. Top sadece demirlerin arasındaki 28 piksellik boşluklardan geçebilir.
* **Şifre:** `0, 1, 2, 1, 0, 2` (6 hedef).
* **Yumi Davranışı:** Demirlerin arasından pati uzatır; menzili dardır ama hızlıdır.
* **Strateji:** Milimetrik dikey açı hassasiyeti ile demir aralıklarını vurmak.

### Bölüm 42 — Güneş Lekesi (Kedi Tuzağı)
* **Mekân:** Balkon karoları.
* **Yeni Mekanik:** Balkona vuran güneş ışığı yeri değiştirir (`5 dakikada bir kayan güneş spotu`). Yumi güneş lekesinin olduğu yere gidip kıvrılır ve orada mırıldanarak uyur!
* **Şifre:** `2, 0, 1, 0, 2, 1, 2` (7 hedef).
* **Yumi Davranışı:** Güneş lekesi neredeyse oraya sabitlenir, güneşten çıkmak istemez.
* **Strateji:** Güneş lekesinin olmadığı koridorları kullanarak engelsiz atış yapmak.

### Bölüm 43 — Rüzgâr Gülü (Dinamik Açı Saptırıcı)
* **Mekân:** Balkon saksısına saplanmış renkli rüzgâr gülü.
* **Yeni Mekanik:** Rüzgâr gülü rüzgârın şiddetine göre hızla döner. Top kanatlarına çarparsa kanadın o anki açısına göre beklenmedik bir yöne fırlar.
* **Şifre:** `1, 0, 2, 1, 2, 0, 1` (7 hedef).
* **Yumi Davranışı:** Rüzgâr gülünü patisiyle döndürmeye bayılır; döndürdükçe hızı artar.
* **Strateji:** Rüzgâr gülünün durduğu anı beklemek veya HAV ile Yumi'yi korkutup pervaneyi durdurmak.

### Bölüm 44 — Çiçek Saksıları (Sallanan Sarkaçlar)
* **Mekân:** Tavandan asılı saksılar.
* **Yeni Mekanik:** 2 saksı sarkaç gibi sağa sola sallanır. Deliklerin önünü periyodik olarak kapatır.
* **Şifre:** `0, 2, 1, 0, 1, 2, 0, 2` (8 hedef).
* **Yumi Davranışı:** Saksıların arkasına saklanıp aniden fırlar.
* **Strateji:** Sarkaç fiziğinin tepe noktalarında (hızın sıfırlandığı anlarda) atış yapmak.

### Bölüm 45 — Güvercin Ziyareti (Geçici Hareketli Hedef)
* **Mekân:** Balkon mermeri.
* **Yeni Mekanik:** Ara sıra balkona bir güvercin konar. Top güvercine çarparsa güvercin kanat çırparak uçar ve deliklerin etrafındaki hava akımını dağıtır.
* **Şifre:** `2, 1, 0, 2, 0, 1, 2` (7 hedef).
* **Yumi Davranışı:** Güvercini görünce av moduna geçer (yere yapışıp yavaşça sürünür - stalking modu). Topu tamamen unutur!
* **Strateji:** Güvercin sahnede kaldığı sürece Yumi tehdidi sıfırdır; hızlıca ardışık atışlar yapılmalıdır.

### Bölüm 46 — Su Hortumu (Basınçlı İtme)
* **Mekân:** Balkon yıkama hortumu.
* **Yeni Mekanik:** Ekranın altından çapraz su fışkırtan bir hortum vardır. Top su jetine girerse basınçla roket gibi yukarı fırlar.
* **Şifre:** `1, 0, 2, 1, 0, 2, 1` (7 hedef).
* **Yumi Davranışı:** Sudan kaçmak için sürekli yukarıda tünemiş vaziyettedir.
* **Strateji:** Su jetini hızlandırıcı olarak kullanarak hedefe süper hızlı top ulaştırmak.

### Bölüm 47 — Çamaşır İpi (Salınan Engeller)
* **Mekân:** Asılı çamaşırlar.
* **Yeni Mekanik:** Balkonda asılı duran iki havlu rüzgârda dalgalanır. Havluya çarpan top yumuşakça yere düşer (hata sayılır).
* **Şifre:** `0, 2, 1, 2, 0, 1, 0, 2` (8 hedef).
* **Yumi Davranışı:** Havluların arasından saklambaç oynar gibi bakar.
* **Strateji:** Havluların rüzgârla yana açıldığı boşluk anında atışı bırakmak.

### Bölüm 48 — Cam Balkon Sürgüsü (Açılıp Kapanan Duvar)
* **Mekân:** Sürgülü cam balkon.
* **Yeni Mekanik:** Cam kanat her 3 saniyede bir sola ve sağa kayar. Cam kapalıyken şeffaf bir sekme duvarı oluşturur, açıkken top dışarı uçup ıskalayabilir.
* **Şifre:** `1, 2, 0, 1, 2, 0, 1` (7 hedef).
* **Yumi Davranışı:** Cama sinek konduğunda cama pati vurur; cam titrer ve topun sekme açısını değiştirir.
* **Strateji:** Camın kapalı olduğu anı yakalayıp bilardo sekmesiyle içeri göndermek.

### Bölüm 49 — Kelebek Kovalama (Öngörülemez Yumi)
* **Mekân:** Çiçekli balkon kenarı.
* **Yeni Mekanik:** Ekranda sarı bir kelebek uçuşur. Yumi kelebeğin peşinde kaotik bir şekilde zıplar, koşar ve takla atar.
* **Şifre:** `0, 1, 2, 0, 2, 1, 0, 1` (8 hedef).
* **Yumi Davranışı:** Topa özel bir kastı yoktur; kelebeği kovalarken kazara topa çarpabilir veya kazara topu deliğe sokabilir!
* **Strateji:** Kelebeğin deliklerden uzakta olduğu anlarda güvenli atış yapmak.

### Bölüm 50 — Balkon Finali (5. Boss: Kuş Evi Tepesi Zirvesi)
* **Mekân:** Balkon çatısındaki büyük ahşap kiler dolabı.
* **Yeni Mekanik:** Delikler rüzgâr gülü çarkı üzerinde sürekli dönerken, balkon rüzgârı yönünü her 4 saniyede bir değiştirir (Rüzgâr bayrağı yönü gösterir).
* **Şifre:** `0, 1, 2, 1 | 2, 0, 1, 0 | 1, 2, 0, 2` (12 hedef).
* **Yumi Davranışı:** Kuş evinin çatısından aşağı doğru çift patiyle saldırır.
* **Strateji:** Rüzgâr yönünü, dönen çarkı ve Yumi'nin hava saldırısını aynı anda hesaplayan usta seviye atışlar.

---

# DÜNYA 6: BÜYÜK ZİYAFET & KİLER FİNALİ (Bölüm 51 – 55)

### Bölüm 51 — Konserve Kulesi (Fizik Yıkımı)
* **Mekân:** Kilerdeki konserve kutuları yığını.
* **Yeni Mekanik:** Deliklerin önünde konserve kutularından bir kule vardır. Kuleye top çarptıkça kutular devrilir ve deliklerin önü temizlenir.
* **Şifre:** `0, 2, 1, 0, 2, 1, 0` (7 hedef).
* **Yumi Davranışı:** Kutular devrildikçe çıkan sesten korkup 2 saniye boyunca kaçışır.
* **Strateji:** İlk 2 atışta kuleyi yıkıp yolu açmak, ardından kilit dizisini tamamlamak.

### Bölüm 52 — Altın Kemik Topu (Delip Geçen Özel Top)
* **Mekân:** Kilerin gizli kasası.
* **Yeni Mekanik:** Şako'ya her 3 atışta bir parlayan "Altın Top" verilir. Altın top Yumi'nin patisinden etkilenmez ve tüm engelleri delip doğrudan deliğe girer!
* **Şifre:** `1, 0, 2, 2, 1, 0, 1, 2` (8 hedef).
* **Yumi Davranışı:** Altın topa pati atmaya çalışır ancak patisi acır ve geri çekilir.
* **Strateji:** Normal toplarda Yumi'yi oyalayıp altın top geldiğinde en zor deliğe doğrudan nişan almak.

### Bölüm 53 — Çift Kilit Mekanizması (Eşzamanlı Şifre)
* **Mekân:** Ağır kiler demir kapısı.
* **Yeni Mekanik:** Ekranda iki ayrı şifre dizisi vardır (Biri Şako'nun kemik kilidi, biri Yumi'nin balık kilidi). Oyuncu sırayla bir sola bir sağa doğru sembolü göndermelidir.
* **Şifre:** `Sol: 0, 1, 2 | Sağ: 2, 1, 0 | Sol: 1, 2, 0 | Sağ: 0, 2, 1` (12 hedef).
* **Yumi Davranışı:** Yumi kendi kilidine yardım etmeye çalışır! Kendi sembolü (Balık/Yumak) gelince topu doğru deliğe itmeye yardım eder.
* **Strateji:** Yumi'nin yardımlarını kendi lehine kullanarak çift kilidi çözmek.

### Bölüm 54 — Karanlıkta Kayan Şifre (Mega Hafıza & Refleks)
* **Mekân:** Elektrikleri kesilmiş kiler odası.
* **Yeni Mekanik:** Bölüm 3 (kayan kilit), Bölüm 4 (dağılan delikler) ve Bölüm 5 (hafıza gizleme) tek bir potada erir! Delikler dağılır, semboller 1.5 sn gösterilip kapanır ve delikler hafifçe salınır.
* **Şifre:** `0, 2, 1, 1, 0, 2, 0, 1, 2` (9 hedef).
* **Yumi Davranışı:** Gece görüşü aktiftir; fosforlu gözleriyle deliklerin arasında mekik dokur.
* **Strateji:** Oyuncunun hafıza, hareket tahmini ve HAV zamanlamasını kusursuz harmanlaması gerekir.

### Bölüm 55 — BÜYÜK FİNAL: Mama Dağı & Ziyafet Şöleni (Ultra Boss)
* **Mekân:** Dev kiler kapısı, arkasında tepeleme mama çuvalları ve ödül kemikleri.
* **Aşama 1 (Kilit Kırma):** 3 delik döner, Yumi süper hızlı dolaşır. (4 doğru atış).
* **Aşama 2 (Duvar ve Rüzgâr):** Yan duvarlar aktif, hafif rüzgâr sapması var. (4 doğru atış).
* **Aşama 3 (Büyük İş Birliği):** Şako son 4 topu atarken Yumi artık sabotajı bırakır! Yumi hedeflerin önüne geçip yanlış deliğe gidecek toplara pati vurarak onları DOĞRU deliğe yönlendirir! (Kedi ve köpeğin mamaya ulaşmak için efsanevi dostluğu).
* **Şifre:** `0, 1, 2, 0 | 2, 0, 1, 2 | 1, 2, 0, 1` (12 hedef).
* **Kutlama Sekansı:** Dev dolap kapısı açılır, yüzlerce mama tanesi ve balık ödülü ekrana saçılır. Şako ve Yumi yan yana mamaları yerken oyun sonu tebrik ekranı ve "Tüm Bölümler Tamamlandı!" kadehi görünür.

---

## 14. Teknik Geliştirme ve Uygulama Notları (Gelecek Sprintler)

1. **Varlık (Asset) İhtiyaçları:**
   * Yeni Oda Arka Planları: Salon (`living-room-v1.png`), Koridor (`corridor-v1.png`), Yatak Odası (`bedroom-v1.png`), Balkon (`balcony-v1.png`), Kiler (`pantry-v1.png`).
   * Çevresel Sprite'lar: Robot süpürge, minder, ayna efekti, vantilatör, saksı, konserve kutusu, altın top.
2. **Fizik Katmanı Genişletmeleri (`main.gd`):**
   * Rüzgâr / Yanal ivme fonksiyonu: `ball_velocity.x += wind_force * delta`.
   * Çarpışma Bumper / Zıplatıcı: Belirli objelerde `bounce_multiplier = 1.3`.
   * Lazer İşaretleyici: `_input` içinde çoklu dokunma (`event.index == 1`) ile `laser_pos` güncelleme.
3. **Kayıt ve İlerleme Sistemi:**
   * Sayfalı menü altyapısı (`MENU_CARDS_PER_PAGE = 4`) zaten hazır olduğu için, 55 bölüm 14 sayfa halinde sorunsuz listelenecektir.
