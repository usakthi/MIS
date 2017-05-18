using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Daria.MIS.Core.Entities;
using Excel;
using System.IO;
using System.Data;

namespace Daria.MIS.UI.Web
{
    public class EditedBillViewModel
    {
        public EditedBill PurchaseInfo { get; set; }

        public User LoggedUserInfo { get; set; }

    }
}