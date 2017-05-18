using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IIndentReceivableRepository : IRepository<IndentReceivable>
    {
        void AddIndentReceivableHeader(IndentReceivable indentreceivableHeader, IDbConnection conn, IDbTransaction transaction);
        void AddIndentReceivableItem(IndentReceivableItem indentreceivableItem, IDbConnection conn, IDbTransaction transaction);


        IndentReceivable FindIndentDetails(object id, long pharmacyId);
    }

}
