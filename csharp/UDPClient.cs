using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net.Sockets;
using System.Net;
using System.Threading;

namespace UDPClient
{
    public partial class Form1 : Form
    {
        UdpClient _server = null;
        IPEndPoint _client = null;

        public Form1()
        {
            InitializeComponent();
        }

        private void serverMsgBox_Load(object sender, EventArgs e)
        {
            //Get the server.
            _server = new UdpClient("127.0.0.1", 16000);
            //Create a client.
            _client = new IPEndPoint(IPAddress.Any, 0);
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            _server.Close();
        }

        private void btSend_Click(object sender, EventArgs e)
        {
            //Send the input message.
            string text = this.richTextBox1.Text;
            _server.Send(Encoding.ASCII.GetBytes(text), text.Length);
            //Receive the response message.
            byte[] data = _server.Receive(ref _client);
            string msg = Encoding.ASCII.GetString(data, 0, data.Length);
            //Show the response message.
            this.richTextBox1.Text = msg;      
        }
        
    }
}