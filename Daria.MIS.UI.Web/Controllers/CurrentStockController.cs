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
    public class CurrentStockController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly ICurrentStockService CurrentStockService;
        private readonly IAccountService AccountService;

        public CurrentStockController(IMasterDataService _masterSrv, ICurrentStockService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            CurrentStockService = _purchaseSrv;
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
        public ActionResult SavePurchase(CurrentStock model)
        {
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
        }

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = CurrentStockService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        {
            User user = (User)Session["CurrentUser"];
            var model = CurrentStockService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }

        [HttpPost]
        public ActionResult RptCurrentStock(CurrentStockSearchDTO model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = user.PharmacyId;

            if (model.AddedFrom.HasValue)
            {
                model.AddedFrom = model.AddedFrom.Value.Date;
            }
            if (model.AddedTo.HasValue)
            {
                model.AddedTo = model.AddedTo.Value.Date;
            }
            var records = CurrentStockService.RptCurrentStock(model);
            return Json(new { data = records, total = model.TotalRecords });
        }


        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = 0;// CurrentStockService.DeletePurchase(new Purchase { Id = id, PharmacyId = user.PharmacyId });
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