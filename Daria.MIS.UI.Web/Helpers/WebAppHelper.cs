using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace Daria.MIS.UI.Web
{
    public static class WebAppHelper
    {
        public static DateTime GetCurrentDateTime(){
            return DateTime.Now;
        }

        public static string Obfuscate(string param)
        {

            string KEY = HttpContext.Current.Session.SessionID;
            var key = Encoding.ASCII.GetBytes(KEY.Substring(0, 8));

            var des = new DESCryptoServiceProvider();
            Byte[] inputByteArray = Encoding.ASCII.GetBytes(param);
            var ms = new MemoryStream();
            var cs = new CryptoStream(ms, des.CreateEncryptor(key, key), CryptoStreamMode.Write);
            cs.Write(inputByteArray, 0, inputByteArray.Length);
            cs.FlushFinalBlock();
            return ToBase64Url(Convert.ToBase64String(ms.ToArray()));
        }

        public static string Deobfuscate(string param)
        {
            string KEY = HttpContext.Current.Session.SessionID;

            var key = Encoding.ASCII.GetBytes(KEY.Substring(0, 8));

            var des = new DESCryptoServiceProvider();
            var pm = FromBase64Url(param);
            var inputByteArray = Convert.FromBase64String(pm);
            var ms = new MemoryStream();
            var cs = new CryptoStream(ms, des.CreateDecryptor(key, key), CryptoStreamMode.Write);
            cs.Write(inputByteArray, 0, inputByteArray.Length);
            cs.FlushFinalBlock();

            return Encoding.ASCII.GetString(ms.ToArray());
        }

        static string ToBase64Url(string base64)
        {
            return base64.Replace("/", "_").Replace("+", "-");
        }

        static string FromBase64Url(string base64Url)
        {
            return base64Url.Replace("_", "/").Replace("-", "+");
        }
    }
}