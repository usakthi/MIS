using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BCrypt.Net;
using System.Security.Cryptography;

namespace Daria.MIS.Utils
{
    public static class SecurityHelper
    {
        public static string Encrypt(string strEnc)
        {
            return PBKDF2PasswordHash.CreateHash(strEnc);
            //return BCrypt.Net.BCrypt.HashPassword(strEnc, BCrypt.Net.BCrypt.GenerateSalt(12));
        }

        public static bool IsMatchEncryptText(string normal, string encrypted)
        {
            return PBKDF2PasswordHash.ValidatePassword(normal, encrypted);
            //return BCrypt.Net.BCrypt.Verify(normal, encrypted);
        }

        public static string CreateRandomPassword(int passwordLength)
        {
            string allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789";
            char[] chars = new char[passwordLength];
            Random rd = new Random();

            for (int i = 0; i < passwordLength; i++)
            {
                chars[i] = allowedChars[rd.Next(0, allowedChars.Length)];
            }

            return new string(chars);
        }

        public static string GetMD5HashString(string text)
        {
            using (MD5 md5Hash = MD5.Create())
            {
                return GetMd5Hash(md5Hash, text);
            }            
        }

        static string GetMd5Hash(MD5 md5Hash, string input)
        {

            // Convert the input string to a byte array and compute the hash. 
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes 
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data  
            // and format each one as a hexadecimal string. 
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string. 
            return sBuilder.ToString();
        }
    }
}
