using Daria.MIS.Core.CrossCutting;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using Daria.MIS.Core.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Infrastructure.Services
{
    public class PharmacyService : IPharmacyService
    {
        private readonly IPharmacyRepository Repository;
        private ICacheStorage CacheStore;

        public PharmacyService(IPharmacyRepository _repository)
        {
            Repository = _repository;
        }

        public void AddPharmacy(Pharmacy model)
        {
            Repository.AddPharmacy(model);
        }

        public Pharmacy GetPharmacyDetails(int Id)
        {
            throw new NotImplementedException();
        }

        public Role GetPharmacyRoleDetail(int id, int pharmacyId)
        {
            return ((IRepository<Role>)Repository).Find(id, pharmacyId);
        }

        public void AddApplicationRole(Role model)
        {
            ((IRepository<Role>)Repository).Insert(model);
        }

        public List<Role> GetAllPharmacyRoles(int pharmacyId)
        {
            return ((IRepository<Role>)Repository).SelectAll(pharmacyId).ToList();
        }

        public bool UpdateRoleDetail(Role model)
        {
            return Repository.SaveRoleDetail(model);
        }

        public bool DeleteRoleDetail(Role model)
        {
            return ((IRepository<Role>)Repository).Delete(model);
        }
    }
}
