using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class RolYonetimiController : ModuleControllerBase { public IActionResult Index() => View(Page("Rol Yönetimi")); }
