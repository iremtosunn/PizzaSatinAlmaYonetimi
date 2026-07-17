using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class SatinAlmaOnayiController : ModuleControllerBase { public IActionResult Index() => View(Page("Satın Alma Onayı")); }
