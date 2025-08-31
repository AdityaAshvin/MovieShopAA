using ApplicationCore.Contracts.Services;
using Infrastructure.Services;
using Microsoft.AspNetCore.Mvc;

namespace MovieShopMVC.Controllers
{
    [Route("movies")]
    public class MoviesController : Controller
    {
        private readonly IMovieService _movieService;
        public MoviesController(IMovieService movieService)
        {
            _movieService = movieService;
        }
        [HttpGet("")]
        public IActionResult Index(int page = 1, int pageSize = 24)
        {
            var cards = _movieService.GetAllMovies();
            var total = cards.Count;
            var items = cards.Skip((page - 1) * pageSize).Take(pageSize).ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(total / (double)pageSize);

            return View(items);
        }

        [HttpGet("{id:int}")]
        public IActionResult MovieDetails(int id)
        {
            var movie = _movieService.GetMovieDetails(id);
            return View(movie);
        }

        [HttpPost]
        public IActionResult DeleteMovie(int id)
        {
            var movie = _movieService.GetMovieDetails(id);
            if(movie == null)
            {
                return NotFound();
            }
            _movieService.DeleteMovie(id);
            return RedirectToAction("Index", "Home");
        }
    }
}
