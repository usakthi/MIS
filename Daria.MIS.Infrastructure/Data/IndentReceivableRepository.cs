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
    public class IndentReceivableRepository : IIndentReceivableRepository
    {
        private IDbConnection _dbConn;

        public void Insert(IndentReceivable model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddIndentReceivableHeader(model, _dbConn, transaction);
                        if (model.IndentReceivableItems != null)
                        {
                            foreach (IndentReceivableItem item in model.IndentReceivableItems)
                            {

                                item.BillCode = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddIndentReceivableItem(item, _dbConn, transaction);

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


        public void AddIndentReceivableHeader(IndentReceivable indentreceivableHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddBillHeader",
                                new
                                {
                                    pharmacyId = indentreceivableHeader.PharmacyId,
                                    customer = indentreceivableHeader.Customer,
                                    consultantName = indentreceivableHeader.ConsultantName,
                                    ipNo = indentreceivableHeader.IPNo,
                                    totalAmount = indentreceivableHeader.TotalAmount,
                                    discountPercent = indentreceivableHeader.DiscountPercent,
                                    discount = indentreceivableHeader.Discount,
                                    netAmount = indentreceivableHeader.NetAmount,
                                    totalVAT = indentreceivableHeader.TotalVAT,
                                    paidAmount = indentreceivableHeader.PaidAmount,
                                    balance = indentreceivableHeader.Balance,
                                    roundOff = indentreceivableHeader.RoundOff,
                                    billstatus = indentreceivableHeader.BillStatus,
                                    salesMode = indentreceivableHeader.SalesMode,
                                    payMode = indentreceivableHeader.Paymode,
                                    indentId = indentreceivableHeader.IndentId,
                                    AddedBy = indentreceivableHeader.AddedPerson.PersonId,
                                    AddedDateTime = indentreceivableHeader.AddedDateTime,
                                    savedUserId = indentreceivableHeader.SavedUser.UserId

                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            indentreceivableHeader.Id = output.Key;
            indentreceivableHeader.BillNo = output.Value;
        }

        public void AddIndentReceivableItem(IndentReceivableItem indentreceivableItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            indentreceivableItem.Id = dbConn.Query<int>("AddBillItem",
                                new
                                {
                                    pharmacyId = indentreceivableItem.PharmacyId,
                                    billcode = indentreceivableItem.BillCode,
                                    productId = indentreceivableItem.ProductId,
                                    batchNo = indentreceivableItem.BatchNo,
                                    qty = indentreceivableItem.Qty,
                                    mfgId = (indentreceivableItem.ManufacturerId == 0) ? (long?)null : indentreceivableItem.ManufacturerId,

                                    expiryDate = indentreceivableItem.ExpiryDate,
                                    grnNo = indentreceivableItem.GRNNo,
                                    CostPrice = indentreceivableItem.CostPrice,
                                    totalcostprice = indentreceivableItem.TotalCostPrice,
                                    MRP = indentreceivableItem.MRP,
                                    totalMRP = indentreceivableItem.TotalMRP,
                                    taxPercent = indentreceivableItem.TaxPercent,
                                    taxAmount = indentreceivableItem.VATAmount,
                                    discPercent = indentreceivableItem.DiscPercent,
                                    discount = indentreceivableItem.Discount,
                                    cancelFlag = (indentreceivableItem.CancelFlag == 0) ? (long?)null : indentreceivableItem.CancelFlag,
                                    editProduct = (indentreceivableItem.EditProduct == 0) ? (long?)null : indentreceivableItem.EditProduct,
                                    oldQty = indentreceivableItem.OldQty,
                                    purDetId = indentreceivableItem.PurDetId,
                                    AddedBy = indentreceivableItem.AddedPerson.PersonId,
                                    AddedDateTime = indentreceivableItem.AddedDateTime
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public IndentReceivable Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetBillDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<IndentReceivable>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.IndentReceivableItems = resultSet.Read<IndentReceivableItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public IndentReceivable FindIndentDetails(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetDueDetailsforReceivable", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<IndentReceivable>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Id = (long)id;
                        purchase.IndentReceivableItems = resultSet.Read<IndentReceivableItem>().ToList();
                    }
                    return purchase;
                }
            }

        }
        public IndentReceivable Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(IndentReceivable model)
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

        public bool Update(IndentReceivable model)
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
                        p.Add("@discountPercent", model.DiscountPercent);
                        p.Add("@discountAmount", model.Discount);
                        p.Add("@totalAmount", model.TotalAmount);
                        p.Add("@totalVAT", model.TotalVAT);
                        p.Add("@netAmount", model.NetAmount);
                        p.Add("@roundOff", model.RoundOff);
                        p.Add("@paidAmount", model.PaidAmount);
                        p.Add("@status", model.BillStatus);
                        p.Add("@comment", model.Comment);
                        p.Add("@UpdatedBy", model.UpdatedBy);
                        p.Add("@UpdatedDateTime", model.UpdatedDateTime);
                        p.Add("@savedUserId", model.SavedUser.UserId);
                        p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("UpdatePurchaseHeader", p, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var rowsAffected = p.Get<int>("@RowsAffected");

                        if (model.IndentReceivableItems != null)
                        {
                            foreach (IndentReceivableItem item in model.IndentReceivableItems)
                            {
                                item.BillCode = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddIndentReceivableItem(item, _dbConn, transaction);
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

        public IEnumerable<IndentReceivable> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<IndentReceivable> bills = new List<IndentReceivable>();
                var result = _dbConn.Query("GetIndentDueList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    IndentReceivable bill = new IndentReceivable();
                    bill.Id = record.BillCode;
                    bill.BillNo = record.BillNo;
                    bill.BillDate = record.BillDate;
                    bill.Customer = record.Customer;
                    bill.TotalAmount = record.TotalAmount;
                    bill.TotalVAT = record.TotalVat;
                    bill.NetAmount = record.NetAmount;

                    bill.PaidAmount = record.PaidAmount;
                    bill.Balance = record.Balance;
                    bill.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    bill.AddedDateTime = record.AddedDateTime;
                    bill.AddedUserName = record.Username;
                    bills.Add(bill);
                }

                return bills;
            }
        }

        IEnumerable<IndentReceivable> IRepository<IndentReceivable>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<IndentReceivable>("GetDuePatientList",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        IEnumerable<IndentReceivable> IRepository<IndentReceivable>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<IndentReceivable> IRepository<IndentReceivable>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        public IEnumerable<IndentReceivable> SelectAll()
        {
            throw new NotImplementedException();
        }
    }
}
