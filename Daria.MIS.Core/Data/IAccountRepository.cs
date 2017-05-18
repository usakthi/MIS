using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IAccountRepository : IRepository<User>
    {
        User GetUserLogonDetails(string userName, string password);
        void RetreivePassword(string emailOrUserName);
        User VerifyUserCredentials(string userName, string password, long pharmacyId);
        List<ActionFeature> GetAllActionDetails();
        User UserResetPassword(string userName, string password);
    }
}
