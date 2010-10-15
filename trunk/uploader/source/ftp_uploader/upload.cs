/* Johann Pascher (johann.pascher@gmail.com)
*/
#region Public using def

using System.ComponentModel;
using System.Globalization;
using System.Drawing;
using System.Threading;



using System;
using System.IO;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Text;
/*using System.Net.NetworkInformation;
using System.Net;
using System.Net.Sockets;
*/
using ftplib;
using ICSharpCode.SharpZipLib.Tar;
using System.Resources;

#endregion 
namespace ftp
{
    public class Form1 : Form
    {
        #region Public Variables
        public int count;
        public Button Start;
        public TextBox tB1;
        #endregion
        #region Private Variables
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
        private Label testText;
        private Label labelLooking;
        private Label label7;
        private Label labelSwitch;
        private Label labelStartWait;
        private Label labelNoPW;
        private Label labelPartition;
        private Label labelErase;
        private Label labelErasemtd1;
        private Label label10;
        private Label labelErrorServer;
        private Label labelSecElapsed;
        private Label labelOf;
        private Label labelUploadmtd1;
        private Label labelKInotfound;
        private Label labelFreetzPackages;
        private Label labelLogWrittenTo;
#endregion
        private Label labelDisconnecting;
        private ToolTip toolTip1;
        private Button buttonSP;
        public static FTP lib = new FTP();
        public Form1()
        {
            //Thread.CurrentThread.CurrentUICulture = new CultureInfo("en-US");
            InitializeComponent();
            Win32.AllocConsole();//To disable Console - remove this Line
            Console.SetWindowSize(80, 2);
        }
        #region Windows Form Designer generated code

        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        /// <summary>
        /// Required method for Designer support
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
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
            this.testText = new System.Windows.Forms.Label();
            this.labelLooking = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.labelSwitch = new System.Windows.Forms.Label();
            this.labelStartWait = new System.Windows.Forms.Label();
            this.labelNoPW = new System.Windows.Forms.Label();
            this.labelPartition = new System.Windows.Forms.Label();
            this.labelErase = new System.Windows.Forms.Label();
            this.labelErasemtd1 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.labelErrorServer = new System.Windows.Forms.Label();
            this.labelSecElapsed = new System.Windows.Forms.Label();
            this.labelOf = new System.Windows.Forms.Label();
            this.labelUploadmtd1 = new System.Windows.Forms.Label();
            this.labelKInotfound = new System.Windows.Forms.Label();
            this.labelFreetzPackages = new System.Windows.Forms.Label();
            this.labelLogWrittenTo = new System.Windows.Forms.Label();
            this.labelDisconnecting = new System.Windows.Forms.Label();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.buttonSP = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // Start
            // 
            resources.ApplyResources(this.Start, "Start");
            this.Start.BackColor = System.Drawing.Color.LimeGreen;
            this.Start.Name = "Start";
            this.toolTip1.SetToolTip(this.Start, resources.GetString("Start.ToolTip"));
            this.Start.UseVisualStyleBackColor = false;
            this.Start.Click += new System.EventHandler(this.button1_Click);
            // 
            // tB1
            // 
            this.tB1.AcceptsReturn = true;
            this.tB1.AcceptsTab = true;
            resources.ApplyResources(this.tB1, "tB1");
            this.tB1.BackColor = System.Drawing.SystemColors.MenuText;
            this.tB1.ForeColor = System.Drawing.SystemColors.Info;
            this.tB1.Name = "tB1";
            this.toolTip1.SetToolTip(this.tB1, resources.GetString("tB1.ToolTip"));
            this.tB1.TextChanged += new System.EventHandler(this.tB1_TextChanged);
            this.tB1.Validated += new System.EventHandler(this.tB1_TextChanged);
            // 
            // progressBar1
            // 
            resources.ApplyResources(this.progressBar1, "progressBar1");
            this.progressBar1.Name = "progressBar1";
            this.progressBar1.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.toolTip1.SetToolTip(this.progressBar1, resources.GetString("progressBar1.ToolTip"));
            this.progressBar1.Click += new System.EventHandler(this.progressBar1_Click);
            // 
            // progressBar2
            // 
            resources.ApplyResources(this.progressBar2, "progressBar2");
            this.progressBar2.Maximum = 200;
            this.progressBar2.Name = "progressBar2";
            this.progressBar2.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.toolTip1.SetToolTip(this.progressBar2, resources.GetString("progressBar2.ToolTip"));
            this.progressBar2.Click += new System.EventHandler(this.progressBar2_Click);
            // 
            // label3
            // 
            resources.ApplyResources(this.label3, "label3");
            this.label3.BackColor = System.Drawing.SystemColors.ControlText;
            this.label3.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.label3.Name = "label3";
            this.toolTip1.SetToolTip(this.label3, resources.GetString("label3.ToolTip"));
            this.label3.Click += new System.EventHandler(this.label3_Click);
            // 
            // PBox
            // 
            resources.ApplyResources(this.PBox, "PBox");
            this.PBox.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.PBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PBox.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.PBox.Name = "PBox";
            this.PBox.ReadOnly = true;
            this.toolTip1.SetToolTip(this.PBox, resources.GetString("PBox.ToolTip"));
            this.PBox.TextChanged += new System.EventHandler(this.PBox_TextChanged);
            // 
            // PBox0
            // 
            resources.ApplyResources(this.PBox0, "PBox0");
            this.PBox0.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.PBox0.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PBox0.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.PBox0.Name = "PBox0";
            this.PBox0.ReadOnly = true;
            this.toolTip1.SetToolTip(this.PBox0, resources.GetString("PBox0.ToolTip"));
            // 
            // checkBox1
            // 
            resources.ApplyResources(this.checkBox1, "checkBox1");
            this.checkBox1.Checked = true;
            this.checkBox1.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBox1.Name = "checkBox1";
            this.toolTip1.SetToolTip(this.checkBox1, resources.GetString("checkBox1.ToolTip"));
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // checkBox2
            // 
            resources.ApplyResources(this.checkBox2, "checkBox2");
            this.checkBox2.Checked = true;
            this.checkBox2.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBox2.Name = "checkBox2";
            this.toolTip1.SetToolTip(this.checkBox2, resources.GetString("checkBox2.ToolTip"));
            this.checkBox2.UseVisualStyleBackColor = true;
            this.checkBox2.CheckedChanged += new System.EventHandler(this.checkBox2_CheckedChanged);
            // 
            // OEMBox
            // 
            resources.ApplyResources(this.OEMBox, "OEMBox");
            this.OEMBox.BackColor = System.Drawing.Color.White;
            this.OEMBox.Name = "OEMBox";
            this.toolTip1.SetToolTip(this.OEMBox, resources.GetString("OEMBox.ToolTip"));
            // 
            // WKey
            // 
            resources.ApplyResources(this.WKey, "WKey");
            this.WKey.Name = "WKey";
            this.toolTip1.SetToolTip(this.WKey, resources.GetString("WKey.ToolTip"));
            // 
            // label1
            // 
            resources.ApplyResources(this.label1, "label1");
            this.label1.Name = "label1";
            this.toolTip1.SetToolTip(this.label1, resources.GetString("label1.ToolTip"));
            // 
            // label2
            // 
            resources.ApplyResources(this.label2, "label2");
            this.label2.Name = "label2";
            this.toolTip1.SetToolTip(this.label2, resources.GetString("label2.ToolTip"));
            // 
            // label4
            // 
            resources.ApplyResources(this.label4, "label4");
            this.label4.Name = "label4";
            this.toolTip1.SetToolTip(this.label4, resources.GetString("label4.ToolTip"));
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // ANNEXBox
            // 
            resources.ApplyResources(this.ANNEXBox, "ANNEXBox");
            this.ANNEXBox.FormattingEnabled = true;
            this.ANNEXBox.Items.AddRange(new object[] {
            resources.GetString("ANNEXBox.Items"),
            resources.GetString("ANNEXBox.Items1"),
            resources.GetString("ANNEXBox.Items2")});
            this.ANNEXBox.Name = "ANNEXBox";
            this.toolTip1.SetToolTip(this.ANNEXBox, resources.GetString("ANNEXBox.ToolTip"));
            this.ANNEXBox.SelectedIndexChanged += new System.EventHandler(this.ANNEXBox_SelectedIndexChanged);
            // 
            // textBox1
            // 
            resources.ApplyResources(this.textBox1, "textBox1");
            this.textBox1.Name = "textBox1";
            this.toolTip1.SetToolTip(this.textBox1, resources.GetString("textBox1.ToolTip"));
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged_1);
            // 
            // Fsel
            // 
            resources.ApplyResources(this.Fsel, "Fsel");
            this.Fsel.Name = "Fsel";
            this.toolTip1.SetToolTip(this.Fsel, resources.GetString("Fsel.ToolTip"));
            this.Fsel.UseVisualStyleBackColor = true;
            this.Fsel.Click += new System.EventHandler(this.Fsel_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "kernel.image";
            resources.ApplyResources(this.openFileDialog1, "openFileDialog1");
            this.openFileDialog1.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog1_FileOk);
            // 
            // RouterIP
            // 
            resources.ApplyResources(this.RouterIP, "RouterIP");
            this.RouterIP.FormattingEnabled = true;
            this.RouterIP.Items.AddRange(new object[] {
            resources.GetString("RouterIP.Items"),
            resources.GetString("RouterIP.Items1")});
            this.RouterIP.Name = "RouterIP";
            this.toolTip1.SetToolTip(this.RouterIP, resources.GetString("RouterIP.ToolTip"));
            this.RouterIP.SelectedIndexChanged += new System.EventHandler(this.RouterIP_SelectedIndexChanged);
            // 
            // RouterIPLabel
            // 
            resources.ApplyResources(this.RouterIPLabel, "RouterIPLabel");
            this.RouterIPLabel.Name = "RouterIPLabel";
            this.toolTip1.SetToolTip(this.RouterIPLabel, resources.GetString("RouterIPLabel.ToolTip"));
            this.RouterIPLabel.Click += new System.EventHandler(this.RouterIPLabel_Click);
            // 
            // labelGW
            // 
            resources.ApplyResources(this.labelGW, "labelGW");
            this.labelGW.Name = "labelGW";
            this.toolTip1.SetToolTip(this.labelGW, resources.GetString("labelGW.ToolTip"));
            this.labelGW.Click += new System.EventHandler(this.labelGW_Click);
            // 
            // testText
            // 
            resources.ApplyResources(this.testText, "testText");
            this.testText.Name = "testText";
            this.toolTip1.SetToolTip(this.testText, resources.GetString("testText.ToolTip"));
            this.testText.Click += new System.EventHandler(this.label5_Click);
            // 
            // labelLooking
            // 
            resources.ApplyResources(this.labelLooking, "labelLooking");
            this.labelLooking.Name = "labelLooking";
            this.toolTip1.SetToolTip(this.labelLooking, resources.GetString("labelLooking.ToolTip"));
            // 
            // label7
            // 
            resources.ApplyResources(this.label7, "label7");
            this.label7.Name = "label7";
            this.toolTip1.SetToolTip(this.label7, resources.GetString("label7.ToolTip"));
            // 
            // labelSwitch
            // 
            resources.ApplyResources(this.labelSwitch, "labelSwitch");
            this.labelSwitch.Name = "labelSwitch";
            this.toolTip1.SetToolTip(this.labelSwitch, resources.GetString("labelSwitch.ToolTip"));
            // 
            // labelStartWait
            // 
            resources.ApplyResources(this.labelStartWait, "labelStartWait");
            this.labelStartWait.Name = "labelStartWait";
            this.toolTip1.SetToolTip(this.labelStartWait, resources.GetString("labelStartWait.ToolTip"));
            // 
            // labelNoPW
            // 
            resources.ApplyResources(this.labelNoPW, "labelNoPW");
            this.labelNoPW.Name = "labelNoPW";
            this.toolTip1.SetToolTip(this.labelNoPW, resources.GetString("labelNoPW.ToolTip"));
            // 
            // labelPartition
            // 
            resources.ApplyResources(this.labelPartition, "labelPartition");
            this.labelPartition.Name = "labelPartition";
            this.toolTip1.SetToolTip(this.labelPartition, resources.GetString("labelPartition.ToolTip"));
            // 
            // labelErase
            // 
            resources.ApplyResources(this.labelErase, "labelErase");
            this.labelErase.Name = "labelErase";
            this.toolTip1.SetToolTip(this.labelErase, resources.GetString("labelErase.ToolTip"));
            // 
            // labelErasemtd1
            // 
            resources.ApplyResources(this.labelErasemtd1, "labelErasemtd1");
            this.labelErasemtd1.Name = "labelErasemtd1";
            this.toolTip1.SetToolTip(this.labelErasemtd1, resources.GetString("labelErasemtd1.ToolTip"));
            // 
            // label10
            // 
            resources.ApplyResources(this.label10, "label10");
            this.label10.Name = "label10";
            this.toolTip1.SetToolTip(this.label10, resources.GetString("label10.ToolTip"));
            // 
            // labelErrorServer
            // 
            resources.ApplyResources(this.labelErrorServer, "labelErrorServer");
            this.labelErrorServer.Name = "labelErrorServer";
            this.toolTip1.SetToolTip(this.labelErrorServer, resources.GetString("labelErrorServer.ToolTip"));
            // 
            // labelSecElapsed
            // 
            resources.ApplyResources(this.labelSecElapsed, "labelSecElapsed");
            this.labelSecElapsed.Name = "labelSecElapsed";
            this.toolTip1.SetToolTip(this.labelSecElapsed, resources.GetString("labelSecElapsed.ToolTip"));
            this.labelSecElapsed.Click += new System.EventHandler(this.label6_Click_1);
            // 
            // labelOf
            // 
            resources.ApplyResources(this.labelOf, "labelOf");
            this.labelOf.Name = "labelOf";
            this.toolTip1.SetToolTip(this.labelOf, resources.GetString("labelOf.ToolTip"));
            // 
            // labelUploadmtd1
            // 
            resources.ApplyResources(this.labelUploadmtd1, "labelUploadmtd1");
            this.labelUploadmtd1.Name = "labelUploadmtd1";
            this.toolTip1.SetToolTip(this.labelUploadmtd1, resources.GetString("labelUploadmtd1.ToolTip"));
            // 
            // labelKInotfound
            // 
            resources.ApplyResources(this.labelKInotfound, "labelKInotfound");
            this.labelKInotfound.Name = "labelKInotfound";
            this.toolTip1.SetToolTip(this.labelKInotfound, resources.GetString("labelKInotfound.ToolTip"));
            // 
            // labelFreetzPackages
            // 
            resources.ApplyResources(this.labelFreetzPackages, "labelFreetzPackages");
            this.labelFreetzPackages.Name = "labelFreetzPackages";
            this.toolTip1.SetToolTip(this.labelFreetzPackages, resources.GetString("labelFreetzPackages.ToolTip"));
            // 
            // labelLogWrittenTo
            // 
            resources.ApplyResources(this.labelLogWrittenTo, "labelLogWrittenTo");
            this.labelLogWrittenTo.Name = "labelLogWrittenTo";
            this.toolTip1.SetToolTip(this.labelLogWrittenTo, resources.GetString("labelLogWrittenTo.ToolTip"));
            // 
            // labelDisconnecting
            // 
            resources.ApplyResources(this.labelDisconnecting, "labelDisconnecting");
            this.labelDisconnecting.Name = "labelDisconnecting";
            this.toolTip1.SetToolTip(this.labelDisconnecting, resources.GetString("labelDisconnecting.ToolTip"));
            // 
            // toolTip1
            // 
            this.toolTip1.IsBalloon = true;
            // 
            // buttonSP
            // 
            resources.ApplyResources(this.buttonSP, "buttonSP");
            this.buttonSP.Name = "buttonSP";
            this.toolTip1.SetToolTip(this.buttonSP, resources.GetString("buttonSP.ToolTip"));
            this.buttonSP.UseVisualStyleBackColor = true;
            this.buttonSP.Click += new System.EventHandler(this.buttonSP_Click);
            // 
            // Form1
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.Controls.Add(this.buttonSP);
            this.Controls.Add(this.labelDisconnecting);
            this.Controls.Add(this.labelKInotfound);
            this.Controls.Add(this.labelFreetzPackages);
            this.Controls.Add(this.labelLogWrittenTo);
            this.Controls.Add(this.labelOf);
            this.Controls.Add(this.labelUploadmtd1);
            this.Controls.Add(this.labelSecElapsed);
            this.Controls.Add(this.labelPartition);
            this.Controls.Add(this.labelErase);
            this.Controls.Add(this.labelErasemtd1);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.labelErrorServer);
            this.Controls.Add(this.labelNoPW);
            this.Controls.Add(this.labelStartWait);
            this.Controls.Add(this.labelSwitch);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.labelLooking);
            this.Controls.Add(this.testText);
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
            this.Name = "Form1";
            this.toolTip1.SetToolTip(this, resources.GetString("$this.ToolTip"));
            this.Load += new System.EventHandler(this.Program_Load);
            this.Shown += new System.EventHandler(this.Program_Shown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        #endregion
        /// <summary>
        /// Append a line to the TextBox, and make sure the first and last
        /// appends don't show extra space.
        /// </summary>
        /// <param name="myStr">The string you want to show in the TextBox.</param>
        public void AppendTextBoxLine(string myStr)
        {
            if ((tB1.Text.Length > 0) && (myStr.Length > 3))
            {
                tB1.AppendText(Environment.NewLine);
            }
            tB1.AppendText(myStr);
        }
        public void waitOpen(string ip)
        {
        repeate:
            AppendTextBoxLine(labelLooking.Text + ip + labelSwitch.Text);
            Console.WriteLine(labelLooking.Text + ip + labelSwitch.Text);
            // Assign the string for the "strMessage" key to a messagebox
            //MessageBox.Show(LocRM.GetString("strMessage"));
            string PCip = "192.168.2.2";
            if (ip == "192.168.178.1")  PCip = "192.168.178.2";
            MessageBox.Show(this.testText.Text + PCip, "Reboot",
            //MessageBox.Show("--> Switch Router Power Line Off And On Again,\n   then Click 'OK' Button Within Three Seconds.\n\n--> If it did not work the first time wait until this Popup comes up again and repeat.\n\nAttention:\n    Static PC LAN IP settings are needed. IP: 192.168.178.2 Mask: 255.255.0.0 (Optional GW:" + ip + ").", "Reboot",
            MessageBoxButtons.OK, MessageBoxIcon.None);
            //MessageBox.Show("Switch Router OFF and On again!", "Reboot",
            AppendTextBoxLine(labelStartWait.Text);
            Console.WriteLine(labelStartWait.Text);
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
                        throw new Exception(labelNoPW.Text);
                    }
                    quote("PASS " + pass);
                    if (lib.response != 230)
                        lib.Fail();
                    break;
                case 230:
                    break;
            }
            return;
        }
        public void close()
        {
            try
            {
                if (lib.IsConnected)
                {
                    Console.WriteLine(labelDisconnecting.Text);
                    AppendTextBoxLine(labelDisconnecting.Text);
                    lib.Disconnect();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
        public void upload(string command, string remotePartition)
        {
            try
            {
                int perc = 0;
                string file = Regex.Replace(command, "put ", "");
                if (!lib.IsConnected)
                {
                    Console.WriteLine(labelErrorServer.Text);
                    AppendTextBoxLine(labelErrorServer.Text);
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
                    AppendTextBoxLine(labelErasemtd1.Text);
                    Console.WriteLine(labelErasemtd1.Text);
                }
                else
                {
                    Console.WriteLine(labelErase.Text + remotePartition + labelPartition.Text);
                    AppendTextBoxLine(labelErase.Text + remotePartition + labelPartition.Text);
                }
                //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                Console.WriteLine("--> ");
                progressBar2.Value = count;
                while (lib.CheckSocetAvalabel() == false)
                {
                    Console.Write("#");
                    if (progressBar2.Value > 199) progressBar2.Value = 0;
                    progressBar2.Value += 1;
                    this.PBox0.Clear();
                    this.PBox0.AppendText(labelErase.Text + progressBar2.Value + labelSecElapsed.Text);
                    Application.DoEvents();
                }
                count = progressBar2.Value;
                Console.WriteLine("");
                progressBar2.Value = 200;
                String xStr = lib.ReadResponse();
                Console.WriteLine(xStr);
                AppendTextBoxLine(xStr);
                Console.WriteLine("STOR " + remotePartition);
                AppendTextBoxLine("STOR " + remotePartition);
                lib.CheckStor();
                while (lib.DoUpload1460() > 0)
                {
                    perc = (int)(((lib.BytesTotal) * 100) / lib.FileSize);
                    Console.Write("\rUpload: {0}/{1} {2}%", lib.BytesTotal, lib.FileSize, perc);
                    this.PBox.Clear();
                    this.PBox.AppendText(labelUploadmtd1.Text + lib.BytesTotal + " Byts " + labelOf.Text + lib.FileSize + " Byts => " + progressBar1.Value + " %");
                    if (perc >= 99) perc = 100;
                    progressBar1.Value = perc;
                    Console.Out.Flush();
                    Application.DoEvents();
                }
                Console.WriteLine("");
                Console.WriteLine(lib.ResponseString);
                AppendTextBoxLine(lib.ResponseString);
            }
            catch (Exception ex)
            {
                Console.WriteLine("");
                Console.WriteLine(ex.Message);
                AppendTextBoxLine(ex.Message);
            }
        }
        private void button1_Click(object sender, EventArgs e)
        {
            this.Start.Enabled = false;
            count = 0;
            progressBar1.Value = 0;
            lib.port = 21;
            String oem = "avm", annex = "Multi", pmtd34 = "clear", pmtd1 = "push", wkey = "speedboxspeedbox", ip = "192.168.178.1";
            oem = this.OEMBox.Text;
            annex = this.ANNEXBox.Text;
            wkey = this.WKey.Text;
            ip = this.RouterIP.Text;
            if (this.checkBox1.Checked == false) pmtd34 = "noclear";
            if (this.checkBox1.Checked == true) pmtd34 = "clear";
            if (this.checkBox2.Checked == false) pmtd1 = "nopush";
            if (this.checkBox2.Checked == true)
            {
                pmtd1 = "push";
                TestKI();
            }
            DoIt(oem, annex, pmtd34, pmtd1, wkey, ip);
            if (pmtd34 == "clear") DoItAgain(oem, annex, pmtd34, pmtd1, wkey, ip);
            DateTime date1 = DateTime.Now;
            String Logname = (date1.ToString("MMddyyyyHHmm"));
            this.tB1.Text = this.tB1.Text.Trim();
            //tB1.Text = Regex.Replace(tB1.Text, "(?<Text>.*)(?:[\r]?(?:\r)?)", "${Text}\r\n");
            //textBox1.Text = Regex.Replace(textBox1.Text, "(?<Text>.*)(?:[\r\n]?(?:\r\n)?)", "${Text}\r\n");
            // Remove trailing blanks
            tB1.Text = Regex.Replace(tB1.Text, "\\s+\r\n", "\r\n");
            // Remove duplicate end-of-lines
            tB1.Text = Regex.Replace(tB1.Text, "\r\n\r\n", "\r\n");
            // Remove duplicate return
            tB1.Text = Regex.Replace(tB1.Text, "\r+", "\r");
            // Remove duplicate new lines
            tB1.Text = Regex.Replace(tB1.Text, "\n+", "\n");
            System.IO.File.WriteAllText(@Logname + ".log", tB1.Text);
            AppendTextBoxLine(labelLogWrittenTo.Text + Logname + ".log");
            Console.WriteLine(labelLogWrittenTo.Text + Logname + ".log");         
            this.Start.Enabled = true;
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
            getenv("GETENV SerialNumber");
            getenv("GETENV annex");
            getenv("GETENV autoload");
            getenv("GETENV bootloaderVersion");
            getenv("GETENV bootserport");
            getenv("GETENV cpufrequency");
            getenv("GETENV firstfreeaddress");
            getenv("GETENV firmware_version");
            getenv("GETENV firmware_info");
            getenv("GETENV flashsize");
            getenv("GETENV jffs2_size");
            getenv("GETENV kernel_args");
            getenv("GETENV maca");
            getenv("GETENV macb");
            getenv("GETENV macwlan");
            getenv("GETENV macdsl");
            getenv("GETENV memsize");
            getenv("GETENV modetty1");
            getenv("GETENV modetty2");
            getenv("GETENV bootserverport");
            getenv("GETENV bluetooth");
            getenv("GETENV mtd0");
            getenv("GETENV mtd1");
            getenv("GETENV mtd2");
            getenv("GETENV mtd3");
            getenv("GETENV mtd4");
            getenv("GETENV my_ipaddress");
            getenv("GETENV prompt");
            getenv("GETENV req_fullrate_freq");
            getenv("GETENV sysfrequency");
            getenv("GETENV urlader-version");
            getenv("GETENV usb_board_mac");
            getenv("GETENV usb_rndis_mac");
            getenv("GETENV usb_device_id");
            getenv("GETENV usb_revision_id");
            getenv("GETENV usb_manufacturer_name");
            getenv("GETENV webgui_pass");
            getenv("GETENV wlan");
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
            quote("SETENV my_ipaddress 192.168.178.1");
            quote("SETENV firmware_version " + oem);
            if (annex == "A") { quote("SETENV kernel_args annex=" + annex); } else { quote("SETENV kernel_args"); }
            quote("SETENV wlan_key " + wkey);
            //quote("SYST");
            //quote("TYPE I");
            //quote("MEDIA FLSH");
            if (pmtd1 == "push") try { upload(textBox1.Text, "mtd1"); }
                catch (Exception) { }
            if (pmtd23 == "clear")
            {
                try { upload("filesystem.image", "mtd3"); }
                catch (Exception) { }
                try { upload("filesystem.image", "mtd4"); }
                catch (Exception) { }
                //quote("SETENV my_ipaddress 192.168.178.1");
                //quote("SETENV firmware_version " + oem);
                //if ((annex == "B") || (annex == "A")) { quote("SETENV kernel_args annex=" + annex); }
                //quote("SETENV wlan_key " + wkey);
                quote("SETENV autoload no");
            }
            quote("REBOOT");
            close();
            this.Start.Enabled = true;
        }
        public void DoItAgain(String oem, String annex, String pmtd23, String pmtd1, String wkey, String ip)
        {
            this.Start.Enabled = false;
            Open("192.168.2.1");
            Open("192.168.2.1");
            Login("adam2", "adam2");
            quote("SETENV my_ipaddress 192.168.178.1");
            quote("SETENV firmware_version " + oem);
            if (annex == "A") { quote("SETENV kernel_args annex=A"); } else { quote("SETENV kernel_args "); }
            quote("SETENV wlan_key " + wkey);
            quote("SETENV autoload yes");
            quote("REBOOT");
            close();
            this.Start.Enabled = true;
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
            String rStr = lib.ReadResponse();
            if (lib.MessagesAvailable)
            {
                AppendTextBoxLine(lib.messages);
                Console.WriteLine(lib.messages);
            }
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
            if (File.Exists(FILE_NAME) == false)
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
            if (File.Exists(textBox1.Text) == false)
            {
                MessageBox.Show(labelKInotfound.Text, "kernel.image",
                MessageBoxButtons.OK, MessageBoxIcon.None);
                return false;
            }
            return true;
        }
        public static void List(String name)
        {
            TarArchive ta = TarArchive.CreateInputTarArchive(new
            FileStream(@name, FileMode.Open, FileAccess.Read));
            ta.ProgressMessageEvent += MyLister;
            ta.ListContents();
            ta.Close();
        }
        public static void Extract(String name)
        {
            TarArchive ta = TarArchive.CreateInputTarArchive(new
            FileStream(@name, FileMode.Open, FileAccess.Read));
            ta.ProgressMessageEvent += MyNotifier;
            ta.ExtractContents(@".");
            ta.Close();
        }
        public static void MyLister(TarArchive ta, TarEntry te, string msg)
        {
            Console.WriteLine(te.Name + " " + te.Size + " " + te.ModTime);
        }
        public static void MyNotifier(TarArchive ta, TarEntry te, string msg)
        {
            Console.WriteLine(te.Name + " extracted");
        }
        static bool Find(string allRead, string regMatch)
        {
            if (Regex.IsMatch(allRead, regMatch))
            {
                //Debug.WriteLine("found\n");
                return true;
            }
            else
            {
                //Debug.WriteLine("not found\n");
                return false;
            }
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
                    try
                    {
                        if (Directory.Exists(@".\var")) Directory.Delete(@".\var", true);
                    }
                    catch (Exception)
                    {
                    }
                    if (File.Exists(openFileDialog1.FileName))
                    {
                        textBox1.Text = this.openFileDialog1.FileName;
                        try
                        {
                            List(openFileDialog1.FileName);
                            Extract(openFileDialog1.FileName);
                        }
                        catch (Exception)
                        {
                        }

                        if (File.Exists(@".\var\tmp\kernel.image"))
                            textBox1.Text = @".\var\tmp\kernel.image";

                        if (File.Exists(@".\var\install"))
                        {
                            StreamReader installTxt = new StreamReader(@".\var\install");
                            string allRead = installTxt.ReadToEnd();//Reads the whole text file to the end
                            installTxt.Close(); //Closes the text file after it is fully read.
                            string temp = "";
                            if (Find(allRead, "AnnexB")) temp = "B";
                            if (Find(allRead, "multiannex")) temp = "Multi";
                            if (Find(allRead, "echo kernel_args annex=B")) temp = "B";
                            if (Find(allRead, "AnnexA")) temp = "A";
                            if (Find(allRead, "echo kernel_args annex=A")) temp = "A";
                            if (temp != "")
                            {
                                this.ANNEXBox.Text = temp;
                                this.ANNEXBox.BackColor = System.Drawing.Color.White;
                            }
                            else
                            {
                                this.ANNEXBox.BackColor = System.Drawing.Color.Yellow;
                            }
                            temp = "";
                            if (Find(allRead, "echo firmware_version avme ")) temp = "avme";
                            if (Find(allRead, "echo firmware_version avm ")) temp = "avm";
                            if (Find(allRead, "for i in  avm ")) temp = "avm";
                            if (Find(allRead, "for i in  avme ")) temp = "avme";
                            if (Find(allRead, "for i in  tcom ")) temp = "tcom";
                            if (Find(allRead, "for i in  1und1 ")) temp = "1und1";
                            if (Find(allRead, "for i in  freenet ")) temp = "freenet";
                            if (Find(allRead, "for i in  hansenet ")) temp = "hansenet";
                            if (temp != "")
                            {
                                this.OEMBox.Text = temp;
                                this.OEMBox.BackColor = System.Drawing.Color.White;
                            }
                            else 
                            {
                                this.OEMBox.BackColor = System.Drawing.Color.Yellow;
                            }

                            //Console.WriteLine("install file exists\n");
                        }
                        if (File.Exists(@".\var\.packages"))
                        {
                            StreamReader FreetzTxt = new StreamReader(@".\var\.packages");
                            AppendTextBoxLine(labelFreetzPackages.Text);
                            Console.WriteLine(labelFreetzPackages.Text);
                            AppendTextBoxLine("----------------------------------------------------------");
                            Console.WriteLine("----------------------------------------------------------");
                            string line;
                            // Read the file and display it line by line.
                            while ((line = FreetzTxt.ReadLine()) != null)
                            {
                                Console.WriteLine(line);
                                AppendTextBoxLine(line);
                            }
                            FreetzTxt.Close();
                            AppendTextBoxLine("");
                            AppendTextBoxLine("----------------------------------------------------------");
                            Console.WriteLine("----------------------------------------------------------");
                        }
                    }
                }
            }
        }
        #endregion
        #region Unused
        private void tB1_TextChanged(object sender, EventArgs e)
        {
        }
        private void eventLog1_EntryWritten(object sender, System.Diagnostics.EntryWrittenEventArgs e)
        {
        }
        private void progressBar1_Click(object sender, EventArgs e)
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
        private void labelGW_Click(object sender, EventArgs e)
        {
        }
        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
        }
        private void label5_Click(object sender, EventArgs e)
        {
        }
        private void label6_Click(object sender, EventArgs e)
        {
        }
        private void label6_Click_1(object sender, EventArgs e)
        {
        }
        private void label5_Click_1(object sender, EventArgs e)
        {
        }
        #endregion
        #region SwitchLanguage
        private void buttonSP_Click(object sender, EventArgs e)
        {
            if (Thread.CurrentThread.CurrentCulture.Name == "en")
                SwitchLanguage("de");
            else SwitchLanguage("en");
        }
        private void SwitchLanguage(string culture)
        {
            CultureInfo cInfo = new CultureInfo(culture);
            ComponentResourceManager resManager = new ComponentResourceManager(this.GetType());
            Point old_location = this.Location;
            resManager.ApplyResources(this, "$this", cInfo);
            //this.Location = old_location; //nur für .NET 1.1 nötig

            //Controls.Clear(); // <<=== Sauberer, aber ggf. mehr Flackern (es sind dann keine Apply* Methoden mehr nötig)
            ApplyRessourcesAllControls(this, resManager, cInfo); // <<=== wenn "Controls.Clear" aktiviert, dann auskommentieren.

            Thread.CurrentThread.CurrentCulture = new CultureInfo(culture);
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(culture);

            //InitializeComponent(); // <<=== wenn "Controls.Clear" aktiviert, dann hier auch.
            //Form1_Load(this, EventArgs.Empty);
        }

        private void ApplyRessourcesAllControls(Control control,
          ComponentResourceManager resManager, CultureInfo cInfo)
        {
            foreach (Control ctl in ((Control)control).Controls)
            {
                if (ctl.Controls.Count > 0) ApplyRessourcesAllControls(ctl, resManager, cInfo);
                resManager.ApplyResources(ctl, ctl.Name, cInfo); // folgendes nur für .NET 2.0
                if (ctl is ToolStrip) ApplyRessourcesAllToolStrips((ToolStrip)ctl, resManager, cInfo);
            }
            foreach (Component cmp in this.components.Components) // z.B. ContextMenu
                if (cmp is ToolStrip)
                    ApplyRessourcesAllToolStrips((ToolStrip)cmp, resManager, cInfo);
        }

        private void ApplyRessourcesAllToolStrips(ToolStrip ts, ComponentResourceManager resManager, CultureInfo cInfo)
        {
            foreach (ToolStripItem tsi in ts.Items)
            {
                ToolStripDropDownItem tdi = tsi as ToolStripDropDownItem;
                if (tdi != null) ApplyAllToolStripItems(tdi, resManager, cInfo);
                ToolStripComboBox tdc = tsi as ToolStripComboBox;
                if (tdc != null) ApplyAllToolStripItems(tdc, resManager, cInfo);
                resManager.ApplyResources(tsi, tsi.Name, cInfo);
            }
            resManager.ApplyResources(ts, ts.Name, cInfo);
        }

        private void ApplyAllToolStripItems(ToolStripItem tsi, ComponentResourceManager resManager, CultureInfo cInfo)
        {
            ToolStripDropDownItem tdi = tsi as ToolStripDropDownItem;
            if (tdi != null)
            {
                foreach (ToolStripItem tsi2 in tdi.DropDownItems)
                {
                    ToolStripDropDownItem tdi2 = tsi2 as ToolStripDropDownItem;
                    if (tdi2 != null && tdi2.DropDownItems.Count > 0)
                        ApplyAllToolStripItems(tdi2, resManager, cInfo);
                    resManager.ApplyResources(tsi2, tsi2.Name, cInfo);
                }
            }
            ToolStripComboBox tdc = tsi as ToolStripComboBox;
            if (tdc != null)
                for (int i = 0; i < tdc.Items.Count; i++)
                {
                    tdc.Items[i] = resManager.GetString(tdc.Name + ".Items" +
                      ((i == 0) ? "" : i.ToString()), cInfo);
                }
            resManager.ApplyResources(tsi, tsi.Name, cInfo);
        }
        #endregion
    }
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
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.Run(new Form1());
        }
    }
}


