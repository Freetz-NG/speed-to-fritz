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
    partial class pseudo1
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(pseudo1));
            this.Fsel = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.HWRNlabel = new System.Windows.Forms.Label();
            this.HWRNBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.oemlabel = new System.Windows.Forms.Label();
            this.ANNEXBox = new System.Windows.Forms.TextBox();
            this.OEMBox = new System.Windows.Forms.TextBox();
            this.annexlebel = new System.Windows.Forms.Label();
            this.labelFilename = new System.Windows.Forms.Label();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.linkLabel1 = new System.Windows.Forms.LinkLabel();
            this.VERSIONBox = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // Fsel
            // 
            this.Fsel.BackColor = System.Drawing.Color.LimeGreen;
            this.Fsel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Fsel.ForeColor = System.Drawing.Color.DarkSlateBlue;
            this.Fsel.Location = new System.Drawing.Point(26, 218);
            this.Fsel.Name = "Fsel";
            this.Fsel.Size = new System.Drawing.Size(416, 33);
            this.Fsel.TabIndex = 26;
            this.Fsel.Text = "Firmware auswählen - > und patchen";
            this.Fsel.UseVisualStyleBackColor = false;
            this.Fsel.Click += new System.EventHandler(this.Fsel_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(26, 276);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(416, 36);
            this.textBox1.TabIndex = 25;
            this.textBox1.Text = "FRITZ.Box_Fon_WLAN_7570_vDSL.en-de-fr.75.04.82.image";
            this.toolTip1.SetToolTip(this.textBox1, "Hier kann nichts eingetragen werden, klicken Sie die Taste Firmware Auswählen");
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // HWRNlabel
            // 
            this.HWRNlabel.AutoSize = true;
            this.HWRNlabel.Location = new System.Drawing.Point(26, 56);
            this.HWRNlabel.Name = "HWRNlabel";
            this.HWRNlabel.Size = new System.Drawing.Size(131, 13);
            this.HWRNlabel.TabIndex = 28;
            this.HWRNlabel.Text = "Hardwarerevisionsnummer";
            // 
            // HWRNBox
            // 
            this.HWRNBox.Location = new System.Drawing.Point(178, 51);
            this.HWRNBox.MaxLength = 5;
            this.HWRNBox.Name = "HWRNBox";
            this.HWRNBox.Size = new System.Drawing.Size(264, 20);
            this.HWRNBox.TabIndex = 27;
            this.HWRNBox.Text = "135 | 146 | 153 | # anpassen!";
            this.toolTip1.SetToolTip(this.HWRNBox, "Es dürfen mehere Nummern eingeragen werden die mit  | getennt werden müssen");
            this.HWRNBox.TextChanged += new System.EventHandler(this.OEMBox_TextChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(55, 74);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(361, 117);
            this.label1.TabIndex = 29;
            this.label1.Text = resources.GetString("label1.Text");
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            this.openFileDialog1.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog1_FileOk);
            // 
            // oemlabel
            // 
            this.oemlabel.AutoSize = true;
            this.oemlabel.Location = new System.Drawing.Point(26, 31);
            this.oemlabel.Name = "oemlabel";
            this.oemlabel.Size = new System.Drawing.Size(131, 13);
            this.oemlabel.TabIndex = 34;
            this.oemlabel.Text = "Ermittelter OEM (Branding)";
            // 
            // ANNEXBox
            // 
            this.ANNEXBox.Enabled = false;
            this.ANNEXBox.Location = new System.Drawing.Point(380, 24);
            this.ANNEXBox.MaxLength = 5;
            this.ANNEXBox.Name = "ANNEXBox";
            this.ANNEXBox.Size = new System.Drawing.Size(62, 20);
            this.ANNEXBox.TabIndex = 32;
            // 
            // OEMBox
            // 
            this.OEMBox.Enabled = false;
            this.OEMBox.Location = new System.Drawing.Point(178, 24);
            this.OEMBox.MaxLength = 5;
            this.OEMBox.Name = "OEMBox";
            this.OEMBox.Size = new System.Drawing.Size(69, 20);
            this.OEMBox.TabIndex = 35;
            this.OEMBox.TextChanged += new System.EventHandler(this.textBox2_TextChanged);
            // 
            // annexlebel
            // 
            this.annexlebel.AutoSize = true;
            this.annexlebel.Location = new System.Drawing.Point(266, 31);
            this.annexlebel.Name = "annexlebel";
            this.annexlebel.Size = new System.Drawing.Size(93, 13);
            this.annexlebel.TabIndex = 36;
            this.annexlebel.Text = "Ermittelter ANNEX";
            // 
            // labelFilename
            // 
            this.labelFilename.AutoSize = true;
            this.labelFilename.Location = new System.Drawing.Point(26, 256);
            this.labelFilename.Name = "labelFilename";
            this.labelFilename.Size = new System.Drawing.Size(49, 13);
            this.labelFilename.TabIndex = 37;
            this.labelFilename.Text = "Firmware";
            // 
            // toolTip1
            // 
            this.toolTip1.Popup += new System.Windows.Forms.PopupEventHandler(this.toolTip1_Popup);
            // 
            // linkLabel1
            // 
            this.linkLabel1.AutoSize = true;
            this.linkLabel1.Location = new System.Drawing.Point(55, 191);
            this.linkLabel1.Name = "linkLabel1";
            this.linkLabel1.Size = new System.Drawing.Size(346, 13);
            this.linkLabel1.TabIndex = 38;
            this.linkLabel1.TabStop = true;
            this.linkLabel1.Text = "http://www.ip-phone-forum.de/showpost.php?p=1146628&postcount=30";
            // 
            // VERSIONBox
            // 
            this.VERSIONBox.Enabled = false;
            this.VERSIONBox.Location = new System.Drawing.Point(370, 253);
            this.VERSIONBox.MaxLength = 5;
            this.VERSIONBox.Name = "VERSIONBox";
            this.VERSIONBox.Size = new System.Drawing.Size(72, 20);
            this.VERSIONBox.TabIndex = 39;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(220, 256);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(129, 13);
            this.label2.TabIndex = 40;
            this.label2.Text = "Ermittelte Firmwareversion";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(471, 333);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.VERSIONBox);
            this.Controls.Add(this.linkLabel1);
            this.Controls.Add(this.labelFilename);
            this.Controls.Add(this.annexlebel);
            this.Controls.Add(this.OEMBox);
            this.Controls.Add(this.oemlabel);
            this.Controls.Add(this.ANNEXBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.HWRNlabel);
            this.Controls.Add(this.HWRNBox);
            this.Controls.Add(this.Fsel);
            this.Controls.Add(this.textBox1);
            this.Name = "Form1";
            this.Text = "Patch Hardwarerevisionsnummer V1.1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Fsel;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label HWRNlabel;
        private System.Windows.Forms.TextBox HWRNBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Label oemlabel;
        private System.Windows.Forms.TextBox ANNEXBox;
        #region File Select
        protected static char[] Versioni = new char[8];
        private void Fsel_Click(object sender, EventArgs e)
        {
            this.openFileDialog1.DefaultExt = ".image"; // Default file extension
            this.openFileDialog1.Filter = "Firmware Files (.image)|*.image|All files (*.*)|*.*"; // Filter files by extension

            openFileDialog1.FilterIndex = 2;
            openFileDialog1.RestoreDirectory = true;
            openFileDialog1.FileName = textBox1.Text;
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
                        textBox1.Text = this.openFileDialog1.FileName;
                    try
                    {
                        List(openFileDialog1.FileName);
                        Extract(openFileDialog1.FileName);
                    }
                        catch (Exception)
                    {
                    }
                    if (File.Exists(@".\post_install"))
                    try
                    {
                       File.Copy(@".\post_install", @".\var\post_install");
                    }
                        catch (Exception)
                    {
                    }
                    {
                       if (File.Exists(@".\var\install"))
                        {
                            string Temp_HWID = "135";
                            //this.HWRNBox.Text = "135 | 146 | 153 | # anpassen!";
                            string ANNEX = "B";
                            this.ANNEXBox.Text = "B";
                            this.OEMBox.Text = "avm";
                            //StreamReader installTxt = new StreamReader(File.OpenRead("));
                            StreamReader installTxt = new StreamReader(@".\var\install");
                            string allRead = installTxt.ReadToEnd();//Reads the whole text file to the end
                            installTxt.Close(); //Closes the text file after it is fully read.
                            if (Find(allRead, "AnnexB")) this.ANNEXBox.Text = "B";
                            if (Find(allRead, "multiannex")) this.ANNEXBox.Text = "multi";                          
                            if (Find(allRead, "echo kernel_args annex=B")) this.ANNEXBox.Text = "B";
                            if (Find(allRead, "AnnexA")) this.ANNEXBox.Text = "A";
                            if (Find(allRead, "echo kernel_args annex=A")) this.ANNEXBox.Text = "A";
                            if (Find(allRead, "echo firmware_version avme ")) this.OEMBox.Text = "avme";
                            if (Find(allRead, "echo firmware_version avm ")) this.OEMBox.Text = "avm";
                            if (Find(allRead, "for i in  avm ")) this.OEMBox.Text = "avm";
                            if (Find(allRead, "for i in  avme ")) this.OEMBox.Text = "avme";
                            if (Find(allRead, "for i in  tcom ")) this.OEMBox.Text = "tcom";
                            if (Find(allRead, "for i in  1und1 ")) this.OEMBox.Text = "1und1";
                            if (Find(allRead, "for i in  freenet ")) this.OEMBox.Text = "freenet";
                            if (Find(allRead, "for i in  hansenet ")) this.OEMBox.Text = "hansenet";
                            if (Find(allRead, "7570")) this.HWRNBox.Text = "135 | 146 | 153";
                           //# Versioninfo:	75.04.82
                           //protected static char[] Versioninfo = new char[8];

                            Temp_HWID = this.HWRNBox.Text;

                            if (this.ANNEXBox.Text == "multi") ANNEX = "B";
                            else ANNEX = this.ANNEXBox.Text;
                            //Console.WriteLine("install file exists\n");
                            //--> patch install
                            string KARGS = "";
                            if (this.ANNEXBox.Text == "A") KARGS = "annex=A";
                            string strTest = allRead;
                            StringBuilder strBuilder = new StringBuilder(strTest);
                            int nIndexX = strTest.IndexOf("# Versioninfo:	");
                            strBuilder.CopyTo(nIndexX + 15, Versioni, 0, 8);
                            string Firmw_version = new string(Versioni);
                            this.VERSIONBox.Text = Firmw_version;
                            int nIndexE = strTest.IndexOf("kernel_start=");
                            int nIndex = strTest.IndexOf("if [ -z \"${ANNEX}\" ] ; then echo ANNEX=${ANNEX} not supported ; exit $INSTALL_WRONG_HARDWARE ; fi");
                            if ((nIndexE > nIndex) && (nIndexE > 0) && (nIndex > 0)) strBuilder.Remove(nIndex, nIndexE - nIndex);
                            string InsertStr = "##### check hardware #####\necho testing acceptance for device ...\nhwrev=`echo $(grep HWRevision < ${CONFIG_ENVIRONMENT_PATH}/environment | tr -d [:alpha:],[:blank:])`\nhwrev=${hwrev%%.*}\necho \"HWRevision: $hwrev\"\ncase \"$hwrev\" in\n" + Temp_HWID + " | \"\" ) korrekt_version=1 ;;\nesac\n";
                            strBuilder.Replace("export ANNEX=`cat ${CONFIG_ENVIRONMENT_PATH}/annex`", InsertStr);
                            string AddStr = "\necho \"echo kernel_args " + KARGS + " > /proc/sys/urlader/environment\" >>/var/post_install \necho \"echo " + ANNEX + " > /proc/sys/urlader/annex\" >>/var/post_install \necho \"echo annex " + ANNEX + " > /proc/sys/urlader/environment\" >>/var/post_install\necho \"echo " + this.OEMBox.Text + " > /proc/sys/urlader/firmware_version\" >>/var/post_install \necho \"echo firmware_version " + this.OEMBox.Text + " > /proc/sys/urlader/environment\" >>/var/post_install \necho \"echo my_ipaddress 192.168.178.1 > /proc/sys/urlader/environment\" >>/var/post_install\necho \"echo firmware_info " + Firmw_version + " > /proc/sys/urlader/environment\" >>/var/post_install \n";
                            strBuilder.Replace("# unmittelbar vor dem Flashen den Watchdog ausschalten", AddStr + "# unmittelbar vor dem Flashen den Watchdog ausschalten");
                           //strBuilder.Replace("korrekt_version=0", "korrekt_version=1");
                            strBuilder.Replace("exit $INSTALL_FIRMWARE_VERSION", "## exit $INSTALL_FIRMWARE_VERSION");
                            strBuilder.Replace("force_update=n", "force_update=y");
                            //File.CreateText
                            try
                            {
                                using (StreamWriter writer = File.CreateText(@".\var\install"))
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
                            string fileName = openFileDialog1.FileName + ".image";
                            Stream outStream;
                            outStream = File.OpenWrite(fileName);
                            outStream = new TarOutputStream(outStream);
                            TarArchive archive = TarArchive.CreateOutputTarArchive(outStream);
                            TarEntry entry = TarEntry.CreateEntryFromFile("./var");
                            archive.WriteEntry(entry, true);
                            if (archive != null) { archive.Close(); }
                            outStream.Close();
                            textBox1.Text = this.openFileDialog1.FileName + ".image";
                            //<--
                        }
                    }
                }
            }
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
            //Console.WriteLine(te.Name + " " + te.Size + " " + te.ModTime);
        }
        public static void MyNotifier(TarArchive ta, TarEntry te, string msg)
        {
            //Console.WriteLine(te.Name + " extracted");
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

        #endregion

        private TextBox OEMBox;
        private Label annexlebel;
        private Label labelFilename;
        private ToolTip toolTip1;
        private LinkLabel linkLabel1;
        private TextBox VERSIONBox;
        private Label label2;

    }
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.Run(new pseudo1());
        }
    }
}

