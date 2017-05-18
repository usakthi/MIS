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
    public class CustomerReceivableService : ICustomerReceivableService
    {
        private readonly ICustomerReceivableRepository repository;
        private readonly ICacheStorage store;

        public CustomerReceivableService(ICustomerReceivableRepository _billRep, ICacheStorage _store)
        {
            repository = _billRep;
            store = _store;

        }

        public void AddCustomerReceivable(CustomerReceivable purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public CustomerReceivable GetCustomerReceivables(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<CustomerReceivable> GetCustomerReceivableList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdateCustomerReceivable(CustomerReceivable purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeleteCustomerReceivable(CustomerReceivable model)
        {
            return repository.Delete(model);
        }

        public List<CustomerReceivable> GetDueCustomerReceivable()
        {
            List<CustomerReceivable> cachedList = store.Retrieve<List<CustomerReceivable>>("CustomerDueList");

            cachedList = ((IRepository<CustomerReceivable>)repository).SelectAll().ToList();
            store.Add("CustomerDueList", cachedList);
            return cachedList;
        }

        public CustomerReceivable FindCustomerDetails(long id, long pharmacyId)
        {
            return repository.FindCustomerDetails(id, pharmacyId);
        }

        public void SaveDueReceivable(List<CustomerDueList> q)
        {
            repository.SaveDueReceivable(q);
        }
    }
}
