using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class TeklifKarsilastirmaController : ModuleControllerBase { public IActionResult Index() => View(Page("Teklif Karşılaştırma")); }
