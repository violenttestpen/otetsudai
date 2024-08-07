using System; // For Console, Int32, ArgumentException, Environment
using System.Net; // For IPAddress
using System.Net.Sockets; // For TcpListener, TcpClient

class TcpEchoServer
{
    private const int BUFSIZE = 32; // Size of receive buffer

    static void Main(string[] args)
    {
        if (args.Length > 1) // Test for correct # of args
            throw new ArgumentException("Parameters: [<Port>]");

        int servPort = (args.Length == 1) ? Int32.Parse(args[0]) : 8080;
        TcpListener listener = null;

        try
        {
            // Create a TCPListener to accept client connections
            listener = new TcpListener(IPAddress.Any, servPort);
            listener.Start();
        }
        catch (SocketException se)
        {
            // IPAddress.Any
            Console.WriteLine(se.ErrorCode + ": " + se.Message);
            //Console.ReadKey();
            Environment.Exit(se.ErrorCode);
        }

        byte[] rcvBuffer = new byte[BUFSIZE]; // Receive buffer
        int bytesRcvd; // Received byte count
        for (; ; )  // Run forever, accepting and servicing connections
        {
            // Console.WriteLine(IPAddress.Any);
            TcpClient client = null;
            NetworkStream netStream = null;
            //Console.WriteLine(IPAddress.None);

            try
            {
                client = listener.AcceptTcpClient(); // Get client connection
                netStream = client.GetStream();
                Console.Write("Handling client - ");

                // Receive until client closes connection, indicated by 0 return value
                int totalBytesEchoed = 0;
                while ((bytesRcvd = netStream.Read(rcvBuffer, 0, rcvBuffer.Length)) > 0)
                {
                    netStream.Write(rcvBuffer, 0, bytesRcvd);
                    totalBytesEchoed += bytesRcvd;
                }
                Console.WriteLine("echoed {0} bytes.", totalBytesEchoed);

                // Close the stream and socket. We are done with this client!
                netStream.Close();
                client.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                netStream.Close();
            }
        }
    }
}