using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class User
    {
        public int Id { get; set; }
        public DateTime? DateOfBirth { get; set; }
        [MaxLength(256)]
        public string? Email { get; set; }
        [MaxLength(128)]
        public string? FirstName { get; set; }
        [MaxLength(1024)]
        public string? HashedPassword {  get; set; }
        public bool? isLocked { get; set; }
        [MaxLength(128)]
        public string? LastName { get; set; }
        [MaxLength(16)]
        public string? PhoneNumber {  get; set; }
        public string? ProfilePictureUrl { get; set; }
        [MaxLength(1024)]
        public string? Salt { get; set; }
        //navigation property
        public ICollection<Review> Reviews { get; set; }
        public ICollection<Favourite> Favourites { get; set; }
        public ICollection<Purchase> Purchases { get; set; }
        public ICollection<UserRole> UserRoles { get; set; }
    }
}
