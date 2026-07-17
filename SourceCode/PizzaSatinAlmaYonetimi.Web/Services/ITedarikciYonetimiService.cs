using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface ITedarikciYonetimiService{Task<IReadOnlyList<TedarikciListeSatiri>>ListeleAsync(TedarikciFiltreModel? filtre,CancellationToken ct);Task<TedarikciFormModel?>DetayGetirAsync(int id,CancellationToken ct);Task EkleAsync(TedarikciFormModel model,CancellationToken ct);Task GuncelleAsync(TedarikciFormModel model,CancellationToken ct);Task DurumGuncelleAsync(int id,int durum,CancellationToken ct);}
