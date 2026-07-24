using System.Security.Claims;using Microsoft.AspNetCore.Authorization;using Microsoft.AspNetCore.Mvc;using PizzaSatinAlmaYonetimi.Web.Services;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
[Authorize]public sealed class BildirimlerController(IBildirimService service,ILogger<BildirimlerController> logger):Controller
{
 [HttpGet]public async Task<IActionResult>Index(CancellationToken ct)=>View(await service.GetirAsync(Id(),ct));
 [HttpPost,ValidateAntiForgeryToken]public Task<IActionResult>OkunduYap(int bildirimId,CancellationToken ct)=>Guncelle(()=>service.OkunduYapAsync(bildirimId,Id(),ct),null);
 [HttpPost,ValidateAntiForgeryToken]public Task<IActionResult>OkunmadiYap(int bildirimId,CancellationToken ct)=>Guncelle(()=>service.OkunmadiYapAsync(bildirimId,Id(),ct),null);
 [HttpPost,ValidateAntiForgeryToken]public Task<IActionResult>TumunuOkunduYap(CancellationToken ct)=>Guncelle(()=>service.TumunuOkunduYapAsync(Id(),ct),"Tüm bildirimler okundu olarak işaretlendi.");
 [HttpPost,ValidateAntiForgeryToken]public Task<IActionResult>TumunuOkunmadiYap(CancellationToken ct)=>Guncelle(()=>service.TumunuOkunmadiYapAsync(Id(),ct),"Tüm bildirimler okunmadı olarak işaretlendi.");
 private async Task<IActionResult>Guncelle(Func<Task>islem,string? basari){try{await islem();if(basari is not null)TempData["Basari"]=basari;}catch(Exception ex){logger.LogError(ex,"Bildirimler güncellenemedi.");TempData["Hata"]="Bildirimler güncellenemedi.";}return RedirectToAction(nameof(Index));}
 private int Id()=>int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
