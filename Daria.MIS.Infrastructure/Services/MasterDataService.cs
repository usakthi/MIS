using Daria.MIS.Core.CrossCutting;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using Daria.MIS.Core.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Infrastructure.Services
{
    public class MasterDataService : IMasterDataService
    {

        private readonly IMasterDataRepository repository;
        private readonly ICacheStorage store;


        public MasterDataService(IMasterDataRepository _metaDataRepository, ICacheStorage _store)
        {
            repository = _metaDataRepository;
            store = _store;
        }

        public List<MenuItem> GetAllActiveMenuItems()
        {
            List<MenuItem> menuList = store.Retrieve<List<MenuItem>>("ApplicationActiveMenuList");

            if (menuList != null)
            {
                return menuList;
            }
            else
            {
                menuList = repository.GetAllActiveMenuItems();
                store.Add("ApplicationActiveMenuList", menuList);
                
            }
            return menuList;
        }


        public List<Pharmacy> GetAllPharmacyDetails()
        {
            List<Pharmacy> cachedList = store.Retrieve<List<Pharmacy>>("PharmacyList");

            if (cachedList != null)
            {
                return cachedList;
            }
            else
            {
                cachedList = repository.GetAllPharmacyDetails();
                store.Add("PharmacyList", cachedList);

            }
            return cachedList;
        }

        // DrugUnit
        public List<DrugUnit> GetDrugUnits()
        {
            List<DrugUnit> cachedList = store.Retrieve<List<DrugUnit>>("DrugUnitList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<DrugUnit>)repository).SelectAll().ToList();
                store.Add("DrugUnitList", cachedList);

            //}
            return cachedList;
        }

        public void AddDrugUnit(DrugUnit model)
        {
            ((IRepository<DrugUnit>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("DrugUnitList");
            }
        }

        public DrugUnit GetDrugUnit(int id)
        {
            return ((IRepository<DrugUnit>)repository).Find(id);     
        }

        public bool UpdateDrugUnit(DrugUnit model)
        {
            var updated= ((IRepository<DrugUnit>)repository).Update(model);
            if (updated) { store.Remove("DrugUnitList"); }            
            return updated;
        }

        public bool DeleteDrugUnit(DrugUnit model)
        {
            var deleted = ((IRepository<DrugUnit>)repository).Delete(model);
            if (deleted) { store.Remove("DrugUnitList"); }
            return deleted;
        }

        // Manufacturer
        public List<Manufacturer> GetManufacturers()
        {
            List<Manufacturer> cachedList = store.Retrieve<List<Manufacturer>>("ManufacturerList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Manufacturer>)repository).SelectAll().ToList();
                store.Add("ManufacturerList", cachedList);

            //}
            return cachedList;
        }

        public void AddManufacturer(Manufacturer model)
        {
            ((IRepository<Manufacturer>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("ManufacturerList");
            }
        }

        public Manufacturer GetManufacturer(int id)
        {
            return ((IRepository<Manufacturer>)repository).Find(id);
        }

        public bool UpdateManufacturer(Manufacturer model)
        {
            var updated = ((IRepository<Manufacturer>)repository).Update(model);
            if (updated) { store.Remove("ManufacturerList"); }
            return updated;
        }

        public bool DeleteManufacturer(Manufacturer model)
        {
            var deleted = ((IRepository<Manufacturer>)repository).Delete(model);
            if (deleted) { store.Remove("ManufacturerList"); }
            return deleted;
        }

        // DrugCategory
        public List<DrugCategory> GetDrugCategories()
        {
            List<DrugCategory> cachedList = store.Retrieve<List<DrugCategory>>("DrugCategoryList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<DrugCategory>)repository).SelectAll().ToList();
                store.Add("DrugCategoryList", cachedList);

            //}
            return cachedList;
        }

        public void AddDrugCategory(DrugCategory model)
        {
            ((IRepository<DrugCategory>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("DrugCategoryList");
            }
        }

        public DrugCategory GetDrugCategory(int id)
        {
            return ((IRepository<DrugCategory>)repository).Find(id);
        }

        public bool UpdateDrugCategory(DrugCategory model)
        {
            var updated = ((IRepository<DrugCategory>)repository).Update(model);
            if (updated) { store.Remove("DrugCategoryList"); }
            return updated;
        }

        public bool DeleteDrugCategory(DrugCategory model)
        {
            var deleted = ((IRepository<DrugCategory>)repository).Delete(model);
            if (deleted) { store.Remove("DrugCategoryList"); }
            return deleted;
        }

        // DrugContent
        public List<DrugContent> GetDrugContents()
        {
            List<DrugContent> cachedList = store.Retrieve<List<DrugContent>>("DrugContentList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<DrugContent>)repository).SelectAll().ToList();
                store.Add("DrugContentList", cachedList);

            //}
            return cachedList;
        }

        public void AddDrugContent(DrugContent model)
        {
            ((IRepository<DrugContent>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("DrugContentList");
            }
        }

        public DrugContent GetDrugContent(int id)
        {
            return ((IRepository<DrugContent>)repository).Find(id);
        }

        public bool UpdateDrugContent(DrugContent model)
        {
            var updated = ((IRepository<DrugContent>)repository).Update(model);
            if (updated) { store.Remove("DrugContentList"); }
            return updated;
        }

        public bool DeleteDrugContent(DrugContent model)
        {
            var deleted = ((IRepository<DrugContent>)repository).Delete(model);
            if (deleted) { store.Remove("DrugContentList"); }
            return deleted;
        }

        // DrugType
        public List<DrugType> GetDrugTypes()
        {
            List<DrugType> cachedList = store.Retrieve<List<DrugType>>("DrugTypeList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<DrugType>)repository).SelectAll().ToList();
                store.Add("DrugTypeList", cachedList);

            //}
            return cachedList;
        }

        public void AddDrugType(DrugType model)
        {
            ((IRepository<DrugType>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("DrugTypeList");
            }
        }

        public DrugType GetDrugType(int id)
        {
            return ((IRepository<DrugType>)repository).Find(id);
        }

        public bool UpdateDrugType(DrugType model)
        {
            var updated = ((IRepository<DrugType>)repository).Update(model);
            if (updated) { store.Remove("DrugTypeList"); }
            return updated;
        }

        public bool DeleteDrugType(DrugType model)
        {
            var deleted = ((IRepository<DrugType>)repository).Delete(model);
            if (deleted) { store.Remove("DrugTypeList"); }
            return deleted;
        }

        // Department
        public List<Department> GetDepartments()
        {
            List<Department> cachedList = store.Retrieve<List<Department>>("DepartmentList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Department>)repository).SelectAll().ToList();
                store.Add("DepartmentList", cachedList);

            //}
            return cachedList;
        }

        public void AddDepartment(Department model)
        {
            ((IRepository<Department>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("DepartmentList");
            }
        }

        public Department GetDepartment(int id)
        {
            return ((IRepository<Department>)repository).Find(id);
        }

        public bool UpdateDepartment(Department model)
        {
            var updated = ((IRepository<Department>)repository).Update(model);
            if (updated) { store.Remove("DepartmentList"); }
            return updated;
        }

        public bool DeleteDepartment(Department model)
        {
            var deleted = ((IRepository<Department>)repository).Delete(model);
            if (deleted) { store.Remove("DepartmentList"); }
            return deleted;
        }

        // Consultant
        public List<Consultant> GetConsultants()
        {
            List<Consultant> cachedList = store.Retrieve<List<Consultant>>("ConsultantList");

                cachedList = ((IRepository<Consultant>)repository).SelectAll().ToList();
                store.Add("ConsultantList", cachedList);

            return cachedList;
        }

        public void AddConsultant(Consultant model)
        {
            ((IRepository<Consultant>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("ConsultantList");
            }
        }

        public Consultant GetConsultant(int id)
        {
            return ((IRepository<Consultant>)repository).Find(id);
        }

        public bool UpdateConsultant(Consultant model)
        {
            var updated = ((IRepository<Consultant>)repository).Update(model);
            if (updated) { store.Remove("ConsultantList"); }
            return updated;
        }

        public bool DeleteConsultant(Consultant model)
        {
            var deleted = ((IRepository<Consultant>)repository).Delete(model);
            if (deleted) { store.Remove("ConsultantList"); }
            return deleted;
        }

        // Rack
        public List<Rack> GetRacks()
        {
            List<Rack> cachedList = store.Retrieve<List<Rack>>("RackList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Rack>)repository).SelectAll().ToList();
                store.Add("RackList", cachedList);

            //}
            return cachedList;
        }

        public void AddRack(Rack model)
        {
            ((IRepository<Rack>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("RackList");
            }
        }

        public Rack GetRack(int id)
        {
            return ((IRepository<Rack>)repository).Find(id);
        }

        public bool UpdateRack(Rack model)
        {
            var updated = ((IRepository<Rack>)repository).Update(model);
            if (updated) { store.Remove("RackList"); }
            return updated;
        }

        public bool DeleteRack(Rack model)
        {
            var deleted = ((IRepository<Rack>)repository).Delete(model);
            if (deleted) { store.Remove("RackList"); }
            return deleted;
        }

        // Tax
        public List<Tax> GetTaxs()
        {
            List<Tax> cachedList = store.Retrieve<List<Tax>>("TaxList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Tax>)repository).SelectAll().ToList();
                store.Add("TaxList", cachedList);

            //}
            return cachedList;
        }

        public void AddTax(Tax model)
        {
            ((IRepository<Tax>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("TaxList");
            }
        }

        public Tax GetTax(int id)
        {
            return ((IRepository<Tax>)repository).Find(id);
        }

        public bool UpdateTax(Tax model)
        {
            var updated = ((IRepository<Tax>)repository).Update(model);
            if (updated) { store.Remove("TaxList"); }
            return updated;
        }

        public bool DeleteTax(Tax model)
        {
            var deleted = ((IRepository<Tax>)repository).Delete(model);
            if (deleted) { store.Remove("TaxList"); }
            return deleted;
        }

        // Bank
        public List<Bank> GetBanks()
        {
            List<Bank> cachedList = store.Retrieve<List<Bank>>("BankList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Bank>)repository).SelectAll().ToList();
                store.Add("BankList", cachedList);

            //}
            return cachedList;
        }

        public void AddBank(Bank model)
        {
            ((IRepository<Bank>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("BankList");
            }
        }

        public Bank GetBank(int id)
        {
            return ((IRepository<Bank>)repository).Find(id);
        }

        public bool UpdateBank(Bank model)
        {
            var updated = ((IRepository<Bank>)repository).Update(model);
            if (updated) { store.Remove("BankList"); }
            return updated;
        }

        public bool DeleteBank(Bank model)
        {
            var deleted = ((IRepository<Bank>)repository).Delete(model);
            if (deleted) { store.Remove("BankList"); }
            return deleted;
        }

        // Supplier
        public List<Supplier> GetSuppliers()
        {
            List<Supplier> cachedList = store.Retrieve<List<Supplier>>("SupplierList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Supplier>)repository).SelectAll().ToList();
                store.Add("SupplierList", cachedList);

            //}
            return cachedList;
        }

        public void AddSupplier(Supplier model)
        {
            ((IRepository<Supplier>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("SupplierList");
            }
        }

        public Supplier GetSupplier(int id)
        {
            return ((IRepository<Supplier>)repository).Find(id);
        }

        public bool UpdateSupplier(Supplier model)
        {
            var updated = ((IRepository<Supplier>)repository).Update(model);
            if (updated) { store.Remove("SupplierList"); }
            return updated;
        }

        public bool DeleteSupplier(Supplier model)
        {
            var deleted = ((IRepository<Supplier>)repository).Delete(model);
            if (deleted) { store.Remove("SupplierList"); }
            return deleted;
        }

        // Patient List
        public List<Patient> GetPatients()
        {
            List<Patient> cachedList = store.Retrieve<List<Patient>>("Patient");

            cachedList = ((IRepository<Patient>)repository).SelectAll().ToList();
            store.Add("PatientList", cachedList);

            return cachedList;
        }

        public void AddPatient(Patient model)
        {
            ((IRepository<Patient>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("PatientList");
            }
        }

        public Patient GetPatient(int id)
        {
            return ((IRepository<Patient>)repository).Find(id);
        }

        public bool UpdatePatient(Patient model)
        {
            var updated = ((IRepository<Patient>)repository).Update(model);
            if (updated) { store.Remove("PatientList"); }
            return updated;
        }

        public bool DeletePatient(Patient model)
        {
            var deleted = ((IRepository<Patient>)repository).Delete(model);
            if (deleted) { store.Remove("PatientList"); }
            return deleted;
        }

        // Product

        public List<Product> GetProducts()
        {
            List<Product> cachedList = store.Retrieve<List<Product>>("ProductList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<Product>)repository).SelectAll().ToList();
                store.Add("ProductList", cachedList);

            //}
            return cachedList;
        }

        // Product For Bill & Indents
        public List<Product> GetProductsForBill(string ph)
        {
            List<Product> cachedList = store.Retrieve<List<Product>>("ProductList");

            cachedList = ((IRepository<Product>)repository).SelectAll(ph).ToList();
            store.Add("ProductList", cachedList);

            return cachedList;
        }

        public List<Product> GetProductsForUsage(string ph,string category)
        {
            List<Product> cachedList = store.Retrieve<List<Product>>("ProductList");

            cachedList = ((IRepository<Product>)repository).SelectAll(ph,category).ToList();
            store.Add("ProductList", cachedList);

            return cachedList;
        }

        public void AddProduct(Product model)
        {
            ((IRepository<Product>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("ProductList");
            }
        }

        public Product GetProduct(int id)
        {
            return ((IRepository<Product>)repository).Find(id);
        }
        public bool UpdateProduct(Product model)
        {
            var updated = ((IRepository<Product>)repository).Update(model);
            if (updated) { store.Remove("ProductList"); }
            return updated;
        }

        public bool DeleteProduct(Product model)
        {
            var deleted = ((IRepository<Product>)repository).Delete(model);
            if (deleted) { store.Remove("ProductList"); }
            return deleted;
        }


        //CreditAuth
        public List<CreditAuth> GetCreditAuths()
        {
            List<CreditAuth> cachedList = store.Retrieve<List<CreditAuth>>("CreditAuthList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<CreditAuth>)repository).SelectAll().ToList();
                store.Add("CreditAuthList", cachedList);

            //}
            return cachedList;
        }

        public void AddCreditAuth(CreditAuth model)
        {
            ((IRepository<CreditAuth>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("CreditAuthList");
            }
        }

        public CreditAuth GetCreditAuth(int id)
        {
            return ((IRepository<CreditAuth>)repository).Find(id);
        }

        public bool UpdateCreditAuth(CreditAuth model)
        {
            var updated = ((IRepository<CreditAuth>)repository).Update(model);
            if (updated) { store.Remove("CreditAuthList"); }
            return updated;
        }

        public bool DeleteCreditAuth(CreditAuth model)
        {
            var deleted = ((IRepository<CreditAuth>)repository).Delete(model);
            if (deleted) { store.Remove("CreditAuthList"); }
            return deleted;
        }

        // DrugGeneric
        public List<DrugGeneric> GetDrugGenerics()
        {
            List<DrugGeneric> cachedList = store.Retrieve<List<DrugGeneric>>("DrugGenericList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<DrugGeneric>)repository).SelectAll().ToList();
                store.Add("DrugGenericList", cachedList);

            //}
            return cachedList;
        }

        public void AddDrugGeneric(DrugGeneric model)
        {
            ((IRepository<DrugGeneric>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("DrugGenericList");
            }
        }

        public DrugGeneric GetDrugGeneric(int id)
        {
            return ((IRepository<DrugGeneric>)repository).Find(id);
        }

        public bool UpdateDrugGeneric(DrugGeneric model)
        {
            var updated = ((IRepository<DrugGeneric>)repository).Update(model);
            if (updated) { store.Remove("DrugGenericList"); }
            return updated;
        }

        public bool DeleteDrugGeneric(DrugGeneric model)
        {
            var deleted = ((IRepository<DrugGeneric>)repository).Delete(model);
            if (deleted) { store.Remove("DrugGenericList"); }
            return deleted;
        }

        // PurchaseRequestDetails
        public List<PurchaseRequestDetails> GetPurchaseRequestDetails()
        {
            List<PurchaseRequestDetails> cachedList = store.Retrieve<List<PurchaseRequestDetails>>("PurchaseRequestDetailsList");

            //if (cachedList != null)
            //{
            //    return cachedList;
            //}
            //else
            //{
                cachedList = ((IRepository<PurchaseRequestDetails>)repository).SelectAll().ToList();
                store.Add("PurchaseRequestDetailsList", cachedList);

            //}
            return cachedList;
        }

        public void AddPurchaseRequestDetails(PurchaseRequestDetails model)
        {
            ((IRepository<PurchaseRequestDetails>)repository).Insert(model);
            if (model.RequestId > 0)
            {
                store.Remove("PurchaseRequestDetailsList");
            }
        }

        public PurchaseRequestDetails GetPurchaseRequestDetail(int id)
        {
            return ((IRepository<PurchaseRequestDetails>)repository).Find(id);
        }
        public bool UpdatePurchaseRequestDetails(PurchaseRequestDetails model)
        {
            var updated = ((IRepository<PurchaseRequestDetails>)repository).Update(model);
            if (updated) { store.Remove("PurchaseRequestDetailsList"); }
            return updated;
        }

        public bool DeletePurchaseRequestDetails(PurchaseRequestDetails model)
        {
            var deleted = ((IRepository<PurchaseRequestDetails>)repository).Delete(model);
            if (deleted) { store.Remove("PurchaseRequestDetailsList"); }
            return deleted;
        }

        public List<Product> SearchProducts(ProductSearchDTO searchDto)
        {
            return repository.SearchProducts(searchDto);
        }

        // Customer
        public List<Customer> GetCustomers()
        {
            List<Customer> cachedList = store.Retrieve<List<Customer>>("CustomerList");

            cachedList = ((IRepository<Customer>)repository).SelectAll().ToList();
            store.Add("CustomerList", cachedList);

            return cachedList;
        }

        public void AddCustomer(Customer model)
        {
            ((IRepository<Customer>)repository).Insert(model);
            if (model.Id > 0)
            {
                store.Remove("CustomerList");
            }
        }

        public Customer GetCustomer(int id)
        {
            return ((IRepository<Customer>)repository).Find(id);
        }

        public bool UpdateCustomer(Customer model)
        {
            var updated = ((IRepository<Customer>)repository).Update(model);
            if (updated) { store.Remove("CustomerList"); }
            return updated;
        }

        public bool DeleteCustomer(Customer model)
        {
            var deleted = ((IRepository<Customer>)repository).Delete(model);
            if (deleted) { store.Remove("CustomerList"); }
            return deleted;
        }
    }

}
