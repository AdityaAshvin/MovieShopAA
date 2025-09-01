using ApplicationCore.Contracts.Services;
using Infrastructure.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace MovieShopMVC.Controllers
{
    public class ActorController : Controller
    {
        private readonly IActorService _actorService;
        public ActorController(IActorService actorService)
        {
            _actorService = actorService;
        }

        [Route("Actor/{id:int}")]
        public IActionResult Index(int id, int page = 1, int pageSize = 24)
        {
            var cards = _actorService.GetMoviesByCastId(id);
            var actorModel = _actorService.GetActorById(id);
            var total = cards.Count;
            var items = cards.Skip((page - 1) * pageSize).Take(pageSize).ToList();

            ViewBag.ActorName = actorModel.Name;
            ViewBag.ActorId = actorModel.Id;
            ViewBag.ProfilePath = actorModel.ProfilePath;
            ViewBag.TmdbURL = actorModel.TmdbURL;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(total / (double)pageSize);

            return View(items);
        }
    }
}
