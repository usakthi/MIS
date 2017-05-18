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
    public class DueBillsRepository : IDueBillsRepository
    {
        private IDbConnection _dbConn;

        public void Insert(DueBills model)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var transaction = _dbConn.BeginTransaction())
                {
                    try
                    {
                        this.AddDueBills(model, _dbConn, transaction);

                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                    }
                }
            }
        }

        public void AddDueBills(DueBills dueBillsHeader, IDbConnection dbConn, IDbTransaction transaction)
        {
            var output = dbConn.Query<KeyValuePair<int, string>>("AddDueBills",
                                new
                                {
                                    pharmacyId = dueBillsHeader.PharmacyId,
                                    billCode = dueBillsHeader.BillCode,
                                    netAmount = dueBillsHeader.NetAmount,
                                    duePaidAmount = dueBillsHeader.DuePaidAmount,
                                    dueAmount = dueBillsHeader.DueAmount,
                                    roundOff = dueBillsHeader.RoundOff,
                                    payMode = dueBillsHeader.PayMode,
                                    AddedBy = dueBillsHeader.AddedPerson.PersonId,
                                    AddedDateTime = dueBillsHeader.AddedDateTime,
                                    savedUserId = dueBillsHeader.SavedUser.UserId

                                },
                                    transaction: transaction,
                                    commandType: CommandType.StoredProcedure).First();

            dueBillsHeader.Id = output.Key;
            dueBillsHeader.BillNo = output.Value;
        }

        public DueBills Find(object id, long tenantId)
        {
            throw new NotImplementedException();
        }

        public DueBills Find(object id)
        {
            throw new NotImplementedException();
        }

        public bool Delete(DueBills model)
        {
            throw new NotImplementedException();
        }

        public bool Update(DueBills model)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DueBills> SelectAll(int pharmaId)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                List<DueBills> adjusts = new List<DueBills>();
                var result = _dbConn.Query("GetDueBillsList",
                            new { pharmacyId = pharmaId }, commandType: CommandType.StoredProcedure);

                foreach (dynamic record in result)
                {
                    DueBills adjust = new DueBills();
                    adjust.Id = record.SNo;
                    adjust.Customer = record.Customer;
                    adjust.BillNo = record.BillNo;
                    adjust.BillDate = record.BillDate;
                    adjust.ConsultantName = record.ConsultantName;
                    adjust.TotalAmount = record.TotalAmount;
                    adjust.Discount = record.Discount;
                    adjust.NetAmount = record.NetAmount;
                    adjust.PaidAmount = record.PaidAmount;
                    adjust.Balance = record.Balance;
                    adjust.SalesMode = record.SalesMode;
                    adjust.UserName = record.UserName;
                    adjusts.Add(adjust);
                }

                return adjusts;
            }
        }

        IEnumerable<DueBills> IRepository<DueBills>.SelectAll(string ph)
        {
            throw new NotImplementedException();
        }

        IEnumerable<DueBills> IRepository<DueBills>.SelectAll(string ph, string category)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DueBills> SelectAll()
        {
            throw new NotImplementedException();
        }

        public DueBills FindDueBillItems(string no, string category)
        {
            using (_dbConn = DBHelper.GetOpenConnection())
            {
                using (var resultSet = _dbConn.QueryMultiple("GetDueBillItems", new { no = no, category = category }, commandType: CommandType.StoredProcedure))
                {
                    var purchase = resultSet.Read<DueBills>().FirstOrDefault();

                    return purchase;
                }
            }

        }
    }
}
