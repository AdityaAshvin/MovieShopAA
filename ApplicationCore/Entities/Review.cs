using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class Review
    {
        public int MovieId { get; set; }
        //navigation property
        public Movie Movie { get; set; }
        public int UserId { get; set; }
        //navigation property
        public User User {  get; set; }
        public DateTime? CreatedDate { get; set; }
        [Range(0, 9.99)]
        public decimal? Rating { get; set; }
    }
}
