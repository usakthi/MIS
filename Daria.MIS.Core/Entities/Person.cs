using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public class Person
    {
        public int PharmacyId { get; set; }
        public long PersonId { get; set; }
        public string EncPersonId { get; set; }
        public string EncPharmacyId { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set; }
        public string Gender { get; set; }
        public DateTime? DOB { get; set; }
        public string MobileNumber { get; set; }
        public string Email { get; set; }
        public Address Address { get; set; }
        public long AddedBy { get; set; }
        public DateTime AddedDateTime { get; set; }
        public bool IsDeleted { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string PersonImage { get; set; }
    }


  
} 
