using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ApplicationCore.Models;

namespace ApplicationCore.Contracts.Services
{
public interface IMovieService
    {
        //all the business logic
        List<MovieCardModel> GetTop20Movies();

        List<MovieCardModel> GetAllMovies();

        MovieDetailsModel GetMovieDetails(int Id);

        public bool DeleteMovie(int Id);
    }
}
