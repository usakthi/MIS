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
    public class PurchaseReturnService : IPurchaseReturnService
    {
        private readonly IPurchaseReturnRepository repository;
        private readonly ICacheStorage store;

        public PurchaseReturnService(IPurchaseReturnRepository _purchaseRep, ICacheStorage _store)
        {
            repository = _purchaseRep;
            store = _store;
        }

        public void AddPurchase(PurchaseReturn purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public PurchaseReturn GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<PurchaseReturn> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(PurchaseReturn purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(PurchaseReturn model)
        {
            return repository.Delete(model);
        }

        public PurchaseReturn GetPurchasedItems(string no, string category)
        {
            return repository.FindPurchasedItems(no, category);
        }

        public List<PurchaseReturn> GetSupplierInvoices(string q, string cat)
        {
            List<PurchaseReturn> cachedList = store.Retrieve<List<PurchaseReturn>>("InvoiceProductList");

            cachedList = ((IRepository<PurchaseReturn>)repository).SelectAll(q,cat).ToList();
            store.Add("InvoiceProductList", cachedList);

            return cachedList;
        }

        // Product For Purchase Return
        public List<PurchaseReturn> GetProductsForPurchaseReturn(string q)
        {
            List<PurchaseReturn> cachedList = store.Retrieve<List<PurchaseReturn>>("InvoiceProductList");

            cachedList = ((IRepository<PurchaseReturn>)repository).SelectAll(q).ToList();
            store.Add("InvoiceProductList", cachedList);

            return cachedList;
        }
    }
}
