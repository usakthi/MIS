using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace Daria.MIS.Core.Entities
{

    [Serializable]
    public class MenuItem
    {
        public int Id { get; set; }
        public string Key { get; set; }
        string _displayImageClass = string.Empty;

        public string DisplayImageClass
        {
            get { return _displayImageClass; }
            set { _displayImageClass = value; }
        }

        public int? ParentId { get; set; }
        public string Url { get; set; }
        public int Order { get; set; }
        public MenuItem ParentMenu { get; set; }
        public List<MenuItem> SubMenus { get; set; }

        string _displayText = string.Empty;
   

        public string DisplayText
        {
            get { return _displayText; }
            set { _displayText = value; }
        }

        public bool IsSelected { get; set; }

    }
    public enum AuthenticationStatus
    {
        UserNotFound,
        ValidUser,
        PasswordMismatch,
        UserAccountLocked,
        InActiveUser,
        Success
    }


    public class Role
    {
        public int Id { get; set; }
        public string RoleName { get; set; }
        public string Description { get; set; }
        public bool IsDeleted { get; set; }

        public long AddedBy { get; set; }
        public DateTime AddedDateTime { get; set; }

        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }


        public string LandingPage { get; set; }

        List<Module> modules = new List<Module>();

        public List<Module> Modules
        {
            get { return modules; }
            set { modules = value; }
        }


        public long PharmacyId { get; set; }

    }

    public class Module
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Key { get; set; }
        public bool IsDeleted { get; set; }
        public long AddedBy { get; set; }
        public DateTime AddedDateTime { get; set; }

        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public bool IsActive { get; set; }
        public bool IsAllowed { get; set; }

        List<Feature> _features = new List<Feature>();

        public List<Feature> Features
        {
            get { return _features; }
            set { _features = value; }
        }

        public bool IsSelected { get; set; }
    }

    public class Feature
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Key { get; set; }
        public bool IsDeleted { get; set; }
        public long AddedBy { get; set; }
        public DateTime AddedDateTime { get; set; }

        public long? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public bool IsActive { get; set; }
        public bool IsAllowed { get; set; }

        public bool ApplyInherited { get; set; }
        public int ParentFeatureId { get; set; }

        public Module Module { get; set; }
        public bool IsSelected { get; set; }

        public int? MenuId { get; set; }

    }

    /// <summary>
    /// Add all the application feature constant here
    /// </summary>
    public enum FeatureConst
    {
        NoAccess,
        SearchUser,
        AddUser,
        UpdateUser,
        DeleteUser,
        AddRole,
        UpdateRole,
        DeleteRole

    }

    public static class Extensions
    {
        /// <summary>
        /// Determines whether the collection is null or contains no elements.
        /// </summary>
        /// <typeparam name="T">The IEnumerable type.</typeparam>
        /// <param name="enumerable">The enumerable, which may be null or empty.</param>
        /// <returns>
        ///     <c>true</c> if the IEnumerable is null or empty; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsNullOrEmpty<T>(this IEnumerable<T> enumerable)
        {
            if (enumerable == null)
            {
                return true;
            }
            /* If this is a list, use the Count property. 
             * The Count property is O(1) while IEnumerable.Count() is O(N). */
            var collection = enumerable as ICollection<T>;
            if (collection != null)
            {
                return collection.Count < 1;
            }
            return enumerable.Any();
        }

        /// <summary>
        /// Determines whether the collection is null or contains no elements.
        /// </summary>
        /// <typeparam name="T">The IEnumerable type.</typeparam>
        /// <param name="collection">The collection, which may be null or empty.</param>
        /// <returns>
        ///     <c>true</c> if the IEnumerable is null or empty; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsNullOrEmpty<T>(this ICollection<T> collection)
        {
            if (collection == null)
            {
                return true;
            }
            return collection.Count < 1;
        }
    }
}
