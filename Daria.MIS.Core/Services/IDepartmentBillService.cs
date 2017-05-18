using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IDepartmentBillService
    {
        void AddPurchase(DepartmentBill purchaseEntry);
        bool UpdatePurchase(DepartmentBill purchaseEntry);
        bool DeletePurchase(DepartmentBill model);
        DepartmentBill GetPurchaseDetails(long id, long pharmacyId);
        List<DepartmentBill> GetPurchaseList(int pharmacyId);
        DepartmentBill GetIndentDetails(long id, long pharmacyId);
    }
}
