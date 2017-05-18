using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IDepartmentUsageService
    {
        void AddPurchase(DepartmentUsage purchaseEntry);
        bool UpdatePurchase(DepartmentUsage purchaseEntry);
        bool DeletePurchase(DepartmentUsage model);
        DepartmentUsage GetPurchaseDetails(long id, long pharmacyId);
        List<DepartmentUsage> GetPurchaseList(int pharmacyId);
        DepartmentUsage GetDepartmentItems(long id, long pharmacyId);
    }
}
