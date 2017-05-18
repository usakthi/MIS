using System.Web;
using System.Web.Optimization;

namespace Daria.MIS.UI.Web
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new StyleBundle("~/bundles/fontawesome").Include(
             "~/content/angle/Vendor/fontawesome/css/font-awesome.min.css"
            ));

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"
            ));
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                       "~/Scripts/jquery-2.1.3.min.js"
            ));
            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                     "~/Scripts/bootstrap.min.js"
           ));
            bundles.Add(new ScriptBundle("~/bundles/Common").Include(
                     "~/app/Helpers/bootstrap-start.js",
                     "~/app/Helpers/jquery.storageapi.js",
                     "~/app/Helpers/clear-storage.js",
                     "~/app/Helpers/constants.js",
                     "~/app/Helpers/sidebar.js",
                     "~/app/Helpers/toggle-state.js"
           ));

            bundles.Add(new ScriptBundle("~/bundles/Admin").Include(

                 "~/app/admin/adminServices.js",
                 "~/app/admin/unit/controllers/unitcontroller.js",
                 "~/app/admin/manf/controllers/manufacturercontroller.js",
                 "~/app/admin/category/controllers/categorycontroller.js",
                 "~/app/admin/content/controllers/contentcontroller.js",
                 "~/app/admin/drugtype/controllers/drugtypecontroller.js",
                 "~/app/admin/department/controllers/departmentcontroller.js",
                 "~/app/admin/rack/controllers/rackcontroller.js",
                 "~/app/admin/tax/controllers/taxcontroller.js",
                 "~/app/admin/bank/controllers/bankcontroller.js",
                 "~/app/admin/product/controllers/productcontroller.js",
                 "~/app/admin/creditauth/controllers/creditauthcontroller.js",
                 "~/app/admin/druggeneric/controllers/druggenericcontroller.js",
                 "~/app/admin/purchaserequest/controllers/purchaserequestcontroller.js",
                 "~/app/admin/supplier/controllers/suppliercontroller.js",
                 "~/app/admin/consultant/controllers/consultantcontroller.js",
                 "~/app/admin/patient/controllers/patientcontroller.js",
                 "~/app/admin/role/controllers/rolecontroller.js",
                 "~/app/admin/adminapp.js",
                 "~/app/admin/admincontroller.js"
           ));

            bundles.Add(new ScriptBundle("~/bundles/Purchase").Include(

                 "~/app/purchase/purchase-service.js",
                 "~/app/purchase/controllers/purchase-entry-controller.js",
                 "~/app/purchase/purchase-app.js"
           ));

            bundles.Add(new ScriptBundle("~/bundles/PurchaseReturn").Include(

                 "~/app/purchasereturn/purchasereturn-service.js",
                 "~/app/purchasereturn/controllers/purchasereturn-entry-controller.js",
                 "~/app/purchasereturn/purchasereturn-app.js"
           ));

            bundles.Add(new ScriptBundle("~/bundles/Bill").Include(

                "~/app/bill/bill-service.js",
                "~/app/bill/controllers/bill-entry-controller.js",
                "~/app/bill/bill-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/BillReturn").Include(

                "~/app/billreturn/billreturn-service.js",
                "~/app/billreturn/controllers/billreturn-entry-controller.js",
                "~/app/billreturn/billreturn-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/InternalTransfer").Include(

                "~/app/internaltransfer/internaltransfer-service.js",
                "~/app/internaltransfer/controllers/internaltransfer-entry-controller.js",
                "~/app/internaltransfer/internaltransfer-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/InternalTransferReturn").Include(

                "~/app/internaltransferreturn/internaltransferreturn-service.js",
                "~/app/internaltransferreturn/controllers/internaltransferreturn-entry-controller.js",
                "~/app/internaltransferreturn/internaltransferreturn-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/Indent").Include(

                "~/app/indent/indent-service.js",
                "~/app/indent/controllers/indent-entry-controller.js",
                "~/app/indent/indent-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/IndentBill").Include(

                "~/app/indentbill/indentbill-service.js",
                "~/app/indentbill/controllers/indentbill-entry-controller.js",
                "~/app/indentbill/indentbill-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/IndentReceivable").Include(

                "~/app/indentreceivable/indentreceivable-service.js",
                "~/app/indentreceivable/controllers/indentreceivable-entry-controller.js",
                "~/app/indentreceivable/indentreceivable-app.js"
          ));

            bundles.Add(new ScriptBundle("~/bundles/CurrentStock").Include(

                "~/app/currentstock/currentstock-service.js",
                "~/app/currentstock/controllers/currentstock-entry-controller.js",
                "~/app/currentstock/currentstock-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/DepartmentIndent").Include(

                "~/app/departmentindent/departmentindent-service.js",
                "~/app/departmentindent/controllers/departmentindent-entry-controller.js",
                "~/app/departmentindent/departmentindent-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/DepartmentBill").Include(

                "~/app/departmentbill/departmentbill-service.js",
                "~/app/departmentbill/controllers/departmentbill-entry-controller.js",
                "~/app/departmentbill/departmentbill-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/DepartmentUsage").Include(

                "~/app/departmentusage/departmentusage-service.js",
                "~/app/departmentusage/controllers/departmentusage-entry-controller.js",
                "~/app/departmentusage/departmentusage-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/DepartmentStock").Include(

                "~/app/departmentstock/departmentstock-service.js",
                "~/app/departmentstock/controllers/departmentstock-entry-controller.js",
                "~/app/departmentstock/departmentstock-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/SalesReturn").Include(

                "~/app/salesreturn/salesreturn-service.js",
                "~/app/salesreturn/controllers/salesreturn-entry-controller.js",
                "~/app/salesreturn/salesreturn-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/stockadjustment").Include(

                "~/app/stockadjustment/stockadjustment-service.js",
                "~/app/stockadjustment/controllers/stockadjustment-controller.js",
                "~/app/stockadjustment/stockadjustment-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/supplierpayable").Include(

                "~/app/supplierpayable/supplierpayable-service.js",
                "~/app/supplierpayable/controllers/supplierpayable-controller.js",
                "~/app/supplierpayable/supplierpayable-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/editedbill").Include(

                "~/app/editedbill/editedbill-service.js",
                "~/app/editedbill/controllers/editedbill-controller.js",
                "~/app/editedbill/editedbill-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/duebills").Include(

                "~/app/duebills/duebills-service.js",
                "~/app/duebills/controllers/duebills-controller.js",
                "~/app/duebills/duebills-app.js"
          ));
            bundles.Add(new ScriptBundle("~/bundles/customerreceivable").Include(

                "~/app/customerreceivable/customerreceivable-service.js",
                "~/app/customerreceivable/controllers/customerreceivable-controller.js",
                "~/app/customerreceivable/customerreceivable-app.js"
          ));
            //BundleTable.EnableOptimizations = true;
        }
    }
}
