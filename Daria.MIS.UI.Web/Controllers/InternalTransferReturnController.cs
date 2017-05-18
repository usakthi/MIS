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
    public class InternalTransferReturnController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IInternalTransferReturnService InternalTransferReturnService;
        private readonly IAccountService AccountService;

        public InternalTransferReturnController(IMasterDataService _masterSrv, IInternalTransferReturnService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            InternalTransferReturnService = _purchaseSrv;
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
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SavePurchase(IntTransReturn model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.IntTransReturnItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                InternalTransferReturnService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {
                model.UpdatedBy = user.PersonId;
                model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
                var updatedStatus = InternalTransferReturnService.UpdatePurchase(model);
                return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            }

        }

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = InternalTransferReturnService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        {
            User user = (User)Session["CurrentUser"];
            var model = InternalTransferReturnService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = InternalTransferReturnService.DeletePurchase(new IntTransReturn { Id = id, PharmacyId = user.PharmacyId });
            return Json(new { status = deleted });
        }

        [HttpPost]
        public ActionResult ValidateUserLogin(User user)
        {
            User currentLoggedUser = (User)Session["CurrentUser"];

            var appUser = AccountService.VerifyUserCredentials(user.UserName, user.Password, currentLoggedUser.PharmacyId);

            return Json(appUser);
        }
    }
}