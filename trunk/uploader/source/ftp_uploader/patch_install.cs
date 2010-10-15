/* Johann Pascher (johann.pascher@gmail.com)
*/
#region Public using def
using System.Xml;
using System;
using System.ComponentModel;
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
/*using System.Net.NetworkInformation;
using System.Net;
using System.Net.Sockets;
*/
using System.Collections;
using ICSharpCode.SharpZipLib.Tar;

#endregion 
namespace patch
{
    public class Form1 : Form
    {
        #region Public Variables
        public int count;
        #endregion
        #region Private Variables

        private TextBox OEMBox;
        private Label label1;
        private TextBox textBox1;
        private Button Fsel;
        private OpenFileDialog openFileDialog1;
        private Label labelGW;
        #endregion
           public Form1()
        {
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.OEMBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.Fsel = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.labelGW = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // OEMBox
            // 
            this.OEMBox.Enabled = false;
            this.OEMBox.Location = new System.Drawing.Point(110, 135);
            this.OEMBox.MaxLength = 5;
            this.OEMBox.Name = "OEMBox";
            this.OEMBox.Size = new System.Drawing.Size(100, 20);
            this.OEMBox.TabIndex = 14;
            this.OEMBox.Text = "avm";
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
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(10, 16);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(606, 20);
            this.textBox1.TabIndex = 23;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged_1);
            // 
            // Fsel
            // 
            this.Fsel.Location = new System.Drawing.Point(10, 42);
            this.Fsel.Name = "Fsel";
            this.Fsel.Size = new System.Drawing.Size(200, 31);
            this.Fsel.TabIndex = 24;
            this.Fsel.Text = "Select Firmware";
            this.Fsel.UseVisualStyleBackColor = true;
            this.Fsel.Click += new System.EventHandler(this.Fsel_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "kernel.image";
            this.openFileDialog1.Title = "Select Firmware";
            // 
            // labelGW
            // 
            this.labelGW.AutoSize = true;
            this.labelGW.Location = new System.Drawing.Point(12, 173);
            this.labelGW.Name = "labelGW";
            this.labelGW.Size = new System.Drawing.Size(198, 117);
            this.labelGW.TabIndex = 28;
            this.labelGW.Text = resources.GetString("labelGW.Text");
            this.labelGW.Click += new System.EventHandler(this.labelGW_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.ClientSize = new System.Drawing.Size(627, 333);
            this.Controls.Add(this.labelGW);
            this.Controls.Add(this.Fsel);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.OEMBox);
            this.Name = "Form1";
            this.Text = "Firmware Uploader";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        #endregion
        /// <summary>
        /// Append a line to the TextBox, and make sure the first and last
        /// appends don't show extra space.
        /// </summary>
        /// <param name="myStr">The string you want to show in the TextBox.</param>

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

                        if (File.Exists(@".\var\tmp\kernel.image"))
                            textBox1.Text = @".\var\tmp\kernel.image";

                        if (File.Exists(@".\var\install"))
                        {
                            string Temp_HWID = "145";
                            string ANNEX="B";
                            //StreamReader installTxt = new StreamReader(File.OpenRead("));
                            StreamReader installTxt = new StreamReader(@".\var\install");
                            string allRead = installTxt.ReadToEnd();//Reads the whole text file to the end
                            installTxt.Close(); //Closes the text file after it is fully read.
                            if (Find(allRead, "AnnexB")) ANNEX = "B";
                            if (Find(allRead, "echo kernel_args annex=B")) ANNEX = "B";
                            if (Find(allRead, "AnnexA")) ANNEX = "A";
                            if (Find(allRead, "echo kernel_args annex=A")) ANNEX = "A";
                            if (Find(allRead, "echo firmware_version avme ")) this.OEMBox.Text = "avme";
                            if (Find(allRead, "echo firmware_version avm ")) this.OEMBox.Text = "avm";
                            if (Find(allRead, "for i in  avm ")) this.OEMBox.Text = "avm";
                            if (Find(allRead, "for i in  avme ")) this.OEMBox.Text = "avme";
                            if (Find(allRead, "for i in  tcom ")) this.OEMBox.Text = "tcom";
                            if (Find(allRead, "for i in  1und1 ")) this.OEMBox.Text = "1und1";
                            if (Find(allRead, "7570"))
                            {
                                Temp_HWID = "146";
                            }
                            else
                            {

                            }
                            //Console.WriteLine("install file exists\n");
                            //--> patch install
                            string strTest = allRead;
                            if ((Temp_HWID == "135") || (Temp_HWID == "146") || (Temp_HWID == "153")) Temp_HWID = "135 | 146 | 153";
                            StringBuilder strBuilder = new StringBuilder(strTest);
                            int nIndexE = strTest.IndexOf("kernel_start=");
                            int nIndex = strTest.IndexOf("if [ -z \"${ANNEX}\" ] ; then echo ANNEX=${ANNEX} not supported ; exit $INSTALL_WRONG_HARDWARE ; fi");
                            strBuilder.Remove(nIndex, nIndexE - nIndex);
                            string InsertStr = "##### check hardware #####\necho testing acceptance for device ...\n/etc/version\nhwrev=`echo $(grep HWRevision < ${CONFIG_ENVIRONMENT_PATH}/environment | tr -d [:alpha:],[:blank:])`\nhwrev=${hwrev%%.*}\necho \"HWRevision: $hwrev\"\ncase \"$hwrev\" in\n" + Temp_HWID + " | \"\" ) korrekt_version=1 ;;\nesac\n";
                            strBuilder.Insert(nIndex, InsertStr);
                            string AddStr="\necho \"echo kernel_args annex= " + ANNEX + " > \\/proc\\/sys\\/urlader\\/environment\\\" >>\\/var\\/post_install \necho \"echo " + ANNEX + " > \\/proc\\/sys\\/urlader\\/annex\\\" >>\\/var\\/post_install \necho \"echo annex " + ANNEX + " > \\/proc\\/sys\\/urlader\\/environment\\\" >>\\/var\\/post_install \necho \"echo annex=" + this.OEMBox.Text + " > \\/proc\\/sys\\/urlader\\/firmware_version\\\" >>\\/var\\/post_install \necho \"echo firmware_version " + this.OEMBox.Text + " > \\/proc\\/sys\\/urlader\\/environment\\\" >>\\/var\\/post_install \necho \"echo " + this.OEMBox.Text + " > \\/proc\\/sys\\/urlader\\/annex\\\" >>\\/var\\/post_install \necho \"echo annex " + ANNEX + " > \\/proc\\/sys\\/urlader\\/environment\\\" >>\\/var\\/post_install\n";
                            strBuilder.Replace("# unmittelbar vor dem Flashen den Watchdog ausschalten", AddStr + "# unmittelbar vor dem Flashen den Watchdog ausschalten");
                            strBuilder.Replace("korrekt_version=0", "korrekt_version=1");
                            strBuilder.Replace("force_update=n","force_update=y");
                            Console.WriteLine(strBuilder.ToString());

                            //File.CreateText
                            try
                            {
                                using (StreamWriter writer = File.CreateText(@".\var\install1"))
                                {
                                    //Hier den Dateiinhalt schreiben
                                    writer.WriteLine(strBuilder.ToString());
                                }
                            }
                            catch
                            {
                                //Hier definieren, wie sich im Fehlerfall verhalten werden soll.
                            }
                            //<--
                            //--> write tar
                            string fileName = openFileDialog1.FileName + ".tar";
                            Stream outStream;
                            outStream = File.OpenWrite(fileName);
                            outStream = new TarOutputStream(outStream);
                            TarArchive archive = TarArchive.CreateOutputTarArchive(outStream);           
                            TarEntry entry = TarEntry.CreateEntryFromFile("./var");
                            archive.WriteEntry(entry, true);
                            if (archive != null) { archive.Close(); }
                            outStream.Close();
                            //<--
                        }
                        if (File.Exists(@".\var\.packages"))
                        {
                            StreamReader FreetzTxt = new StreamReader(@".\var\.packages");
                            Console.WriteLine("Firmware is a Freetz Firmware with the following Packages:");
                            Console.WriteLine("----------------------------------------------------------");
                            string line;
                            // Read the file and display it line by line.
                            while ((line = FreetzTxt.ReadLine()) != null)
                            {
                                Console.WriteLine(line);
                            }
                            FreetzTxt.Close();
                            Console.WriteLine("----------------------------------------------------------");
                        }
                    }
                }
            }
        }

        private bool Find(string allRead, string p)
        {
            throw new NotImplementedException();
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
        #endregion

        private void labelGW_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
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


