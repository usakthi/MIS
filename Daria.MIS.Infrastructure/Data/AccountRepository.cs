using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using System.Data;
using Dapper;
using Daria.MIS.Core;

namespace Daria.MIS.Infrastructure.Data
{
    public class AccountRepository : IAccountRepository
    {
        private IDbConnection _dbConn ;

        public User GetUserLogonDetails(string userName, string password)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                User appUser = new User();
                var p = new DynamicParameters();
                p.Add("@UserName", userName, DbType.String);


                var resultSet = _dbConn.QueryMultiple("GetUserLogonDetails", p, commandType: CommandType.StoredProcedure);

                var userRecord = resultSet.Read().FirstOrDefault();

                if (userRecord != null)
                {
                    appUser.UserId = userRecord.UserId;
                    appUser.UserName = userRecord.UserName;
                    appUser.Password = userRecord.Password;
                    appUser.PharmacyId = userRecord.PharmacyId;
                    appUser.Email = userRecord.EmailId;
                    appUser.PersonId = userRecord.PersonId;
                    appUser.LastLoginDate = userRecord.LastLoginDate;
                    appUser.FailedLoginAttempt = userRecord.FailedLoginAttempt;
                    appUser.IsAccountLocked = userRecord.IsAccountLocked ?? false;
                    appUser.PersonId = userRecord.PersonId;
                    appUser.FirstName = userRecord.FirstName;
                    appUser.LastName = userRecord.LastName;
                    appUser.Role = new Role { Id = userRecord.RoleId, RoleName = userRecord.RoleName, LandingPage = userRecord.LandingPage };
                    appUser.RequiredPasswordReset = userRecord.NeedPasswordReset ?? false;
                    appUser.UserType = (UserType)userRecord.UserType;

                }

                var accessibleFeatures = resultSet.Read();

                foreach (dynamic feature in accessibleFeatures)
                {
                    Module module = appUser.Role.Modules.Find(m => m.Key == feature.ModuleKey);
                    if (module == null)
                    {
                        module = new Module();
                        module.Id = feature.ModuleId;
                        module.Key = feature.ModuleKey;
                        module.Name = feature.ModuleName;

                        module.Description = feature.ModuleDesc;

                        module.IsActive = feature.IsModuleActive ?? false;
                        module.Features.Add(PrepareFeature(feature));
                        appUser.Role.Modules.Add(module);
                    }
                    else
                    {
                        module.Features.Add(PrepareFeature(feature));
                    }
                }


                return appUser;
            }
        }

        private Feature PrepareFeature(dynamic row)
        {
            Feature feature = new Feature();
            feature.Id = row.FeatureId;
            feature.Key = row.FeatureKey;
            feature.Name = row.FeatureName;
            feature.Description = row.FeatureDesc;
            feature.ParentFeatureId = row.ParentFeatureId ?? 0;
            feature.IsActive = row.IsFeatureActive ?? false;
            feature.MenuId = row.MenuId;

            return feature;
        }

        public void RetreivePassword(string emailOrUserName)
        {
            throw new NotImplementedException();
        }

        public User Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        public User Find(object id)
        {
            throw new NotImplementedException();
        }

        public void Insert(User model)
        {
            throw new NotImplementedException();
        }

        public bool Delete(User model)
        {
            throw new NotImplementedException();
        }

        public bool Update(User model)
        {
            throw new NotImplementedException();
        }


        public IEnumerable<User> SelectAll()
        {
            throw new NotImplementedException();
        }
        public IEnumerable<User> SelectAll(int pId)
        {
            throw new NotImplementedException();
        }


        public User VerifyUserCredentials(string userName, string password, long pharmacyId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {

                return _dbConn.Query<User>("VerifyUserCredentials", new { UserName = userName, pharmacyId=pharmacyId }, commandType: CommandType.StoredProcedure).FirstOrDefault();

            }
        }
        IEnumerable<User> IRepository<User>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<User> IRepository<User>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public User UserResetPassword(string userName, string password)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                User appUser = new User();
                var p = new DynamicParameters();
                p.Add("@UserName", userName, DbType.String);
                p.Add("@Password", password, DbType.String);

                var resultSet = _dbConn.QueryMultiple("UserResetPassword", p, commandType: CommandType.StoredProcedure);

                var userRecord = resultSet.Read().FirstOrDefault();

                if (userRecord != null)
                {
                    appUser.UserId = userRecord.UserId;
                    appUser.UserName = userRecord.UserName;
                    appUser.Password = userRecord.Password;
                    appUser.PharmacyId = userRecord.PharmacyId;
                    appUser.Email = userRecord.EmailId;
                    appUser.PersonId = userRecord.PersonId;
                    appUser.LastLoginDate = userRecord.LastLoginDate;
                    appUser.FailedLoginAttempt = userRecord.FailedLoginAttempt;
                    appUser.IsAccountLocked = userRecord.IsAccountLocked ?? false;
                    appUser.PersonId = userRecord.PersonId;
                    appUser.FirstName = userRecord.FirstName;
                    appUser.LastName = userRecord.LastName;
                    appUser.Role = new Role { Id = userRecord.RoleId, RoleName = userRecord.RoleName, LandingPage = userRecord.LandingPage };
                    appUser.RequiredPasswordReset = userRecord.NeedPasswordReset ?? false;
                    appUser.UserType = (UserType)userRecord.UserType;

                }

                var accessibleFeatures = resultSet.Read();

                foreach (dynamic feature in accessibleFeatures)
                {
                    Module module = appUser.Role.Modules.Find(m => m.Key == feature.ModuleKey);
                    if (module == null)
                    {
                        module = new Module();
                        module.Id = feature.ModuleId;
                        module.Key = feature.ModuleKey;
                        module.Name = feature.ModuleName;

                        module.Description = feature.ModuleDesc;

                        module.IsActive = feature.IsModuleActive ?? false;
                        module.Features.Add(PrepareFeature(feature));
                        appUser.Role.Modules.Add(module);
                    }
                    else
                    {
                        module.Features.Add(PrepareFeature(feature));
                    }
                }


                return appUser;
            }
        }

        public List<ActionFeature> GetAllActionDetails()
        {
            List<ActionFeature> actionList = new List<ActionFeature>();

            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();

                var resultSet = _dbConn.QueryMultiple("GetActionFeatureMapping", p, commandType: CommandType.StoredProcedure);
                var allActions = resultSet.Read();

                foreach (dynamic a in allActions)
                {
                    if (a != null)
                    {
                        ActionFeature action = new ActionFeature();
                        action.ActionName = a.ActionName;
                        action.ControllerName = a.ControllerName;
                        action.ActionType = a.ActionType;

                        Feature feature = new Feature();
                        feature.Id = a.FeatureId;
                        feature.Key = a.Key;
                        feature.Name = a.Name;
                        action.Feature = feature;
                        actionList.Add(action);
                    }
                }
            }

            return actionList;
        }
    }
}
