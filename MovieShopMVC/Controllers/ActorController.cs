using Microsoft.AspNetCore.Mvc;

namespace MovieShopMVC.Controllers
{
    public class ActorController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
