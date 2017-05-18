using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IDepartmentStockRepository : IRepository<DepartmentStock>
    {
        List<DepartmentStock> RptCurrentStock(DepartmentStockSearchDTO searchDto);
    }

}
