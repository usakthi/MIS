using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IStockAdjustmentRepository : IRepository<StockAdjustment>
    {
        void AddStockAdjustment(StockAdjustment stockAdjustmentHeader, IDbConnection conn, IDbTransaction transaction);
        void AddStockAdjustmentItem(StockAdjustmentItem stockAdjustmentDetails, IDbConnection conn, IDbTransaction transaction);

        //void FindIndentHeader(Bill billHeader, IDbConnection conn, IDbTransaction transaction);
        //Bill FindIndentDetails(object id, long pharmacyId);
    }

}
