using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IInternalTransferService
    {
        void AddPurchase(IntTrans purchaseEntry);
        bool UpdatePurchase(IntTrans purchaseEntry);
        bool DeletePurchase(IntTrans model);
        IntTrans GetPurchaseDetails(long id, long pharmacyId);
        List<IntTrans> GetPurchaseList(int pharmacyId);
    }
}
