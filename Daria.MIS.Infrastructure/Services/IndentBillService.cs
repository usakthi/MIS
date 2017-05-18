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
    public class IndentBillService : IIndentBillService
    {
        private readonly IIndentBillRepository repository;

        public IndentBillService(IIndentBillRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(IndentBill purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public IndentBill GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<IndentBill> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(IndentBill purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(IndentBill model)
        {
            return repository.Delete(model);
        }

        public IndentBill GetIndentDetails(long id, long pharmacyId)
        {
            return repository.FindIndentDetails(id, pharmacyId);
        }
    }
}
