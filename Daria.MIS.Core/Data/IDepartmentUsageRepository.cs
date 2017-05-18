using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IDepartmentUsageRepository : IRepository<DepartmentUsage>
    {
        void AddBillHeader(DepartmentUsage indentbillHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillItem(DepartmentUsageItem indentbillItem, IDbConnection conn, IDbTransaction transaction);


        DepartmentUsage FindDepartmentItems(object id, long pharmacyId);
    }

}
