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
    public class BillReturnRepository : IBillReturnRepository
    {
        private IDbConnection _dbConn;

        public void Insert(BillReturn model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddBillReturnHeader(model, _dbConn, transaction);
                        if (model.BillReturnItems != null)
                        {
                            foreach (BillReturnItem item in model.BillReturnItems)
                            {

                                item.BillCode = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddBillReturnItem(item, _dbConn, transaction);

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


        public void AddBillReturnHeader(BillReturn billHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("EditBillHeader",
                                new
                                {
                                    pharmacyId = billHeader.PharmacyId,
                                    billno = billHeader.BillNo,
                                    netAmount = billHeader.NetAmount,
                                    totalVAT = billHeader.TotalVAT,
                                    paidAmount = billHeader.PaidAmount,
                                    balance = billHeader.Balance,
                                    salesMode = billHeader.SalesMode
                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            billHeader.Id = output.Key;
            billHeader.BillNo = output.Value;
        }

        public void AddBillReturnItem(BillReturnItem billItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            billItem.Id = dbConn.Query<int>("EditBillItems",
                                new
                                {
                                    pharmacyId = billItem.PharmacyId,
                                    billcode = billItem.BillCode,
                                    productId = billItem.ProductId,
                                    batchNo = billItem.BatchNo,
                                    qty = billItem.Qty,
                                    MfgId = (billItem.ManufacturerId == 0) ? (long?)null : billItem.ManufacturerId,

                                    expiryDate = billItem.ExpDate,
                                    grnNo = billItem.GRNNo,
                                    CostPrice = billItem.CostPrice,
                                    totalcostprice = billItem.TotalCostPrice,
                                    MRP = billItem.MRP,
                                    totalMRP = billItem.TotalMRP,
                                    TaxPercent = billItem.VAT,
                                    TaxAmount = billItem.VATAmount,
                                    discPercent = billItem.DiscPercent,
                                    discount = billItem.Discount,
                                    cancelFlag = (billItem.CancelFlag == 0) ? (long?)null : billItem.CancelFlag,
                                    editProduct = (billItem.EditProduct == 0) ? (long?)null : billItem.EditProduct,
                                    oldQty = billItem.OldQty,
                                    purDetId = billItem.PurDetId,
                                    AddedBy = billItem.AddedPerson.PersonId,
                                    AddedDateTime = billItem.AddedDateTime
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public BillReturn Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetBillDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<BillReturn>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.BillReturnItems = resultSet.Read<BillReturnItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public BillReturn Find(object id)
        {
            throw new NotImplementedException();
        }



        public bool Delete(BillReturn model)
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

        public bool Update(BillReturn model)
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
                        p.Add("@grnDate", model.BillDate);
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

                        if (model.BillReturnItems != null)
                        {
                            foreach (BillReturnItem item in model.BillReturnItems)
                            {
                                item.BillCode = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddBillReturnItem(item, _dbConn, transaction);
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

        public IEnumerable<BillReturn> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<BillReturn> bills = new List<BillReturn>();
                var result = _dbConn.Query("GetSalesList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    BillReturn bill = new BillReturn();
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

        IEnumerable<BillReturn> IRepository<BillReturn>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<BillReturn> IRepository<BillReturn>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<BillReturn> SelectAll()
        {
            throw new NotImplementedException();
        }

        public List<BillReturn> SearchPurchases(BillReturnSearchDTO model)
        {
            List<BillReturn> purchases = new List<BillReturn>();
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
                    BillReturn purchase = new BillReturn();
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
