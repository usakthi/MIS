using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface ICustomerReceivableRepository : IRepository<CustomerReceivable>
    {
        void AddCustomerReceivableHeader(CustomerReceivable customerReceivableHeader, IDbConnection conn, IDbTransaction transaction);
        void AddCustomerReceivableItem(CustomerReceivableItem customerReceivableItem, IDbConnection conn, IDbTransaction transaction);

        CustomerReceivable FindCustomerDetails(object id, long pharmacyId);
        void SaveDueReceivable(List<CustomerDueList> q);
    }

}
