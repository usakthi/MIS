using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantsupplierpayable
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }
    public class SupplierPayable : ITenantsupplierpayable
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string PayNo { get; set; }
        public long SupplierId { get; set; }
        public string Name { get; set; }
        public string TinNo { get; set; }
        public string DLNo { get; set; }
        public long SNo { get; set; }
        public string GRNNo { get; set; }
        public DateTime GRNDate { get; set; }
        public string InvNo { get; set; }
        public DateTime InvDate { get; set; }
        
        public decimal NetAmount { get; set; }      
        public decimal PaidAmount { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalPayable { get; set; }
        public string PayStatus { get; set; }
        public string Comment { get; set; }
        public Person AddedPerson { get; set; }
        public Supplier Supplier { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public string AddedUserName { get; set; }

        public List<SupplierPayableItem> SupplierPayableItems { get; set; }

        public User SavedUser { get; set; }
        public decimal Balance { get; set; }
        public string PayMode { get; set; }
        public string ChequeNo { get; set; }
        public string Comments { get; set; }
        public string ChequeDate { get; set; }
    }

    public class SupplierPayableItem
    {
        public long Id { get; set; }
        public int SupplierId { get; set; }
        public int PharmacyId { get; set; }
        public long PayId { get; set; }
        public string PayNo { get; set; }
        
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Supplier Supplier { get; set; }
        
        public string GrnNo { get; set; }
        public string GrnDate { get; set; }
        public string InvNo { get; set; }
        public string InvDate { get; set; }
        
        public bool isNew { get; set; }

        public decimal NetAmount { get; set; }
        public decimal Balance { get; set; }
        public decimal PaidAmount { get; set; }
    }

    public class SupplierPayableDueList
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string PayNo { get; set; }
        public long CustomerId { get; set; }
        public string CustomerName { get; set; }

        public string BillNo { get; set; }
        public DateTime BillDate { get; set; }

        public decimal TotalAmount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal Discount { get; set; }
        public string PayStatus { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string AddedUserName { get; set; }

        public User SavedUser { get; set; }
        public decimal Balance { get; set; }
        public string PayMode { get; set; }
        public string ChequeNo { get; set; }
        public string Comments { get; set; }
        public DateTime ChequeDate { get; set; }

        public decimal Payable { get; set; }
        public decimal BillCode { get; set; }

        public long PayId { get; set; }
        public string PayDate { get; set; }
        public int SupplierId { get; set; }
        public string GrnNo { get; set; }
    }
}
