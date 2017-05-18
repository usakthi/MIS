using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IInternalTransferReturnService
    {
        void AddPurchase(IntTransReturn purchaseEntry);
        bool UpdatePurchase(IntTransReturn purchaseEntry);
        bool DeletePurchase(IntTransReturn model);
        IntTransReturn GetPurchaseDetails(long id, long pharmacyId);
        List<IntTransReturn> GetPurchaseList(int pharmacyId);
    }
}
