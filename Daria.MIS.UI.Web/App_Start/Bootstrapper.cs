
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Autofac;
using Daria.MIS.UI.Web;
using Autofac.Integration.Mvc;
using System.Web.Mvc;
using System.Configuration;
using Daria.MIS.Core.Data;
using Daria.MIS.Infrastructure.Data;

using Daria.MIS.Core.Services;
using Daria.MIS.Infrastructure.Services;
using Daria.MIS.Core.CrossCutting;
using Daria.MIS.Infrastructure.CrossCutting;

namespace Daria.MIS.UI.Web
{
    public class Bootstrapper
    {
      
        public static void RegisterDependencies()
        {
            var builder = new ContainerBuilder();
            builder.RegisterControllers(typeof(MvcApplication).Assembly);
            builder.RegisterModule<AutofacWebTypesModule>();
            builder.RegisterType(typeof(MasterDataRepository)).As(typeof(IMasterDataRepository)).InstancePerRequest();
            builder.RegisterType(typeof(PharmacyRepository)).As(typeof(IPharmacyRepository)).InstancePerRequest();
            builder.RegisterType(typeof(AccountRepository)).As(typeof(IAccountRepository)).InstancePerRequest();
            builder.RegisterType(typeof(PurchaseRepository)).As(typeof(IPurchaseRepository)).InstancePerRequest();
            builder.RegisterType(typeof(PurchaseReturnRepository)).As(typeof(IPurchaseReturnRepository)).InstancePerRequest();
            builder.RegisterType(typeof(BillRepository)).As(typeof(IBillRepository)).InstancePerRequest();
            builder.RegisterType(typeof(BillReturnRepository)).As(typeof(IBillReturnRepository)).InstancePerRequest();
            builder.RegisterType(typeof(InternalTransferRepository)).As(typeof(IInternalTransferRepository)).InstancePerRequest();
            builder.RegisterType(typeof(InternalTRansferReturnRepository)).As(typeof(IInternalTransferReturnRepository)).InstancePerRequest();
            builder.RegisterType(typeof(IndentRepository)).As(typeof(IIndentRepository)).InstancePerRequest();
            builder.RegisterType(typeof(IndentBillRepository)).As(typeof(IIndentBillRepository)).InstancePerRequest();
            builder.RegisterType(typeof(IndentReceivableRepository)).As(typeof(IIndentReceivableRepository)).InstancePerRequest();
            builder.RegisterType(typeof(CurrentStockRepository)).As(typeof(ICurrentStockRepository)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentIndentRepository)).As(typeof(IDepartmentIndentRepository)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentBillRepository)).As(typeof(IDepartmentBillRepository)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentUsageRepository)).As(typeof(IDepartmentUsageRepository)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentStockRepository)).As(typeof(IDepartmentStockRepository)).InstancePerRequest();
            builder.RegisterType(typeof(SalesReturnRepository)).As(typeof(ISalesReturnRepository)).InstancePerRequest();
            builder.RegisterType(typeof(StockAdjustmentRepository)).As(typeof(IStockAdjustmentRepository)).InstancePerRequest();
            builder.RegisterType(typeof(SupplierPayableRepository)).As(typeof(ISupplierPayableRepository)).InstancePerRequest();
            builder.RegisterType(typeof(EditedBillRepository)).As(typeof(IEditedBillRepository)).InstancePerRequest();
            builder.RegisterType(typeof(DueBillsRepository)).As(typeof(IDueBillsRepository)).InstancePerRequest();
            builder.RegisterType(typeof(CustomerReceivableRepository)).As(typeof(ICustomerReceivableRepository)).InstancePerRequest();

            builder.RegisterType(typeof(HttpContextCacheAdapter)).As(typeof(ICacheStorage)).InstancePerRequest();

            builder.RegisterType(typeof(AccountService)).As(typeof(IAccountService)).InstancePerRequest();
            builder.RegisterType(typeof(PharmacyService)).As(typeof(IPharmacyService)).InstancePerRequest();
            builder.RegisterType(typeof(MasterDataService)).As(typeof(IMasterDataService)).InstancePerRequest();
            builder.RegisterType(typeof(PurchaseService)).As(typeof(IPurchaseService)).InstancePerRequest();
            builder.RegisterType(typeof(PurchaseReturnService)).As(typeof(IPurchaseReturnService)).InstancePerRequest();
            builder.RegisterType(typeof(BillService)).As(typeof(IBillService)).InstancePerRequest();
            builder.RegisterType(typeof(BillReturnService)).As(typeof(IBillReturnService)).InstancePerRequest();
            builder.RegisterType(typeof(InternalTransferService)).As(typeof(IInternalTransferService)).InstancePerRequest();
            builder.RegisterType(typeof(InternalTransferReturnService)).As(typeof(IInternalTransferReturnService)).InstancePerRequest();
            builder.RegisterType(typeof(IndentService)).As(typeof(IIndentService)).InstancePerRequest();
            builder.RegisterType(typeof(IndentBillService)).As(typeof(IIndentBillService)).InstancePerRequest();
            builder.RegisterType(typeof(IndentReceivableService)).As(typeof(IIndentReceivableService)).InstancePerRequest();
            builder.RegisterType(typeof(CurrentStockService)).As(typeof(ICurrentStockService)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentIndentService)).As(typeof(IDepartmentIndentService)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentBillService)).As(typeof(IDepartmentBillService)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentUsageService)).As(typeof(IDepartmentUsageService)).InstancePerRequest();
            builder.RegisterType(typeof(DepartmentStockService)).As(typeof(IDepartmentStockService)).InstancePerRequest();
            builder.RegisterType(typeof(SalesReturnService)).As(typeof(ISalesReturnService)).InstancePerRequest();
            builder.RegisterType(typeof(StockAdjustmentService)).As(typeof(IStockAdjustmentService)).InstancePerRequest();
            builder.RegisterType(typeof(SupplierPayableService)).As(typeof(ISupplierPayableService)).InstancePerRequest();
            builder.RegisterType(typeof(EditedBillService)).As(typeof(IEditedBillService)).InstancePerRequest();
            builder.RegisterType(typeof(DueBillsService)).As(typeof(IDueBillsService)).InstancePerRequest();
            builder.RegisterType(typeof(CustomerReceivableService)).As(typeof(ICustomerReceivableService)).InstancePerRequest();

            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
        }


        public static void LoadMasterData()
        {
            var metaService = (IMasterDataService)DependencyResolver.Current.GetService(typeof(IMasterDataService));

            var pharmacyService = (IPharmacyService)DependencyResolver.Current.GetService(typeof(IPharmacyService));

            var store = (ICacheStorage)DependencyResolver.Current.GetService(typeof(ICacheStorage));

            //metaService.GetAllPharmacyDetails();


        }
    }
}