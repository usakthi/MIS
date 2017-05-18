using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface ISupplierPayableRepository : IRepository<SupplierPayable>
    {
        void AddSupplierPayableHeader(SupplierPayable indentreceivableHeader, IDbConnection conn, IDbTransaction transaction);
        void AddSupplierPayableItem(SupplierPayableItem indentreceivableItem, IDbConnection conn, IDbTransaction transaction);

        SupplierPayable FindSupplierDetails(object id, long pharmacyId);
        void SaveSupplierPayable(List<SupplierPayableDueList> q);
    }

}
