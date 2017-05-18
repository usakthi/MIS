using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface ISupplierPayableService
    {
        void AddSupplierPayable(SupplierPayable purchaseEntry);
        bool UpdateSupplierPayable(SupplierPayable purchaseEntry);
        bool DeleteSupplierPayable(SupplierPayable model);
        SupplierPayable GetSupplierPayables(long id, long pharmacyId);
        List<SupplierPayable> GetSupplierPayableList(int pharmacyId);
        SupplierPayable GetIndentDetails(long id, long pharmacyId);
        List<SupplierPayable> GetDueSupplierPayable();
        void SaveSupplierPayable(List<SupplierPayableDueList> q);

    }
}
