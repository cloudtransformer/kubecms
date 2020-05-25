using System.IO;
using System.Linq;
using backoffice.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace backoffice.Controllers
{
    public class SitesViewComponent : ViewComponent
    {
        private readonly BackofficeOptions _options;

        public SitesViewComponent(IOptions<BackofficeOptions> options)
        {
            _options = options.Value;
        }

        public IViewComponentResult Invoke()
        {
            if (string.IsNullOrEmpty(_options.DataPath))
            {
                return View();
            }

            if (!Directory.Exists(_options.DataPath))
            {
                Directory.CreateDirectory(_options.DataPath);
            }

            var retval = Directory.GetDirectories(_options.DataPath)
                            .Select(Path.GetFileName)
                            .OrderBy(q => q)
                            .ToList();

            return View(retval);
        }
    }
}
