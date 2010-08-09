#define FTP_DEBUG   

using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Diagnostics;

namespace ftp
{
	public class FTP
	{
		#region Public Variables

		/// <summary>
		/// IP address or hostname to connect to
		/// </summary>
		public string server;
		/// <summary>
		/// Username to login as
		/// </summary>
		public string user;
		/// <summary>
		/// Password for account
		/// </summary>
		public string pass;
		/// <summary>
		/// Port number the FTP server is listening on
		/// </summary>
		public int port;
		/// <summary>
		/// The timeout (miliseconds) for waiting on data to arrive
		/// </summary>
		public int timeout;
		
		#endregion

		#region Private Variables
		
		private string messages; // server messages
		private string responseStr; // server response if the user wants it.
		private bool passive_mode;		// #######################################
		private long bytes_total; // upload/download info if the user wants it.
		private long file_size; // gets set when an upload or download takes place
		private Socket main_sock;
		private IPEndPoint main_ipEndPoint;
		private Socket listening_sock;
		private Socket data_sock;
		private IPEndPoint data_ipEndPoint;
		private FileStream file;
		private int response;
		private string bucket;
		
		#endregion
		
		#region Constructors
		/// <summary>
		/// Constructor
		/// </summary>
		public FTP()
		{
			server = null;
			user = null;
			pass = null;
			port = 21;
			passive_mode = true;		// #######################################
			main_sock = null;
			main_ipEndPoint = null;
			listening_sock = null;
			data_sock = null;
			data_ipEndPoint = null;
			file = null;
			bucket = "";
			bytes_total = 0;
			timeout = 10000;	// 10 seconds
			messages = "";
		}
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="server">Server to connect to</param>
		/// <param name="user">Account to login as</param>
		/// <param name="pass">Account password</param>
		public FTP(string server, string user, string pass)
		{
			this.server = server;
			this.user = user;
			this.pass = pass;
			port = 21;
			passive_mode = true;		// #######################################
			main_sock = null;
			main_ipEndPoint = null;
			listening_sock = null;
			data_sock = null;
			data_ipEndPoint = null;
			file = null;
			bucket = "";
			bytes_total = 0;
			timeout = 10000;	// 10 seconds
			messages = "";
		}
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="server">Server to connect to</param>
		/// <param name="port">Port server is listening on</param>
		/// <param name="user">Account to login as</param>
		/// <param name="pass">Account password</param>
		public FTP(string server, int port, string user, string pass)
		{
			this.server = server;
			this.user = user;
			this.pass = pass;
			this.port = port;
			passive_mode = true;		// #######################################
			main_sock = null;
			main_ipEndPoint = null;
			listening_sock = null;
			data_sock = null;
			data_ipEndPoint = null;
			file = null;
			bucket = "";
			bytes_total = 0;
			timeout = 10000;	// 10 seconds
			messages = "";
		}

		#endregion

		/// <summary>
		/// Connection status to the server
		/// </summary>
		public bool IsConnected
		{
			get
			{
				if (main_sock != null)
					return main_sock.Connected;
				return false;
			}
		}
		/// <summary>
		/// Returns true if the message buffer has data in it
		/// </summary>
		public bool MessagesAvailable
		{
			get
			{
				if(messages.Length > 0)
					return true;
				return false;
			}
		}
		/// <summary>
		/// Server messages if any, buffer is cleared after you access this property
		/// </summary>
		public string Messages
		{
			get
			{
				string tmp = messages;
				messages = "";
				return tmp;
			}
		}
		/// <summary>
		/// The response string from the last issued command
		/// </summary>
		public string ResponseString
		{
			get
			{
				return responseStr;
			}
		}
		/// <summary>
		/// The total number of bytes sent/recieved in a transfer
		/// </summary>
		public long BytesTotal		// #######################################
		{
			get
			{
				return bytes_total;
			}
		}
		/// <summary>
		/// The size of the file being downloaded/uploaded (Can possibly be 0 if no size is available)
		/// </summary>
		public long FileSize		// #######################################
		{
			get
			{
				return file_size;
			}
		}
		/// <summary>
		/// True:  Passive mode [default]
		/// False: Active Mode
		/// </summary>
		public bool PassiveMode		// #######################################
		{
			get
			{
				return passive_mode;
			}
			set
			{
				passive_mode = value;
			}
		}


		private void Fail()
		{
			Disconnect();
			throw new Exception(responseStr);
		}


		public void SetBinaryMode(bool mode)
		{
            if (mode)
            {
                SendCommand("TYPE I");
            }
            else
                SendCommand("TYPE A");

			ReadResponse();
			if (response != 200)
				Fail();
		}

        public String SetCommand(string command)
        { 
            SendCommand(command);
            ReadResponse();
            return responseStr;
        }

		public void SendCommand(string command)
		{
			Byte[] cmd = Encoding.ASCII.GetBytes((command + "\r\n").ToCharArray());

#if (FTP_DEBUG)
			if (command.Length > 3 && command.Substring(0, 4) == "PASS")
				Debug.WriteLine("\rPASS xxx");
			else
				Debug.WriteLine("\r" + command);
#endif

			main_sock.Send(cmd, cmd.Length, 0);
		}


        public bool CheckSocetAvalabel()
        {
            int msecs_passed = 0;		// #######################################
            if (main_sock.Available < 1)
            {
                System.Threading.Thread.Sleep(500);
                msecs_passed += 50;
                //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                // this code is just a fail safe option 
                // so the code doesn't hang if there is 
                // no data comming.
                if (msecs_passed > timeout)
                {
                    Disconnect();
                    throw new Exception("Timed out waiting on server to respond.");
                }
                return false;
            }
            return true;
        }

            private void FillBucket()
        {
            while (CheckSocetAvalabel() == false)
                {
#if (FTP_DEBUG)
                    Debug.Write(",");
#endif
            }
            Byte[] bytes = new Byte[512];
            long bytesgot;
			while(main_sock.Available > 0)
			{
				bytesgot = main_sock.Receive(bytes, 512, 0);
				bucket += Encoding.ASCII.GetString(bytes, 0, (int)bytesgot);
				// this may not be needed, gives any more data that hasn't arrived
				// just yet a small chance to get there.
				System.Threading.Thread.Sleep(50);
			}
		}


		private string GetLineFromBucket()
		{
			int i;
			string buf = "";

			if ((i = bucket.IndexOf('\n')) < 0)
			{
				while(i < 0)
				{
					FillBucket();
					i = bucket.IndexOf('\n');
				}
			}

			buf = bucket.Substring(0, i);
			bucket = bucket.Substring(i + 1);

			return buf;
		}


		// Any time a command is sent, use ReadResponse() to get the response
		// from the server. The variable responseStr holds the entire string and
		// the variable response holds the response number.
		public String ReadResponse()
		{
			string buf;
			messages = "";

			while(true)
			{
				//buf = GetLineFromBucket();
				buf = GetLineFromBucket();

#if (FTP_DEBUG)
				Debug.WriteLine(buf);
#endif
				// the server will respond with "000-Foo bar" on multi line responses
				// "000 Foo bar" would be the last line it sent for that response.
				// Better example:
				// "000-This is a multiline response"
				// "000-Foo bar"
				// "000 This is the end of the response"
				if (Regex.Match(buf, "^[0-9]+ ").Success)
				{
					responseStr = buf;
					response = int.Parse(buf.Substring(0, 3));
					break;
				}
				else
					messages += Regex.Replace(buf, "^[0-9]+-", "") + "\n";
			}
            return responseStr;
		}


		// if you add code that needs a data socket, i.e. a PASV or PORT command required,
		// call this function to do the dirty work. It sends the PASV or PORT command,
		// parses out the port and ip info and opens the appropriate data socket
		// for you. The socket variable is private Socket data_socket. Once you
		// are done with it, be sure to call CloseDataSocket()
		public void OpenDataSocket()
		{
			if (passive_mode)		// #######################################
			{
				string[] pasv;
				string server;
				int port;

				Connect();
				SendCommand("PASV");
				ReadResponse();
				if (response != 227)
					Fail();

				try
				{
					int i1, i2;

					i1 = responseStr.IndexOf('(') + 1;
					i2 = responseStr.IndexOf(')') - i1;
					pasv = responseStr.Substring(i1, i2).Split(',');
				}
				catch(Exception)
				{
					Disconnect();
					throw new Exception("Malformed PASV response: " + responseStr);
				}

				if (pasv.Length < 6)
				{
					Disconnect();
					throw new Exception("Malformed PASV response: " + responseStr);
				}

				server = String.Format("{0}.{1}.{2}.{3}", pasv[0], pasv[1], pasv[2], pasv[3]);
				port = (int.Parse(pasv[4]) << 8) + int.Parse(pasv[5]);

				try
				{
#if (FTP_DEBUG)
					Debug.WriteLine("Data socket: {0}:{1}", server, port);
#endif
					CloseDataSocket();
					
#if (FTP_DEBUG)
					Debug.WriteLine("Creating socket...");
#endif
					data_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
					
#if (FTP_DEBUG)
					Debug.WriteLine("Resolving host");
#endif

					data_ipEndPoint = new IPEndPoint(Dns.GetHostByName(server).AddressList[0], port);
                    //data_ipEndPoint = new IPEndPoint(IPAddress.Parse(server), port);
					
#if (FTP_DEBUG)
					Debug.WriteLine("Connecting..");
#endif
					data_sock.Connect(data_ipEndPoint);

#if (FTP_DEBUG)
					Debug.WriteLine("Connected.");
#endif
				}
				catch(Exception ex)
				{
					throw new Exception("Failed to connect for data transfer: " + ex.Message);
				}
			}
			else		// #######################################
			{
				Connect();

				try
				{
#if (FTP_DEBUG)
					Debug.WriteLine("Data socket (active mode)");
#endif
					CloseDataSocket();
					
#if (FTP_DEBUG)
					Debug.WriteLine("Creating listening socket...");
#endif
					listening_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

#if (FTP_DEBUG)
					Debug.WriteLine("Binding it to local address/port");
#endif
					// for the PORT command we need to send our IP address; let's extract it
					// from the LocalEndPoint of the main socket, that's already connected
					string sLocAddr = main_sock.LocalEndPoint.ToString();
					int ix = sLocAddr.IndexOf(':');
					if (ix < 0)
					{
						throw new Exception("Failed to parse the local address: " + sLocAddr);
					}
					string sIPAddr = sLocAddr.Substring(0, ix);
					// let the system automatically assign a port number (setting port = 0)
					System.Net.IPEndPoint localEP = new IPEndPoint(IPAddress.Parse(sIPAddr), 0);

					listening_sock.Bind(localEP);
					sLocAddr = listening_sock.LocalEndPoint.ToString();
					ix = sLocAddr.IndexOf(':');
					if (ix < 0)
					{
						throw new Exception("Failed to parse the local address: " + sLocAddr);
					}
					int nPort = int.Parse(sLocAddr.Substring(ix + 1));
#if (FTP_DEBUG)
					Debug.WriteLine("Listening on {0}:{1}", sIPAddr, nPort);
#endif
					// start to listen for a connection request from the host (note that
					// Listen is not blocking) and send the PORT command
					listening_sock.Listen(1);
					string sPortCmd = string.Format("PORT {0},{1},{2}", 
													sIPAddr.Replace('.', ','),
													nPort / 256, nPort % 256);
					SendCommand(sPortCmd);
					ReadResponse();
					if (response != 200)
						Fail();
				}
				catch(Exception ex)
				{
					throw new Exception("Failed to connect for data transfer: " + ex.Message);
				}
			}
		}


		private void ConnectDataSocket()		// #######################################
		{
			if (data_sock != null)		// already connected (always so if passive mode)
				return;

			try
			{
#if (FTP_DEBUG)
				Debug.WriteLine("Accepting the data connection.");
#endif
				data_sock = listening_sock.Accept();	// Accept is blocking
				listening_sock.Close();
				listening_sock = null;

				if (data_sock == null)
				{
					throw new Exception("Winsock error: " + 
						Convert.ToString(System.Runtime.InteropServices.Marshal.GetLastWin32Error()) );
				}
#if (FTP_DEBUG)
				Debug.WriteLine("Connected.");
#endif
			}
			catch(Exception ex)
			{
				throw new Exception("Failed to connect for data transfer: " + ex.Message);
			}
		}


		private void CloseDataSocket()
		{
#if (FTP_DEBUG)
			Debug.WriteLine("Attempting to close data channel socket...");
#endif
			if (data_sock != null)
			{
				if (data_sock.Connected)
				{
#if (FTP_DEBUG)
						Debug.WriteLine("Closing data channel socket!");
#endif	
						data_sock.Close();
#if (FTP_DEBUG)
						Debug.WriteLine("Data channel socket closed!");
#endif
				}
				data_sock = null;
			}

			data_ipEndPoint = null;
		}
		/// <summary>
		/// Closes all connections to the ftp server
		/// </summary>
		public void Disconnect()
		{
			CloseDataSocket();

			if (main_sock != null)
			{
				if (main_sock.Connected)
				{
					SendCommand("QUIT");
					main_sock.Close();
				}
				main_sock = null;
			}

			if (file != null)
				file.Close();

			main_ipEndPoint = null;
			file = null;
		}
		/// <summary>
		/// Connect to a ftp server
		/// </summary>
		/// <param name="server">IP or hostname of the server to connect to</param>
		/// <param name="port">Port number the server is listening on</param>
		/// <param name="user">Account name to login as</param>
		/// <param name="pass">Password for the account specified</param>
		public String Connect(string server, int port, string user, string pass)
		{
			this.server = server;
			this.user = user;
			this.pass = pass;
			this.port = port;

			return Connect();
		}
		/// <summary>
		/// Connect to a ftp server
		/// </summary>
		/// <param name="server">IP or hostname of the server to connect to</param>
		/// <param name="user">Account name to login as</param>
		/// <param name="pass">Password for the account specified</param>
        public String Connect(string server, string user, string pass)
		{
			this.server = server;
			this.user = user;
			this.pass = pass;

			return Connect();
		}
		/// <summary>
		/// Connect to an ftp server
		/// </summary>
        public String Connect()
		{
			if (server == null)
				throw new Exception("No server has been set.");
			if (user == null)
				throw new Exception("No username has been set.");

			if (main_sock != null)
				if (main_sock.Connected)
                    return "connected";

			main_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
			main_ipEndPoint = new IPEndPoint(Dns.GetHostByName(server).AddressList[0], port);
            //data_ipEndPoint = new IPEndPoint(IPAddress.Parse(server), port);
			
			try
			{
				main_sock.Connect(main_ipEndPoint);	
			}
			catch(Exception ex)
			{
                throw new Exception(ex.Message);
			}

			ReadResponse();
			if (response != 220)
				Fail();

			SendCommand("USER " + user);
			ReadResponse();

			switch(response)
			{
				case 331:
					if (pass == null)
					{
						Disconnect();
						throw new Exception("No password has been set.");
					}
					SendCommand("PASS " + pass);
					ReadResponse();
					if (response != 230)
						Fail();
					break;
				case 230:
					break;
			}
			
			return responseStr;
		}

//------------------------------------------------------------------------------------------------------------------
		public long GetFileSize(string filename)
		{
			Connect();
			SendCommand("SIZE " + filename);
			ReadResponse();
			if (response != 213)
			{
#if (FTP_DEBUG)
				Debug.Write("\r" + responseStr);
#endif
				throw new Exception(responseStr);
			}
            
			return Int64.Parse(responseStr.Substring(4));
		}
        //------------------------------------------------------------------------------------------------------------------
		/// <summary>
		/// Open an upload file with resume support
		/// </summary>
		public void OpenUploadM(string filename)
		{
			//Connect();
			//SetBinaryMode(true);
			//OpenDataSocket();
            //bytes_total = 0;
			try
			{
				file = new FileStream(filename, FileMode.Open);
			}
			catch(Exception ex)
			{
				file = null;
				throw new Exception(ex.Message);
			}
			file_size = file.Length;
            //SetCommand("STOR " + remote_filename);
            //CheckStor();
   		}
    public String CheckStor()
    {
                //ReadResponse();
                //Console.WriteLine("RRRR" + responseStr);
    			switch(response)
			{
				case 125:
				case 150:
					break;
				default:
					file.Close();
					file = null;
					throw new Exception(responseStr);
			}
			ConnectDataSocket();		// #######################################	
            return responseStr;
    }
		/// <summary>
		/// Upload the file, to be used in a loop until file is completely uploaded
		/// </summary>
		/// <returns>Bytes sent</returns>
		public long DoUpload()
		{
			Byte[] bytes = new Byte[512];
			long bytes_got;

			try
			{
				bytes_got = file.Read(bytes, 0, bytes.Length);
				bytes_total += bytes_got;
				data_sock.Send(bytes, (int)bytes_got, 0);

				if(bytes_got <= 0)
				{
					// the upload is complete or an error occured
					file.Close();
					file = null;
				
					CloseDataSocket();
					ReadResponse();
					switch(response)
					{
						case 226:
						case 250:
							break;
						default:
							throw new Exception(responseStr);
					}
				
					SetBinaryMode(false);
				}
			}
			catch(Exception ex)
			{
				file.Close();
				file = null;
				CloseDataSocket();
				ReadResponse();
				SetBinaryMode(false);
				throw ex;
			}

			return bytes_got;
		}

	}
}