using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface ITedarikciPuanService{Task<IReadOnlyList<TedarikciPuanBilgisi>>GetirAsync(CancellationToken ct);}
