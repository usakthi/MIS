using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface ICurrentStockService
    {
        void AddPurchase(CurrentStock purchaseEntry);
        bool UpdatePurchase(CurrentStock purchaseEntry);
        bool DeletePurchase(CurrentStock model);
        CurrentStock GetPurchaseDetails(long id, long pharmacyId);
        List<CurrentStock> GetPurchaseList(int pharmacyId);
        List<CurrentStock> RptCurrentStock(CurrentStockSearchDTO searchDto);
    }
}
