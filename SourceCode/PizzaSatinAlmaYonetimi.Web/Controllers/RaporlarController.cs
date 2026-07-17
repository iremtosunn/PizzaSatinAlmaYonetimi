using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Authorize]
public sealed class RaporlarController(IRaporlarService service, ILogger<RaporlarController> logger) : Controller
{
    [HttpGet]
    public async Task<IActionResult> Index(string? raporTuru, CancellationToken cancellationToken)
    {
        try { return View(await service.GetirAsync(raporTuru, cancellationToken)); }
        catch (Exception exception)
        {
            logger.LogError(exception, "Rapor verisi alınamadı.");
            return View(new RaporlarViewModel { RaporTuru = raporTuru ?? RaporTurleri.AylikTalep, HataMesaji = "Rapor şu anda görüntülenemiyor. Lütfen daha sonra tekrar deneyin." });
        }
    }

    [HttpGet]
    public async Task<IActionResult> Csv(string? raporTuru, CancellationToken cancellationToken)
    {
        try
        {
            var report = await service.GetirAsync(raporTuru, cancellationToken);
            var text = new StringBuilder("\uFEFF");
            text.AppendLine(string.Join(';', report.Sutunlar.Select(Kacis)));
            foreach (var row in report.Satirlar) text.AppendLine(string.Join(';', row.Select(Kacis)));
            return File(Encoding.UTF8.GetBytes(text.ToString()), "text/csv; charset=utf-8", "rapor.csv");
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "Rapor CSV olarak dışa aktarılamadı.");
            TempData["Hata"] = "Rapor dışa aktarılamadı. Lütfen daha sonra tekrar deneyin.";
            return RedirectToAction(nameof(Index), new { raporTuru });
        }
    }

    private static string Kacis(string value) => $"\"{value.Replace("\"", "\"\"")}\"";
}
