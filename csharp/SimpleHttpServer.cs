using System;
using System.Net;
using System.IO;
using System.Threading;
using System.Text;

namespace SimpleHttpServer
{
	class Program
	{
		public static void Main(string[] args)
		{
			HttpListener listener = null;
			try
			{
				listener = new HttpListener();
				listener.Prefixes.Add("http://localhost:1300/simpleserver/");
				listener.Start();
				while (true)
				{
					Console.WriteLine("waiting...");
					HttpListenerContext context = listener.GetContext();
					string msg = "hello:)";
					context.Response.ContentLength64 = Encoding.UTF8.GetByteCount(msg);
					context.Response.StatusCode = (int)HttpStatusCode.OK;
					using (Stream stream = context.Response.OutputStream)
					{
						using (StreamWriter writer = new StreamWriter(stream))
						{
							writer.Write(msg);
						}
					}
					Console.WriteLine("msg sent...");
				}
			}
			catch (WebException e)
			{
				Console.WriteLine(e.Status);
			}
		}
	}
}