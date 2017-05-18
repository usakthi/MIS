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
    public class PurchaseService : IPurchaseService
    {
        private readonly IPurchaseRepository repository;
        private readonly ICacheStorage store;

         public PurchaseService(IPurchaseRepository _purchaseRep, ICacheStorage _store)
        {
            repository = _purchaseRep;
            store = _store;
        }

        public void AddPurchase(Purchase purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public Purchase GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<Purchase> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(Purchase purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(Purchase model)
        {
            return repository.Delete(model);
        }


        public List<Purchase> SearchPurchases(PurchaseSearchDTO searchDto)
        {
            return repository.SearchPurchases(searchDto);
        }

        public List<PurchaseItem> GetPurchaseItems(long pharmacyId, long prodId)
        {
            List<PurchaseItem> purchaseItems = repository.GetPurchaseItems(pharmacyId);
            return purchaseItems.Where(p => p.ProductId == prodId).ToList<PurchaseItem>();
        }

        public List<PurchaseItem> FindPurchaseItems(string PurchaseName)
        {
            return null;
        }

        public List<Purchase> GetInvoicesList()
        {
            List<Purchase> cachedList = store.Retrieve<List<Purchase>>("InvoicesList");

            cachedList = ((IRepository<Purchase>)repository).SelectAll().ToList();
            store.Add("InvoicesList", cachedList);

            return cachedList;
        }
    }
}
