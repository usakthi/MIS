using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using System.Resources;
using System.Web.Routing;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Collections;
using Daria.MIS.Core.Entities;
using MoreLinq;
using Daria.MIS.Core.CrossCutting;
using Daria.MIS.Core.Services;

namespace Daria.MIS.UI.Web
{
    public class FeatureAuthenticationAttribute : FilterAttribute, IAuthorizationFilter
    {
        //public FeatureConst AllowFeature { get; set; }

        public void OnAuthorization(AuthorizationContext filterContext)
        {
            bool allowed = false;
            if (ACLAccessHelper.IsGlobalAdmin())
            {
                return;
            }
            Feature feature = ACLAccessHelper.GetFeatureByAction(filterContext);
            if (feature != null)
            {

                User currentLoggedInUser = (User)filterContext.HttpContext.Session["CurrentUser"];
                allowed = ACLAccessHelper.IsAccessible(feature.Key, currentLoggedInUser);

            }

            if (!allowed)
            {
                filterContext.HttpContext.Response.StatusCode = 403;

                if (filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    filterContext.Result = new JsonResult
                    {
                        Data = new { Redirect = "/error/noAccess" },
                        ContentEncoding = System.Text.Encoding.UTF8,
                        ContentType = "application/json",
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet
                    };

                }
                else
                {
                    string unAuthorizedUrl = new UrlHelper(filterContext.RequestContext).RouteUrl(new { controller = "home", action = "UnAuthorized" });
                    filterContext.HttpContext.Response.Redirect(unAuthorizedUrl);
                }

            }

        }
    }

    public class ACLAccessHelper
    {

        public static Feature GetFeatureByAction(AuthorizationContext filterContext)
        {
            var actionDesc = filterContext.ActionDescriptor;
            var accountService = (IAccountService)DependencyResolver.Current.GetService(typeof(IAccountService));
            var allActions = accountService.GetAllActionDetails();
            if (!allActions.IsNullOrEmpty())
            {

                var matched = allActions.FindAll(a => string.Equals(a.ActionName, actionDesc.ActionName, StringComparison.OrdinalIgnoreCase)
                 && string.Equals(a.ControllerName, actionDesc.ControllerDescriptor.ControllerName, StringComparison.OrdinalIgnoreCase));

                if (!matched.IsNullOrEmpty())
                {
                    var returnFeature = matched.First().Feature;

                    if (matched.Count > 1)
                    {
                        // matched.Find(m=>string.Equals(m.ActionType,actionDesc.GetFilterAttributes.))
                    }

                    return returnFeature;
                }
            }
            return null;


        }
        public static bool IsAccessible(string featureKey, Role role)
        {
            List<Feature> featuresFound = new List<Feature>();
          
                if (!role.Modules.IsNullOrEmpty())
                {
                    foreach (Module module in role.Modules)
                    {
                        var features = module.Features.Where(f => string.Equals(f.Key, featureKey, StringComparison.OrdinalIgnoreCase));
                        if (features != null)
                        {
                            featuresFound.AddRange(features);
                        }
                    }
                
            }

            if (featuresFound.Count > 0)
            {
                return true;
            }

            return false;
        }
        private static List<Feature> GetAccessibleFeatures(Role role)
        {
            List<Feature> featuresFound = new List<Feature>();
          
                if (!role.Modules.IsNullOrEmpty())
                {
                    foreach (Module module in role.Modules)
                    {
                        if (!module.Features.IsNullOrEmpty())
                        {
                            featuresFound.AddRange(module.Features);
                        }
                    }
                }
            

            return featuresFound.DistinctBy(f => f.Key).ToList();


        }

        public static bool IsAccessible(string featureKey)
        {
            User currentLoggedInUser = (User)HttpContext.Current.Session["CurrentUser"];
            return IsAccessible(featureKey, currentLoggedInUser);
        }
        public static bool IsGlobalAdmin()
        {
            User currentLoggedInUser = (User)HttpContext.Current.Session["CurrentUser"];
            if (currentLoggedInUser.UserType == UserType.GlobalAdmin)
            {
                return true;
            }
            return false;
        }
        public static bool IsAccessible(string featureKey, User user)
        {
            if (user.UserType == UserType.GlobalAdmin)
            {
                return true;
            }
            return IsAccessible(featureKey, user.Role);
        }

        public static List<MenuItem> GetAccessibleMenuForUser(User user, RouteData routeData)
        {
            List<Feature> featuresAccessible = GetAccessibleFeatures(user.Role);
            List<MenuItem> accessibleMenu = new List<MenuItem>();

            var store = (ICacheStorage)DependencyResolver.Current.GetService(typeof(ICacheStorage));
            var metaService = (IMasterDataService)DependencyResolver.Current.GetService(typeof(IMasterDataService));
            var allMenus = metaService.GetAllActiveMenuItems();
            if (allMenus != null)
            {
                var clonedMenu = DeepClone<List<MenuItem>>(allMenus);
                accessibleMenu = PopulateMenuByFeatures(featuresAccessible, clonedMenu, routeData);
                accessibleMenu = OrderMenuListHierarchy(accessibleMenu);
                return accessibleMenu.OrderBy(m => m.Order).ToList();
            }
            return accessibleMenu;

        }

        

        private static List<MenuItem> OrderMenuListHierarchy(List<MenuItem> menuItems)
        {
            if (menuItems.IsNullOrEmpty())
            {
                return menuItems;
            }


            var groups = menuItems.GroupBy(i => i.ParentId);

            var roots = groups.FirstOrDefault(g => g.Key.HasValue == false).ToList();

            if (roots.Count > 0)
            {
                var dict = groups.Where(g => g.Key.HasValue).ToDictionary(g => g.Key.Value, g => g.ToList());
                for (int i = 0; i < roots.Count; i++)
                    AddChildren(roots[i], dict);
            }

            return roots;
        }

        private static void AddChildren(MenuItem node, IDictionary<int, List<MenuItem>> source)
        {
            if (source.ContainsKey(node.Id))
            {
                node.SubMenus = source[node.Id];
                for (int i = 0; i < node.SubMenus.Count; i++)
                    AddChildren(node.SubMenus[i], source);
            }
            else
            {
                node.SubMenus = new List<MenuItem>();
            }
        }

        private static List<MenuItem> PopulateMenuByFeatures(List<Feature> features, List<MenuItem> allMenus, RouteData routeData)
        {
            List<MenuItem> menuList = new List<MenuItem>();

          
            if (!features.IsNullOrEmpty())
            {
                foreach (Feature feature in features)
                {
                    MenuItem item = allMenus.Find(m => (m.Id == feature.MenuId));
                    if (item != null)
                    {
                        if (menuList.Find(m => m.Id == item.Id) == null)
                        {


                            menuList.Add(item);
                        }
                        while (item.ParentId != null)
                        {
                            var parent = allMenus.Single(m => m.Id == item.ParentId);
                            if (item.IsSelected) { parent.IsSelected = true; }
                            if (menuList.Find(m => m.Id == parent.Id) == null)
                            {

                                menuList.Add(parent);
                            }
                            item = parent;
                        }
                    }
                }
            }
            return menuList.DistinctBy(m => m.Id).ToList();
        }

        public static T DeepClone<T>(T obj)
        {
            using (var ms = new MemoryStream())
            {
                var formatter = new BinaryFormatter();
                formatter.Serialize(ms, obj);
                ms.Position = 0;

                return (T)formatter.Deserialize(ms);
            }
        }

    }
}