using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IIndentReceivableService
    {
        void AddPurchase(IndentReceivable purchaseEntry);
        bool UpdatePurchase(IndentReceivable purchaseEntry);
        bool DeletePurchase(IndentReceivable model);
        IndentReceivable GetPurchaseDetails(long id, long pharmacyId);
        List<IndentReceivable> GetPurchaseList(int pharmacyId);
        IndentReceivable GetIndentDetails(long id, long pharmacyId);
        List<IndentReceivable> GetDuePatientList();
    }
}
