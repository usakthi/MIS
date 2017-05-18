using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Services;
using Daria.MIS.Core.Entities;
using Daria.MIS.Core.CrossCutting;

namespace Daria.MIS.Infrastructure.Services
{
    public class IndentReceivableService : IIndentReceivableService
    {
        private readonly IIndentReceivableRepository repository;
        private readonly ICacheStorage store;

        public IndentReceivableService(IIndentReceivableRepository _billRep, ICacheStorage _store)
        {
            repository = _billRep;
            store = _store;

        }

        public void AddPurchase(IndentReceivable purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public IndentReceivable GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<IndentReceivable> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(IndentReceivable purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(IndentReceivable model)
        {
            return repository.Delete(model);
        }

        public List<IndentReceivable> GetDuePatientList()
        {
            List<IndentReceivable> cachedList = store.Retrieve<List<IndentReceivable>>("BillDueList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<IndentReceivable>)repository).SelectAll().ToList();
                store.Add("BillDueList", cachedList);

            //}
            return cachedList;
        }

        public IndentReceivable GetIndentDetails(long id, long pharmacyId)
        {
            return repository.FindIndentDetails(id, pharmacyId);
        }
    }
}
