using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class TeklifGirisiController : ModuleControllerBase { public IActionResult Index() => View(Page("Teklif Girişi")); }
