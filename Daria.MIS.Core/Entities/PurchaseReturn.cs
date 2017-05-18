using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantPurRet
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }
    public class PurchaseReturn : ITenantPurRet
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string ReturnNo { get; set; }
        public DateTime ReturnDate { get; set; }
        public string GrnNo { get; set; }
        public DateTime GrnDate { get; set; }
        public string RetNo { get; set; }
        public DateTime RetDate { get; set; }
        public Supplier Supplier { get; set; }
        public int SupplierId { get; set; }
        public string SupplierInvNo { get; set; }
        public DateTime? SupplierInvDate { get; set; }
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

        public List<PurchaseReturnItem> PurchaseReturnItems { get; set; }

        public User SavedUser { get; set; }

        public List<PurchaseReturn> InvoiceProductList { get; set; }

        public long ProductId { get; set; }
        public string Name { get; set; }
        //public int TypeId { get; set; }
        //public int CategoryId { get; set; }
        //public int MainCategoryId { get; set; }
        //public int GenericId { get; set; }
        public int ManfId { get; set; }
        public int AddedbyUserId { get; set; }
        public string Category { get; set; }
        public string Manufacture { get; set; }
        public string DrugName { get; set; }
        public long SlNo { get; set; }

        public int Stock { get; set; }
        //public string GRNNo { get; set; }
        //public string GRNDate { get; set; }
        public string ExpDate { get; set; }

        //public DrugCategory DrugCategory { get; set; }
        //public DrugGeneric DrugGeneric { get; set; }
        //public DrugUnit DrugUnit { get; set; }
        //public DrugContent DrugContent { get; set; }
        //public DrugType DrugType { get; set; }
        //public Tax Tax { get; set; }

        public decimal Discount { get; set; }
        public string BatchNo { get; set; }
        public decimal CostPrice { get; set; }
        public decimal MRP { get; set; }
        public decimal VAT { get; set; }
        public long PurDetId { get; set; }
        //public Manufacturer Manufacturer { get; set; }

        public int MfgId { get; set; }
        public string MfgName { get; set; }
        public string TaxType { get; set; }
        public string TaxMode { get; set; }
        public int Pack { get; set; }
        public int PurStk { get; set; }
    }

    public class PurchaseReturnItem
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public long PurchaseId { get; set; }
        public long ProductId { get; set; }
        public string BatchNo { get; set; }
        public int Qty { get; set; }
        public int FreeQty { get; set; }

        public long ManufacturerId { get; set; }
        public long ManfId { get; set; }
        public long UnitId { get; set; }

        public string ExpiryDate { get; set; }
        public string ExpDate { get; set; }
        public int Packing { get; set; }

        public decimal CostPrice { get; set; } 
        public decimal MRP { get; set; }
        public decimal VAT { get; set; }
        
        public decimal AbatedMRP { get; set; }

        public string TaxMode { get; set; }
        public string TaxType { get; set; }
        public bool DiscApplicable { get; set; }
        public bool VATOnDiscount { get; set; }
        public bool VATOnFreeQty { get; set; }
        public bool DiscOnFreeQty { get; set; }

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

        public long RackId { get; set; }
        public long PurDetId { get; set; }
        public string Barcode { get; set; }

        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        //public Manufacturer Manufacturer { get; set; }
        //public DrugUnit Unit { get; set; }
        //public Product Product { get; set; }
        //public Rack Rack { get; set; }

        public string ProductName { get; set; }
        public string ManufacturerName { get; set; }

        public bool isNew { get; set; }
    }
}
