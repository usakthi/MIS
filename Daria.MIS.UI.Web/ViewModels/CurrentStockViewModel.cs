﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Daria.MIS.Core.Entities;

namespace Daria.MIS.UI.Web
{
    public class CurrentStockViewModel
    {
        public CurrentStock PurchaseInfo { get; set; }

        public User LoggedUserInfo { get; set; }
    }
}