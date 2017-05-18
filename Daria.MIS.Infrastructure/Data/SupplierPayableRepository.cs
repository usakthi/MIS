using Dapper;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Xml.Linq;
using System.Configuration;

namespace Daria.MIS.Infrastructure.Data
{
    public class SupplierPayableRepository : ISupplierPayableRepository
    {
        private IDbConnection _dbConn;

        public void Insert(SupplierPayable model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddSupplierPayableHeader(model, _dbConn, transaction);
                        if (model.SupplierPayableItems != null)
                        {
                            foreach (SupplierPayableItem item in model.SupplierPayableItems)
                            {
                                item.PayId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddSupplierPayableItem(item, _dbConn, transaction);
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

        public void AddSupplierPayableHeader(SupplierPayable supplierpayableHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddSupplierPayable",
                                new
                                {
                                    pharmacyId = supplierpayableHeader.PharmacyId,
                                    SupplierId = supplierpayableHeader.SupplierId,
                                    PaidAmount = supplierpayableHeader.PaidAmount,
                                    TotalPayable = supplierpayableHeader.TotalPayable,
                                    Balance = supplierpayableHeader.Balance,
                                    Discount = supplierpayableHeader.Discount,
                                    PayMode = supplierpayableHeader.PayMode,
                                    ChequeNo = supplierpayableHeader.ChequeNo,
                                    Comments = supplierpayableHeader.Comments,
                                    AddedBy = supplierpayableHeader.AddedPerson.PersonId,
                                    savedUserId = supplierpayableHeader.SavedUser.UserId
                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            supplierpayableHeader.Id = output.Key;
            supplierpayableHeader.PayNo = output.Value;
        }

        public void AddSupplierPayableItem(SupplierPayableItem supplierpayableItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            supplierpayableItem.Id = dbConn.Query<int>("AddSupplierPayableDetails",
                                new
                                {
                                    pharmacyId = supplierpayableItem.PharmacyId,
                                    PayId = supplierpayableItem.PayId,
                                    GrnNo = supplierpayableItem.GrnNo,
                                    GrnDate = supplierpayableItem.GrnDate,
                                    InvNo = supplierpayableItem.InvNo,
                                    InvDate = supplierpayableItem.InvDate,
                                    NetAmount = supplierpayableItem.NetAmount,
                                    PaidAmount = supplierpayableItem.PaidAmount,
                                    Balance = supplierpayableItem.Balance,
                                    Status = supplierpayableItem.PharmacyId,
                                    Comments = supplierpayableItem.PharmacyId,
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public SupplierPayable Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetBillDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<SupplierPayable>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.SupplierPayableItems = resultSet.Read<SupplierPayableItem>().ToList();
                    }
                    return purchase;
                }
            }
        }

        public SupplierPayable FindSupplierDetails(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetDueSupplierwisePayable", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<SupplierPayable>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Id = (long)id;
                        purchase.SupplierPayableItems = resultSet.Read<SupplierPayableItem>().ToList();
                    }
                    return purchase;
                }
            }
        }

        public SupplierPayable Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(SupplierPayable model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@pharmacyId", model.PharmacyId);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);

                _dbConn.Execute("DeleteSupplierPayable", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        public bool Update(SupplierPayable model)
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
                        p.Add("@netAmount", model.NetAmount);
                        
                        p.Add("@paidAmount", model.PaidAmount);
                        
                        p.Add("@comment", model.Comment);
                        p.Add("@UpdatedBy", model.UpdatedBy);
                        p.Add("@UpdatedDateTime", model.UpdatedDateTime);
                        p.Add("@savedUserId", model.SavedUser.UserId);
                        p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("UpdatePurchaseHeader", p, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var rowsAffected = p.Get<int>("@RowsAffected");

                        if (model.SupplierPayableItems != null)
                        {
                            foreach (SupplierPayableItem item in model.SupplierPayableItems)
                            {
                                item.PayId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddSupplierPayableItem(item, _dbConn, transaction);
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

        public IEnumerable<SupplierPayable> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<SupplierPayable> bills = new List<SupplierPayable>();
                var result = _dbConn.Query("GetDueSupplierPayable",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    SupplierPayable bill = new SupplierPayable();
                    bill.SNo = record.SNo;
                    bill.GRNNo = record.GrnNo;
                    bill.GRNDate = record.GrnDate;
                    bill.InvNo = record.InvNo;
                    bill.InvDate = record.InvDate;
                    bill.Supplier = new Supplier { Name = record.Name };


                    bill.NetAmount = record.NetAmount;
                    bill.PaidAmount = record.PaidAmount;
                    bill.Balance = record.Balance;
                    bill.AddedUserName = record.AddedUsername;
                    bills.Add(bill);
                }

                return bills;
            }
        }

        IEnumerable<SupplierPayable> IRepository<SupplierPayable>.SelectAll()
        
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<SupplierPayable>("GetBanks",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<SupplierPayable> IRepository<SupplierPayable>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<SupplierPayable> IRepository<SupplierPayable>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<SupplierPayable> SelectAll()
        {
            throw new NotImplementedException();
        }

        public void SaveSupplierPayable(List<SupplierPayableDueList> q)
        {
            DataTable payablelist = new DataTable("PayableListType");
            payablelist.Columns.Add("PharmacyId", typeof(Int32));
            payablelist.Columns.Add("PayNo", typeof(Int32));
            payablelist.Columns.Add("PayDate", typeof(string));
            payablelist.Columns.Add("SupplierId", typeof(Int32));
            payablelist.Columns.Add("GrnNo", typeof(string));
            payablelist.Columns.Add("PaidAmount", typeof(Decimal));
            payablelist.Columns.Add("Payable", typeof(Decimal));
            payablelist.Columns.Add("Balance", typeof(Decimal));
            payablelist.Columns.Add("PayMode", typeof(string));
            payablelist.Columns.Add("ChequeNo", typeof(string));
            payablelist.Columns.Add("ChequeDate", typeof(string));
            payablelist.Columns.Add("SavedUser", typeof(Int32));

            foreach (SupplierPayableDueList cr in q)
            {
                payablelist.Rows.Clear();
                payablelist.Rows.Add(cr.PharmacyId,
                                     cr.PayNo,
                                     cr.PayDate,
                                     cr.SupplierId,
                                     cr.GrnNo,
                                     cr.PaidAmount,
                                     cr.Payable,
                                     cr.Balance,
                                     cr.PayMode,
                                     cr.ChequeNo,
                                     cr.ChequeDate,
                                     cr.SavedUser
                                 );

                using (_dbConn = DBHelper.GetOpenConnection())
                {
                    using (var transaction = _dbConn.BeginTransaction())
                    {
                        try
                        {
                            var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MISDBConn"].ConnectionString);
                            connection.Open();

                            SqlCommand cmd = new SqlCommand("SaveSupplierPayable", connection);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@q", payablelist);
                            cmd.ExecuteNonQuery();
                            connection.Close();

                            // var records = _dbConn.Query("SaveDueReceivable", crParam, transaction: transaction, commandType: CommandType.StoredProcedure);
                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                        }
                    }
                }
            }
        }
    }
}
