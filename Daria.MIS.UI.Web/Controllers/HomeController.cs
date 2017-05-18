using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Daria.MIS.UI.Web.Controllers
{
    [UserMenuFilter]
    public class HomeController : Controller
    {
        
        public ActionResult Index()
        {
            return View();
        }
	public ActionResult UnAuthorized()
        {
            return View();
        }
    }
}