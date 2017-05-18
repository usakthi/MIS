using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IBillRepository : IRepository<Bill>
    {
        void AddBillHeader(Bill billHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillItem(BillItem billItem, IDbConnection conn, IDbTransaction transaction);

        //void FindIndentHeader(Bill billHeader, IDbConnection conn, IDbTransaction transaction);

        Bill FindIndentDetails(object id, long pharmacyId);
        List<Bill> SearchPurchases(BillSearchDTO searchDto);
        //Bill FindBillReceiptDetails(long id, long pharmacyId);
    }

}
