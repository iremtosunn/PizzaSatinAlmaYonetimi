# Pizza Satın Alma Yönetimi

Bu repository, pizza fabrikasının satın alma süreçleri için ASP.NET Core MVC tabanlı uygulama altyapısını içerir. Bu aşamada ekranların işlevleri, örnek veriler, dashboard sorguları, bildirim görevleri ve raporlar uygulanmamıştır.

## Gereksinimler

- .NET 8 SDK
- Microsoft SQL Server
- Visual Studio 2022, Visual Studio Code veya uyumlu bir geliştirme ortamı

## Yerelde çalıştırma

1. Repository'yi bilgisayarınıza alın.
2. `SourceCode/PizzaSatinAlmaYonetimi.Web/appsettings.json` içindeki `ConnectionStrings:SqlServer` örnek değerini kendi yerel/güvenli bağlantı ayarınızla değiştirin. Gerçek parolaları kaynak kontrolüne eklemeyin; geliştirme sırasında kullanıcı gizleri veya ortam değişkenleri kullanın.
3. `appsettings.json` içindeki `Security:PasswordPepper` değeri yalnızca geliştirme placeholder'ıdır. Gerçek pepper değerini hiçbir zaman `appsettings.json` dosyasına veya kaynak kontrolüne yazmayın; kullanıcı gizleri, ortam değişkenleri ya da güvenli bir secret kasası üzerinden sağlayın.
4. Repository kökünde bağımlılıkları yükleyin:

   ```powershell
   dotnet restore .\PizzaSatinAlmaYonetimi.sln
   ```

5. Projeyi derleyin:

   ```powershell
   dotnet build .\PizzaSatinAlmaYonetimi.sln
   ```

6. Web uygulamasını başlatın:

   ```powershell
   dotnet run --project .\SourceCode\PizzaSatinAlmaYonetimi.Web\PizzaSatinAlmaYonetimi.Web.csproj
   ```

7. Konsolda gösterilen yerel HTTPS adresini tarayıcıda açın. Giriş ekranı iskeleti için `/Giris`, ana uygulama iskeleti için `/` yolunu kullanın.

## Yapı

- `Controllers`: MVC denetleyicileri ve ortak hata denetleyicisi
- `Models`: Görünüm modelleri
- `Views`: Türkçe ekran iskeletleri ve ortak şablon
- `Services`: Stored procedure tabanlı servis sözleşmeleri için başlangıç noktası
- `Data`: SQL Server bağlantı fabrikası
- `wwwroot`: CSS ve JavaScript dosyaları

Mevcut SQL scripti uygulama tarafından değiştirilmez. Veri erişimi geliştirildiğinde işlemler mevcut stored procedure'lerle eşleştirilecektir.
