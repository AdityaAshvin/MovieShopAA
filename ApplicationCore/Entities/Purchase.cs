using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class Purchase
    {
        public int MovieId { get; set; }
        //navigation property
        public Movie Movie { get; set; }
        public int UserId { get; set; }
        //navigation property
        public User User { get; set; }
        public DateTime? PurchaseDateTime { get; set; }
        public Guid? PurchaseNumber { get; set; }
        [Range(0, 999.99)]
        public decimal? TotalPrice { get; set; }
    }
}
