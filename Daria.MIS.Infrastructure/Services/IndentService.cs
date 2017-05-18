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
    public class IndentService : IIndentService
    {
        private readonly IIndentRepository repository;
        private readonly ICacheStorage store;

        public IndentService(IIndentRepository _billRep, ICacheStorage _store)
        {
            repository = _billRep;
            store = _store;

        }

        public void AddPurchase(Indent purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public Indent GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<Indent> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        public bool UpdatePurchase(Indent purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(Indent model)
        {
            return repository.Delete(model);
        }

        public List<Indent> GetIndents()
        {
            return repository.SelectAll().ToList();
               
        }
    }
}
