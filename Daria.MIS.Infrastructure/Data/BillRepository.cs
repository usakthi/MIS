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
    public class BillRepository : IBillRepository
    {
        private IDbConnection _dbConn;

        public void Insert(Bill model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddBillHeader(model, _dbConn, transaction);
                        if (model.BillItems != null)
                        {
                            foreach (BillItem item in model.BillItems)
                            {

                                item.BillCode = model.Id;
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


        public void AddBillHeader(Bill billHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddBillHeader",
                                new
                                {
                                    pharmacyId = billHeader.PharmacyId,
                                    Customer = billHeader.Customer,
                                    CustomerId = billHeader.CustomerId,
                                    ConsultantName = billHeader.ConsultantName,
                                    ipno = billHeader.IPNo,
                                    totalAmount = billHeader.TotalAmount,
                                    discountPercent = billHeader.DiscountPercent,
                                    discount = billHeader.Discount,
                                    netAmount = billHeader.NetAmount,
                                    totalVAT = billHeader.VatAmount,
                                    paidAmount = billHeader.PaidAmount,
                                    balance = billHeader.Balance,
                                    roundOff = billHeader.RoundOff,
                                    billstatus = billHeader.BillStatus,
                                    salesMode = billHeader.SalesMode,
                                    payMode = billHeader.PayMode,
                                    indentId = billHeader.IndentId,
                                    dType = billHeader.DType,
                                    AddedBy = billHeader.AddedPerson.PersonId,
                                    AddedDateTime = billHeader.AddedDateTime,
                                    savedUserId = billHeader.SavedUser.UserId

                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            billHeader.Id = output.Key;
            billHeader.BillNo = output.Value;
        }

        public void AddBillItem(BillItem billItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            billItem.Id = dbConn.Query<int>("AddBillItem",
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
                                    cancelFlag = (billItem.CancelFlag == 0)? (long?)null : billItem.CancelFlag,
                                    editProduct = (billItem.EditProduct == 0) ? (long?)null : billItem.EditProduct,
                                    oldQty = billItem.OldQty,
                                    purDetId = billItem.PurDetId,
                                    AddedBy = billItem.AddedPerson.PersonId,
                                    AddedDateTime = billItem.AddedDateTime
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public Bill Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetBillDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<Bill>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.BillItems = resultSet.Read<BillItem>().ToList();
                    }
                    return purchase;
                }
            }
        }

        public Bill FindIndentDetails(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetIndentDetailsForBilling", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<Bill>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Id = (long)id;
                        purchase.BillItems = resultSet.Read<BillItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        //public Bill FindBillReceiptDetails(object id, long tenantId)
        //{
        //    using (_dbConn = DBHelper.GetOpenConnection())
        //    {
        //        using (var resultSet = _dbConn.QueryMultiple("GetReceiptForBill", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
        //        {
        //            var purchase = resultSet.Read<Bill>().FirstOrDefault();

        //            if (purchase != null)
        //            {
        //                purchase.Id = (long)id;
        //                purchase.BillItems = resultSet.Read<BillItem>().ToList();
        //            }
        //            return purchase;
        //        }
        //    }
        //}

        public Bill Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(Bill model)
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

        public bool Update(Bill model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {

                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        //(billItem.EditProduct == 0) ? (long?)null : billItem.EditProduct,
                        var p = new DynamicParameters();
                        p.Add("@Id", model.Id);
                        p.Add("@Customer", model.Customer);
                        p.Add("@Consultant", model.ConsultantName);
                        p.Add("@IPNo", model.IPNo);
                        p.Add("@SalesMode", model.SalesMode);
                        //p.Add("@BillEditUser", model.SavedUser.UserId);
                        p.Add("@BillEditUser", model.AddedPerson.PersonId);
                        p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("UpdateBillHeader", p, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var rowsAffected = p.Get<int>("@RowsAffected");

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

        public IEnumerable<Bill> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<Bill> bills = new List<Bill>();
                var result = _dbConn.Query("GetSalesList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    Bill bill = new Bill();
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

        IEnumerable<Bill> IRepository<Bill>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<Bill> IRepository<Bill>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Bill> SelectAll()
        {
            throw new NotImplementedException();
        }

        public List<Bill> SearchPurchases(BillSearchDTO model)
        {
            List<Bill> purchases = new List<Bill>();
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
                    Bill purchase = new Bill();
                    purchase.Id = record.Id;
                    purchase.BillNo = record.BillNo;
                    purchase.BillDate = record.BillDate;
                    purchase.Customer = record.Customer;
                    purchase.IPId = record.Customer;
                    purchase.NetAmount = record.NetAmount;
                    purchase.PaidAmount = record.PaidAmount;
                    purchase.Balance = record.Balance;
                    purchase.TotalVAT = record.TotalVAT;
                    purchase.SalesMode = record.SalesMode;
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
