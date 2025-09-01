using ApplicationCore.Contracts.Repositories;
using ApplicationCore.Entities;
using Infrastructure.Data;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Repositories
{
    public class ActorRepository : BaseRepository<Movie>, IActorRepository
    {
        public ActorRepository(MovieShopDbContext dbContext): base(dbContext)
        {

        }
        public Cast GetActorById(int id)
        {
            return _movieShopDbContext.Cast.FirstOrDefault(c => c.Id == id);
        }

        public IEnumerable<Movie> GetMoviesByCastId(int castID)
        {
            var movies = _movieShopDbContext.MovieCasts.Where(mc => mc.CastId == castID).Select(mc => mc.Movie).Distinct().OrderByDescending(m => m.ReleaseDate).ToList();
            return movies;
        }
    }
}
