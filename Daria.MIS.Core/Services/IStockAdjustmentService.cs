using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IStockAdjustmentService
    {
        void AddStockAdjustment(StockAdjustment stockadjustmentEntry);
        List<StockAdjustment> GetStockAdjustmentList(int pharmacyId);
    }
}
