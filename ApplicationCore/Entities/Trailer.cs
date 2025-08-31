using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class Trailer
    {
        public int Id { get; set; }
        //Explicity mention
        [ForeignKey("Movie")]
        public int MovieId { get; set; }
        //navigation property
        public Movie Movie {  get; set; }
        [MaxLength(256)]
        public string? Name { get; set; }
        [MaxLength(256)]
        public string? TrailerUrl { get; set; }
    }
}
