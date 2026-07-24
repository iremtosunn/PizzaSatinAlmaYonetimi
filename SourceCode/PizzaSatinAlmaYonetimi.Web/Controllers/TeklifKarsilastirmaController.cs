using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Authorize(Roles = "Satın Alma Yöneticisi,Satın Alma Uzmanı")]
public sealed class TeklifKarsilastirmaController(
    ITeklifKarsilastirmaService service,
    ISatinAlmaTalebiService talepService,
    ILogger<TeklifKarsilastirmaController> logger) : Controller
{
    [HttpGet]
    public async Task<IActionResult> Index(string? talepNo, CancellationToken ct)
    {
        TalepFormModel? talep = null;
        IReadOnlyList<KarsilastirmaTeklifi> teklifler = Array.Empty<KarsilastirmaTeklifi>();

        if (!string.IsNullOrWhiteSpace(talepNo))
        {
            talep = await talepService.DetayGetirAsync(talepNo, ct);

            if (talep is not null)
                teklifler = await service.ListeleAsync(talepNo, ct);
        }

        return View(new TeklifKarsilastirmaViewModel
        {
            TalepNo = talepNo,
            Talep = talep,
            Talepler = await talepService.ListeleAsync(null, ct),
            Teklifler = teklifler
        });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Satın Alma Yöneticisi")]
    public Task<IActionResult> Sec(string talepNo, string teklifNo, CancellationToken ct)
        => Islem(talepNo, teklifNo, "Girildi", () => service.SecAsync(teklifNo, ct), "Teklif seçildi.", ct);

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Satın Alma Yöneticisi")]
    public Task<IActionResult> Reddet(string talepNo, string teklifNo, CancellationToken ct)
        => Islem(talepNo, teklifNo, "Girildi", () => service.ReddetAsync(teklifNo, ct), "Teklif reddedildi.", ct);

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Satın Alma Yöneticisi")]
    public Task<IActionResult> GeriAl(string talepNo, string teklifNo, CancellationToken ct)
        => Islem(talepNo, teklifNo, "Reddedildi", () => service.GeriAlAsync(teklifNo, ct), "Teklif geri alındı.", ct);

    private async Task<IActionResult> Islem(
        string talepNo,
        string teklifNo,
        string beklenenDurum,
        Func<Task> action,
        string mesaj,
        CancellationToken ct)
    {
        try
        {
            var teklif = (await service.ListeleAsync(talepNo, ct))
                .FirstOrDefault(x => x.TeklifNo == teklifNo);

            if (teklif is null || teklif.Durum != beklenenDurum)
                return BadRequest();

            await action();

            TempData["Basari"] = mesaj;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Teklif karşılaştırma işlemi başarısız.");
            TempData["Hata"] = "İşlem tamamlanamadı.";
        }

        return RedirectToAction(nameof(Index), new { talepNo });
    }
}
