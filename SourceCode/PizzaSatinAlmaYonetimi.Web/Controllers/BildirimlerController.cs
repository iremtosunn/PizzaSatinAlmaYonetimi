using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class BildirimlerController : ModuleControllerBase { public IActionResult Index() => View(Page("Bildirimler")); }
