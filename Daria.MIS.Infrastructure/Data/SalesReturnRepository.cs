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
    public class SalesReturnRepository : ISalesReturnRepository
    {
        private IDbConnection _dbConn;

        public void Insert(SalesReturn model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddBillHeader(model, _dbConn, transaction);
                        if (model.SalesRetItems != null)
                        {
                            foreach (SalesReturnItem item in model.SalesRetItems)
                            {
                                item.BRCode = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddBillItem(item, _dbConn, transaction);
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


        public void AddBillHeader(SalesReturn salesreturnHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddBillReturnHeader",
                                new
                                {
                                    pharmacyId = salesreturnHeader.PharmacyId,
                                    dtype = salesreturnHeader.DType,
                                    customer = salesreturnHeader.Customer,
                                    consultantName = salesreturnHeader.ConsultantName,
                                    ipNo = salesreturnHeader.IPNo,
                                    totalamount = salesreturnHeader.TotalAmount,
                                    discountpercent = salesreturnHeader.DiscountPercent,
                                    discount = salesreturnHeader.Discount,
                                    netamount = salesreturnHeader.NetAmount,
                                    paidamount = salesreturnHeader.PaidAmount,
                                    balance = salesreturnHeader.Balance,
                                    totalvat = salesreturnHeader.TotalVAT,
                                    roundoff = salesreturnHeader.RoundOff,
                                    billstatus = salesreturnHeader.BillStatus,
                                    AddedBy = salesreturnHeader.AddedPerson.PersonId,
                                    AddedDateTime = salesreturnHeader.AddedDateTime,
                                    savedUserId = salesreturnHeader.SavedUser.UserId,
                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            salesreturnHeader.Id = output.Key;
            salesreturnHeader.BillNo = output.Value;
        }

        public void AddBillItem(SalesReturnItem salesreturnItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            salesreturnItem.Id = dbConn.Query<int>("AddBillReturnItem",
                                new
                                {
                                    pharmacyId = salesreturnItem.PharmacyId,
                                    brcode = salesreturnItem.BRCode,
                                    billcode = salesreturnItem.BillCode,
                                    productId = salesreturnItem.ProductId,
                                    batchNo = salesreturnItem.BatchNo,
                                    qty = salesreturnItem.Qty,
                                    mfgId = (salesreturnItem.ManufacturerId == 0) ? (long?)null : salesreturnItem.ManufacturerId,

                                    expiryDate = salesreturnItem.ExpDate,
                                    MRP = salesreturnItem.MRP,
                                    totalMRP = salesreturnItem.TotalMRP,
                                    taxPercent = salesreturnItem.VAT,
                                    taxAmount = salesreturnItem.VATAmount,
                                    discpercent = salesreturnItem.DiscPercent,
                                    discount = salesreturnItem.Discount,
                                    purDetId = salesreturnItem.PurDetId,
                                    AddedBy = salesreturnItem.AddedPerson.PersonId,
                                    AddedDateTime = salesreturnItem.AddedDateTime
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public SalesReturn Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetBillReturnDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<SalesReturn>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.SalesRetItems = resultSet.Read<SalesReturnItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public SalesReturn FindSalesItems(string no, string category)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetIPSalesItems", new { no = no, category = category }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<SalesReturn>().FirstOrDefault();

                    return purchase;
                }
            }

        }

        IEnumerable<SalesReturn> IRepository<SalesReturn>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public SalesReturn Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(SalesReturn model)
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

        public bool Update(SalesReturn model)
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

                        if (model.SalesRetItems != null)
                        {
                            foreach (SalesReturnItem item in model.SalesRetItems)
                            {
                                item.BillCode = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddBillItem(item, _dbConn, transaction);
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

        public IEnumerable<SalesReturn> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<SalesReturn> bills = new List<SalesReturn>();
                var result = _dbConn.Query("GetSalesReturnList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    SalesReturn bill = new SalesReturn();
                    bill.Id = record.BillCode;
                    bill.BillNo = record.BillNo;
                    bill.BillDate = record.BillDate;
                    bill.Customer = record.Customer;
                    bill.TotalAmount = record.TotalAmount;
                    bill.TotalVAT = record.TotalVat;
                    bill.NetAmount = record.NetAmount;

                    bill.PaidAmount = record.PaidAmount;
                    bill.BillStatus = record.BillStatus;
                    bill.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    bill.AddedDateTime = record.AddedDateTime;
                    bill.AddedUserName = record.Username;
                    bills.Add(bill);
                }

                return bills;
            }
        }

        IEnumerable<SalesReturn> IRepository<SalesReturn>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        
        public IEnumerable<SalesReturn> SelectAll()
        {
            throw new NotImplementedException();
        }
    }
}
