using Microsoft.AspNetCore.Mvc;

namespace KubeCMS.Backoffice.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}