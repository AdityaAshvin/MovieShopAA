using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ApplicationCore.Entities;
using ApplicationCore.Models;

namespace ApplicationCore.Contracts.Repositories
{
    public interface IGenreRepository : IRepository<Genre>
    {
        IEnumerable<Genre> GetAllGenres();

        IEnumerable<Movie> GetMoviesByGenre(int id);

        Genre GetGenreById(int id);
    }
}
