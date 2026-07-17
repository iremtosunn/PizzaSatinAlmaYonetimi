using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface ISatinAlmaTalebiService{Task<IReadOnlyList<TalepListeSatiri>>ListeleAsync(TalepFiltreModel? filtre,CancellationToken ct);Task<TalepFormModel?>DetayGetirAsync(string talepNo,CancellationToken ct);Task EkleAsync(int kullaniciId,TalepFormModel model,CancellationToken ct);Task GuncelleAsync(TalepFormModel model,CancellationToken ct);Task ReddetAsync(string talepNo,CancellationToken ct);}
