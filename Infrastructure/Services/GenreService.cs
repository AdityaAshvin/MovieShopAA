using ApplicationCore.Contracts.Repositories;
using ApplicationCore.Contracts.Services;
using ApplicationCore.Entities;
using ApplicationCore.Models;
using Infrastructure.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Services
{
    public class GenreService : IGenreService
    {
        private readonly IGenreRepository _genreRepository;
        public GenreService(IGenreRepository genreRepository)
        {
            _genreRepository = genreRepository;
        }

        public List<GenreModel> GetAllGenres()
        {
            var genres = _genreRepository.GetAllGenres();
            var genreModels = new List<GenreModel>();

            foreach (var genre in genres)
            {
                genreModels.Add(new GenreModel()
                {
                    Id = genre.Id,
                    Name = genre.Name,
                });
            }
            return genreModels;
        }

        public List<MovieCardModel> GetMoviesByGenre(int id)
        {
            var movies = _genreRepository.GetMoviesByGenre(id);
            return movies.Select(m => new MovieCardModel
            {
                Id = m.Id,
                Title = m.Title,
                PosterURL = m.PosterUrl
            }).ToList();
        }

        public GenreModel GetGenreById(int id)
        {
            var genre = _genreRepository.GetGenreById(id);
            if (genre == null) return null;

            return new GenreModel
            {
                Id = genre.Id,
                Name = genre.Name
            };
        }
    }
}
