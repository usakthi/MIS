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
    public class DepartmentIndentService : IDepartmentIndentService
    {
        private readonly IDepartmentIndentRepository repository;
        private readonly ICacheStorage store;

        public DepartmentIndentService(IDepartmentIndentRepository _billRep, ICacheStorage _store)
        {
            repository = _billRep;
            store = _store;

        }

        public void AddPurchase(DepartmentIndent purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public DepartmentIndent GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<DepartmentIndent> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        public bool UpdatePurchase(DepartmentIndent purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(DepartmentIndent model)
        {
            return repository.Delete(model);
        }

        public List<DepartmentIndent> GetIndents()
        {
            return repository.SelectAll().ToList();
               
        }
    }
}
