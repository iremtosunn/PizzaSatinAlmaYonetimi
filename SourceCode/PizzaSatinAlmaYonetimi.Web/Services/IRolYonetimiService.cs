using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface IRolYonetimiService
{
    Task<IReadOnlyList<RolListeSatiri>> ListeleAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<RolYetkisi>> YetkileriGetirAsync(int rolId, CancellationToken cancellationToken);
    Task EkleAsync(RolFormModel model, CancellationToken cancellationToken);
    Task GuncelleAsync(RolFormModel model, CancellationToken cancellationToken);
    Task YetkileriGuncelleAsync(int rolId, IReadOnlyCollection<int> yetkiIdleri, CancellationToken cancellationToken);
}
