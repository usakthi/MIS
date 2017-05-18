using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface IEditedBillTenant
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }

    public class EditedBillSearchDTO : Search
    {
        public EditedBillSearchDTO()
            : base()
        {
            this.SortColumn = "Id";
            SortBy = SortOrder.DESC;
        }
        public int PharmacyId { get; set; }        
        public string BillNo { get; set; }
        public DateTime? BillDate { get; set; }
        public string Customer { get; set; }
        public int IPId { get; set; }
       
        public long? EditedById { get; set; }  
        public DateTime? EditedFrom { get; set; }
        public DateTime? EditedTo { get; set; }

        public string OrderBy { get; set; }
    }

    public class EditedBill : IEditedBillTenant
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string BillNo { get; set; }
        public DateTime BillDate { get; set; }
        public string IPId { get; set; }
        public string Customer { get; set; }
        public decimal TotalVAT { get; set; }
        public decimal NetAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public string Status { get; set; }
        public string PayMode { get; set; }
        public string Comment { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string AddedUserName { get; set; }
        public User SavedUser { get; set; }
    }

}
