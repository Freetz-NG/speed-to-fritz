/* Copyright (c) 2006, J.P. Trosclair
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted 
 * provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this list of conditions and 
 *		the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions 
 *		and the following disclaimer in the documentation and/or other materials provided with the 
 *		distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR 
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * Based on FTPFactory.cs code, pretty much a complete re-write with FTPFactory.cs
 * as a reference.
 * 
 ***********************
 * Authors of this code:
 ***********************
 * J.P. Trosclair    (jptrosclair@judelawfirm.com)
 * Filipe Madureira  (filipe_madureira@hotmail.com) 
 * Carlo M. Andreoli (cmandreoli@numericaprogetti.it)
 * Sloan Holliday    (sloan@ipass.net)
 * Johann Pascher    (johann.pascher@gmail.com)
 * 
 *********************** 
 * FTPFactory.cs was written by Jaimon Mathew (jaimonmathew@rediffmail.com)
 * and modified by Dan Rolander (Dan.Rolander@marriott.com),
 * Johann Pascher (johann.pascher@gmail.com) Remove most unneeded code to adapt.
 ***********************
 * 
 * ** DO NOT ** contact the authors of FTPFactory.cs about problems with this code. It
 * is not their responsibility.
 * 
 *  Any bug fixes or additions to the code will be properly credited to the author.
 * 
 * 
 * All calls to the ftplib functions should be:
 * 
 * try 
 * { 
 *		// ftplib function call
 * } 
 * catch(Exception ex) 
 * {
 *		// error handeler
 * }
 * 
 * If you add to the code please make use of OpenDataSocket(), CloseDataSocket(), and
 * ReadResponse() appropriately. See the comments above each for info about using them.
 * 
 * The Fail() function terminates the entire connection. Only call it on critical errors.
 * Non critical errors should NOT close the connection.
 * All errors should throw an exception of type Exception with the response string from
 * the server as the message.
 */
//#define FTP_DEBUG
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Diagnostics;
namespace ftplib
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
        /// Data Port number the FTP server is listening on
        /// </summary>
        public int dataport;
        /// <summary>
        /// Data server IP number the FTP server is listening on
        /// </summary>
        public string dataserver;
		/// <summary>
		/// The timeout (miliseconds) for waiting on data to arrive
		/// </summary>
		public int timeout;
        public string messages; // server messages
        public string responseStr; // server response if the user wants it.
        public int response; //response Number

		#endregion
		#region Private Variables
		private long bytes_total; // upload/download info if the user wants it.
		private long file_size; // gets set when an upload or download takes place
		private Socket main_sock;
        private Socket data_sock;
		private IPEndPoint main_ipEndPoint;
		private IPEndPoint data_ipEndPoint;
		private FileStream file;
		private string bucket = "";
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
        /// The response number from the last issued command
        /// </summary>
        public int Response
        {
            get
            {
                return response;
            }
        }
		/// <summary>
		/// The total number of bytes sent/recieved in a transfer
		/// </summary>
		public long BytesTotal
		{
			get
			{
				return bytes_total;
			}
		}
		/// <summary>
		/// The size of the file being downloaded/uploaded (Can possibly be 0 if no size is available)
		/// </summary>
		public long FileSize
		{
			get
			{
				return file_size;
			}
		}
        /// <summary>
        /// Connect to a ftp server
        /// </summary>
        /// <param name="server">IP of the server to connect to</param>
        public void Connect(string server)
        {
            this.server = server;
            if (main_sock != null)
                if (main_sock.Connected)
                return;
            main_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            //main_ipEndPoint = new IPEndPoint(Dns.GetHostByName(server).AddressList[0], port);
            main_ipEndPoint = new IPEndPoint(IPAddress.Parse(server), port);
            try
            {
                main_sock.Connect(main_ipEndPoint);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        /// <summary>
        /// Upload the file, to be used in a loop until file is completely uploaded
        /// </summary>
        /// <returns>Bytes sent</returns>
        public long DoUpload1460()
        {
            Byte[] bytes = new Byte[1460];
            long bytes_got;
            try
            {
                bytes_got = file.Read(bytes, 0, bytes.Length);
                bytes_total += bytes_got;
                if (bytes_got > 0) data_sock.Send(bytes, (int)bytes_got, 0);
                if (bytes_got <= 0)
                { // the upload is complete or an error occured
                    file.Close();
                    file = null;
                    CloseDataSocket();
                    ReadResponse();
                    switch (response)
                    {
                        case 226: //transfere complette
                        case 250:
                            break;
                        default:
                            throw new Exception(responseStr);
                    }
                }
            }
            catch (Exception ex)
            {
                file.Close();
                file = null;
                CloseDataSocket();
                ReadResponse();
                throw ex;
            }
            return bytes_got;
        }
        /// <summary>
        /// Open an upload file with resume support
        /// </summary>
        public void OpenUploadFile(string filename)
        {
            try
            {
                file = new FileStream(filename, FileMode.Open);
            }
            catch (Exception ex)
            {
                file = null;
                throw new Exception(ex.Message);
            }
            file_size = file.Length;
        }
		public bool SendCommand(string command)
		{
            try
            {
                Byte[] cmd = Encoding.ASCII.GetBytes((command + "\r\n").ToCharArray());
                main_sock.Send(cmd, cmd.Length, 0);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
		// Any time a command is sent, use ReadResponse() to get the response from the server. 
        // The variable responseStr holds the entire string.
		// The variable response holds the response number.
        // The variable messages holds multilines.
        public String ReadResponse()
        {
            if (main_sock != null)
            {
                string buf = "";
                messages = "";
                while (true)
                {
                    //-> buf = GetLineFromBucket();
                    int i;
                    if ((i = bucket.IndexOf('\n')) < 0)
                    {
                        while (i < 0)
                        {
                            //->FillBucket();
                            Byte[] bytes = new Byte[512];
                            long bytesgot;
                            //+++++++++++++++++++++++++++++++++++++++++++
                            while (main_sock.Available < 1) ;
                            //+++++++++++++++++++++++++++++++++++++++++++
                            while (main_sock.Available > 0)
                            {
                                bytesgot = main_sock.Receive(bytes, 512, 0);
                                bucket += Encoding.ASCII.GetString(bytes, 0, (int)bytesgot);
                            }//<-FillBucket();
                            i = bucket.IndexOf('\n');
                        }
                    }
                    buf = bucket.Substring(0, i);
                    bucket = bucket.Substring(i + 1);
                    //<-buf = GetLineFromBucket();
#if (FTP_DEBUG)
                    Debug.WriteLine("buf:" + buf);
#endif
                    responseStr = buf; // get line
                    if (Regex.Match(buf, "^[0-9]+ ").Success)
                    {
                        response = int.Parse(buf.Substring(0, 3)); //get 3 digit code
                        break;
                    }
                    else
                        messages += buf; // get multilines into messages
                }
                return responseStr;
            }
            return "No main Socket!";
        }
        public void GetDataPortFormResponseString()
        {
            string[] pasv;
            if (response != 227)
                Fail();
            try
            {
                int i1, i2;
                i1 = responseStr.IndexOf('(') + 1;
                i2 = responseStr.IndexOf(')') - i1;
                pasv = responseStr.Substring(i1, i2).Split(',');
            }
            catch (Exception)
            {
                Disconnect();
                throw new Exception("Malformed PASV response: " + responseStr);
            }
            if (pasv.Length < 6)
            {
                Disconnect();
                throw new Exception("Malformed PASV response: " + responseStr);
            }
            dataserver = String.Format("{0}.{1}.{2}.{3}", pasv[0], pasv[1], pasv[2], pasv[3]);
            dataport = (int.Parse(pasv[4]) << 8) + int.Parse(pasv[5]);
        }
		// if you add code that needs a data socket,
        // Send the PASV command first and GetDataPortFormResponseString().
        // opens the appropriate data socket.
		// The socket variable is Socket data_socket. Once you
		// are done with it, be sure to call CloseDataSocket()
        public void OpenDataSocket()
		{
				try
				{
#if (FTP_DEBUG)
					Debug.WriteLine("Data socket: {0}:{1}", dataserver, dataport);
#endif
                    CloseDataSocket();
					
#if (FTP_DEBUG)
					Debug.WriteLine("Creating socket...");
#endif
					data_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
					
#if (FTP_DEBUG)
					Debug.WriteLine("Resolving host");
#endif

					//data_ipEndPoint = new IPEndPoint(Dns.GetHostByName(server).AddressList[0], dataport);
                    data_ipEndPoint = new IPEndPoint(IPAddress.Parse(server), dataport);
					
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
        public void CheckStor()
        {
            switch (response)
            {
                case 125:
                case 150:
                    break;
                default:
                    file.Close();
                    file = null;
                    throw new Exception(responseStr);
            }
        }
        public bool CheckSocetAvalabel()
        {
                System.Threading.Thread.Sleep(500);
                if (main_sock == null) return true; 
                if (main_sock.Available < 1)
                    return false;
                return true;
        }
        public void Disconnect() //Send QUIT and close data soket main soket and file
        {
            CloseDataSocket();
            if (main_sock != null)
            {
                if (main_sock.Connected)
                {
                    SendCommand("QUIT");
                    CloseMainSocket();
                }
            }
            if (file != null)
                file.Close();
            file = null;
        }
        public void CloseMainSocket() //close main channel socket
        {
#if (FTP_DEBUG)
            Debug.WriteLine("Attempting to close main socket...");
#endif
            if (main_sock != null)
            {
                if (main_sock.Connected)
                {
#if (FTP_DEBUG)
                    Debug.WriteLine("Closing main socket!");
#endif
                    main_sock.Close();
#if (FTP_DEBUG)
                    Debug.WriteLine("Main channel socket closed!");
#endif
                }
                main_sock = null;
            }

            main_ipEndPoint = null;
        }
        public void CloseDataSocket() //close data channel socket
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
        public void Fail()
        {
            Disconnect();
            //throw new Exception(responseStr);
        }
	}
}