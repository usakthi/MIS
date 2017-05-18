using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IBillReturnService
    {
        void AddPurchase(BillReturn purchaseEntry);
        bool UpdatePurchase(BillReturn purchaseEntry);
        bool DeletePurchase(BillReturn model);
        BillReturn GetPurchaseDetails(long id, long pharmacyId);
        List<BillReturn> GetPurchaseList(int pharmacyId);

        List<BillReturn> SearchPurchases(BillReturnSearchDTO searchDto);
    }
}
