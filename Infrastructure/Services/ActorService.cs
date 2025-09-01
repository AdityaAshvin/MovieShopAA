using ApplicationCore.Contracts.Repositories;
using ApplicationCore.Contracts.Services;
using ApplicationCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Services
{
    public class ActorService : IActorService
    {
        private readonly IActorRepository _actorRepository;
        public ActorService(IActorRepository actorRepository)
        {
            _actorRepository = actorRepository;
        }
        public ActorModel GetActorById(int Id)
        {
            var actor = _actorRepository.GetActorById(Id);

            return new ActorModel
            {
                Id = actor.Id,
                Name = actor.Name,
                ProfilePath = actor.ProfilePath,
                TmdbURL = actor.TmbdUrl
            };
        }

        public List<MovieCardModel> GetMoviesByCastId(int castId)
        {
            var movies = _actorRepository.GetMoviesByCastId(castId);
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
