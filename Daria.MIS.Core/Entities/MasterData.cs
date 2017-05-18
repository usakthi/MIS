using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{    
    public class DrugUnit
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }
    public class Manufacturer
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class DrugCategory
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class DrugContent
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class DrugType
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class Department
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class Consultant
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class Rack
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }

    public class Tax
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
    }
    public class Bank
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string SlNo { get; set; }
    }

    public class Supplier
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int TypeId { get; set; }
        public string Type { get; set; }
        public string Address { get; set; }
        public string TinNo { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public string ContactPerson { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Pincode { get; set; }
        public string MobileNo { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string SlNo { get; set; }
        public int DueDays { get; set; }
    }

    public class Patient
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int TypeId { get; set; }
        public string Type { get; set; }
        public string Address { get; set; }
        public string TinNo { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public string ContactPerson { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Pincode { get; set; }
        public string MobileNo { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string SlNo { get; set; }
        public int DueDays { get; set; }

        public string PatientName { get; set; }
        public string Age { get; set; }
        public string RegNo { get; set; }
        public string PayMode { get; set; }
        public string Ward { get; set; }
        public string Consultant { get; set; }
        public string IPNo { get; set; }
    }


    public class ProductSearchDTO : Search
    {
        public ProductSearchDTO()
            : base()
        {
            this.SortColumn = "Id";
            SortBy = SortOrder.DESC;
        }
        public int PharmacyId { get; set; }
        public string DrugName { get; set; }
        public string Type { get; set; }
        public string OrderBy { get; set; }
    }

    public class Product
    {
        public long Id { get; set; }
        public string Classification { get; set; }
        public string Name { get; set; }
        public int TypeId { get; set; }
        public int CategoryId { get; set; }
        public int MainCategoryId { get; set; }
        public int GenericId { get; set; }
        public int ManfId { get; set; }
        public int UnitId { get; set; }
        public int MinStock { get; set; }
        public int MaxStock { get; set; }
        public int ExpiryNotifyinDays { get; set; }
        public int ExpiryDays { get; set; }
        public int SuppTakenBeforExpiryDays { get; set; }
        public int TakenBeforeDays { get; set; }
        public int SuppTakenAfterExpiryDays { get; set; }
        public int TakenAfterDays { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string Type { get; set; }
        public string Category { get; set; }
        public string Generic { get; set; }
        public string Manufacture { get; set; }
        public string Unit { get; set; }
        public string MainCategory { get; set; }
        public string DrugName { get; set; }
        public long SlNo { get; set; }

        public string Stock { get; set; }
        public string BatchNo { get; set; }
        public string GRNNo { get; set; }
        public string GRNDate { get; set; }
        public string ExpDate { get; set; }
        public string PurDetId { get; set; }
        public int RackId { get; set; }
        public string RackName { get; set; }
        public int TaxId { get; set; }
        public string TaxName { get; set; }

        public decimal MRP { get; set; }
        public decimal CostPrice { get; set; }
        public decimal VAT { get; set; }

        public DrugCategory DrugCategory { get; set; }
        public DrugGeneric DrugGeneric { get; set; }
        public DrugUnit DrugUnit { get; set; }
        public Manufacturer Manufacturer { get; set; }
        public DrugContent DrugContent { get; set; }
        public DrugType DrugType { get; set; }
        public Rack Rack { get; set; }
        public Tax Tax { get; set; }
        public List<Product> ProductList { get; set; }

        public long BillCode { get; set; }
        public decimal Discount { get; set; }

        public int Pur { get; set; }
        public int PurRet { get; set; }
        public int Sal { get; set; }
        public int SalRet { get; set; }
        public int OpenStk { get; set; }
        public int CurStk { get; set; }
        public int StkAdj { get; set; }
        public decimal PreMRP { get; set; }
    }
    public class CreditAuth
    {
        public int Id { get; set; }
        public string AuthName { get; set; }
        public string DepName { get; set; }
        public string DesigName { get; set; }
        public string FindBy { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string SlNo { get; set; }
    }
    public class DrugGeneric
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string SlNo { get; set; }
    }
    public class PurchaseRequestDetails
    {
        public int RequestId { get; set; }
        public string RequestNo { get; set; }
        public string RequestDate { get; set; }
        public int ProductId { get; set; }
        public int Qty { get; set; }
        public int CurrentStock { get; set; }
        public int ManfId { get; set; }
        public string Status { get; set; }
        public int AddedBy { get; set; }
        public string Reason { get; set; }
        public string DrugName { get; set; }
        public string Manufacturar { get; set; }
        public bool? isActive { get; set; }
        public int AddedbyUserId { get; set; }
        public DateTime AddedDateTime { get; set; }
        public string SlNo { get; set; }

    }

    public class Customer
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Age { get; set; }
        public string Gender { get; set; }
        public string Location { get; set; }
        public string Mobile { get; set; }
        public string Type { get; set; }
        public bool? isActive { get; set; }
        //public int Addedby { get; set; }
        //public DateTime AddedDateTime { get; set; }
    }
}
