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
    }
}