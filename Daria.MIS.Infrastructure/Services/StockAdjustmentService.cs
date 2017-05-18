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
    public class StockAdjustmentService : IStockAdjustmentService
    {
        private readonly IStockAdjustmentRepository repository;

        public StockAdjustmentService(IStockAdjustmentRepository _stockAdjustmentRep)
        {
            repository = _stockAdjustmentRep;

        }

        public void AddStockAdjustment(StockAdjustment stockAdjustmentEntry)
        {
            repository.Insert(stockAdjustmentEntry);
        }

        public List<StockAdjustment> GetStockAdjustmentList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        //public Bill GetPurchaseDetails(long id, StockAdjustment pharmacyId)
        //{
        //    return repository.Find(id, pharmacyId);
        //}


        //public bool UpdatePurchase(StockAdjustment purchaseEntry)
        //{
        //    return repository.Update(purchaseEntry);
        //}

        //public bool DeletePurchase(StockAdjustment model)
        //{
        //    return repository.Delete(model);
        //}
    }
}
