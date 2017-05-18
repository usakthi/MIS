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
    public class SupplierPayableService : ISupplierPayableService
    {
        private readonly ISupplierPayableRepository repository;
        private readonly ICacheStorage store;

        public SupplierPayableService(ISupplierPayableRepository _billRep, ICacheStorage _store)
        {
            repository = _billRep;
            store = _store;

        }

        public void AddSupplierPayable(SupplierPayable purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public SupplierPayable GetSupplierPayables(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<SupplierPayable> GetSupplierPayableList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdateSupplierPayable(SupplierPayable purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeleteSupplierPayable(SupplierPayable model)
        {
            return repository.Delete(model);
        }

        public List<SupplierPayable> GetDueSupplierPayable()
        {
            List<SupplierPayable> cachedList = store.Retrieve<List<SupplierPayable>>("PaymentDueList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<SupplierPayable>)repository).SelectAll().ToList();
                store.Add("PaymentDueList", cachedList);
            //}
            return cachedList;
        }

        public SupplierPayable FindSupplierDetails(long id, long pharmacyId)
        {
            return repository.FindSupplierDetails(id, pharmacyId);
        }

        public SupplierPayable GetIndentDetails(long id, long pharmacyId)
        {
            return repository.FindSupplierDetails(id, pharmacyId);
        }

        public void SaveSupplierPayable(List<SupplierPayableDueList> q)
        {
            repository.SaveSupplierPayable(q);
        }
    }
}
