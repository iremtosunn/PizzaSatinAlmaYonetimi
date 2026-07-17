# Pizza Fabrikası Satın Alma Yönetim Modülü
## Project Overview
Pizza Fabrikası Satın Alma Yönetim Modülü, fabrikanın satın alma süreçlerini dijital ortamda yönetmek amacıyla geliştirilmektedir.

Sistem; satın alma taleplerinin oluşturulması, tedarikçilerden teklif alınması, tekliflerin sisteme kaydedilmesi, tekliflerin karşılaştırılması, satın alma yöneticisi onay süreci ve sipariş oluşturma işlemlerini kapsamaktadır.

Bu doküman, projenin tüm iş kurallarını, kullanıcı rollerini, veritabanı yapısını ve kullanıcı arayüzlerini açıklamak amacıyla hazırlanmıştır. Aynı zamanda yapay zekâ destekli yazılım geliştirme araçlarının projeyi doğru anlayabilmesi için proje bağlamını (Project Context) sağlamaktadır.

## Project Goals

Bu projenin amacı pizza fabrikasının satın alma süreçlerini dijital ortama taşıyarak süreçlerin daha hızlı, güvenli ve takip edilebilir şekilde yürütülmesini sağlamaktır.

Sistem sayesinde;

- Satın alma talepleri oluşturulabilir.
- Tedarikçilerden teklifler alınabilir.
- Teklifler sisteme kaydedilebilir.
- Teklifler karşılaştırılabilir.
- En uygun teklif seçilebilir.
- Satın alma yöneticisi onay verebilir.
- Satın alma siparişi oluşturulabilir.
- Tüm işlemler raporlanabilir.
## User Roles
Sistemde dört temel kullanıcı rolü bulunmaktadır.

### Satın Alma Yöneticisi

- Satın alma süreçlerini yönetir.
- Teklifleri değerlendirir.
- Satın alma siparişlerini onaylar.
- Raporları görüntüler.
- Kullanıcı ve rol yönetimini gerçekleştirir.

### Satın Alma Uzmanı

- Satın alma taleplerini inceler.
- Uygun tedarikçileri belirler.
- Tedarikçilerden teklif toplar.
- Teklifleri sisteme kaydeder.
- Teklifleri karşılaştırır.
### Talep Oluşturan Kullanıcı

- Satın alma talebi oluşturur.
- Oluşturduğu talepleri takip eder.

### Tedarikçi

- Satın alma uzmanına ürün ve hizmet tekliflerini iletir.
- Fiyat ve teslim süresi bilgilerini paylaşır.
## Authorization Structure

Sistemde rol tabanlı yetkilendirme (Role Based Access Control - RBAC) kullanılmaktadır.

Her kullanıcı sisteme giriş yaptığında kendisine atanmış Rol bilgisi okunur. Daha sonra RolYetkileri tablosu üzerinden bu role ait yetkiler belirlenir.

Arayüzde bulunan butonlar, menüler ve işlemler kullanıcının sahip olduğu yetkilere göre görüntülenir veya gizlenir.

Örnek:

- KullaniciEkle
- KullaniciListe
- RolYonet
- TeklifGir
- TeklifKarsilastir
- SatinAlmaOnayla
- RaporGoruntule

Bir kullanıcı "KullaniciEkle" yetkisine sahip değilse Yeni Kullanıcı butonu görüntülenmez.
## Business Workflow
1. Talep oluşturan kullanıcı satın alma talebi oluşturur.
2. Satın alma uzmanı talebi inceler.
3. Uygun tedarikçiler belirlenir.
4. Tedarikçilerden teklifler alınır.
5. Satın alma uzmanı teklifleri sisteme kaydeder.
6. Teklif kalemleri sisteme kaydedilir.
7. Teklifler karşılaştırılır.
8. En uygun teklif seçilir.
9. Satın alma yöneticisi onay verir.
10. Satın alma siparişi oluşturulur.
11. Süreç tamamlanır.
## Database Design
Sistem Microsoft SQL Server veritabanı kullanılarak tasarlanmıştır.

Veritabanı ilişkisel (Relational Database) yapısına sahiptir.

Temel tablolar aşağıdaki gibidir.

### Kullanicilar

Sistem kullanıcılarının giriş bilgilerini ve rol bilgilerini tutar.

### Roller

Sistemde bulunan kullanıcı rollerini tutar.

### Yetkiler

Sistemde kullanılacak tüm yetkileri içerir.

### RolYetkileri

Roller ile yetkiler arasındaki ilişkiyi tutar.

### Firmalar

Çalışılan firmaların bilgilerini tutar.

### FirmaKullanicilari

Firmalarda çalışan kişilerin bilgilerini tutar.

### Tedarikciler

Satın alma sürecinde teklif veren tedarikçileri tutar.

### SatinAlmaTalepleri

Oluşturulan satın alma taleplerini tutar.

### Teklifler

Tedarikçilerden alınan tekliflerin genel bilgilerini tutar.

### TeklifKalemleri

Bir teklif içerisinde bulunan ürün veya hizmet kalemlerini tutar.

### SatinAlmaSiparisleri

Onaylanan teklifler sonucunda oluşturulan siparişleri tutar.

### Bildirimler

Sistem tarafından kullanıcılara gönderilen bildirimleri tutar.
## Business Rules
- Her kullanıcı yalnızca bir role sahiptir.
- Bir rol birden fazla yetkiye sahip olabilir.
- Aynı yetki birden fazla role atanabilir.
- Tedarikçiler sisteme doğrudan teklif girmez.
- Teklif bilgileri satın alma uzmanı tarafından sisteme kaydedilir.
- Bir teklif birden fazla teklif kaleminden oluşabilir.
- Satın alma siparişi yalnızca onaylanan teklif için oluşturulur.
- Durum alanları ENUM mantığı ile yönetilir.
- Şifreler düz metin olarak saklanmaz.
- Şifreler hash algoritması ile saklanmalıdır.
## User Interface
Sistem aşağıdaki ekranlardan oluşmaktadır.

- Giriş Ekranı
- Dashboard
- Kullanıcı Yönetimi
- Rol Yönetimi
- Tedarikçi Yönetimi
- Satın Alma Talepleri
- Teklif Girişi
- Teklif Karşılaştırma
- Satın Alma Onay
- Bildirimler
- Raporlar
- Ayarlar
## Technology Stack
Bu proje aşağıdaki teknolojiler kullanılarak geliştirilecektir.

- React
- .NET
- SQl Server
- GitHub

## AI Development Instructions

Bu doküman referans alınarak proje geliştirilmelidir.

- Veritabanı tasarımına uyulmalıdır.
- ER diyagramına uyulmalıdır.
- Analiz dokümanına uyulmalıdır.
- Kullanıcı rolleri dikkate alınmalıdır.
- Yetkilendirme yapısı korunmalıdır.
- UI tasarımlarına uygun ekranlar geliştirilmelidir.
## Project Structure
Bu proje aşağıdaki modüllerden oluşmaktadır.

- Authentication
- Dashboard
- Kullanıcı Yönetimi
- Rol Yönetimi
- Yetki Yönetimi
- Firma Yönetimi
- Tedarikçi Yönetimi
- Satın Alma Talepleri
- Teklif Yönetimi
- Teklif Kalemleri
- Teklif Karşılaştırma
- Satın Alma Onayı
- Bildirimler
- Raporlar
- Ayarlar

## Database Tables
Sistemde aşağıdaki veritabanı tabloları bulunmaktadır.

- Kullanicilar
- Roller
- Yetkiler
- RolYetkileri
- Firmalar
- FirmaKullanicilari
- Tedarikciler
- SatinAlmaTalepleri
- Teklifler
- TeklifKalemleri
- SatinAlmaSiparisleri
- Bildirimler
---

# Nihai Proje Kararları ve Güncel Teknik Kapsam

Bu bölüm, proje geliştirme sürecinde kesinleşen güncel kararları içerir. Önceki bölümlerle bir çelişki olması durumunda bu bölümdeki bilgiler esas alınacaktır.

## 1. Proje Senaryosu

Proje, bir pizza üretim fabrikasının satın alma süreçlerini yönetmek amacıyla geliştirilen web tabanlı bir Satın Alma Yönetim Sistemidir.

Sistemde aşağıdaki kullanıcı grupları bulunmaktadır:

- Satın Alma Yöneticisi
- Satın Alma Uzmanı
- Talep Oluşturan Kullanıcı
- Tedarikçi

Temel iş akışı şu şekildedir:

1. Talep Oluşturan Kullanıcı bir satın alma talebi oluşturur.
2. Satın alma ekibi oluşturulan talebi inceler.
3. Talep için tedarikçilerden teklifler toplanır.
4. Gelen teklifler sisteme kaydedilir.
5. Aynı talebe ait teklifler karşılaştırılır.
6. Uygun teklif seçilir.
7. Seçilen teklif üzerinden satın alma siparişi oluşturulur.
8. Süreçle ilgili bildirimler üretilir.
9. Dashboard ve raporlar üzerinden satın alma süreci takip edilir.

## 2. Roller

Sistemde kullanılan roller şunlardır:

1. Satın Alma Yöneticisi
2. Satın Alma Uzmanı
3. Talep Oluşturan Kullanıcı
5. Tedarikçi

### Satın Alma Yöneticisi

- Satın alma süreçlerini yönetir.
- Satın alma talebi oluşturabilir.
- Talepleri görüntüleyebilir.
- Teklifleri karşılaştırabilir.
- Uygun teklifi seçebilir.
- Satın alma siparişlerini görüntüleyebilir.
- Raporları görüntüleyebilir.

### Satın Alma Uzmanı

- Satın alma taleplerini görüntüler ve inceler.
- Tedarikçilerden alınan teklifleri sisteme girer.
- Teklifleri karşılaştırır.
- Yetkisi kapsamında satın alma sürecini yönetir.

### Talep Oluşturan Kullanıcı

- Satın alma talebi oluşturur.
- Yetkisi kapsamında talepleri görüntüler.

### Tedarikçi

Tedarikçi rolü veritabanında bulunmaktadır. Ancak bu proje kapsamında tedarikçiler için ayrı bir giriş ekranı veya aktif işlem ekranı hazırlanmayacaktır.

## 3. Yetkiler

Sistemde rol bazlı yetkilendirme kullanılacaktır.

Tanımlanan temel yetkiler şunlardır:

1. Talep Oluştur
2. Talep Görüntüle
3. Teklif Gir
4. Teklif Karşılaştır
5. Teklif Seç
6. Sipariş Görüntüle
7. Rapor Görüntüle

Roller ve yetkiler `Roller`, `Yetkiler` ve `RolYetkileri` tabloları üzerinden ilişkilendirilecektir.

Uygulamadaki menüler, ekranlar ve işlem butonları kullanıcının rolüne bağlı yetkilere göre gösterilecektir.

Rol yetkileri ayrı bir Yetki Yönetimi ekranında değil, Rol Yönetimi ekranı içerisinde yönetilecektir.

## 4. Nihai UI/UX Ekranları

Uygulama tamamen Türkçe hazırlanacaktır.

Hazırlanan ana ekranlar şunlardır:

1. Giriş Ekranı
2. Dashboard
3. Kullanıcı Yönetimi
4. Rol Yönetimi
5. Tedarikçi Yönetimi
6. Satın Alma Talepleri
7. Teklif Girişi
8. Teklif Karşılaştırma
9. Satın Alma Onayı
10. Bildirimler
11. Raporlar
12. Ayarlar

## 5. UI Tasarım Kuralları

Tüm ekranlarda aynı tasarım şablonu kullanılacaktır.

- Sol menü bütün ekranlarda aynı kalacaktır.
- Üst kullanıcı alanı bütün ekranlarda aynı kalacaktır.
- Kurumsal mavi renk paleti kullanılacaktır.
- Tasarımlar 16:9 yatay masaüstü web arayüzü olarak hazırlanacaktır.
- Ekranlarda Türkçe metinler kullanılacaktır.
- Her ekran ayrı bir görsel olarak hazırlanacaktır.
- Kolaj veya storyboard kullanılmayacaktır.
- Veritabanında veya açık iş kurallarında bulunmayan alanlar eklenmeyecektir.
- Ekranlar arasında tasarım dili, renkler, tablo yapıları ve bileşenler tutarlı olacaktır.

## 6. Yönetim Ekranlarında Hazırlanan İşlem Panelleri

### Kullanıcı Yönetimi

- Kullanıcı Ekle
- Kullanıcı Düzenle
- Kullanıcı Filtrele
- Kullanıcı Aktif/Pasif Durumunu Değiştir

### Rol Yönetimi

- Rol Ekle
- Rol Düzenle
- Rol Yetkilerini Görüntüle ve Yönet

### Tedarikçi Yönetimi

- Tedarikçi Ekle
- Tedarikçi Düzenle
- Tedarikçi Filtrele
- Tedarikçi Aktif/Pasif Durumunu Değiştir

### Satın Alma Talepleri

- Talep Ekle
- Talep Düzenle
- Talep Filtrele

### Teklif Girişi

- Teklif Ekle
- Teklif Düzenle
- Teklif Sil
- Teklif Filtrele

Teklif silme işlemi için ayrı bir ekran hazırlanmayacaktır. Çöp kutusu ikonuna basıldığında standart bir onay mesajı gösterilmesi yeterlidir.

Teklif Karşılaştırma, Satın Alma Onayı, Bildirimler, Raporlar ve Ayarlar için gereksiz ekleme veya düzenleme ekranları hazırlanmayacaktır.

## 7. Nihai Veritabanı Yapısı

Projede kullanılan temel tablolar şunlardır:

- Roller
- Yetkiler
- RolYetkileri
- Kullanicilar
- Firmalar
- FirmaKullanicilari
- Tedarikciler
- SatinAlmaTalepleri
- Teklifler
- TeklifKalemleri
- SatinAlmaSiparisleri
- Bildirimler

Veritabanında yer alan diğer yardımcı tablolar da mevcut SQL şemasına göre kullanılacaktır.

Her tablo için gerekli olduğu durumlarda aşağıdaki yapılar tanımlanmıştır:

- Primary Key
- Foreign Key
- Unique kısıtları
- Check kısıtları
- Default değerler
- Indexler
- Tablo ilişkileri

## 8. Teklifler ve Teklif Kalemleri

Tekliflerin genel bilgileri `Teklifler` tablosunda tutulmaktadır.

Bir teklife ait ürün veya teklif detayları `TeklifKalemleri` tablosunda tutulmaktadır.

`TeklifKalemleri` tablosu, ilgili teklife `TeklifID` üzerinden bağlanmaktadır.

Tekliflerin ana bilgileri ile teklif kalemleri birbirinden ayrı yönetilecektir.

## 9. Teklifler Tablosunun Güncel Alanları

`Teklifler` tablosunda aşağıdaki alanlar bulunmaktadır:

- TeklifID
- TeklifNo
- TalepID
- TedarikciID
- TeklifGirenKullaniciID
- TeklifTutari
- TeslimSuresiGun
- SKT
- TeklifTarihi
- GecerlilikTarihi
- ParaBirimi
- TeklifDurumID

## 10. Teklif Durumları

`Teklifler.TeklifDurumID` alanı için kullanılan durumlar şunlardır:

- 0 = Girildi
- 1 = Seçildi
- 2 = Reddedildi

Yeni bir teklif sisteme eklendiğinde durumu otomatik olarak `Girildi` olacaktır.

Teklif Girişi ekranında kullanıcı tarafından teklif durumu seçilmeyecektir.

Teklif durumu, Teklif Karşılaştırma ekranında gerçekleştirilen seçme veya reddetme işlemlerine göre güncellenecektir.

Bir teklif seçildiğinde:

- Seçilen teklif `Seçildi` durumuna getirilir.
- Aynı satın alma talebine ait diğer teklifler `Reddedildi` durumuna getirilir.

## 11. Teklif Düzenleme Kuralları

Yalnızca `Girildi` durumundaki teklifler düzenlenebilir.

`Seçildi` veya `Reddedildi` durumundaki teklifler düzenlenemez.

Teklif düzenleme işleminde aşağıdaki alanlar güncellenebilir:

- Tedarikçi
- Teklif Tutarı
- Teslim Süresi Gün
- SKT
- Geçerlilik Tarihi
- Para Birimi

Aşağıdaki alanlar teklif düzenleme ekranında değiştirilemez:

- Teklif ID
- Teklif No
- Talep
- Teklif Giren Kullanıcı
- Teklif Tarihi
- Teklif Durumu

Teklif düzenleme işlemi `sp_TeklifGuncelle` stored procedure üzerinden gerçekleştirilecektir.

## 12. Teklif Silme Kuralları

Teklif silme işlemi `sp_TeklifSil` stored procedure üzerinden gerçekleştirilecektir.

- Yalnızca `Girildi` durumundaki teklifler silinebilir.
- `Seçildi` veya `Reddedildi` durumundaki teklifler silinemez.
- Satın alma siparişine bağlı bir teklif silinemez.
- Silme işleminden önce kullanıcıdan onay alınacaktır.

## 13. Satın Alma Siparişi Durumları

`SatinAlmaSiparisleri.Durum` alanı için kullanılan durumlar şunlardır:

- 0 = Oluşturuldu
- 1 = Tamamlandı
- 2 = İptal

Seçilen teklif üzerinden satın alma siparişi oluşturulacaktır.

Satın Alma Onayı ekranındaki işlem tamamlandığında ilgili sipariş kaydı veritabanına eklenecektir.

## 14. Kullanıcı Yönetimi Kuralları

Kullanıcı ekleme ve düzenleme işlemleri stored procedure üzerinden gerçekleştirilecektir.

Kullanıcı düzenleme ekranında:

- Kullanıcı ID yalnızca okunabilir gösterilecektir.
- Ad Soyad düzenlenebilir.
- Kullanıcı Adı düzenlenebilir.
- Rol değiştirilebilir.
- Geçici Şifre alanları isteğe bağlı olacaktır.
- Geçici şifre alanları boş bırakılırsa mevcut şifre değiştirilmeyecektir.

Kullanıcının aktif veya pasif durumu ilgili stored procedure üzerinden güncellenecektir.

## 15. Şifre Güvenliği

Kullanıcı şifreleri veritabanında düz metin olarak saklanmayacaktır.

Şifre güvenliği için:

- `SifreHash` değeri veritabanında tutulacaktır.
- `SifreSalt` değeri veritabanında tutulacaktır.
- Pepper değeri uygulama yapılandırma dosyasında tutulacaktır.

Şifre oluşturma ve güncelleme işlemleri uygulama katmanında güvenli şekilde gerçekleştirilecektir.

## 16. Stored Procedure Kullanımı

Uygulamadaki veritabanı işlemleri mümkün olduğunca stored procedure üzerinden gerçekleştirilecektir.

Başlıca stored procedure grupları şunlardır:

- Giriş ve kullanıcı doğrulama işlemleri
- Kullanıcı yönetimi
- Rol ve yetki yönetimi
- Firma kullanıcıları
- Tedarikçi yönetimi
- Satın alma talebi yönetimi
- Teklif yönetimi
- Teklif kalemleriyle ilgili işlemler
- Teklif karşılaştırma
- Teklif seçme ve reddetme
- Satın alma siparişi oluşturma
- Sipariş durumu güncelleme
- Bildirim yönetimi
- Dashboard verileri
- Rapor işlemleri
- Profil ve şifre güncelleme işlemleri

Mevcut stored procedure’ler uygulama kodlanırken ilgili ekran ve butonlarla eşleştirilecektir.

## 17. Dashboard

Dashboard, örnek veriler sisteme eklendikten sonra gerçek veritabanı sonuçlarına bağlanacaktır.

Dashboard üzerinde aşağıdaki türde bilgiler gösterilecektir:

- Bekleyen talepler
- Gelen teklifler
- Onay bekleyen satın almalar
- En çok çalışılan tedarikçiler
- Bu ay açılan talepler
- Yaklaşan teklif tarihleri
- Son talepler
- Son teklifler
- Son siparişler
- Talep durum dağılımları
- Teklif durum dağılımları

Dashboard verileri stored procedure veya gerekli durumlarda view üzerinden okunacaktır.

## 18. Bildirim Sistemi

Bildirim sistemi satın alma sürecindeki önemli olayları kullanıcıya bildirmek için kullanılacaktır.

Örnek bildirim senaryoları:

- Yeni satın alma talebi oluşturulması
- Talebin incelenmesi veya reddedilmesi
- Yeni teklif girilmesi
- Teklifin seçilmesi
- Teklifin reddedilmesi
- Satın alma siparişi oluşturulması
- Onay bekleyen satın almalar
- Yaklaşan teklif tarihleri
- Tamamlanmayan talepler

Zamana bağlı bildirim senaryoları için SQL Server Agent Job mantığı araştırılacak ve uygun SQL sorguları hazırlanacaktır.

Bildirimler kullanıcı bazlı tutulacaktır.

Kullanıcı:

- Tek bir bildirimi okundu olarak işaretleyebilir.
- Tüm bildirimleri okundu olarak işaretleyebilir.
- Okunmamış bildirim sayısını görüntüleyebilir.

## 19. Raporlar

Raporlar stored procedure üzerinden hazırlanacaktır.

Proje kapsamında aşağıdaki türde raporlar kullanılabilir:

- Bu ay oluşturulan satın alma talepleri
- Bu ay gelen teklif sayısı
- Tedarikçi bazlı teklif sayıları
- En fazla teklif alınan tedarikçiler
- En çok satın alma yapılan firmalar
- Yaklaşan teklif tarihleri
- Bekleyen satın alma talepleri
- Kullanıcı bazlı oluşturulan talepler
- Aylık satın alma özeti
- Talep durumları
- Teklif durumları
- Sipariş durumları

Rapor ekranında yalnızca mevcut stored procedure’lerle desteklenen filtre ve alanlar kullanılacaktır.

## 20. Örnek Veriler

Uygulamanın kodlanmasından sonra sistemi gerçek hayata yakın şekilde test etmek için örnek veriler hazırlanacaktır.

Örnek veri hedefleri:

- Yaklaşık 20 kullanıcı
- Yaklaşık 30 tedarikçi
- Yaklaşık 100 satın alma talebi
- Yaklaşık 300 teklif
- Farklı durumlarda teklifler
- Farklı durumlarda satın alma siparişleri
- Bildirim kayıtları

Örnek veriler ayrı INSERT scriptleri hâlinde hazırlanacaktır.

Veriler pizza üretim fabrikasının satın alma süreçlerine uygun olacaktır.

## 21. Proje Dosyaları

Proje dosyaları aşağıdaki klasör yapısına göre düzenlenecektir:

```text
PizzaSatinAlmaYonetimi
│
├── Database
│   ├── PizzaSatinAlmaDB_Final.sql
│   └── Örnek veri ve ek SQL scriptleri
│
├── Documents
│   ├── PROJECT.md
│   ├── Analiz dokümanı
│   ├── Veritabanı şeması
│   ├── ER diyagramı
│   ├── Use Case diyagramı
│   ├── Süreç akış diyagramı
│   └── Yetki matrisi
│
├── UI
│   └── Hazırlanan bütün ekran görselleri
│
└── SourceCode
    └── Codex ile geliştirilecek uygulama kodları
 