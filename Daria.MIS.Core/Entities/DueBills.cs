using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantDueBills
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }

    public class DueBills : ITenantDueBills
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public bool isNew { get; set; }
        //public List<DueBillsItem> DueBillsItems { get; set; }
        public string PharmacyIdEnc { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public User SavedUser { get; set; }

        public long BillCode { get; set; }
        public string BillNo { get; set; }
        public string Customer { get; set; }
        public string ConsultantName { get; set; }

        public decimal TotalAmount { get; set; }
        public decimal Discount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal Balance { get; set; }
        public string SalesMode { get; set; }
        public string UserName { get; set; }
        public DateTime BillDate { get; set; }
        public string PayMode { get; set; }
        public decimal RoundOff { get; set; } 
        public decimal DuePaidAmount { get; set; }
        public decimal DueAmount { get; set; }
    }

    //public class DueBillsItem
    //{
    //    public long ProductId { get; set; }
    //    public long PurDetId { get; set; }
    //    public string GRNNo { get; set; }

    //    public long Id { get; set; }
    //    public int PharmacyId { get; set; }
        
    //    public string BatchNo { get; set; }
    //    public int Qty { get; set; }
    //    public int CurStk { get; set; }
    //    public int Pur { get; set; }
    //    public int PurRet { get; set; }
    //    public int Sal { get; set; }
    //    public int SalRet { get; set; }
    //    public int OpenStk { get; set; }
    //    public int StkAdj { get; set; }
    //    public int PreMRP { get; set; }
    //    public int SavedUser { get; set; }

    //    public long ManufacturerId { get; set; }
    //    public string ExpiryDate { get; set; }
    //    public decimal CostPrice { get; set; }
    //    public decimal MRP { get; set; }
        
    //    public Person AddedPerson { get; set; }
    //    public DateTime AddedDateTime { get; set; }
    //    public Manufacturer Manufacturer { get; set; }
    //    public Product Product { get; set; }
    //    public string ProductName { get; set; }
    //    public string ManufacturerName { get; set; }

    //    public bool isNew { get; set; }
    //    public string PharmacyIdEnc { get; set; }
    //    //public User SavedUser { get; set; }
    //}
}
