using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IDepartmentIndentService
    {
        void AddPurchase(DepartmentIndent purchaseEntry);
        bool UpdatePurchase(DepartmentIndent purchaseEntry);
        bool DeletePurchase(DepartmentIndent model);
        DepartmentIndent GetPurchaseDetails(long id, long pharmacyId);
        List<DepartmentIndent> GetPurchaseList(int pharmacyId);
        List<DepartmentIndent> GetIndents();
    }
}
