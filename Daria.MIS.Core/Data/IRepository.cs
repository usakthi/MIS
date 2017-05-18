using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IRepository<T>
    {
        T Find(object id, long tenantId);
        T Find(object id);
        void Insert(T model);
        bool Delete(T model);
        bool Update(T model);
        IEnumerable<T> SelectAll();
        IEnumerable<T> SelectAll(int pharmacyId);
        IEnumerable<T> SelectAll(string ph="bill");
        IEnumerable<T> SelectAll(string ph, string category);
    }
}
