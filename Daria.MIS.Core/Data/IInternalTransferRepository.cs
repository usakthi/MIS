using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IInternalTransferRepository : IRepository<IntTrans>
    {
        void AddBillHeader(IntTrans billHeader, IDbConnection conn, IDbTransaction transaction);
        void AddBillItem(IntTransItem billItem, IDbConnection conn, IDbTransaction transaction);

    }

}
