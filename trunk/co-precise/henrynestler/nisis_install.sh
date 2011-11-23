#!/bin/bash
#apt-get install scons 
#####
#apt-get remove --purge scons
#sleep 10
echo "----------------------------------------------------"
echo "Installs: nsis, zlib, scons, python, and g++"
echo "----------------------------------------------------"

wget --output-document="nsis-2.42.zip" "http://kent.dl.sourceforge.net/sourceforge/nsis/nsis-2.42.zip"
wget --output-document="nsis-2.42-src.tar.bz2" "http://kent.dl.sourceforge.net/sourceforge/nsis/nsis-2.42-src.tar.bz2"
mkdir -p /usr/local/nsis
mv nsis-2.42-src.tar.bz2 /usr/local/nsis/
mv nsis-2.42.zip /usr/local/nsis/
cd /usr/local/nsis
tar -jxvf nsis-2.42-src.tar.bz2
unzip nsis-2.42.zip
sudo apt-get install p7zip-full
sudo apt-get install build-essential g++
##sudo apt-get install libcompress-zlib-perl
##sudo apt-get install libreadline5-dev
sudo apt-get install python
echo 'print "Python ist installiert"' | python
wget --output-document="scons-1.2.0.tar.gz" "http://downloads.sourceforge.net/scons/scons-1.2.0.tar.gz?modtime=1229849221&big_mirror=0"
tar -zxf scons-1.2.0.tar.gz
cd scons-1.2.0
python setup.py install
cd ..
#####apt-get install scons 
#####apt-get remove --purge scons

cd /usr/local/nsis/nsis-2.42-src
scons SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all NSIS_CONFIG_CONST_DATA=no PREFIX=/usr/local/nsis/nsis-2.42 install-compiler
cp /usr/local/nsis/nsis-2.42/bin/* /usr/bin

#
mkdir -p /usr/local/nsis/nsis-2.42/share
cd /usr/local/nsis/nsis-2.42/share
ln -s /usr/local/nsis/nsis-2.42 nsis
#remove source
rm /usr/local/nsis/nsis-2.42-src.tar.bz2
rm /usr/local/nsis/nsis-2.42.zip 
rm scons-1.2.0.tar.gz
rm -dr scons-1.2.0
exit


Docu:

Step 1 u. 2.) After downloading the two packages, I created a directory named 'nsis' in /usr/local.   
You can create this diretcory wherever you want, as long as the users who will need it have permissions to access it.  
Move the two packages you have just downloaded into the directory 'nsis' that you just have created.  The commands to do this are below. 

                    In the /usr/local directory, issue a 'mkdir nsis' command.

                    Move (or copy) the files into /usr/local/nsis with these commands (execute these commands from inside the directory where you downloaded the packages) : 

                                   a.   mv nsis-2.34-src.tar.bz2 /usr/local/nsis/

                                   b.   mv nsis-2.34.zip /usr/local/nsis/

Step 3.) After moving the files into /usr/local/nsis , extract the two packages.  The commands I used are below:

                                 a.    cd /usr/local/nsis (if you are not there already)

                                 b.    tar -jxvf nsis-2.34-src.tar.bz2

                                 c.    unzip nsis-2.34.zip

Step 4.) After you have extracted the two packages, you will have two directories in /usr/local/nsis.  
With the versions I had downloaded above, the two directories were nsis-2.34-src and nsis-2.34.   
The nsis-2.34-src diretory contains the source code for the NSIS package.  
You will compile the Installer from inside this folder.  
The nsis-2.34 directory contains a pre-compiled package of the software for Windows.   
Inside the nsis-2.34-src directory will be an INSTALL file.  
Read this file!  
It contains information to assist you with your installation in Linux.  
Your system will need to meet the requirements section of the Install file.  
Basically, you just need to make sure your Linux system has the three software tools needed to compile and run NSIS.

                   The three tools you need are:

                           a. Python version 1.6 and above

                           b. Scons version 0.96.93 or above.  (this is a program similiar to 'make').   
			   You can install your distro's version or install from the source located at: http://www.scons.org.

                           c. A 'C' Compiler (gcc and g++ packages)
			   
Depending on your Linux installtion, these programs may already be installed.  
If not, they are fairly standard and can easily be installed from your distro's package installation program (apt-get, yum, etc.).   
My box did not have the 'scons' program, so I needed to install the RPM package for this program.    
If you need help finding and installing the packages, a simple Google query on the program name and your distro name will point you in the right direction.

Step 5.)  After meeting the requirements section, you now need to build the NSIS compiler for Linux.  
The program you will be building is called 'makensis'.  This is what will actually build the Installer Package on a Linux box.  
I chose not to use a cross-compiler for this installation, 
since I only needed to create Installer packages for Windows systems.  The process to create this 'makensis' program is described below:

                              a.) Inside the nsis-2.34-src directory isssue the following command (also mentioned in the INSTALL file): 

scons SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all NSIS_CONFIG_CONST_DATA=no PREFIX=/path/to/your/extracted/zip/directory install-compiler
So for my setup the command was:

scons SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all NSIS_CONFIG_CONST_DATA=no PREFIX=/usr/local/nsis/nsis-2.34 install-compiler

 The option "install-compiler" at the end of the command is an actual option you must use!  It is not part of the PREFIX parameter.

This command will build the 'makensis' program and place it into the /usr/local/nsis/nsis-2.34 directory 
(or whatever the path is to the directory that you extracted your zip file to; 
it also may place the 'makensis' file in the 'bin' dir within your PREFIX).

NOTE:  If you issue this command and while it is running you receive 'sh: o: command not found' errors, 
this means that you do not have the C compiler packages installed (gcc, g++). 

(For my system, I needed to install the rpm packages for g++ and libstdc++.  G++ can also be the gcc-c++ RPM package on your system.). 

Step 6.) After the makensis program is built, you can begin createing installer packages for Windows inside a Linux box.  
You will need to create Installer scripts and have the makensis program execute them to create the installer packages.   
For example, if you have a script named 'software_install.nsi' you would create the package by issuing the following 
command inside the /usr/local/nsis/nsis-2.34 directory: 
                                 ./makensis software_install.nsi
 
UPDATE: After Installing the compiler on a CentOS 5 system, when I ran 'makensis' the first time I received this error message:
Error: opening stub "/usr/local/nsis/nsis-2.34/share/nsis/Stubs/zlib
Error initalizing CEXEBuild: error setting default stub

To correct this problem, create a symlink.  From inside of the /usr/local/nsis/nsis-2.34 directory, first 'mkdir share'.  
The inside of the 'share' directory issue: 'ln -s /usr/local/nsis/nsis-2.34 nsis' .  This will create the symlink back to 
the folder where it can then find the 'Stubs' directory (which lies in the top level of the nsis-2.34 directory).

Step 7.) At this point, you have successfully installed the NSIS software on Linux and are able to create Windows Installer packages on a Linux box.  
The EXE packages will reside on a Linux box and can be downlaoed via a Website, FTP, or any other method that you choose to provide.  
I set up a script that was executed by a cron job to build packages automatically every night and placed them in a deployment directory.  
You may want to create symlinks to the makensis program, or include the /usr/local/nsis/nsis-2.34 directory in your PATH to make things easier for you.  
Remember, the installer scripts that you create for use on Linux should contain absolute paths to the source files needed to create the package on the Linux box, 
while the destination paths during install are Windows based.  Good luck. 

Refer to the NSIS help file for a comprehensive description of how the program works and for links to scripts and tools.   
I use the Eclipse Developmnt Environment and downloded the Eclipse NSIS plug-in to help in creating installer scripts.  
More information on this plugin is available at http://nsis.sourceforge.net/Category:Development_Environments .  
There also is a ton of information about how to use NSIS and good examples on the software's website (shown at the top of this article).        