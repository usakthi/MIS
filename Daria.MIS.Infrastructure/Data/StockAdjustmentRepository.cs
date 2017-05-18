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
    public class StockAdjustmentRepository : IStockAdjustmentRepository
    {
        private IDbConnection _dbConn;

        public void Insert(StockAdjustment model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddStockAdjustment(model, _dbConn, transaction);

                        if (model.StockAdjustmentItems != null)
                        {
                            foreach (StockAdjustmentItem item in model.StockAdjustmentItems)
                            {
                                item.PharmacyId = model.PharmacyId;
                                item.AddedPerson = model.AddedPerson;
                                item.AddedDateTime = model.AddedDateTime;
                                this.AddStockAdjustmentItem(item, _dbConn, transaction);
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

        public void AddStockAdjustment(StockAdjustment adjustHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            // throw new NotImplementedException();
        }

        public void AddStockAdjustmentItem(StockAdjustmentItem adjustItem, IDbConnection dbConn, IDbTransaction transaction)
        {
            adjustItem.Id = dbConn.Query<int>("AddStockAdjustment",
                                new
                                {
                                    pharmacyId = adjustItem.PharmacyId,
                                    productId = adjustItem.ProductId,
                                    qty = adjustItem.Qty,
                                    curStk = adjustItem.CurStk,
                                    pur = adjustItem.Pur,
                                    purRet = adjustItem.PurRet,
                                    sal = adjustItem.Sal,
                                    salRet = adjustItem.SalRet,
                                    openstk = adjustItem.OpenStk,
                                    stkadj = adjustItem.StkAdj,

                                    MRP = adjustItem.MRP,
                                    premrp = adjustItem.PreMRP,
                                    purDetId = adjustItem.PurDetId,
                                    AddedBy = adjustItem.AddedPerson.PersonId,
                                    AddedDateTime = adjustItem.AddedDateTime,
                                    SavedUser = adjustItem.AddedPerson.PersonId //adjustItem.SavedUser.UserId
                                },
                                transaction: transaction,
                                commandType: CommandType.StoredProcedure).Single();
        }

        public StockAdjustment Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        public StockAdjustment Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(StockAdjustment model)
        {
            throw new NotImplementedException();
        }

        public bool Update(StockAdjustment model)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<StockAdjustment> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<StockAdjustment> adjusts = new List<StockAdjustment>();
                var result = _dbConn.Query("GetStockAdjustmentList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    StockAdjustment adjust = new StockAdjustment();
                    adjust.Id = record.SNo;
                    adjust.ProductName = record.DrugName;
                    adjust.BatchNo = record.BatchNo;
                    adjust.ExpiryDate = record.ExpiryDate;
                    adjust.Qty = record.Qty;
                    adjust.PreMRP = record.PreMRP;
                    adjust.Pur = record.Pur;
                    adjust.PurRet = record.PurRet;
                    adjust.Sal = record.Sal;
                    adjust.SalRet = record.SalRet;
                    adjust.ManufacturerName = record.Mfg;
                    
                    //adjust.AddedPerson = new Person { FirstName = record.AddedFirstName, LastName = record.AddedLastName };
                    //adjust.AddedDateTime = record.AddedDateTime;
                    adjust.UserName = record.UserName;
                    adjusts.Add(adjust);
                }

                return adjusts;
            }
        }

        IEnumerable<StockAdjustment> IRepository<StockAdjustment>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<StockAdjustment> IRepository<StockAdjustment>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<StockAdjustment> SelectAll()
        {
            throw new NotImplementedException();
        }
    }
}
