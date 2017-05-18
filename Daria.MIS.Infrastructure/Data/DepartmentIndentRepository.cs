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
    public class DepartmentIndentRepository : IDepartmentIndentRepository
    {
        private IDbConnection _dbConn;

        public void Insert(DepartmentIndent model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddIndentHeader(model, _dbConn, transaction);
                        if (model.IndentItems != null)
                        {
                            foreach (DepartmentIndentItem item in model.IndentItems)
                            {

                                item.IndentId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddIndentItem(item, _dbConn, transaction);

                            }
                        }
                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                    }
                }
            }
        }


        public void AddIndentHeader(DepartmentIndent indentHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddDepartmentIndentHeader",
                                new
                                {
                                    pharmacyId = indentHeader.PharmacyId,
                                    patientName = indentHeader.PatientName,
                                    consultant = indentHeader.Consultant,
                                    IPNo = indentHeader.IPNo,
                                    payMode = indentHeader.PayMode,
                                    AddedBy = indentHeader.AddedPerson.PersonId,
                                    AddedDateTime = indentHeader.AddedDateTime,
                                    savedUserId = indentHeader.SavedUser.UserId

                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            indentHeader.Id = output.Key;
            indentHeader.IndentNo = output.Value;
        }

        public void AddIndentItem(DepartmentIndentItem indentItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            indentItem.Id = dbConn.Query<int>("AddDepartmentIndentItem",
                                new
                                {
                                    pharmacyId = indentItem.PharmacyId,
                                    indentId = indentItem.IndentId,
                                    productId = indentItem.ProductId,
                                    batchNo = indentItem.BatchNo,
                                    qty = indentItem.Qty,
                                    mfgId = (indentItem.ManufacturerId == 0) ? (long?)null : indentItem.ManufacturerId,
                                    expDate = indentItem.ExpDate,
                                    grnNo = indentItem.GRNNo,
                                    //stock = indentItem.OldQty,
                                    stock = indentItem.Stock,
                                    purDetId = indentItem.PurDetId,
                                    AddedBy = indentItem.AddedPerson.PersonId,
                                    AddedDateTime = indentItem.AddedDateTime
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public DepartmentIndent Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetIndentDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<DepartmentIndent>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.IndentItems = resultSet.Read<DepartmentIndentItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public DepartmentIndent Find(object id)
        {
            throw new NotImplementedException();
        }



        public bool Delete(DepartmentIndent model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@pharmacyId", model.PharmacyId);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);

                _dbConn.Execute("DeletePurchase", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        public bool Update(DepartmentIndent model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {

                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {

                        var dp = new DynamicParameters();
                        dp.Add("@pHeaderId", model.Id);
                        dp.Add("@pharmacyId", model.PharmacyId);
                        dp.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("DeletePurchaseItems", dp, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var deletedRows = dp.Get<int>("@RowsAffected");

                        var p = new DynamicParameters();
                        p.Add("@Id", model.Id);
                        p.Add("@pharmacyId", model.PharmacyId);
                        p.Add("@grnDate", model.IndentDate);
                        p.Add("@status", model.Status);
                        p.Add("@comment", model.Comment);
                        p.Add("@UpdatedBy", model.UpdatedBy);
                        p.Add("@UpdatedDateTime", model.UpdatedDateTime);
                        p.Add("@savedUserId", model.SavedUser.UserId);
                        p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("UpdatePurchaseHeader", p, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var rowsAffected = p.Get<int>("@RowsAffected");

                        if (model.IndentItems != null)
                        {
                            foreach (DepartmentIndentItem item in model.IndentItems)
                            {
                                item.IndentId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddIndentItem(item, _dbConn, transaction);
                            }
                        }

                        transaction.Commit();
                        if (rowsAffected > 0) { return true; } else { return false; }
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        throw;
                    }

                }
            }
        }

        public IEnumerable<DepartmentIndent> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<DepartmentIndent> bills = new List<DepartmentIndent>();
                var result = _dbConn.Query("GetIndentsList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    DepartmentIndent bill = new DepartmentIndent();
                    bill.Id = record.IndentId;
                    bill.IndentNo = record.IndentNo;
                    bill.IndentDate = record.IndentDate;
                    bill.PatientName = record.Customer;
                    bill.IPNo = record.IPNo;
                    bill.Consultant = record.ConsultantName;
                    bill.DeptName = record.DeptName;
                    bill.Ward = record.Ward;
                    bill.PayMode = record.PayMode;
                    bill.Status = record.Status;
                    bill.IndentUser = record.IndentUser;

                    bill.Status = record.Status;
                    bill.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    bill.AddedDateTime = record.AddedDateTime;
                    bill.AddedUserName = record.Username;
                    bills.Add(bill);
                }

                return bills;
            }
        }

        IEnumerable<DepartmentIndent> IRepository<DepartmentIndent>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<DepartmentIndent>("GetIndents",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<DepartmentIndent> IRepository<DepartmentIndent>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DepartmentIndent> IRepository<DepartmentIndent>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        public IEnumerable<DepartmentIndent> SelectAll()
        {
            throw new NotImplementedException();
        }
    }
}
