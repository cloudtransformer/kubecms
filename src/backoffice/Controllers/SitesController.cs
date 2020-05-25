using Microsoft.AspNetCore.Mvc;

namespace backoffice.Controllers
{
    public class SitesController : Controller
    {
        [Route("sites/{id}")]
        public IActionResult GetSite(string id)
        {
            ViewBag.Site = id;
            return View();
        }
    }
}