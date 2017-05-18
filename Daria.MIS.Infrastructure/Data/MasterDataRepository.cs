using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using System.Data;

namespace Daria.MIS.Infrastructure.Data
{
    public class MasterDataRepository : IMasterDataRepository
    {
        private IDbConnection _dbConn;

        public List<MenuItem> GetAllActiveMenuItems()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<MenuItem>("GetAllActiveMenuItems",
                               new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<Pharmacy> GetAllPharmacyDetails()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Pharmacy>("GetAllPharmacyDetails",
                               new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        #region DrugUnit
        DrugUnit IRepository<DrugUnit>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        DrugUnit IRepository<DrugUnit>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugUnit>("GetDrugUnit", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<DrugUnit>.Insert(DrugUnit model)
        {
            //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddDrugUnit",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<DrugUnit>.Delete(DrugUnit model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteDrugUnit", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<DrugUnit>.Update(DrugUnit model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateDrugUnit", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<DrugUnit> IRepository<DrugUnit>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugUnit>("GetDrugUnits",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<DrugUnit> IRepository<DrugUnit>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        #endregion
        #region  Manufacturer

        Manufacturer IRepository<Manufacturer>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Manufacturer IRepository<Manufacturer>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Manufacturer>("GetManufacturer", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Manufacturer>.Insert(Manufacturer model)
        {
            //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddManufacturer",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Manufacturer>.Delete(Manufacturer model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteManufacturer", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Manufacturer>.Update(Manufacturer model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateManufacturer", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Manufacturer> IRepository<Manufacturer>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Manufacturer>("GetManufacturers",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<Manufacturer> IRepository<Manufacturer>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }

        #endregion
        #region DrugCategory
        DrugCategory IRepository<DrugCategory>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        DrugCategory IRepository<DrugCategory>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugCategory>("GetDrugCategory", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<DrugCategory>.Insert(DrugCategory model)
        {
            //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddDrugCategory",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<DrugCategory>.Delete(DrugCategory model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteDrugCategory", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<DrugCategory>.Update(DrugCategory model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateDrugCategory", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<DrugCategory> IRepository<DrugCategory>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugCategory>("GetDrugCategories",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<DrugCategory> IRepository<DrugCategory>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        #endregion
        #region DrugContent
        DrugContent IRepository<DrugContent>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        DrugContent IRepository<DrugContent>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugContent>("GetDrugContent", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<DrugContent>.Insert(DrugContent model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddDrugContent",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<DrugContent>.Delete(DrugContent model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteDrugContent", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<DrugContent>.Update(DrugContent model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateDrugContent", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<DrugContent> IRepository<DrugContent>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugContent>("GetDrugContents",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<DrugContent> IRepository<DrugContent>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        #endregion
        #region DrugType
        DrugType IRepository<DrugType>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        DrugType IRepository<DrugType>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugType>("GetDrugType", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<DrugType>.Insert(DrugType model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
                model.Id = _dbConn.Query<int>("AddDrugType",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<DrugType>.Delete(DrugType model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteDrugType", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<DrugType>.Update(DrugType model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateDrugType", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<DrugType> IRepository<DrugType>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugType>("GetDrugTypes",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<DrugType> IRepository<DrugType>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        #endregion
        // Department 
        Department IRepository<Department>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Department IRepository<Department>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Department>("GetDepartment", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Department>.Insert(Department model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
                model.Id = _dbConn.Query<int>("AddDepartment",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Department>.Delete(Department model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteDepartment", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Department>.Update(Department model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateDepartment", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Department> IRepository<Department>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Department>("GetDepartments",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<Department> IRepository<Department>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }

        // Consultant 
        Consultant IRepository<Consultant>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Consultant IRepository<Consultant>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Consultant>("GetConsultant", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Consultant>.Insert(Consultant model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
                model.Id = _dbConn.Query<int>("AddConsultant",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Consultant>.Delete(Consultant model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteConsultant", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Consultant>.Update(Consultant model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateConsultant", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Consultant> IRepository<Consultant>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Consultant>("GetConsultants",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<Consultant> IRepository<Consultant>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        // Rack 
        Rack IRepository<Rack>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Rack IRepository<Rack>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Rack>("GetRack", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Rack>.Insert(Rack model)
        {
            //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddRack",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Rack>.Delete(Rack model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteRack", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Rack>.Update(Rack model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateRack", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Rack> IRepository<Rack>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Rack>("GetRacks",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<Rack> IRepository<Rack>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        // Tax 
        Tax IRepository<Tax>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Tax IRepository<Tax>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Tax>("GetTax", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Tax>.Insert(Tax model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
                model.Id = _dbConn.Query<int>("AddTax",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Tax>.Delete(Tax model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteTax", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Tax>.Update(Tax model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateTax", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Tax> IRepository<Tax>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Tax>("GetTaxs",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<Tax> IRepository<Tax>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        // Bank 
        Bank IRepository<Bank>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Bank IRepository<Bank>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Bank>("GetBank", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Bank>.Insert(Bank model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddBank",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Bank>.Delete(Bank model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteBank", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Bank>.Update(Bank model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateBank", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Bank> IRepository<Bank>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Bank>("GetBanks",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<Bank> IRepository<Bank>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        // Supplier 
        Supplier IRepository<Supplier>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Supplier IRepository<Supplier>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Supplier>("GetSupplier", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Supplier>.Insert(Supplier model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddSupplier",
                              new
                              {
                                  Name = model.Name,
                                  TypeId = model.TypeId,
                                  Address = model.Address,
                                  TinNo = model.TinNo,
                                  City = model.City,
                                  State = model.State,
                                  Country = model.Country,
                                  ContactPerson = model.ContactPerson,
                                  Email = model.Email,
                                  Phone = model.Phone,
                                  Fax = model.Fax,
                                  Pincode = model.Pincode,
                                  MobileNo = model.MobileNo,
                                  IsActive = model.isActive
                              },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Supplier>.Delete(Supplier model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteSupplier", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Supplier>.Update(Supplier model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@TypeId", model.TypeId);
                p.Add("@Address", model.Address);
                p.Add("@TinNo", model.TinNo);
                p.Add("@City", model.City);
                p.Add("@State", model.State);
                p.Add("@Country", model.Country);
                p.Add("@ContactPerson", model.ContactPerson);
                p.Add("@Email", model.Email);
                p.Add("@Phone", model.Phone);
                p.Add("@Fax", model.Fax);
                p.Add("@Pincode", model.Pincode);
                p.Add("@MobileNo", model.MobileNo);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateSupplier", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Supplier> IRepository<Supplier>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Supplier>("GetSuppliers",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<Supplier> IRepository<Supplier>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }

        // Patient 
        Patient IRepository<Patient>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Patient IRepository<Patient>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Patient>("GetPatient", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Patient>.Insert(Patient model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddPatient",
                              new
                              {
                                  Name = model.Name,
                                  TypeId = model.TypeId,
                                  Address = model.Address,
                                  TinNo = model.TinNo,
                                  City = model.City,
                                  State = model.State,
                                  Country = model.Country,
                                  ContactPerson = model.ContactPerson,
                                  Email = model.Email,
                                  Phone = model.Phone,
                                  Fax = model.Fax,
                                  Pincode = model.Pincode,
                                  MobileNo = model.MobileNo,
                                  IsActive = model.isActive
                              },
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Patient>.Delete(Patient model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeletePatient", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Patient>.Update(Patient model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@TypeId", model.TypeId);
                p.Add("@Address", model.Address);
                p.Add("@TinNo", model.TinNo);
                p.Add("@City", model.City);
                p.Add("@State", model.State);
                p.Add("@Country", model.Country);
                p.Add("@ContactPerson", model.ContactPerson);
                p.Add("@Email", model.Email);
                p.Add("@Phone", model.Phone);
                p.Add("@Fax", model.Fax);
                p.Add("@Pincode", model.Pincode);
                p.Add("@MobileNo", model.MobileNo);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdatePatient", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Patient> IRepository<Patient>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Patient>("GetPatients",new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<Patient> IRepository<Patient>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }

        // Product 

        Product IRepository<Product>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }
        Product IRepository<Product>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Product>("GetProduct", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }
        void IRepository<Product>.Insert(Product model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddProduct",
                              new
                              {
                                  Classification = model.Classification,
                                  Name = model.Name,
                                  TypeId = model.TypeId,
                                  CategoryId = model.CategoryId,
                                  MainCategoryId = model.MainCategoryId,
                                  GenericId = model.GenericId,
                                  ManfId = model.ManfId,
                                  UnitId = model.UnitId,
                                  RackId = model.RackId,
                                  TaxId = model.TaxId,
                                  MinStock = model.MinStock,
                                  MaxStock = model.MaxStock,
                                  ExpiryNotifyinDays = model.ExpiryNotifyinDays,
                                  ExpiryDays = model.ExpiryDays,
                                  SuppTakenBeforExpiryDays = model.SuppTakenBeforExpiryDays,
                                  TakenBeforeDays = model.TakenBeforeDays,
                                  SuppTakenAfterExpiryDays = model.SuppTakenAfterExpiryDays,
                                  TakenAfterDays = model.TakenAfterDays,
                                  IsActive = model.isActive
                              },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Product>.Delete(Product model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteProduct", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Product>.Update(Product model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Classification", model.Classification);
                p.Add("@Name", model.Name);
                p.Add("@TypeId", model.TypeId);
                p.Add("@CategoryId", model.CategoryId);
                p.Add("@MainCategoryId", model.MainCategoryId);
                p.Add("@GenericId", model.GenericId);
                p.Add("@ManfId", model.ManfId);
                p.Add("@UnitId", model.UnitId);
                p.Add("@RackId", model.RackId);
                p.Add("@TaxId", model.TaxId);
                p.Add("@MinStock", model.MinStock);
                p.Add("@MaxStock", model.MaxStock);
                p.Add("@ExpiryNotifyinDays", model.ExpiryNotifyinDays);
                p.Add("@ExpiryDays", model.ExpiryDays);
                p.Add("@SuppTakenBeforExpiryDays", model.SuppTakenBeforExpiryDays);
                p.Add("@TakenBeforeDays", model.TakenBeforeDays);
                p.Add("@SuppTakenAfterExpiryDays", model.SuppTakenAfterExpiryDays);
                p.Add("@TakenAfterDays", model.TakenAfterDays);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateProduct", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }
        IEnumerable<Product> IRepository<Product>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Product> IRepository<Product>.SelectAll(string ph, string category)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var resultSet = _dbConn.QueryMultiple("GetProductsforUsage", new { ph = ph, category = "D" }, commandType: CommandType.StoredProcedure);
                List<Product> productList = new List<Product>();
                var products = resultSet.Read();

                foreach (dynamic p in products)
                {
                    Product prod = new Product();
                    prod.SlNo = p.SNo;
                    prod.Id = p.Id;
                    
                    prod.Name = p.DrugName;
                    prod.DrugCategory = new DrugCategory { Name = p.Category };
                    prod.Stock = p.Stock;
                    prod.BatchNo = p.BatchNo;
                    prod.GRNNo = p.BillNo;
                    prod.GRNDate = p.BillDate;
                    prod.ExpDate = p.ExpiryDate;
                    prod.PurDetId = p.bdcode;

                    prod.Manufacturer = new Manufacturer { Name = p.Manufacture, Id = p.ManufactureId };
                    prod.MRP = p.MRP;
                    prod.VAT = p.VAT;
                    prod.BillCode = p.BillCode;
                    prod.Discount = p.Discount;

                    productList.Add(prod);
                }

                return productList;
            }
        }

        //Product prod = new Product();
        //            prod.SlNo = p.Slno;
        //            prod.Id = p.Id;
        //            prod.Category = p.Classification;
        //            prod.Name = p.DrugName;
        //            prod.DrugType = new DrugType { Name = p.Type };
        //            prod.DrugCategory = new DrugCategory { Name = p.Category };

        //            prod.Stock = p.Stock;
        //            prod.BatchNo = p.BatchNo;
        //            prod.GRNNo = p.GRNNo;
        //            prod.GRNDate = p.GRNDate;
        //            prod.ExpDate = p.ExpiryDate;
        //            prod.PurDetId = p.PurDetId;

        //            prod.DrugContent = new DrugContent { Name = p.MainCategory };

        //            prod.DrugGeneric = new DrugGeneric { Name = p.Generic };
        //            prod.DrugUnit = new DrugUnit { Name = p.Unit, Id = p.UnitId };
        //            prod.Manufacturer = new Manufacturer { Name = p.Manufacture, Id = p.ManufactureId };
        //            prod.MinStock = p.MinStock;
        //            prod.MaxStock = p.MaxStock;
        //            prod.ExpiryNotifyinDays = p.ExpiryNotifyinDays;
        //            prod.ExpiryDays = p.ExpiryDays;
        //            prod.SuppTakenBeforExpiryDays = p.SuppTakenBeforExpiryDays;
        //            prod.TakenBeforeDays = p.TakenBeforeDays;
        //            prod.SuppTakenAfterExpiryDays = p.SuppTakenAfterExpiryDays;
        //            prod.TakenAfterDays = p.TakenAfterDays;
        //            prod.isActive = p.IsActive;

        //            prod.MRP = p.MRP;
        //            prod.CostPrice = p.CostPrice;
        //            prod.VAT = p.VAT;

        IEnumerable<Product> IRepository<Product>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var resultSet = _dbConn.QueryMultiple("GetProducts", new { }, commandType: CommandType.StoredProcedure);
                List<Product> productList = new List<Product>();
                var products = resultSet.Read();

                foreach (dynamic p in products)
                {
                    Product prod = new Product();
                    prod.SlNo = p.Slno;
                    prod.Id = p.Id;
                    prod.Category = p.Classification;
                    prod.Name = p.DrugName;
                    prod.DrugType = new DrugType { Name = p.Type };
                    prod.DrugCategory = new DrugCategory { Name = p.Category };

                    prod.Stock = p.Stock;
                    prod.BatchNo = p.BatchNo;
                    prod.GRNNo = p.GRNNo;
                    prod.GRNDate = p.GRNDate;
                    prod.ExpDate = p.ExpiryDate;
                    prod.PurDetId = p.PurDetId;

                    prod.DrugContent = new DrugContent { Name = p.MainCategory };

                    prod.DrugGeneric = new DrugGeneric { Name = p.Generic };
                    prod.DrugUnit = new DrugUnit { Name = p.Unit, Id = p.UnitId };
                    prod.Manufacturer = new Manufacturer { Name = p.Manufacture, Id = p.ManufactureId };
                    prod.MinStock = p.MinStock;
                    prod.MaxStock = p.MaxStock;
                    prod.ExpiryNotifyinDays = p.ExpiryNotifyinDays;
                    prod.ExpiryDays = p.ExpiryDays;
                    prod.SuppTakenBeforExpiryDays = p.SuppTakenBeforExpiryDays;
                    prod.TakenBeforeDays = p.TakenBeforeDays;
                    prod.SuppTakenAfterExpiryDays = p.SuppTakenAfterExpiryDays;
                    prod.TakenAfterDays = p.TakenAfterDays;
                    prod.isActive = p.IsActive;

                    prod.MRP = p.MRP;
                    prod.CostPrice = p.CostPrice;
                    prod.VAT = p.VAT;

                    productList.Add(prod);
                }

                return productList;
            }

        }

        IEnumerable<Product> IRepository<Product>.SelectAll(string ph)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var resultSet = _dbConn.QueryMultiple("GetProductsforBill", new { ph = "bill" }, commandType: CommandType.StoredProcedure);
                List<Product> productList = new List<Product>();
                var products = resultSet.Read();

                foreach (dynamic p in products)
                {
                    Product prod = new Product();
                    prod.SlNo = p.Slno;
                    prod.Id = p.Id;
                    prod.Category = p.Classification;
                    prod.Name = p.DrugName;
                    prod.DrugType = new DrugType { Name = p.Type };
                    prod.DrugCategory = new DrugCategory { Name = p.Category };

                    prod.Stock = p.Stock;
                    prod.BatchNo = p.BatchNo;
                    prod.GRNNo = p.GRNNo;
                    prod.GRNDate = p.GRNDate;
                    prod.ExpDate = p.ExpiryDate;
                    prod.PurDetId = p.PurDetId;

                    prod.DrugContent = new DrugContent { Name = p.MainCategory };

                    prod.DrugGeneric = new DrugGeneric { Name = p.Generic };
                    prod.DrugUnit = new DrugUnit { Name = p.Unit, Id = p.UnitId };
                    prod.Manufacturer = new Manufacturer { Name = p.Manufacture, Id = p.ManufactureId };
                    prod.MinStock = p.MinStock;
                    prod.MaxStock = p.MaxStock;
                    prod.ExpiryNotifyinDays = p.ExpiryNotifyinDays;
                    prod.ExpiryDays = p.ExpiryDays;
                    prod.SuppTakenBeforExpiryDays = p.SuppTakenBeforExpiryDays;
                    prod.TakenBeforeDays = p.TakenBeforeDays;
                    prod.SuppTakenAfterExpiryDays = p.SuppTakenAfterExpiryDays;
                    prod.TakenAfterDays = p.TakenAfterDays;
                    prod.isActive = p.IsActive;

                    prod.MRP = p.MRP;
                    prod.CostPrice = p.CostPrice;
                    prod.VAT = p.VAT;

                    prod.Pur = p.Pur;
                    prod.PurRet = p.PurRet;
                    prod.Sal = p.Sal;
                    prod.SalRet = p.SalRet;
                    prod.OpenStk = p.OpenStk;
                    prod.CurStk = p.CurStk;
                    prod.StkAdj = p.StkAdj;
                    prod.PreMRP = p.PreMRP;

                    productList.Add(prod);
                }

                return productList;
            }
        }

        public List<Product> SearchProducts(ProductSearchDTO model)
        {
            List<Product> products = new List<Product>();
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@PharmacyId", model.PharmacyId);
                p.Add("@pageSize", model.PageSize);
                p.Add("@page", model.PageNo);
                p.Add("@OrderBy", model.OrderBy);
                p.Add("@DrugName", model.DrugName);
                p.Add("@Type", model.Type);
                
                p.Add("@totalRows", dbType: DbType.Int32, direction: ParameterDirection.Output);
                p.Add("@totalPages", dbType: DbType.Int32, direction: ParameterDirection.Output);
                var records = _dbConn.Query("SearchProducts", p, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in records)
                {
                    Product product = new Product();
                    product.Id = record.Id;
                    product.DrugName = record.DrugName;
                    product.Type = record.Type;
                    product.SlNo = record.RowNumber;
                    products.Add(product);
                }
                model.TotalRecords = p.Get<int?>("@totalRows").GetValueOrDefault();
                model.TotalPages = p.Get<int?>("@totalPages").GetValueOrDefault();
            }

            return products;
        }
        // CreditAuth 
        CreditAuth IRepository<CreditAuth>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        CreditAuth IRepository<CreditAuth>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<CreditAuth>("GetCreditAuth", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<CreditAuth>.Insert(CreditAuth model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
                model.Id = _dbConn.Query<int>("AddCreditAuth",
                              new
                              {
                                  AuthName = model.AuthName,
                                  DepName = model.DepName,
                                  DesigName = model.DesigName,
                                  FindBy = model.FindBy,
                                  IsActive = model.isActive
                              },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<CreditAuth>.Delete(CreditAuth model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteCreditAuth", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<CreditAuth>.Update(CreditAuth model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@AuthName", model.AuthName);
                p.Add("@DepName", model.DepName);
                p.Add("@DesigName", model.DesigName);
                p.Add("@FindBy", model.FindBy);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateCreditAuth", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<CreditAuth> IRepository<CreditAuth>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<CreditAuth>("GetCreditAuths",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<CreditAuth> IRepository<CreditAuth>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        // DrugGeneric
        DrugGeneric IRepository<DrugGeneric>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        DrugGeneric IRepository<DrugGeneric>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugGeneric>("GetDrugGeneric", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<DrugGeneric>.Insert(DrugGeneric model)
        {
            //prop name should match sp param name, ie. Name=. Here @Name is sp param name. If we use like Label=model.Name, it wont work
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddDrugGeneric",
                              new { Name = model.Name, Desc = model.Desc, IsActive = model.isActive },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<DrugGeneric>.Delete(DrugGeneric model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteDrugGeneric", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<DrugGeneric>.Update(DrugGeneric model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Desc", model.Desc);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateDrugGeneric", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<DrugGeneric> IRepository<DrugGeneric>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DrugGeneric>("GetDrugGenerics",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<DrugGeneric> IRepository<DrugGeneric>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        // PurchaseRequestDetails 
        PurchaseRequestDetails IRepository<PurchaseRequestDetails>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }
        PurchaseRequestDetails IRepository<PurchaseRequestDetails>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<PurchaseRequestDetails>("GetPurchaseRequestDetail", new { RequestId = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }
        void IRepository<PurchaseRequestDetails>.Insert(PurchaseRequestDetails model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.RequestId = _dbConn.Query<int>("AddPurchaseRequestDetails",
                              new
                              {
                                  RequestNo = model.RequestNo,
                                  RequestDate = model.RequestDate,
                                  ProductId = model.ProductId,
                                  Qty = model.Qty,
                                  CurrentStock = model.CurrentStock,
                                  ManfId = model.ManfId,
                                  AddedBy = model.AddedBy,
                                  Status = model.Status,
                                  IsActive = model.isActive
                              },//prop name should match sp param name
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<PurchaseRequestDetails>.Delete(PurchaseRequestDetails model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@RequestId", model.RequestId);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeletePurchaseRequestDetails", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<PurchaseRequestDetails>.Update(PurchaseRequestDetails model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@RequestNo", model.RequestNo);
                p.Add("@RequestDate", model.RequestDate);
                p.Add("@ProductId", model.ProductId);
                p.Add("@Qty", model.Qty);
                p.Add("@CurrentStock", model.CurrentStock);
                p.Add("@ManfId", model.ManfId);
                p.Add("@AddedBy", model.AddedBy);
                p.Add("@Status", model.Status);
                p.Add("@IsActive", model.isActive);
                p.Add("@RequestId", model.RequestId);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdatePurchaseRequestDetails", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<PurchaseRequestDetails> IRepository<PurchaseRequestDetails>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<PurchaseRequestDetails>("GetPurchaseRequestDetails",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        IEnumerable<PurchaseRequestDetails> IRepository<PurchaseRequestDetails>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }

        IEnumerable<PurchaseRequestDetails> IRepository<PurchaseRequestDetails>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<PurchaseRequestDetails> IRepository<PurchaseRequestDetails>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugGeneric> IRepository<DrugGeneric>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugGeneric> IRepository<DrugGeneric>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<CreditAuth> IRepository<CreditAuth>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<CreditAuth> IRepository<CreditAuth>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Supplier> IRepository<Supplier>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Supplier> IRepository<Supplier>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Bank> IRepository<Bank>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Bank> IRepository<Bank>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Tax> IRepository<Tax>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Tax> IRepository<Tax>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Rack> IRepository<Rack>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Rack> IRepository<Rack>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Department> IRepository<Department>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Department> IRepository<Department>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Manufacturer> IRepository<Manufacturer>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Manufacturer> IRepository<Manufacturer>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugType> IRepository<DrugType>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugType> IRepository<DrugType>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugUnit> IRepository<DrugUnit>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugUnit> IRepository<DrugUnit>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugContent> IRepository<DrugContent>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugContent> IRepository<DrugContent>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugCategory> IRepository<DrugCategory>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DrugCategory> IRepository<DrugCategory>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Consultant> IRepository<Consultant>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Consultant> IRepository<Consultant>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Patient> IRepository<Patient>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Patient> IRepository<Patient>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        // Customer 
        Customer IRepository<Customer>.Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        Customer IRepository<Customer>.Find(object id)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Customer>("GetCustomer", new { Id = id }, commandType: CommandType.StoredProcedure).Single();
            }
        }

        void IRepository<Customer>.Insert(Customer model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                model.Id = _dbConn.Query<int>("AddCustomer",
                              new
                              {
                                  Name = model.Name,
                                  Age = model.Age,
                                  Gender = model.Gender,
                                  Mobile = model.Mobile,
                                  Location = model.Location,
                                  Type = model.Type
                              },
                              commandType: CommandType.StoredProcedure).Single();
            }
        }

        bool IRepository<Customer>.Delete(Customer model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("DeleteCustomer", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        bool IRepository<Customer>.Update(Customer model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Name", model.Name);
                p.Add("@Type", model.Type);
                p.Add("@Location", model.Location);
                p.Add("@Age", model.Age);
                p.Add("@Gender", model.Gender);
                p.Add("@Mobile", model.Mobile);
                p.Add("@IsActive", model.isActive);
                p.Add("@Id", model.Id);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                _dbConn.Execute("UpdateCustomer", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        IEnumerable<Customer> IRepository<Customer>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Customer>("GetCustomers",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<Customer> IRepository<Customer>.SelectAll(int pId)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Customer> IRepository<Customer>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<Customer> IRepository<Customer>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
    }
}
