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
    public class DepartmentUsageController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IDepartmentUsageService DepartmentUsageService;
        private readonly IAccountService AccountService;
        private readonly IDepartmentIndentService DepartmentIndentService;

        public DepartmentUsageController(IMasterDataService _masterSrv, IDepartmentIndentService _indentServ, IDepartmentUsageService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            DepartmentIndentService = _indentServ;
            DepartmentUsageService = _purchaseSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.Departments = MasterDataService.GetDepartments().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Patients = MasterDataService.GetPatients().Select(c => new { Id = c.Id, Name = c.Name, PatientName = c.PatientName, Age = c.Age, RegNo = c.RegNo, PayMode = c.PayMode, Ward = c.Ward, Consultant = c.Consultant });
            ViewBag.Manufacturers = MasterDataService.GetManufacturers().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Units = MasterDataService.GetDrugUnits().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Indents = DepartmentIndentService.GetIndents().Select(c => new { Id = c.Id, Name = c.IndentNo });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SavePurchase(DepartmentUsage model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.IndentBillItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                DepartmentUsageService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {
                DepartmentUsageService.AddPurchase(model);
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
            var model = DepartmentUsageService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        
        {
            User user = (User)Session["CurrentUser"];
            var model = DepartmentUsageService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = DepartmentUsageService.DeletePurchase(new DepartmentUsage { Id = id, PharmacyId = user.PharmacyId });
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
        public string GetDepartmentItems(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = DepartmentUsageService.GetDepartmentItems(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

    }
}