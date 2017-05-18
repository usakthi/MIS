using Daria.MIS.Core.Entities;
using Daria.MIS.Core.Services;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Daria.MIS.UI.Web.Controllers
{
    public class CustomerReceivableController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly ICustomerReceivableService CustomerReceivableService;
        private readonly IAccountService AccountService;

        public CustomerReceivableController(IMasterDataService _masterSrv, ICustomerReceivableService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            CustomerReceivableService = _purchaseSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.Suppliers = MasterDataService.GetSuppliers().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SaveCustomerReceivable(CustomerReceivable model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            //model.SupplierPayableItems.RemoveAll(p => p.Id == 0);

            //if (model.Id == 0)
            //{
            CustomerReceivableService.AddCustomerReceivable(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            //}
            //else
            //{
            //    SupplierPayableService.AddSupplierPayable(model);
            //    return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });

            //    //model.UpdatedBy = user.PersonId;
            //    //model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
            //    //var updatedStatus = IndentBillService.UpdatePurchase(model);
            //    //return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            //}

        }

        [HttpPost]
        public string GetCustomerDueInfo(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = CustomerReceivableService.GetCustomerReceivables(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetCustomerReceivableList()
        
        {
            User user = (User)Session["CurrentUser"];
            var model = CustomerReceivableService.GetCustomerReceivableList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = CustomerReceivableService.DeleteCustomerReceivable(new CustomerReceivable { Id = id, PharmacyId = user.PharmacyId });
            return Json(new { status = deleted });
        }

        [HttpPost]
        public ActionResult ValidateUserLogin(User user)
        {
            User currentLoggedUser = (User)Session["CurrentUser"];

            var appUser = AccountService.VerifyUserCredentials(user.UserName, user.Password, currentLoggedUser.PharmacyId);

            return Json(appUser);
        }

        [HttpPost]
        public ActionResult getCustomerDueList()
        {
            User user = (User)Session["CurrentUser"];
            var indents = CustomerReceivableService.GetDueCustomerReceivable();
            return Json(indents);
        }

        [HttpPost]
        public ActionResult SaveDueReceivable(List<CustomerDueList> q)
        {
            CustomerReceivableService.SaveDueReceivable(q);
            return null;
        }
    }
}