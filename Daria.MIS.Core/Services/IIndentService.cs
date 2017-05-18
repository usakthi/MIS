using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IIndentService
    {
        void AddPurchase(Indent purchaseEntry);
        bool UpdatePurchase(Indent purchaseEntry);
        bool DeletePurchase(Indent model);
        Indent GetPurchaseDetails(long id, long pharmacyId);
        List<Indent> GetPurchaseList(int pharmacyId);
        List<Indent> GetIndents();
    }
}
