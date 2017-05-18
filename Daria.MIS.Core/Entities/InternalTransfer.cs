﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public interface ITenantIntTrans
    {
        int PharmacyId { get; set; }
        string PharmacyIdEnc { get; set; }
    }
    public class IntTrans : ITenantIntTrans
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public string PharmacyIdEnc { get; set; }
        public string BillNo { get; set; }
        public DateTime BillDate { get; set; }
        public long POrderNo { get; set; }
        public string Customer { get; set; }
        public string ConsultantName { get; set; }
        public decimal DiscountPercent { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal TotalVAT { get; set; }
        public decimal NetAmount { get; set; }
        public decimal RoundOff { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal Balance { get; set; }
        public string BillStatus { get; set; }
        public string Comment { get; set; }
        public Person AddedPerson { get; set; }
        public DateTime AddedDateTime { get; set; }
        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public string AddedUserName { get; set; }

        public List<IntTransItem> IntTransItems { get; set; }

        public User SavedUser { get; set; }

        
    }

    public class IntTransItem
    {
        public long Id { get; set; }
        public int PharmacyId { get; set; }
        public long BillCode { get; set; }
        public long IntTransCode { get; set; }
        public long ProductId { get; set; }
        public string BatchNo { get; set; }
        public int Qty { get; set; }
        public int OldQty { get; set; }
        public int Stock { get; set; }

        public long ManufacturerId { get; set; }
        public long ManfId { get; set; }

        public string ExpiryDate { get; set; }
        public string ExpDate { get; set; }
        public string GRNNo { get; set; }
        
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
        //public Manufacturer Manufacturer { get; set; }
        public DrugUnit Unit { get; set; }
        public Product Product { get; set; }
        public Rack Rack { get; set; }

        public string ProductName { get; set; }
        public string ManufacturerName { get; set; }
        public long PurDetId { get; set; }
        public bool isNew { get; set; }

        public string Manufacturer { get; set; }
        public decimal VAT { get; set; }
        public decimal VATAmount { get; set; }
    }
}
