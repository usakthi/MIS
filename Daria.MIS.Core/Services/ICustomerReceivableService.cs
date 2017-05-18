using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface ICustomerReceivableService
    {
        void AddCustomerReceivable(CustomerReceivable purchaseEntry);
        bool UpdateCustomerReceivable(CustomerReceivable purchaseEntry);
        bool DeleteCustomerReceivable(CustomerReceivable model);
        CustomerReceivable GetCustomerReceivables(long id, long pharmacyId);
        List<CustomerReceivable> GetCustomerReceivableList(int pharmacyId);
        List<CustomerReceivable> GetDueCustomerReceivable();
        void SaveDueReceivable(List<CustomerDueList> q);

    }
}
