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
    public class SupplierPayableController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly ISupplierPayableService SupplierPayableService;
        private readonly IAccountService AccountService;

        public SupplierPayableController(IMasterDataService _masterSrv, ISupplierPayableService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            SupplierPayableService = _purchaseSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.Suppliers = MasterDataService.GetSuppliers().Select(c => new { Id = c.Id, Name = c.Name, DueDays = c.DueDays });
            ViewBag.Racks = MasterDataService.GetRacks().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Manufacturers = MasterDataService.GetManufacturers().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Units = MasterDataService.GetDrugUnits().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Dues = SupplierPayableService.GetDueSupplierPayable().Select(c => new { Id = c.Id, Name = c.GRNNo });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        //[HttpPost]
        //public ActionResult SaveSupplierPayable(SupplierPayable model)
        //{
        //    User user = (User)Session["CurrentUser"];
        //    model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

        //    model.AddedPerson = new Person { PersonId = user.PersonId };
        //    model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

        //    //model.SupplierPayableItems.RemoveAll(p => p.Id == 0);

        //    //if (model.Id == 0)
        //    //{
        //        SupplierPayableService.AddSupplierPayable(model);
        //        return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
        //    //}
        //    //else
        //    //{
        //    //    SupplierPayableService.AddSupplierPayable(model);
        //    //    return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });

        //    //    //model.UpdatedBy = user.PersonId;
        //    //    //model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
        //    //    //var updatedStatus = IndentBillService.UpdatePurchase(model);
        //    //    //return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
        //    //}

        //}

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = SupplierPayableService.GetSupplierPayables(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        
        {
            User user = (User)Session["CurrentUser"];
            var model = SupplierPayableService.GetSupplierPayableList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = SupplierPayableService.DeleteSupplierPayable(new SupplierPayable { Id = id, PharmacyId = user.PharmacyId });
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
        public ActionResult GetAllDueLists()
        {
            User user = (User)Session["CurrentUser"];
            var indents = SupplierPayableService.GetDueSupplierPayable();
            return Json(indents);
        }

        [HttpPost]
        public string GetIndent(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = SupplierPayableService.GetIndentDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult SaveSupplierPayable(List<SupplierPayableDueList> q)
        {
            SupplierPayableService.SaveSupplierPayable(q);
            return null;
        }
    }
}