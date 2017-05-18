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
    public class EditedBillRepository : IEditedBillRepository
    {
        private IDbConnection _dbConn;

        public void Insert(EditedBill model)
        {
            throw new NotImplementedException();
        }

        public EditedBill Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        public EditedBill Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(EditedBill model)
        {
            throw new NotImplementedException();
        }

        public bool Update(EditedBill model)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<EditedBill> SelectAll()
        {
            throw new NotImplementedException();
        }

        IEnumerable<EditedBill> IRepository<EditedBill>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<EditedBill> IRepository<EditedBill>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<EditedBill> SelectAll(int pharmaId)
        {
            throw new NotImplementedException();

            //using (_dbConn = DBHelper.GetOpenConnection())
            //{
            //    List<EditedBill> purchases = new List<EditedBill>();
            //    var result = _dbConn.Query("GetEditedBillList",
            //                new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

            //    foreach (dynamic record in result)
            //    {
            //        EditedBill purchase = new EditedBill();
            //        purchase.Id = record.Id;
            //        purchase.BillNo = record.GrnNo;
            //        purchase.BillDate = record.GrnDate;
            //        purchase.Customer = record.Customer;
            //        purchase.TotalVAT = record.TotalVAT;
            //        purchase.NetAmount = record.NetAmount;
            //        purchase.PaidAmount = record.PaidAmount;
            //        purchase.Status = record.Status;
            //        purchase.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
            //        purchase.AddedDateTime = record.AddedDateTime;
            //        purchase.AddedUserName = record.Username;
            //        purchases.Add(purchase);
            //    }

            //    return purchases;
            //}
        }

        public List<EditedBill> SearchPurchases(EditedBillSearchDTO model)
        {
            List<EditedBill> purchases = new List<EditedBill>();
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@PharmacyId", model.PharmacyId);
                p.Add("@pageSize", model.PageSize);
                p.Add("@page", model.PageNo);
                p.Add("@OrderBy", model.OrderBy);
                p.Add("@BillNo", model.BillNo);
                p.Add("@Billdate", model.BillDate);
                p.Add("@Customer", model.Customer);
                p.Add("@EditedById", model.EditedById);
                p.Add("@IPId", model.IPId);
                p.Add("@EditedFromDate", model.EditedFrom);
                p.Add("@EditedToDate", model.EditedTo);
                p.Add("@totalRows", dbType: DbType.Int32, direction: ParameterDirection.Output);
                p.Add("@totalPages", dbType: DbType.Int32, direction: ParameterDirection.Output);
                var records = _dbConn.Query("SearchSalesList", p, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in records)
                {
                    EditedBill purchase = new EditedBill();
                    purchase.Id = record.Id;
                    purchase.BillNo = record.BillNo;
                    purchase.BillDate = record.BillDate;
                    purchase.Customer = record.Customer;
                    purchase.IPId = record.Customer;
                    purchase.NetAmount = record.NetAmount;
                    purchase.PaidAmount = record.PaidAmount;
                    purchase.TotalVAT = record.TotalVAT;
                    purchase.PayMode = record.PayMode;
                    purchase.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    purchases.Add(purchase);
                }
                model.TotalRecords = p.Get<int?>("@totalRows").GetValueOrDefault();
                model.TotalPages = p.Get<int?>("@totalPages").GetValueOrDefault();
            }

            return purchases;
        }
    }
}
