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
    public class InternalTransferReturnService : IInternalTransferReturnService
    {
        private readonly IInternalTransferReturnRepository repository;

        public InternalTransferReturnService(IInternalTransferReturnRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(IntTransReturn purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public IntTransReturn GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<IntTransReturn> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(IntTransReturn purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(IntTransReturn model)
        {
            return repository.Delete(model);
        }
    }
}
