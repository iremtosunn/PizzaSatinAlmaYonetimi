using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public interface IRaporlarService
{
    Task<RaporlarViewModel> GetirAsync(string? raporTuru, CancellationToken cancellationToken);
}
