using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Services
{
    public interface IDueBillsService
    {
        void AddDueBills(DueBills dueBillsEntry);
        List<DueBills> GetDueBillsList(int pharmacyId);

        DueBills GetDueBillItems(string no, string category);
    }
}
