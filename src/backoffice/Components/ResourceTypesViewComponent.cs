using Microsoft.AspNetCore.Mvc;

namespace KubeCMS.Backoffice.Controllers
{
    public class ResourceTypesViewComponent : ViewComponent
    {
        public IViewComponentResult Invoke()
        {
            return View();
        }
    }
}