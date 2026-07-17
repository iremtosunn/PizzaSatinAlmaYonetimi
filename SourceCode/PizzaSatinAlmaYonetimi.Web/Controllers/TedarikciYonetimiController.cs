using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class TedarikciYonetimiController : ModuleControllerBase { public IActionResult Index() => View(Page("Tedarikçi Yönetimi")); }
