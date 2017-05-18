using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    /// <summary>
    /// Pharmacy is nothing but Tenant
    /// </summary>
    /// 

    public class Pharmacy 
    {
        public int Id { get; set; }
        public string EncPharmacyId { get; set; } 
        public long? ParentId { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
        public string AltPhone { get; set; }
        public string Email { get; set; }
        public string Fax { get; set; }
        public string WebSite { get; set; }
        public Address Address { get; set; }       
        public Person ContactPerson { get; set; }
        public string TINRegNo { get; set; }         
        public string DrugLicenceNo { get; set; }
        public string CompanyName { get; set; }
        public Pharmacy ParentPharmacy { get; set; }
        public long AddedBy { get; set; }
        public DateTime AddedDateTime { get; set; }
        public bool IsDeleted { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
    }
}
