using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.Owin.Security;
using Daria.MIS.Core.Services;
using Daria.MIS.Core.Entities;
using System.Web.Security;

namespace Daria.MIS.UI.Web.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        private readonly IAccountService AccountService;

        public AccountController(IAccountService _service)
        {
            AccountService = _service;
        }

        public ActionResult Index()
        {
            return View();
        }

        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        [AllowAnonymous]
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult Login(LoginViewModel model)
        {

            User user = new User();

            user = AccountService.GetUserLogonDetails(model.UserName, model.Password);

            if (user.LoginStatus == AuthenticationStatus.Success)
            {
                 //string uuser = new HttpContext.Current(User.Identity.Name);

                Session["CurrentUser"] = user;
                var authTicket = new FormsAuthenticationTicket(1, user.UserName, DateTime.Now,
                                                   DateTime.Now.AddMinutes(120), true,
                                                   user.PharmacyId + "___" + string.Join(",", user.Role.RoleName));

                string cookieContents = FormsAuthentication.Encrypt(authTicket);
                var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, cookieContents)
                {
                    Expires = authTicket.Expiration,
                    Path = FormsAuthentication.FormsCookiePath
                };
                if (HttpContext != null)
                {
                    HttpContext.Response.Cookies.Add(cookie);
                    HttpContext.Session["ContextPharmacyId"] = user.PharmacyId;                                       
                }

                if (!string.IsNullOrEmpty(user.Role.LandingPage))
                {
                   return RedirectToAction("Index", user.Role.LandingPage);
                }
               
               return RedirectToAction("Index", "Home", new { });

            }

            return View("Login", model);
        }

        public ActionResult UnAuthorized()
        {
            return View();
        }

        [AllowAnonymous]
        [HttpGet]
        public ActionResult ForgotPassword()
        {
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult ForgotPassword(ForgotPasswordViewModel model)
        {

            User user = new User();

            if (model.NewPassword != model.ConfirmPassword)
            {
                //Redirect to Forger Password...
            }
            else
            {
                user = AccountService.GetUserLogonDetails(model.UserName, model.OldPassword);

                if (user.LoginStatus == AuthenticationStatus.Success)
                {
                    user = AccountService.UserResetPassword(model.UserName, model.ConfirmPassword);

                    Session["CurrentUser"] = user;
                    var authTicket = new FormsAuthenticationTicket(1, user.UserLogin, DateTime.Now,
                                                       DateTime.Now.AddMinutes(30), true,
                                                       user.PharmacyId + "___" + string.Join(",", user.Role.RoleName));

                    string cookieContents = FormsAuthentication.Encrypt(authTicket);
                    var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, cookieContents)
                    {
                        Expires = authTicket.Expiration,
                        Path = FormsAuthentication.FormsCookiePath
                    };
                    if (HttpContext != null)
                    {
                        HttpContext.Response.Cookies.Add(cookie);
                        HttpContext.Session["ContextPharmacyId"] = user.PharmacyId;
                    }

                    if (!string.IsNullOrEmpty(user.Role.LandingPage))
                    {
                        return RedirectToAction("Index", user.Role.LandingPage);
                    }

                    return RedirectToAction("Index", "Home", new { });

                }
            }
            return View("ForgotPassword", model);
        }
    }
}