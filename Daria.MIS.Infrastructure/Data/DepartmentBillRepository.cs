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
    public class DepartmentBillRepository : IDepartmentBillRepository
    {
        private IDbConnection _dbConn;

        public void Insert(DepartmentBill model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddBillHeader(model, _dbConn, transaction);
                        if (model.IndentBillItems != null)
                        {
                            foreach (DepartmentBillItem item in model.IndentBillItems)
                            {

                                item.BillCode = model.Id;
                                item.IPNo = model.IPNo;
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


        public void AddBillHeader(DepartmentBill indentbillHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddDepartmentBillHeader",
                                new
                                {
                                    pharmacyId = indentbillHeader.PharmacyId,
                                    customer = indentbillHeader.Customer,
                                    consultantName = indentbillHeader.ConsultantName,
                                    ipNo = indentbillHeader.IPNo,
                                    totalAmount = indentbillHeader.TotalAmount,
                                    discountPercent = indentbillHeader.DiscountPercent,
                                    discount = indentbillHeader.Discount,
                                    netAmount = indentbillHeader.NetAmount,
                                    totalVAT = indentbillHeader.TotalVAT,
                                    paidAmount = indentbillHeader.PaidAmount,
                                    balance = indentbillHeader.Balance,
                                    roundOff = indentbillHeader.RoundOff,
                                    billstatus = indentbillHeader.BillStatus,
                                    salesMode = indentbillHeader.SalesMode,
                                    payMode = indentbillHeader.Paymode,
                                    indentId = indentbillHeader.IndentId,
                                    AddedBy = indentbillHeader.AddedPerson.PersonId,
                                    AddedDateTime = indentbillHeader.AddedDateTime,
                                    savedUserId = indentbillHeader.SavedUser.UserId

                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            indentbillHeader.Id = output.Key;
            indentbillHeader.BillNo = output.Value;
        }

        public void AddBillItem(DepartmentBillItem indentbillItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            indentbillItem.Id = dbConn.Query<int>("AddDepartmentBillItem",
                                new
                                {
                                    pharmacyId = indentbillItem.PharmacyId,
                                    billcode = indentbillItem.BillCode,
                                    productId = indentbillItem.ProductId,
                                    batchNo = indentbillItem.BatchNo,
                                    qty = indentbillItem.Qty,
                                    mfgId = (indentbillItem.ManufacturerId == 0) ? (long?)null : indentbillItem.ManufacturerId,

                                    expiryDate = indentbillItem.ExpiryDate,
                                    grnNo = indentbillItem.GRNNo,
                                    CostPrice = indentbillItem.CostPrice,
                                    totalcostprice = indentbillItem.TotalCostPrice,
                                    MRP = indentbillItem.MRP,
                                    totalMRP = indentbillItem.TotalMRP,
                                    taxPercent = indentbillItem.TaxPercent,
                                    taxAmount = indentbillItem.VATAmount,
                                    discPercent = indentbillItem.DiscPercent,
                                    discount = indentbillItem.Discount,
                                    cancelFlag = (indentbillItem.CancelFlag == 0) ? (long?)null : indentbillItem.CancelFlag,
                                    editProduct = (indentbillItem.EditProduct == 0) ? (long?)null : indentbillItem.EditProduct,
                                    stock = indentbillItem.Stock,
                                    purDetId = indentbillItem.PurDetId,
                                    AddedBy = indentbillItem.AddedPerson.PersonId,
                                    AddedDateTime = indentbillItem.AddedDateTime,
                                    ipNo = indentbillItem.IPNo,
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public DepartmentBill Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetBillDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<DepartmentBill>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.IndentBillItems = resultSet.Read<DepartmentBillItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public DepartmentBill FindIndentDetails(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetIndentDetailsForBilling", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<DepartmentBill>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Id = (long)id;
                        purchase.IndentBillItems = resultSet.Read<DepartmentBillItem>().ToList();
                    }
                    return purchase;
                }
            }

        }
        public DepartmentBill Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(DepartmentBill model)
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

        public bool Update(DepartmentBill model)
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

                        if (model.IndentBillItems != null)
                        {
                            foreach (DepartmentBillItem item in model.IndentBillItems)
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

        public IEnumerable<DepartmentBill> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<DepartmentBill> bills = new List<DepartmentBill>();
                var result = _dbConn.Query("GetSalesList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    DepartmentBill bill = new DepartmentBill();
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

        IEnumerable<DepartmentBill> IRepository<DepartmentBill>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<DepartmentBill> IRepository<DepartmentBill>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        public IEnumerable<DepartmentBill> SelectAll()
        {
            throw new NotImplementedException();
        }
    }
}
