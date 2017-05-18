using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IIndentBillRepository : IRepository<IndentBill>
    {
        void AddBillHeader(IndentBill indentbillHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillItem(IndentBillItem indentbillItem, IDbConnection conn, IDbTransaction transaction);


        IndentBill FindIndentDetails(object id, long pharmacyId);
    }

}
