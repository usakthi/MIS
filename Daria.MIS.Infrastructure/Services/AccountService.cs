using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Services;
using Daria.MIS.Core.Entities;
using Daria.MIS.Utils;
using Daria.MIS.Core.CrossCutting;

namespace Daria.MIS.Infrastructure.Services
{
    public class AccountService : IAccountService
    {
        private readonly IAccountRepository Repository;
        private readonly ICacheStorage store;

        public AccountService(IAccountRepository _repository, ICacheStorage _store)
        {
            Repository = _repository;
            store = _store;
        }

        public User GetUserLogonDetails(string userName, string password)
        {
            User user= Repository.GetUserLogonDetails(userName, password);

            if (string.IsNullOrEmpty(user.UserName))
            {
                user.LoginStatus = AuthenticationStatus.UserNotFound;
            }
            else
            {
                if (SecurityHelper.IsMatchEncryptText(password, user.Password))
                {
                    user.LoginStatus = AuthenticationStatus.Success;
                }
                else
                {
                    user.LoginStatus = AuthenticationStatus.PasswordMismatch;
                }
            }
           
            return user;
        }

        public User UserResetPassword(string username, string password)
        {
            password = SecurityHelper.Encrypt(password);
            User user = Repository.UserResetPassword(username, password);

            if (string.IsNullOrEmpty(user.UserName))
            {
                user.LoginStatus = AuthenticationStatus.UserNotFound;
            }
            else
            {
                if (SecurityHelper.IsMatchEncryptText(password, user.Password))
                {
                    user.LoginStatus = AuthenticationStatus.Success;
                }
                else
                {
                    user.LoginStatus = AuthenticationStatus.PasswordMismatch;
                }
            }

            return user;
        }

        public User VerifyUserCredentials(string userName, string password, long pharmacyId)
        {
            User user = Repository.VerifyUserCredentials(userName, password,pharmacyId);

            if (string.IsNullOrEmpty(user.UserName))
            {
                user.LoginStatus = AuthenticationStatus.UserNotFound;
            }
            else
            {
                if (SecurityHelper.IsMatchEncryptText(password, user.Password))
                {
                    user.LoginStatus = AuthenticationStatus.Success;
                }
                else
                {
                    user.LoginStatus = AuthenticationStatus.PasswordMismatch;
                }
            }

            return user;
        }

        public List<ActionFeature> GetAllActionDetails()
        {

            List<ActionFeature> actionList = store.Retrieve<List<ActionFeature>>("ApplicationActionFeature");

            if (actionList != null)
            {
                return actionList;
            }
            else
            {
                actionList = Repository.GetAllActionDetails();
                store.Add("ApplicationActionFeature", actionList);

            }
            return actionList;
        }
    }
}
