using Microsoft.AspNetCore.Mvc;
namespace PizzaSatinAlmaYonetimi.Web.Controllers;
public sealed class DashboardController : ModuleControllerBase { public IActionResult Index() => View(Page("Dashboard")); }
