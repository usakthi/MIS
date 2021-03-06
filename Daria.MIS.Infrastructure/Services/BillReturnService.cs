﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Services;
using Daria.MIS.Core.Entities;

namespace Daria.MIS.Infrastructure.Services
{
    public class BillReturnService : IBillReturnService
    {
        private readonly IBillReturnRepository repository;

        public BillReturnService(IBillReturnRepository _billRep)
        {
            repository = _billRep;

        }

        public void AddPurchase(BillReturn purchaseEntry)
        {
            repository.Insert(purchaseEntry);
        }


        public BillReturn GetPurchaseDetails(long id, long pharmacyId)
        {
            return repository.Find(id, pharmacyId);
        }


        public List<BillReturn> GetPurchaseList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }


        public bool UpdatePurchase(BillReturn purchaseEntry)
        {
            return repository.Update(purchaseEntry);
        }

        public bool DeletePurchase(BillReturn model)
        {
            return repository.Delete(model);
        }

        public List<BillReturn> SearchPurchases(BillReturnSearchDTO searchDto)
        {
            return repository.SearchPurchases(searchDto);
        }
    }
}
