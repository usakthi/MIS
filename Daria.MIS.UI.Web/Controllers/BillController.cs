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
    public class BillController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IBillService BillService;
        private readonly IAccountService AccountService;
        private readonly IIndentService IndentService;

        public BillController(IMasterDataService _masterSrv, IIndentService _indentServ, IBillService _purchaseSrv, IAccountService _accServ)
        
        {
            MasterDataService = _masterSrv;
            IndentService = _indentServ;
            BillService = _purchaseSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.Consultants = MasterDataService.GetConsultants().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Patients = MasterDataService.GetPatients().Select(c => new { Id = c.Id, Name = c.Name, IPNo = c.IPNo, PatientName = c.PatientName, Age = c.Age, RegNo = c.RegNo, PayMode = c.PayMode, Ward = c.Ward, Consultant = c.Consultant });
            ViewBag.Manufacturers = MasterDataService.GetManufacturers().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Customers = MasterDataService.GetCustomers().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.Indents = IndentService.GetIndents().Select(c => new { Id = c.Id, Name = c.IndentNo });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SavePurchase(Bill model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.BillItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                BillService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {
                model.UpdatedBy = user.PersonId;
                model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
                var updatedStatus = BillService.UpdatePurchase(model);
                return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            }

        }

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = BillService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        
        {
            User user = (User)Session["CurrentUser"];
            var model = BillService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = BillService.DeletePurchase(new Bill { Id = id, PharmacyId = user.PharmacyId });
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
            var model = BillService.GetIndentDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }


        [HttpPost]
        public ActionResult SearchPurchases(BillSearchDTO model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = user.PharmacyId;

            if (model.EditedFrom.HasValue)
            {
                model.EditedFrom = model.EditedFrom.Value.Date;
            }
            if (model.EditedTo.HasValue)
            {
                model.EditedTo = model.EditedTo.Value.Date;
            }
            var records = BillService.SearchPurchases(model);
            return Json(new { data = records, total = model.TotalRecords });
        }
        //[HttpPost]
        //public string GetBillReceipt(long id)
        //{
        //    User user = (User)Session["CurrentUser"];
        //    var model = BillService.GetBillReceiptDetails(id, user.PharmacyId);
        //    return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        //}
    }
}