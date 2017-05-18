using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;
using Daria.MIS.Web;
using Autofac.Integration.Mvc;
using System.Web.Mvc;
using System.Configuration;
using Daria.MIS.Core.Data;
using Daria.MIS.Infrastructure.Data;
using System.Web;
using Daria.MIS.Core.Services;
using Daria.MIS.Infrastructure.Services;
using Daria.MIS.Core.CrossCutting;
using Daria.MIS.Infrastructure.CrossCutting;

[assembly: WebActivatorEx.PreApplicationStartMethod(typeof(Daria.MIS.Bootstrapper.Bootstrapper), "RegisterDependencies")]

namespace Daria.MIS.Bootstrapper
{
    public class Bootstrapper
    {
        
        public static void RegisterDependencies()
        {
            var builder = new ContainerBuilder();            
            builder.RegisterControllers(typeof(MvcApplication).Assembly);
            builder.RegisterModule<AutofacWebTypesModule>();
            builder.RegisterType(typeof(MasterDataRepository)).As(typeof(IMasterDataRepository)).InstancePerHttpRequest();
            builder.RegisterType(typeof(PharmacyRepository)).As(typeof(IPharmacyRepository)).InstancePerHttpRequest();
            builder.RegisterType(typeof(AccountRepository)).As(typeof(IAccountRepository)).InstancePerHttpRequest();

            builder.RegisterType(typeof(HttpContextCacheAdapter)).As(typeof(ICacheStorage)).InstancePerHttpRequest();

            builder.RegisterType(typeof(AccountService)).As(typeof(IAccountService)).InstancePerHttpRequest();
            builder.RegisterType(typeof(PharmacyService)).As(typeof(IPharmacyService)).InstancePerHttpRequest();
            builder.RegisterType(typeof(MasterDataService)).As(typeof(IMasterDataService)).InstancePerHttpRequest();           
            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
        }
    }
}
