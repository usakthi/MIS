using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IPurchaseRepository : IRepository<Purchase>
    {
        void AddPurchaseHeader(Purchase purchaseHeader, IDbConnection conn, IDbTransaction transaction);
        void AddPurchaseItem(PurchaseItem purchaseItem, IDbConnection conn, IDbTransaction transaction);
        List<Purchase> SearchPurchases(PurchaseSearchDTO searchDto);
        List<PurchaseItem> GetPurchaseItems(long tenantId);
    }

}
