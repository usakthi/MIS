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
    public class PurchaseRepository : IPurchaseRepository
    {
        private IDbConnection _dbConn;

        public void Insert(Purchase model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddPurchaseHeader(model, _dbConn, transaction);
                        if (model.PurchaseItems != null)
                        {
                            foreach (PurchaseItem item in model.PurchaseItems)
                            {
                                item.PurchaseId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.SaveStatus = model.SaveStatus;
                                this.AddPurchaseItem(item, _dbConn, transaction);
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


        public void AddPurchaseHeader(Purchase purchaseHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddPurchaseHeader",
                                new
                                {
                                    pharmacyId = purchaseHeader.PharmacyId,
                                    grnDate = purchaseHeader.GrnDate,
                                    orderNo = purchaseHeader.POrderNo,
                                    supplierId = (purchaseHeader.SupplierId == 0) ? (int?) 1 : purchaseHeader.SupplierId,
                                    supInvNo = purchaseHeader.SupplierInvNo,
                                    supInvDate = purchaseHeader.SupplierInvDate,
                                    creditPeriod = purchaseHeader.CreditPeriod,
                                    creditDate = purchaseHeader.CreditDate,
                                    discountPercent = purchaseHeader.DiscountPercent,
                                    discountAmount = purchaseHeader.DiscountAmount,
                                    totalAmount = purchaseHeader.TotalAmount,
                                    totalVAT = purchaseHeader.TotalVAT,
                                    netAmount = purchaseHeader.NetAmount,
                                    roundOff = purchaseHeader.RoundOff,
                                    isPaid = purchaseHeader.IsPaid,
                                    paidAmount = purchaseHeader.PaidAmount,
                                    status = purchaseHeader.Status,
                                    comment = purchaseHeader.Comment,
                                    AddedBy = purchaseHeader.AddedPerson.PersonId,
                                    AddedDateTime = purchaseHeader.AddedDateTime,
                                    savedUserId = purchaseHeader.SavedUser.UserId,
                                    SaveStatus = purchaseHeader.SaveStatus
                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            purchaseHeader.Id = output.Key;
            purchaseHeader.GrnNo = output.Value;
        }

        public void AddPurchaseItem(PurchaseItem purchaseItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            purchaseItem.Id = dbConn.Query<int>("AddPurchaseItem",
                                new
                                {
                                    pharmacyId = purchaseItem.PharmacyId,
                                    pHeaderId = purchaseItem.PurchaseId,
                                    productId = purchaseItem.ProductId,
                                    batchNo = purchaseItem.BatchNo,
                                    qty = purchaseItem.Qty,

                                    freeQty = purchaseItem.FreeQty,
                                    mfgId = (purchaseItem.ManufacturerId == 0) ? (long?)1 : purchaseItem.ManufacturerId,
                                    unitId = (purchaseItem.UnitId == 0) ? (long?)1 : purchaseItem.UnitId,
                                    expiryDate = purchaseItem.ExpiryDate,
                                    packing = purchaseItem.Packing,
                                    assortedQty = purchaseItem.AssortedQty,
                                    CostPrice = purchaseItem.CostPrice,
                                    MRP = purchaseItem.MRP,
                                    VAT = purchaseItem.VAT,

                                    abatedMRP = purchaseItem.AbatedMRP,
                                    TaxMode = purchaseItem.TaxMode,
                                    TaxType = purchaseItem.TaxType,
                                    DiscApplicable = purchaseItem.DiscApplicable,
                                    VATOnDiscount = purchaseItem.VATOnDiscount,
                                    VATOnFreeQty = purchaseItem.VATOnFreeQty,
                                    DiscOnFreeQty = purchaseItem.DiscOnFreeQty,
                                    FreeQtyVATAmount = purchaseItem.FreeQtyVATAmount,
                                    DiscountPercentage = purchaseItem.DiscountPercentage,
                                    DiscountAmount = purchaseItem.DiscountAmount,
                                    AssortedCostPrice = purchaseItem.AssortedCostPrice,
                                    AssortedMRPPrice = purchaseItem.AssortedMRPPrice,
                                    VATAmount = purchaseItem.VATAmount,
                                    TotalCostPrice = purchaseItem.TotalCostPrice,
                                    NetCostPrice = purchaseItem.NetCostPrice,
                                    TotalMRP = purchaseItem.TotalMRP,
                                    NetMRP = purchaseItem.NetMRP,
                                    VatOnDiscountAmount = purchaseItem.VatOnDiscountAmount,
                                    DiscOnFreeQtyAmount = purchaseItem.DiscOnFreeQtyAmount,
                                    TotalDiscountAmount = purchaseItem.TotalDiscountAmount,
                                    TotalVatAmount = purchaseItem.TotalVatAmount,
                                    NetVATAmount = purchaseItem.NetVATAmount,
                                    rackId = (purchaseItem.RackId == 0) ? (long?)null : purchaseItem.RackId,
                                    barCode = purchaseItem.Barcode,
                                    AddedBy = purchaseItem.AddedPerson.PersonId,
                                    AddedDateTime = purchaseItem.AddedDateTime,
                                    PurDetId = purchaseItem.PurDetId,
                                    SaveStatus = purchaseItem.SaveStatus
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public Purchase Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetPurchaseDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<Purchase>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.PurchaseItems = resultSet.Read<PurchaseItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public Purchase Find(object id)
        {
            throw new NotImplementedException();
        }


        public bool Delete(Purchase model)
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

        public bool Update(Purchase model)
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
                        p.Add("@grnDate", model.GrnDate);
                        p.Add("@orderNo", model.POrderNo);
                        p.Add("@supplierId", model.SupplierId);
                        p.Add("@supInvNo", model.SupplierInvNo);
                        p.Add("@supInvDate", model.SupplierInvDate);
                        p.Add("@creditPeriod", model.CreditPeriod);
                        p.Add("@creditDate", model.CreditDate);
                        p.Add("@discountPercent", model.DiscountPercent);
                        p.Add("@discountAmount", model.DiscountAmount);
                        p.Add("@totalAmount", model.TotalAmount);
                        p.Add("@totalVAT", model.TotalVAT);
                        p.Add("@netAmount", model.NetAmount);
                        p.Add("@roundOff", model.RoundOff);
                        p.Add("@isPaid", model.IsPaid);
                        p.Add("@paidAmount", model.PaidAmount);
                        p.Add("@status", model.Status);
                        p.Add("@comment", model.Comment);
                        p.Add("@UpdatedBy", model.UpdatedBy);
                        p.Add("@UpdatedDateTime", model.UpdatedDateTime);
                        p.Add("@saveStatus", model.SaveStatus);
                        //p.Add("@savedUserId", model.SavedUser.UserId);
                        p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("UpdatePurchaseHeader", p, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var rowsAffected = p.Get<int>("@RowsAffected");

                        if (model.PurchaseItems != null)
                        {
                            foreach (PurchaseItem item in model.PurchaseItems)
                            {
                                item.PurchaseId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                item.SaveStatus = model.SaveStatus;
                                this.AddPurchaseItem(item, _dbConn, transaction);
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

        public IEnumerable<Purchase> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<Purchase> purchases = new List<Purchase>();
                var result = _dbConn.Query("GetPurchaseList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    Purchase purchase = new Purchase();
                    purchase.Id = record.Id;
                    purchase.GrnNo = record.GrnNo;
                    purchase.GrnDate = record.GrnDate;
                    purchase.POrderNo = record.POrderNo;
                    purchase.Supplier = new Supplier { Name = record.SupplierName };
                    purchase.SupplierInvNo = record.SupplierInvNo;
                    purchase.SupplierInvDate = record.SupplierInvDate;
                    purchase.CreditPeriod = record.CreditPeriod;
                    purchase.CreditDate = record.CreditDate;
                    purchase.DiscountPercent = record.DiscountPercent;
                    purchase.DiscountAmount = record.DiscountAmount;
                    purchase.TotalAmount = record.TotalAmount;
                    purchase.NetAmount = record.NetAmount;

                    purchase.PaidAmount = record.PaidAmount;
                    purchase.Status = record.Status;
                    purchase.Comment = record.Comment;
                    purchase.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    purchase.AddedDateTime = record.AddedDateTime;
                    purchase.AddedUserName = record.Username;
                    purchases.Add(purchase);
                }

                return purchases;
            }
        }

        public IEnumerable<Purchase> SelectAll()
        {
            throw new NotImplementedException();
        }

        IEnumerable<Purchase> IRepository<Purchase>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<Purchase> IRepository<Purchase>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public List<Purchase> SearchPurchases(PurchaseSearchDTO model)
        {
            List<Purchase> purchases = new List<Purchase>();
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
                var records = _dbConn.Query("SearchPurchase", p, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in records)
                {
                    Purchase purchase = new Purchase();
                    purchase.Id = record.Id;
                    purchase.GrnNo = record.GrnNo;
                    purchase.GrnDate = record.GrnDate;
                    purchase.SupplierInvNo = record.SupplierInvNo;
                    purchase.Supplier = new Supplier { Name = record.SupplierName };
                    purchase.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    purchase.SNo = record.RowNumber;
                    purchase.SaveStatus = record.SaveStatus;
                    purchases.Add(purchase);
                }
                model.TotalRecords = p.Get<int?>("@totalRows").GetValueOrDefault();
                model.TotalPages = p.Get<int?>("@totalPages").GetValueOrDefault();
            }

            return purchases;
        }

        public List<PurchaseItem> GetPurchaseItems(long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetPurchaseItems", new { pharmacyId = tenantId }, commandType: CommandType.StoredProcedure))
                {
                    return resultSet.Read<PurchaseItem>().ToList();
                }
            }
        }

        IEnumerable<Purchase> IRepository<Purchase>.SelectAll()
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                return _dbConn.Query<Purchase>("GetSupplierInvoicesExisting",
                             new { }, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
