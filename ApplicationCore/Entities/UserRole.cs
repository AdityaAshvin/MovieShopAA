using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.Entities
{
    public class UserRole
    {
        public int RoleId { get; set; }
        //navigation property
        public Role Role { get; set; }
        public int UserId { get; set; }
        //navigation property
        public User User { get; set; }
    }
}
