using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text.RegularExpressions;

namespace Helper
{
	public static class Helper
	{
		public static int IntParse(string value)
		{
			const int OFFSET = 48; // The method relies on the ASCII values of characters. The character "1" is offset +48 from the integer 1 in ASCII.
			int result = 0;
			for (int i = 0; i != value.Length; i++)
				result = 10 * result + (value[i] - OFFSET);
			return result;
		}

		public static char ToLower(char c)
		{
			const string _lookupStringL = "---------------------------------!-#$%&-()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[-]^_`abcdefghijklmnopqrstuvwxyz{|}~-";
			return _lookupStringL[c];
		}

		public static char ToUpper(char c)
		{
			const string _lookupStringU = "---------------------------------!-#$%&-()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[-]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~-";
			return _lookupStringU[c];
		}

		public static string MakeValidFileName(string name)
        {
            string invalidChars = Regex.Escape(new string(Path.GetInvalidFileNameChars()));
            string invalidReStr = string.Format(@"[{0}]+", invalidChars);
            return Regex.Replace(name, invalidReStr, "_");
        }

        public static string HttpGet(string url)
        {
            var req = WebRequest.Create(url) as HttpWebRequest;
            using (var resp = req.GetResponse() as HttpWebResponse)
            {
                var reader = new StreamReader(resp.GetResponseStream());
                return reader.ReadToEnd();
            }
        }

		public static void DownloadFile(string url)
		{//Not working
			var httpWebRequest = (HttpWebRequest)HttpWebRequest.Create(filename)
			{
				AllowWriteStreamBuffering = true;
				UserAgent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)";
				Timeout = 30000; //30 seconds
			};
            WebResponse webResponse = httpWebRequest.GetResponse();
            Stream webStream = webResponse.GetResponseStream();
			imageStream = Image.FromStream(webStream);
			webResponse.Close();
		}

        public static string GetIPAddress()
        {
            IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (IPAddress ip in host.AddressList)
                if (ip.AddressFamily == AddressFamily.InterNetwork)
                    return ip.ToString();
            return "?";
        }
	}
}