using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class SatinAlmaTalepleriController : ModuleControllerBase { public IActionResult Index() => View(Page("Satın Alma Talepleri")); }
