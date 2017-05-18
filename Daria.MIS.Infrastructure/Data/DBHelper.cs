using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace Daria.MIS.Infrastructure.Data
{
    class DBHelper
    {
        public static SqlConnection GetOpenConnection()
        {
            var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MISDBConn"].ConnectionString);
            connection.Open();
            return connection;
        }
    }
}
