using Daria.MIS.Core.Entities;
using Daria.MIS.Core.Services;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Daria.MIS.UI.Web.Controllers
{
    public class PurchaseController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IPurchaseService PurchaseService;
        private readonly IAccountService AccountService;

        public PurchaseController(IMasterDataService _masterSrv, IPurchaseService _purchaseSrv, IAccountService _accServ)
        {
            MasterDataService = _masterSrv;
            PurchaseService = _purchaseSrv;
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
        public ActionResult SavePurchase(Purchase model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = Convert.ToInt32(WebAppHelper.Deobfuscate(model.PharmacyIdEnc));

            model.AddedPerson = new Person { PersonId = user.PersonId };
            model.AddedDateTime = WebAppHelper.GetCurrentDateTime();

            model.GrnDate = model.GrnDate.Date;

            if (model.CreditDate.HasValue)
            {
                model.CreditDate = model.CreditDate.Value.Date;
            }
            if (model.SupplierInvDate.HasValue)
            {
                model.SupplierInvDate = model.SupplierInvDate.Value.Date;
            }
            if (model.PurchaseItems != null)
                model.PurchaseItems.RemoveAll(p => p.ProductId == 0);

            if (model.Id == 0)
            {
                PurchaseService.AddPurchase(model);
                return Json(new { status = model.Id > 0 ? true : false, id = model.Id, mode = "add" });
            }
            else
            {
                model.UpdatedBy = user.PersonId;
                model.UpdatedDateTime = WebAppHelper.GetCurrentDateTime();
                var updatedStatus = PurchaseService.UpdatePurchase(model);
                return Json(new { status = updatedStatus, id = model.Id, mode = "update" });
            }

        }

        [HttpPost]
        public string GetPurchase(long id)
        {
            User user = (User)Session["CurrentUser"];
            var model = PurchaseService.GetPurchaseDetails(id, user.PharmacyId);
            return JsonConvert.SerializeObject(model, new IsoDateTimeConverter());
        }

        [HttpPost]
        public ActionResult GetPurchaseList()
        {
            User user = (User)Session["CurrentUser"];
            var model = PurchaseService.GetPurchaseList(user.PharmacyId);
            return Json(model);
        }

        [HttpPost]
        public ActionResult SearchPurchases(PurchaseSearchDTO model)
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
            var records = PurchaseService.SearchPurchases(model);
            return Json(new { data = records, total = model.TotalRecords });
        }


        [HttpPost]
        public ActionResult DeletePurchase(long id)
        {

            User user = (User)Session["CurrentUser"];
            var deleted = PurchaseService.DeletePurchase(new Purchase { Id = id, PharmacyId = user.PharmacyId });
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
        public ActionResult SaveOpenStockFromFile()
        {
            var file = Request.Files[0];

            if (file != null)
            {
                var fileName = Guid.NewGuid() + "_" + file.FileName;
                var filePath = Server.MapPath("~/Uploads/OpenStock");
                var targetFile = Path.Combine(filePath, fileName);
                if (!System.IO.Directory.Exists(filePath))
                {
                    System.IO.Directory.CreateDirectory(filePath);
                }
                file.SaveAs(targetFile);

                var stocks = PurchaseViewModel.ReadOpenStocks(targetFile);
                return Json(new { data = stocks, status = true });
            }
            return Json(new { status = false });
        }

        [HttpPost]
        public ActionResult GetPurchaseItems(long prodId)
        {
            User user = (User)Session["CurrentUser"];
            var model = PurchaseService.GetPurchaseItems(user.PharmacyId, prodId);
            return Json(model);
        }

        [HttpGet]
        public ActionResult GetSupplierInvoicesAutoComplete(string q)
        {
            var model = PurchaseService.GetInvoicesList();
            if (q != null)
            {
                model = model.FindAll(m => m.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(m => new { label = m.Name, id = m.Id }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }
    }
}