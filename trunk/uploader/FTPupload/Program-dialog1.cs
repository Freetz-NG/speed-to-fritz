/* Johann Pascher (johann.pascher@gmail.com)
*/
#region Public using def
using System;
using System.IO;
using System.Drawing;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Net.NetworkInformation;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using ftplib;
#endregion 
namespace ftp
{
    class Program:System.Windows.Forms.Form
	{
        #region Public Variables1
        public int count;
        public Button Start;
        public TextBox tB1;
        #endregion
        #region Private Variables1
        private ProgressBar progressBar1;
        private ProgressBar progressBar2;
        private Label label3;
        private TextBox PBox;
        private TextBox PBox0;
        private CheckBox checkBox1;
        private CheckBox checkBox2;
        private TextBox OEMBox;
        private TextBox WKey;
        private Label label1;
        private Label label2;
        private Label label4;
        private ComboBox ANNEXBox;
        private TextBox textBox1;
        private Button Fsel;
        private OpenFileDialog openFileDialog1;
        private ComboBox RouterIP;
        private Label RouterIPLabel;
        private Label labelGW;
        #endregion
        public static FTP lib = new FTP();	
        #region Constructors
        Program() // ADD THIS CONSTRUCTOR
        {
            InitializeComponent();
            Win32.AllocConsole();//To disable Console - remove this Line
            Console.SetWindowSize(80, 2);
        }
        #endregion
		[STAThread]
        static void Main()
		{
            Application.EnableVisualStyles();
            Application.Run(new Program());
		}
        private void InitializeComponent()
        {
            #region Private IDE
            this.Start = new System.Windows.Forms.Button();
            this.tB1 = new System.Windows.Forms.TextBox();
            this.progressBar1 = new System.Windows.Forms.ProgressBar();
            this.progressBar2 = new System.Windows.Forms.ProgressBar();
            this.label3 = new System.Windows.Forms.Label();
            this.PBox = new System.Windows.Forms.TextBox();
            this.PBox0 = new System.Windows.Forms.TextBox();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.checkBox2 = new System.Windows.Forms.CheckBox();
            this.OEMBox = new System.Windows.Forms.TextBox();
            this.WKey = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.ANNEXBox = new System.Windows.Forms.ComboBox();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.Fsel = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.RouterIP = new System.Windows.Forms.ComboBox();
            this.RouterIPLabel = new System.Windows.Forms.Label();
            this.labelGW = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // Start
            // 
            this.Start.BackColor = System.Drawing.Color.LimeGreen;
            this.Start.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Start.Location = new System.Drawing.Point(10, 415);
            this.Start.Name = "Start";
            this.Start.Size = new System.Drawing.Size(200, 55);
            this.Start.TabIndex = 0;
            this.Start.Text = "Start Upload";
            this.Start.UseVisualStyleBackColor = false;
            this.Start.Click += new System.EventHandler(this.button1_Click);
            // 
            // tB1
            // 
            this.tB1.AcceptsReturn = true;
            this.tB1.AcceptsTab = true;
            this.tB1.BackColor = System.Drawing.SystemColors.MenuText;
            this.tB1.ForeColor = System.Drawing.SystemColors.Info;
            this.tB1.Location = new System.Drawing.Point(227, 135);
            this.tB1.Multiline = true;
            this.tB1.Name = "tB1";
            this.tB1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.tB1.Size = new System.Drawing.Size(389, 355);
            this.tB1.TabIndex = 1;
            this.tB1.TextChanged += new System.EventHandler(this.tB1_TextChanged);
            this.tB1.Validated += new System.EventHandler(this.tB1_TextChanged);
            // 
            // progressBar1
            // 
            this.progressBar1.Location = new System.Drawing.Point(227, 102);
            this.progressBar1.Name = "progressBar1";
            this.progressBar1.Size = new System.Drawing.Size(389, 10);
            this.progressBar1.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressBar1.TabIndex = 2;
            this.progressBar1.Click += new System.EventHandler(this.progressBar1_Click);
            // 
            // progressBar2
            // 
            this.progressBar2.Location = new System.Drawing.Point(227, 63);
            this.progressBar2.Maximum = 150;
            this.progressBar2.Name = "progressBar2";
            this.progressBar2.Size = new System.Drawing.Size(389, 10);
            this.progressBar2.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressBar2.TabIndex = 3;
            this.progressBar2.Click += new System.EventHandler(this.progressBar2_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.SystemColors.ControlText;
            this.label3.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.label3.Location = new System.Drawing.Point(233, 119);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(48, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "FTP Log";
            this.label3.Click += new System.EventHandler(this.label3_Click);
            // 
            // PBox
            // 
            this.PBox.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.PBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PBox.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.PBox.Location = new System.Drawing.Point(227, 81);
            this.PBox.Name = "PBox";
            this.PBox.ReadOnly = true;
            this.PBox.Size = new System.Drawing.Size(389, 13);
            this.PBox.TabIndex = 10;
            this.PBox.Text = "Upload Progress";
            this.PBox.TextChanged += new System.EventHandler(this.PBox_TextChanged);
            // 
            // PBox0
            // 
            this.PBox0.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.PBox0.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PBox0.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.PBox0.Location = new System.Drawing.Point(227, 42);
            this.PBox0.Name = "PBox0";
            this.PBox0.ReadOnly = true;
            this.PBox0.Size = new System.Drawing.Size(389, 13);
            this.PBox0.TabIndex = 11;
            this.PBox0.Text = "Erase Progress";
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Checked = true;
            this.checkBox1.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBox1.Location = new System.Drawing.Point(13, 87);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(87, 17);
            this.checkBox1.TabIndex = 12;
            this.checkBox1.Text = "Clear mtd3/4";
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // checkBox2
            // 
            this.checkBox2.AutoSize = true;
            this.checkBox2.Checked = true;
            this.checkBox2.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBox2.Location = new System.Drawing.Point(110, 87);
            this.checkBox2.Name = "checkBox2";
            this.checkBox2.Size = new System.Drawing.Size(105, 17);
            this.checkBox2.TabIndex = 13;
            this.checkBox2.Text = "Upload Firmware";
            this.checkBox2.UseVisualStyleBackColor = true;
            this.checkBox2.CheckedChanged += new System.EventHandler(this.checkBox2_CheckedChanged);
            // 
            // OEMBox
            // 
            this.OEMBox.Location = new System.Drawing.Point(110, 135);
            this.OEMBox.MaxLength = 5;
            this.OEMBox.Name = "OEMBox";
            this.OEMBox.Size = new System.Drawing.Size(100, 20);
            this.OEMBox.TabIndex = 14;
            this.OEMBox.Text = "avm";
            // 
            // WKey
            // 
            this.WKey.Location = new System.Drawing.Point(110, 170);
            this.WKey.MaxLength = 16;
            this.WKey.Name = "WKey";
            this.WKey.Size = new System.Drawing.Size(100, 20);
            this.WKey.TabIndex = 15;
            this.WKey.Text = "speedboxspeedbox";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(10, 138);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(79, 13);
            this.label1.TabIndex = 16;
            this.label1.Text = "OEM (Banding)";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(10, 173);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(97, 13);
            this.label2.TabIndex = 17;
            this.label2.Text = "Default WLAN Key";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(10, 209);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(65, 13);
            this.label4.TabIndex = 19;
            this.label4.Text = "ANNEX Typ";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // ANNEXBox
            // 
            this.ANNEXBox.FormattingEnabled = true;
            this.ANNEXBox.Items.AddRange(new object[] {
            "A",
            "B",
            "Multi"});
            this.ANNEXBox.Location = new System.Drawing.Point(110, 205);
            this.ANNEXBox.Name = "ANNEXBox";
            this.ANNEXBox.Size = new System.Drawing.Size(100, 21);
            this.ANNEXBox.TabIndex = 22;
            this.ANNEXBox.Text = "Multi";
            this.ANNEXBox.SelectedIndexChanged += new System.EventHandler(this.ANNEXBox_SelectedIndexChanged);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(10, 16);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(606, 20);
            this.textBox1.TabIndex = 23;
            this.textBox1.Text = "kernel.image";
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged_1);
            // 
            // Fsel
            // 
            this.Fsel.Location = new System.Drawing.Point(10, 42);
            this.Fsel.Name = "Fsel";
            this.Fsel.Size = new System.Drawing.Size(200, 31);
            this.Fsel.TabIndex = 24;
            this.Fsel.Text = "Select kernel.image";
            this.Fsel.UseVisualStyleBackColor = true;
            this.Fsel.Click += new System.EventHandler(this.Fsel_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "kernel.image";
            this.openFileDialog1.Title = "Select Firmware";
            // 
            // RouterIP
            // 
            this.RouterIP.FormattingEnabled = true;
            this.RouterIP.Items.AddRange(new object[] {
            "192.168.178.1",
            "192.168.2.1"});
            this.RouterIP.Location = new System.Drawing.Point(110, 241);
            this.RouterIP.Name = "RouterIP";
            this.RouterIP.Size = new System.Drawing.Size(100, 21);
            this.RouterIP.TabIndex = 26;
            this.RouterIP.Text = "192.168.178.1";
            this.RouterIP.SelectedIndexChanged += new System.EventHandler(this.RouterIP_SelectedIndexChanged);
            // 
            // RouterIPLabel
            // 
            this.RouterIPLabel.AutoSize = true;
            this.RouterIPLabel.Location = new System.Drawing.Point(10, 244);
            this.RouterIPLabel.Name = "RouterIPLabel";
            this.RouterIPLabel.Size = new System.Drawing.Size(82, 13);
            this.RouterIPLabel.TabIndex = 27;
            this.RouterIPLabel.Text = "Router Adam IP";
            this.RouterIPLabel.Click += new System.EventHandler(this.RouterIPLabel_Click);
            // 
            // labelGW
            // 
            this.labelGW.AutoSize = true;
            this.labelGW.Location = new System.Drawing.Point(10, 272);
            this.labelGW.Name = "labelGW";
            this.labelGW.Size = new System.Drawing.Size(184, 52);
            this.labelGW.TabIndex = 28;
            this.labelGW.Text = "This Router Adam IP is the same as\r\n the Gateway IP of PC LAN Card.\r\nUse manual s" +
                "ettings off PC LAN.\r\nIP: 192.168.178.2 Mask: 255.255.0.0";
            // 
            // Program
            // 
            this.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.ClientSize = new System.Drawing.Size(627, 499);
            this.Controls.Add(this.labelGW);
            this.Controls.Add(this.RouterIPLabel);
            this.Controls.Add(this.RouterIP);
            this.Controls.Add(this.Fsel);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.ANNEXBox);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.WKey);
            this.Controls.Add(this.OEMBox);
            this.Controls.Add(this.checkBox2);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.PBox0);
            this.Controls.Add(this.PBox);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.progressBar2);
            this.Controls.Add(this.progressBar1);
            this.Controls.Add(this.tB1);
            this.Controls.Add(this.Start);
            this.Name = "Program";
            this.Text = "Firmware Uploader";
            this.Load += new System.EventHandler(this.Program_Load);
            this.Shown += new System.EventHandler(this.Program_Shown);
            this.ResumeLayout(false);
            this.PerformLayout();
            #endregion
        }
        public delegate void UpdateRichEditCallback(string text);
        static void ThreadMethod()
        {
            Thread.Sleep(1000);
        }
        // This method could be called by either the main thread or any of the
        // worker threads
        private void AppendTextBoxLine(string msg)
        {
            if (InvokeRequired)
            {
                object[] pList = { msg };
                tB1.BeginInvoke(new UpdateRichEditCallback(AppendTextBoxLine1), pList);
            }
            else
            {
                AppendTextBoxLine1(msg);
            }
        }
        /// <summary>
        /// Append a line to the TextBox, and make sure the first and last
        /// appends don't show extra space.
        /// </summary>
        /// <param name="myStr">The string you want to show in the TextBox.</param>
        public void AppendTextBoxLine1(string myStr)
        {
            if (tB1.Text.Length > 0)
            {
                tB1.AppendText(Environment.NewLine);
            }
            tB1.AppendText(myStr);
        }
        public void waitOpen(string ip)   
        {
            repeate:
            AppendTextBoxLine("Looking for Router on IP: " + ip + ", Switch Router OFF and On again!");
            Console.WriteLine("Looking for Router on IP: " + ip + ", Switch Router OFF and On again!");
            MessageBox.Show("--> Switch Router Power Line Off And On Again (Reboot), then Klick 'OK' Button Within Three Seconds.  --> If it did not work the first time repeat router reboot.  Attention: Static PC LAN IP settings are needed. IP: 192.168.178.2 Mask: 255.255.0.0 (Optional) GW:" + ip + ". Also make sure no Firewall is active and all other LAN and WLAN Cards are deactivated.", "Reboot",
            MessageBoxButtons.OK, MessageBoxIcon.None);
            //MessageBox.Show("Switch Router OFF and On again!", "Reboot",
            AppendTextBoxLine("--> Start --> Wait for response ...");
            Console.WriteLine("--> Start --> Wait for response ...");
            try
            {
                lib.Connect(ip);
            }
            catch (Exception)
            {
                lib.Disconnect();
                if (ip == "192.168.178.1") ip = "192.168.2.1";
                else if (ip == "192.168.2.1") ip = "192.168.178.1";
                goto repeate;
            }
            lib.ReadResponse();
            Console.WriteLine(lib.ResponseString);
            AppendTextBoxLine(lib.ResponseString);
        }
        public void Open(string ip)
        {
        repeate:
            try
            {
                lib.Connect(ip);
            }
            catch (Exception)
            {
                lib.Disconnect();
                goto repeate;
            }
            lib.ReadResponse();
            Console.WriteLine(lib.ResponseString);
            AppendTextBoxLine(lib.ResponseString);
        }
        public void Login(string user, string pass)
        {
            if (lib.Response != 220)
                lib.Fail();
            quote("USER " + user);
            switch (lib.response)
            {
                case 331:
                    if (pass == null)
                    {
                        lib.Disconnect();
                        throw new Exception("No password has been set.");
                    }
                    quote("PASS " + pass);
                    if (lib.response != 230)
                        lib.Fail();
                    break;
                case 230:
                    break;
            }
            return ;
        }
		public void close()
		{
			try
			{
                if (lib.IsConnected)
				{
					Console.WriteLine("--> Disconnecting.");
                    AppendTextBoxLine("--> Disconnecting.");
                    lib.Disconnect();
				}
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}
		}
        public void upload(string command, string remotePartition)
		{
			try
			{
                //Console.WriteLine("put " + command + " " + remotePartition);
                //AppendTextBoxLine("put " + command + " " + remotePartition);
				int perc = 0;
				string file = Regex.Replace(command, "put ", "");

				if (!lib.IsConnected)
				{
					Console.WriteLine("Error: Must be connected to a server.");
                    AppendTextBoxLine("Error: Must be connected to a server.");
                  	return;
				}
                //---------------------------------------------------------------------------------
				// open an upload;
                quote("PASV");
                lib.GetDataPortFormResponseString();// needs PASV bevore, writes public vars dataserver and dataport
                lib.CloseDataSocket();
                lib.OpenDataSocket();//needs public vars dataserver and dataport
                lib.OpenUploadFile(file);
                lib.SendCommand("STOR " + remotePartition);
                if (remotePartition == "mtd1")
                {
                    AppendTextBoxLine("Erase Flash mtd1 partition, please wait up to three minutes... ");
                    Console.WriteLine("Erase Flash mtd1 partition, please wait up to three minutes... ");
                }
                else
                {
                    Console.WriteLine("Erase " + remotePartition + " partition ...");
                    AppendTextBoxLine("Erase " + remotePartition + " partition ...");
                }
                //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                progressBar2.Value = count;
                while (lib.CheckSocetAvalabel() == false)
                {
                    Console.Write("#");
                    if  (progressBar2.Value > 149) progressBar2.Value = 0;
                    progressBar2.Value += 1;
                    this.PBox0.Clear();
                    this.PBox0.AppendText("Erase: " + progressBar2.Value + " sec elapsed");
                }
                count = progressBar2.Value;
                Console.WriteLine("");
                progressBar2.Value = 150;
                String xStr = lib.ReadResponse();
                Console.WriteLine(xStr);
                AppendTextBoxLine(xStr);
                Console.WriteLine("STOR " + remotePartition);
                AppendTextBoxLine("STOR " + remotePartition);
                lib.CheckStor();
                while (lib.DoUpload512() > 0)
				{
                    perc = (int)(((lib.BytesTotal) * 100) / lib.FileSize);
                    Console.Write("\rUpload: {0}/{1} {2}%", lib.BytesTotal, lib.FileSize, perc);
                    this.PBox.Clear();
                    this.PBox.AppendText("Upload kernel.image to mtd1: " + lib.BytesTotal + " Bytes of " + lib.FileSize + " Byts => " + progressBar1.Value + " %");
                    if (perc > 99) perc = 100;
                    progressBar1.Value = perc;
					Console.Out.Flush();
				}
                Console.WriteLine("");
                Console.WriteLine(lib.ResponseString);
                AppendTextBoxLine(lib.ResponseString);
			}
			catch(Exception ex)
			{
				Console.WriteLine("");
				Console.WriteLine(ex.Message);
                AppendTextBoxLine(ex.Message);
			}
		}
        private void button1_Click(object sender, EventArgs e)
        {
            count = 0;
            progressBar1.Value = 0;
            TestKI();
            lib.port = 21;
            String oem = "avm", annex = "Multi", pmtd23 = "clear", pmtd1 = "push", wkey = "speedboxspeedbox", ip = "192.168.178.1";
            oem = this.OEMBox.Text;
            annex = this.ANNEXBox.Text;
            wkey = this.WKey.Text;
            ip = this.RouterIP.Text;
            if (this.checkBox1.Checked == false) pmtd23 = "noclear";
            if (this.checkBox1.Checked == true) pmtd23 = "clear";
            if (this.checkBox2.Checked == false) pmtd1 = "nopush";
            if (this.checkBox2.Checked == true) pmtd1 = "push";
            DoIt(oem, annex, pmtd23, pmtd1, wkey, ip);
            if (pmtd23 == "clear") DoItAgain(oem, annex, pmtd23, pmtd1, wkey, ip);
        }
        public void DoIt(String oem, String annex, String pmtd23, String pmtd1, String wkey, String ip)
        {
            waitOpen(ip);
            Login("adam2", "adam2");
            //Console.WriteLine("-->");
            //AppendTextBoxLine("-->");
            ///*
            quote("SYST");
            getenv("GETENV HWRevision");
            getenv("GETENV ProductID");
            getenv("GETENV annex");
            getenv("GETENV autoload");
            getenv("GETENV bootloaderVersion");
            getenv("GETENV firmware_version");
            getenv("GETENV bootserverport");
            getenv("GETENV bluetooth");
            getenv("GETENV cpufrequency");
            getenv("GETENV firstfreeaddress");
            getenv("GETENV flashsize");
            getenv("GETENV jffs2_size");
            getenv("GETENV kernel_args");
            getenv("GETENV sysfrequency");
            getenv("GETENV req_fullrate_freq");
            getenv("GETENV firmware_info");
            getenv("GETENV prompt");
            getenv("GETENV urlader-version");
            getenv("GETENV usb_board_mac");
            getenv("GETENV usb_rndis_mac");
            getenv("GETENV usb_device_id");
            getenv("GETENV my_ipaddress");
            getenv("GETENV macdsl");
            getenv("GETENV maca");
            getenv("GETENV macb");
            getenv("GETENV macwlan");
            getenv("GETENV wlan_key");
            ///*/
            quote("TYPE I");
            quote("MEDIA FLSH");
            ///*
            quote("CHECK mtd1");
            quote("CHECK mtd2");
            quote("CHECK mtd3");
            quote("CHECK mtd4");
            quote("CHECK mtd5");
            quote("CHECK mtd6");
             ///*/
            quote("SETENV autoload no");
            quote("SETENV my_ipaddress 192.168.178.1");
            quote("SETENV firmware_version " + oem);
            if ((annex == "B") || (annex == "A")) { quote("SETENV kernel_args annex=" + annex); }
            quote("SETENV wlan_key " + wkey);
            quote("SYST");
            quote("TYPE I");
            quote("MEDIA FLSH");
            if(pmtd1 == "push")try{upload("kernel.image","mtd1");}catch(Exception){}
            if (pmtd23 == "clear")
            {
                try { upload("filesystem.image", "mtd3"); } catch (Exception) { } 
                try { upload("filesystem.image", "mtd4"); } catch (Exception) { }
                quote("SETENV my_ipaddress 192.168.178.1");
                quote("SETENV firmware_version " + oem);
                if ((annex == "B") || (annex == "A")) { quote("SETENV kernel_args annex=" + annex); }
                quote("SETENV wlan_key " + wkey);
                //quote("SETENV autoload yes");
            }
            quote("REBOOT");
            close();
        }
        public void DoItAgain(String oem, String annex, String pmtd23, String pmtd1, String wkey, String ip)
        {
            Open("192.168.2.1");
            Open("192.168.2.1");
            Login("adam2", "adam2");
            quote("SETENV my_ipaddress 192.168.178.1");
            quote("SETENV firmware_version " + oem);
            if ((annex == "B") || (annex == "A")) { quote("SETENV kernel_args annex=" + annex); }
            quote("SETENV wlan_key " + wkey);
            quote("SETENV autoload yes");
            quote("REBOOT");
            close();
        }
        private void quote(String command)
        {
                lib.SendCommand(command);
                Console.WriteLine(command);
                AppendTextBoxLine(command);
                String rStr = lib.ReadResponse();
                Console.WriteLine(rStr);
                AppendTextBoxLine(rStr);
                //Console.WriteLine(lib.Messages);
                //AppendTextBoxLine(lib.Messages);
        }
        private void getenv(String command)
        {
            lib.SendCommand(command);
            Console.WriteLine(command);
            String rStr = lib.ReadResponse();
            Console.WriteLine(rStr);
            Console.WriteLine(lib.Messages);
        }
        private void tB1_TextChanged(object sender, EventArgs e)
        {
        }
        private void Program_Load(object sender, EventArgs e)
        {
            string[] args = Environment.GetCommandLineArgs();
            try
            {
                if ((args.Length == 8) && (TestKI()))
                {
                    String oem = args[2], annex = args[3], pmtd23 = args[4], pmtd1 = args[5], wkey = args[6], ip = args[7];
                    //AppendTextBoxLine("Commandline Args: " + "oem: " + oem + " annex: " + annex + " clear: " + pmtd23 + " push: " + pmtd1 + " wkey: " + wkey + " ip: " + ip);
                    lib.port = 21;
                    this.OEMBox.Text = oem;
                    this.ANNEXBox.Text = annex;
                    this.WKey.Text = wkey;
                    this.RouterIP.Text = ip;
                    if (pmtd23 != "clear") this.checkBox1.Checked = false;
                    if (pmtd23 == "clear") this.checkBox1.Checked = true;
                    if (pmtd1 != "push") this.checkBox2.Checked = false;
                    if (pmtd1 == "push") this.checkBox2.Checked = true;
                }
            }
            catch { }
            #region create firmware.image Datei
            // Create the new, empty data file.
            const string FILE_NAME = "filesystem.image";
            if (File.Exists(FILE_NAME) == false ) 
            {
                FileStream fs = new FileStream(FILE_NAME, FileMode.CreateNew);
                fs.Close();
            }
            #endregion
        }
        private void Program_Shown(object sender, EventArgs e)
        {
            string[] args = Environment.GetCommandLineArgs();
            if (args.Length == 8)
            {
                try
                {
                    this.Start.PerformClick();
                    this.Start.Hide();
                }
                catch { }
            }
        }
        private bool TestKI()
        {
            const string FILE_NAME = "kernel.image";
            if (File.Exists(FILE_NAME) == false)
            {
                MessageBox.Show("File kernel.image not found within the same directory from where this tool ware executed, copy or select a file first. 'kernel.image' file can be extracted from every AVM Firmware. Rename Firmware to any name with extension 'tar', untar and look into the subdirectory var/tmp.", "kernel.image",
                MessageBoxButtons.OK, MessageBoxIcon.None);
                return false;
            }
            return true;
        }
    #region File Select
        private void Fsel_Click(object sender, EventArgs e)
        {
            this.openFileDialog1.DefaultExt = ".image"; // Default file extension
            this.openFileDialog1.Filter = "Firmware Files (.image)|*.image|All files (*.*)|*.*"; // Filter files by extension

                openFileDialog1.FilterIndex = 2;
                openFileDialog1.RestoreDirectory = true;

                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    {
                        if (File.Exists(openFileDialog1.FileName))
                        {
                            textBox1.Text = this.openFileDialog1.FileName;
                            string path2 = "kernel.image";
                            try
                            {
                                File.Delete(path2);
                                File.Copy(openFileDialog1.FileName, path2);
                                Debug.WriteLine("{0} copied to {1}", openFileDialog1.FileName, path2);
                                //AppendTextBoxLine(openFileDialog1.FileName + " copied to " + path2);
                            }
                            catch
                            {
                                Debug.WriteLine("Copy Error ");
                                AppendTextBoxLine("Copy Error ");
                            }

                        }
                    }
                }

        }
        #endregion
        #region Unused
        private void eventLog1_EntryWritten(object sender, System.Diagnostics.EntryWrittenEventArgs e)
        {

        }

        private void progressBar1_Click(object sender, EventArgs e)
        {

        }

        private void backgroundWorker1_DoWork(object sender, System.ComponentModel.DoWorkEventArgs e)
        {

        }

        private void progressBar2_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void PBox_TextChanged(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void openFileDialog_FileOk(object sender, System.ComponentModel.CancelEventArgs e)
        {

        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void ANNEXBox_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void RouterIPLabel_Click(object sender, EventArgs e)
        {

        }

        private void RouterIP_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
	}
    #endregion
    #region Console
    public class Win32
    {
        /// <summary>
        /// Allocates a new console for current process.
        /// </summary>
        [System.Runtime.InteropServices.DllImport("kernel32.dll")]
        public static extern Boolean AllocConsole();

        /// <summary>
        /// Frees the console.
        /// </summary>
        [System.Runtime.InteropServices.DllImport("kernel32.dll")]
        public static extern Boolean FreeConsole();
    }
    #endregion
}
