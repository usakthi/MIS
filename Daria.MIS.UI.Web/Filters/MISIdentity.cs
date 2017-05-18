using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;

namespace Daria.MIS.UI.Web
{
   

    [Serializable]
    public class MISIdentity : IIdentity
    {
        private System.Web.Security.FormsAuthenticationTicket ticket;

        public MISIdentity(System.Web.Security.FormsAuthenticationTicket ticket)
        {
            this.ticket = ticket;
        }

        public string AuthenticationType
        {
            get { return "DariaMIS"; }
        }

        public bool IsAuthenticated
        {
            get { return true; }
        }

        public string Name
        {
            get { return ticket.Name; }
        }

        public string FriendlyName
        {
            get { return ticket.UserData; }
        }

        public long TenantId
        {

            get
            {
                string[] userData = ticket.UserData.Split(new string[] { "___" }, StringSplitOptions.None);
                return Convert.ToInt32(userData[0]);
            }
        }

    }
}