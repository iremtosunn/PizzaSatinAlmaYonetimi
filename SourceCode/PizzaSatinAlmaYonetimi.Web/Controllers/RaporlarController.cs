using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class RaporlarController : ModuleControllerBase { public IActionResult Index() => View(Page("Raporlar")); }
