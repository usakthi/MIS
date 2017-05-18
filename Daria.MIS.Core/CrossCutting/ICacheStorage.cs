using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daria.MIS.Core.CrossCutting
{
    public interface ICacheStorage
    {
        void Remove(string key);
        void Add(string key, object data);
        T Retrieve<T>(string storageKey);
    }
}
