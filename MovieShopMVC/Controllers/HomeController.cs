using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using MovieShopMVC.Models;
using Infrastructure.Services;
using ApplicationCore.Contracts;
using ApplicationCore.Contracts.Services;

namespace MovieShopMVC.Controllers
{
    public class HomeController : Controller
    {
        private IMovieService movieService;

        public HomeController(IMovieService _movieService)
        {
            movieService = _movieService;
        }

        public IActionResult Index()
        {
            //var movieService = new MovieService();
            var movies = movieService.GetTop20Movies();
            return View(movies);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult TopMovies()
        {
            return View();
        }

        public IActionResult Login()
        {
            return View();
        }

        public IActionResult Register()
        {
            return View();
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
