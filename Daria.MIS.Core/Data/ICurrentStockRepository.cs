using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface ICurrentStockRepository : IRepository<CurrentStock>
    {
        List<CurrentStock> RptCurrentStock(CurrentStockSearchDTO searchDto);
    }

}
