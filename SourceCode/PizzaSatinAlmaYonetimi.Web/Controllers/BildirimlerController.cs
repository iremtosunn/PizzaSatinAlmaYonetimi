using System.Security.Claims;using Microsoft.AspNetCore.Authorization;using Microsoft.AspNetCore.Mvc;using PizzaSatinAlmaYonetimi.Web.Services;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
[Authorize]public sealed class BildirimlerController(IBildirimService service,ILogger<BildirimlerController> logger):Controller
{
 [HttpGet]public async Task<IActionResult>Index(CancellationToken ct)=>View(await service.GetirAsync(Id(),ct));
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>OkunduYap(int bildirimId,CancellationToken ct){try{await service.OkunduYapAsync(bildirimId,Id(),ct);}catch(Exception ex){logger.LogError(ex,"Bildirim okundu yapılamadı.");TempData["Hata"]="Bildirim güncellenemedi.";}return RedirectToAction(nameof(Index));}
 [HttpPost][ValidateAntiForgeryToken]public async Task<IActionResult>TumunuOkunduYap(CancellationToken ct){try{await service.TumunuOkunduYapAsync(Id(),ct);TempData["Basari"]="Tüm bildirimler okundu olarak işaretlendi.";}catch(Exception ex){logger.LogError(ex,"Bildirimler güncellenemedi.");TempData["Hata"]="Bildirimler güncellenemedi.";}return RedirectToAction(nameof(Index));}
 private int Id()=>int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
