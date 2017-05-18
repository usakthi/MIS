using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantDepartmentIndent
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }
    public class DepartmentIndent : ITenantDepartmentIndent
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string IndentNo { get; set; }
        public DateTime IndentDate { get; set; }
        public long POrderNo { get; set; }
        public string PatientName { get; set; }
        public string Consultant { get; set; }
        public string IPNo { get; set; }
        public string DeptName { get; set; }
        public string Ward { get; set; }
        public string PayMode { get; set; }
        public string IndentUser { get; set; }
        
        public string Status { get; set; }
        public string Comment { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public string AddedUserName { get; set; }

        public List<DepartmentIndentItem> IndentItems { get; set; }

        public User SavedUser { get; set; }

        
    }

    public class DepartmentIndentItem
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public long IndentId { get; set; }
        public long ProductId { get; set; }
        public string BatchNo { get; set; }
        public int Qty { get; set; }
        public int OldQty { get; set; }
        public int PurDetId { get; set; }

        public long ManufacturerId { get; set; }

        public string ExpDate { get; set; }

        public decimal CostPrice { get; set; } 
        public decimal MRP { get; set; }
        public decimal TaxPercent { get; set; }
        public decimal TaxAmount { get; set; }
        public int CancelFlag { get; set; }
        public int EditProduct { get; set; }
        public decimal DiscPercent { get; set; }

        public decimal Discount { get; set; }

        public decimal TotalCostPrice { get; set; }
        public decimal TotalMRP { get; set; }

        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Manufacturer Manufacturer { get; set; }
        public DrugUnit Unit { get; set; }
        public Product Product { get; set; }
        public Rack Rack { get; set; }

        public string ProductName { get; set; }
        public string ManufacturerName { get; set; }
        public string GRNNo { get; set; }
        public string Stock { get; set; }
        public bool isNew { get; set; }
    }
}
