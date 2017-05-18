using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IIndentRepository : IRepository<Indent>
    {
        void AddIndentHeader(Indent indentHeader, IDbConnection conn, IDbTransaction transaction);
        void AddIndentItem(IndentItem indentItem, IDbConnection conn, IDbTransaction transaction);

    }

}
