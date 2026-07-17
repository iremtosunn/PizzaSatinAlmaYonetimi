using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Authorize(Roles = "Satın Alma Yöneticisi")]
public sealed class KullaniciYonetimiController(IKullaniciYonetimiService service, ILogger<KullaniciYonetimiController> logger) : Controller
{
    [HttpGet]
    public async Task<IActionResult> Index([FromQuery] KullaniciFiltreModel filtre, string? panel, int? duzenleId, CancellationToken ct)
    {
        var form = duzenleId.HasValue ? await service.DetayGetirAsync(duzenleId.Value, ct) ?? new() : new KullaniciFormModel();
        return View(await ModelOlustur(filtre, form, panel, ct));
    }

    [HttpPost][ValidateAntiForgeryToken]
    public async Task<IActionResult> Ekle(KullaniciFormModel form, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(form.GeciciSifre)) ModelState.AddModelError(nameof(form.GeciciSifre), "Geçici şifre zorunludur.");
        if (!ModelState.IsValid) return View("Index", await ModelOlustur(new(), form, "ekle", ct));
        try { await service.EkleAsync(form, ct); TempData["Basari"]="Kullanıcı başarıyla eklendi."; }
        catch(Exception ex){ logger.LogError(ex,"Kullanıcı eklenemedi.");TempData["Hata"]="Kullanıcı eklenemedi. Bilgileri kontrol ederek yeniden deneyin."; }
        return RedirectToAction(nameof(Index));
    }

    [HttpPost][ValidateAntiForgeryToken]
    public async Task<IActionResult> Guncelle(KullaniciFormModel form, CancellationToken ct)
    {
        if (!ModelState.IsValid) return View("Index", await ModelOlustur(new(), form, "duzenle", ct));
        try { await service.GuncelleAsync(form, ct); TempData["Basari"]="Kullanıcı bilgileri güncellendi."; }
        catch(Exception ex){ logger.LogError(ex,"Kullanıcı güncellenemedi. ID: {Id}",form.KullaniciId);TempData["Hata"]="Kullanıcı güncellenemedi. Bilgileri kontrol ederek yeniden deneyin."; }
        return RedirectToAction(nameof(Index));
    }

    [HttpPost][ValidateAntiForgeryToken]
    public async Task<IActionResult> DurumGuncelle(int kullaniciId, int yeniDurum, CancellationToken ct)
    {
        try { await service.DurumGuncelleAsync(kullaniciId,yeniDurum,ct);TempData["Basari"]=$"Kullanıcı {(yeniDurum==1?"aktif":"pasif")} duruma getirildi."; }
        catch(Exception ex){logger.LogError(ex,"Kullanıcı durumu güncellenemedi. ID: {Id}",kullaniciId);TempData["Hata"]="Kullanıcı durumu güncellenemedi.";}
        return RedirectToAction(nameof(Index));
    }

    private async Task<KullaniciYonetimiViewModel> ModelOlustur(KullaniciFiltreModel filtre,KullaniciFormModel form,string? panel,CancellationToken ct)=>new()
    { Kullanicilar=await service.ListeleAsync(filtre,ct),Ozet=await service.OzetGetirAsync(ct),Roller=await service.RolleriGetirAsync(ct),Filtre=filtre,Form=form,AcikPanel=panel };
}
