using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class KullaniciYonetimiController : ModuleControllerBase { public IActionResult Index() => View(Page("Kullanıcı Yönetimi")); }
