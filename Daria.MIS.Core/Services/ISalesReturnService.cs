using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface ISalesReturnService
    {
        void AddPurchase(SalesReturn purchaseEntry);
        bool UpdatePurchase(SalesReturn purchaseEntry);
        bool DeletePurchase(SalesReturn model);
        SalesReturn GetPurchaseDetails(long id, long pharmacyId);
        List<SalesReturn> GetPurchaseList(int pharmacyId);
        //SalesReturn GetDepartmentItems(long id, long pharmacyId);
        SalesReturn GetSalesItems(string no, string category);
    }
}
