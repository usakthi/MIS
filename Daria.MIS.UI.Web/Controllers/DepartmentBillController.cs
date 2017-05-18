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
    public class DepartmentBillController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IDepartmentBillService DepartmentBillService;
        private readonly IAccountService AccountService;
        private readonly IDepartmentIndentService DepartmentIndentService;

        public DepartmentBillController(IMasterDataService _masterSrv, IDepartmentIndentService _indentServ, IDepartmentBillService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            DepartmentIndentService = _indentServ;
            DepartmentBillService = _purchaseSrv;
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
            ViewBag.Indents = DepartmentIndentService.GetIndents().Select(c => new { Id = c.Id, Name = c.IndentNo });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SavePurchase(DepartmentBill model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.IndentBillItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                DepartmentBillService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {
                DepartmentBillService.AddPurchase(model);
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
            var model = DepartmentBillService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        
        {
            User user = (User)Session["CurrentUser"];
            var model = DepartmentBillService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = DepartmentBillService.DeletePurchase(new DepartmentBill { Id = id, PharmacyId = user.PharmacyId });
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
        public string GetIndent(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = DepartmentBillService.GetIndentDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }
    }
}