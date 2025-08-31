using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class MovieCast
    {
        public int CastId { get; set; }
        //navigation property
        public Cast Cast { get; set; }
        [MaxLength(450)]
        public string Character { get; set; }
        public int MovieId { get; set; }
        //navigation property
        public Movie Movie { get; set; }
    }
}
