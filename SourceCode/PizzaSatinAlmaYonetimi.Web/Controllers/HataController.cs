using System.Diagnostics;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[Route("Hata")]
public sealed class HataController(ILogger<HataController> logger) : Controller
{
    [Route("")]
    [Route("{statusCode:int}")]
    public IActionResult Index(int? statusCode = null)
    {
        var exception = HttpContext.Features.Get<IExceptionHandlerPathFeature>();
        if (exception is not null)
            logger.LogError(exception.Error, "İşlenmeyen hata. Yol: {Path}, İz: {TraceId}", exception.Path, Activity.Current?.Id ?? HttpContext.TraceIdentifier);
        else if (statusCode.HasValue)
            logger.LogWarning("HTTP {StatusCode} yanıtı. İz: {TraceId}", statusCode, HttpContext.TraceIdentifier);

        Response.StatusCode = statusCode ?? StatusCodes.Status500InternalServerError;
        return statusCode == StatusCodes.Status403Forbidden
            ? View(new PageViewModel("Yetkisiz erişim", "Bu sayfaya erişim yetkiniz yok."))
            : View(new PageViewModel("Bir sorun oluştu", "İşleminiz tamamlanamadı. Lütfen daha sonra yeniden deneyin."));
    }
}
