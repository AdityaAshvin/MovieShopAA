using ApplicationCore.Contracts.Repositories;
using ApplicationCore.Entities;
using ApplicationCore.Models;
using Infrastructure.Data;
using Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Repositories
{
    public class GenreRepository : BaseRepository<Genre>, IGenreRepository
    {
        public GenreRepository(MovieShopDbContext dbContext) : base(dbContext)
        {

        }
        public IEnumerable<Genre> GetAllGenres()
        {
            var genres = _movieShopDbContext.Genres.AsNoTracking().ToList();
            return genres;
        }
        public IEnumerable<Movie> GetMoviesByGenre(int id)
        {
            return _movieShopDbContext.MovieGenres.Where(mg => mg.GenreId == id).Select(mg => mg.Movie).Distinct().OrderByDescending(m => m.ReleaseDate).AsNoTracking().ToList(); ;
        }
        public Genre GetGenreById(int id)
        {
            return _movieShopDbContext.Genres.FirstOrDefault(g => g.Id == id);
        }
        public Genre Insert(Genre entity)
        {
            throw new NotImplementedException();
        }

        public Genre Update(Genre entity)
        {
            throw new NotImplementedException();
        }

        Genre IRepository<Genre>.DeleteByID(int id)
        {
            throw new NotImplementedException();
        }

        IEnumerable<Genre> IRepository<Genre>.GetAll()
        {
            throw new NotImplementedException();
        }

        Genre IRepository<Genre>.GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
