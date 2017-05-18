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
    public class DepartmentStockService : IDepartmentStockService
    {
        private readonly IDepartmentStockRepository repository;

        public DepartmentStockService(IDepartmentStockRepository _purchaseRep)
        {
            repository = _purchaseRep;

        }

        public void AddPurchase(DepartmentStock purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }

        public bool UpdatePurchase(DepartmentStock purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(DepartmentStock model)
        {
            return repository.Delete(model);
        }

        public DepartmentStock GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<DepartmentStock> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        public List<DepartmentStock> RptCurrentStock(DepartmentStockSearchDTO searchDto)
        {
            return repository.RptCurrentStock(searchDto);
        }
    }
}
