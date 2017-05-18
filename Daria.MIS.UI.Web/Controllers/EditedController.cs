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
    public class EditedBillController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IEditedBillService EditedBillService;
        private readonly IAccountService AccountService;

        public EditedBillController(IMasterDataService _masterSrv, IEditedBillService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            EditedBillService = _purchaseSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        //[HttpPost]
        //public ActionResult GetPurchaseList()
        //{
        //    User user = (User)Session["CurrentUser"];
        //    var model = EditedBillService.GetPurchaseList(user.PharmacyId);
        //    return Json(model);
        //}

        [HttpPost]
        public ActionResult SearchPurchases(EditedBillSearchDTO model)
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
            var records = EditedBillService.SearchPurchases(model);
            return Json(new { data = records, total = model.TotalRecords });
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