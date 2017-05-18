using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Entities;

namespace Daria.MIS.Core.Data
{
    public interface IPharmacyRepository : IRepository<Role>
    {
        void AddPharmacy(Pharmacy model);
         
        Pharmacy GetPharmacyDetails(int Id);
        bool SaveRoleDetail(Role role);
       
    }
}
