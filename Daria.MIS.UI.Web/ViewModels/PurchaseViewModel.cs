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
    public class PurchaseViewModel
    {
        public Purchase PurchaseInfo { get; set; }

        public User LoggedUserInfo { get; set; }

        public static List<OpenStock> ReadOpenStocks(string file)
        {
            List<OpenStock> openStocks = new List<OpenStock>();

            var type = Path.GetExtension(file);
            FileStream stream = File.Open(file, FileMode.Open, FileAccess.Read);
            IExcelDataReader excelReader = null;
            if (type.Equals(".xls", StringComparison.OrdinalIgnoreCase))
            {
                excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
            }
            else
            {
                excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
            }

            excelReader.IsFirstRowAsColumnNames = true;
            DataSet result = excelReader.AsDataSet();
            if (result.Tables.Count > 0)
            {
                DataTable table = result.Tables[0];
                foreach (DataRow row in table.Rows)
                {
                    OpenStock stk = new OpenStock();
                    stk.DrugId = Convert.ToInt64(row[0]);
                    stk.BatchNo = Convert.ToString(row[1]);
                    stk.ManufacturerId = Convert.ToInt64(row[2]);
                    stk.ExpiryDate = Convert.ToString(row[3]);
                    stk.TotalQty = Convert.ToInt32(row[4]);
                    stk.Packing = Convert.ToInt32(row[5]);
                    stk.AssortedQty = Convert.ToInt32(row[6]);
                    stk.CostPrice = Convert.ToDecimal(row[7]);
                    stk.AssortedCostPrice = Convert.ToDecimal(row[8]);
                    stk.MRP = Convert.ToDecimal(row[9]);
                    stk.AssortedMRPPrice = Convert.ToDecimal(row[10]);
                    stk.VAT = Convert.ToDecimal(row[11]);
                    stk.VATType = Convert.ToString(row[12]);
                    stk.VATAmount = Convert.ToDecimal(row[13]);

                    openStocks.Add(stk);
                }
            }




            excelReader.Close();

            return openStocks;
        }
    }
}