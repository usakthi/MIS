using Dapper;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Infrastructure.Data
{
    public class DepartmentStockRepository : IDepartmentStockRepository
    {
        private IDbConnection _dbConn;

        public DepartmentStock Find(object id)
        {
            throw new NotImplementedException();
        }

        public DepartmentStock Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        public void Insert(DepartmentStock model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        //transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                    }
                }
            }
        }

        public bool Delete(DepartmentStock model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var rowsAffected = 0;
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        public bool Update(DepartmentStock model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var rowsAffected = 0;
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        public IEnumerable<DepartmentStock> SelectAll(int pharmaId)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DepartmentStock> SelectAll()
        {
            throw new NotImplementedException();
        }

        IEnumerable<DepartmentStock> IRepository<DepartmentStock>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<DepartmentStock> IRepository<DepartmentStock>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public List<DepartmentStock> RptCurrentStock(DepartmentStockSearchDTO model)
        {
            List<DepartmentStock> purchases = new List<DepartmentStock>();
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@PharmacyId", model.PharmacyId);
                p.Add("@pageSize", model.PageSize);
                p.Add("@page", model.PageNo);
                p.Add("@OrderBy", model.OrderBy);
                p.Add("@GrnNo", model.GrnNo);
                p.Add("@GrnDate", model.GrnDate);
                p.Add("@InvoiceNo", model.SupplierInvNo);
                p.Add("@AddedById", model.AddedById);
                p.Add("@SupplierId", model.SupplierId);
                p.Add("@AddedFromDate", model.AddedFrom);
                p.Add("@AddedToDate", model.AddedTo);
                p.Add("@totalRows", dbType: DbType.Int32, direction: ParameterDirection.Output);
                p.Add("@totalPages", dbType: DbType.Int32, direction: ParameterDirection.Output);
                var records = _dbConn.Query("RptDepartmentStock", p, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in records)
                {
                    DepartmentStock purchase = new DepartmentStock();
                    purchase.Id = record.Id;
                    purchase.DrugName = record.DrugName;
                    purchase.Qty = record.Qty;
                    purchase.BatchNo = record.BatchNo;
                    purchase.Manufacturer = new Manufacturer { Name = record.Mfg };
                    purchase.Category = new DrugCategory { Name = record.Category };
                    purchase.CostPrice = record.CostPrice;
                    purchase.Mrp = record.MRP;
                    purchase.TotalCost = record.TotalCost;
                    purchase.TotalMrp = record.TotalMrp;
                    purchase.Vat = record.VAT;
                    purchase.SNo = record.RowNumber;
                    purchases.Add(purchase);
                }
                model.TotalRecords = p.Get<int?>("@totalRows").GetValueOrDefault();
                model.TotalPages = p.Get<int?>("@totalPages").GetValueOrDefault();
            }

            return purchases;
        }
    }
}
