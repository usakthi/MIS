using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenant
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }

    public enum SortOrder
    {
        DESC,
        ASC
    }
    public abstract class Search
    {
        protected Search()
        {

            PageNo = 1;
            SortBy = SortOrder.DESC;
            PageSize = 10;
        }
        public int StartRowNo
        {
            get
            {
                return (PageNo - 1) * PageSize;
            }

        }
        public int PageSize { get; set; }
        public int EndRowNo
        {
            get
            {
                return StartRowNo + PageSize;
            }

        }
        public int TotalPages
        {
            get
            {
                return (int)Math.Ceiling((float)TotalRecords / (float)PageSize);
            }
            set { }

        }
        public int PageNo { get; set; }
        public long TotalRecords { get; set; }
        public SortOrder SortBy { get; set; }
        public string SortColumn { get; set; }
        public long TenantId { get; set; }
        public string SortText
        {
            get
            {
                return this.SortColumn + this.SortBy.ToString();
            }
        }

    }

    public class PurchaseSearchDTO : Search
    {
        public PurchaseSearchDTO()
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

    public class Purchase : ITenant
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string GrnNo { get; set; }
        public DateTime GrnDate { get; set; }
        public long POrderNo { get; set; }
        public Supplier Supplier { get; set; }
        public int SupplierId { get; set; }
        public string SupplierInvNo { get; set; }
        public DateTime? SupplierInvDate { get; set; }
        public int CreditPeriod { get; set; }
        public DateTime? CreditDate { get; set; }
        public decimal DiscountPercent { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal TotalVAT { get; set; }
        public decimal NetAmount { get; set; }
        public decimal RoundOff { get; set; }
        public bool IsPaid { get; set; }
        public decimal PaidAmount { get; set; }
        public string Status { get; set; }
        public string Comment { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public string AddedUserName { get; set; }

        public List<PurchaseItem> PurchaseItems { get; set; }

        public User SavedUser { get; set; }

        public long SNo { get; set; }
        public string SaveStatus { get; set; }
        public string Name { get; set; }
        public string SupName { get; set; }
        public string TinNo { get; set; }
    }

    public class PurchaseItem
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public long PurchaseId { get; set; }
        public long ProductId { get; set; }
        public string BatchNo { get; set; }
        public int Qty { get; set; }
        public int FreeQty { get; set; }

        public long ManufacturerId { get; set; }
        public long UnitId { get; set; }

        public string ExpiryDate { get; set; }
        public int Packing { get; set; }

        public decimal CostPrice { get; set; } 
        public decimal MRP { get; set; }
        public decimal VAT { get; set; }
        
        
        public decimal AbatedMRP { get; set; }

        public string TaxMode { get; set; }
        public string TaxType { get; set; }
        public string DiscApplicable { get; set; }
        public string VATOnDiscount { get; set; }
        public string VATOnFreeQty { get; set; }
        public string DiscOnFreeQty { get; set; }


        public decimal DiscountPercentage { get; set; }


        public int AssortedQty { get; set; }
        public decimal AssortedCostPrice { get; set; }
        public decimal AssortedMRPPrice { get; set; }
        
        public decimal FreeQtyVATAmount { get; set; }
        public decimal DiscountAmount { get; set; }

        public decimal VATAmount { get; set; }
        public decimal TotalCostPrice { get; set; }
        public decimal NetCostPrice { get; set; }
        public decimal TotalMRP { get; set; }
        public decimal NetMRP { get; set; }
        public decimal VatOnDiscountAmount { get; set; }
        public decimal DiscOnFreeQtyAmount { get; set; }
        public decimal TotalDiscountAmount { get; set; }
        public decimal TotalVatAmount { get; set; }
        public decimal NetVATAmount { get; set; }
        public long PurDetId { get; set; } 

        public long RackId { get; set; }
        public string Barcode { get; set; }

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

        public bool isNew { get; set; }
        public string SaveStatus { get; set; }
    }

    public class OpenStock
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }

        public long DrugId { get; set; }
        public string BatchNo { get; set; }


        public long ManufacturerId { get; set; }


        public string ExpiryDate { get; set; }
        public int TotalQty { get; set; }
        public int Packing { get; set; }

        public int AssortedQty { get; set; }
        public decimal CostPrice { get; set; }
        public decimal AssortedCostPrice { get; set; }
        public decimal MRP { get; set; }
        public decimal AssortedMRPPrice { get; set; }
        public decimal VAT { get; set; }
        public string VATType { get; set; }
        public decimal VATAmount { get; set; }
        public bool isNew { get; set; }
    }
}
