using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IPharmacyService
    {
        void AddPharmacy(Pharmacy model); 

        Pharmacy GetPharmacyDetails(int Id);

        Role GetPharmacyRoleDetail(int id, int pharmacyId);

        void AddApplicationRole(Role model);

        List<Role> GetAllPharmacyRoles(int pharmacyId);

        bool UpdateRoleDetail(Role model);

        bool DeleteRoleDetail(Role model);
    }
}
