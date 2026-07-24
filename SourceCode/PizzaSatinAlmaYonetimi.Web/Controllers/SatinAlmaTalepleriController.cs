using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Authorize]
public sealed class SatinAlmaTalepleriController(ISatinAlmaTalebiService service,ILogger<SatinAlmaTalepleriController> logger):Controller
{
 private const int YoneticiRolId=1,UzmanRolId=2,TalepOlusturanRolId=3;
 private int KullaniciId=>int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
 private int RolId=>int.TryParse(User.FindFirstValue("rol_id"),out var id)?id:0;

 [HttpGet]public async Task<IActionResult> Index([FromQuery]TalepFiltreModel filtre,string? panel,string? duzenleNo,string? inceleNo,CancellationToken ct)
 {
  if(RolId is not (YoneticiRolId or UzmanRolId or TalepOlusturanRolId))return Forbid();
  var form=!string.IsNullOrWhiteSpace(duzenleNo)?await service.DetayGetirAsync(duzenleNo,ct)??new():new TalepFormModel();
  if(RolId==TalepOlusturanRolId&&form.TalepId.HasValue&&!await service.KullaniciyaAitMiAsync(form.TalepId.Value,KullaniciId,ct))return Forbid();
  TalepFormModel? incelenecek=null;
  if(!string.IsNullOrWhiteSpace(inceleNo)){if(RolId!=UzmanRolId)return Forbid();incelenecek=await service.DetayGetirAsync(inceleNo,ct);if(incelenecek is null)return NotFound();if(incelenecek.TalepDurumId!=0)return BadRequest();}
  return View(new SatinAlmaTalepleriViewModel{Talepler=await service.ListeleAsync(filtre,ct),Filtre=filtre,Form=form,IncelenecekTalep=incelenecek,Inceleme=new(){TalepId=incelenecek?.TalepId??0},AcikPanel=panel,GirisYapanKullaniciId=KullaniciId,GirisYapanRolId=RolId});
 }
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>Ekle(TalepFormModel form,CancellationToken ct){if(!ModelState.IsValid)return await Hatali(form,"ekle",ct);return await Islem(()=>service.EkleAsync(KullaniciId,form,ct),"Satın alma talebi oluşturuldu.","Talep oluşturulamadı.");}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>Guncelle(TalepFormModel form,CancellationToken ct){if(!ModelState.IsValid)return await Hatali(form,"duzenle",ct);if(string.IsNullOrWhiteSpace(form.TalepNo))return BadRequest();var kayit=await service.DetayGetirAsync(form.TalepNo,ct);if(kayit is null||kayit.TalepId!=form.TalepId)return BadRequest();if(RolId==TalepOlusturanRolId&&!await service.KullaniciyaAitMiAsync(kayit.TalepId!.Value,KullaniciId,ct))return Forbid();return await Islem(()=>service.GuncelleAsync(form,ct),"Talep bilgileri güncellendi.","Talep güncellenemedi.");}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>Reddet(string talepNo,CancellationToken ct){if(RolId!=YoneticiRolId)return Forbid();return await Islem(()=>service.ReddetAsync(talepNo,ct),"Talep reddedildi.","Talep reddedilemedi.");}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>GeriAl(string talepNo,CancellationToken ct){if(RolId!=YoneticiRolId)return Forbid();return await Islem(()=>service.GeriAlAsync(talepNo,ct),"Talep geri alındı.","Talep geri alınamadı.");}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>Incele(TalepIncelemeModel model,CancellationToken ct){if(RolId!=UzmanRolId)return Forbid();if(!ModelState.IsValid){TempData["Hata"]=string.Join(" ",ModelState.Values.SelectMany(x=>x.Errors).Select(x=>x.ErrorMessage));return RedirectToAction(nameof(Index));}return await Islem(()=>service.InceleAsync(KullaniciId,model,ct),"Talep incelendi ve teklif sürecine alındı.","Talep incelenemedi.");}
 private async Task<IActionResult>Hatali(TalepFormModel form,string panel,CancellationToken ct)=>View("Index",new SatinAlmaTalepleriViewModel{Talepler=await service.ListeleAsync(null,ct),Form=form,AcikPanel=panel,GirisYapanKullaniciId=KullaniciId,GirisYapanRolId=RolId});
 private async Task<IActionResult>Islem(Func<Task>a,string b,string h){try{await a();TempData["Basari"]=b;}catch(Exception ex){logger.LogError(ex,h);TempData["Hata"]=h+" Bilgileri kontrol ederek yeniden deneyin.";}return RedirectToAction(nameof(Index));}
}
