using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Authorize]
public sealed class DashboardController(IDashboardService service, ILogger<DashboardController> logger) : Controller
{
    [HttpGet]
    public async Task<IActionResult> Index(CancellationToken cancellationToken)
    {
        try
        {
            int? kullaniciId = int.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : null;
            return View(await service.GetirAsync(kullaniciId, cancellationToken));
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "Dashboard verileri alınamadı.");
            return View(new DashboardViewModel
            {
                HataMesaji = "Dashboard bilgileri şu anda görüntülenemiyor. Lütfen daha sonra tekrar deneyin."
            });
        }
    }
}
