using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IMasterDataRepository : IRepository<DrugUnit>
                                           , IRepository<Manufacturer>
                                           , IRepository<DrugCategory>
                                           , IRepository<DrugContent>
                                           , IRepository<DrugType>
                                           , IRepository<Department>
                                           , IRepository<Rack>
                                           , IRepository<Tax>
                                           , IRepository<Bank>
                                           , IRepository<Supplier>
                                           , IRepository<Product>
                                           , IRepository<CreditAuth>
                                           , IRepository<DrugGeneric>
                                           , IRepository<PurchaseRequestDetails>
                                           , IRepository<Consultant>
                                           , IRepository<Patient>
                                           , IRepository<Customer>
                                                            
    {

        List<MenuItem> GetAllActiveMenuItems();

        List<Pharmacy> GetAllPharmacyDetails();

        List<Product> SearchProducts(ProductSearchDTO searchDto);
    }

}
