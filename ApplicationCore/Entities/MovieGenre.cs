using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class MovieGenre
    {
        public int MovieId { get; set; }
        public int GenreId { get; set; }
        //navigation proprty
        public Genre Genre { get; set; }
        public Movie Movie { get; set; }
    }
}
