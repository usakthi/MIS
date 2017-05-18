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
    public class DepartmentBillService : IDepartmentBillService
    {
        private readonly IDepartmentBillRepository repository;

        public DepartmentBillService(IDepartmentBillRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(DepartmentBill purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public DepartmentBill GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<DepartmentBill> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(DepartmentBill purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(DepartmentBill model)
        {
            return repository.Delete(model);
        }

        public DepartmentBill GetIndentDetails(long id, long pharmacyId)
        {
            return repository.FindIndentDetails(id, pharmacyId);
        }
    }
}
