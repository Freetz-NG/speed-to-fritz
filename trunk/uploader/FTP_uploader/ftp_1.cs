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
 * 
 * Authors: 
 * J.P. Trosclair (jptrosclair@judelawfirm.com)
 * Daniel Tamajón (dtamajon@gmail.com)
 * Johann Pascher (johann.pascher@gmail.com)
 * 
 * Simple ftp client to test the ftplib code and show examples of how to use
 * the class in your own programs.
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
 */
using System;
using FTPLib;
using System.Text.RegularExpressions;

namespace ftp
{
	class ftp_main
	{
		public static FTP ftplib = new FTP();

		[STAThread]
		static void Main(string[] args)
		{
			if (args.Length > 0)
			{
				try
				{
					commandline_mode(args);
				}
				catch(Exception ex)
				{
					Console.WriteLine(ex.Message);
				}
			}
			else
			{
				console_mode();
			}
		}

		static void commandline_mode(string[] args)
		{
			int i = 0, j = 0, k = 0;
			bool go = true;
			string [] ftpGet = new string[0];
			string [] ftpPut = new string[0];

			ftplib.port = 21;
			ftplib.user = "adam2";
			ftplib.pass = "adam2";
            ftplib.server = "192.168.178.1";
            ftplib.port = 21;

			for(i = 0; (i < args.Length) && go; i+=2)
			{
				switch(args[i])
				{
					case "-x":
            Console.WriteLine("'filesystem.image and kernel.image' must be in the same directory as this utility!");
            waitOpen();
            ftplib.SetCommand("MEDIA FLSH");
            Console.WriteLine("Erase Flash, Pleas Wait.. ");
            if (args[i + 4] == "y")
            {
                upload("kernel.image", "mtd1");
            }
            if (args[i + 3] == "y")
            {
                upload("filesystem.image", "mtd3");
                //Console.WriteLine(" ");
                upload("filesystem.image", "mtd4");
                //Console.WriteLine(" ");
            }
            ftplib.SetCommand("SETENV my_ipaddress 192.168.178.1");
            ftplib.SetCommand("SETENV firmware_version " + args[i+1]);
            ftplib.SetCommand("SETENV wlan_key speedboxspeedbox");
            if (args[i + 2] == "annex=A")
                {
                    ftplib.SetCommand("SETENV kernel_args annex=A");
                }
            ftplib.SetCommand("REBOOT");
            close();
						ftplib.server = args[i+1];
						break;
					
	
					case "-s":
						ftplib.server = args[i+1];
						break;
					
					case "-p":
						if (IsInteger(args[i+1]))
						{
							ftplib.port = Int32.Parse(args[i+1]);
						}
						else
						{
							Console.WriteLine("Port should be a numeric value...");
							go = false;
						}
						break;
					
					case "-usr":
						ftplib.user = args[i+1];
						break;
					
					case "-pwd":
						ftplib.pass = args[i+1];
						break;
					
					case "-get":
						for(j = i+1, k = 0; j < args.Length && args[j] != "-"; j++, k++);
						ftpGet = new string[k];

						for(j = i+1, k = 0; j < args.Length && args[j] != "-"; j++, k++)
						{
							ftpGet[k] = args[j];
						}
						if ( j == i+1 )
						{
							Console.WriteLine("File to get must be specified...");
							go = false;
						}
						i = j - 2;
						break;
					
					case "-put":
						for(j = i+1, k = 0; j < args.Length && args[j] != "-"; j++, k++);
						ftpPut = new string[k];

						for(j = i+1, k = 0; j < args.Length && args[j] != "-"; j++, k++)
						{
							ftpPut[k] = args[j];
						}
						if ( j == i+1 )
						{
							Console.WriteLine("File to put must be specified...");
							go = false;
						}
						i = j - 2;
						break;

					case "-cd":
						ftplib.ChangeDir(args[i+1]);
						break;

					case "-ld":
						System.IO.Directory.SetCurrentDirectory(args[i+1]);
						break;

					case "-h":
					default:
						show_help_command_line();
						go = false;
						break;
				}
			}

			if (ftpPut.Length > 0 || ftpGet.Length > 0 )
			{
				if ( ftpPut.Length > 0 )
				{
					for(i = 0; i < ftpPut.Length; i++)
					{
						if (ftpPut[i].LastIndexOf("/") >= 0)
						{
							ftplib.OpenUpload(ftpPut[i], ftpPut[i].Substring(ftpPut[i].LastIndexOf("/")+1));
						}
						else if (ftpPut[i].LastIndexOf("\\") >= 0) 
						{
							ftplib.OpenUpload(ftpPut[i], ftpPut[i].Substring(ftpPut[i].LastIndexOf("\\")+1));
						}
						else 
						{
							ftplib.OpenUpload(ftpPut[i]);
						}

						int perc;
						while(ftplib.DoUpload() > 0)
						{
							perc = (int)(((ftplib.BytesTotal) * 100) / ftplib.FileSize);
							Console.Write("\rUpload: {0}/{1} {2}%", ftplib.BytesTotal, ftplib.FileSize, perc);
							Console.Out.Flush();
						}
						Console.WriteLine("");
					}
				}

				if ( ftpGet.Length > 0 )
				{
					for(i = 0; i < ftpGet.Length; i++)
					{
						ftplib.OpenDownload(ftpGet[i]);
						int perc;
						while(ftplib.DoDownload() > 0)
						{
							perc = (int)(((ftplib.BytesTotal) * 100) / ftplib.FileSize);
							Console.Write("\rDownloading: {0}/{1} {2}%", ftplib.BytesTotal, ftplib.FileSize, perc);
							Console.Out.Flush();
						}
						Console.WriteLine("");
					}
				}
			}
			else
			{
				Console.WriteLine("Any order (set/put) was given...");
			}
		}

		static void console_mode()
		{
			bool go = true;
			string input = "";
			
			
            ftplib.port = 21;
            Console.WriteLine("'filesystem.image and kernel.image' must be in the same directory as this utility!");
            waitOpen();
            ftplib.SetCommand("MEDIA FLSH");
            Console.WriteLine("Erase Flash, Pleas Wait.. ");
            upload("kernel.image", "mtd1");
            upload("filesystem.image", "mtd3");
            //Console.WriteLine(" ");
            upload("filesystem.image", "mtd4");
            //Console.WriteLine(" ");
            ftplib.SetCommand("SETENV my_ipaddress 192.168.178.1");
            ftplib.SetCommand("SETENV firmware_version avm");
            ftplib.SetCommand("SETENV wlan_key speedboxspeedbox");
            //ftplib.SetCommand("SETENV kernel_args annex=A");
            ftplib.SetCommand("REBOOT");
            close();



            //Console.WriteLine("Reboot Router or Circle Power Line OFF/ON Now");
            ftplib.user = "adam2";
            ftplib.pass = "adam2";
            ftplib.server = "192.168.178.1";
            Console.WriteLine("FTP Client\n'?' for a list of commands.");
            while(go)
			{
				Console.Write("% ");
				input = Console.ReadLine();
				switch(Regex.Replace(input, " .*", ""))
				{
					case "open":
						open(input);
						break;
					case "close":
						close();
						break;
					case "ls":
						list(input);
						break;
					case "lsd":
						list_dir(input);
						break;
					case "lsf":
						list_file(input);
						break;
					case "mkdir":
						mkdir(input);
						break;
					case "rmdir":
						rmdir(input);
						break;
					case "rm":
						rm(input);
						break;
                    case "quote":
                        ftplib.SetCommand(Regex.Replace(input, "quote ", ""));
                        break;
                    case "ren":
                        rename(input);
                        break;
                    case "get":
						download(input);
						break;
					case "put":
                        upload(input, System.IO.Path.GetFileName(Regex.Replace(input, "put ", "")));
						break;
					case "set":
						set_option(input);
						break;
					case "quit":
						go = false;
						close();
						break;
					case "cd":
						cd(input);
						break;
					case "pwd":
						pwd();
						break;
					case "rawdate":
						raw_date(input);
						break;
					case "date":
						date(input);
						break;
					case "?":
						show_help();
						break;
					default:
						Console.WriteLine("E: Unrecognized command.");
                   
						break;
				}

				if (ftplib.MessagesAvailable)
				{
					Console.Write(ftplib.Messages);
				}
			}
		}

		static void show_help_command_line()
		{
			Console.WriteLine(
				"-h                  -- Show this help\n" +
                "-x                  -- Push Firmware and Set OEM + [Set annex=A] \n" +
				"-c                  -- Start console mode (any other parameter can be defined)\n" +
				"-s [ftp server]     -- Set the server to connect\n" +
				"-p [port]           -- Set the port to connect to ('21' is default)\n" +
				"-usr [username]     -- Set the username to connect as ('anonymous' is default)\n" +
				"-pwd [password]     -- Set the password\n" +
				"-get [filename list]-- Download a file (not compatible with use of -put)\n" +
				"-put [filename list]-- Upload a file (not compatible with use of -get)\n" + 
				"-cd [directory]     -- Server source/target directory\n" +
				"-ld [directory]     -- Local source/target directory\n" +
				"\n" +
				"-- Samples --\n\n" + 
				"ftp -s 127.0.0.1 -cd test -put C:\\tmp\\testfile1.txt C:\\tmp\\testfile2.txt\n" + 
				"\tConnect to FTP 127.0.0.1:21, change to remote 'test' directory and \n\tupload the local files 'C:\\tmp\\testfile1.txt' and 'C:\\tmp\\testfile2.txt'\n" + 
				"\n" +
				"ftp -s 127.0.0.1 -cd test -ld C:\\tmp -put testfile1.txt testfile2.txt\n" +
				"\tAs above, but local path is set once\n"
				);
		}

		static void show_help()
		{
			Console.WriteLine(
				"set user [username]     -- Set the username to connect as\n" +
				"set pass [password]     -- Set the password\n" +
				"set port [port]         -- Set the port to connect to\n" +
				"set mode [A/P]          -- Set the A(ctive) or P(assive) [default] mode\n" +
				"open [ftp server]       -- Connect to an ftp server\n" +
				"close                   -- Close an existing connection\n" +
				"get [filename]          -- Download a file\n" +
				"put [filename]          -- Upload a file\n" +
				"cd [directory]          -- Change directory\n" +
				"pwd                     -- Get working directory\n" +
                "quote [string]          -- execute server commands\n" +
				"ls                      -- List files and directories\n" +
				"lsf                     -- List files only\n" +
				"lsd                     -- (get the good stuff, joking!) List directories only\n" +
				"rm [filename]           -- Delete a file\n" +
				"ren [oldname] [newname] -- Rename a file\n" +
				"rmdir [directory]       -- Remove a directory\n" +
				"mkdir [directory]       -- Create a directory\n" +
				"rawdate [filename]      -- Get raw date of file\n" +
				"date [filename]         -- Get formatted date\n"
				);
		}

		static void set_option(string command)
		{
			string option = Regex.Replace(command, "^[A-Za-z]+ ", "");
			option = Regex.Replace(option, " .*", "");
			switch(option)
			{
				/*case "debug":
					if (ftplib.debug)
					{
						ftplib.debug = false;
						Console.WriteLine("--> Debug mode turned off.");
					}
					else 
					{
						ftplib.debug = true;
						Console.WriteLine("--> Debug mode turned on.");
					}
					break;*/
				case "user":
					ftplib.user = Regex.Replace(command, "set user ", "");
					Console.WriteLine("--> User set to: " + ftplib.user);
					break;
				case "pass":
					ftplib.pass = Regex.Replace(command, "set pass ", "");
					Console.WriteLine("--> Pass set to: " + ftplib.pass);
					break;
				case "port":
					ftplib.port = int.Parse(ftplib.user = Regex.Replace(command, "set port ", ""));
					Console.WriteLine("--> Port set to: " + ftplib.port);
					break;
				case "mode":
					string sMode = Regex.Replace(command, "set mode ", "").ToUpper();
					if (sMode == "A" || sMode == "P")
					{
						ftplib.PassiveMode = (sMode == "P");
						Console.WriteLine("--> Mode set to: " + (ftplib.PassiveMode ? "Passive" : "Active"));
					}
					else
						Console.WriteLine("E: Invalid value for set mode option.");
					break;
				default:
					Console.WriteLine("E: Unrecognized option for set.");
					break;
			}

			return;
		}

		static void cd(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}

				ftplib.ChangeDir(Regex.Replace(command, "cd ", ""));
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void pwd()
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				Console.WriteLine(ftplib.GetWorkingDirectory());
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void mkdir(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}

				ftplib.MakeDir(Regex.Replace(command, "mkdir ", ""));
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void rmdir(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}

				ftplib.RemoveDir(Regex.Replace(command, "rmdir ", ""));
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void rm(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}

				ftplib.RemoveFile(Regex.Replace(command, "rm ", ""));
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void rename(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				char [] cSepar = { ' ' };
				string[] sNames = Regex.Replace(command, "ren ", "").Split(cSepar, 2);
				ftplib.RenameFile(sNames[0], sNames[1]);
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void open(string command)
		{
			try 
			{
				Console.WriteLine("--> Connecting...");
				ftplib.Connect(Regex.Replace(command, "open ", ""), ftplib.user, ftplib.pass);
			}
			catch(Exception ex)
			{	
				Console.WriteLine(ex.Message);
			}
		}
        static void waitOpen()   
        {

            while (! ftplib.IsConnected) 
            {
                Console.WriteLine("Reboot Router or Circle Power Line OFF Now");
                           
                //Console.WriteLine("--> Switch Router Now Off ...");
                try
                {
                    //Console.WriteLine("--> Switch Router On ...");
                    //Console.WriteLine("--> Tray Connecting...");
                    ftplib.Connect("192.168.2.1", "adam2", "adam2");
                }
                catch (Exception)
                {
                    //Console.Write("Trying: 192.168.2.1\n");
                    Console.WriteLine("--> Circle Power Line ON Now");
                    try
                    {
                        ftplib.Connect("192.168.178.1", "adam2", "adam2");
                    }
                    catch (Exception)
                    {
                        //Console.Write("Trying: 192.168.178.1\n");
                    }
                }
            }     
        }
		static void close()
		{
			try
			{
				if (ftplib.IsConnected)
				{
					Console.WriteLine("--> Disconnecting.");
					ftplib.Disconnect();
				}
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		// all of the file listing functions return an ArrayList from System.Collections
		static void list(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				foreach(string f in ftplib.List())
					Console.WriteLine(f);
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		// all of the file listing functions return an ArrayList from System.Collections
		static void list_file(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				foreach(string f in ftplib.ListFiles())
					Console.WriteLine(f);
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		// all of the file listing functions return an ArrayList from System.Collections
		static void list_dir(string command)
		{
			try
			{
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				foreach(string f in ftplib.ListDirectories())
					Console.WriteLine(f);
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void raw_date(string command)
		{
			try
			{
				if(!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				Console.WriteLine(ftplib.GetFileDateRaw(Regex.Replace(command, "rawdate ", "")));
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void date(string command)
		{
			try
			{
				if(!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				Console.WriteLine(ftplib.GetFileDate(Regex.Replace(command, "date ", "")).ToString());
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}

		static void download(string command)
		{
			try
			{
				int perc = 0;
			
				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}
				
				// open the file with resume support if it already exists, the last
				// peram should be false for no resume
				ftplib.OpenDownload(Regex.Replace(command, "get ", ""), false);
				while(ftplib.DoDownload() > 0)
				{
					perc = (int)(((ftplib.BytesTotal) * 100) / ftplib.FileSize);
					Console.Write("\rDownloading: {0}/{1} {2}%", ftplib.BytesTotal, ftplib.FileSize, perc);
					Console.Out.Flush();
				}
				Console.WriteLine("");
			}
			catch(Exception ex)
			{
				Console.WriteLine("");
				Console.WriteLine(ex.Message);
			}
		}

        static void upload(string command, string remotePartition)
		{
			try
			{
				int perc = 0;
				string file = Regex.Replace(command, "put ", "");

				if (!ftplib.IsConnected)
				{
					Console.WriteLine("E: Must be connected to a server.");
					return;
				}

				// open an upload
                ftplib.OpenUploadM(file, remotePartition);
				while(ftplib.DoUpload() > 0)
				{
					perc = (int)(((ftplib.BytesTotal) * 100) / ftplib.FileSize);
					Console.Write("\rUpload: {0}/{1} {2}%", ftplib.BytesTotal, ftplib.FileSize, perc);
					Console.Out.Flush();
				}
				Console.WriteLine("");
			}
			catch(Exception ex)
			{
				Console.WriteLine("");
				Console.WriteLine(ex.Message);
			}
		}

		static bool IsInteger(string theValue)
		{
			try
			{
				Convert.ToInt32(theValue);
				return true;
			} 
			catch 
			{
				return false;
			}
		}
	}
}
