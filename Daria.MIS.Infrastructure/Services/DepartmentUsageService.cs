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
    public class DepartmentUsageService : IDepartmentUsageService
    {
        private readonly IDepartmentUsageRepository repository;

        public DepartmentUsageService(IDepartmentUsageRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(DepartmentUsage purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public DepartmentUsage GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<DepartmentUsage> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(DepartmentUsage purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(DepartmentUsage model)
        {
            return repository.Delete(model);
        }

        public DepartmentUsage GetDepartmentItems(long id, long pharmacyId)
        {
            return repository.FindDepartmentItems(id, pharmacyId);
        }
    }
}
