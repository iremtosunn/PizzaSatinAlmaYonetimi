using Microsoft.AspNetCore.Authorization;using Microsoft.AspNetCore.Mvc;using PizzaSatinAlmaYonetimi.Web.Models;using PizzaSatinAlmaYonetimi.Web.Services;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
[Authorize(Roles="Satın Alma Yöneticisi,Satın Alma Uzmanı")]
public sealed class TedarikciYonetimiController(ITedarikciYonetimiService service,ILogger<TedarikciYonetimiController> logger):Controller
{
 [HttpGet]public async Task<IActionResult>Index([FromQuery]TedarikciFiltreModel filtre,string? panel,int? duzenleId,CancellationToken ct){var form=duzenleId.HasValue?await service.DetayGetirAsync(duzenleId.Value,ct)??new():new TedarikciFormModel();return View(new TedarikciYonetimiViewModel{Tedarikciler=await service.ListeleAsync(filtre,ct),Filtre=filtre,Form=form,AcikPanel=panel});}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>Ekle(TedarikciFormModel form,CancellationToken ct){if(!ModelState.IsValid)return await Hatali(form,"ekle",ct);return await Islem(()=>service.EkleAsync(form,ct),"Tedarikçi başarıyla eklendi.","Tedarikçi eklenemedi.");}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>Guncelle(TedarikciFormModel form,CancellationToken ct){if(!ModelState.IsValid)return await Hatali(form,"duzenle",ct);return await Islem(()=>service.GuncelleAsync(form,ct),"Tedarikçi bilgileri güncellendi.","Tedarikçi güncellenemedi.");}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>DurumGuncelle(int tedarikciId,int yeniDurum,CancellationToken ct)=>await Islem(()=>service.DurumGuncelleAsync(tedarikciId,yeniDurum,ct),$"Tedarikçi {(yeniDurum==1?"aktif":"pasif")} duruma getirildi.","Tedarikçi durumu güncellenemedi.");
 private async Task<IActionResult>Hatali(TedarikciFormModel form,string panel,CancellationToken ct)=>View("Index",new TedarikciYonetimiViewModel{Tedarikciler=await service.ListeleAsync(null,ct),Form=form,AcikPanel=panel});
 private async Task<IActionResult>Islem(Func<Task> action,string basari,string hata){try{await action();TempData["Basari"]=basari;}catch(Exception ex){logger.LogError(ex,hata);TempData["Hata"]=hata+" Bilgileri kontrol ederek yeniden deneyin.";}return RedirectToAction(nameof(Index));}
}
