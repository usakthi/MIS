using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Services;
using Daria.MIS.Core.Entities;

namespace Daria.MIS.Infrastructure.Services
{
    public class SalesReturnService : ISalesReturnService
    {
        private readonly ISalesReturnRepository repository;

        public SalesReturnService(ISalesReturnRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(SalesReturn purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public SalesReturn GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<SalesReturn> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(SalesReturn purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(SalesReturn model)
        {
            return repository.Delete(model);
        }

        public SalesReturn GetSalesItems(string no, string category)
        {
            return repository.FindSalesItems(no, category);
        }
    }
}
