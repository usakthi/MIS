using Dapper;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Infrastructure.Data
{
    public class PharmacyRepository : IPharmacyRepository
    {
        private IDbConnection _dbConn;
        
        public void AddPharmacy(Pharmacy model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name, DbType.String);
                p.Add("@CompanyName", model.CompanyName, DbType.String);
                p.Add("@Id", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("AddPharmacy", p, commandType: CommandType.StoredProcedure);
                model.Id = p.Get<int>("@Id");
            }
        }

        public Pharmacy GetPharmacyDetails(int Id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Pharmacy>("GetPharmacyDetails",
                                new { Id = Id }, commandType: CommandType.StoredProcedure)
                        .First();
            }
        }

        void IPharmacyRepository.AddPharmacy(Pharmacy model)
        {
            throw new NotImplementedException();
        }

        bool IRepository<Role>.Delete(Role model)
        {
            throw new NotImplementedException();
        }

        Role IRepository<Role>.Find(object id)
        {
            throw new NotImplementedException();
        }

        Role IRepository<Role>.Find(object id, long pharmacyId)
        {
            Role role = new Role();
            role.Id = (int)id;

            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@RoleId", id, DbType.Int32);
                p.Add("@PharmacyId", pharmacyId, DbType.Int32);

                var resultSet = _dbConn.QueryMultiple("GetPharmacyRoleDetail", p, commandType: CommandType.StoredProcedure);
                var accessibleFeatures = resultSet.Read();

                foreach (dynamic futureRecord in accessibleFeatures)
                {
                    if (futureRecord != null)
                    {
                        Feature feature = new Feature();
                        feature.Id = futureRecord.FeatureId;
                        feature.Key = futureRecord.FeatureKey;
                        feature.Name = futureRecord.FeatureName;
                        feature.IsSelected = (futureRecord.Selected == 1);


                        Module module = role.Modules.Find(m => m.Key == futureRecord.ModuleKey);
                        if (module == null)
                        {
                            module = new Module();
                            module.Id = futureRecord.ModuleId;
                            module.Key = futureRecord.ModuleKey;
                            module.Name = futureRecord.ModuleName;
                            role.Modules.Add(module);
                        }

                        module.Features.Add(feature);

                    }
                }
                var roleRecord = resultSet.Read().FirstOrDefault();

                if (roleRecord != null)
                {
                    role.RoleName = roleRecord.RoleName;
                    role.Description = roleRecord.RoleDescription;
                }
            }

            return role;
        }

        void IRepository<Role>.Insert(Role model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                System.Data.DataTable dt = new System.Data.DataTable();

                dt.Columns.Add("Id", typeof(int));

                foreach (Module m in model.Modules)
                {
                    foreach (Feature f in m.Features)
                    {
                        DataRow dr = dt.NewRow();
                        dr["Id"] = f.Id;
                        dt.Rows.Add(dr);
                    }

                }


                var p = new DynamicParameters();
                p.Add("@PharmacyId", model.PharmacyId);
                p.Add("@RoleName", model.RoleName);
                p.Add("@Description", model.Description);
                p.Add("@SelectedFeatures", dt.AsTableValuedParameter("IdInt"));

                p.Add("@AddedBy", model.AddedBy);
                p.Add("@AddedDateTime", model.AddedDateTime);

                p.Add("@RecordsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                p.Add("@RoleId", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("AddApplicationRole", p, commandType: CommandType.StoredProcedure);
                model.Id = p.Get<int>("@RoleId");


            }
        }

        IEnumerable<Role> IRepository<Role>.SelectAll()
        {
            throw new NotImplementedException();
        }

        IEnumerable<Role> IRepository<Role>.SelectAll(int pharmacyId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Role>("GetAllPharmacyRoles",
                             new { PharmacyId = pharmacyId }, commandType: CommandType.StoredProcedure);
            }
        }

        bool IRepository<Role>.Update(Role model)
        {
            throw new NotImplementedException();
        }

        Pharmacy IPharmacyRepository.GetPharmacyDetails(int Id)
        {
            throw new NotImplementedException();
        }

        public bool SaveRoleDetail(Role model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                System.Data.DataTable dt = new System.Data.DataTable();

                dt.Columns.Add("Id", typeof(int));

                foreach (Module m in model.Modules)
                {
                    foreach (Feature f in m.Features)
                    {
                        DataRow dr = dt.NewRow();
                        dr["Id"] = f.Id;
                        dt.Rows.Add(dr);
                    }

                }

                var p = new DynamicParameters();
                p.Add("@RoleId", model.Id);
                p.Add("@RoleName", model.RoleName);
                p.Add("@RoleDesc", model.Description);
                p.Add("@SelectedFeatures", dt.AsTableValuedParameter("IdInt"));
                p.Add("@RecordsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("SaveRoleFeatures", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RecordsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Role> IRepository<Role>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<Role> IRepository<Role>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
    }
}
