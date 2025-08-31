using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class Favourite
    {
        public int MovieId { get; set; }
        //navigation property
        public Movie Movie { get; set; }
        public int UserId { get; set; }
        //navigation property
        public User User {  get; set; }
    }
}
