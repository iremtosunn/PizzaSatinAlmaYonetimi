using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;
using PizzaSatinAlmaYonetimi.Web.Services;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

[AllowAnonymous]
public sealed class GirisController(IGirisService girisService, ILogger<GirisController> logger) : Controller
{
    [HttpGet]
public async Task<IActionResult> Cikis()
{
    await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

    return RedirectToAction("Index", "Giris");
}
    [HttpGet]
    public IActionResult Index()
    {
        return View(new GirisViewModel());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Index(GirisViewModel model, CancellationToken cancellationToken)
    {
        if (!ModelState.IsValid)
            return View(model);

        try
        {
            var kullanici = await girisService.DogrulaAsync(model.KullaniciAdi, model.Sifre, cancellationToken);
            if (kullanici is null)
            {
                ModelState.AddModelError(string.Empty, "KullanÄ±cÄ± adÄ± veya ÅŸifre hatalÄ±.");
                return View(model);
            }

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, kullanici.KullaniciId.ToString()),
                new Claim(ClaimTypes.Name, kullanici.AdSoyad),
                new Claim(ClaimTypes.Role, kullanici.RolAdi)
            };
            var principal = new ClaimsPrincipal(new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme));
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

            return RedirectToAction("Index", "Dashboard");
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "GiriÅŸ iÅŸlemi sÄ±rasÄ±nda hata oluÅŸtu.");
            ModelState.AddModelError(string.Empty, "GiriÅŸ iÅŸlemi ÅŸu anda tamamlanamÄ±yor. LÃ¼tfen daha sonra yeniden deneyin.");
            return View(model);
        }
    }
}


