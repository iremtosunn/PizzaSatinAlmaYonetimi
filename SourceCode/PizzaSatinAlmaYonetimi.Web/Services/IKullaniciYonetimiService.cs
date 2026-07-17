using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public interface IKullaniciYonetimiService
{
    Task<IReadOnlyList<KullaniciListeSatiri>> ListeleAsync(KullaniciFiltreModel? filtre, CancellationToken cancellationToken);
    Task<KullaniciOzet> OzetGetirAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<RolSecenegi>> RolleriGetirAsync(CancellationToken cancellationToken);
    Task<KullaniciFormModel?> DetayGetirAsync(int kullaniciId, CancellationToken cancellationToken);
    Task EkleAsync(KullaniciFormModel model, CancellationToken cancellationToken);
    Task GuncelleAsync(KullaniciFormModel model, CancellationToken cancellationToken);
    Task DurumGuncelleAsync(int kullaniciId, int yeniDurum, CancellationToken cancellationToken);
}
