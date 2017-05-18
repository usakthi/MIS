using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IDepartmentBillRepository : IRepository<DepartmentBill>
    {
        void AddBillHeader(DepartmentBill indentbillHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillItem(DepartmentBillItem indentbillItem, IDbConnection conn, IDbTransaction transaction);


        DepartmentBill FindIndentDetails(object id, long pharmacyId);
    }

}
