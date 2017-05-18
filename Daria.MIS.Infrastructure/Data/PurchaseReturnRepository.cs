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
    public class PurchaseReturnRepository : IPurchaseReturnRepository
    {
        private IDbConnection _dbConn;

        public void Insert(PurchaseReturn model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddPurchaseReturnHeader(model, _dbConn, transaction);
                        if (model.PurchaseReturnItems != null)
                        {
                            foreach (PurchaseReturnItem item in model.PurchaseReturnItems)
                            {

                                item.PurchaseId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddPurchaseReturnItem(item, _dbConn, transaction);

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

        public void AddPurchaseReturnHeader(PurchaseReturn purchaseHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddPurchaseReturnHeader",
                                new
                                {
                                    pharmacyId = purchaseHeader.PharmacyId,
                                    returnNo = purchaseHeader.ReturnNo,
                                    returnDate = purchaseHeader.GrnDate,
                                    grnNo = purchaseHeader.GrnNo,
                                    grnDate = purchaseHeader.GrnDate,
                                    supplierId = purchaseHeader.SupplierId,
                                    supInvNo = purchaseHeader.SupplierInvNo,
                                    supInvDate = purchaseHeader.SupplierInvDate,
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
                                    savedUserId = purchaseHeader.SavedUser.UserId
                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            purchaseHeader.Id = output.Key;
            purchaseHeader.GrnNo = output.Value;
        }

        public void AddPurchaseReturnItem(PurchaseReturnItem purchaseItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            purchaseItem.Id = dbConn.Query<int>("AddPurchaseReturnItem",
                                new
                                {
                                    pharmacyId = purchaseItem.PharmacyId,
                                    prHeaderId = purchaseItem.PurchaseId,
                                    productId = purchaseItem.ProductId,
                                    batchNo = purchaseItem.BatchNo,
                                    qty = purchaseItem.Qty,

                                    manfId = purchaseItem.ManufacturerId,
                                    expDate = purchaseItem.ExpDate,
                                    packing = purchaseItem.Packing,
                                    assortedQty = purchaseItem.AssortedQty,
                                    CostPrice = purchaseItem.CostPrice,
                                    MRP = purchaseItem.MRP,
                                    VAT = purchaseItem.VAT,

                                    abatedMRP = purchaseItem.AbatedMRP,
                                    TaxMode = purchaseItem.TaxMode,
                                    TaxType = purchaseItem.TaxType,
                                    
                                    DiscountPercentage = purchaseItem.DiscountPercentage,
                                    DiscountAmount = purchaseItem.DiscountAmount,
                                    AssortedCostPrice = purchaseItem.AssortedCostPrice,
                                    AssortedMRPPrice = purchaseItem.AssortedMRPPrice,
                                    VATAmount = purchaseItem.VATAmount,
                                    TotalCostPrice = purchaseItem.TotalCostPrice,
                                    NetCostPrice = purchaseItem.NetCostPrice,
                                    TotalMRP = purchaseItem.TotalMRP,
                                    NetMRP = purchaseItem.NetMRP,

                                    AddedBy = purchaseItem.AddedPerson.PersonId,
                                    AddedDateTime = purchaseItem.AddedDateTime,
                                    PurDetId = purchaseItem.PurDetId
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public PurchaseReturn Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetPurchaseDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<PurchaseReturn>().FirstOrDefault();

                    if (purchase != null)
                    {
                        purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.PurchaseReturnItems = resultSet.Read<PurchaseReturnItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public PurchaseReturn Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(PurchaseReturn model)
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

        public bool Update(PurchaseReturn model)
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
                        p.Add("@supplierId", model.SupplierId);
                        p.Add("@supInvNo", model.SupplierInvNo);
                        p.Add("@supInvDate", model.SupplierInvDate);
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
                        p.Add("@savedUserId", model.SavedUser.UserId);
                        p.Add("@RowsAffected", dbType: DbType.Int32, direction: ParameterDirection.Output);
                        _dbConn.Execute("UpdatePurchaseReturnHeader", p, transaction: transaction, commandType: CommandType.StoredProcedure);
                        var rowsAffected = p.Get<int>("@RowsAffected");

                        if (model.PurchaseReturnItems != null)
                        {
                            foreach (PurchaseReturnItem item in model.PurchaseReturnItems)
                            {
                                item.PurchaseId = model.Id;
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                item.UpdatedBy = model.UpdatedBy;
                                item.UpdatedDateTime = model.UpdatedDateTime;
                                this.AddPurchaseReturnItem(item, _dbConn, transaction);
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

        public IEnumerable<PurchaseReturn> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<PurchaseReturn> purchases = new List<PurchaseReturn>();
                var result = _dbConn.Query("GetPurchaseListForReturn",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    PurchaseReturn purchase = new PurchaseReturn();
                    purchase.Id = record.Id;
                    purchase.RetNo = record.RetNo;
                    purchase.RetDate = record.RetDate;
                    purchase.Supplier = new Supplier { Name = record.SupplierName };
                    purchase.SupplierInvNo = record.SupplierInvNo;
                    purchase.SupplierInvDate = record.SupplierInvDate;
                    purchase.DiscountPercent = record.DiscountPercent;
                    purchase.DiscountAmount = record.DiscountAmount;
                    purchase.TotalAmount = record.TotalAmount;
                    purchase.NetAmount = record.NetAmount;

                    purchase.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    purchase.AddedDateTime = record.AddedDateTime;
                    purchase.AddedUserName = record.Username;
                    purchases.Add(purchase);
                }

                return purchases;
            }
        }

        IEnumerable<PurchaseReturn> IRepository<PurchaseReturn>.SelectAll(string ph)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                var resultSet = _dbConn.QueryMultiple("GetProductsForPurchaseReturn", new { q = ph }, commandType: CommandType.StoredProcedure);
                List<PurchaseReturn> productList = new List<PurchaseReturn>();
                var products = resultSet.Read();

                foreach (dynamic p in products)
                {
                    PurchaseReturn prod = new PurchaseReturn();
                    prod.SlNo = p.Slno;
                    prod.Id = p.Id;
                    prod.ProductId = p.ProductId;
                    prod.Name = p.DrugName;
                    prod.Category = p.Category;

                    prod.Stock = p.Stock;
                    prod.PurStk = p.PurStk;
                    prod.BatchNo = p.BatchNo;
                    prod.ExpDate = p.ExpDate;
                    prod.PurDetId = p.PurDetId;
                    prod.MfgName = p.MfgName;
                    prod.MfgId = p.ManfId;

                    prod.MRP = p.MRP;
                    prod.CostPrice = p.CostPrice;
                    prod.VAT = p.VAT;
                    prod.Pack = p.Pack;
                    prod.TaxMode = p.TaxMode;
                    prod.TaxType = p.TaxType;
                    prod.DiscountPercent = p.DiscPercent;

                    productList.Add(prod);
                }

                return productList;
            }
        }

        IEnumerable<PurchaseReturn> IRepository<PurchaseReturn>.SelectAll(string ph, string category)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<PurchaseReturn> purchases = new List<PurchaseReturn>();
                var result = _dbConn.Query("GetSupplierInvoices",
                            new { q = ph, cat = category }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    PurchaseReturn purchase = new PurchaseReturn();
                    purchase.Id = record.Id;
                    purchase.Name = record.Name;
                    purchase.SupplierInvNo = record.SupplierInvNo;

                    purchases.Add(purchase);
                }

                return purchases;
            }
        }

        public IEnumerable<PurchaseReturn> SelectAll()
        {
            throw new NotImplementedException();
        }

        public PurchaseReturn FindPurchasedItems(string no, string category)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetPurchasedItems", new { no = no, category = category }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<PurchaseReturn>().FirstOrDefault();

                    return purchase;
                }
            }

        }
    }
}
