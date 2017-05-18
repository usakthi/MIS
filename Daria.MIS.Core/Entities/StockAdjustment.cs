using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantStockadjust
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }

    public class StockAdjustment : ITenantStockadjust
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public bool isNew { get; set; }
        public List<StockAdjustmentItem> StockAdjustmentItems { get; set; }
        public string PharmacyIdEnc { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public User SavedUser { get; set; }

        public string BatchNo { get; set; }
        public int Qty { get; set; }
        public decimal MRP { get; set; }
        public string ProductName { get; set; }
        public string ManufacturerName { get; set; }
        
        public int CurStk { get; set; }
        public int Pur { get; set; }
        public int PurRet { get; set; }
        public int Sal { get; set; }
        public int SalRet { get; set; }
        public int OpenStk { get; set; }
        public int StkAdj { get; set; }
        public decimal PreMRP { get; set; }
        public string UserName { get; set; }
        public string ExpiryDate { get; set; }
    }

    public class StockAdjustmentItem
    {
        public long ProductId { get; set; }
        public long PurDetId { get; set; }
        public string GRNNo { get; set; }

        public long Id { get; set; }
        public int PharmacyId { get; set; }
        
        public string BatchNo { get; set; }
        public int Qty { get; set; }
        public int CurStk { get; set; }
        public int Pur { get; set; }
        public int PurRet { get; set; }
        public int Sal { get; set; }
        public int SalRet { get; set; }
        public int OpenStk { get; set; }
        public int StkAdj { get; set; }
        public int PreMRP { get; set; }
        public int SavedUser { get; set; }

        public long ManufacturerId { get; set; }
        public string ExpiryDate { get; set; }
        public decimal CostPrice { get; set; }
        public decimal MRP { get; set; }
        
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public Manufacturer Manufacturer { get; set; }
        public Product Product { get; set; }
        public string ProductName { get; set; }
        public string ManufacturerName { get; set; }

        public bool isNew { get; set; }
        public string PharmacyIdEnc { get; set; }
        //public User SavedUser { get; set; }
    }
}
