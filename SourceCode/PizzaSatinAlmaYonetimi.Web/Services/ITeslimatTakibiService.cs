using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface ITeslimatTakibiService{Task<IReadOnlyList<TeslimatSatiri>>ListeleAsync(string? arama,string? durum,CancellationToken ct);Task<TeslimatSatiri?>DetayAsync(int siparisId,CancellationToken ct);Task KaydetAsync(TeslimatKayitModel model,int kullaniciId,CancellationToken ct);}
