using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using ApplicationCore.Contracts.Repositories;
using ApplicationCore.Contracts.Services;
using ApplicationCore.Models;

namespace Infrastructure.Services
{
    public class MovieService : IMovieService
    {
        private readonly IMovieRepository _movieRepository;
        public MovieService(IMovieRepository movieRepository) 
        {
            _movieRepository = movieRepository;
        }

        public bool DeleteMovie(int Id)
        {
            var movie = _movieRepository.DeleteByID(Id);
            if(movie == null)
            {
                return false;
            }
            return true;
        }

        public MovieDetailsModel GetMovieDetails(int Id)
        {
            var movie = _movieRepository.GetMovieByIdWithCasts(Id);
            var trailers = _movieRepository.GetTrailersByMovieId(Id);
            var genres = _movieRepository.GetGenresByMovieId(Id);
            if (movie != null)
            {
                var movieDetailsModel = new MovieDetailsModel()
                {
                    Id = movie.Id,
                    Title = movie.Title,
                    PosterUrl = movie.PosterUrl,
                    Revenue = movie.Revenue,
                    Budget = movie.Budget,
                    Overview = movie.Overview,
                    Tagline = movie.Tagline,
                    BackdropUrl = movie.BackdropUrl,
                    ReleaseYear = movie.ReleaseDate?.Year,
                    ReleaseDate = movie.ReleaseDate,
                    TmdbURL = movie.TmdbUrl,
                    ImdbURL = movie.ImdbURL,
                    Runtime = movie.RunTime,
                    Casts = movie.MovieCasts.Select(mc => new CastModel
                    {
                        Id = mc.CastId,
                        Name = mc.Cast.Name,
                        Character = mc.Character,
                        ProfilePath = mc.Cast.ProfilePath
                    }).ToList(),
                    Trailers = trailers.Select(t => new TrailerModel
                    {
                        Id = t.Id,
                        Name = t.Name,
                        TrailerUrl = t.TrailerUrl,
                        MovieId = t.MovieId
                    }).ToList(),
                    Genres = genres.Select(g => new GenreModel
                    {
                        Id = g.Id,
                        Name = g.Name
                    })
                };
                return movieDetailsModel;
             }
            return null;
        }

        public List<MovieCardModel> GetTop20Movies()
        {
            var movies = _movieRepository.GetTop20Movies();
            var movieCardModels = new List<MovieCardModel>();

            foreach(var movie in movies)
            {
                movieCardModels.Add(new MovieCardModel()
                {
                    Id = movie.Id,
                    PosterURL = movie.PosterUrl,
                    Title = movie.Title
                });
            }

            return movieCardModels;
        }

        public List<MovieCardModel> GetAllMovies()
        {
            var movies = _movieRepository.GetAllMovies();
            var movieCardModels = new List<MovieCardModel>();

            foreach (var movie in movies)
            {
                movieCardModels.Add(new MovieCardModel()
                {
                    Id = movie.Id,
                    PosterURL = movie.PosterUrl,
                    Title = movie.Title
                });
            }

            return movieCardModels;
        }
    }
}
