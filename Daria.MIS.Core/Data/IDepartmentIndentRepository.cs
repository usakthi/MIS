﻿using Daria.MIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.Data
{
    public interface IDepartmentIndentRepository : IRepository<DepartmentIndent>
    {
        void AddIndentHeader(DepartmentIndent indentHeader, IDbConnection conn, IDbTransaction transaction);
        void AddIndentItem(DepartmentIndentItem indentItem, IDbConnection conn, IDbTransaction transaction);

    }

}
