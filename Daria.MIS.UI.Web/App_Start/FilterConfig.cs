using System.Web;
using System.Web.Mvc;

namespace Daria.MIS.UI.Web
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new ElmahHandleErrorAttribute());
        }
    }
}
