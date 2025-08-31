using ApplicationCore.Contracts.Services;
using ApplicationCore.Entities;
using Infrastructure.Services;
using Microsoft.AspNetCore.Mvc;

namespace MovieShopMVC.Controllers
{
    public class GenreController : Controller
    {
        private readonly IGenreService _genreService;
        public GenreController(IGenreService genreService)
        {
            _genreService = genreService;
        }

        [Route("Genres/{id:int}")]
        public IActionResult Index(int id, int page = 1, int pageSize = 24)
        {
            var cards = _genreService.GetMoviesByGenre(id);
            var genre = _genreService.GetGenreById(id);
            var total = cards.Count;
            var items = cards.Skip((page - 1) * pageSize).Take(pageSize).ToList();

            ViewBag.GenreName = genre.Name;
            ViewBag.GenreId = id;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(total / (double)pageSize);

            return View(items); // view typed to IEnumerable<MovieCardModel>
        }
    }
}
