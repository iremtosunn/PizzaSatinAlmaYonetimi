using Microsoft.AspNetCore.Mvc;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Controllers;

public abstract class ModuleControllerBase : Controller
{
    protected PageViewModel Page(string title) =>
        new(title, "Bu ekranın uygulama işlevleri sonraki geliştirme aşamasında hazırlanacaktır.");
}
