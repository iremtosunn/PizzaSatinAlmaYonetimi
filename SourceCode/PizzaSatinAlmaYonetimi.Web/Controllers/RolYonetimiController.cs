using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Authorize(Roles = "Satın Alma Yöneticisi")]
public sealed class RolYonetimiController(IRolYonetimiService service, ILogger<RolYonetimiController> logger) : Controller
{
    [HttpGet]
    public async Task<IActionResult> Index(int? rolId, string? aramaMetni, string? panel, CancellationToken ct)
    {
        var roller=await service.ListeleAsync(ct); if(!string.IsNullOrWhiteSpace(aramaMetni))roller=roller.Where(x=>x.RolAdi.Contains(aramaMetni,StringComparison.CurrentCultureIgnoreCase)).ToList();
        var secili=rolId??roller.FirstOrDefault()?.RolId;var form=secili.HasValue&&panel=="duzenle"?roller.Where(x=>x.RolId==secili).Select(x=>new RolFormModel{RolId=x.RolId,RolAdi=x.RolAdi,Aciklama=x.Aciklama}).FirstOrDefault()??new():new RolFormModel();
        return View(new RolYonetimiViewModel{Roller=roller,SeciliRolId=secili,Yetkiler=secili.HasValue?await service.YetkileriGetirAsync(secili.Value,ct):[],AramaMetni=aramaMetni,Form=form,AcikPanel=panel});
    }

    [HttpPost][ValidateAntiForgeryToken]
    public async Task<IActionResult> Ekle(RolFormModel form,CancellationToken ct){if(!ModelState.IsValid)return await HataliForm(form,"ekle",ct);try{await service.EkleAsync(form,ct);TempData["Basari"]="Rol başarıyla eklendi.";}catch(Exception ex){Hata(ex,"Rol eklenemedi.");}return RedirectToAction(nameof(Index));}
    [HttpPost][ValidateAntiForgeryToken]
    public async Task<IActionResult> Guncelle(RolFormModel form,CancellationToken ct){if(!ModelState.IsValid)return await HataliForm(form,"duzenle",ct);try{await service.GuncelleAsync(form,ct);TempData["Basari"]="Rol bilgileri güncellendi.";}catch(Exception ex){Hata(ex,"Rol güncellenemedi.");}return RedirectToAction(nameof(Index),new{rolId=form.RolId});}
    [HttpPost][ValidateAntiForgeryToken]
    public async Task<IActionResult> YetkileriGuncelle(RolYetkiFormModel form,CancellationToken ct){try{await service.YetkileriGuncelleAsync(form.RolId,form.YetkiIdleri,ct);TempData["Basari"]="Rol yetkileri güncellendi.";}catch(Exception ex){Hata(ex,"Rol yetkileri güncellenemedi.");}return RedirectToAction(nameof(Index),new{rolId=form.RolId});}
    private async Task<IActionResult> HataliForm(RolFormModel form,string panel,CancellationToken ct){var roller=await service.ListeleAsync(ct);var secili=form.RolId??roller.FirstOrDefault()?.RolId;return View("Index",new RolYonetimiViewModel{Roller=roller,SeciliRolId=secili,Yetkiler=secili.HasValue?await service.YetkileriGetirAsync(secili.Value,ct):[],Form=form,AcikPanel=panel});}
    private void Hata(Exception ex,string mesaj){logger.LogError(ex,mesaj);TempData["Hata"]=mesaj+" Bilgileri kontrol ederek yeniden deneyin.";}
}
