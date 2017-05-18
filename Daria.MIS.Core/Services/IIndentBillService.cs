using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IIndentBillService
    {
        void AddPurchase(IndentBill purchaseEntry);
        bool UpdatePurchase(IndentBill purchaseEntry);
        bool DeletePurchase(IndentBill model);
        IndentBill GetPurchaseDetails(long id, long pharmacyId);
        List<IndentBill> GetPurchaseList(int pharmacyId);
        IndentBill GetIndentDetails(long id, long pharmacyId);
    }
}
