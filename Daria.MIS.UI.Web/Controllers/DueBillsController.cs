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
    public class DueBillsController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IDueBillsService StockAdjustmentService;
        private readonly IAccountService AccountService;

        public DueBillsController(IMasterDataService _masterSrv, IDueBillsService _stockadjustSrv, IAccountService _accServ)
        
        {
            MasterDataService = _masterSrv;
            StockAdjustmentService = _stockadjustSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.Manufacturers = MasterDataService.GetManufacturers().Select(c => new { Id = c.Id, Name = c.Name });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());
            return View();
        }

        [HttpPost]
        public ActionResult SaveStockAdjustment(DueBills model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            //model.DueBillsItems.RemoveAll(p => p.ProductId == 0);

            //if (model.Id == 0)
            //{
            StockAdjustmentService.AddDueBills(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            //}
            //else
            //{
                //model.UpdatedBy = user.PersonId;
                //model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
                //var updatedStatus = StockAdjustmentService.UpdatePurchase(model);
                //return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            //}

        }

        //[HttpPost]
        //public string GetPurchase(long id)
        //{
        //    //User user = (User)Session["CurrentUser"];
        //    //var model = StockAdjustmentService.GetPurchaseDetails(id, user.PharmacyId);
        //    //return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        //}

        [HttpPost]
        public ActionResult GetDueBillsList()
        {
            User user = (User)Session["CurrentUser"];
            var model = StockAdjustmentService.GetDueBillsList(user.PharmacyId);
            return Json(model);
        }
        //[HttpPost]
        //public ActionResult DeletePurchase(long id)
        //{

        //    //User user = (User)Session["CurrentUser"];
        //    //var deleted = StockAdjustmentService.DeletePurchase(new Bill { Id = id, PharmacyId = user.PharmacyId });
        //    //return Json(new { status = deleted });
        //}

        [HttpPost]
        public ActionResult ValidateUserLogin(User user)
        {
            User currentLoggedUser = (User)Session["CurrentUser"];

            var appUser = AccountService.VerifyUserCredentials(user.UserName, user.Password, currentLoggedUser.PharmacyId);

            return Json(appUser);
        }

        [HttpPost]
        public string GetDueBillItems(string no, string category)
        {
            User user = (User)Session["CurrentUser"];
            var model = StockAdjustmentService.GetDueBillItems(no, category);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }
        //[HttpPost]
        //public string GetIndent(long id)
        //{
        //    User user = (User)Session["CurrentUser"];
        //    var model = StockAdjustmentService.GetIndentDetails(id, user.PharmacyId);
        //    return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        //}
    }
}