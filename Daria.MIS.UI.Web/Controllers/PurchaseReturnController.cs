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
    public class PurchaseReturnController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IPurchaseReturnService PurchaseReturnService;
        private readonly IAccountService AccountService;

        public PurchaseReturnController(IMasterDataService _masterSrv, IPurchaseReturnService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            PurchaseReturnService = _purchaseSrv;
            AccountService = _accServ;
        }

        [UserMenuFilter]
        public ActionResult Index()
        {
            User user = (User)Session["CurrentUser"];
            ViewBag.Suppliers = MasterDataService.GetSuppliers().Select(c => new { Id = c.Id, Name = c.Name, DueDays = c.DueDays });
            ViewBag.PharmacyIdEnc = WebAppHelper.Obfuscate(user.PharmacyId.ToString());

            return View();
        }

        [HttpPost]
        public ActionResult SavePurchase(PurchaseReturn model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.PurchaseReturnItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                PurchaseReturnService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {

                PurchaseReturnService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });

                //model.UpdatedBy = user.PersonId;
                //model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
                //var updatedStatus = PurchaseReturnService.UpdatePurchase(model);
                //return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            }

        }

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = PurchaseReturnService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        {
            User user = (User)Session["CurrentUser"];
            var model = PurchaseReturnService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }
        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = PurchaseReturnService.DeletePurchase(new PurchaseReturn { Id = id, PharmacyId = user.PharmacyId });
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
        public string GetPurchasedItems(string no, string category)
        {
            User user = (User)Session["CurrentUser"];
            var model = PurchaseReturnService.GetPurchasedItems(no, category);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetSupplierInvoices(string q,string category)
        {
            var model = PurchaseReturnService.GetSupplierInvoices(q, category);
            return Json(model);
        }

        [HttpGet]
        public ActionResult GetProductsForPurchaseReturnAutoComplete(string q)
        {
            var model = PurchaseReturnService.GetProductsForPurchaseReturn(q);
            if (q != null)
            {
                model = model.FindAll(p => p.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(p => new { aa = p.Category, label = p.Name, id = p.Id, ProductId = p.ProductId, manfId = p.MfgId, manf = p.MfgName, batchNo = p.BatchNo, expDate = p.ExpDate, stock = p.Stock, purstk = p.PurStk, purDetId = p.PurDetId, mrp = p.MRP, costPrice = p.CostPrice, vat = p.VAT, pack = p.Pack, taxmode = p.TaxMode, taxtype = p.TaxType, discper = p.DiscountPercent }), JsonRequestBehavior.AllowGet);
            }
            return Json(model, JsonRequestBehavior.AllowGet);
        }
    }
}