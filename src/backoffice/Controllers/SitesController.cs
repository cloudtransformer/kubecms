using System.IO;
using KubeCMS.Backoffice.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace KubeCMS.Backoffice.Controllers
{
    public class SitesController : Controller
    {
        private readonly BackofficeOptions _options;

        public SitesController(IOptions<BackofficeOptions> options)
        {
            _options = options.Value;
        }

        [Route("sites")]
        public IActionResult GetSites()
        {
            return View();
        }

        [Route("sites/{id}")]
        public IActionResult GetSite(string id)
        {
            if (Directory.Exists($"{_options.DataPath}{id}"))
            {
                ViewBag.Site = id;
                return View();
            }

            return NotFound();
        }

        [HttpPost]
        [Route("sites/{id}")]
        public IActionResult PostSite(string id)
        {
            if (!Directory.Exists($"{_options.DataPath}{id}"))
            {
                Directory.CreateDirectory($"{_options.DataPath}{id}");
            }

            return RedirectToAction("GetSite", new { id });
        }
    }
}