using Daria.MIS.Core.Entities;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Daria.MIS.UI.Web
{
    public class UserMenuFilter : ActionFilterAttribute
    {
        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            if (!filterContext.RequestContext.HttpContext.Request.IsAjaxRequest())
            {
                var filterAttribute = filterContext.ActionDescriptor.GetFilterAttributes(true)
                                    .Where(a => a.GetType() == typeof(UserMenuFilter));
                if (filterAttribute != null)
                {
                    User currentLoggedInUser = (User)filterContext.HttpContext.Session["CurrentUser"];

                    if (currentLoggedInUser == null)
                    {
                        string unAuthorizedUrl = new UrlHelper(filterContext.RequestContext).RouteUrl(new { controller = "Account", action = "UnAuthorized" });
                        filterContext.HttpContext.Response.Redirect(unAuthorizedUrl);
                    }
                    else
                    {
                        filterContext.Controller.ViewBag.UserMenu = ACLAccessHelper.GetAccessibleMenuForUser(currentLoggedInUser, filterContext.RouteData);
                    }
                }
            }
        }
    }
}
