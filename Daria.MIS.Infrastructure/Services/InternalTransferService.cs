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
    public class InternalTransferService : IInternalTransferService
    {
        private readonly IInternalTransferRepository repository;

        public InternalTransferService(IInternalTransferRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(IntTrans purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public IntTrans GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<IntTrans> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(IntTrans purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(IntTrans model)
        {
            return repository.Delete(model);
        }
    }
}
