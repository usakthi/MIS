using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantCurrentStock
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }

    public class CurrentStockSearchDTO : Search
    {
        public CurrentStockSearchDTO()
            : base()
        {
            this.SortColumn = "Id";
            SortBy = SortOrder.DESC;
        }
        public int PharmacyId { get; set; }        
        public string GrnNo { get; set; }
        public DateTime? GrnDate { get; set; }
        public string SupplierInvNo { get; set; }
        public int SupplierId { get; set; }
       
        public long? AddedById { get; set; }  
        public DateTime? AddedFrom { get; set; }
        public DateTime? AddedTo { get; set; }

        public string OrderBy { get; set; }
       

    }

    public class CurrentStock : ITenantCurrentStock
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public long POrderNo { get; set; }
        public decimal CostPrice { get; set; }
        public decimal Mrp { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalMrp { get; set; }
        public decimal Vat { get; set; }
        public long SNo { get; set; }
        public string DrugName { get; set; }
        public int Qty { get; set; }
        public string BatchNo { get; set; }
        public Manufacturer Manufacturer { get; set; }
        public DrugCategory Category { get; set; }
    }
}
