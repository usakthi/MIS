using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IDueBillsRepository : IRepository<DueBills>
    {
        void AddDueBills(DueBills dueBillsHeader, IDbConnection conn, IDbTransaction transaction);
        //void AddDueBillsItem(DueBillsItem dueBillsDetails, IDbConnection conn, IDbTransaction transaction);

        DueBills FindDueBillItems(string no, string category);
    }

}
