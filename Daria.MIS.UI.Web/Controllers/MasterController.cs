using Daria.MIS.Core.Entities;
using Daria.MIS.Core.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Daria.MIS.UI.Web.Areas.Admin.Controllers
{
    [RoutePrefix("admin")]
    [Route("{action=index}")]
    // [FeatureAuthentication]
    public class MasterController : Controller
    {
        private readonly IMasterDataService MasterDataService;
        private readonly IPharmacyService PharmacyService;

        public MasterController(IMasterDataService _service, IPharmacyService _pharmacyService)
        {
            MasterDataService = _service;
            PharmacyService = _pharmacyService;
        }

        [Route("~/admin")]
        [UserMenuFilter]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult GetAllDrugUnits()
        {
            var units = MasterDataService.GetDrugUnits();
            return Json(units);
        }

        [HttpPost]
        public ActionResult GetDrugUnit(int id)
        {
            var model = MasterDataService.GetDrugUnit(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddDrugUnit(DrugUnit unit)
        {
            MasterDataService.AddDrugUnit(unit);
            return Json(new { status = unit.Id > 0 ? true : false, id = unit.Id });
        }

        [HttpPost]
        public ActionResult EditDrugUnit(DrugUnit unit)
        {
            var updated = MasterDataService.UpdateDrugUnit(unit);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteDrugUnit(int id)
        {
            var deleted = MasterDataService.DeleteDrugUnit(new DrugUnit { Id = id });
            return Json(new { status = deleted });
        }

        // Manufacturer
        [HttpPost]
        public ActionResult GetAllManufacturers()
        {
            var manufs = MasterDataService.GetManufacturers();
            return Json(manufs);
        }

        [HttpPost]
        public ActionResult GetManufacturer(int id)
        {
            var model = MasterDataService.GetManufacturer(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddManufacturer(Manufacturer manuf)
        {
            MasterDataService.AddManufacturer(manuf);
            return Json(new { status = manuf.Id > 0 ? true : false, id = manuf.Id });
        }

        [HttpPost]
        public ActionResult EditManufacturer(Manufacturer manuf)
        {
            var updated = MasterDataService.UpdateManufacturer(manuf);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteManufacturer(int id)
        {
            var deleted = MasterDataService.DeleteManufacturer(new Manufacturer { Id = id });
            return Json(new { status = deleted });
        }

        // DrugCategory
        [HttpPost]
        public ActionResult GetAllDrugCategories()
        {
            var cats = MasterDataService.GetDrugCategories();
            return Json(cats);
        }

        [HttpPost]
        public ActionResult GetDrugCategory(int id)
        {
            var model = MasterDataService.GetDrugCategory(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddDrugCategory(DrugCategory cat)
        {
            MasterDataService.AddDrugCategory(cat);
            return Json(new { status = cat.Id > 0 ? true : false, id = cat.Id });
        }

        [HttpPost]
        public ActionResult EditDrugCategory(DrugCategory cat)
        {
            var updated = MasterDataService.UpdateDrugCategory(cat);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteDrugCategory(int id)
        {
            var deleted = MasterDataService.DeleteDrugCategory(new DrugCategory { Id = id });
            return Json(new { status = deleted });
        }

        // DrugContent
        [HttpPost]
        public ActionResult GetAllDrugContents()
        {
            var conts = MasterDataService.GetDrugContents();
            return Json(conts);
        }

        [HttpPost]
        public ActionResult GetDrugContent(int id)
        {
            var model = MasterDataService.GetDrugContent(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddDrugContent(DrugContent cont)
        {
            MasterDataService.AddDrugContent(cont);
            return Json(new { status = cont.Id > 0 ? true : false, id = cont.Id });
        }

        [HttpPost]
        public ActionResult EditDrugContent(DrugContent cont)
        {
            var updated = MasterDataService.UpdateDrugContent(cont);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteDrugContent(int id)
        {
            var deleted = MasterDataService.DeleteDrugContent(new DrugContent { Id = id });
            return Json(new { status = deleted });
        }

        // DrugType
        [HttpPost]
        public ActionResult GetAllDrugTypes()
        {
            var types = MasterDataService.GetDrugTypes();
            return Json(types);
        }

        [HttpPost]
        public ActionResult GetDrugType(int id)
        {
            var model = MasterDataService.GetDrugType(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddDrugType(DrugType type)
        {
            MasterDataService.AddDrugType(type);
            return Json(new { status = type.Id > 0 ? true : false, id = type.Id });
        }

        [HttpPost]
        public ActionResult EditDrugType(DrugType type)
        {
            var updated = MasterDataService.UpdateDrugType(type);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteDrugType(int id)
        {
            var deleted = MasterDataService.DeleteDrugType(new DrugType { Id = id });
            return Json(new { status = deleted });
        }

        // Department
        [HttpPost]
        public ActionResult GetAllDepartments()
        {
            var depts = MasterDataService.GetDepartments();
            return Json(depts);
        }

        [HttpPost]
        public ActionResult GetDepartment(int id)
        {
            var model = MasterDataService.GetDepartment(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddDepartment(Department dept)
        {
            MasterDataService.AddDepartment(dept);
            return Json(new { status = dept.Id > 0 ? true : false, id = dept.Id });
        }

        [HttpPost]
        public ActionResult EditDepartment(Department dept)
        {
            var updated = MasterDataService.UpdateDepartment(dept);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteDepartment(int id)
        {
            var deleted = MasterDataService.DeleteDepartment(new Department { Id = id });
            return Json(new { status = deleted });
        }

        // Consultant
        [HttpPost]
        public ActionResult GetAllConsultants()
        {
            var cons = MasterDataService.GetConsultants();
            return Json(cons);
        }

        [HttpPost]
        public ActionResult GetConsultant(int id)
        {
            var model = MasterDataService.GetConsultant(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddConsultant(Consultant con)
        {
            MasterDataService.AddConsultant(con);
            return Json(new { status = con.Id > 0 ? true : false, id = con.Id });
        }

        [HttpPost]
        public ActionResult EditConsultant(Consultant con)
        {
            var updated = MasterDataService.UpdateConsultant(con);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteConsultant(int id)
        {
            var deleted = MasterDataService.DeleteConsultant(new Consultant { Id = id });
            return Json(new { status = deleted });
        }

        // Rack
        [HttpPost]
        public ActionResult GetAllRacks()
        {
            var racks = MasterDataService.GetRacks();
            return Json(racks);
        }

        
        [HttpPost]
        public ActionResult GetRack(int id)
        {
            var model = MasterDataService.GetRack(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddRack(Rack rack)
        {
            MasterDataService.AddRack(rack);
            return Json(new { status = rack.Id > 0 ? true : false, id = rack.Id });
        }

        [HttpPost]
        public ActionResult EditRack(Rack rack)
        {
            var updated = MasterDataService.UpdateRack(rack);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteRack(int id)
        {
            var deleted = MasterDataService.DeleteRack(new Rack { Id = id });
            return Json(new { status = deleted });
        }

        // Tax
        [HttpPost]
        public ActionResult GetAllTaxs()
        {
            var taxs = MasterDataService.GetTaxs();
            return Json(taxs);
        }

        [HttpPost]
        public ActionResult GetTax(int id)
        {
            var model = MasterDataService.GetTax(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddTax(Tax tax)
        {
            MasterDataService.AddTax(tax);
            return Json(new { status = tax.Id > 0 ? true : false, id = tax.Id });
        }

        [HttpPost]
        public ActionResult EditTax(Tax tax)
        {
            var updated = MasterDataService.UpdateTax(tax);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteTax(int id)
        {
            var deleted = MasterDataService.DeleteTax(new Tax { Id = id });
            return Json(new { status = deleted });
        }
        // Bank
        [HttpPost]
        public ActionResult GetAllBanks()
        {
            var bans = MasterDataService.GetBanks();
            return Json(bans);
        }

        [HttpPost]
        public ActionResult GetBank(int id)
        {
            var model = MasterDataService.GetBank(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddBank(Bank ban)
        {
            MasterDataService.AddBank(ban);
            return Json(new { status = ban.Id > 0 ? true : false, id = ban.Id });
        }

        [HttpPost]
        public ActionResult EditBank(Bank ban)
        {
            var updated = MasterDataService.UpdateBank(ban);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteBank(int id)
        {
            var deleted = MasterDataService.DeleteBank(new Bank { Id = id });
            return Json(new { status = deleted });
        }


        // Supplier
        [HttpPost]
        public ActionResult GetAllSuppliers()
        {
            var suppliers = MasterDataService.GetSuppliers();
            return Json(suppliers);
        }
        [HttpPost]
        public ActionResult GetSupplier(int id)
        {
            var model = MasterDataService.GetSupplier(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddSupplier(Supplier supplier)
        {
            MasterDataService.AddSupplier(supplier);
            return Json(new { status = supplier.Id > 0 ? true : false, id = supplier.Id });
        }

        [HttpPost]
        public ActionResult EditSupplier(Supplier supplier)
        {
            var updated = MasterDataService.UpdateSupplier(supplier);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteSupplier(int id)
        {
            var deleted = MasterDataService.DeleteSupplier(new Supplier { Id = id });
            return Json(new { status = deleted });
        }

        // Patient
        [HttpPost]
        public ActionResult GetAllPatients()
        {
            var patients = MasterDataService.GetPatients();
            return Json(patients);
        }
        [HttpPost]
        public ActionResult GetPatient(int id)
        {
            var model = MasterDataService.GetSupplier(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddPatient(Patient patient)
        {
            MasterDataService.AddPatient(patient);
            return Json(new { status = patient.Id > 0 ? true : false, id = patient.Id });
        }

        [HttpPost]
        public ActionResult EditPatient(Patient patient)
        {
            var updated = MasterDataService.UpdatePatient(patient);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeletePatient(int id)
        {
            var deleted = MasterDataService.DeletePatient(new Patient { Id = id });
            return Json(new { status = deleted });
        }

        // Product
        //[HttpPost]
        //public ActionResult GetAllProducts()
        //{
        //    var products = MasterDataService.GetProducts();
        //    return Json(products);
        //}

        [HttpPost]
        public ActionResult GetProduct(int id)
        {
            var model = MasterDataService.GetProduct(id);
            return Json(model);
        }

        [HttpGet]
        public ActionResult GetProductsAutoComplete(string q)
        {
            var model = MasterDataService.GetProducts();
            if (q != null)
            {
                model= model.FindAll(p => p.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(p => new { aa = p.DrugCategory.Name, label = p.Name, id = p.Id, unitId = p.DrugUnit.Id,manfId = p.Manufacturer.Id, manf = p.Manufacturer.Name, batchNo = p.BatchNo, expDate = p.ExpDate, stock = p.Stock, grnNo = p.GRNNo, purDetId = p.PurDetId, mrp = p.MRP, costPrice = p.CostPrice, vat = p.VAT }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetProductsForBillAutoComplete(string q)
        {
            var model = MasterDataService.GetProductsForBill(q);
            if (q != null)
            {
                model = model.FindAll(p => p.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(p => new { aa = p.DrugCategory.Name, label = p.Name, id = p.Id, unitId = p.DrugUnit.Id, manfId = p.Manufacturer.Id, manf = p.Manufacturer.Name, batchNo = p.BatchNo, expDate = p.ExpDate, stock = p.Stock, grnNo = p.GRNNo, purDetId = p.PurDetId, mrp = p.MRP, costPrice = p.CostPrice, vat = p.VAT, Pur = p.Pur, PurRet = p.PurRet, Sal = p.Sal, SalRet = p.SalRet, OpenStk = p.OpenStk, CurStk = p.CurStk, StkAdj = p.StkAdj, PreMRP = p.PreMRP }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetProductsForUsageAutoComplete(string q,string c)
        {
            var model = MasterDataService.GetProductsForUsage(q,c);
            if (q != null)
            {
                model = model.FindAll(p => p.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                //return Json(model.Select(p => new { aa = p.DrugCategory.Name, label = p.Name, id = p.Id, unitId = p.DrugUnit.Id, manfId = p.Manufacturer.Id, manf = p.Manufacturer.Name, batchNo = p.BatchNo, expDate = p.ExpDate, stock = p.Stock, grnNo = p.GRNNo, purDetId = p.PurDetId, mrp = p.MRP, costPrice = p.CostPrice, vat = p.VAT }), JsonRequestBehavior.AllowGet);
                return Json(model.Select(p => new { aa = p.DrugCategory.Name, label = p.Name, id = p.Id, manfId = p.Manufacturer.Id, manf = p.Manufacturer.Name, batchNo = p.BatchNo, expDate = p.ExpDate, stock = p.Stock, grnNo = p.GRNNo, billdate= p.GRNDate, purDetId = p.PurDetId, mrp = p.MRP, vat = p.VAT, billcode = p.BillCode }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetManufacturesAutoComplete(string q)
        { 
            var model = MasterDataService.GetManufacturers();
            if (q != null)
            {
                model = model.FindAll(m => m.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(m => new { label = m.Name, id = m.Id}), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetSupplierAutoComplete(string q)
        {
            var model = MasterDataService.GetSuppliers();
            if (q != null)
            {
                model = model.FindAll(m => m.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(m => new { label = m.Name, id = m.Id }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetConsultantAutoComplete(string q)
        {
            var model = MasterDataService.GetConsultants();
            if (q != null)
            {
                model = model.FindAll(m => m.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(m => new { label = m.Name, id = m.Id }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetCustomerAutoComplete(string q)
        {
            var model = MasterDataService.GetCustomers();
            if (q != null)
            {
                model = model.FindAll(m => m.Name.StartsWith(q, StringComparison.OrdinalIgnoreCase));
                return Json(model.Select(m => new { label = m.Name, id = m.Id }), JsonRequestBehavior.AllowGet);
            }

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult AddProduct(Product product)
        {
            MasterDataService.AddProduct(product);
            return Json(new { status = product.Id > 0 ? true : false, id = product.Id });
        }

        [HttpPost]
        public ActionResult EditProduct(Product product)
        {
            var updated = MasterDataService.UpdateProduct(product);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteProduct(int id)
        {
            var deleted = MasterDataService.DeleteProduct(new Product { Id = id });
            return Json(new { status = deleted });
        }


        // CreditAuth
        [HttpPost]
        public ActionResult GetAllCreditAuths()
        {
            var creditauths = MasterDataService.GetCreditAuths();
            return Json(creditauths);
        }

        [HttpPost]
        public ActionResult GetCreditAuth(int id)
        {
            var model = MasterDataService.GetCreditAuth(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddCreditAuth(CreditAuth creditauth)
        {
            MasterDataService.AddCreditAuth(creditauth);
            return Json(new { status = creditauth.Id > 0 ? true : false, id = creditauth.Id });
        }

        [HttpPost]
        public ActionResult EditCreditAuth(CreditAuth creditauth)
        {
            var updated = MasterDataService.UpdateCreditAuth(creditauth);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteCreditAuth(int id)
        {
            var deleted = MasterDataService.DeleteCreditAuth(new CreditAuth { Id = id });
            return Json(new { status = deleted });
        }


        //DrugGeneric
        [HttpPost]
        public ActionResult GetAllDrugGenerics()
        {
            var druggenerics = MasterDataService.GetDrugGenerics();
            return Json(druggenerics);
        }

        [HttpPost]
        public ActionResult GetDrugGeneric(int id)
        {
            var model = MasterDataService.GetDrugGeneric(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddDrugGeneric(DrugGeneric druggeneric)
        {
            MasterDataService.AddDrugGeneric(druggeneric);
            return Json(new { status = druggeneric.Id > 0 ? true : false, id = druggeneric.Id });
        }

        [HttpPost]
        public ActionResult EditDrugGeneric(DrugGeneric druggeneric)
        {
            var updated = MasterDataService.UpdateDrugGeneric(druggeneric);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteDrugGeneric(int id)
        {
            var deleted = MasterDataService.DeleteDrugGeneric(new DrugGeneric { Id = id });
            return Json(new { status = deleted });
        }

        // PurchaseRequestDetails
        [HttpPost]
        public ActionResult GetAllPurchaseRequestDetails()
        {
            var purchaserequests = MasterDataService.GetPurchaseRequestDetails();
            return Json(purchaserequests);
        }

        [HttpPost]
        public ActionResult GetPurchaseRequestDetail(int id)
        {
            var model = MasterDataService.GetPurchaseRequestDetail(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddPurchaseRequestDetails(PurchaseRequestDetails purchaserequest)
        {
            MasterDataService.AddPurchaseRequestDetails(purchaserequest);
            return Json(new { status = purchaserequest.RequestId > 0 ? true : false, id = purchaserequest.RequestId });
        }

        [HttpPost]
        public ActionResult EditPurchaseRequestDetails(PurchaseRequestDetails purchaserequest)
        {
            var updated = MasterDataService.UpdatePurchaseRequestDetails(purchaserequest);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeletePurchaseRequestDetails(int id)
        {
            var deleted = MasterDataService.DeletePurchaseRequestDetails(new PurchaseRequestDetails { RequestId = id });
            return Json(new { status = deleted });
        }

        [HttpPost]
        public ActionResult SearchProducts(ProductSearchDTO model)
        {
            User user = (User)Session["CurrentUser"];
            model.PharmacyId = user.PharmacyId;

            var records = MasterDataService.SearchProducts(model);
            return Json(new { data = records, total = model.TotalRecords });
        }

        // Role
        [HttpPost]
        public ActionResult GetAllRoles(int? pharmacyId)
        {
            if (!pharmacyId.HasValue)
            {
                User user = (User)Session["CurrentUser"];
                pharmacyId = user.PharmacyId;
            }

            var roles = PharmacyService.GetAllPharmacyRoles(pharmacyId.Value);
            return Json(roles);
        }

        [HttpPost]
        public ActionResult GetRole(int id)
        {
            var model = PharmacyService.GetPharmacyRoleDetail(id, ((User)Session["CurrentUser"]).PharmacyId);
            var viewModel = new RoleViewModel(model);
            return Json(new { Role = viewModel.Role, TreeData = viewModel.TreeData });
        }

        [HttpPost]
        public ActionResult SaveRole(RoleViewModel viewModel)
        {
            var role = viewModel.FormatRole(viewModel);
            var saved = false;

            if (role.Id == 0)
            {
                var loggedUser = ((User)Session["CurrentUser"]);
                role.PharmacyId = loggedUser.PharmacyId;
                role.AddedBy = loggedUser.PersonId;
                role.AddedDateTime = WebAppHelper.GetCurrentDateTime();
                PharmacyService.AddApplicationRole(role);
                if (role.Id > 0)
                {
                    saved = true;
                }
            }
            else
            {
                saved = PharmacyService.UpdateRoleDetail(role);
            }
            return Json(new { status = saved });
        }

        [HttpPost]
        public ActionResult DeleteRole(int id)
        {
            var deleted = MasterDataService.DeleteBank(new Bank { Id = id });
            return Json(new { status = deleted });
        }

        // Customer
        [HttpPost]
        public ActionResult GetAllCustomers()
        {
            var customers = MasterDataService.GetCustomers();
            return Json(customers);
        }
        [HttpPost]
        public ActionResult GetCustomer(int id)
        {
            var model = MasterDataService.GetCustomer(id);
            return Json(model);
        }

        [HttpPost]
        public ActionResult AddCustomer(Customer customer)
        {
            MasterDataService.AddCustomer(customer);
            return Json(new { status = customer.Id > 0 ? true : false, id = customer.Id });
        }

        [HttpPost]
        public ActionResult EditCustomer(Customer customer)
        {
            var updated = MasterDataService.UpdateCustomer(customer);
            return Json(new { status = updated });
        }

        [HttpPost]
        public ActionResult DeleteCustomer(int id)
        {
            var deleted = MasterDataService.DeleteCustomer(new Customer { Id = id });
            return Json(new { status = deleted });
        }
    }
}