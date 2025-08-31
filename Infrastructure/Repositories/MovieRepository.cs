using ApplicationCore.Contracts.Repositories;
using ApplicationCore.Entities;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Repositories
{
    public class MovieRepository : BaseRepository<Movie>, IMovieRepository
    {
        public MovieRepository(MovieShopDbContext dbContext) : base(dbContext)
        {

        }
        public IEnumerable<Movie> GetTop20Movies()
        {
            var movies = _movieShopDbContext.Movies.OrderByDescending(m => m.Revenue).Take(20);
            return movies;
        }
        public IEnumerable<Movie> GetAllMovies()
        {
            var movies = _movieShopDbContext.Movies.OrderByDescending(m => m.ReleaseDate);
            return movies;
        }
        public Movie? GetMovieByIdWithCasts(int id)
        {
            return _movieShopDbContext.Movies.Include(m => m.MovieCasts).ThenInclude(mc => mc.Cast).AsNoTracking().FirstOrDefault(m => m.Id == id);
        }
        public IEnumerable<Trailer> GetTrailersByMovieId(int id)
        {
            return _movieShopDbContext.Trailer.Where(t => t.MovieId == id).ToList();
        }
        public IEnumerable<Genre> GetGenresByMovieId(int id)
        {
            return _movieShopDbContext.MovieGenres.Where(mg => mg.MovieId == id).Select(mg => mg.Genre).AsNoTracking().Distinct().ToList();
        }

        public IEnumerable<Review> GetRatingByMovieId(int id)
        {
            return _movieShopDbContext.Reviews.Where(r => r.MovieId == id);
        }
    }
}
