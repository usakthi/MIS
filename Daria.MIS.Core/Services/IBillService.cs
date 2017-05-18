using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IBillService
    {
        void AddPurchase(Bill purchaseEntry);
        bool UpdatePurchase(Bill purchaseEntry);
        bool DeletePurchase(Bill model);
        Bill GetPurchaseDetails(long id, long pharmacyId);
        List<Bill> GetPurchaseList(int pharmacyId);
        Bill GetIndentDetails(long id, long pharmacyId);

        List<Bill> SearchPurchases(BillSearchDTO searchDto);
        //Bill GetBillReceiptDetails(long id, long pharmacyId);
    }
}
