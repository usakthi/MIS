using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Entities
{
    public class User:Person
    {
        public int PharmacyId { get; set; }

        public string EncPharmacyId { get; set; }

        public long UserId { get; set; }
        public string UserLogin { get; set; }

        public string Password { get; set; }

        public bool IsActive { get; set; }
        public DateTime? LastLoginDate { get; set; }

        public string UserName { get; set; }

        public Role Role { get; set; }

        public AuthenticationStatus LoginStatus { get; set; }

        public int? FailedLoginAttempt { get; set; }

        public bool IsAccountLocked { get; set; }

        

        public int RoleId { get; set; }


        public bool RequiredPasswordReset { get; set; }


        public Person AddedPerson { get; set; }

        public string OldPassword { get; set; }

        Pharmacy _tenant = new Pharmacy();

        public Pharmacy Tenant
        {
            get { return _tenant; }
            set { _tenant = value; }
        }

        public List<Pharmacy> AccessibleTenants { get; set; }

        public UserType UserType { get; set; }
        
    }

    public enum UserType
    {
        NormalUser=0,
        SiteAdmin=1,
        GlobalAdmin=100
    }

    public class ActionFeature
    {
        public string ActionName { get; set; }
        public string ControllerName { get; set; }
        public string ActionType { get; set; }

        public Feature Feature { get; set; }
    }
}
