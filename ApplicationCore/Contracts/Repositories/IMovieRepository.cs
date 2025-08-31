using ApplicationCore.Entities;
using ApplicationCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Contracts.Repositories
{
    public interface IMovieRepository: IRepository<Movie>
    {
        IEnumerable<Movie> GetTop20Movies();
        IEnumerable<Movie> GetAllMovies();
        Movie GetMovieByIdWithCasts(int id);
        IEnumerable<Trailer> GetTrailersByMovieId(int id);

        IEnumerable<Genre> GetGenresByMovieId(int id);
        IEnumerable<Review> GetRatingByMovieId(int id);
    }
}
