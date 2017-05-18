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
    public class IndentReceivableController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IIndentReceivableService IndentReceivableService;
        private readonly IAccountService AccountService;

        public IndentReceivableController(IMasterDataService _masterSrv, IIndentReceivableService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            IndentReceivableService = _purchaseSrv;
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
            ViewBag.Dues = IndentReceivableService.GetDuePatientList().Select(c => new { Id = c.BillCode, Name = c.IPNo });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SavePurchase(IndentReceivable model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.IndentReceivableItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                IndentReceivableService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {
                IndentReceivableService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });

                //model.UpdatedBy = user.PersonId;
                //model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
                //var updatedStatus = IndentBillService.UpdatePurchase(model);
                //return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            }

        }

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = IndentReceivableService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        
        {
            User user = (User)Session["CurrentUser"];
            var model = IndentReceivableService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = IndentReceivableService.DeletePurchase(new IndentReceivable { Id = id, PharmacyId = user.PharmacyId });
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
            var indents = IndentReceivableService.GetDuePatientList();
            return Json(indents);
        }

        [HttpPost]
        public string GetIndent(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = IndentReceivableService.GetIndentDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }
    }
}