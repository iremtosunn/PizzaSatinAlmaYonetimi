using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public interface IDashboardService
{
    Task<DashboardViewModel> GetirAsync(int? kullaniciId, CancellationToken cancellationToken);
}
