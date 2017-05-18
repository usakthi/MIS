using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Daria.MIS.Core.Data;
using Daria.MIS.Core.Services;
using Daria.MIS.Core.Entities;

namespace Daria.MIS.Infrastructure.Services
{
    public class DueBillsService : IDueBillsService
    {
        private readonly IDueBillsRepository repository;

        public DueBillsService(IDueBillsRepository _stockAdjustmentRep)
        {
            repository = _stockAdjustmentRep;

        }

        public void AddDueBills(DueBills dueBillsEntry)
        {
            repository.Insert(dueBillsEntry);
        }

        public List<DueBills> GetDueBillsList(int pharmacyId)
        {
            return repository.SelectAll(pharmacyId).ToList();
        }

        public DueBills GetDueBillItems(string no, string category)
        {
            return repository.FindDueBillItems(no, category);
        }
       
    }
}
