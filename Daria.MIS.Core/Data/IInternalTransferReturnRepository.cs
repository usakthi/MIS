using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IInternalTransferReturnRepository : IRepository<IntTransReturn>
    {
        void AddBillReturnHeader(IntTransReturn billreturnHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillReturnItem(IntTransReturnItem billreturnItem, IDbConnection conn, IDbTransaction transaction);

    }

}
