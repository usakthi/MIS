using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface ISalesReturnRepository : IRepository<SalesReturn>
    {
        void AddBillHeader(SalesReturn salesreturnHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillItem(SalesReturnItem salesreturnItem, IDbConnection conn, IDbTransaction transaction);


        //SalesReturn FindDepartmentItems(object id, long pharmacyId);
        SalesReturn FindSalesItems(string no, string category);
    }

}
