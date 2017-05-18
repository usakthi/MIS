using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IPurchaseReturnRepository : IRepository<PurchaseReturn>
    {
        void AddPurchaseReturnHeader(PurchaseReturn purchasereturnHeader, IDbConnection conn, IDbTransaction transaction);
        void AddPurchaseReturnItem(PurchaseReturnItem purchasereturnItem, IDbConnection conn, IDbTransaction transaction);

        PurchaseReturn FindPurchasedItems(string no, string category);
        //PurchaseReturn FindSupplierInvoices(string q);
    }

}
