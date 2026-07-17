using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class AyarlarController : ModuleControllerBase { public IActionResult Index() => View(Page("Ayarlar")); }
