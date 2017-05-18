using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IMasterDataService
    {
        List<MenuItem> GetAllActiveMenuItems();
        List<Pharmacy> GetAllPharmacyDetails();

        List<DrugUnit> GetDrugUnits();
        void AddDrugUnit(DrugUnit model);
        bool UpdateDrugUnit(DrugUnit model);
        bool DeleteDrugUnit(DrugUnit model); 
        DrugUnit GetDrugUnit(int id);

        List<Manufacturer> GetManufacturers();
        void AddManufacturer(Manufacturer model);
        bool UpdateManufacturer(Manufacturer model);
        bool DeleteManufacturer(Manufacturer model);
        Manufacturer GetManufacturer(int id);

        List<DrugCategory> GetDrugCategories();
        void AddDrugCategory(DrugCategory model);
        bool UpdateDrugCategory(DrugCategory model);
        bool DeleteDrugCategory(DrugCategory model);
        DrugCategory GetDrugCategory(int id);

        List<DrugContent> GetDrugContents();
        void AddDrugContent(DrugContent model);
        bool UpdateDrugContent(DrugContent model);
        bool DeleteDrugContent(DrugContent model);
        DrugContent GetDrugContent(int id);

        List<DrugType> GetDrugTypes();
        void AddDrugType(DrugType model);
        bool UpdateDrugType(DrugType model);
        bool DeleteDrugType(DrugType model);
        DrugType GetDrugType(int id);

        List<Department> GetDepartments();
        void AddDepartment(Department model);
        bool UpdateDepartment(Department model);
        bool DeleteDepartment(Department model);
        Department GetDepartment(int id);

        List<Consultant> GetConsultants();
        void AddConsultant(Consultant model);
        bool UpdateConsultant(Consultant model);
        bool DeleteConsultant(Consultant model);
        Consultant GetConsultant(int id);

        List<Rack> GetRacks();
        void AddRack(Rack model);
        bool UpdateRack(Rack model);
        bool DeleteRack(Rack model);
        Rack GetRack(int id);

        List<Tax> GetTaxs();
        void AddTax(Tax model);
        bool UpdateTax(Tax model);
        bool DeleteTax(Tax model);
        Tax GetTax(int id);

        List<Bank> GetBanks();
        void AddBank(Bank model);
        bool UpdateBank(Bank model);
        bool DeleteBank(Bank model);
        Bank GetBank(int id);

        List<Supplier> GetSuppliers();
        void AddSupplier(Supplier model);
        bool UpdateSupplier(Supplier model);
        bool DeleteSupplier(Supplier model);
        Supplier GetSupplier(int id);

        List<Patient> GetPatients();
        void AddPatient(Patient model);
        bool UpdatePatient(Patient model);
        bool DeletePatient(Patient model);
        Patient GetPatient(int id);

        List<Product> GetProducts();
        void AddProduct(Product model);
        bool UpdateProduct(Product model);
        bool DeleteProduct(Product model);
        Product GetProduct(int id);
        List<Product> GetProductsForBill(string ph);
        List<Product> GetProductsForUsage(string ph,string category);
        List<Product> SearchProducts(ProductSearchDTO searchDto);

        List<CreditAuth> GetCreditAuths();
        void AddCreditAuth(CreditAuth model);
        bool UpdateCreditAuth(CreditAuth model);
        bool DeleteCreditAuth(CreditAuth model);
        CreditAuth GetCreditAuth(int id);

        List<DrugGeneric> GetDrugGenerics();
        void AddDrugGeneric(DrugGeneric model);
        bool UpdateDrugGeneric(DrugGeneric model);
        bool DeleteDrugGeneric(DrugGeneric model);
        DrugGeneric GetDrugGeneric(int id);

        List<PurchaseRequestDetails> GetPurchaseRequestDetails();
        void AddPurchaseRequestDetails(PurchaseRequestDetails model);
        bool UpdatePurchaseRequestDetails(PurchaseRequestDetails model);
        bool DeletePurchaseRequestDetails(PurchaseRequestDetails model);
        PurchaseRequestDetails GetPurchaseRequestDetail(int id);

        List<Customer> GetCustomers();
        void AddCustomer(Customer model);
        bool UpdateCustomer(Customer model);
        bool DeleteCustomer(Customer model);
        Customer GetCustomer(int id);

    }

}
