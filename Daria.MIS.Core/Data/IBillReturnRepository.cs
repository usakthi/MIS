using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IBillReturnRepository : IRepository<BillReturn>
    {
        void AddBillReturnHeader(BillReturn billreturnHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillReturnItem(BillReturnItem billreturnItem, IDbConnection conn, IDbTransaction transaction);

        List<BillReturn> SearchPurchases(BillReturnSearchDTO searchDto);
    }

}
