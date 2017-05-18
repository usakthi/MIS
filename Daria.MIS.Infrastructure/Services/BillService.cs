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
    public class BillService : IBillService
    {
        private readonly IBillRepository repository;

        public BillService(IBillRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(Bill purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public Bill GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<Bill> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(Bill purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(Bill model)
        {
            return repository.Delete(model);
        }

        public Bill GetIndentDetails(long id, long pharmacyId)
        {
            return repository.FindIndentDetails(id, pharmacyId);
        }

        public List<Bill> SearchPurchases(BillSearchDTO searchDto)
        {
            return repository.SearchPurchases(searchDto);
        }
        //public Bill GetBillReceiptDetails(long id, long pharmacyId)
        //{
        //    return repository.FindBillReceiptDetails(id, pharmacyId);
        //}
    }
}
