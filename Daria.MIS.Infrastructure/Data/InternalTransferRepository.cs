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
    public class InternalTransferRepository : IInternalTransferRepository
    {
        private IDbConnection _dbConn;

        public void Insert(IntTrans model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddBillHeader(model, _dbConn, transaction);
                        if (model.IntTransItems != null)
                        {
                            foreach (IntTransItem item in model.IntTransItems)
                            {

                                item.IntTransCode = model.Id;
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


        public void AddBillHeader(IntTrans billHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddInternalTransferHeader",
                                new
                                {
                                    pharmacyId = billHeader.PharmacyId,
                                    customer = billHeader.Customer,
                                    consultantName = billHeader.ConsultantName,
                                    //totalAmount = billHeader.TotalAmount,
                                    totalAmount = billHeader.NetAmount,
                                    discountPercent = billHeader.DiscountPercent,
                                    discount = billHeader.Discount,
                                    netAmount = billHeader.NetAmount,
                                    totalVAT = billHeader.TotalVAT,
                                    paidAmount = billHeader.PaidAmount,
                                    balance = billHeader.Balance,
                                    roundOff = billHeader.RoundOff,
                                    billstatus = billHeader.BillStatus,
                                    AddedBy = billHeader.AddedPerson.PersonId,
                                    AddedDateTime = billHeader.AddedDateTime,
                                    savedUserId = billHeader.SavedUser.UserId

                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            billHeader.Id = output.Key;
            billHeader.BillNo = output.Value;
        }

        public void AddBillItem(IntTransItem billItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            billItem.Id = dbConn.Query<int>("AddInternalTransferItem",
                                new
                                {
                                    pharmacyId = billItem.PharmacyId,
                                    IntTransCode = billItem.IntTransCode,
                                    productId = billItem.ProductId,
                                    batchNo = billItem.BatchNo,
                                    qty = billItem.Qty,
                                    mfgId = (billItem.ManufacturerId == 0) ? (long?)null : billItem.ManufacturerId,
                                    
                                    expiryDate = billItem.ExpDate,
                                    GRNNo = billItem.GRNNo,
                                    CostPrice = billItem.CostPrice,
                                    totalcostprice = billItem.TotalCostPrice, 
                                    MRP = billItem.MRP,
                                    totalMRP = billItem.TotalMRP,
                                    taxPercent = billItem.VAT,
                                    taxAmount = billItem.TaxAmount,
                                    discPercent = billItem.DiscPercent,
                                    discount = billItem.Discount,
                                    cancelFlag = (billItem.CancelFlag == 0)? (long?)null : billItem.CancelFlag,
                                    editProduct = (billItem.EditProduct == 0) ? (long?)null : billItem.EditProduct,
                                    oldQty = billItem.Stock,
                                    AddedBy = billItem.AddedPerson.PersonId,
                                    AddedDateTime = billItem.AddedDateTime,
                                    PurDetId = billItem.PurDetId
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public IntTrans Find(object id, long tenantId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetTransferDetails", new { pharmacyId = tenantId, pId = id }, commandType: CommandType.StoredProcedure))
                {

                    var purchase = resultSet.Read<IntTrans>().FirstOrDefault();

                    if (purchase != null)
                    {
                        //purchase.Supplier = new Supplier { Id = purchase.SupplierId };
                        purchase.Id = (long)id;
                        purchase.IntTransItems = resultSet.Read<IntTransItem>().ToList();
                    }
                    return purchase;
                }
            }

        }

        public IntTrans Find(object id)
        {
            throw new NotImplementedException();
        }



        public bool Delete(IntTrans model)
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

        public bool Update(IntTrans model)
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

                        if (model.IntTransItems != null)
                        {
                            foreach (IntTransItem item in model.IntTransItems)
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

        public IEnumerable<IntTrans> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<IntTrans> bills = new List<IntTrans>();
                var result = _dbConn.Query("GetTransferList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    IntTrans bill = new IntTrans();
                    bill.Id = record.BillCode;
                    bill.BillNo = record.BillNo;
                    bill.BillDate = record.BillDate;
                    bill.Customer = record.Customer;
                    bill.TotalAmount = record.TotalAmount;
                    bill.TotalVAT = record.TotalVat;
                    bill.NetAmount = record.NetAmount;
                    bill.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    bill.AddedDateTime = record.AddedDateTime;
                    bill.AddedUserName = record.Username;
                    bills.Add(bill);
                }

                return bills;
            }
        }

        IEnumerable<IntTrans> IRepository<IntTrans>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }
        IEnumerable<IntTrans> IRepository<IntTrans>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }
        public IEnumerable<IntTrans> SelectAll()
        {
            throw new NotImplementedException();
        }
    }
}
