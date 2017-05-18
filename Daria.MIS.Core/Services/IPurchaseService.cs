using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IPurchaseService
    {
        void AddPurchase(Purchase purchaseEntry);
        bool UpdatePurchase(Purchase purchaseEntry);
        bool DeletePurchase(Purchase model);
        Purchase GetPurchaseDetails(long id, long pharmacyId);
        List<Purchase> GetPurchaseList(int pharmacyId);
        List<Purchase> SearchPurchases(PurchaseSearchDTO searchDto);
        List<PurchaseItem> GetPurchaseItems(long pharmacyId, long q);
        List<Purchase> GetInvoicesList();
    }
}
