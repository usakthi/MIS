using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;

namespace Daria.MIS.UI.Web
{
    public class MvcApplication : System.Web.HttpApplication
    {
        public override void Init()
        {
            this.PostAuthenticateRequest += new EventHandler(MvcApplication_PostAuthenticateRequest);

            base.Init();
        }

        protected void Application_Start()
        {            
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            Bootstrapper.RegisterDependencies();
            Bootstrapper.LoadMasterData();
        }

        void MvcApplication_PostAuthenticateRequest(object sender, EventArgs e)
        {
            HttpCookie authCookie = HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie != null)
            {
                string encTicket = authCookie.Value;
                if (!String.IsNullOrEmpty(encTicket))
                {
                    FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(encTicket);

                    string[] userData = ticket.UserData.Split(new string[] { "___" }, StringSplitOptions.None);
                    string[] roles = null;
                    if (userData.Length > 1)
                    {
                        roles = userData[1].Split(',');
                    }
                    MISIdentity identity = new MISIdentity(ticket);
                    GenericPrincipal principle = new GenericPrincipal(identity, roles);
                    HttpContext.Current.User = principle;
                }
            }
        }
    }
}
