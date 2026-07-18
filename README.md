# Pizza Satın Alma Yönetimi

Bu repository, pizza fabrikasının satın alma süreçleri için geliştirilmiş ASP.NET Core MVC tabanlı satın alma yönetim sistemi uygulamasını içerir.

Proje; satın alma taleplerinin oluşturulması, tedarikçilerin yönetilmesi, tekliflerin girilmesi, tekliflerin karşılaştırılması, satın alma onayı, bildirimler, raporlar ve rol bazlı kullanıcı erişimi gibi temel süreçleri kapsar.

## Kullanılan Teknolojiler

- ASP.NET Core MVC
- .NET 8
- C#
- SQL Server
- Stored Procedure
- ADO.NET
- HTML / CSS / JavaScript
- Visual Studio Code
- SQL Server Management Studio

## Kullanıcı Rolleri

Sistemde rol bazlı erişim yapısı bulunmaktadır.

### Satın Alma Yöneticisi

- Dashboard ekranını görüntüleyebilir.
- Kullanıcı yönetimi yapabilir.
- Rol yönetimi yapabilir.
- Tedarikçi yönetimi yapabilir.
- Satın alma taleplerini görüntüleyebilir.
- Talepleri reddedebilir ve geri alabilir.
- Teklif girişi ve teklif karşılaştırma ekranlarını kullanabilir.
- Satın alma onayı verebilir.
- Bildirimleri ve raporları görüntüleyebilir.
- Ayarlar ekranından çıkış yapabilir.

### Satın Alma Uzmanı

- Dashboard ekranını görüntüleyebilir.
- Tedarikçi yönetimi yapabilir.
- Satın alma taleplerini görüntüleyebilir.
- Talepleri reddedebilir ve geri alabilir.
- Teklif girişi yapabilir.
- Teklif karşılaştırma ekranını görüntüleyebilir.
- Bildirimleri ve raporları görüntüleyebilir.
- Ayarlar ekranından çıkış yapabilir.

### Talep Oluşturan Kullanıcı

- Dashboard ekranını görüntüleyebilir.
- Satın alma taleplerini görüntüleyebilir.
- Yeni talep oluşturabilir.
- Kendi oluşturduğu talepleri düzenleyebilir.
- Bildirimlerini görüntüleyebilir.
- Ayarlar ekranından çıkış yapabilir.

## Ana Modüller

- Giriş ekranı
- Dashboard
- Kullanıcı yönetimi
- Rol yönetimi
- Tedarikçi yönetimi
- Satın alma talepleri
- Teklif girişi
- Teklif karşılaştırma
- Satın alma onayı
- Bildirimler
- Raporlar
- Ayarlar

## Gereksinimler

- .NET 8 SDK
- Microsoft SQL Server
- Visual Studio Code veya Visual Studio
- SQL Server Management Studio

## Yerelde Çalıştırma

Web uygulamasını çalıştırmak için doğru proje klasörüne gidilmelidir:

```powershell
cd C:\Users\Gaming\Desktop\PizzaSatinAlmaYonetimi\SourceCode\PizzaSatinAlmaYonetimi.Web
