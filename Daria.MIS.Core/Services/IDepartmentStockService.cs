using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IDepartmentStockService
    {
        void AddPurchase(DepartmentStock purchaseEntry);
        bool UpdatePurchase(DepartmentStock purchaseEntry);
        bool DeletePurchase(DepartmentStock model);
        DepartmentStock GetPurchaseDetails(long id, long pharmacyId);
        List<DepartmentStock> GetPurchaseList(int pharmacyId);
        List<DepartmentStock> RptCurrentStock(DepartmentStockSearchDTO searchDto);
    }
}
