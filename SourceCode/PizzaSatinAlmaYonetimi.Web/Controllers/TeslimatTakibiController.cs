using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
[Authorize]public sealed class TeslimatTakibiController(ITeslimatTakibiService service,ILogger<TeslimatTakibiController> logger):Controller
{
 private int RolId=>int.TryParse(User.FindFirst("rol_id")?.Value,out var id)?id:0;private int KullaniciId=>int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
 [HttpGet]public async Task<IActionResult>Index(string? arama,string? durum,int? siparisId,CancellationToken ct){if(RolId is not(1 or 2))return Forbid();var l=await service.ListeleAsync(arama,durum,ct);return View(new TeslimatTakibiViewModel{Teslimatlar=l,Arama=arama,Durum=durum,SeciliSiparis=siparisId.HasValue?await service.DetayAsync(siparisId.Value,ct):null,Form=new(){SiparisId=siparisId??0,GercekTeslimTarihi=DateTime.Today,KusurluMiktar=0}});}
 [HttpPost,ValidateAntiForgeryToken]public async Task<IActionResult>Kaydet(TeslimatKayitModel form,CancellationToken ct){if(RolId!=2)return Forbid();if(ModelState.IsValid)try{await service.KaydetAsync(form,KullaniciId,ct);TempData["Basari"]="Teslimat başarıyla kaydedildi.";return RedirectToAction(nameof(Index));}catch(Exception ex){logger.LogError(ex,"Teslimat kaydedilemedi.");ModelState.AddModelError("",ex.Message);}return View("Index",new TeslimatTakibiViewModel{Teslimatlar=await service.ListeleAsync(null,null,ct),SeciliSiparis=await service.DetayAsync(form.SiparisId,ct),Form=form});}
}
