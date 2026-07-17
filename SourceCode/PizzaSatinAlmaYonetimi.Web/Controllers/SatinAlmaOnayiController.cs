using System.Security.Claims;using Microsoft.AspNetCore.Authorization;using Microsoft.AspNetCore.Mvc;using PizzaSatinAlmaYonetimi.Web.Services;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
[Authorize(Roles="Satın Alma Yöneticisi")]
public sealed class SatinAlmaOnayiController(ISatinAlmaOnayService service,ILogger<SatinAlmaOnayiController> logger):Controller
{
 [HttpGet]public async Task<IActionResult>Index(CancellationToken ct)=>View(await service.ListeleAsync(ct));
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>SiparisOlustur(int teklifId,CancellationToken ct){try{var uid=int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);await service.SiparisOlusturAsync(teklifId,uid,ct);TempData["Basari"]="Satın alma siparişi Oluşturuldu durumuyla kaydedildi.";}catch(Exception ex){logger.LogError(ex,"Sipariş oluşturulamadı. Teklif ID: {Id}",teklifId);TempData["Hata"]="Sipariş oluşturulamadı.";}return RedirectToAction(nameof(Index));}
}
