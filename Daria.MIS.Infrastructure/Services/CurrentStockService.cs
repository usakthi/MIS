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
    public class CurrentStockService : ICurrentStockService
    {
        private readonly ICurrentStockRepository repository;

        public CurrentStockService(ICurrentStockRepository _purchaseRep)
        {
            repository = _purchaseRep;

        }

        public void AddPurchase(CurrentStock purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }

        public bool UpdatePurchase(CurrentStock purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(CurrentStock model)
        {
            return repository.Delete(model);
        }

        public CurrentStock GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<CurrentStock> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        public List<CurrentStock> RptCurrentStock(CurrentStockSearchDTO searchDto)
        {
            return repository.RptCurrentStock(searchDto);
        }
    }
}
