using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IPurchaseReturnService
    {
        void AddPurchase(PurchaseReturn purchaseEntry);
        bool UpdatePurchase(PurchaseReturn purchaseEntry);
        bool DeletePurchase(PurchaseReturn model);
        PurchaseReturn GetPurchaseDetails(long id, long pharmacyId);
        List<PurchaseReturn> GetPurchaseList(int pharmacyId);
        List<PurchaseReturn> GetProductsForPurchaseReturn(string q);

        PurchaseReturn GetPurchasedItems(string no, string category);
        List<PurchaseReturn> GetSupplierInvoices(string no, string category);
    }
}
