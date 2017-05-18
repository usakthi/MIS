using Dapper;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Entities;
using System;
using System.Web;
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
    public class CustomerReceivableRepository : ICustomerReceivableRepository
    {
        private IDbConnection _dbConn;

        public void Insert(CustomerReceivable model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddCustomerReceivableHeader(model, _dbConn, transaction);
                        if (model.CustomerReceivableItems != null)
                        {
                            foreach (CustomerReceivableItem item in model.CustomerReceivableItems)
                            {

                                item.PayId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddCustomerReceivableItem(item, _dbConn, transaction);

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

        public void AddCustomerReceivableHeader(CustomerReceivable customerReceivableHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddCustomerReceivable",
                                new
                                {
                                    pharmacyId = customerReceivableHeader.PharmacyId,
                                    CustomerId = customerReceivableHeader.CustomerId,
                                    PaidAmount = customerReceivableHeader.PaidAmount,
                                    TotalPayable = customerReceivableHeader.TotalPayable,
                                    Balance = customerReceivableHeader.Balance,
                                    Discount = customerReceivableHeader.Discount,
                                    PayMode = customerReceivableHeader.PayMode,
                                    ChequeNo = customerReceivableHeader.ChequeNo,
                                    Comments = customerReceivableHeader.Comments,
                                    AddedBy = customerReceivableHeader.AddedPerson.PersonId,
                                    savedUserId = customerReceivableHeader.SavedUser.UserId
                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            customerReceivableHeader.Id = output.Key;
            customerReceivableHeader.PayNo = output.Value;
        }

        public void AddCustomerReceivableItem(CustomerReceivableItem customerReceivableItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            customerReceivableItem.Id = dbConn.Query<int>("AddCustomerReceivableDetails",
                                new
                                {
                                    pharmacyId = customerReceivableItem.PharmacyId,
                                    PayId = customerReceivableItem.PayId,
                                    GrnNo = customerReceivableItem.BillNo,
                                    GrnDate = customerReceivableItem.BillDate,
                                    NetAmount = customerReceivableItem.NetAmount,
                                    PaidAmount = customerReceivableItem.PaidAmount,
                                    Balance = customerReceivableItem.Balance,
                                    Status = customerReceivableItem.PharmacyId,
                                    Comments = customerReceivableItem.PharmacyId,
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public CustomerReceivable Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("getCustomerDueInfo", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<CustomerReceivable>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.CustomerReceivableItems = resultSet.Read<CustomerReceivableItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public CustomerReceivable FindCustomerDetails(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetDueSupplierwisePayable", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<CustomerReceivable>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Id = (long)id;
                        purchase.CustomerReceivableItems = resultSet.Read<CustomerReceivableItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public CustomerReceivable Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(CustomerReceivable model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var p = new DynamicParameters();
                p.Add("@Id", model.Id);
                p.Add("@pharmacyId", model.PharmacyId);
                p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);

                _dbConn.Execute("DeleteCustomerReceivable", p, commandType: CommandType.StoredProcedure);
                var rowsAffected = p.Get<int>("@RowsAffected");
                if (rowsAffected > 0) { return true; } else { return false; }
            }
        }

        public bool Update(CustomerReceivable model)
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

                        if (model.CustomerReceivableItems != null)
                        {
                            foreach (CustomerReceivableItem item in model.CustomerReceivableItems)
                            {
                                item.PayId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddCustomerReceivableItem(item, _dbConn, transaction);
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

        public IEnumerable<CustomerReceivable> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<CustomerReceivable> dues = new List<CustomerReceivable>();
                var result = _dbConn.Query("getCustomerDueList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    CustomerReceivable due = new CustomerReceivable();
                    due.Id = record.Id;
                    due.CustomerName = record.CustomerName;
                    due.BillNo = record.BillNo;
                    due.BillDate = record.BillDate;
                    due.ConsultantName = record.ConsultantName;
                    due.TotalAmount = record.TotalAmount;
                    due.Discount = record.Discount;
                    due.NetAmount = record.NetAmount;
                    due.PaidAmount = record.PaidAmount;
                    due.Balance = record.Balance;
                    dues.Add(due);
                }

                return dues;
            }
        }

        IEnumerable<CustomerReceivable> IRepository<CustomerReceivable>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<CustomerReceivable>("getCustomerDueList",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<CustomerReceivable> IRepository<CustomerReceivable>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<CustomerReceivable> IRepository<CustomerReceivable>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<CustomerReceivable> SelectAll()
        {
            throw new NotImplementedException();
        }

        public void SaveDueReceivable(List<CustomerDueList> q)
        {
            DataTable duelist = new DataTable("DueListType");
            duelist.Columns.Add("pharmacyid", typeof(Int32));
            duelist.Columns.Add("customerid", typeof(Int32));
            duelist.Columns.Add("BillCode", typeof(Int64));
            duelist.Columns.Add("BillNo", typeof(string));
            duelist.Columns.Add("NetAmount", typeof(Decimal));
            duelist.Columns.Add("PaidAmount", typeof(Decimal));
            duelist.Columns.Add("Payable", typeof(Decimal));
            duelist.Columns.Add("Balance", typeof(Decimal));
            duelist.Columns.Add("PayMode", typeof(string));
            duelist.Columns.Add("ChequeNo", typeof(string));
            duelist.Columns.Add("ChequeDate", typeof(string));
            duelist.Columns.Add("SavedUser", typeof(Int32));

            foreach (CustomerDueList cr in q)
            {
                duelist.Rows.Clear();
                duelist.Rows.Add(cr.PharmacyId,
                                 cr.CustomerId,
                                     cr.BillCode,
                                     cr.BillNo,
                                     cr.NetAmount,
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

                            SqlCommand cmd = new SqlCommand("SaveDueReceivable", connection);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@q", duelist);
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
