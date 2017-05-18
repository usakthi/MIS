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
    public class EditedBillService : IEditedBillService
    {
        private readonly IEditedBillRepository repository;

        public EditedBillService(IEditedBillRepository _purchaseRep)
        {
            repository = _purchaseRep;

        }

        public void AddPurchase(EditedBill purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }

        public EditedBill GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }

        public bool UpdatePurchase(EditedBill purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(EditedBill model)
        {
            return repository.Delete(model);
        }

        public List<EditedBill> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        public List<EditedBill> SearchPurchases(EditedBillSearchDTO searchDto)
        {
            return repository.SearchPurchases(searchDto);
        }
    }
}
