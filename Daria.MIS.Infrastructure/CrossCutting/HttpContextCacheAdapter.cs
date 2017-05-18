using Daria.MIS.Core.CrossCutting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Daria.MIS.Infrastructure.CrossCutting
{
    public class HttpContextCacheAdapter : ICacheStorage
    {
        public void Remove(string key)
        {
            HttpRuntime.Cache.Remove(key);            
        }

        public void Add(string key, object data)
        {
            if (data != null)
            {
                HttpRuntime.Cache.Insert(key, data);                
            }
        }

        public T Retrieve<T>(string key)
        {            
            T itemStored = (T)HttpRuntime.Cache.Get(key);
            if (itemStored == null)
                itemStored = default(T);

            return itemStored;
        }
    }
}
